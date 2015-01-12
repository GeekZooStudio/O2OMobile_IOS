//
//       _/_/_/                      _/            _/_/_/_/_/
//    _/          _/_/      _/_/    _/  _/              _/      _/_/      _/_/
//   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/              _/      _/    _/  _/    _/
//  _/    _/  _/        _/        _/  _/          _/        _/    _/  _/    _/
//   _/_/_/    _/_/_/    _/_/_/  _/    _/      _/_/_/_/_/    _/_/      _/_/
//
//
//  Copyright (c) 2015-2016, Geek Zoo Studio
//  http://www.geek-zoo.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "MessageListModel.h"

#pragma mark -

#undef	PAGE_SIZE
#define PAGE_SIZE	(10)

#pragma mark -

DEF_EXTERNAL( MessageListModel, messageListModel );

#pragma mark -

@implementation MessageListModel

DEF_SINGLETON( MessageListModel )

DEF_SIGNAL( UPDATING )
DEF_SIGNAL( UPDATED )
DEF_SIGNAL( READING )
DEF_SIGNAL( READED )

DEF_NOTIFICATION( UNREAD_UPDATE )

@synthesize unreadCount = _unreadCount;
@synthesize messages = _messages;

- (void)load
{
	self.messages = [NSMutableArray array];
	self.more = YES;
	
	[self loadCache];
}

- (void)unload
{
	[self.messages removeAllObjects];
	self.messages = nil;
}

#pragma mark -

- (NSString *)cacheKey
{
	NSNumber * userID = bee.ext.userModel.user.id ? bee.ext.userModel.user.id : @0;
	
	return [NSString stringWithFormat:@"MessageListModel-%@", userID];
}

- (void)loadCache
{
	NSData * data = bee.system.fileCache[self.cacheKey];
	if ( data )
	{
		[self.messages removeAllObjects];
		[self.messages addObjectsFromArray:[MESSAGE objectFromAny:data]];
		
		self.loaded = (self.messages.count) ? YES : NO;
	}
    
    self.unreadCount = [[self userDefaultsRead:@"MessagesUnreadCount"] integerValue];
}

- (void)saveCache
{
	if ( self.messages && self.messages.count )
	{
		bee.system.fileCache[self.cacheKey] = [self.messages objectToData];
	}
    
    if ( self.unreadCount )
    {
        [self userDefaultsWrite:@(self.unreadCount) forKey:@"MessagesUnreadCount"];
    }
}

- (void)clearCache
{
	bee.system.fileCache[self.cacheKey] = nil;

	[self clear];
}

#pragma mark -

- (void)clear
{
	[self.messages removeAllObjects];
	self.unreadCount = 0;
	self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
	[API_MESSAGE_LIST cancel:self];

	API_MESSAGE_LIST * api = [API_MESSAGE_LIST apiWithResponder:self];

	@weakify(api);

	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;

	api.req.by_id = nil;
	api.req.by_no = @(1);
	api.req.count = @(PAGE_SIZE);

	api.whenUpdate = ^
	{
		@normalize(api);

		if ( api.sending )
		{
			[self sendUISignal:self.RELOADING];
		}
		else
		{
			if ( api.succeed && api.resp.succeed.boolValue )
			{
				[self.messages removeAllObjects];
                
                [self.messages addObjectsFromArray:api.resp.messages];
				
//				self.unreadCount = 0;
				self.more = api.resp.more.boolValue;
				self.loaded = YES;
			}

			[self sendUISignal:self.RELOADED];
			[self reload];
		}
	};
	
	[api send];
}

- (void)nextPage
{
	if ( self.messages.count < PAGE_SIZE )
		return;
	
	if ( NO == self.more )
		return;

	[API_MESSAGE_LIST cancel:self];
	
	API_MESSAGE_LIST * api = [API_MESSAGE_LIST apiWithResponder:self];
	
	@weakify(api);

	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;

	api.req.by_id = nil; 
	api.req.by_no = @(1 + (self.messages.count / PAGE_SIZE));
	api.req.count = @(PAGE_SIZE);
	
	api.whenUpdate = ^
	{
		@normalize(api);

		if ( api.sending )
		{
			[self sendUISignal:self.RELOADING];
		}
		else
		{
			if ( api.succeed && api.resp.succeed.boolValue )
			{
				[self.messages addObjectsFromArray:api.resp.messages];
				
//				self.unreadCount = 0;
				self.loaded = (self.messages.count) ? YES : NO;
				self.more = api.resp.more.boolValue;
			}
			
			[self sendUISignal:self.RELOADED];
			[self reload];
		}
	};
	
	[api send];
}

- (void)reload
{
	if ( NO == [UserModel online] )
		return;
	
	[API_MESSAGE_UNREAD_COUNT cancel];
	
	API_MESSAGE_UNREAD_COUNT * api = [API_MESSAGE_UNREAD_COUNT apiWithResponder:self];
	
	@weakify(api);

	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;

	api.whenUpdate = ^
	{
		@normalize(api);

		if ( api.sending )
		{
			[self sendUISignal:self.UPDATING];
		}
		else
		{
			if ( api.succeed && api.resp.succeed.boolValue )
			{
//				if ( NO == [api.req.message isEqualToNumber:@(-1)] )
				{
					self.unreadCount = api.resp.unread.unsignedIntegerValue;
				}
			}

			[self sendUISignal:self.UPDATED];
			[self postNotification:self.UNREAD_UPDATE];
		}
	};
	
	[api send];
}

- (void)readMessage:(NSNumber *)messageId
{
    [API_MESSAGE_READ cancel];
	
	API_MESSAGE_READ * api = [API_MESSAGE_READ apiWithResponder:self];
	
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;
    api.req.message = messageId;
    
	api.whenUpdate = ^
	{
		@normalize(api);
        
		if ( api.sending )
		{
            [self sendUISignal:self.READING];
		}
		else
		{
			if ( api.succeed && api.resp.succeed.boolValue )
			{
				for ( MESSAGE * message in self.messages )
				{
					if ( [message.id isEqualToNumber:messageId] )
					{
						message.is_readed = @(YES);
					}
				}

                [self sendUISignal:self.READED];
                [self reload];
			}
		}
	};
	
	[api send];
}

@end

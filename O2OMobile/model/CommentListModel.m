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

#import "CommentListModel.h"

#pragma mark -

#undef	PAGE_SIZE
#define PAGE_SIZE	(10)

#pragma mark -

@implementation CommentListModel

DEF_SINGLETON( CommentListModel )

+ (NSString *)cacheName { return @"<Document>/<Class>/{uid}_{activity}.cache"; }

@synthesize uid;
@synthesize comments;

- (void)load
{
	self.comments = [NSMutableArray array];
    [self loadCache];
}

- (void)unload
{
	[self.comments removeAllObjects];
	self.comments = nil;
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
}

#pragma mark -

- (void)firstPage
{
	[API_COMMENT_LIST cancel:self];
    
	API_COMMENT_LIST * api = [API_COMMENT_LIST apiWithResponder:self];
    
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;
    
	api.req.by_no = @(1);
	api.req.count = @(PAGE_SIZE);
	
	api.req.user = self.uid;
	api.req.ver = nil;
	
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
				[self.comments removeAllObjects];
				[self.comments addObjectsFromArray:api.resp.comments];
				[self saveCache];
                
				self.loaded = YES;
				self.more = api.resp.more.boolValue;
			}

			[self sendUISignal:self.RELOADED];
		}
	};
    
	[api send];
}

- (void)nextPage
{
	if ( self.comments.count < PAGE_SIZE )
    {
        [self sendUISignal:self.RELOADED];
		return;
    }
	
	if ( NO == self.more )
    {
        [self sendUISignal:self.RELOADED];
		return;
    }

	[API_COMMENT_LIST cancel:self];
	
	API_COMMENT_LIST * api = [API_COMMENT_LIST apiWithResponder:self];
	
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    
	api.req.by_no = @(1 + (self.comments.count / PAGE_SIZE));
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
				[self.comments addObjectsFromArray:api.resp.comments];
				[self saveCache];

				self.loaded = (self.comments.count) ? YES : NO;
				self.more = api.resp.more.boolValue;
			}

			[self sendUISignal:self.RELOADED];
		}
	};
    
	[api send];
}

@end

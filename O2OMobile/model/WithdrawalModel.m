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

#import "WithdrawalModel.h"

#pragma mark -

#undef	PAGE_SIZE
#define PAGE_SIZE	(10)

@implementation WithdrawalModel

@synthesize withdraws = _withdraws;

DEF_SIGNAL( WITHDRAWALING )
DEF_SIGNAL( WITHDRAWAL_SUCCEED )
DEF_SIGNAL( WITHDRAWAL_FAILED )

- (void)load
{
	self.withdraws = [NSMutableArray array];
	self.more = YES;
	
	[self loadCache];
}

- (void)unload
{
	[self.withdraws removeAllObjects];
	self.withdraws = nil;
}

#pragma mark -

- (NSString *)cacheKey
{
	NSNumber * userID = bee.ext.userModel.user.id ? bee.ext.userModel.user.id : @0;
	
	return [NSString stringWithFormat:@"WithdrawalModel-%@", userID];
}

- (void)loadCache
{
	NSData * data = bee.system.fileCache[self.cacheKey];
	if ( data )
	{
		[self.withdraws removeAllObjects];
		[self.withdraws addObjectsFromArray:[WITHDRAW_ORDER objectFromAny:data]];
		
		self.loaded = (self.withdraws.count) ? YES : NO;
	}
}

- (void)saveCache
{
	if ( self.withdraws && self.withdraws.count )
	{
		bee.system.fileCache[self.cacheKey] = [self.withdraws objectToData];
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
	[self.withdraws removeAllObjects];
	self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
	[API_WITHDRAW_LIST cancel:self];
    
	API_WITHDRAW_LIST * api = [API_WITHDRAW_LIST apiWithResponder:self];
    
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
				[self.withdraws removeAllObjects];
                
                [self.withdraws addObjectsFromArray:api.resp.withdraws];
                
				self.more = api.resp.more.boolValue;
				self.loaded = YES;
			}
            
			[self sendUISignal:self.RELOADED];
		}
	};
	
	[api send];
}

- (void)nextPage
{
	if ( self.withdraws.count < PAGE_SIZE )
		return;
	
	if ( NO == self.more )
		return;
    
	[API_WITHDRAW_LIST cancel:self];
	
	API_WITHDRAW_LIST * api = [API_WITHDRAW_LIST apiWithResponder:self];
	
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;
    
	api.req.by_id = nil;
	api.req.by_no = @(1 + (self.withdraws.count / PAGE_SIZE));
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
				[self.withdraws addObjectsFromArray:api.resp.withdraws];
				
				self.loaded = (self.withdraws.count) ? YES : NO;
				self.more = api.resp.more.boolValue;
			}
			
			[self sendUISignal:self.RELOADED];
		}
	};
	
	[api send];
}

#pragma mark -

- (void)withDrawal:(NSNumber *)cash
{
    [API_WITHDRAW_MONEY cancel];
	
	API_WITHDRAW_MONEY * api = [API_WITHDRAW_MONEY apiWithResponder:self];
	
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;
    api.req.amount = cash;
    
	api.whenUpdate = ^
	{
		@normalize(api);
        
		if ( api.sending )
		{
            [self sendUISignal:self.WITHDRAWALING];
		}
		else
		{
			if ( api.succeed && api.resp.succeed.boolValue )
			{
                [self sendUISignal:self.WITHDRAWAL_SUCCEED];
			}
            else
            {
                [self sendUISignal:self.WITHDRAWAL_FAILED];
            }
		}
	};
	
	[api send];
}

@end

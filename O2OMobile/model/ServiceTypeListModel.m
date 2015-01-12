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

#import "ServiceTypeListModel.h"
#import "UserModel.h"

#pragma mark -

#undef	PAGE_SIZE
#define PAGE_SIZE	(20)

@implementation ServiceTypeListModel

@synthesize services = _services;

DEF_SIGNAL( RELOADED_CANCEL )

- (void)load
{
	self.services = [NSMutableArray array];
}

- (void)unload
{
	[self.services removeAllObjects];
	self.services = nil;
}

#pragma mark -

- (NSString *)cacheKey
{
	return [NSString stringWithFormat:@"ServiceTypeListModel"];
}

- (void)loadCache
{
	NSData * data = bee.system.fileCache[self.cacheKey];
	if ( data )
	{
		[self.services removeAllObjects];
		[self.services addObjectsFromArray:[SERVICE_TYPE objectFromAny:data]];
		
        self.loaded = (self.services.count) ? YES : NO;
        
        // 从缓存中加载，如果上次缓存数量小于PAGE_SIZE，说明上次 more 为 NO
        self.more = self.services.count >= PAGE_SIZE;
	}
    else
    {
        // 无缓存不知道是否还有，more为YES
        self.more = YES;
    }
}

- (void)saveCache
{
	bee.system.fileCache[self.cacheKey] = [self.services objectToData];
}

- (void)clearCache
{
	bee.system.fileCache[self.cacheKey] = nil;
	
	[self.services removeAllObjects];
	
	self.loaded = NO;
}

#pragma mark -

- (void)firstPage
{
	[API_SERVICETYPE_LIST cancel:self];
    
	API_SERVICETYPE_LIST * api = [API_SERVICETYPE_LIST apiWithResponder:self];
    
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;
    
	api.req.by_no = @(1);
	api.req.by_id = nil;
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
				[self.services removeAllObjects];
                
				[self.services addObjectsFromArray:api.resp.services];
                
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
	if ( self.services.count < PAGE_SIZE )
    {
        [self sendUISignal:self.RELOADED_CANCEL];
		return;
    }
	
	if ( NO == self.more )
    {
        [self sendUISignal:self.RELOADED_CANCEL];
		return;
    }
    
	[API_SERVICETYPE_LIST cancel:self];
	
	API_SERVICETYPE_LIST * api = [API_SERVICETYPE_LIST apiWithResponder:self];
	
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    
	api.req.by_no = @(1 + (self.services.count / PAGE_SIZE));
	api.req.by_id = nil;
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
				[self.services addObjectsFromArray:api.resp.services];
                             
				self.loaded = (self.services.count) ? YES : NO;
				self.more = api.resp.more.boolValue;
			}
            
			[self sendUISignal:self.RELOADED];
		}
	};
    
	[api send];
}

@end

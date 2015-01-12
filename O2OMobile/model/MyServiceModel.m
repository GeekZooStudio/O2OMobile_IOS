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

#import "MyServiceModel.h"

#pragma mark -

#undef	PAGE_SIZE
#define PAGE_SIZE	(10)

#pragma mark -

@implementation MyServiceModel

DEF_SINGLETON( MyServiceModel )

DEF_SIGNAL( MODIFY_REQUESTING )
DEF_SIGNAL( MODIFY_SUCCEED )
DEF_SIGNAL( MODIFY_FAILED )

@synthesize uid;
@synthesize services;

- (void)load
{
	self.services = [[[NSMutableArray alloc] init] autorelease];
	
    [self loadCache];
}

- (void)unload
{
	[self.services removeAllObjects];
	self.services = nil;
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
	[API_MYSERVICE_LIST cancel:self];
    
	API_MYSERVICE_LIST * api = [API_MYSERVICE_LIST apiWithResponder:self];
    
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
        [self sendUISignal:self.RELOADED];
		return;
    }
	
	if ( NO == self.more )
    {
        [self sendUISignal:self.RELOADED];
		return;
    }

	[API_MYSERVICE_LIST cancel:self];
	
	API_MYSERVICE_LIST * api = [API_MYSERVICE_LIST apiWithResponder:self];
	
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

- (void)modify:(NSNumber *)serviceId price:(NSNumber *)price
{
	[API_MYSERVICE_MODIFY cancel:self];
	
	API_MYSERVICE_MODIFY * api = [API_MYSERVICE_MODIFY apiWithResponder:self];
	
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    
	api.req.service_id = serviceId;
	api.req.price = [NSString stringWithFormat:@"%@", price];

	api.whenUpdate = ^
	{
		@normalize(api);

		if ( api.sending )
		{
			[self sendUISignal:self.MODIFY_REQUESTING];
		}
		else
		{
			if ( api.succeed && api.resp.succeed.boolValue )
			{
				for ( MY_SERVICE * service in self.services )
				{
					if ( [service.id isEqualToNumber:api.req.service_id] )
					{
						service.price = api.resp.service.price;
					}
				}

				[self sendUISignal:self.MODIFY_SUCCEED];
			}
			else
			{
				[self sendUISignal:self.MODIFY_FAILED];
			}
		}
	};
    
	[api send];

}

@end

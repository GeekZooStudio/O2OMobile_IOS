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

#import "AroundOrderListModel.h"
#import "UserModel.h"

#pragma mark -

#undef	PAGE_SIZE
#define PAGE_SIZE	(10)

@implementation AroundOrderListModel

@synthesize orders = orders;
@synthesize filterArray = _filterArray;

DEF_SIGNAL( RELOADED_CANCEL )

- (void)load
{
	self.orders = [NSMutableArray array];
    
    self.filterArray = [NSMutableArray array];
}

- (void)unload
{
	[self.orders removeAllObjects];
	self.orders = nil;
    
    [self.filterArray removeAllObjects];
    self.filterArray = nil;
}

#pragma mark -

- (NSString *)cacheKey
{
	return [NSString stringWithFormat:@"AroundOrderListModel"];
}

- (void)loadCache
{
	NSData * data = bee.system.fileCache[self.cacheKey];
	if ( data )
	{
		[self.orders removeAllObjects];
		[self.orders addObjectsFromArray:[ORDER_INFO objectFromAny:data]];
		
        self.loaded = (self.orders.count) ? YES : NO;
        self.more = self.orders.count >= PAGE_SIZE;
	}
    else
    {
        self.more = YES;
    }
}

- (void)saveCache
{
	bee.system.fileCache[self.cacheKey] = [self.orders objectToData];
}

- (void)clearCache
{
	bee.system.fileCache[self.cacheKey] = nil;
	
	[self.orders removeAllObjects];
	
	self.loaded = NO;
}

#pragma mark -

- (void)loadFilterData
{
    [self.filterArray removeAllObjects];
    
    FilterItemData * data0 = [[[FilterItemData alloc] init] autorelease];
    data0.title = __TEXT(@"nearest_me");
    data0.value = [NSNumber numberWithInt:SEARCH_ORDER_location_asc];
    data0.selected = [_sort_by isEqualToNumber:[NSNumber numberWithInt:SEARCH_ORDER_location_asc]];
    [self.filterArray addObject:data0];

    FilterItemData * data1 = [[[FilterItemData alloc] init] autorelease];
    data1.title = __TEXT(@"most_expensive");
    data1.value = [NSNumber numberWithInt:SEARCH_ORDER_price_desc];
    data1.selected = [_sort_by isEqualToNumber:[NSNumber numberWithInt:SEARCH_ORDER_price_desc]];
    [self.filterArray addObject:data1];
    
    FilterItemData * data2 = [[[FilterItemData alloc] init] autorelease];
    data2.title = __TEXT(@"price_lowest");
    data2.value = [NSNumber numberWithInt:SEARCH_ORDER_price_asc];
    data2.selected = [_sort_by isEqualToNumber:[NSNumber numberWithInt:SEARCH_ORDER_price_asc]];
    [self.filterArray addObject:data2];
    
    FilterItemData * data3 = [[[FilterItemData alloc] init] autorelease];
    data3.title = __TEXT(@"newest_publish");
    data3.value = [NSNumber numberWithInt:SEARCH_ORDER_time_desc];
    data3.selected = [_sort_by isEqualToNumber:[NSNumber numberWithInt:SEARCH_ORDER_time_desc]];
    [self.filterArray addObject:data3];
    
}

- (void)reloadFilterData
{
    for ( int i = 0; i < self.filterArray.count; i++ )
    {
        FilterItemData * data = [self.filterArray objectAtIndex:i];
        if ( [_sort_by isEqualToNumber:data.value ] )
        {
            data.selected = YES;
        }
        else
        {
            data.selected = NO;
        }
    }
}

#pragma mark -

- (void)firstPage
{
	[API_ORDERLIST_AROUND cancel:self];
    
	API_ORDERLIST_AROUND * api = [API_ORDERLIST_AROUND apiWithResponder:self];
    
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;
    api.req.sort_by = self.sort_by;
    api.req.location = [LocationModel sharedInstance].location;
    
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
				[self.orders removeAllObjects];
                
				[self.orders addObjectsFromArray:api.resp.orders];
                
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
	if ( self.orders.count < PAGE_SIZE )
    {
        [self sendUISignal:self.RELOADED_CANCEL];
		return;
    }
	
	if ( NO == self.more )
    {
        [self sendUISignal:self.RELOADED_CANCEL];
		return;
    }
    
	[API_ORDERLIST_AROUND cancel:self];
	
	API_ORDERLIST_AROUND * api = [API_ORDERLIST_AROUND apiWithResponder:self];
	
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    api.req.sort_by = self.sort_by;
    api.req.location = [LocationModel sharedInstance].location;
    
	api.req.by_no = @(1 + (self.orders.count / PAGE_SIZE));
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
				[self.orders addObjectsFromArray:api.resp.orders];
                
				self.loaded = (self.orders.count) ? YES : NO;
				self.more = api.resp.more.boolValue;
			}
            
            [self sendUISignal:self.RELOADED];
		}
	};
    
	[api send];
}

@end

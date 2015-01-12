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

#import "E0_PublishedOrdersBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "E0_SegmentCell_iPhone.h"
#import "HeaderLoader_iPhone.h"
#import "FooterLoader_iPhone.h"
#import "E0_PublishedOrderCell_iPhone.h"
#import "D1_OrderBoard_iPhone.h"

@implementation E0_PublishedOrdersBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( E0_SegmentCell_iPhone, segment )
DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( PublishedOrderListModel, publishedOrderListModel )

- (void)load
{
    self.publishedOrderListModel = [PublishedOrderListModel modelWithObserver:self];
}

- (void)unload
{
    [self.publishedOrderListModel removeObserver:self];
    self.publishedOrderListModel = nil;
}

#pragma mark -

- (NSInteger)currentTab
{
	return self.segment.currentTab;
}

- (void)reloadAll
{
	if ( 0 == [self currentTab] )
	{
        self.publishedOrderListModel.order_state = [NSNumber numberWithInt:PUBLISHED_ORDER_STATE_PUBLISHED_ORDER_UNDONE];
	}
	else
	{
        self.publishedOrderListModel.order_state = [NSNumber numberWithInt:PUBLISHED_ORDER_STATE_PUBLISHED_ORDER_DONE];
	}
    [self.publishedOrderListModel loadCache];
    [self.publishedOrderListModel firstPage];
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
    self.segment = [E0_SegmentCell_iPhone cell];
    self.segment.one.title = __TEXT(@"unfinished_order");
    self.segment.two.title = __TEXT(@"finished_order");
    
    self.navigationBarShown = YES;
	self.navigationBarTitle = self.segment;
    self.navigationBarLeft = [UIImage imageNamed:@"b0_btn_menu.png"];
    
    @weakify(self);
    
    self.list.headerClass = [HeaderLoader_iPhone class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [FooterLoader_iPhone class];
    self.list.footerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.publishedOrderListModel.orders.count;
        
//        if ( self.publishedOrderListModel.loaded && 0 == self.publishedOrderListModel.orders.count )
//        {
//            self.list.total = 1;
//            
//            BeeUIScrollItem * item = self.list.items[0];
////            item.clazz = [NoResultCell class];
//            item.size = self.list.size;
//            item.rule = BeeUIScrollLayoutRule_Tile;
//        }
//        else
        {
            for ( int i = 0; i < self.publishedOrderListModel.orders.count; i++ )
            {
                BeeUIScrollItem * item = self.list.items[i];
                
                item.clazz = [E0_PublishedOrderCell_iPhone class];
                item.size = CGSizeMake( self.list.width, 100 );
                item.data = [self.publishedOrderListModel.orders safeObjectAtIndex:i];
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.publishedOrderListModel firstPage];
        
    };
    self.list.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.publishedOrderListModel nextPage];
    };
    self.list.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.publishedOrderListModel nextPage];
    };
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    if ( self.firstEnter )
	{
		[self selectSegmentOne];
	}
}

ON_DID_APPEAR( signal )
{
    [self reloadAll];
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [AppBoard_iPhone sharedInstance].menuShown = [AppBoard_iPhone sharedInstance].menuShown ? NO : YES;
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

#pragma mark - E0_SegmentCell_iPhone

ON_SIGNAL3( E0_SegmentCell_iPhone, one, signal )
{
    [self selectSegmentOne];
}

ON_SIGNAL3( E0_SegmentCell_iPhone, two, signal )
{
    [self selectSegmentTwo];
}

- (void)selectSegmentOne
{
    if ( 0 == [self currentTab] )
        return;
    
    [self.segment selectOne];
    
    self.publishedOrderListModel.order_state = [NSNumber numberWithInt:PUBLISHED_ORDER_STATE_PUBLISHED_ORDER_UNDONE];
    [self.publishedOrderListModel loadCache];
    [self.publishedOrderListModel firstPage];
}

- (void)selectSegmentTwo
{
    if ( 1 == [self currentTab] )
        return;
    
    [self.segment selectTwo];
    
    self.publishedOrderListModel.order_state = [NSNumber numberWithInt:PUBLISHED_ORDER_STATE_PUBLISHED_ORDER_DONE];
    [self.publishedOrderListModel loadCache];
    [self.publishedOrderListModel firstPage];
}

#pragma mark - E0_PublishedOrderCell_iPhone

ON_SIGNAL3( E0_PublishedOrderCell_iPhone, mask, signal )
{
    D1_OrderBoard_iPhone * board = [D1_OrderBoard_iPhone board];
    board.order = signal.sourceCell.data;
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - PublishedOrderListModel

ON_SIGNAL3( PublishedOrderListModel, RELOADING, signal )
{
	if ( 0 == self.publishedOrderListModel.orders.count )
	{
		self.list.footerLoading = NO;
		self.list.footerShown = NO;
	}
	else
	{
		self.list.footerLoading = self.publishedOrderListModel.orders.count ? YES : NO;
		self.list.footerShown = YES;
	}
	
	[self.list asyncReloadData];
}

ON_SIGNAL3( PublishedOrderListModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.publishedOrderListModel.more;
	self.list.footerShown = YES;
    
    [self.list asyncReloadData];
}

@end

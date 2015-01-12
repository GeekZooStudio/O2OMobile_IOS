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

#import "A0_RequestListBoard_iPhone.h"
#import "MenuButton_iPhone.h"
#import "AppBoard_iPhone.h"
#import "A0_RequestCell_iPhone.h"
#import "C0_ServerListBoard_iPhone.h"
#import "HeaderLoader_iPhone.h"
#import "FooterLoader_iPhone.h"
#import "A0_HomeBoard_iPhone.h"
#import "C5_FilterCell_iPhone.h"
#import "C5_FilterItemCell_iPhone.h"
#import "D1_OrderBoard_iPhone.h"

#pragma mark -

@interface A0_RequestListBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation A0_RequestListBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( MenuButton_iPhone, menuButton )
DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( C5_FilterCell_iPhone, filter )

DEF_MODEL( AroundOrderListModel, aroundOrderListModel )

- (void)load
{
    self.title = __TEXT(@"request_around");
    
    self.aroundOrderListModel = [AroundOrderListModel modelWithObserver:self];
}

- (void)unload
{
    [self.aroundOrderListModel removeObserver:self];
    [self.aroundOrderListModel cancelMessages];
    self.aroundOrderListModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
    self.navigationBarShown = YES;
    
    @weakify(self);
    
    self.list.headerClass = [HeaderLoader_iPhone class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [FooterLoader_iPhone class];
    self.list.footerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    self.list.baseInsets = bee.ui.config.baseInsets;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.aroundOrderListModel.orders.count;
        
//        if ( self.aroundOrderListModel.loaded && 0 == self.aroundOrderListModel.orders.count )
//        {
//            self.list.total = 1;
//            
//            BeeUIScrollItem * item = self.list.items[0];
//            //            item.clazz = [NoResultCell class];
//            item.size = self.list.size;
//            item.rule = BeeUIScrollLayoutRule_Tile;
//        }
//        else
        {
            for ( int i = 0; i < self.list.total; i++ )
            {
                BeeUIScrollItem * item = self.list.items[i];
                item.clazz = [A0_RequestCell_iPhone class];
                item.size = CGSizeMake( self.list.width, 100 );
                item.data = [self.aroundOrderListModel.orders safeObjectAtIndex:i];
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.aroundOrderListModel firstPage];
    };
    self.list.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.aroundOrderListModel nextPage];
    };
    self.list.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.aroundOrderListModel nextPage];
    };
    
    [self observeNotification:A0_HomeBoard_iPhone.FILTRATE];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:A0_HomeBoard_iPhone.FILTRATE];
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_LOAD_DATAS( signal )
{
    [self.aroundOrderListModel loadFilterData];
    self.filter.datas = self.aroundOrderListModel.filterArray;
}

ON_WILL_APPEAR( signal )
{
    [AppBoard_iPhone sharedInstance].menuPannable = YES;
    
    if ( NO == self.aroundOrderListModel.loaded )
    {
        self.aroundOrderListModel.sort_by = [NSNumber numberWithInt:SEARCH_ORDER_location_asc];
        [self.aroundOrderListModel loadCache];
        [self.aroundOrderListModel firstPage];
        
        [self.aroundOrderListModel reloadFilterData];
        [self.filter.itemList reloadData];
    }
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [AppBoard_iPhone sharedInstance].menuPannable = NO;
    
    self.filter.expanded = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

#pragma mark -

ON_NOTIFICATION3( A0_HomeBoard_iPhone, FILTRATE, notification )
{
    self.filter.expanded = !self.filter.expanded;
    
    if( self.whenExpandChanged )
    {
        self.whenExpandChanged(self.filter.expanded);
    }
}

#pragma mark - C5_FilterItemCell_iPhone

ON_SIGNAL3( C5_FilterItemCell_iPhone, mask, signal )
{
    C5_FilterItemCell_iPhone * cell = (C5_FilterItemCell_iPhone *)signal.sourceCell;
    FilterItemData * itemData = cell.data;
    
    self.list.headerShown = YES;
    self.list.headerLoading = YES;
    
    self.aroundOrderListModel.sort_by = itemData.value;
    [self.aroundOrderListModel firstPage];
    
    [self.aroundOrderListModel reloadFilterData];
    [self.filter.itemList reloadData];
    
    self.filter.expanded = NO;
    
    if( self.whenExpandChanged )
    {
        self.whenExpandChanged( NO );
    }
}

#pragma mark -

ON_SIGNAL3( A0_RequestCell_iPhone, mask, signal )
{
    D1_OrderBoard_iPhone * board = [D1_OrderBoard_iPhone board];
    board.order = signal.sourceCell.data;
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - AroundOrderListModel

ON_SIGNAL3( AroundOrderListModel, RELOADING, signal )
{
	if ( 0 == self.aroundOrderListModel.orders.count )
	{
		self.list.footerLoading = NO;
		self.list.footerShown = NO;
	}
	else
	{
		self.list.footerLoading = self.aroundOrderListModel.orders.count ? YES : NO;
		self.list.footerShown = YES;
	}
	
	[self.list asyncReloadData];
}

ON_SIGNAL3( AroundOrderListModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.aroundOrderListModel.more;
	self.list.footerShown = YES;
    
    [self.list asyncReloadData];
}

@end

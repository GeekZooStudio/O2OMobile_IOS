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

#import "C0_ServerListBoard_iPhone.h"
#import "C0_ServerListCell_iPhone.h"
#import "HeaderLoader_iPhone.h"
#import "FooterLoader_iPhone.h"
#import "C5_FilterItemCell_iPhone.h"
#import "F0_ProfileBoard_iPhone.h"
#import "C1_PublishOrderBoard_iPhone.h"

@implementation C0_ServerListBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( C5_FilterCell_iPhone, filter )

DEF_MODEL( UserListModel, userListModel )

@synthesize service_type = _service_type;

- (void)load
{
    self.userListModel = [UserListModel modelWithObserver:self];
}

- (void)unload
{
    [self.userListModel removeObserver:self];
    [self.userListModel cancelMessages];
    self.userListModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
    self.navigationBarShown = YES;
	self.navigationBarTitle = self.service_type.title;
    self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
    self.navigationBarRight = [UIImage imageNamed:@"b1_icon_filter.png"];
    
    @weakify(self);
    
    self.list.headerClass = [HeaderLoader_iPhone class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [FooterLoader_iPhone class];
    self.list.footerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    UIEdgeInsets insets = bee.ui.config.baseInsets;
    insets.bottom += 60;
    self.list.baseInsets = insets;
    
    self.list.whenReloading = ^
    {
        @normalize(self);

        self.list.total = self.userListModel.users.count;
        
//        if ( self.userListModel.loaded && 0 == self.userListModel.users.count )
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
            for ( int i = 0; i < self.list.total; i++ )
            {
                BeeUIScrollItem * item = self.list.items[i];
                item.clazz = [C0_ServerListCell_iPhone class];
                item.size = CGSizeMake( self.list.width, 80 );
                item.data = [self.userListModel.users safeObjectAtIndex:i];
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.userListModel firstPage];
    };
    self.list.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.userListModel nextPage];
    };
    self.list.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.userListModel nextPage];
    };
    [self.list sendSubviewToBack:self.view];
    
    [self.filter bringSubviewToFront:self.view];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_LOAD_DATAS( signal )
{
    [self.userListModel loadFilterData];
    self.filter.datas = self.userListModel.filterArray;
}

ON_WILL_APPEAR( signal )
{
    if ( NO == self.userListModel.loaded )
    {
        self.userListModel.service_type = self.service_type.id;
        self.userListModel.sort_by = [NSNumber numberWithInt:SEARCH_ORDER_location_asc];
        [self.userListModel loadCache];
        [self.userListModel firstPage];
        
        [self.userListModel reloadFilterData];
        [self.filter.itemList reloadData];
    }
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    self.filter.expanded = !self.filter.expanded;
    
    if ( self.filter.expanded )
    {
        self.navigationBarRight = [UIImage imageNamed:@"b2_close.png"];
    }
    else
    {
        self.navigationBarRight = [UIImage imageNamed:@"b1_icon_filter.png"];
    }
}

#pragma mark - C0_ServerListCell_iPhone

ON_SIGNAL3( C0_ServerListCell_iPhone, mask, signal )
{
    BeeUICell * cell = signal.sourceCell;
    USER * user = cell.data;
    
    if ( [user.id isEqualToNumber:[UserModel sharedInstance].user.id] )
    {
        [self.stack pushBoard:[F0_MyProfileBoard_iPhone sharedInstance] animated:YES];
    }
    else
    {
        F0_OtherProfileBoard_iPhone * board = [F0_OtherProfileBoard_iPhone board];
        board.uid = user.id;
        board.currentServiceType = self.service_type;
        [self.stack pushBoard:board animated:YES];
    }
}

#pragma mark - C5_FilterItemCell_iPhone

ON_SIGNAL3( C5_FilterCell_iPhone, mask, signal )
{
    self.filter.expanded = NO;
}

#pragma mark - C5_FilterItemCell_iPhone

ON_SIGNAL3( C5_FilterItemCell_iPhone, mask, signal )
{
    C5_FilterItemCell_iPhone * cell = (C5_FilterItemCell_iPhone *)signal.sourceCell;
    FilterItemData * itemData = cell.data;

    self.list.headerShown = YES;
    self.list.headerLoading = YES;
    
    self.userListModel.sort_by = itemData.value;
    [self.userListModel firstPage];
    
    [self.userListModel reloadFilterData];
    [self.filter.itemList reloadData];
    
    self.filter.expanded = NO;
    self.navigationBarRight = [UIImage imageNamed:@"b1_icon_filter.png"];
}

#pragma mark - C0_ServerListBoard_iPhone

ON_SIGNAL3( C0_ServerListBoard_iPhone, publish, signal )
{
    C1_PublishOrderBoard_iPhone * board = [C1_PublishOrderBoard_iPhone board];
    board.orderData.service_type = self.service_type;
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - UserListModel

ON_SIGNAL3( UserListModel, RELOADING, signal )
{
	if ( 0 == self.userListModel.users.count )
	{
		self.list.footerLoading = NO;
		self.list.footerShown = NO;
	}
	else
	{
		self.list.footerLoading = self.userListModel.users.count ? YES : NO;
		self.list.footerShown = YES;
	}
	
	[self.list asyncReloadData];
}

ON_SIGNAL3( UserListModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.userListModel.more;
	self.list.footerShown = YES;
    
    [self.list asyncReloadData];
}

@end

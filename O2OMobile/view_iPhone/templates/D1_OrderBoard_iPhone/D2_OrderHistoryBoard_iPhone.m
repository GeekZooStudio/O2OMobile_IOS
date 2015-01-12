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

#import "D2_OrderHistoryBoard_iPhone.h"
#import "D2_OrderHistoryCell_iPhone.h"
#import "HeaderLoader_iPhone.h"
#import "OrderInfoModel.h"

#pragma mark -

@interface D2_OrderHistoryBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation D2_OrderHistoryBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( OrderInfoModel, orderInfoModel )

- (void)load
{
    self.orderInfoModel = [OrderInfoModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL(self.orderInfoModel);
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.title = __TEXT(@"order_status");
    self.navigationBarShown = YES;
    self.view.backgroundColor = HEX_RGB(0xFFFFFF);
    
    self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
    
    self.list.headerClass = [HeaderLoader_iPhone class];
    self.list.headerShown = YES;
    
    @weakify(self);
    
    self.list.whenReloading = ^
	{
		@normalize( self );
        
        if ( !self.orderInfoModel.records )
            return;
        
        self.list.total = self.orderInfoModel.records.count;
        
        for ( BeeUIScrollItem * item in self.list.items )
        {
            D2_OrderHistoryCellData * data = [[[D2_OrderHistoryCellData alloc] init] autorelease];
            data.record = [self.orderInfoModel.records safeObjectAtIndex:item.index];
            data.isCurrent = self.order.order_status.intValue == data.record.order_action.intValue;
            data.isActive = self.order.order_status.intValue > data.record.order_action.intValue;
            item.clazz = [D2_OrderHistoryCell_iPhone class];
            item.data = data;
        }
    };
    
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        self.orderInfoModel.order_id = self.order.id;
        [self.orderInfoModel history];
    };
    
    self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    self.orderInfoModel.order_id = self.order.id;
    [self.orderInfoModel history];
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
}

ON_SIGNAL3( OrderInfoModel, HISTORY_LOADING, signal )
{
    
}

ON_SIGNAL3( OrderInfoModel, DID_HISTORY, signal )
{
    self.list.headerLoading = NO;
    [self dismissTips];
	
    [self.list asyncReloadData];
}

@end

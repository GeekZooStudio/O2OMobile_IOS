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

#import "A0_ServiceBoard_iPhone.h"
#import "MenuButton_iPhone.h"
#import "AppBoard_iPhone.h"
#import "A0_ServiceCell_iPhone.h"
#import "C0_ServerListBoard_iPhone.h"
#import "A0_HomeBoard_iPhone.h"
#import "C1_PublishOrderBoard_iPhone.h"
#import "HeaderLoader_iPhone.h"

#pragma mark -

@implementation A0_ServiceBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( MenuButton_iPhone, menuButton )
DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( ServiceTypeListModel, serviceTypeListModel )

- (void)load
{
    self.title = __TEXT(@"need_help");
    self.serviceTypeListModel = [ServiceTypeListModel modelWithObserver:self];
}

- (void)unload
{
    [self.serviceTypeListModel removeObserver:self];
    [self.serviceTypeListModel cancelMessages];
    self.serviceTypeListModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
    @weakify(self);
    
    self.list.headerClass = [HeaderLoader_iPhone class];
    self.list.headerShown = YES;
    
    self.list.lineCount = 2;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = self.serviceTypeListModel.services.count;
        
        for ( int i = 0; i < self.list.total; i++ )
        {
            BeeUIScrollItem * item = self.list.items[i];
            item.clazz = [A0_ServiceCell_iPhone class];
            item.size = CGSizeMake( self.list.width / 2.0f, self.list.width / 2.0f );
            item.rule = BeeUIScrollLayoutRule_Fall;
            
            SERVICE_TYPE * service_type = [self.serviceTypeListModel.services safeObjectAtIndex:i];
            if ( i % 2 )
            {
                service_type.showRightLine = NO;
            }
            else
            {
                service_type.showRightLine = YES;
            }
            
            if ( i < self.serviceTypeListModel.services.count - 2 )
            {
                service_type.showBottomLine = YES;
            }
            else
            {
                service_type.showBottomLine = NO;
            }
            
            item.data = service_type;
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        [self.serviceTypeListModel firstPage];
    };
    
    [self observeNotification:A0_HomeBoard_iPhone.PUBLISH];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:A0_HomeBoard_iPhone.PUBLISH];
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [AppBoard_iPhone sharedInstance].menuPannable = YES;
    
    if ( NO == self.serviceTypeListModel.loaded )
    {
        [self.serviceTypeListModel loadCache];
        [self.serviceTypeListModel firstPage];
    }
    
    [self.list reloadData];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [AppBoard_iPhone sharedInstance].menuPannable = NO;
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

#pragma mark -

ON_NOTIFICATION3( A0_HomeBoard_iPhone, PUBLISH, notification )
{
    [self.stack pushBoard:[C1_PublishOrderBoard_iPhone board] animated:YES];
}

#pragma mark - A0_ServiceCell_iPhone

ON_SIGNAL3( A0_ServiceCell_iPhone, mask, signal )
{
    C0_ServerListBoard_iPhone * board = [C0_ServerListBoard_iPhone board];
    board.service_type = signal.sourceCell.data;
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - ServiceTypeListModel

ON_SIGNAL3( ServiceTypeListModel, RELOADING, signal )
{
}

ON_SIGNAL3( ServiceTypeListModel, RELOADED, signal )
{
    self.list.headerLoading = NO;
	
    [self.list asyncReloadData];
}

@end

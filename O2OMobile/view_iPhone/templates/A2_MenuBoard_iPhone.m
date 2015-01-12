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

#import "A2_MenuBoard_iPhone.h"
#import "A2_MenuBoardCell_iPhone.h"
#import "UserModel.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface A2_MenuBoard_iPhone ()
{
    CAGradientLayer * colorLayer;
}

@end

@implementation A2_MenuBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( A2_MenuBoard_iPhone )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( UserModel, userModel )
DEF_MODEL( MessageListModel, messageListModel )

- (void)load
{
    self.userModel = [UserModel sharedInstance];
    [self.userModel addObserver:self];
    
    self.messageListModel = [MessageListModel sharedInstance];
    [self.messageListModel addObserver:self];
}

- (void)unload
{
    [self.userModel removeObserver:self];
    [self.userModel cancelMessages];
    
    [self.messageListModel removeObserver:self];
    [self.messageListModel cancelMessages];
}

- (void)updateBadge
{
    A2_MenuBoardCell_iPhone * cell = (A2_MenuBoardCell_iPhone *)(((BeeUIScrollItem *)[self.list.items safeObjectAtIndex:0]).view);
    if ( nil == cell)
        return;
    
	if ( self.messageListModel.unreadCount )
	{
		cell.message_badge.data = @(self.messageListModel.unreadCount);
		cell.message_badge.hidden = NO;
	}
	else
	{
		cell.message_badge.data = nil;
		cell.message_badge.hidden = YES;
	}
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    if ( IOS7_OR_LATER )
    {
        [self addGradientLayer];
    }
    else
    {
        self.view.backgroundColor = HEX_RGB( 0x3bb5e8 );
    }
    
    @weakify(self);
    
    self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	
	self.list.whenReloading = ^
	{
		@normalize(self);
		
		self.list.total = 1;
        
        BeeUIScrollItem * item = self.list.items[0];
        item.size = CGSizeMake( self.list.width, self.list.height );
        item.clazz = [A2_MenuBoardCell_iPhone class];
        item.data = bee.ext.userModel;
        item.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        item.section = 0;
    };
    
    [self observeNotification:UserModel.LOGIN];
    [self observeNotification:UserModel.LOGOUT];
    [self observeNotification:AppBoard_iPhone.LEFT_MENU_OPENED];
	[self observeNotification:AppBoard_iPhone.LEFT_MENU_CLOSED];
    [self observeNotification:MessageListModel.UNREAD_UPDATE];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:UserModel.LOGIN];
    [self unobserveNotification:UserModel.LOGOUT];
    [self unobserveNotification:AppBoard_iPhone.LEFT_MENU_OPENED];
	[self unobserveNotification:AppBoard_iPhone.LEFT_MENU_CLOSED];
    [self unobserveNotification:MessageListModel.UNREAD_UPDATE];
}

ON_LAYOUT_VIEWS( signal )
{
    colorLayer.frame = self.frame;
}

ON_WILL_APPEAR( signal )
{
    [self.userModel getUserBalance];
    [self.messageListModel reload];
    
    [self.list reloadData];
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
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

#pragma mark -

ON_NOTIFICATION3( AppBoard_iPhone, LEFT_MENU_OPENED, n )
{
    if ( self.userModel.user.user_group.intValue != USER_GROUP_FREEMAN)
    {
        [self.userModel getProfile];
    }

    [self.userModel getUserBalance];
    
    [self.messageListModel reload];
}

ON_NOTIFICATION3( AppBoard_iPhone, LEFT_MENU_CLOSED, n )
{
}

#pragma mark -

- (void)addGradientLayer
{
    colorLayer = [CAGradientLayer layer];
    colorLayer.frame = self.frame;
    colorLayer.position = self.view.center;
    [self.view.layer insertSublayer:colorLayer atIndex:0];
    
    colorLayer.colors = @[(__bridge id)HEX_RGB( 0x3bb5e8 ).CGColor, (__bridge id)HEX_RGB( 0x1479b9 ).CGColor];
    colorLayer.locations  = @[@(0.0), @(1.0)];
    colorLayer.startPoint = CGPointMake( 0, 0 );
    colorLayer.endPoint = CGPointMake( 0, 1 );
}

#pragma mark -

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
    [self.userModel getUserBalance];
    
    [self.messageListModel loadCache];
    
    [self.list reloadData];
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
    [self updateBadge];
    
    [self.list reloadData];
}

#pragma mark - UserModel

ON_SIGNAL3( UserModel, GETTING_BALANCE, signal )
{
}

ON_SIGNAL3( UserModel, GET_BALANCE_SUCCEED, signal )
{
    [self.list asyncReloadData];
}

ON_SIGNAL3( UserModel, GET_BALANCE_FAILED, signal )
{
}

ON_SIGNAL3( UserModel, PROFILE_UPDATING, signal )
{
}

ON_SIGNAL3( UserModel, PROFILE_UPDATED, signal )
{
	[self.list reloadData];
}

ON_SIGNAL3( UserModel, PROFILE_FAILED, signal )
{
}

#pragma mark - MessageListModel

ON_SIGNAL3( MessageListModel, UPDATING, signal )
{
}

ON_SIGNAL3( MessageListModel, UPDATED, signal )
{
	[self updateBadge];
}

ON_NOTIFICATION3( MessageListModel, UNREAD_UPDATE, notification )
{
    [self updateBadge];
}

@end

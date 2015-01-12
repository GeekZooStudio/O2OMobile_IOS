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

#import "AppBoard_iPhone.h"
#import "A2_MenuBoard_iPhone.h"
#import "A2_MenuBoardCell_iPhone.h"
#import "A0_HomeBoard_iPhone.h"
#import "B0_SigninBoard_iPhone.h"
#import "F0_ProfileBoard_iPhone.h"
#import "F4_RefferalBoard_iPhone.h"
#import "A0_HomeBoard_iPhone.h"
#import "H0_MessageBoard_iPhone.h"
#import "E0_PublishedOrdersBoard_iPhone.h"
#import "D1_OrderBoard_iPhone.h"
#import "E2_ReceivedOrdersBoard_iPhone.h"
#import "D3_OrderCommentBoard_iPhone.h"
#import "D4_OrderCommentListBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"
#import "C1_PublishOrderBoard_iPhone.h"
#import "F10_ApplyBoard_iPhone.h"

#import "bee.services.location.h"
#import "bee.services.push.h"
#import "BeeAlertView.h"

#pragma mark -

DEF_EXTERNAL( AppBoard_iPhone, appBoard );

#pragma mark -

#undef	DRAG_BOUNDS
#define	DRAG_BOUNDS			(100.0f)

#undef	MENU_BOUNDS
#define	MENU_BOUNDS			(0.7*([[UIScreen mainScreen] bounds].size.width))

#pragma mark -

@interface AppBoard_iPhone ()
{
    BeeUIRouter *			_router;
    A2_MenuBoard_iPhone *	_leftMenu;
	
    BOOL _leftMenuShown;
    BOOL _menuAnimating;
    BOOL _leftMenuPanning;
    BOOL _menuPanning;
    BOOL _menuPannable;
}

@end

@implementation AppBoard_iPhone

DEF_SINGLETON( AppBoard_iPhone )

DEF_NOTIFICATION( LEFT_MENU_OPENED )
DEF_NOTIFICATION( LEFT_MENU_CLOSED )

DEF_SIGNAL( NOTIFY )

@dynamic menuShown;
@dynamic menuPannable;

- (void)load
{
    _leftMenuShown		= NO;
	_menuAnimating		= NO;
	_menuPannable		= NO;
    
    [UserModel sharedInstance];
    [MessageListModel sharedInstance];
    
    // TODO: add function (setup push)
    
    bee.services.location.ON();
}

- (void)unload
{
    bee.services.location.OFF();
}

#pragma mark Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = [UIColor clearColor];
	
    _router = [BeeUIRouter sharedInstance];
    _router.parentBoard = self;

	[_router map:@"profile"		toBoard:[F0_MyProfileBoard_iPhone sharedInstance]];
    [_router map:@"home"		toClass:[A0_HomeBoard_iPhone class]];
    [_router map:@"publish"		toClass:[E0_PublishedOrdersBoard_iPhone class]];
    [_router map:@"receive"		toClass:[E2_ReceivedOrdersBoard_iPhone class]];
    [_router map:@"apply"		toClass:[F10_ApplyBoard_iPhone class]];
    [_router map:@"message"		toClass:[H0_MessageBoard_iPhone class]];
    [_router map:@"fifth"		toClass:[A0_HomeBoard_iPhone class]];
    [_router map:@"refferal"	toClass:[F4_RefferalBoard_iPhone class]];
    [_router map:@"order"	toClass:[D1_OrderBoard_iPhone class]];
    [_router map:@"comment"	toClass:[D4_OrderCommentListBoard_iPhone class]];
    
    _router.view.layer.shadowOpacity = 0.5f;
	_router.view.layer.shadowRadius = 2.5f;
	_router.view.layer.shadowOffset = CGSizeMake(-2.0f, 0.0f);
	_router.view.layer.shadowColor = [UIColor blackColor].CGColor;
	_router.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
	[self.view addSubview:_router.view];
	
    _leftMenuShown	= NO;
	_menuAnimating	= NO;
    
    [self checkMenus];
    
    [self observeNotification:UserModel.LOGIN];
	[self observeNotification:UserModel.LOGOUT];
	[self observeNotification:UserModel.RELOGIN];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:UserModel.LOGIN];
	[self unobserveNotification:UserModel.LOGOUT];
	[self unobserveNotification:UserModel.RELOGIN];
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    // TODO: add function (update device token)
}

ON_DID_APPEAR( signal )
{
    if ( _menuPannable )
	{
		_router.view.pannable = YES;
	}

	if ( self.firstEnter )
	{
		[_router open:@"home" animated:NO];
	}

    if ( NO == bee.ext.userModel.online )
    {
        [self showLogin];
    }
}

ON_WILL_DISAPPEAR( signal )
{
    _router.view.pannable = NO;
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

- (void)checkMenus
{
	if ( nil == _leftMenu )
	{
		_leftMenu = [A2_MenuBoard_iPhone sharedInstance];
		_leftMenu.view.hidden = YES;
		_leftMenu.view.frame = CGRectMake( 0, 0, self.viewWidth, self.viewHeight );
		_leftMenu.parentBoard = self;
		[self.view addSubview:_leftMenu.view];
	}
	
	_leftMenu.view.frame = CGRectMake( 0, 0, self.viewWidth, self.viewHeight );
    
    [self.view bringSubviewToFront:_leftMenu.view];
    [self.view bringSubviewToFront:_router.view];
}

#pragma mark - UIView Pan Events

ON_SIGNAL2( UIView, signal )
{
    if ( [signal is:UIView.PAN_START]  )
    {
        _menuPanning = YES;
        
		[self checkMenus];
		
		for ( BeeUIStack * stack in _router.stacks )
		{
			stack.view.userInteractionEnabled = NO;
		}
    }
    else if ( [signal is:UIView.PAN_CHANGED]  )
    {
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_STOP] || [signal is:UIView.PAN_CANCELLED] )
    {
        _menuPanning = NO;
        _leftMenuPanning = NO;
        
        if ( _menuAnimating )
            return;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3f];
        
		if ( _router.view.left <= DRAG_BOUNDS )
		{
			_router.view.left = 0;
			
			CATransform3D transform = CATransform3DIdentity;
			transform.m34 = -(1.0f / 1000.0f);
			transform = CATransform3DTranslate( transform, -40.0f, 0, 0.0f );
			
			_leftMenu.view.layer.transform = transform;
			_leftMenu.view.alpha = 0.0f;
			_leftMenuShown = NO;
			
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didLeftMenuHidden)];
		}
		else
		{
			_router.view.left = MENU_BOUNDS;
			
			_leftMenu.view.layer.transform = CATransform3DIdentity;
			_leftMenu.view.alpha = 1.0f;
			_leftMenuShown = YES;
			
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didLeftMenuShown)];
		}
		
		[UIView commitAnimations];
    }
	else if ( [signal is:UIView.TAPPED]  )
    {
        if ( _menuAnimating )
            return;
		
		[self hideLeftMenu];
	}
}

- (void)syncPanPosition:(CGPoint)offset
{
	if ( NO == _menuPannable )
		return;
    
	if ( offset.x < 0.0f )
	{
		[self hideLeftMenu];
		
	}
	else if ( offset.x > 0.0f )
	{
		if ( offset.x > 100.0f )
		{
			[self showLeftMenu];
		}
	}
}

- (void)syncPanPosition
{
	[self syncPanPosition:_router.view.panOffset];
}

#pragma mark - menuPannable

- (BOOL)menuPannable
{
	return _menuPannable;
}

- (void)setMenuPannable:(BOOL)flag
{
	_router.view.pannable = flag;
	_menuPannable = flag;
}

#pragma mark - menuShown

- (BOOL)menuShown
{
	return _leftMenuShown ;
}

- (void)setMenuShown:(BOOL)flag
{
	if ( flag )
	{
		[self showLeftMenu];
	}
	else
	{
		[self hideLeftMenu];
	}
}

#pragma mark - Left Menu

- (void)didLeftMenuHidden
{
	_menuAnimating = NO;
	
	_leftMenuShown = NO;
	_leftMenu.view.layer.transform = CATransform3DIdentity;
	
    for ( BeeUIStack * stack in _router.stacks )
    {
        stack.view.userInteractionEnabled = YES;
    }

	[self postNotification:self.LEFT_MENU_CLOSED];
    
	_router.view.tappable = NO;
}

- (void)didLeftMenuShown
{
	_menuAnimating = NO;
	
	_leftMenuShown = YES;
	_leftMenu.view.hidden = NO;
    
	for ( BeeUIStack * stack in _router.stacks )
	{
		stack.view.userInteractionEnabled = NO;
	}
    
	[self postNotification:self.LEFT_MENU_OPENED];
    
	_router.view.tappable = YES;
}

- (void)showLeftMenu
{
	if ( _leftMenuShown )
		return;
	
	if ( _menuAnimating )
		return;
	
	[self checkMenus];
    
	_menuAnimating = YES;
	
	_leftMenu.view.hidden = NO;
	
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 1000.0f);
	transform = CATransform3DTranslate( transform, -40.0f, 0, 0.0f );
	
	_leftMenu.view.layer.transform = transform;
	_leftMenu.view.alpha = 0.0f;
    
	[UIView beginAnimations:nil context:nil];
    //	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didLeftMenuShown)];
	
	_router.view.left = MENU_BOUNDS;
	
	_leftMenu.view.layer.transform = CATransform3DIdentity;
	_leftMenu.view.alpha = 1.0f;
    
	[UIView commitAnimations];
	
	_leftMenuShown = YES;
	_leftMenuPanning = _menuPanning ? YES : NO;
    
    self.menuPannable = YES;
}

- (void)hideLeftMenu
{
	if ( NO == _leftMenuShown || nil == _leftMenu )
		return;
	
	if ( _menuAnimating )
		return;
    
	_menuAnimating = YES;
	
	_leftMenu.view.layer.transform = CATransform3DIdentity;
	_leftMenu.view.alpha = 1.0f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didLeftMenuHidden)];
    
	_router.view.left = 0.0f;
	
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -(1.0f / 1000.0f);
	transform = CATransform3DTranslate( transform, -40.0f, 0, 0.0f );
	
	_leftMenu.view.layer.transform = transform;
	_leftMenu.view.alpha = 0.0f;
	
	[UIView commitAnimations];
	
	_leftMenuShown = NO;
	_leftMenuPanning = _menuPanning ? YES : NO;
}

#pragma mark - A2_MenuBoardCell_iPhone

ON_SIGNAL3( A2_MenuBoardCell_iPhone, profile, signal )
{
    [_router open:@"profile" animated:NO];
	
	[self hideLeftMenu];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, home, signal )
{
    [_router open:@"home" animated:NO];
	
	[self hideLeftMenu];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, publish, signal )
{
    [_router open:@"publish" animated:NO];
	
	[self hideLeftMenu];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, receive, signal )
{
    USER * user = bee.ext.userModel.user;
    if ( user )
    {
        switch ( user.user_group.intValue )
        {
            case USER_GROUP_NEWBEE:
            {
                [self presentMessageTips:__TEXT(@"please_buy_authorized_edition")];
                [_router open:@"apply" animated:NO];
            }
                break;
            case USER_GROUP_FREEMAN_INREVIEW:
            {
            }
                break;
            case USER_GROUP_FREEMAN:
            {
                [_router open:@"receive" animated:NO];
            }
                break;
            default:
                break;
        }
    }
    
	[self hideLeftMenu];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, message, signal )
{
    [_router open:@"message" animated:NO];
	
	[self hideLeftMenu];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, fifth, signal )
{
    [_router open:@"fifth" animated:NO];
	
	[self hideLeftMenu];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, refferal, signal )
{
    [_router open:@"refferal" animated:NO];
	
	[self hideLeftMenu];
}

#pragma mark -

- (void)showLogin
{
	[self hideLeftMenu];
	
    if ( nil == self.modalStack )
	{
		[self presentModalStack:[BeeUIStack stackWithFirstBoard:[B0_SigninBoard_iPhone board]] animated:YES];
	}
}

- (void)hideLogin
{
    if ( self.modalStack )
	{
		[self dismissModalStackAnimated:YES];
	}
    
	[self hideLeftMenu];
}

- (void)openHomeBoard
{
	[_router open:@"home" animated:YES];
	
	[self hideLeftMenu];
}

- (void)openMessageBoard
{
	[_router open:@"message" animated:YES];
	
	[self hideLeftMenu];
}

#pragma mark -

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
    [self openHomeBoard];
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
	// TODO: add function (update device token)
}

ON_NOTIFICATION3( UserModel, RELOGIN, notification )
{
	[self hideLeftMenu];
	
	[self showLogin];
    
    [_router.currentStack popToFirstBoardAnimated:NO];
}

#pragma mark - Push Notification

ON_SIGNAL3( AppBoard_iPhone, NOTIFY, signal )
{
    // TODO: add function (push message action)
}

#pragma mark -

+ (void)openTelephone:(NSString *)telephone
{
    if ( telephone )
    {
        NSString * str = [[telephone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", str]];
        
        if ( [[UIApplication sharedApplication] canOpenURL:url] )
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            [self presentFailureTips:[NSString stringWithFormat:@"无法拨打\n%@", telephone]];
        }
    }
    else
    {
        [self presentFailureTips:@"无法拨打电话"];
    }
}

@end

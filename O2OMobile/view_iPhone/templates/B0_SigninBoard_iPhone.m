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

#import "B0_SigninBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "B0_SigninCell_iPhone.h"
#import "B1_SignupVerifyBoard_iPhone.h"
#import "ErrorMsg.h"

@implementation B0_SigninBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( UserModel, userModel )

- (void)load
{
    self.userModel = [UserModel sharedInstance];
    [self.userModel addObserver:self];
}

- (void)unload
{
    [self.userModel removeObserver:self];
    [self.userModel cancelMessages];
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
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
        item.clazz = [B0_SigninCell_iPhone class];
        item.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        item.section = 0;
    };
    
    [self observeNotification:BeeUIKeyboard.SHOWN];
    [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self observeNotification:BeeUIKeyboard.HIDDEN];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:BeeUIKeyboard.SHOWN];
    [self unobserveNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self unobserveNotification:BeeUIKeyboard.HIDDEN];
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.list reloadData];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [self.view endEditing:YES];
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

#pragma mark - BeeUITextField

ON_SIGNAL2( BeeUITextField, signal )
{
    BeeUITextField * input = (BeeUITextField *)signal.source;
    
    if ( [signal is:BeeUITextField.RETURN] )
    {
        B0_SigninCell_iPhone * cell = (B0_SigninCell_iPhone * )signal.sourceCell;
        
        if ( [cell.mobilePhone isFirstResponder] )
        {
            [cell.password becomeFirstResponder];
            
            return;
        }
		else if ( UIReturnKeyDone == input.returnKeyType )
        {
            [self.view endEditing:YES];
            [self doLogin];
        }
    }
    else if ( [signal is:BeeUITextField.WILL_ACTIVE] )
    {
    }
}

ON_NOTIFICATION2( BeeUIKeyboard , notification )
{
    if ( [notification is:BeeUIKeyboard.SHOWN])
    {
        CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
        [UIView animateWithDuration:0.35f animations:^{
            [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
        }];
    }
    else if ([notification is:BeeUIKeyboard.HEIGHT_CHANGED])
    {
        CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
        [UIView animateWithDuration:0.35f animations:^{
            [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
        }];
    }
    else if ( [notification is:BeeUIKeyboard.HIDDEN] )
    {
        [UIView animateWithDuration:0.35f animations:^{
            [self.list setBaseInsets:UIEdgeInsetsZero];
        }];
    }
}

#pragma mark -

ON_SIGNAL3( B0_SigninCell_iPhone, back, signal )
{
    [[AppBoard_iPhone sharedInstance] hideLogin];
}

ON_SIGNAL3( B0_SigninCell_iPhone, signin, signal )
{
    [self.view endEditing:YES];
    [self doLogin];
}

ON_SIGNAL3( B0_SigninCell_iPhone, signup, signal )
{
    [self.stack pushBoard:[B1_SignupVerifyBoard_iPhone board] animated:YES];
}

#pragma mark -

- (void)doLogin
{
    B0_SigninCell_iPhone * cell = (B0_SigninCell_iPhone *)((BeeUIScrollItem *)self.list.items[0]).view;
    if ( nil == cell )
        return;

    NSString * mobilePhone = cell.mobilePhone.text.trim;
    NSString * password = cell.password.text.trim;
    
    if ( NO == [mobilePhone isMobilephone] )
    {
        [self presentMessageTips:__TEXT(@"wrong_mobile_phone")];
        
        cell.mobilePhone.text = @"";
        [cell.mobilePhone becomeFirstResponder];
        
        return;
    }
    
    if ( password.length < 6 )
    {
        [self presentMessageTips:__TEXT(@"please_enter_correct_password_format")];
        
        cell.password.text = @"";
        [cell.password becomeFirstResponder];
        
        return;
    }
    
    if ( password.length > 20 )
    {
        [self presentMessageTips:__TEXT(@"please_enter_correct_password_format")];
        
        cell.password.text = @"";
        [cell.password becomeFirstResponder];
        
        return;
    }
    
    [self.userModel signinWithMobilePhone:mobilePhone
                                 password:password];
}

#pragma mark - UserModel

ON_SIGNAL3( UserModel, LOADING, signal )
{
    [self presentLoadingTips:@"正在登录..."];
}

ON_SIGNAL3( UserModel, SIGNIN_SUCCEED, signal )
{
    [self dismissTips];
    [self.view.window presentSuccessTips:@"登录成功"];
    
    [[AppBoard_iPhone sharedInstance] hideLogin];
}

ON_SIGNAL3( UserModel, SIGNIN_FAILED, signal )
{
    [self dismissTips];
    
//    B0_SigninCell_iPhone * cell = (B0_SigninCell_iPhone *)((BeeUIScrollItem *)self.list.items[0]).view;
//    if ( nil == cell )
//        return;
//    
//    NSNumber * errorCode = signal.object;
//    
//    switch ( errorCode.intValue )
//    {
//            
//        case ErrorMsgCodeMobileNotExists:
//        {
//            [cell.mobilePhone becomeFirstResponder];
//        }
//            break;
//        case ErrorMsgCodePasswordError:
//        {
//            [cell.password becomeFirstResponder];
//        }
//            break;
//            
//        default:
//            break;
//    }
}

@end

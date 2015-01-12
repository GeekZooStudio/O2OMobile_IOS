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

#import "B2_SignupBoard_iPhone.h"
#import "B2_SignupCell_iPhone.h"
#import "AppBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"
#import "AppConfig.h"

#pragma mark -

@interface B2_SignupBoard_iPhone ()
{
    float _operateZoneHeight;
}
@end

#pragma mark -

@implementation B2_SignupBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( UserModel, userModel )

@synthesize mobilePhone = _mobilePhone;

- (void)load
{
    self.userModel = [UserModel sharedInstance];
    [self.userModel addObserver:self];
    
    _operateZoneHeight = self.viewHeight - [BeeUIKeyboard sharedInstance].height;
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
        item.size = CGSizeMake( self.list.width, 548 );
        item.clazz = [B2_SignupCell_iPhone class];
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
        B2_SignupCell_iPhone * item = (B2_SignupCell_iPhone * )signal.sourceCell;
        
        if ( [item.name isFirstResponder] )
        {
            [item.password becomeFirstResponder];
            return;
        }
        else if ( [item.password isFirstResponder] )
        {
            [item.confirmPassword becomeFirstResponder];
            return;
        }
//        else if ( [item.confirmPassword isFirstResponder] )
//        {
//            [item.inviteCode becomeFirstResponder];
//            return;
//        }
		else if ( UIReturnKeyDone == input.returnKeyType )
        {
            [self.view endEditing:YES];
            [self doSignup];
        }
    }
    else if ( [signal is:BeeUITextField.WILL_ACTIVE] )
    {
        float offsetY = 0.0f;
        if ( ( input.frame.origin.y + input.height ) > _operateZoneHeight )
        {
            offsetY = ( input.frame.origin.y + input.height * 2.5 + [BeeUIKeyboard sharedInstance].height )
            - ( self.viewHeight);
        }
        
        [UIView animateWithDuration:0.35f animations:^{
            [self.list setContentOffset:CGPointMake( 0, offsetY )];
        }];

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
        
        _operateZoneHeight = self.viewHeight - keyboardHeight;
    }
    else if ([notification is:BeeUIKeyboard.HEIGHT_CHANGED])
    {
        CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
        [UIView animateWithDuration:0.35f animations:^{
            [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
        }];
        
        _operateZoneHeight = self.viewHeight - keyboardHeight;
    }
    else if ( [notification is:BeeUIKeyboard.HIDDEN] )
    {
        [UIView animateWithDuration:0.35f animations:^{
            [self.list setBaseInsets:UIEdgeInsetsZero];
        }];
    }
}

#pragma mark - B2_SignupCell_iPhone

ON_SIGNAL3( B2_SignupCell_iPhone, back, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( B2_SignupCell_iPhone, signup, signal )
{
    [self.view endEditing:YES];
    [self doSignup];
}

ON_SIGNAL3( B2_SignupCell_iPhone, statement, signal )
{
//    WebViewBoard_iPhone * board = [WebViewBoard_iPhone board];
//    board.urlString = [NSString stringWithFormat:@"%@/reg_agreement.html",[ServerConfig sharedInstance].webUrl];
//    board.isToolbarHiden = YES;
//    board.defaultTitle = @"注册协议";
//    board.isPreviousNavbarHidden = YES;
//    [self.stack pushBoard:board animated:YES];
}

#pragma mark -

- (void)doSignup
{
    B2_SignupCell_iPhone * cell = (B2_SignupCell_iPhone *)((BeeUIScrollItem *)self.list.items[0]).view;
    if ( nil == cell )
        return;
    
    NSString * name = cell.name.text.trim;
    NSString * password = cell.password.text.trim;
    NSString * confirmPassword = cell.confirmPassword.text.trim;
    NSString * inviteCode = cell.inviteCode.text.trim;
    
    if ( name.length == 0 )
    {
        [self presentMessageTips:__TEXT(@"please_input_nickname")];
        
         cell.name.data = @"";
        [cell.name becomeFirstResponder];
        
        return;
    }
    
    if ( name.length > 16 )
    {
        [self presentMessageTips:__TEXT(@"nickname_wrong_format_hint")];
        
         cell.name.data = @"";
        [cell.name becomeFirstResponder];
        
        return;
    }
    
    if ( password.length < 6 )
    {
        [self presentMessageTips:__TEXT(@"password_wrong_format_hint")];
        
         cell.password.data = @"";
        [cell.password becomeFirstResponder];
        
        return;
    }
    
    if ( password.length > 20 )
    {
        [self presentMessageTips:__TEXT(@"password_wrong_format_hint")];
        
         cell.password.data = @"";
        [cell.password becomeFirstResponder];
        
        return;
    }
    
    if ( NO == [password isEqualToString:confirmPassword] )
    {
        [self presentMessageTips:__TEXT(@"two_passwords_differ_hint")];
        
         cell.confirmPassword.data = @"";
        [cell.confirmPassword becomeFirstResponder];
        
        return;
    }
    
//    if ( inviteCode.length == 0 )
//    {
//        [self presentMessageTips:@"邀请码不能为空"];
//        
//         cell.inviteCode.data = @"";
//        [cell.inviteCode becomeFirstResponder];
//        
//        return;
//    }
    
    [self.userModel signupWithMobilePhone:self.mobilePhone
                                 password:password
                                 nickname:name
                               inviteCode:inviteCode];
}

#pragma mark - UserModel

ON_SIGNAL3( UserModel, LOADING, signal )
{
    [self presentLoadingTips:@"正在注册..."];
}

ON_SIGNAL3( UserModel, SIGNUP_SUCCEED, signal )
{
    [self dismissTips];
    [self.view.window presentSuccessTips:@"注册成功"];
    
    [[AppBoard_iPhone sharedInstance] hideLogin];
}

ON_SIGNAL3( UserModel, SIGNUP_FAILED, signal )
{
    [self dismissTips];
}

@end

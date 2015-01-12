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

#import "C13_EditPasswordBoard_iPhone.h"

#import "AppBoard_iPhone.h"

#pragma mark -

@implementation C13_EditPasswordBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( C13_EditPasswordBoard_iPhone )

DEF_OUTLET( BeeUITextField, old_password );
DEF_OUTLET( BeeUITextField, new_password );
DEF_OUTLET( BeeUITextField, new_password2 );

@synthesize backWhenSucceed = _backWhenSucceed;
@synthesize userModel = _userModel;

- (void)load
{
	self.userModel = [UserModel sharedInstance];
	[self.userModel addObserver:self];
}

- (void)unload
{
	[self.userModel removeObserver:self];
	self.userModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationBarShown = YES;
	self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
	self.navigationBarTitle = __TEXT(@"change_login_password");
	self.navigationBarRight = __TEXT(@"save");
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	[AppBoard_iPhone sharedInstance].menuPannable = NO;
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
	[self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
	if ( nil == self.old_password.text || self.old_password.text.length == 0 )
	{
		[self presentMessageTips:__TEXT(@"input_old_password")];
		[self.old_password becomeFirstResponder];
		return;
	}

	if ( nil == self.new_password.text || self.new_password.text.length == 0 )
	{
		[self presentMessageTips:__TEXT(@"input_new_password")];
		[self.new_password becomeFirstResponder];
		return;
	}

	if ( NO == [self.new_password.text isEqualToString:self.new_password2.text] )
	{
		[self presentMessageTips:__TEXT(@"please_enter_correct_password_format")];
		[self.new_password2 becomeFirstResponder];
		return;
	}

	[self.userModel changePassword:self.new_password.text
					   oldPassword:self.old_password.text];
}

#pragma MARK -

ON_SIGNAL3( UserModel, PASSWORD_CHANGING, signal )
{
	[self presentLoadingTips:@"正在提交..."];
	
	[self.old_password resignFirstResponder];
	[self.new_password resignFirstResponder];
}

ON_SIGNAL3( UserModel, PASSWORD_SUCCEED, signal )
{
	[self dismissTips];
	[self.view.window presentSuccessTips:__TEXT(@"change_password_success")];

	if ( self.backWhenSucceed )
	{
		[self.stack popBoardAnimated:YES];
	}
}

ON_SIGNAL3( UserModel, PASSWORD_FAILED, signal )
{
	[self dismissTips];
}

@end

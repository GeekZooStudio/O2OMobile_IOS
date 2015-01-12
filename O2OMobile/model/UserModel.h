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

#import "O2OMobile.h"

#pragma mark -

AS_EXTERNAL( UserModel, userModel )

#pragma mark -

@interface UserModel : BeeOnceViewModel

@property (nonatomic, retain) INOUT NSString *	verifyCode;

@property (nonatomic, retain) OUT NSString *	sid;
@property (nonatomic, retain) OUT USER *		user;
@property (nonatomic, retain) OUT NSNumber *	balance;
@property (nonatomic, retain) OUT NSString *	inviteCode;

AS_SINGLETON( UserModel )

AS_SIGNAL( LOADING )
AS_SIGNAL( GETTING_VERIFYCODE )
AS_SIGNAL( VERIFYING )
AS_SIGNAL( GETTING_BALANCE )

AS_SIGNAL( SIGNIN_SUCCEED )
AS_SIGNAL( SIGNIN_FAILED )

AS_SIGNAL( SIGNOUT_SUCCEED )
AS_SIGNAL( SIGNOUT_FAILED )

AS_SIGNAL( GET_VERIFYCODE_FAILED )
AS_SIGNAL( GET_VERIFYCODE_SUCCEED )

AS_SIGNAL( GET_BALANCE_FAILED )
AS_SIGNAL( GET_BALANCE_SUCCEED )

AS_SIGNAL( VERIFY_FAILED )
AS_SIGNAL( VERIFY_SUCCEED )

AS_SIGNAL( SIGNUP_SUCCEED )
AS_SIGNAL( SIGNUP_FAILED )

AS_SIGNAL( PROFILE_UPDATING )
AS_SIGNAL( PROFILE_UPDATED )
AS_SIGNAL( PROFILE_FAILED )
AS_SIGNAL( PROFILE_BLOCKED )

AS_SIGNAL( AVATAR_UPDATING )
AS_SIGNAL( AVATAR_UPDATED )
AS_SIGNAL( AVATAR_FAILED )

AS_SIGNAL( PASSWORD_CHANGING )
AS_SIGNAL( PASSWORD_SUCCEED )
AS_SIGNAL( PASSWORD_FAILED )

AS_SIGNAL( CERTIFY_REQUESTING )
AS_SIGNAL( CERTIFY_SUCCEED )
AS_SIGNAL( CERTIFY_FAILED )

AS_SIGNAL( REPORT_REQUESTING )
AS_SIGNAL( REPORT_SUCCEED )
AS_SIGNAL( REPORT_FAILED )

AS_SIGNAL( FEEDBACK_SENDING )
AS_SIGNAL( FEEDBACK_SUCCEED )
AS_SIGNAL( FEEDBACK_FAILED )

AS_SIGNAL( INVITECODE_REQUESTING )
AS_SIGNAL( INVITECODE_SUCCEED )
AS_SIGNAL( INVITECODE_FAILED )

AS_NOTIFICATION( LOGIN )
AS_NOTIFICATION( LOGOUT )
AS_NOTIFICATION( RELOGIN )

- (void)signinWithMobilePhone:(NSString *)mobilePhone
                    password:(NSString *)password;

- (void)getVerifyCodeWithMobilePhone:(NSString *)mobilePhone;

- (void)verifyWithMobilePhone:(NSString *)mobilePhone
                   verifyCode:(NSString *)verifyCode;

- (void)signupWithMobilePhone:(NSString *)mobilePhone
                     password:(NSString *)password
                     nickname:(NSString *)nickname
                   inviteCode:(NSString *)inviteCode;

- (void)getUserBalance;
- (void)getProfile;
- (void)getInviteCode;

- (void)certifyWithName:(NSString *)name
			   identity:(NSString *)identity
			   bankcard:(NSString *)bankcard
				 gender:(NSNumber *)gender
				 avatar:(UIImage *)avatar;

- (void)changePassword:(NSString *)password
		   oldPassword:(NSString *)oldPassword;
- (void)changeNickName:(NSString *)name;
- (void)changeAvatar:(UIImage *)avatar;
- (void)changeSignature:(NSString *)text;
- (void)changeBrief:(NSString *)text;

- (void)reportWithUser:(NSNumber *)uid order:(NSNumber *)oid text:(NSString *)text;
- (void)feedback:(NSString *)feedback;

+ (BOOL)online;
- (BOOL)online;

- (BOOL)loading;
- (void)signout;

- (void)kickout;

@end

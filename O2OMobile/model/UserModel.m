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

#import "UserModel.h"

#pragma mark -

DEF_EXTERNAL( UserModel, userModel )

#pragma mark -

@implementation UserModel

DEF_SINGLETON( UserModel )

DEF_SIGNAL( LOADING )
DEF_SIGNAL( GETTING_VERIFYCODE )
DEF_SIGNAL( GETTING_BALANCE )
DEF_SIGNAL( VERIFYING )

DEF_SIGNAL( SIGNIN_SUCCEED )
DEF_SIGNAL( SIGNIN_FAILED )

DEF_SIGNAL( SIGNOUT_SUCCEED )
DEF_SIGNAL( SIGNOUT_FAILED )

DEF_SIGNAL( GET_VERIFYCODE_FAILED )
DEF_SIGNAL( GET_VERIFYCODE_SUCCEED )

DEF_SIGNAL( GET_BALANCE_FAILED )
DEF_SIGNAL( GET_BALANCE_SUCCEED )

DEF_SIGNAL( VERIFY_FAILED )
DEF_SIGNAL( VERIFY_SUCCEED )

DEF_SIGNAL( SIGNUP_SUCCEED )
DEF_SIGNAL( SIGNUP_FAILED )

DEF_SIGNAL( PROFILE_UPDATING )
DEF_SIGNAL( PROFILE_UPDATED )
DEF_SIGNAL( PROFILE_FAILED )
DEF_SIGNAL( PROFILE_BLOCKED )

DEF_SIGNAL( AVATAR_UPDATING )
DEF_SIGNAL( AVATAR_UPDATED )
DEF_SIGNAL( AVATAR_FAILED )

DEF_SIGNAL( PASSWORD_CHANGING )
DEF_SIGNAL( PASSWORD_SUCCEED )
DEF_SIGNAL( PASSWORD_FAILED )

DEF_SIGNAL( CERTIFY_REQUESTING )
DEF_SIGNAL( CERTIFY_SUCCEED )
DEF_SIGNAL( CERTIFY_FAILED )

DEF_SIGNAL( REPORT_REQUESTING )
DEF_SIGNAL( REPORT_SUCCEED )
DEF_SIGNAL( REPORT_FAILED )

DEF_SIGNAL( FEEDBACK_SENDING )
DEF_SIGNAL( FEEDBACK_SUCCEED )
DEF_SIGNAL( FEEDBACK_FAILED )

DEF_SIGNAL( INVITECODE_REQUESTING )
DEF_SIGNAL( INVITECODE_SUCCEED )
DEF_SIGNAL( INVITECODE_FAILED )

DEF_NOTIFICATION( LOGIN )
DEF_NOTIFICATION( LOGOUT )
DEF_NOTIFICATION( RELOGIN )

#pragma mark -

- (void)load
{
    [self loadCache];
}

- (void)unload
{
}

- (void)loadCache
{
    self.sid = [self userDefaultsRead:@"sid"];
    
    if ( self.sid )
    {
		self.user = [USER objectFromDictionary:[[self userDefaultsRead:@"user"] objectFromJSONString]];
    }
    
    self.inviteCode = [self userDefaultsRead:@"UserInviteCode"];
}

- (void)saveCache
{
    if ( [self.user.id isEqualToNumber:[UserModel sharedInstance].user.id ])
    {
        [self userDefaultsWrite:[self.user objectToString] forKey:@"user"];
        [self userDefaultsWrite:self.sid  forKey:@"sid"];
    }
    
    if ( self.inviteCode && self.inviteCode.length )
    {
        [self userDefaultsWrite:self.inviteCode forKey:@"UserInviteCode"];
    }
}

- (void)clearCache
{
	[self userDefaultsRemove:@"user"];
    [self userDefaultsRemove:@"sid"];
    [self userDefaultsRemove:@"UserInviteCode"];

    self.user = nil;
    self.sid = nil;
    self.inviteCode = nil;
}

#pragma mark -

+ (BOOL)online
{
    return [[UserModel sharedInstance] online];
}

- (BOOL)online
{
	return self.user ? YES : NO;
}

- (BOOL)loading
{
	return [API_USER_PROFILE sending];
}

- (void)signout
{
    [API_USER_SIGNIN cancel];
    [API_USER_SIGNUP cancel];
    [API_USER_VERIFYCODE cancel];
	[API_USER_SIGNOUT cancel];
	
    API_USER_SIGNOUT * api = [API_USER_SIGNOUT apiWithResponder:self];
    
    @weakify(api);
    
    api.req.uid = self.user.id;
    api.req.sid = self.sid;
    
    api.whenUpdate = ^
    {
		@normalize(api);
        
        if ( api.sending )
		{
			[self sendUISignal:self.LOADING];
		}
		else
        {
            if ( api.succeed  && api.resp.succeed.boolValue )
            {
                
                [self sendUISignal:self.SIGNOUT_SUCCEED];
                [self clearCache];
                
                [self postNotification:self.LOGOUT];
            }
            else
            {
                [self sendUISignal:self.SIGNOUT_FAILED withObject:api.resp.error_desc];
            }
        }
    };
    
    [api send];
}

- (void)kickout
{
    [API_USER_SIGNIN cancel];
    [API_USER_SIGNUP cancel];
    [API_USER_VERIFYCODE cancel];
	
	[self clearCache];
	
	[self postNotification:self.LOGOUT];
    [self postNotification:self.RELOGIN];
}

#pragma mark -

- (void)signinWithMobilePhone:(NSString *)mobilePhone
                     password:(NSString *)password
{
    [API_USER_SIGNIN cancel];
    
    API_USER_SIGNIN * api = [API_USER_SIGNIN apiWithResponder:self];
    
    @weakify(api);
    
    api.req.UUID = [BeeSystemInfo deviceUUID];
    api.req.platform = @"ios";
    api.req.location = [LocationModel sharedInstance].location;
    api.req.mobile_phone = mobilePhone;
    api.req.password = password;
    
    api.whenUpdate = ^
    {
		@normalize(api);
        
        if ( api.sending )
		{
			[self sendUISignal:self.LOADING];
		}
		else
        {
            if ( api.succeed  && api.resp.succeed.boolValue )
            {
                self.user = api.resp.user;
                self.sid = api.resp.sid;
				self.loaded = (self.user) ? YES : NO;
                
                bee.ext.configModel.config = api.resp.config;
                [bee.ext.configModel saveCache];
                
                [self sendUISignal:self.SIGNIN_SUCCEED];
				[self postNotification:self.LOGIN];
            }
            else
            {
                [self sendUISignal:self.SIGNIN_FAILED withObject:api.resp.error_code];
            }
        }
    };
    
    [api send];
}

- (void)getVerifyCodeWithMobilePhone:(NSString *)mobilePhone
{
    [API_USER_VERIFYCODE cancel];
    
    API_USER_VERIFYCODE * api = [API_USER_VERIFYCODE apiWithResponder:self];
    
    @weakify(api);
    
    api.req.mobile_phone = mobilePhone;
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.GETTING_VERIFYCODE];
        }
        else
        {
            if ( api.succeed  && api.resp.succeed.boolValue )
            {
                self.verifyCode = api.resp.verify_code;
                
                [self sendUISignal:self.GET_VERIFYCODE_SUCCEED];
            }
            else
            {
                [self sendUISignal:self.GET_VERIFYCODE_FAILED withObject:api.resp.error_code];
            }
        }
    };
    
    [api send];
}

- (void)verifyWithMobilePhone:(NSString *)mobilePhone
                   verifyCode:(NSString *)verifyCode
{
    [API_USER_VALIDCODE cancel];
    
    API_USER_VALIDCODE * api = [API_USER_VALIDCODE apiWithResponder:self];
    
    @weakify(api);
    
    api.req.mobile_phone = mobilePhone;
    api.req.verify_code = verifyCode;
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.VERIFYING];
        }
        else
        {
            if ( api.succeed  && api.resp.succeed.boolValue )
            {   
                [self sendUISignal:self.VERIFY_SUCCEED];
            }
            else
            {
                [self sendUISignal:self.VERIFY_FAILED withObject:api.resp.error_desc];
            }
        }
    };
    
    [api send];
}

- (void)signupWithMobilePhone:(NSString *)mobilePhone
                     password:(NSString *)password
                     nickname:(NSString *)nickname
                   inviteCode:(NSString *)inviteCode
{
    [API_USER_SIGNUP cancel];
    
    API_USER_SIGNUP * api = [API_USER_SIGNUP apiWithResponder:self];
    
    @weakify(api);
    
    api.req.mobile_phone = mobilePhone;
    api.req.password = password;
    api.req.nickname = nickname;
    api.req.invite_code = inviteCode;
    api.req.platform = @"ios";
    api.req.location = [LocationModel sharedInstance].location;
    
    api.whenUpdate = ^
    {
		@normalize(api);
        
        if ( api.sending )
		{
			[self sendUISignal:self.LOADING];
		}
		else
        {
            if ( api.succeed  && api.resp.succeed.boolValue )
            {
                self.user = api.resp.user;
                self.sid = api.resp.sid;
				self.loaded = (self.user) ? YES : NO;
                
                bee.ext.configModel.config = api.resp.config;
                [bee.ext.configModel saveCache];
                
                [self sendUISignal:self.SIGNUP_SUCCEED];
				[self postNotification:self.LOGIN];
            }
            else
            {
                [self sendUISignal:self.SIGNUP_FAILED withObject:api.resp.error_desc];
            }
        }
    };
    
    [api send];
}


- (void)getUserBalance
{
    [API_USER_BALANCE cancel];
    
    API_USER_BALANCE * api = [API_USER_BALANCE apiWithResponder:self];
    
    @weakify(api);
    
    api.req.uid = self.user.id;
    api.req.sid = self.sid;
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.GETTING_BALANCE];
        }
        else
        {
            if ( api.succeed  && api.resp.succeed.boolValue )
            {
                self.balance = @([api.resp.balance floatValue]);

                [self sendUISignal:self.GET_BALANCE_SUCCEED];
            }
            else
            {
                [self sendUISignal:self.GET_BALANCE_FAILED withObject:api.resp.error_desc];
            }
        }
    };
    
    [api send];
}

- (void)getProfile
{
	[API_USER_PROFILE cancel];
    
    API_USER_PROFILE * api = [API_USER_PROFILE apiWithResponder:self];
    
    @weakify(api);

    api.req.uid = self.user.id;
    api.req.sid = self.sid;
	api.req.user = self.user.id;

    api.whenUpdate = ^
    {
        @normalize(api);

        if ( api.sending )
        {
            [self sendUISignal:self.PROFILE_UPDATING];
        }
        else
        {
            if ( api.succeed  && api.resp.succeed.boolValue )
            {
				if ( api.resp.user )
				{
					self.user = api.resp.user;
					self.loaded = (self.user) ? YES : NO;
					
					[self sendUISignal:self.PROFILE_UPDATED];
				}
				else
				{
					[self sendUISignal:self.PROFILE_BLOCKED];
				}
            }
			else
			{
//				NSMutableArray * certs = [[[NSMutableArray alloc] init] autorelease];
//				
//				for ( int i = 0; i < 33; ++i )
//				{
//					MY_CERTIFICATION * cert = [[[MY_CERTIFICATION alloc] init] autorelease];
//					cert.id = @(i);
//					cert.certification = [[[CERTIFICATION alloc] init] autorelease];
//					cert.certification.id = @(i);
//					cert.certification.name = @"测试一下";
//					[certs addObject:cert];
//				}
//
//				self.user.my_certification = certs;
				
				[self sendUISignal:self.PROFILE_FAILED];
			}
        }
    };
    
    [api send];
}

- (void)getInviteCode
{
	[API_USER_INVITE_CODE cancel];
    
    API_USER_INVITE_CODE * api = [API_USER_INVITE_CODE apiWithResponder:self];

    @weakify(api);

    api.req.uid = self.user.id;
    api.req.sid = self.sid;
	
    api.whenUpdate = ^
    {
        @normalize(api);

        if ( api.sending )
        {
            [self sendUISignal:self.INVITECODE_REQUESTING];
        }
        else
        {
            if ( api.succeed  && api.resp.succeed.boolValue )
            {
				self.inviteCode = api.resp.invite_code;

				[self sendUISignal:self.INVITECODE_SUCCEED];
            }
			else
			{
				[self sendUISignal:self.INVITECODE_FAILED];
			}
        }
    };
    
    [api send];

}

- (void)certifyWithName:(NSString *)name
			   identity:(NSString *)identity
			   bankcard:(NSString *)bankcard
				 gender:(NSNumber *)gender
				 avatar:(UIImage *)avatar
{
	[API_USER_CERTIFY cancel];
    
    API_USER_CERTIFY * api = [API_USER_CERTIFY apiWithResponder:self];
    
    @weakify(api);
	
    api.req.uid = self.user.id;
    api.req.sid = self.sid;

	api.req.name = name;
	api.req.gender = gender;
	api.req.identity_card = identity;
	api.req.bankcard = bankcard;
	
	api.req.avatar = @"avatar.png";
	api.req.avatarImage = avatar;
	
    api.whenUpdate = ^
    {
        @normalize(api);

        if ( api.sending )
        {
            [self sendUISignal:self.CERTIFY_REQUESTING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
				self.user.user_group = @(USER_GROUP_FREEMAN_INREVIEW);
				
                [self sendUISignal:self.CERTIFY_SUCCEED];
            }
			else
			{
				[self sendUISignal:self.CERTIFY_FAILED];
			}
        }
    };
    
    [api send];
}

- (void)changePassword:(NSString *)password
		   oldPassword:(NSString *)oldPassword
{
	[API_USER_CHANGE_PASSWORD cancel];
    
    API_USER_CHANGE_PASSWORD * api = [API_USER_CHANGE_PASSWORD apiWithResponder:self];
    
    @weakify(api);
	
    api.req.uid = self.user.id;
    api.req.sid = self.sid;
	api.req.new_password = password;
	api.req.old_password = oldPassword;

    api.whenUpdate = ^
    {
        @normalize(api);
		
        if ( api.sending )
        {
            [self sendUISignal:self.PASSWORD_CHANGING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
                [self sendUISignal:self.PASSWORD_SUCCEED];
            }
			else
			{
				[self sendUISignal:self.PASSWORD_FAILED];
			}
        }
    };
	
    [api send];
}

- (void)changeNickName:(NSString *)name
{
	[API_USER_CHANGE_PROFILE cancel];
    
    API_USER_CHANGE_PROFILE * api = [API_USER_CHANGE_PROFILE apiWithResponder:self];
    
    @weakify(api);
	
    api.req.uid = self.user.id;
    api.req.sid = self.sid;
	api.req.nickname = name;

    api.whenUpdate = ^
    {
        @normalize(api);

        if ( api.sending )
        {
            [self sendUISignal:self.PROFILE_UPDATING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
				self.user = api.resp.user;
				
                [self sendUISignal:self.PROFILE_UPDATED];
            }
			else
			{
				[self sendUISignal:self.PROFILE_FAILED];
			}
        }
    };

    [api send];
}

- (void)changeAvatar:(UIImage *)avatar
{
	[API_USER_CHANGE_AVATAR cancel];
    
    API_USER_CHANGE_AVATAR * api = [API_USER_CHANGE_AVATAR apiWithResponder:self];
    
    @weakify(api);
	
    api.req.uid = self.user.id;
    api.req.sid = self.sid;
	api.req.avatar = @"avatar.png";
	api.req.avatarImage = avatar;

    api.whenUpdate = ^
    {
        @normalize(api);
		
        if ( api.sending )
        {
            [self sendUISignal:self.AVATAR_UPDATING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
				self.user = api.resp.user;
				
                [self sendUISignal:self.AVATAR_UPDATED];
            }
			else
			{
				[self sendUISignal:self.AVATAR_FAILED];
			}
        }
    };
	
    [api send];

}

- (void)changeSignature:(NSString *)text
{
	[API_USER_CHANGE_PROFILE cancel];
    
    API_USER_CHANGE_PROFILE * api = [API_USER_CHANGE_PROFILE apiWithResponder:self];
    
    @weakify(api);
	
    api.req.uid = self.user.id;
    api.req.sid = self.sid;
	api.req.signature = text;
	
    api.whenUpdate = ^
    {
        @normalize(api);
		
        if ( api.sending )
        {
            [self sendUISignal:self.PROFILE_UPDATING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
				self.user = api.resp.user;
				
                [self sendUISignal:self.PROFILE_UPDATED];
            }
			else
			{
				[self sendUISignal:self.PROFILE_FAILED];
			}
        }
    };
	
    [api send];
}

- (void)changeBrief:(NSString *)text
{
	[API_USER_CHANGE_PROFILE cancel];
    
    API_USER_CHANGE_PROFILE * api = [API_USER_CHANGE_PROFILE apiWithResponder:self];
    
    @weakify(api);
	
    api.req.uid = self.user.id;
    api.req.sid = self.sid;
	api.req.brief = text;

    api.whenUpdate = ^
    {
        @normalize(api);
		
        if ( api.sending )
        {
            [self sendUISignal:self.PROFILE_UPDATING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
				self.user = api.resp.user;
				
                [self sendUISignal:self.PROFILE_UPDATED];
            }
			else
			{
				[self sendUISignal:self.PROFILE_FAILED];
			}
        }
    };
	
    [api send];
}

- (void)reportWithUser:(NSNumber *)uid order:(NSNumber *)oid text:(NSString *)text
{
	[API_REPORT cancel];
    
    API_REPORT * api = [API_REPORT apiWithResponder:self];
    
    @weakify(api);
	
    api.req.uid = self.user.id;
    api.req.sid = self.sid;

    if ( uid )
    {
        api.req.user = uid;
    }
    
    if ( oid )
    {
        api.req.order_id = oid;
    }

	api.req.content = [[[CONTENT alloc] init] autorelease];
	api.req.content.text = text;

    api.whenUpdate = ^
    {
        @normalize(api);
		
        if ( api.sending )
        {
            [self sendUISignal:self.REPORT_REQUESTING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
                [self sendUISignal:self.REPORT_SUCCEED];
            }
			else
			{
				[self sendUISignal:self.REPORT_FAILED];
			}
        }
    };
    
    [api send];
}

- (void)feedback:(NSString *)feedback
{
	[API_FEEDBACK cancel];
    
    API_FEEDBACK * api = [API_FEEDBACK apiWithResponder:self];
    
    @weakify(api);

    api.req.uid = self.user.id;
    api.req.sid = self.sid;
	api.req.content = [[[CONTENT alloc] init] autorelease];
	api.req.content.text = feedback;

    api.whenUpdate = ^
    {
        @normalize(api);

        if ( api.sending )
        {
            [self sendUISignal:self.FEEDBACK_SENDING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
                [self sendUISignal:self.FEEDBACK_SUCCEED];
            }
			else
			{
				[self sendUISignal:self.FEEDBACK_FAILED];
			}
        }
    };
    
    [api send];
}

@end

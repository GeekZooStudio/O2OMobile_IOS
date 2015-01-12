//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
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

#import "ServiceShare_TencentOpen.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface ServiceShare_TencentOpen()
{
	NSNumber *						_errorCode;
	NSString *						_errorDesc;
	ServiceShare_TencentOpen_Config *	_config;
}

- (BOOL)checkInstalled;

- (void)clearPost;
- (void)clearError;

@end

#pragma mark -

@implementation ServiceShare_TencentOpen

SERVICE_AUTO_LOADING( YES )
SERVICE_AUTO_POWERON( NO )

DEF_SINGLETON( ServiceShare_TencentOpen )

DEF_NUMBER( ERROR_NOT_INSTALL, -100 )
DEF_NUMBER( ERROR_NOT_SUPPORT, -101 )

@synthesize config = _config;
@dynamic post;

@dynamic ready;
@dynamic installed;
@synthesize errorCode = _errorCode;
@synthesize errorDesc = _errorDesc;

@dynamic SHARE_TO_QQ;
@dynamic SHARE_TO_QZONE;

- (void)load
{
	self.state = self.STATE_IDLE;
	self.config = [[[ServiceShare_TencentOpen_Config alloc] init] autorelease];

	self.whenAuthBegin		= [ServiceShare sharedInstance].whenAuthBegin;
	self.whenAuthSucceed	= [ServiceShare sharedInstance].whenAuthSucceed;
	self.whenAuthFailed		= [ServiceShare sharedInstance].whenAuthFailed;
	self.whenAuthCancelled	= [ServiceShare sharedInstance].whenAuthCancelled;
	
	self.whenShareBegin		= [ServiceShare sharedInstance].whenShareBegin;
	self.whenShareSucceed	= [ServiceShare sharedInstance].whenShareSucceed;
	self.whenShareFailed	= [ServiceShare sharedInstance].whenShareFailed;
	self.whenShareCancelled	= [ServiceShare sharedInstance].whenShareCancelled;
}

- (void)unload
{
	self.config = nil;
	
//	[super unload];
}

#pragma mark -

- (void)powerOn
{
    self.tencentOAuth = [[[TencentOAuth alloc] initWithAppId:self.config.appId andDelegate:self] autorelease];
    
	[super powerOn];
}

- (void)powerOff
{
	[self clearError];
	[self clearPost];
	
	[super powerOff];
}

- (void)serviceWillActive
{
	[super serviceWillActive];

	if ( self.launchParameters )
	{
		NSURL * url			= [self.launchParameters objectForKey:@"url"];
		NSString * source	= [self.launchParameters objectForKey:@"source"];

		if ( [[url absoluteString] hasSuffix:@"wechat"] || [source hasPrefix:@"com.tencent.xin"] )
		{
            [QQApiInterface handleOpenURL:url delegate:self];
            
			BOOL succeed = [TencentOAuth CanHandleOpenURL:url];
			if ( NO == succeed )
			{
				if ( self.STATE_IDLE != self.state )
				{
					[self notifyShareCancelled];
				}
			}
		}
		else
		{
			if ( self.STATE_IDLE != self.state )
			{
				[self notifyShareCancelled];
			}
		}
	}
	else
	{
		if ( self.STATE_IDLE != self.state )
		{
			[self notifyShareCancelled];
		}
	}
}

- (void)serviceDidActived
{
	[super serviceDidActived];
}

- (void)serviceWillDeactive
{
	[super serviceWillDeactive];
}

- (void)serviceDidDeactived
{
	[super serviceDidDeactived];
}

- (ServiceShare_TencentOpen_Post *)post
{
    return [ServiceShare_TencentOpen_Post sharedInstance];
}

#pragma mark -

- (BOOL)ready
{
	if ( self.config.appId && self.config.appKey )
	{
		return YES;
	}

	return NO;
}

- (BOOL)installed
{
	return [TencentOAuth iphoneQQInstalled];
}

- (BeeServiceBlock)SHARE_TO_QQ
{
	BeeServiceBlock block = ^ void ( void )
	{
		[self share:TencentOpenSenceQQ];
	};
	
	return [[block copy] autorelease];
}

- (BeeServiceBlock)SHARE_TO_QZONE
{
	BeeServiceBlock block = ^ void ( void )
	{
        [self share:TencentOpenSenceQZone];
	};
	
	return [[block copy] autorelease];
}

#pragma mark -

- (BOOL)checkInstalled
{
	BOOL installed = [TencentOAuth iphoneQQInstalled];
	if ( NO == installed )
	{
		self.errorCode = self.ERROR_NOT_INSTALL;
		self.errorDesc = @"Please install tencentOpen";
		return NO;
	}
	
	BOOL support = [TencentOAuth iphoneQQSupportSSOLogin];
	if ( NO == support )
	{
		self.errorCode = self.ERROR_NOT_SUPPORT;
		self.errorDesc = @"Version too old";
		return NO;
	}

	return YES;
}

- (void)share:(TencentOpenSence)scene
{
	BOOL result = [self checkInstalled];
	if ( NO == result )
	{
		[self notifyShareFailed];
		return;
	}

	if ( self.post.photo || self.post.thumb || self.post.url )
	{
        QQApiNewsObject * newsObj = nil;
        
        if ( [self.post.photo isKindOfClass:[NSData class]] )
        {
            newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.post.url ? : @""]
                                               title:self.post.title ? : @""
                                         description:self.post.text ? : @""
                                    previewImageData:self.post.photo];
        }
        else if ( [self.post.photo isKindOfClass:[NSString class]] )
        {
            newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.post.url ? : @""]
                                               title:self.post.title ? : @""
                                         description:self.post.text ? : @""
                                     previewImageURL:self.post.photo];
        }
        else
        {
            newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.post.url ? : @""]
                                               title:self.post.title ? : @""
                                         description:self.post.text ? : @""
                                    previewImageData:nil];
        }
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
		
        QQApiSendResultCode sent = 0;
        
        if ( TencentOpenSenceQZone == scene )
        {
            //分享到QZone
            sent = [QQApiInterface SendReqToQZone:req];
        }
        else
        {
            //分享到QQ
            sent = [QQApiInterface sendReq:req];
        }
        
        [self handleSendResult:sent];
    }
    else
    {
        [self notifyShareFailed];
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        self.errorCode = @(sendResult);
        case EQQAPIAPPNOTREGISTED:
        {
            self.errorDesc = @"App未注册";
            [self notifyShareFailed];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            self.errorDesc = @"发送参数错误";
            [self notifyShareFailed];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            self.errorDesc = @"未安装手Q";
            [self notifyShareFailed];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            self.errorDesc = @"API接口不支持";
            [self notifyShareFailed];
            break;
        }
        case EQQAPISENDFAILD:
        {
            self.errorDesc = @"发送失败";
            [self notifyShareFailed];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            self.errorDesc = @"空间分享不支持纯文本分享，请使用图文分享";
            [self notifyShareFailed];
            break;
        }
        default:
            break;
    }
}

- (void)clearPost
{
    self.post.title = nil;
    self.post.text = nil;
    self.post.photo = nil;
    self.post.thumb = nil;
    self.post.url = nil;
}

- (void)clearError
{
	self.errorCode = nil;
	self.errorDesc = nil;
}

#pragma mark -

- (void)notifyShareBegin
{
	self.state = self.STATE_SHARING;

	if ( self.whenShareBegin )
	{
		self.whenShareBegin();
	}
	else if ( [ServiceShare sharedInstance].whenShareBegin )
	{
		[ServiceShare sharedInstance].whenShareBegin();
	}
}

- (void)notifyShareSucceed
{
	if ( self.whenShareSucceed )
	{
		self.whenShareSucceed();
	}
	else if ( [ServiceShare sharedInstance].whenShareSucceed )
	{
		[ServiceShare sharedInstance].whenShareSucceed();
	}

	[self clearError];
	[self clearPost];
	
	self.state = self.STATE_IDLE;
}

- (void)notifyShareFailed
{
	ERROR( @"Failed to share, errorCode = %@, errorDesc = %@", self.errorCode, self.errorDesc );

	if ( self.whenShareFailed )
	{
		self.whenShareFailed();
	}
	else if ( [ServiceShare sharedInstance].whenShareFailed )
	{
		[ServiceShare sharedInstance].whenShareFailed();
	}

	[self clearPost];

	self.state = self.STATE_IDLE;
}

- (void)notifyShareCancelled
{
	if ( self.whenShareCancelled )
	{
		self.whenShareCancelled();
	}
	else if ( [ServiceShare sharedInstance].whenShareCancelled )
	{
		[ServiceShare sharedInstance].whenShareCancelled();
	}

	[self clearPost];
	
	self.state = self.STATE_IDLE;
}

#pragma mark - WXApiDelegate

- (void)onReq:(QQBaseReq*)req
{
    
}

- (void)onResp:(QQBaseReq*)resp
{
    if ( [resp isKindOfClass:[SendMessageToQQResp class]] )
    {
//        if ( WXSuccess == resp.errCode )
        {
			[self notifyShareSucceed];
		}
//		else if ( WXErrCodeUserCancel == resp.errCode )
		{
			[self notifyShareCancelled];
		}
//		else
//		{
//			self.errorCode = [NSNumber numberWithInt:resp.errCode];
//			self.errorDesc = resp.errStr;
//			
//			[self notifyShareFailed];
//		}
    }
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

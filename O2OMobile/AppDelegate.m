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

#import "AppDelegate.h"
#import "AppBoard_iPhone.h"
#import "AppBoard_iPad.h"
#import "AppConfig.h"

#import "O2OMobile.h"

#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.weixin.h"
#import "bee.services.share.tencentopen.h"
#import "bee.services.location.h"
#import "bee.services.wizard.h"
#import "ServiceLocationConvertor.h"

#pragma mark -

@implementation AppDelegate

- (void)load
{
#if APP_DEVELOPMENT
	[ServerConfig sharedInstance].config = ServerConfig.CONFIG_DEVELOPMENT;
#else	// #if APP_DEVELOPMENT
	[ServerConfig sharedInstance].config = ServerConfig.CONFIG_PRODUCTION;
#endif	// #if APP_DEVELOPMENT

	bee.ui.config.ASR = YES;
	bee.ui.config.iOS6Mode = YES;
    
    [BeeUINavigationBar setBackgroundColor:HEX_RGB( 0xFFFFFF )];
    
    [BeeUINavigationBar setTitleFont:[UIFont systemFontOfSize:17.0f]];
	[BeeUINavigationBar setTitleColor:HEX_RGB( 0x39bced )];
    [BeeUINavigationBar setTitleShadowColor:[UIColor clearColor]];

	[BeeUINavigationBar setButtonFont:[UIFont systemFontOfSize:17.0f]];
	[BeeUINavigationBar setButtonColor:HEX_RGB(0x39bced)];
	
    if ( IOS7_OR_LATER )
	{
		[BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"b1_top_bg_128.png"]];
	}
	else
	{
		[BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"b1_top_bg_88.png"]];
	}

    // 配置闪屏    
    bee.services.wizard.config.splashes[0] = @"wizard_1.xml";
    bee.services.wizard.config.splashes[1] = @"wizard_2.xml";
    bee.services.wizard.config.splashes[2] = @"wizard_3.xml";
    
    bee.services.wizard.config.showPageControl = YES;
    bee.services.wizard.config.pageDotHighlighted = [UIImage imageNamed:@"b0_btn_page_on.png"];
    bee.services.wizard.config.pageDotNormal = [UIImage imageNamed:@"b0_btn_page_off.png"];

    // 配置分享
	bee.services.share.sinaweibo.config.appKey = SINAWEIBO_APP_KEY;
	bee.services.share.sinaweibo.config.appSecret = SINAWEIBO_APP_SECRET;
	bee.services.share.sinaweibo.config.redirectURI = SINAWEIBO_REDIRECT_URI;
	bee.services.share.sinaweibo.ON();

	bee.services.share.weixin.config.appId = WEIXIN_APP_ID;
	bee.services.share.weixin.config.appKey = WEIXIN_APP_KEY;
	bee.services.share.weixin.ON();

    bee.services.share.tencentOpen.config.appId = TENCENTOPEN_APP_ID;
	bee.services.share.tencentOpen.config.appKey = TENCENTOPEN_APP_KEY;
	bee.services.share.tencentOpen.ON();
       
    bee.services.location.systemMode = ServiceLocationSystemModeGCJ02;
	
//	if ( [BeeSystemInfo isDevicePad] )
//	{
//		self.window.rootViewController = [AppBoard_iPad sharedInstance];
//	}
//	else
	{
		self.window.rootViewController = [AppBoard_iPhone sharedInstance];
	}
}

- (void)unload
{
	
}

@end

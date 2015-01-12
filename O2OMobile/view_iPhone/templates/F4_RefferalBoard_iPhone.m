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

#import "F4_RefferalBoard_iPhone.h"
#import "F4_RefferalShareCell_iPhone.h"

#import "bee.services.share.h"
#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.weixin.h"

#import "AppBoard_iPhone.h"
#import "AppConfig.h"

#pragma mark -

@implementation F4_RefferalBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( F4_RefferalBoard_iPhone )

DEF_OUTLET( BeeUIWebView,					intro )
DEF_OUTLET( BeeUILabel,						code )
DEF_OUTLET( BeeUIButton,					share )
DEF_OUTLET( FXBlurView,						shareMask )
DEF_OUTLET( F4_RefferalShareCell_iPhone,	shareCell )

DEF_MODEL( UserModel,						userModel )

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
	self.navigationBarLeft = [UIImage imageNamed:@"b0_btn_menu.png"];
	self.navigationBarTitle = __TEXT(@"invite_firend");
	
	self.shareMask.alpha = 0.0f;
	self.shareMask.userInteractionEnabled = NO;
	self.shareMask.blurRadius = 5;
	self.shareMask.tintColor = [UIColor blackColor];
	
	self.shareCell.alpha = 0.0f;
	self.shareCell.userInteractionEnabled = NO;
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	[AppBoard_iPhone sharedInstance].menuPannable = YES;
    
	self.intro.resource = @"license.html";
	
	if ( self.userModel.inviteCode )
	{
		self.code.text = self.userModel.inviteCode;
	}
	else
	{
		self.code.text = @"";
	}
	
	if ( nil == self.userModel.inviteCode )
	{
        [self.userModel loadCache];
		[self.userModel getInviteCode];
	}
    
    [self.view endEditing:YES];
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
	[self hideShareThenToggleMenu];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

#pragma mark -

- (void)showShare
{
	[UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         $(self.shareCell).SET_CLASS( @"cell-show" ).RELAYOUT();
                         $(self.shareMask).SET_CLASS( @"mask-show" ).RELAYOUT();
                     }
                     completion:^(BOOL finished) {
                         self.shareCell.userInteractionEnabled = YES;
                         self.shareMask.userInteractionEnabled = YES;
                     }];
}

- (void)hideShare
{
	[UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         $(self.shareCell).SET_CLASS( @"cell-hide" ).RELAYOUT();
                         $(self.shareMask).SET_CLASS( @"mask-hide" ).RELAYOUT();
                     }
                     completion:^(BOOL finished) {
                         self.shareCell.userInteractionEnabled = NO;
                         self.shareMask.userInteractionEnabled = NO;
                     }];
}

- (void)hideShareThenToggleMenu
{
	if ( $(self.shareCell).HAS_CLASS( @"cell-show" ) )
	{
		[UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             $(self.shareCell).SET_CLASS( @"cell-hide" ).RELAYOUT();
                             $(self.shareMask).SET_CLASS( @"mask-hide" ).RELAYOUT();
                         } completion:^(BOOL finished) {
                             self.shareCell.userInteractionEnabled = NO;
                             self.shareMask.userInteractionEnabled = NO;
                             
                             [AppBoard_iPhone sharedInstance].menuShown = [AppBoard_iPhone sharedInstance].menuShown ? NO : YES;
                         }];
	}
	else
	{
		[AppBoard_iPhone sharedInstance].menuShown = [AppBoard_iPhone sharedInstance].menuShown ? NO : YES;
	}
}

#pragma mark -

ON_SIGNAL3( F4_RefferalBoard_iPhone, share, signal )
{
	[self showShare];
}

ON_SIGNAL3( F4_RefferalBoard_iPhone, shareMask, signal )
{
	[self hideShare];
}

#pragma mark -

ON_SIGNAL3( F4_RefferalShareCell_iPhone, weibo, signal )
{
	[self hideShare];
	
    [self presentMessageTips:__TEXT(@"please_buy_authorized_edition")];
    
//	ALIAS( bee.services.share.sinaweibo, weibo );
//    
//	weibo.post.text = __TEXT(@"share_content");
//	weibo.post.url = APP_ABOUT_US_URL;
//	
//	weibo.whenShareBegin = ^
//	{
//		[self presentLoadingTips:__TEXT(@"sharing")];
//	};
//	weibo.whenShareSucceed = ^
//	{
//		[self dismissTips];
//		[self presentSuccessTips:__TEXT(@"share_succeed")];
//	};
//	weibo.whenShareFailed = ^
//	{
//		[self dismissTips];
//		[self presentFailureTips:__TEXT(@"share_failed")];
//	};
//	weibo.whenShareCancelled = ^
//	{
//		[self dismissTips];
//	};
//	
//	weibo.SHARE();
}

ON_SIGNAL3( F4_RefferalShareCell_iPhone, weixin, signal )
{
	[self hideShare];
	
    [self presentMessageTips:__TEXT(@"please_buy_authorized_edition")];
    
//	ALIAS( bee.services.share.weixin, weixin );
//	
//    weixin.post.text = __TEXT(@"share_content");
//    weixin.post.url = APP_ABOUT_US_URL;
//	
//	weixin.whenShareBegin = ^
//	{
//		[self presentLoadingTips:__TEXT(@"sharing")];
//	};
//	weixin.whenShareSucceed = ^
//	{
//		[self dismissTips];
//		[self presentSuccessTips:__TEXT(@"share_succeed")];
//	};
//	weixin.whenShareFailed = ^
//	{
//		[self dismissTips];
//		[self presentFailureTips:__TEXT(@"share_failed")];
//	};
//	weixin.whenShareCancelled = ^
//	{
//		[self dismissTips];
//	};
//	
//	weixin.SHARE_TO_FRIEND();
}

ON_SIGNAL3( F4_RefferalShareCell_iPhone, sms, signal )
{
	[self hideShare];
    
	MFMessageComposeViewController * picker = [[MFMessageComposeViewController alloc] init];
	if ( picker )
	{
		picker.messageComposeDelegate = self;
        picker.body = __TEXT(@"share_content");
        
		[self presentViewController:picker
						   animated:YES
						 completion:nil];
	}
}

#pragma mark -

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
				 didFinishWithResult:(MessageComposeResult)result
{
	if ( MessageComposeResultCancelled == result )
	{
		[self presentSuccessTips:__TEXT(@"sms_send_canceled")];
	}
	else if ( MessageComposeResultSent == result )
	{
		[self presentSuccessTips:__TEXT(@"sms_send_succeed")];
	}
	else if ( MessageComposeResultFailed == result )
	{
		[self presentSuccessTips:__TEXT(@"sms_send_failed")];
	}
    
	[self dismissViewControllerAnimated:YES
							 completion:nil];
}

ON_SIGNAL3( F4_RefferalShareCell_iPhone, copy, signal )
{
	[self hideShare];
    
	UIPasteboard * board = [UIPasteboard generalPasteboard];
	board.string = __TEXT(@"share_content");
    
	[self presentSuccessTips:__TEXT(@"paste_tips")];
}

ON_SIGNAL3( F4_RefferalShareCell_iPhone, cancel, signal )
{
	[self hideShare];
}

#pragma mark -

ON_SIGNAL3( UserModel, INVITECODE_REQUESTING, signal )
{
	[self presentLoadingTips:__TEXT(@"invitecode_requesting")];
}

ON_SIGNAL3( UserModel, INVITECODE_SUCCEED, signal )
{
	[self dismissTips];
    
	self.code.text = self.userModel.inviteCode;
}

ON_SIGNAL3( UserModel, INVITECODE_FAILED, signal )
{
	[self dismissTips];
    
	self.code.text = @"";
    
	[self.view.window presentFailureTips:__TEXT(@"invitecode_request_failed")];
}

@end


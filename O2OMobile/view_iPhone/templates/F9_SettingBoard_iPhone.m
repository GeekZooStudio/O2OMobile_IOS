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

#import "F9_SettingBoard_iPhone.h"
#import "F9_SettingBoardCell_iPhone.h"
#import "C3_EditNameBoard_iPhone.h"
#import "C4_EditIntroBoard_iPhone.h"
#import "C12_EditSignatureBoard_iPhone.h"
#import "C13_EditPasswordBoard_iPhone.h"
#import "C14_MyServiceBoard_iPhone.h"
#import "C16_FeedbackBoard_iPhone.h"

#import "WebViewBoard_iPhone.h"

#import "AppBoard_iPhone.h"
#import "AppConfig.h"

#pragma mark -

@implementation F9_SettingBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( F9_SettingBoard_iPhone )

DEF_SIGNAL( SIGNOUT )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( UserModel, userModel )

- (void)load
{
    self.userModel = [UserModel sharedInstance];
    [self.userModel addObserver:self];
    
    self.configModel = [ConfigModel sharedInstance];
    [self.configModel addObserver:self];
}

- (void)unload
{
    [self.userModel removeObserver:self];
    [self.userModel cancelMessages];
    
    [self.configModel removeObserver:self];
    [self.configModel cancelMessages];
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationBarShown = YES;
	self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
	self.navigationBarTitle = __TEXT(@"setting");

	self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	
	@weakify( self )
	
	self.list.whenReloading = ^
	{
		@normalize( self );
		
		self.list.total = 1;

		BeeUIScrollItem * item = self.list.items[0];
		item.clazz = [F9_SettingBoardCell_iPhone class];
        item.data = self.userModel.user;
		item.size = CGSizeAuto;
	};
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
}

#pragma mark - F9_SettingBoardCell_iPhone

ON_SIGNAL3( F9_SettingBoardCell_iPhone, nickname, signal )
{
	C3_EditNameBoard_iPhone * board = [C3_EditNameBoard_iPhone board];
	board.backWhenSucceed = YES;
	[self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( F9_SettingBoardCell_iPhone, intro, signal )
{
	C4_EditIntroBoard_iPhone * board = [C4_EditIntroBoard_iPhone board];
	board.backWhenSucceed = YES;
	[self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( F9_SettingBoardCell_iPhone, signature, signal )
{
	C12_EditSignatureBoard_iPhone * board = [C12_EditSignatureBoard_iPhone board];
	board.backWhenSucceed = YES;
	[self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( F9_SettingBoardCell_iPhone, service, signal )
{
	C14_MyServiceBoard_iPhone * board = [C14_MyServiceBoard_iPhone board];
	[self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( F9_SettingBoardCell_iPhone, password, signal )
{
	C13_EditPasswordBoard_iPhone * board = [C13_EditPasswordBoard_iPhone board];
	board.backWhenSucceed = YES;
	[self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( F9_SettingBoardCell_iPhone, avatar, signal )
{
	BeeUIActionSheet * actionSheet = [[[BeeUIActionSheet alloc] init] autorelease];
	[actionSheet addButtonTitle:__TEXT(@"camera") signal:@"from_camera"];
	[actionSheet addButtonTitle:__TEXT(@"album") signal:@"from_album"];
	[actionSheet addCancelTitle:__TEXT(@"cancel")];
	[actionSheet presentForController:self];
}

ON_SIGNAL3( F9_SettingBoardCell_iPhone, sys_msg, signal )
{
	// TODO: add function (push switch)
}

ON_SIGNAL3( F9_SettingBoardCell_iPhone, feedback, signal )
{
	C16_FeedbackBoard_iPhone * board = [C16_FeedbackBoard_iPhone board];
	board.backWhenSucceed = YES;
	[self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( F9_SettingBoardCell_iPhone, about, signal )
{
	WebViewBoard_iPhone * board = [[[WebViewBoard_iPhone alloc] init] autorelease];
	board.defaultTitle = __TEXT(@"about_us");
	board.urlString = APP_ABOUT_US_URL;
	[self.stack pushBoard:board animated:YES];
}

ON_SIGNAL2( from_camera, signal )
{
	UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:picker animated:YES];
}

ON_SIGNAL2( from_album, signal )
{
	UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	if ( image )
	{
		image = [image scaleToSize:CGSizeMake(200, 200)];
		if ( image )
		{
			[self.userModel changeAvatar:image];	
		}
	}

	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

ON_SIGNAL3( F9_SettingBoardCell_iPhone, signout, signal )
{    
    BeeUIActionSheet * confirm = [BeeUIActionSheet spawn];
    [confirm addDestructiveTitle:@"退出登录" signal:self.SIGNOUT];
    [confirm addCancelTitle:__TEXT(@"cancel")];
    [confirm showInViewController:self];
}

#pragma mark - F9_SettingBoard_iPhone

ON_SIGNAL3( F9_SettingBoard_iPhone, SIGNOUT, signal )
{
    [self.userModel signout];
	   
//    [[AppBoard_iPhone sharedInstance] openHomeBoard];
//	[[AppBoard_iPhone sharedInstance] showLogin];
//	
//	[self.stack popToFirstBoardAnimated:NO];
}

#pragma mark -

ON_SIGNAL3( UserModel, AVATAR_UPDATING, signal )
{
	[self presentLoadingTips:__TEXT(@"please_later_on")];
}

ON_SIGNAL3( UserModel, AVATAR_UPDATED, signal )
{
	[self dismissTips];

	[self.view.window presentSuccessTips:__TEXT(@"change_avatar_success")];
}

ON_SIGNAL3( UserModel, AVATAR_FAILED, signal )
{
	[self dismissTips];
}

ON_SIGNAL3( UserModel, LOADING, signal )
{
    [self presentLoadingTips:@"正在登出..."];
}

ON_SIGNAL3( UserModel, SIGNOUT_SUCCEED, signal )
{
    [self dismissTips];
    [self.view.window presentSuccessTips:@"登出成功"];
    
    [[AppBoard_iPhone sharedInstance] openHomeBoard];
	[[AppBoard_iPhone sharedInstance] showLogin];
	
	[self.stack popToFirstBoardAnimated:NO];

}

ON_SIGNAL3( UserModel, SIGNOUT_FAILED, signal )
{
    [self dismissTips];
}

#pragma mark - ConfigModel

ON_SIGNAL3( ConfigModel, SWITCH_LOADING, signal )
{
}

ON_SIGNAL3( ConfigModel, SWITCH_FAILED, signal )
{
    [self.list reloadData];
}

@end

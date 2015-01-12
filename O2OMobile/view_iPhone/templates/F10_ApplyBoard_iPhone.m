//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//	Powered by BeeFramework
//
//
//  F1_MenuBoard_iPhone.m
//  ban
//
//  Created by purplepeng on 14-6-9.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "F10_ApplyBoard_iPhone.h"
#import "F10_ApplyBoardCell_iPhone.h"

#import "AppBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"
#import "AppConfig.h"

#pragma mark -

@interface F10_ApplyBoard_iPhone()

@property (nonatomic, assign) NSInteger		selectedGender;
@property (nonatomic, retain) UIImage *		selectedImage;

@end

#pragma mark -

@implementation F10_ApplyBoard_iPhone

@synthesize selectedGender = _selectedGender;
@synthesize selectedImage = _selectedImage;

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_SINGLETON( F10_ApplyBoard_iPhone )

@synthesize backWhenSucceed = _backWhenSucceed;
@synthesize userModel = _userModel;

- (void)load
{
	self.userModel = [UserModel sharedInstance];
	[self.userModel addObserver:self];
	
	self.backWhenSucceed = YES;
	self.selectedGender = USER_GENDER_MAN;
}

- (void)unload
{
	[self.userModel removeObserver:self];
	self.userModel = nil;
	
	self.selectedImage = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = HEX_RGB(0xf7f7f7);
	
	@weakify(self);
	
	self.list.whenReloading = ^
    {
        @normalize(self);

		NSMutableDictionary * dict = [NSMutableDictionary dictionary];

		dict[@"selectedGender"] = @(self.selectedGender);
		
		if ( self.selectedImage )
		{
			dict[@"selectedImage"] = self.selectedImage;
		}
		
        self.list.total = 1;
		self.list.firstItem.clazz = [F10_ApplyBoardCell_iPhone class];
		self.list.firstItem.data = dict;
		self.list.firstItem.size = CGSizeAuto;
    };
	
	[self observeNotification:BeeUIKeyboard.HIDDEN];
}

ON_DELETE_VIEWS( signal )
{
	[self unobserveNotification:BeeUIKeyboard.HIDDEN];
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	if ( self.stack.boards.count > 1 )
	{
		self.navigationBarShown = YES;
		self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
		self.navigationBarTitle = @"申请成为自由人";
		
		[AppBoard_iPhone sharedInstance].menuPannable = NO;
	}
	else
	{
		self.navigationBarShown = YES;
		self.navigationBarLeft = [UIImage imageNamed:@"b0_btn_menu.png"];
		self.navigationBarTitle = @"申请成为自由人";
		
		[AppBoard_iPhone sharedInstance].menuPannable = YES;
	}
	
	[self.list reloadData];
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
	if ( self.stack.boards.count > 1 )
	{
		[self.stack popBoardAnimated:YES];
	}
	else
	{
		[self.list endEditing:YES];
		
		[AppBoard_iPhone sharedInstance].menuShown = [AppBoard_iPhone sharedInstance].menuShown ? NO : YES;
	}
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

#pragma mark -

ON_SIGNAL3( F10_ApplyBoardCell_iPhone, select_gender, signal )
{
	[self.list endEditing:YES];

	BeeUIActionSheet * actionSheet = [[[BeeUIActionSheet alloc] init] autorelease];
	[actionSheet addButtonTitle:@"男" signal:@"man"];
	[actionSheet addButtonTitle:@"女" signal:@"woman"];
	[actionSheet addCancelTitle:@"取消"];
	[actionSheet presentForController:self];
}

ON_SIGNAL3( F10_ApplyBoardCell_iPhone, statement, signal )
{
    WebViewBoard_iPhone * board = [WebViewBoard_iPhone board];
    board.urlString = APP_ABOUT_US_URL;
    board.isToolbarHiden = YES;
    board.defaultTitle = @"注册协议";
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL2( man, signal )
{
	self.selectedGender = USER_GENDER_MAN;
	
	[self.list reloadData];
}

ON_SIGNAL2( woman, signal )
{
	self.selectedGender = USER_GENDER_WOMAN;
	
	[self.list reloadData];
}

#pragma mark -

ON_SIGNAL3( F10_ApplyBoardCell_iPhone, select_avatar, signal )
{
	[self.list endEditing:YES];

	BeeUIActionSheet * actionSheet = [[[BeeUIActionSheet alloc] init] autorelease];
	[actionSheet addButtonTitle:@"拍照" signal:@"from_camera"];
	[actionSheet addButtonTitle:@"相册选取" signal:@"from_album"];
	[actionSheet addCancelTitle:@"取消"];
	[actionSheet presentForController:self];
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
		image = [image scaleToSize:CGSizeMake(500, 500)];
		if ( image )
		{
			self.selectedImage = image;
		}
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
	[self.list reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
	
	[self.list reloadData];
}

#pragma mark -

ON_SIGNAL2( gender, signal )
{
	
}

ON_SIGNAL2( submit, signal )
{
	if ( nil == self.selectedImage )
	{
		[self presentMessageTips:@"请选择头像"];
		[self.view endEditing:YES];
		return;
	}

	F10_ApplyBoardCell_iPhone * cell = (F10_ApplyBoardCell_iPhone *)self.list.firstItem.view;
	
	if ( nil == cell.realname.text || cell.realname.text.length < 2 )
	{
		[self presentMessageTips:@"请输入正确的全名"];
		[cell.realname becomeFirstResponder];
		return;
	}
	
	if ( nil == cell.ident.text )
	{
		[self presentMessageTips:@"请输入正确的身份证号"];
		[cell.ident becomeFirstResponder];
		return;
	}
	
	if ( NO == [cell.ident.text match:@"^\\d{15}$"] &&
		NO == [cell.ident.text match:@"^\\d{18}$"] &&
		NO == [cell.ident.text match:@"^\\d{17}(\\d|X|x)$"] )
	{
		[self presentMessageTips:@"请输入正确的身份证号"];
		[cell.ident becomeFirstResponder];
		return;
	}

	if ( nil == cell.cardno.text || cell.cardno.text.length < 16 )
	{
		[self presentMessageTips:@"请输入正确的银行卡号"];
		[cell.cardno becomeFirstResponder];
		return;
	}

	[self.userModel certifyWithName:cell.realname.text
						   identity:cell.ident.text
						   bankcard:cell.cardno.text
							 gender:@(self.selectedGender)
							 avatar:self.selectedImage];
}

#pragma mark -

ON_SIGNAL3( BeeUITextField, DID_ACTIVED, signal )
{
	CGPoint offset = CGPointMake( 0, signal.sourceView.frame.origin.y - ([UIScreen mainScreen].bounds.size.height - [BeeUIKeyboard sharedInstance].height) / 2.0f );

	if ( offset.y < 0 )
	{
		offset.y = 0;
	}
	
	[self.list setContentOffset:offset animated:YES];
}

#pragma mark -

ON_NOTIFICATION3( BeeUIKeyboard, HIDDEN, notification )
{
	[self.list setContentOffset:CGPointZero animated:YES];
}

#pragma MARK -

ON_SIGNAL3( UserModel, CERTIFY_REQUESTING, signal )
{
	[self presentLoadingTips:@"正在提交..."];
}

ON_SIGNAL3( UserModel, CERTIFY_SUCCEED, signal )
{
	[self dismissTips];
	[self.view.window presentSuccessTips:@"申请已提交，请等待审核"];
	
	if ( self.backWhenSucceed )
	{
		[self.stack popBoardAnimated:YES];
	}
}

ON_SIGNAL3( UserModel, CERTIFY_FAILED, signal )
{
	[self dismissTips];
}

@end

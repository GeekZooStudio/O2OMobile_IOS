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

#import "F0_ProfileBoard_iPhone.h"
#import "F0_ProfileHeaderCell_iPhone.h"
#import "F0_ProfileIntroCell_iPhone.h"
#import "F0_ProfileSkillCell_iPhone.h"
#import "F0_ProfileSkillRowCell_iPhone.h"
#import "F0_ProfileSkillGroupCell_iPhone.h"
#import "F0_ProfileRateCell_iPhone.h"
#import "F0_ProfileServiceCell_iPhone.h"
#import "F0_ProfileHelpCell_iPhone.h"
#import "F0_ProfileApplyCell_iPhone.h"
#import "F0_ProfileApplyingCell_iPhone.h"

#import "F8_ReviewBoard_iPhone.h"
#import "F9_SettingBoard_iPhone.h"
#import "F10_ApplyBoard_iPhone.h"
#import "F11_IntroBoard_iPhone.h"

#import "F0_LargePhotoCell_iPhone.h"

#import "C1_PublishOrderBoard_iPhone.h"
#import "C15_EditPriceBoard_iPhone.h"

#import "G0_ReportBoard_iPhone.h"

#import "HeaderLoader_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation F0_ProfileBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( F0_ProfileBoard_iPhone )

DEF_OUTLET( BeeUIScrollView,		list )
DEF_OUTLET( BeeUIImageView,			navbar )
DEF_OUTLET( BeeUIButton,			left )
DEF_OUTLET( BeeUIButton,			right )

@synthesize uid = _uid;
@synthesize userModel = _userModel;
@synthesize serviceModel = _serviceModel;
@synthesize currentServiceType = _currentServiceType;

- (void)load
{
}

- (void)unload
{
	[self.serviceModel removeObserver:self];
	self.serviceModel = nil;

	[self.userModel removeObserver:self];
	self.userModel = nil;
}

- (BOOL)isMySelf
{
	return NO;
}

- (void)updateModelData
{
	self.userModel.user.id = self.uid ? self.uid : self.userModel.user.id;
	[self.userModel getProfile];
    
    if ( [self isMySelf] )
    {
        [self.userModel getUserBalance];
    }
    
	self.serviceModel.uid = self.userModel.user.id;
	[self.serviceModel firstPage];
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = [UIColor whiteColor];
	
    self.navigationBarShown = YES;

    self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	self.list.decelerationRate = 0.7f;

	self.navbar.alpha = 0.0f;
	
	@weakify( self )

	self.list.whenReloading = ^
	{
		@normalize( self );
		
		BeeUIScrollItem * item = nil;

		if ( self.firstEnter )
		{
			item = self.list.firstItem;
			item.clazz = [F0_ProfileHeaderCell_iPhone class];
			item.data = self.userModel;
			item.size = CGSizeAuto;
		}
		else
		{
			if ( [self isMySelf] )
			{
                if ( self.userModel.user.user_group.integerValue == USER_GROUP_NEWBEE )
                {
                    item = self.list.firstItem;
                    item.clazz = [F0_ProfileHeaderCell_iPhone class];
                    item.data = self.userModel;
                    item.size = CGSizeAuto;
                    
                    item = self.list.nextItem;
                    item.clazz = [F0_ProfileRateCell_iPhone class];
                    item.data = self.userModel;
                    item.size = CGSizeAuto;
                    
//                    item = self.list.nextItem;
//                    item.clazz = [F0_ProfileApplyCell_iPhone class];
//                    item.data = self.userModel;
//                    item.size = CGSizeAuto;
                }
                else if ( self.userModel.user.user_group.integerValue == USER_GROUP_FREEMAN_INREVIEW )
                {
                    item = self.list.firstItem;
                    item.clazz = [F0_ProfileHeaderCell_iPhone class];
                    item.data = self.userModel;
                    item.size = CGSizeAuto;
                    
                    item = self.list.nextItem;
                    item.clazz = [F0_ProfileRateCell_iPhone class];
                    item.data = self.userModel;
                    item.size = CGSizeAuto;
                    
                    item = self.list.nextItem;
                    item.clazz = [F0_ProfileApplyingCell_iPhone class];
                    item.data = self.userModel;
                    item.size = CGSizeAuto;
                }
                else if ( self.userModel.user.user_group.integerValue == USER_GROUP_FREEMAN )
                {
                    item = self.list.firstItem;
                    item.clazz = [F0_ProfileHeaderCell_iPhone class];
                    item.data = self.userModel;
                    item.size = CGSizeAuto;
                    
//                    item = self.list.nextItem;
//                    item.clazz = [F0_ProfileCashCell_iPhone class];
//                    item.data = self.userModel;
//                    item.size = CGSizeAuto;
                    
                    if ( self.userModel.user.brief && self.userModel.user.brief.length )
                    {
                        item = self.list.nextItem;
                        item.clazz = [F0_ProfileIntroCell_iPhone class];
                        item.data = self.userModel;
                        item.size = CGSizeAuto;
                    }
                    
                    if ( self.userModel.user.my_certification && self.userModel.user.my_certification.count )
                    {
                        item = self.list.nextItem;
                        item.clazz = [F0_ProfileSkillGroupCell_iPhone class];
                        item.data = self.userModel;
                        item.size = CGSizeAuto;
                    }
                    
                    item = self.list.nextItem;
                    item.clazz = [F0_ProfileRateCell_iPhone class];
                    item.data = self.userModel;
                    item.size = CGSizeAuto;
                    
                    for ( MY_SERVICE * service in self.serviceModel.services )
                    {
                        item = self.list.nextItem;
                        item.clazz = [F0_ProfileServiceCell_iPhone class];
                        item.data = service;
                        item.size = CGSizeAuto;
                    }
                }
                else
                {
                    item = self.list.firstItem;
                    item.clazz = [F0_ProfileHeaderCell_iPhone class];
                    item.data = self.userModel;
                    item.size = CGSizeAuto;
                }
			}
			else
			{
				item = self.list.firstItem;
				item.clazz = [F0_ProfileHeaderCell_iPhone class];
				item.data = self.userModel;
				item.size = CGSizeAuto;
				
				if ( self.userModel.user.brief && self.userModel.user.brief.length )
				{
					item = self.list.nextItem;
					item.clazz = [F0_ProfileIntroCell_iPhone class];
					item.data = self.userModel;
					item.size = CGSizeAuto;
				}
				
				if ( self.userModel.user.my_certification && self.userModel.user.my_certification.count )
				{
					item = self.list.nextItem;
					item.clazz = [F0_ProfileSkillGroupCell_iPhone class];
					item.data = self.userModel;
					item.size = CGSizeAuto;
				}
				
				item = self.list.nextItem;
				item.clazz = [F0_ProfileRateCell_iPhone class];
				item.data = self.userModel;
				item.size = CGSizeAuto;

				for ( MY_SERVICE * service in self.serviceModel.services )
				{
					item = self.list.nextItem;
					item.clazz = [F0_ProfileServiceCell_iPhone class];
					item.data = service;
					item.size = CGSizeAuto;
				}

				item = self.list.nextItem;
				item.clazz = [F0_ProfileHelpCell_iPhone class];
				item.data = self.userModel;
				item.size = CGSizeAuto;
			}
		}
	};
	
	self.list.whenScrolling = ^
	{
		@normalize( self );

		CGFloat alpha = 0.0f;
		
		if ( self.list.contentOffset.y > 0.0f )
		{
			if ( self.list.contentOffset.y >= self.navbar.frame.size.height )
			{
				alpha = 1.0f;
			}
			else
			{
				alpha = 1.0f - (self.navbar.frame.size.height - self.list.contentOffset.y) / self.navbar.frame.size.height;
			}
		}

		self.navbar.alpha = alpha * 0.8f;
	};

	self.list.whenDragged = ^
	{
		@normalize( self );

		if ( self.list.contentOffset.y < 60.0f )
		{
			[self updateModelData];
		}
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
	[self updateModelData];
	
	[AppBoard_iPhone sharedInstance].menuPannable = YES;
	
	[self hideNavigationBarAnimated:YES];

	if ( self.stack.boards.count > 1 )
	{
		self.left.image = [UIImage imageNamed:@"a3_btn_back.png"];
	}
	else
	{
		self.left.image = [UIImage imageNamed:@"menu_white.png"];
	}
	
	if ( [self isMySelf] )
	{
		self.right.image = [UIImage imageNamed:@"settings.png"];
		self.right.title = nil;
	}
	else
	{
		self.right.image = nil;
		self.right.title = __TEXT(@"complain");
        self.right.titleFont = [UIFont systemFontOfSize:17.f];
	}
	
	[self.list reloadData];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
	[AppBoard_iPhone sharedInstance].menuPannable = NO;

	[self showNavigationBarAnimated:YES];
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark - F0_ProfileBoard_iPhone

ON_SIGNAL3( F0_ProfileBoard_iPhone, left, signal )
{
	if ( self.stack.boards.count > 1 )
	{
        [self.stack popBoardAnimated:YES];
    }
    else
    {
        [AppBoard_iPhone sharedInstance].menuShown = [AppBoard_iPhone sharedInstance].menuShown ? NO : YES;
    }
}

ON_SIGNAL3( F0_ProfileBoard_iPhone, right, signal )
{
	if ( [self isMySelf] )
	{
		F9_SettingBoard_iPhone * board = [F9_SettingBoard_iPhone board];
		[self.stack pushBoard:board animated:YES];
	}
	else
	{
        G0_ReportBoard_iPhone * board = [G0_ReportBoard_iPhone board];
        board.user_id = self.uid;
        [self.stack pushBoard:board animated:YES];
	}
}

#pragma mark - F0_ProfileHeaderCell_iPhone

ON_SIGNAL3( F0_ProfileHeaderCell_iPhone, refresh, signal )
{
	[self updateModelData];
	
	[self.list reloadData];
}

ON_SIGNAL3( F0_ProfileHeaderCell_iPhone, avatar_touched, signal )
{
	F0_LargePhotoCell_iPhone * cell = [F0_LargePhotoCell_iPhone cell];
	cell.frame = self.view.window.bounds;
	cell.data = self.userModel.user;
	[cell showInContainer:self];
}

#pragma mark - F0_ProfileIntroCell_iPhone

ON_SIGNAL3( F0_ProfileIntroCell_iPhone, mask, signal )
{
	if ( self.userModel.user.brief && self.userModel.user.brief.length )
	{
		F11_IntroBoard_iPhone * board = [F11_IntroBoard_iPhone board];
		board.text = self.userModel.user.brief;
		[self.stack pushBoard:board animated:YES];
	}
	else
	{
		[self presentMessageTips:__TEXT(@"brief_wrong_format_hint")];
	}
}

ON_SIGNAL3( F0_ProfileIntroCell_iPhone, view_all, signal )
{
	if ( self.userModel.user.brief && self.userModel.user.brief.length )
	{
		F11_IntroBoard_iPhone * board = [F11_IntroBoard_iPhone board];
		board.text = self.userModel.user.brief;
		[self.stack pushBoard:board animated:YES];
	}
	else
	{
		[self presentMessageTips:__TEXT(@"brief_wrong_format_hint")];
	}
}

#pragma mark - F0_ProfileServiceCell_iPhone

//ON_SIGNAL3( F0_ProfileServiceCell_iPhone, mask, signal )
//{
//	C15_EditPriceBoard_iPhone * board = [C15_EditPriceBoard_iPhone board];
//	board.backWhenSucceed = YES;
//	board.service = signal.sourceCell.data;
//	[self.stack pushBoard:board animated:YES];
//}

#pragma mark - F0_ProfileRateCell_iPhone

ON_SIGNAL3( F0_ProfileRateCell_iPhone, mask, signal )
{
	F8_ReviewBoard_iPhone * board = [F8_ReviewBoard_iPhone board];
	board.uid = self.userModel.user.id ?: self.uid;
	[self.stack pushBoard:board animated:YES];
}

#pragma mark - F0_ProfileApplyCell_iPhone

ON_SIGNAL3( F0_ProfileApplyCell_iPhone, apply, signal )
{
    F10_ApplyBoard_iPhone * board = [F10_ApplyBoard_iPhone board];
    board.backWhenSucceed = YES;
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - F0_ProfileHelpCell_iPhone

ON_SIGNAL3( F0_ProfileHelpCell_iPhone, help, signal )
{
	C1_PublishOrderBoard_iPhone * board = [C1_PublishOrderBoard_iPhone board];
	board.uid = self.userModel.user.id;
    board.serviceTypeListModel.services = self.serviceModel.services;
    board.orderData.service_type = self.currentServiceType;
	[self.stack pushBoard:board animated:YES];
}

#pragma mark -

ON_SIGNAL3( UserModel, GETTING_BALANCE, signal )
{
	
}

ON_SIGNAL3( UserModel, GET_BALANCE_SUCCEED, signal )
{
	[self.list asyncReloadData];
}

ON_SIGNAL3( UserModel, GET_BALANCE_FAILED, signal )
{
	[self.list asyncReloadData];
}

#pragma mark -

ON_SIGNAL3( UserModel, PROFILE_UPDATING, signal )
{
	self.list.headerLoading = YES;
	[self.list reloadData];
	
//	if ( NO == self.userModel.loaded )
//	{
//		[self presentLoadingTips:__TEXT(@"xlistview_header_hint_loading")];
//	}
}

ON_SIGNAL3( UserModel, PROFILE_UPDATED, signal )
{
	[self dismissTips];
	[self.list asyncReloadData];
}

ON_SIGNAL3( UserModel, PROFILE_FAILED, signal )
{
	[self dismissTips];
	[self.list asyncReloadData];
}

ON_SIGNAL3( UserModel, PROFILE_BLOCKED, signal )
{
	[self dismissTips];
	[self.list asyncReloadData];

	[self.view.window presentFailureTips:@"用户不存在"];
}

#pragma mark -

ON_SIGNAL3( UserModel, REPORT_REQUESTING, signal )
{
	[self presentLoadingTips:@"正在提交..."];
}

ON_SIGNAL3( UserModel, REPORT_SUCCEED, signal )
{
	[self dismissTips];
	[self presentSuccessTips:@"提交成功，我们会尽快处理"];
}

ON_SIGNAL3( UserModel, REPORT_FAILED, signal )
{
	[self dismissTips];
	[self presentSuccessTips:@"提交失败，请稍后再试"];
}

#pragma mark -

ON_SIGNAL3( MyServiceModel, RELOADING, signal )
{
}

ON_SIGNAL3( MyServiceModel, RELOADED, signal )
{
	[self.list asyncReloadData];
}

@end

#pragma mark -

@implementation F0_MyProfileBoard_iPhone

DEF_SINGLETON( F0_MyProfileBoard_iPhone )

+ (NSString *)UIResourceName
{
	return @"F0_ProfileBoard_iPhone";
}

- (void)load
{
	self.userModel = [UserModel sharedInstance];
	[self.userModel addObserver:self];

	self.serviceModel = [MyServiceModel sharedInstance];
	[self.serviceModel addObserver:self];
}

- (void)unload
{
}

- (BOOL)isMySelf
{
	return YES;
}

@end

#pragma mark -

@implementation F0_OtherProfileBoard_iPhone

+ (NSString *)UIResourceName
{
	return @"F0_ProfileBoard_iPhone";
}

- (void)load
{
	self.userModel = [UserModel model];
	self.userModel.user = [[[USER alloc] init] autorelease];
	[self.userModel addObserver:self];

	self.serviceModel = [MyServiceModel model];
	[self.serviceModel addObserver:self];
}

- (void)unload
{
}

- (BOOL)isMySelf
{
	return NO;
}

@end

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

#import "C17_ApplyFormBoard_iPhone.h"

#import "AppBoard_iPhone.h"

#pragma mark -

@implementation C17_ApplyFormBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( C17_ApplyFormBoard_iPhone )

DEF_OUTLET( BeeUITextField, type );
DEF_OUTLET( BeeUITextField, first );
DEF_OUTLET( BeeUITextField, second );

DEF_SIGNAL( TYPE_SELECTED )
DEF_SIGNAL( FIRST_SELECTED )
DEF_SIGNAL( SECOND_SELECTED )

@synthesize backWhenSucceed = _backWhenSucceed;
@synthesize applyModel = _applyModel;

- (void)load
{
	self.applyModel = [ApplyModel model];
	[self.applyModel addObserver:self];
}

- (void)unload
{
	[self.applyModel removeObserver:self];
	self.applyModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationBarShown = YES;
	self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
	self.navigationBarTitle = __TEXT(@"apply_certificate");
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

//	if ( 0 == self.applyModel.typeList.count )
//	{
//		[self.applyModel getTypeList];
//	}
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

#pragma mark -

- (void)updateFields
{
//	if ( nil == self.applyModel.type && self.applyModel.typeList.count )
//	{
//		self.applyModel.type = [self.applyModel.typeList objectAtIndex:0];
//	}
//
//	if ( nil == self.applyModel.first && self.applyModel.firstList.count )
//	{
//		self.applyModel.first = [self.applyModel.firstList objectAtIndex:0];
//	}
//
//	if ( nil == self.applyModel.second && self.applyModel.secondList.count )
//	{
//		self.applyModel.second = [self.applyModel.secondList objectAtIndex:0];
//	}

	self.type.text = self.applyModel.type ? self.applyModel.type.title : __TEXT(@"please_select");
	self.first.text = self.applyModel.first ? self.applyModel.first.title : __TEXT(@"please_select");
	self.second.text = self.applyModel.second ? self.applyModel.second.title : __TEXT(@"please_select");
}

#pragma mark -

ON_SIGNAL3( C17_ApplyFormBoard_iPhone, select_type, signal )
{
	if ( self.applyModel.typeList.count )
	{
		[self showTypeList];
	}
	else
	{
		[self.applyModel getTypeList];
	}
}

ON_SIGNAL3( C17_ApplyFormBoard_iPhone, select_first, signal )
{
	if ( nil == self.applyModel.type )
	{
		[self presentFailureTips:__TEXT(@"select_service")];
		return;
	}
	
	if ( self.applyModel.firstList.count )
	{
		[self showFirstList];
	}
	else
	{
		[self.applyModel getFirstList];
	}
}

ON_SIGNAL3( C17_ApplyFormBoard_iPhone, select_second, signal )
{
	if ( nil == self.applyModel.first )
	{
		[self presentFailureTips:@"请先选择一级类目"];
		return;
	}

	if ( self.applyModel.secondList.count )
	{
		[self showSecondList];
	}
	else
	{
		[self.applyModel getSecondList];
	}
}

ON_SIGNAL3( C17_ApplyFormBoard_iPhone, TYPE_SELECTED, signal )
{
	if ( self.applyModel.type != signal.object )
	{
		self.applyModel.type = signal.object;
		
		self.applyModel.firstList = nil;
		self.applyModel.first = nil;
		
		self.applyModel.secondList = nil;
		self.applyModel.second = nil;
	}
	
	[self updateFields];
	
	if ( 0 == self.applyModel.firstList.count )
	{
		[self.applyModel getFirstList];
	}
}

ON_SIGNAL3( C17_ApplyFormBoard_iPhone, FIRST_SELECTED, signal )
{
	if ( self.applyModel.first != signal.object )
	{
		self.applyModel.first = signal.object;
		
		self.applyModel.secondList = nil;
		self.applyModel.second = nil;
	}
	
	[self updateFields];
	
	if ( 0 == self.applyModel.secondList.count )
	{
		[self.applyModel getSecondList];
	}
}

ON_SIGNAL3( C17_ApplyFormBoard_iPhone, SECOND_SELECTED, signal )
{
	if ( self.applyModel.second != signal.object )
	{
		self.applyModel.second = signal.object;
	}

	[self updateFields];
}

ON_SIGNAL3( C17_ApplyFormBoard_iPhone, submit, signal )
{
	if ( nil == self.applyModel.type )
	{
		[self presentFailureTips:@"请选择项目类型"];
		return;
	}

	if ( nil == self.applyModel.first )
	{
		[self presentFailureTips:@"请选择一级类目"];
		return;
	}

	if ( nil == self.applyModel.second )
	{
		[self presentFailureTips:@"请选择二级类目"];
		return;
	}

	[self.applyModel apply];
}

#pragma mark -

- (void)showTypeList
{
	BeeUIActionSheet * sheet = [BeeUIActionSheet spawn];
	
	[sheet setTitle:@"选择项目类型"];
	
	for ( SERVICE_TYPE * type in self.applyModel.typeList )
	{
		[sheet addButtonTitle:type.title signal:self.TYPE_SELECTED object:type];
	}
	
	[sheet addCancelTitle:__TEXT(@"cancel")];
	[sheet showInViewController:self];
}

ON_SIGNAL3( ApplyModel, TYPE_UPDATING, signal )
{
	[self presentLoadingTips:__TEXT(@"xlistview_header_hint_loading")];
}

ON_SIGNAL3( ApplyModel, TYPE_UPDATED, signal )
{
	[self dismissTips];

	if ( self.applyModel.typeList.count )
	{
		[self showTypeList];
	}
	else
	{
	//	[self presentFailureTips:@"没有选项"];
	}
	
	[self updateFields];

//	if ( 0 == self.applyModel.firstList.count )
//	{
//		[self.applyModel getFirstList];
//	}
}

#pragma MARK -

- (void)showFirstList
{
	BeeUIActionSheet * sheet = [BeeUIActionSheet spawn];
	
	[sheet setTitle:@"选择一级类型"];
	
	for ( SERVICE_CATEGORY * cate in self.applyModel.firstList )
	{
		[sheet addButtonTitle:cate.title signal:self.FIRST_SELECTED object:cate];
	}
	
	[sheet addCancelTitle:__TEXT(@"cancel")];
	[sheet showInViewController:self];
}

ON_SIGNAL3( ApplyModel, FIRST_UPDATING, signal )
{
	[self presentLoadingTips:__TEXT(@"xlistview_header_hint_loading")];
}

ON_SIGNAL3( ApplyModel, FIRST_UPDATED, signal )
{
	[self dismissTips];
	
	if ( self.applyModel.firstList.count )
	{
		[self showFirstList];
	}
	else
	{
	//	[self presentFailureTips:@"没有选项"];
	}
	
	[self updateFields];

//	if ( 0 == self.applyModel.secondList.count )
//	{
//		[self.applyModel getSecondList];
//	}
}

#pragma MARK -

- (void)showSecondList
{
	BeeUIActionSheet * sheet = [BeeUIActionSheet spawn];
	
	[sheet setTitle:@"选择二级类型"];
	
	for ( SERVICE_CATEGORY * cate in self.applyModel.secondList )
	{
		[sheet addButtonTitle:cate.title signal:self.SECOND_SELECTED object:cate];
	}
	
	[sheet addCancelTitle:__TEXT(@"cancel")];
	[sheet showInViewController:self];
}

ON_SIGNAL3( ApplyModel, SECOND_UPDATING, signal )
{
	[self presentLoadingTips:__TEXT(@"xlistview_header_hint_loading")];
}

ON_SIGNAL3( ApplyModel, SECOND_UPDATED, signal )
{
	[self dismissTips];
	
	if ( self.applyModel.secondList.count )
	{
		[self showSecondList];
	}
	else
	{
	//	[self presentFailureTips:@"没有选项"];
	}

	[self updateFields];
}

#pragma mark -

ON_SIGNAL3( ApplyModel, APPLY_REQUESTING, signal )
{
	[self presentLoadingTips:@"正在提交..."];
}

ON_SIGNAL3( ApplyModel, APPLY_SUCCEED, signal )
{
	[self dismissTips];
	[self.view.window presentSuccessTips:@"提交成功"];
	
	if ( self.backWhenSucceed )
	{
		[self.stack popBoardAnimated:YES];
	}
}

ON_SIGNAL3( ApplyModel, APPLY_FAILED, signal )
{
	[self dismissTips];
}

@end

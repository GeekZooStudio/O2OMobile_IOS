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

#import "C15_EditPriceBoard_iPhone.h"

#import "AppBoard_iPhone.h"

#pragma mark -

@implementation C15_EditPriceBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( C15_EditPriceBoard_iPhone )

DEF_OUTLET( BeeUILabel,		name );
DEF_OUTLET( BeeUITextField, price );

@synthesize backWhenSucceed = _backWhenSucceed;
@synthesize service = _service;
@synthesize serviceModel = _serviceModel;

- (void)load
{
	self.serviceModel = [MyServiceModel sharedInstance];
	self.serviceModel.uid = [UserModel sharedInstance].user.id;
	[self.serviceModel addObserver:self];
}

- (void)unload
{
	[self.serviceModel removeObserver:self];
	self.serviceModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationBarShown = YES;
	self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
	self.navigationBarTitle = __TEXT(@"modify_service");
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
	self.name.text = self.service.service_type.title;
	self.price.text = [NSString stringWithFormat:@"%@", self.service.price];

	[AppBoard_iPhone sharedInstance].menuPannable = NO;
}

ON_DID_APPEAR( signal )
{
	[self.price becomeFirstResponder];
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
	[self.serviceModel modify:self.service.id price:@([self.price.text floatValue])];
}

#pragma MARK -

ON_SIGNAL3( MyServiceModel, MODIFY_REQUESTING, signal )
{
	[self presentLoadingTips:@"正在提交..."];
	
	[self.price resignFirstResponder];
}

ON_SIGNAL3( MyServiceModel, MODIFY_SUCCEED, signal )
{
	[self dismissTips];
	[self.view.window presentSuccessTips:__TEXT(@"price_edit_success")];

	if ( self.backWhenSucceed )
	{
		[self.stack popBoardAnimated:YES];
	}
}

ON_SIGNAL3( MyServiceModel, MODIFY_FAILED, signal )
{
	[self dismissTips];
}

@end

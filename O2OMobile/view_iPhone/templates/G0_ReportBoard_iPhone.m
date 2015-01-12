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

#import "G0_ReportBoard_iPhone.h"

#pragma mark -

@interface G0_ReportBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation G0_ReportBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL( UserModel, userModel )

- (void)load
{
    self.userModel = [UserModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL(self.userModel);
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.title = __TEXT(@"complain");
    self.navigationBarShown = YES;
    self.view.backgroundColor = HEX_RGB(0xFFFFFF);
    self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
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

ON_SIGNAL3( G0_ReportBoard_iPhone, report, signal )
{
    NSString * text = self.content.text;
    
    if ( text && text.length )
    {
        [self.userModel reportWithUser:self.user_id order:self.order_id text:text];
    }
    else
    {
        [self presentMessageTips:__TEXT(@"input_complain_content")];
    }
}

#pragma mark - UserModel

ON_SIGNAL3( UserModel, REPORT_REQUESTING, signal )
{
    [self presentLoadingTips:__TEXT(@"please_later_on")];
}

ON_SIGNAL3( UserModel, REPORT_SUCCEED, signal )
{
    [self.stack presentSuccessTips:__TEXT(@"complain_success")];
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( UserModel, REPORT_FAILED, signal )
{
    [self presentLoadingTips:__TEXT(@"complain_failed")];
}

@end

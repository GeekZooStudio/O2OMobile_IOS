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

#import "C2_OrderDistributeBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "D1_OrderBoard_iPhone.h"

#pragma mark -


@implementation C2_OrderDistributeBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

@synthesize order = _order;

DEF_OUTLET( BeeUILabel, note )
DEF_OUTLET( C2_CircleProgressCell, progressCell )

- (void)load
{

}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
    self.navigationBarShown = YES;
    self.navigationBarTitle = __TEXT(@"finding");
    self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
    
    self.progressCell.data = self.order.push_number;
    self.progressCell.whenProgressStarted = ^
    {
        self.navigationBarTitle = __TEXT(@"finding");
        self.note.data = __TEXT(@"please_wait_now_notificationing");
    };
    self.progressCell.whenProgressStoped = ^
    {
        self.navigationBarTitle = __TEXT(@"find_end");
        self.note.data = __TEXT(@"notification_end");
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
//    [[AppBoard_iPhone sharedInstance] openHomeBoard];
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

#pragma mark -

ON_SIGNAL3( C2_OrderDistributeBoard_iPhone, detail, signal )
{
    [self.stack popToFirstBoardAnimated:NO];
    D1_OrderBoard_iPhone * board = [D1_OrderBoard_iPhone board];
    board.order = self.order;
    [[[BeeUIRouter sharedInstance] currentStack] pushBoard:board animated:YES];
}

@end

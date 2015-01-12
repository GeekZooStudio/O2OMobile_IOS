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

#import "D4_OrderCommentListBoard_iPhone.h"
#import "D4_OrderCommentListCell_iPhone.h"
#import "F0_ProfileBoard_iPhone.h"

#pragma mark -

@interface D4_OrderCommentListBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation D4_OrderCommentListBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

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
    self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
    self.navigationBarTitle = __TEXT(@"order_evaluate");
    
    @weakify(self);
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = 1;
        
        BeeUIScrollItem * item = self.list.items[0];
        item.size = CGSizeMake( self.list.width, self.list.height );
        item.clazz = [D4_OrderCommentListCell_iPhone class];
        item.data = self.order;
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
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL3( D4_OrderCommentInfoCell_iPhone, avatar, signal )
{
    USER * user = signal.sourceCell.data[@"user"];
    
    if ( [user.id isEqualToNumber:[UserModel sharedInstance].user.id] )
    {
        [self.stack pushBoard:[F0_MyProfileBoard_iPhone sharedInstance] animated:YES];
    }
    else
    {
        F0_OtherProfileBoard_iPhone * board = [F0_OtherProfileBoard_iPhone board];
        board.uid = user.id;
        [self.stack pushBoard:board animated:YES];
    }
}

@end

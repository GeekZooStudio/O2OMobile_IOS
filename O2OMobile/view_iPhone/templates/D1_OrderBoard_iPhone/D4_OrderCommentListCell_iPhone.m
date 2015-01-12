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

#import "D4_OrderCommentListCell_iPhone.h"
#import "D4_OrderCommentInfoCell_iPhone.h"

#pragma mark -

@implementation D4_OrderCommentListCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    ORDER_INFO * order = self.data;
    
    if ( order )
    {
        self.order_sn.data = order.order_sn;
        self.service_type.data = order.service_type.title;
        self.location.data = order.location.name;
        self.service_price.data = [order.offer_price description];

        if ( order.employee_comment && order.employer_comment )
        {
            self.comment1.data = @{@"user":order.employee, @"comment":order.employee_comment};
            self.comment2.data = @{@"user":order.employer, @"comment":order.employer_comment};
        }
        else if ( order.employee_comment )
        {
            self.comment1.data = @{@"user":order.employee, @"comment":order.employee_comment};
            self.comment2.hidden = YES;
        }
        else if ( order.employer_comment )
        {
            self.comment1.data = @{@"user":order.employer, @"comment":order.employer_comment};
            self.comment2.hidden = YES;
        }
        else
        {
            self.comment1.hidden = YES;
            self.comment2.hidden = YES;
        }
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end

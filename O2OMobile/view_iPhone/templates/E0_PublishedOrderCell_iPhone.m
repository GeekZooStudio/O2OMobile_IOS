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

#import "E0_PublishedOrderCell_iPhone.h"
#import "model.h"

#pragma mark -

@implementation E0_PublishedOrderCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, avatar )
DEF_OUTLET( BeeUILabel, name )
DEF_OUTLET( BeeUILabel, type )
DEF_OUTLET( BeeUILabel, orderState )
DEF_OUTLET( BeeUILabel, desc )
DEF_OUTLET( BeeUILabel, time )
DEF_OUTLET( BeeUILabel, price )

- (void)load
{
    self.name.adjustsFontSizeToFitWidth = YES;
}

- (void)unload
{
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        ORDER_INFO * order = self.data;
        
        SIMPLE_USER * employee = order.employee;
        
        if ( employee )
        {
            if ( employee.avatar.thumb.length )
            {
                [self.avatar GET:employee.avatar.thumb useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
            }
            else if ( employee.avatar.large.length )
            {
                [self.avatar GET:employee.avatar.large useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
            }
            else
            {
                self.avatar.data = @"e8_profile_no_avatar.png";
            }
            
            self.name.data = employee.nickname;
            self.type.data = order.service_type.title;
        }
        else
        {
            self.avatar.data = @"e9_no_header.png";
            self.name.data = order.service_type.title;
            self.type.data = nil;
        }
        
        self.orderState.data = [OrderStatusManager statusStringFromOrder:order];
        
        if ( 0 == order.content.text.length )
        {
            self.desc.data = __TEXT(@"no_content");
        }
        else
        {
            self.desc.data = order.content.text;
        }
        self.time.data = [[order.created_at asNSDate] timeAgo];
        self.price.data = order.offer_price;
    }
}

- (void)layoutDidFinish
{
}

@end

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

#import "A0_RequestCell_iPhone.h"
#import "model.h"
#import "ORDER_INFO+Categories.h"

#pragma mark -

@implementation A0_RequestCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, avatar )
DEF_OUTLET( BeeUILabel, title )
DEF_OUTLET( BeeUILabel, distance )
DEF_OUTLET( BeeUILabel, desc )
DEF_OUTLET( BeeUILabel, time )
DEF_OUTLET( BeeUILabel, price )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        ORDER_INFO * order = self.data;
        
        SIMPLE_USER * employer = order.employer;
        if ( employer.avatar.thumb.length )
        {
            [self.avatar GET:employer.avatar.thumb useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
        }
        else if ( employer.avatar.large.length )
        {
            [self.avatar GET:employer.avatar.large useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
        }
        else
        {
            self.avatar.data = @"e8_profile_no_avatar.png";
        }
        
        self.title.data = order.service_type.title;
        self.distance.data = [NSString stringWithFormat:@"%.f %@", order.distance, __TEXT(@"meter")];
        if ( 0 == order.content.text.length )
        {
            self.desc.data = __TEXT(@"no_content");
        }
        else
        {
            self.desc.data = order.content.text;
        }
        self.time.data = [[order.created_at asNSDate] timeAgo];
        self.price.data = [NSString stringWithFormat:@"%@%@",order.offer_price,__TEXT(@"yuan")];
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end

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

#import "H0_MessageCell_iPhone.h"

#pragma mark -

@implementation H0_MessageCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, dot )
DEF_OUTLET( BeeUILabel, content )
DEF_OUTLET( BeeUILabel, time )
DEF_OUTLET( BeeUIImageView, arrow )

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
        MESSAGE * message = self.data;
        if ( message.is_readed.boolValue )
        {
            self.dot.data = nil;
            self.content.textColor = HEX_RGB( 0x7c7c7c );
        }
        else
        {
            self.dot.data = @"dot_unread.png";
            self.content.textColor = HEX_RGB( 0x4a4a4a );
        }
        self.content.data = message.content;
        self.time.data = [[message.created_at asNSDate] timeAgo];
        
        if ( MESSAGE_TYPE_SYSTEM == message.type.intValue )
        {
            if ( message.url.length )
            {
                self.arrow.hidden = NO;
            }
            else
            {
                self.arrow.hidden = YES;
            }
        }
        else if ( MESSAGE_TYPE_ORDER == message.type.intValue )
        {
            if ( message.order_id.integerValue )
            {
                self.arrow.hidden = NO;
            }
            else
            {
                self.arrow.hidden = YES;
            }
        }
        else if ( MESSAGE_TYPE_OTHER == message.type.intValue )
        {
            if ( message.url.length )
            {
                self.arrow.hidden = NO;
            }
            else
            {
                self.arrow.hidden = YES;
            }
        }
    }
}

- (void)layoutDidFinish
{
}

@end

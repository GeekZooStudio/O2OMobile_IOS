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

#import "D2_OrderHistoryCell_iPhone.h"

@implementation D2_OrderHistoryCellData
@end

#pragma mark -

@implementation D2_OrderHistoryCell_iPhone

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
    ORDER_RECORD * record = ((D2_OrderHistoryCellData *)self.data).record;
    BOOL isCurrent = ((D2_OrderHistoryCellData *)self.data).isCurrent;

    if ( record )
    {
        if ( isCurrent )
        {
            self.indictor.image = [UIImage imageNamed:@"d2_circle.png"];
        }
        else
        {
            if ( record.active.boolValue )
            {
                self.indictor.image = [UIImage imageNamed:@"d2_circle_small.png"];
                self.title.textColor = HEX_RGB(0x4a4a4a);
            }
            else
            {
                self.indictor.image = [UIImage imageNamed:@"d2_circle_small_gray.png"];
                self.title.textColor = HEX_RGB(0xd8d8d8);
            }
        }
        
        self.title.data = [OrderStatusManager statusStringFromStatus:record.order_action.integerValue];
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end

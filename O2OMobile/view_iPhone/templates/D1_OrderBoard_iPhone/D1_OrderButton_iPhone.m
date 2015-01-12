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

#import "D1_OrderButton_iPhone.h"
#import "OrderStatusManager.h"

@implementation D1_OrderButton_iPhone

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initlize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initlize];
    }
    return self;
}

- (void)initlize
{
    self.alpha = 0;
    self.enabled = NO;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setStatus:(BAUserOrderStatus)status
{
    _status = status;
    
    BOOL enabled = YES;
    NSString * title = nil;

    [OrderStatusManager getButtonTitle:&title enabled:&enabled fromStatus:status];
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateDisabled];
    
    if ( BAUserOrderStatusFinished == status )
    {
        UIImage * image = [UIImage imageNamed:@"e3_share_button.png"];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0,image.size.width/2,0,0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, -image.size.width/2, 0, 0)];
        [self setImage:image forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:nil forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsZero];
    }
    
    self.enabled = enabled;
    self.alpha = 1;
}

- (void)didTouchUpInside
{
    [self sendUISignal:BeeUIButton.TOUCH_UP_INSIDE];
}

@end

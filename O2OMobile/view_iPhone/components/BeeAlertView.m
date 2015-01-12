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

#import "BeeAlertView.h"

@implementation BeeAlertView

SUPPORT_AUTOMATIC_LAYOUT(YES)
SUPPORT_RESOURCE_LOADING(YES)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    }
    return self;
}

+ (instancetype)alertWithType:(BeeAlertViewType)type title:(NSString *)title
{
    return [self alertWithType:type title:title message:nil];
}

+ (instancetype)alertWithType:(BeeAlertViewType)type title:(NSString *)title message:(NSString *)message
{
    BeeAlertView * alert = [[BeeAlertView alloc] initWithFrame:CGRectZero];
    alert.templateResource = @"BeeAlertView.xml";
    alert.frame = [UIScreen mainScreen].bounds;
    alert.title.data = title;
    alert.message.data = message;
    switch ( type  )
    {
        case BeeAlertViewTypeSuccess:
            alert.indictor.data = [UIImage imageNamed:@"d3_alert_success.png"];
            alert.title.textColor = HEX_RGB(0x39bced);
            alert.message.textColor = HEX_RGB(0x39bced);
            alert.button.backgroundColor = HEX_RGB(0x39bced);
            break;
        case BeeAlertViewTypeFailure:
            alert.indictor.data = [UIImage imageNamed:@"d3_failed.png"];
            alert.title.textColor = HEX_RGB(0xF65858);
            alert.message.textColor = HEX_RGB(0xF65858);
            alert.button.backgroundColor = HEX_RGB(0xF65858);
            break;
    }
    
    return alert;
}

- (void)showInContainer:(id)container
{
    if ( [container isKindOfClass:[UIView class]] )
    {
        [container addSubview:self];
    }
    else if ( [container isKindOfClass:[UIViewController class]] )
    {
        [[container view] addSubview:self];
    }
}

- (void)hide
{
    [self transitionFade];
    [self removeFromSuperview];
}

ON_SIGNAL3( BeeAlertView, button, signal )
{
    [self hide];
}

@end

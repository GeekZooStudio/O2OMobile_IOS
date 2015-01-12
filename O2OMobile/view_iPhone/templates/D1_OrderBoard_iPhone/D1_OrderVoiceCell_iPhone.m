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

#import "D1_OrderVoiceCell_iPhone.h"
#import "AudioPlayer.h"

#pragma mark -

int const kMinDuration = 3;
int const kMaxDuration = 30;
int const kMinWidth = 70;
int const kMaxWidth = 200;

@implementation D1_OrderVoiceCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    self.indicator.animationImages = [[self class] animationImages];
    self.indicator.animationDuration = 1.f;
    
    [self observeNotification:AudioPlayer.PLAYING];
    [self observeNotification:AudioPlayer.STOPPED];
    [self observeNotification:AudioPlayer.FAILED];
}

- (void)unload
{
    [self unobserveAllNotifications];
}

- (void)dataDidChanged
{
    ORDER_INFO * order = self.data;
    
    if ( order )
    {
        int duration = order.duration.intValue > 30 ? 30 : order.duration.intValue;
        self.duration.data = [NSString stringWithFormat:@"%d`", duration];
        float detalWidth = (duration - kMinDuration) / ((kMaxDuration - kMinDuration) * 1.f);
        int width = kMinWidth + detalWidth * (kMaxWidth - kMinWidth);
        $(self.background).WIDTH( width );
    }
}

+ (NSArray *)animationImages
{
    static NSArray * _images = nil;
    if ( _images == nil )
    {
        _images = [@[ [UIImage imageNamed:@"d8_btn_playing_0.png"],
                      [UIImage imageNamed:@"d8_btn_playing_1.png"],
                      [UIImage imageNamed:@"d8_btn_playing_2.png"] ] copy];
    }
    return _images;
}

- (void)layoutDidFinish
{
}

ON_NOTIFICATION2( AudioPlayer, n )
{
    if ( [n is:AudioPlayer.PLAYING] )
    {
        [self.indicator startAnimating];
    }
    else if ( [n is:AudioPlayer.STOPPED] || [n is:AudioPlayer.FAILED] )
    {
        [self.indicator stopAnimating];
    }
}

@end

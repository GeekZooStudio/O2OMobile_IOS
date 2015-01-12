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

#import "C1_PublishOrderCell_iPhone.h"

#pragma mark -

@interface C1_PublishOrderCell_iPhone ()
{
    NSTimer * _timer;
    NSInteger _count;
}
@end

#pragma mark -

@implementation C1_PublishOrderCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUITextField, price )
DEF_OUTLET( BeeUILabel, time )
DEF_OUTLET( BeeUITextField, address )
DEF_OUTLET( BeeUITextView, note )
DEF_OUTLET( BeeUIButton, record )
DEF_OUTLET( BeeUIButton, reset )
DEF_OUTLET( BeeUILabel, publish_text )

DEF_OUTLET( C1_RecordAnimationCell_iPhone, animationCell )

- (void)load
{
    self.note.editable = YES;
    self.record.enableAllEvents = YES;
    
    self.reset.alpha = 0;
    
    self.animationCell.hidden = YES;
    self.price.isNumber = YES;
}

- (void)unload
{
}

- (void)dataDidChanged
{
    OrderData * orderData = self.data;
    if ( orderData )
    {
        self.price.data = orderData.price;
        self.time.data = [orderData.time stringWithDateFormat:@"MM月dd日 HH时mm分"];
        self.address.data = orderData.location.name;
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - record

- (void)startRecord
{
    self.publish_text.backgroundColor = HEX_RGB( 0xD0AD3C );
    self.publish_text.textColor = HEX_RGB( 0x494949 );
    
    self.record.selected = NO;
    self.record.image = [UIImage imageNamed:@"b3_record_btn.png"];
    self.reset.alpha = 0;
    
    self.animationCell.hidden = NO;
    [self.animationCell starAnimation];
}

- (void)stopRecord
{
    self.publish_text.backgroundColor = HEX_RGB( 0x25BDE8 );
    self.publish_text.textColor = HEX_RGB( 0xFFFFFF );
    
    [self.animationCell stopAnimation];
    self.animationCell.hidden = YES;
}

- (void)resetRecord
{
    self.record.image = [UIImage imageNamed:@"b3_record_btn.png"];
    self.record.selected = NO;
    self.reset.alpha = 0;
}

- (void)recordSucceed
{
    self.record.image = [UIImage imageNamed:@"b5_play_btn.png"];
    self.record.selected = YES;
    self.reset.alpha = 1.0;
}

- (void)recordFailed
{
    
}

#pragma mark - audio play

- (void)startAudioPlay
{
    [self starAnimation];
    
    self.reset.enabled = NO;
}

- (void)stopAudioPlay
{
    [self stopAnimation];
    
    self.record.image = [UIImage imageNamed:@"b5_play_btn.png"];
    
    self.reset.enabled = YES;
}

#pragma mark - animation

- (void)starAnimation
{
    [self startTimer];
}

- (void)stopAnimation
{
    [self stopTimer];
}

- (void)animatePlaying
{
    _count++;
    if ( _count > 3 )
    {
        _count = 1;
    }
    self.record.image = [UIImage imageNamed:[NSString stringWithFormat:@"b6_btn_playing_%d.png",_count]];
}

#pragma mark -

- (void)startTimer
{
	[_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                              target:self
                                            selector:@selector(animatePlaying)
                                            userInfo:nil
                                             repeats:YES];
    _count = 1;
}

- (void)stopTimer
{
	[_timer invalidate];
	_timer = nil;
}

@end

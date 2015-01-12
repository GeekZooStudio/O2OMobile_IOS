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

#import "C2_CircleProgressCell.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

#undef ARC4RANDOM_MAX
#define ARC4RANDOM_MAX      0x100000000

#pragma mark -

@interface C2_CircleProgressCell ()
{
    NSTimer * _centerLabelTimer;
    NSTimer * _circleLabelTimer;
    float _currentProgressCount;
    float _averageInteval;
}
@property (nonatomic, assign) NSInteger centerCount;
@property (nonatomic, assign) NSInteger circleCount;
@end

@implementation C2_CircleProgressCell

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( MDRadialProgressView, progress )
DEF_OUTLET( BeeUILabel, progress_count )

- (void)load
{
    MDRadialProgressTheme *theme = [[[MDRadialProgressTheme alloc] init] autorelease];
	theme.completedColor = HEX_RGB( 0x39bced );
	theme.incompletedColor = HEX_RGBA( 0x39bced, 0.3 );
	theme.centerColor = [UIColor clearColor];
	theme.sliceDividerHidden = YES;
	theme.labelColor = [UIColor greenColor];
    theme.thickness = 8;
	theme.labelShadowColor = [UIColor whiteColor];
    theme.font = [UIFont systemFontOfSize:20];
    
    @weakify(self);
    
    self.progress.theme = theme;
    self.progress.progressTotal = 3000;//self.pushNumber.integerValue;
    self.progress.progressCounter = 0;
    
    self.progress.label.textColor = HEX_RGB( 0x39bced );
    self.progress.label.font = [UIFont systemFontOfSize:40];
    self.progress.label.hidden = YES;
    
    self.progress.circleLabel.backgroundColor = HEX_RGB( 0x39bced );
    self.progress.circleLabel.textColor = [UIColor whiteColor];
    self.progress.circleLabel.textAlignment = NSTextAlignmentCenter;
    self.progress.circleLabel.adjustsFontSizeToFitWidth = YES;
    self.progress.circleLabel.font = [UIFont systemFontOfSize:12];
    
    self.progress.progressBlock = ^( MDRadialProgressView * view ) {
        @normalize(self);
        
        view.label.text = [NSString stringWithFormat:@"%d", self.centerCount];
    };
    
    self.layer.masksToBounds = NO;
    
    [self startTimer];
    
    _currentProgressCount = 0.0f;
    _averageInteval = 300.0 / [self.data integerValue];
}

- (void)unload
{
}

- (void)dataDidChanged
{
    
}

#pragma mark -

- (void)animateCenterLabel
{
    if ( _centerCount > 3000 * 1 )
    {
        [self stopTimer];
    }
    
    self.progress.progressCounter = _centerCount;
    _centerCount++;
}

- (void)updateProgressCount
{
    NSInteger total = [self.data integerValue];
    float averageAdd = total / 300.0f;
    
    srand((unsigned)time(0));
    float randomCount = (rand() % 11) / 10.0f + 0.5f; 
    
    if ( _currentProgressCount <= total )
    {
        _currentProgressCount += randomCount * averageAdd;
        self.progress_count.data = @((int)_currentProgressCount);
    }
    else
    {
        self.progress_count.data = @(total);
    }
}

- (void)animateCircleLabel
{
    if ( _circleCount < 10 )
    {
        self.progress.circleLabel.text = [NSString stringWithFormat:@"00:0%d", _circleCount];
    }
    else if ( _circleCount < 60 )
    {
        self.progress.circleLabel.text = [NSString stringWithFormat:@"00:%d", _circleCount];
    }
    else if ( _circleCount % 60 < 10 )
    {
        self.progress.circleLabel.text = [NSString stringWithFormat:@"0%d:0%d", _circleCount / 60, _circleCount % 60];
    }
    else
    {
        self.progress.circleLabel.text = [NSString stringWithFormat:@"0%d:%d", _circleCount / 60, _circleCount % 60];
    }

    if ( _circleCount > 3000 * 1 )
    {
        [self stopTimer];
    }
    
    _circleCount++;
    
    [self updateProgressCount];
}


#pragma mark -

- (void)startTimer
{
	[_centerLabelTimer invalidate];
	_centerLabelTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                              target:self
                                            selector:@selector(animateCenterLabel)
                                            userInfo:nil
                                             repeats:YES];
    _centerCount = 1;
    
    [_circleLabelTimer invalidate];
	_circleLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                         target:self
                                                       selector:@selector(animateCircleLabel)
                                                       userInfo:nil
                                                        repeats:YES];
    _circleCount = 1;
    
    if ( self.whenProgressStarted )
    {
        self.whenProgressStarted();
    }
}

- (void)stopTimer
{
	[_centerLabelTimer invalidate];
	_centerLabelTimer = nil;
    
    [_circleLabelTimer invalidate];
	_circleLabelTimer = nil;
    
    if ( self.whenProgressStoped )
    {
        self.whenProgressStoped();
    }
}

@end

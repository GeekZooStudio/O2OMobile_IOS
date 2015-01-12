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

#import "AudioContext.h"

#pragma mark -

@implementation AudioContext

static BOOL __inited = NO;

+ (void)active
{
	if ( NO == __inited )
	{
		UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
		AudioSessionSetProperty( kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory );

		UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
		AudioSessionSetProperty ( kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride );

		AVAudioSession * audioSession = [AVAudioSession sharedInstance];
		[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
		[audioSession setActive:YES error:NULL];

		__inited = YES;
	}
}

+ (void)deactive
{
	if ( __inited )
	{
		AVAudioSession * audioSession = [AVAudioSession sharedInstance];
		[audioSession setActive:NO error:NULL];
		
		__inited = NO;
	}
}

+ (void)switchRecord
{
	UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
	AudioSessionSetProperty( kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory );
	
	AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
}

+ (void)switchPlayEarphone
{
	UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
	AudioSessionSetProperty( kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory );
	
	AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];	
}

+ (void)switchPlaySpeaker
{
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty( kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory );
	
	AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:NULL];
}

+ (void)enableProximityMonitor
{
	[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
}

+ (void)disableProximityMonitor
{
	[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

@end

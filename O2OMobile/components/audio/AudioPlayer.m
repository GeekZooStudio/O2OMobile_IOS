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

#import "AudioPlayer.h"
#import "AudioCodec.h"
#import "AudioType.h"
#import "AudioContext.h"

#pragma mark -

@interface AudioPlayer()
{
	NSError *			_lastError;
	AVAudioPlayer *		_player;
}
@end

#pragma mark -

@implementation AudioPlayer

DEF_NOTIFICATION( PLAYING )
DEF_NOTIFICATION( STOPPED )
DEF_NOTIFICATION( FAILED )

DEF_SINGLETON( AudioPlayer )

@synthesize lastError = _lastError;

- (id)init
{
	self = [super init];
	if ( self )
	{
		[AudioContext active];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(sensorStateDidChanged:)
													 name:UIDeviceProximityStateDidChangeNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[_player setDelegate:nil];

	if ( [_player isPlaying] )
	{
		[_player stop];
	}
	
	[_player release];
	[_lastError release];
	
	[super dealloc];
}

- (void)playData:(NSData *)data
{
	if ( _player )
	{
		if ( [_player isPlaying] )
		{
			[_player stop];
		}
		
		[_player release];
		_player = nil;
	}

	BOOL closeToFace = [[UIDevice currentDevice] proximityState];
	if ( closeToFace )
	{
		[AudioContext enableProximityMonitor];
		[AudioContext switchPlayEarphone];
	}
	else
	{
		[AudioContext enableProximityMonitor];
		[AudioContext switchPlaySpeaker];
	}

	if ( nil == data || 0 == data.length )
		return;

	NSData *	playableData = nil;
	NSInteger	type = [AudioType guessType:data];

	if ( AudioType.AMR == type )
	{
		playableData = [AudioCodec AMR2WAV:data];
	}
	else if ( AudioType.WAV == type )
	{
		playableData = data;
	}
	else if ( AudioType.CAF == type )
	{
		playableData = data;
	}
	
	if ( nil == playableData )
	{
		self.lastError = nil;
		[self postNotification:self.FAILED];
		return;
	}

	BOOL		succeed = NO;
	NSError *	error = nil;

	_player = [[AVAudioPlayer alloc] initWithData:playableData error:&error];
	if ( _player )
	{
		[_player setDelegate:self];
		[_player prepareToPlay];
		[_player setVolume:1.0];
		
		succeed = [_player play];
	}

	if ( succeed )
	{
		self.lastError = nil;
		[self postNotification:self.PLAYING];		
	}
	else
	{
		self.lastError = error;
		[self postNotification:self.FAILED];
	}	
}

- (void)playFile:(NSString *)file
{
	if ( nil == file || 0 == file.length )
		return;

	NSData * data = [NSData dataWithContentsOfFile:file];
	if ( nil == data || 0 == data.length )
		return;
	
	[self playData:data];
}

- (void)stop
{
	if ( _player && [_player isPlaying] )
	{
		[_player stop];
	}
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate

/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if ( flag )
	{
		self.lastError = nil;
		[self postNotification:self.STOPPED];
	}
	else
	{
		self.lastError = [NSError errorWithDomain:nil code:0 userInfo:nil];		
		[self postNotification:self.FAILED];
	}
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	self.lastError = error;
	[self postNotification:self.FAILED];
}

#if TARGET_OS_IPHONE

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	
}

/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
	
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
	
}

/* audioPlayerEndInterruption: is called when the preferred method, audioPlayerEndInterruption:withFlags:, is not implemented. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	
}

#endif // TARGET_OS_IPHONE

#pragma mark -

- (void)sensorStateDidChanged:(NSNotification *)notification
{
	BOOL closeToFace = [[UIDevice currentDevice] proximityState];
	if ( closeToFace )
	{
		[AudioContext switchPlayEarphone];
	}
	else
	{
		[AudioContext switchPlaySpeaker];
	}
}

@end

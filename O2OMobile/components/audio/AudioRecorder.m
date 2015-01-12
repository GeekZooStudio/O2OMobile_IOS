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

#import "AudioConfig.h"
#import "AudioRecorder.h"
#import "AudioContext.h"
#import "AudioCodec.h"
#import "amr.h"

#pragma mark -

@interface AudioRecorder()
{
	NSError *			_lastError;
	AVAudioRecorder *	_recorder;
	NSTimeInterval		_startTime;
	NSTimeInterval		_duration;
}

- (NSString *)tmpPath;

@end

#pragma mark -

@implementation AudioRecorder

DEF_NOTIFICATION( RECORDING )
DEF_NOTIFICATION( STOPPED )
DEF_NOTIFICATION( FAILED )

DEF_SINGLETON( AudioPlayer )

@synthesize lastError = _lastError;
@dynamic PCMData;
@dynamic AMRData;
@synthesize duration = _duration;
@synthesize maxDuration = _maxDuration;

- (id)init
{
	self = [super init];
	if ( self )
	{
		[AudioContext active];
		
		_maxDuration = 30.0f;
		
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

	[_recorder setDelegate:nil];
	[_recorder stop];
	[_recorder release];

	[_lastError release];
	
	[super dealloc];
}

- (NSString *)tmpPath
{
	return [[BeeSandbox tmpPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp.caf"]];
}

- (NSData *)PCMData
{
	NSString * path = [self tmpPath];
	if ( nil == path )
		return nil;
	
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
		return nil;
	
	return [NSData dataWithContentsOfFile:path];
}

- (NSData *)AMRData
{
	NSData * data = self.PCMData;
	if ( nil == data )
		return nil;
	
	return [AudioCodec CAF2AMR:data];
}

- (void)record
{
	if ( _recorder )
	{
		if ( [_recorder isRecording] )
		{
			[_recorder stop];
		}
		
		[_recorder release];
		_recorder = nil;
	}

	[AudioContext switchRecord];
	[AudioContext disableProximityMonitor];

	NSDictionary * recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithInt:kAudioFormatLinearPCM],			AVFormatIDKey,
									[NSNumber numberWithFloat:DEFAULT_SAMPLE_RATE],			AVSampleRateKey,
									[NSNumber numberWithInt:DEFAULT_NUMBER_OF_CHANNELS],	AVNumberOfChannelsKey,
									[NSNumber numberWithInt:DEFAULT_BIT_DEPTH],				AVLinearPCMBitDepthKey,
									[NSNumber numberWithBool:NO],							AVLinearPCMIsNonInterleaved,
									[NSNumber numberWithBool:NO],							AVLinearPCMIsFloatKey,
									[NSNumber numberWithBool:NO],							AVLinearPCMIsBigEndianKey,
									nil];

	NSString *	path = [self tmpPath];
	NSURL *		url = [NSURL fileURLWithPath:path];
	NSError *	error = nil;
	BOOL		succeed = NO;

	[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];

    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
	if ( _recorder )
	{
		[_recorder setDelegate:self];
		[_recorder prepareToRecord];

		succeed = [_recorder recordForDuration:_maxDuration];
	}

	_duration = 0;
	_startTime = [NSDate timeIntervalSinceReferenceDate];

	if ( succeed )
	{
		self.lastError = nil;
		[self postNotification:self.RECORDING];
	}
	else
	{
		self.lastError = error;
		[self postNotification:self.FAILED];
	}	
}

- (void)stop
{
	if ( _recorder )
	{
		if ( [_recorder isRecording] )
		{
			[_recorder stop];
		}
		
//		[_recorder release];
//		_recorder = nil;
	}
}

#pragma mark -
#pragma mark AVAudioRecorderDelegate

/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
	if ( flag )
	{
		_duration = ([NSDate timeIntervalSinceReferenceDate] - _startTime) * 1000.0f;

		self.lastError = nil;
		[self postNotification:self.STOPPED];
	}
	else
	{
		_duration = 0;
		
		self.lastError = [NSError errorWithDomain:nil code:0 userInfo:nil];
		[self postNotification:self.FAILED];
	}
	
	if ( _recorder )
	{
		[_recorder release];
		_recorder = nil;
	}
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
	_duration = 0;
	
	self.lastError = error;
	[self postNotification:self.FAILED];
	
	if ( _recorder )
	{
		[_recorder release];
		_recorder = nil;
	}
}

#if TARGET_OS_IPHONE

/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
	
}

/* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
	
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags
{
	
}

/* audioRecorderEndInterruption: is called when the preferred method, audioRecorderEndInterruption:withFlags:, is not implemented. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder
{
	
}

#endif // TARGET_OS_IPHONE

#pragma mark -

- (void)sensorStateDidChanged:(NSNotification *)notification
{
	if ( _recorder && [_recorder isRecording] )
	{
		[AudioContext switchRecord];
	}
}

@end

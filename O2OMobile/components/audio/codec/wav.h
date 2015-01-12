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

#pragma mark -

// chunk header

typedef struct
{
	char	chChunkID[4];
	int		nChunkSize;
} XCHUNKHEADER;

// wave header

typedef struct
{
	short	nFormatTag;
	short	nChannels;
	int		nSamplesPerSec;
	int		nAvgBytesPerSec;
	short	nBlockAlign;
	short	nBitsPerSample;
} WAVEFORMAT;

// wave header X

typedef struct
{
	short	nFormatTag;
	short	nChannels;
	int		nSamplesPerSec;
	int		nAvgBytesPerSec;
	short	nBlockAlign;
	short	nBitsPerSample;
	short	nExSize;
} WAVEFORMATX;

// riff header

typedef struct
{
	char	chRiffID[4];
	int		nRiffSize;
	char	chRiffFormat[4];
} RIFFHEADER;

// fmt block

typedef struct
{
	char		chFmtID[4];
	int			nFmtSize;
	WAVEFORMAT	wf;
} FMTBLOCK;

#pragma mark -

@interface WAV : NSObject

+ (NSData *)header:(NSUInteger)frameCount;
+ (NSData *)header:(NSUInteger)frameCount
		  channels:(short)channels
		sampleRate:(int)samplesPerSec
		   bitRate:(short)bps;

+ (NSInteger)parseOffset:(NSData *)data;

+ (NSInteger)parseFrame:(NSData *)data
				 offset:(NSInteger)offset
			   toSpeech:(short *)speech;

+ (NSInteger)parseFrame:(NSData *)data
				 offset:(NSInteger)offset
			   toSpeech:(short *)speech
			 sampleRate:(NSInteger)sampleRate
			   channels:(NSUInteger)channels
			   bitDepth:(NSUInteger)bitsPerSample;

@end

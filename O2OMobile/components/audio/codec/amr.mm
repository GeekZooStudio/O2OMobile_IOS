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

#import <stdlib.h>
#import <string.h>
#import <stdio.h>
#import "interf_dec.h"
#import "interf_enc.h"

#import "wav.h"
#import "caf.h"
#import "amr.h"
#import "utility.h"

#pragma mark -

#undef	AMR_HEADER
#define AMR_HEADER		("#!AMR\n")

#undef	AMR_FPS
#define AMR_FPS			(50)

#undef	AMR_FRAME_SIZE
#define AMR_FRAME_SIZE	(32)

#undef	AMR_ROUND_UP
#define AMR_ROUND_UP( __double__ )	((int)((double)(__double__) + 0.5))

#pragma mark -

static unsigned int amrEncodeMode[] = { 4750, 5150, 5900, 6700, 7400, 7950, 10200, 12200 };

#pragma mark -

static int CalcFrameSize( unsigned char frameHeader )
{
	int temp1 = 0;
	int temp2 = 0;
	
	temp1 = frameHeader;
	
	temp1 &= 0x78; // 0111-1000
	temp1 >>= 3;
	temp2 = AMR_ROUND_UP( (double)amrEncodeMode[temp1] / (double)AMR_FPS / (double)8 );

	return AMR_ROUND_UP( (double)temp2 + 0.5 );
//	return (int)temp2;
}

static int ReadFirstFrame( const char * bytes, int length, unsigned char * frameBuffer, unsigned char * pStdFrameHeader, int * pStdFrameSize )
{
	int				offset = 0;
	int				frameSize = 0;
	unsigned char	frameHeader = 0;

	if ( length < 1 )
	{
		return 0;
	}

	offset += ReadBytes( bytes + offset, &frameHeader, 1 );
	if ( 0 == offset )
	{
		return 0;
	}
	
	frameSize = CalcFrameSize( frameHeader );

	if ( length < frameSize + 1 )
	{
		return 0;
	}

	frameBuffer[0] = frameHeader;

	offset += ReadBytes( bytes + offset, &frameBuffer[1], frameSize - 1 );
	
	if ( pStdFrameHeader )
	{
		*pStdFrameHeader = frameHeader;
	}
	
	if ( pStdFrameSize )
	{
		*pStdFrameSize = frameSize;
	}

	return offset;
}

static int ReadNextFrame( const char * bytes, int length, unsigned char * frameBuffer, unsigned char stdFrameHeader, int stdFrameSize )
{
	int				offset = 0;
	unsigned char	frameHeader = 0;

	for ( ;; )
	{
		if ( offset >= length )
		{
			break;
		}

		offset += ReadBytes( bytes + offset, &frameHeader, 1 );
		if ( frameHeader == stdFrameHeader )
		{
			break;
		}
	}

	if ( offset + (stdFrameSize - 1) >= length )
	{
		return 0;
	}

	frameBuffer[0] = frameHeader;

	offset += ReadBytes( bytes + offset, &frameBuffer[1], stdFrameSize - 1 );
	return offset;
}

#pragma mark -

@implementation AMR

+ (NSData *)encode:(NSData *)data
{
	return [self encode:data sampleRate:DEFAULT_SAMPLE_RATE channels:DEFAULT_NUMBER_OF_CHANNELS bitDepth:DEFAULT_BIT_DEPTH];
}

+ (NSData *)encode:(NSData *)data sampleRate:(NSInteger)sampleRate channels:(NSInteger)channels bitDepth:(NSInteger)bitsPerSample
{
	if ( nil == data || 0 == data.length )
		return nil;

	int offset = 0;
	int length = data.length;
	
	if ( data.length < 4 )
	{
		return nil;
	}
	
	const char * fourcc = (const char *)data.bytes;
	if ( 0 == strncmp( fourcc, "caff", 4 ) )
	{
		offset = [CAF parseOffset:data];
	}
	else if ( 0 == strncmp( fourcc, "riff", 4 ) )
	{
		offset = [WAV parseOffset:data];
	}
	else
	{
		return nil;
	}
	
	short			speech[160] = { 0 };
	int				wavFrameSize = 0;
	int				amrFrameSize = 0;
	unsigned char	amrFrame[AMR_FRAME_SIZE] = { 0 };
	
	NSMutableData *	amrData = [NSMutableData data];
	[amrData appendBytes:AMR_HEADER length:strlen(AMR_HEADER)];

	void * enstate = Encoder_Interface_init( 0 );
	if ( enstate )
	{
		for ( ;; )
		{
			if ( offset >= length )
				break;

//			fprintf( stderr, "AMR encode, %d/%d\n", offset, length );

			wavFrameSize = [WAV parseFrame:data offset:offset toSpeech:&speech[0] sampleRate:sampleRate channels:channels bitDepth:bitsPerSample];
			if ( 0 == wavFrameSize )
				break;
			
			amrFrameSize = Encoder_Interface_Encode( enstate, MR475/*MR122*/, &speech[0], &amrFrame[0], 0);
			if ( amrFrameSize )
			{
				[amrData appendBytes:&amrFrame[0] length:amrFrameSize];
			}

//			fprintf( stderr, "AMR encode, PCM frame = %d\n", wavFrameSize );
//			fprintf( stderr, "AMR encode, AMR frame = %d\n", amrFrameSize );
			
			offset += wavFrameSize;
		}

		Encoder_Interface_exit( enstate );
	}

	return amrData;
}

+ (NSData *)decode:(NSData *)data
{
	return [self decode:data sampleRate:DEFAULT_SAMPLE_RATE channels:DEFAULT_NUMBER_OF_CHANNELS bitDepth:DEFAULT_BIT_DEPTH];
}

+ (NSData *)decode:(NSData *)data sampleRate:(NSInteger)sampleRate channels:(NSInteger)channels bitDepth:(NSInteger)bitsPerSample
{
	if ( nil == data || 0 == data.length )
	{
		return nil;
	}

	NSMutableData * result = [NSMutableData data];
	NSMutableData * wavData = [NSMutableData data];
	NSData *		wavHeader = nil;
	const char *	bytes = (const char *)data.bytes;
	unsigned int	length = data.length;

	int				offset = 0;
	int				size = 0;
	int				frame = 0;
	int				stdFrameSize = 0;
	unsigned char	stdFrameHeader = 0;
	
	short			pcmFrame[PCM_FRAME_SIZE(sampleRate)];
	unsigned char	amrFrame[AMR_FRAME_SIZE];
	unsigned char	amrHeader[8] = { 0 };

	if ( length < strlen(AMR_HEADER) )
	{
		return nil;
	}
	
	offset += ReadBytes( bytes, &amrHeader[0], strlen(AMR_HEADER) );

	if ( strncmp( (char *)amrHeader, AMR_HEADER, strlen(AMR_HEADER) ) )
	{
		return nil;
	}

	memset( amrFrame, 0, sizeof(amrFrame) );
	memset( pcmFrame, 0, sizeof(pcmFrame) );

	size = ReadFirstFrame( bytes + offset, length - offset, &amrFrame[0], &stdFrameHeader, &stdFrameSize );
	if ( 0 == size )
	{
		return nil;
	}

	offset += size;

	void * destate = Decoder_Interface_init();
	Decoder_Interface_Decode( destate, amrFrame, pcmFrame, 0 );
	[wavData appendBytes:(void *)pcmFrame length:sizeof(short) * PCM_FRAME_SIZE(sampleRate)];

	frame += 1;

	for ( ;; )
	{
		if ( offset >= length )
			break;
	
//		fprintf( stderr, "AMR decode, %d/%d\n", offset, length );
		
		memset( amrFrame, 0, sizeof(amrFrame) );
		memset( pcmFrame, 0, sizeof(pcmFrame) );

		size = ReadNextFrame( bytes + offset, length - offset, &amrFrame[0], stdFrameHeader, stdFrameSize );
		if ( 0 == size )
			break;

//		fprintf( stderr, "AMR decode, PCM frame = %d\n", size );
		
		Decoder_Interface_Decode( destate, amrFrame, pcmFrame, 0 );
		[wavData appendBytes:(void *)pcmFrame length:sizeof(short) * PCM_FRAME_SIZE(sampleRate)];

		frame += 1;
		offset += size;
	}

	Decoder_Interface_exit( destate );

	wavHeader = [WAV header:frame
				   channels:channels
				 sampleRate:sampleRate
					bitRate:bitsPerSample];

	if ( nil == wavHeader )
	{
		return nil;
	}
	
	[result appendData:wavHeader];
	[result appendData:wavData];
	return result;
}

@end

//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import <stdlib.h>
#import <string.h>
#import <stdio.h>

#import "interf_dec.h"
#import "interf_enc.h"

#import "wav.h"
#import "utility.h"

#pragma mark -

static int ReadAudioOffset( const char * bytes, int length )
{
	if ( NULL == bytes || 0 == length )
	{
        return 0;
    }

	RIFFHEADER		riff = { 0 };
	FMTBLOCK		fmt = { 0 };
	WAVEFORMATX		wfx = { 0 };
	XCHUNKHEADER	chunk = { 0 };
	BOOL			found = NO;
	NSUInteger		offset = 0;
	
	if ( length < sizeof(RIFFHEADER) + sizeof(XCHUNKHEADER) )
		return 0;

	offset += ReadBytes( bytes + offset, &riff, sizeof(RIFFHEADER) );
	offset += ReadBytes( bytes + offset, &chunk, sizeof(XCHUNKHEADER) );
	
	if ( chunk.nChunkSize > 16 )
	{
		offset += ReadBytes( bytes + offset, &wfx, sizeof(WAVEFORMATX) );
	}
	else
	{
		memcpy( fmt.chFmtID, chunk.chChunkID, 4 );
		fmt.nFmtSize = chunk.nChunkSize;
		
		offset += ReadBytes( bytes + offset, &fmt.wf, sizeof(WAVEFORMAT) );
	}
	
	while ( NO == found )
	{
		offset += ReadBytes( bytes + offset, &chunk, sizeof(XCHUNKHEADER) );
		
		if ( 0 == memcmp( chunk.chChunkID, "data", 4 ) )
		{
			found = YES;
			break;
		}
		
		offset += chunk.nChunkSize;
	}
	
	return offset;
}

static int ReadPCMFrame( const char * bytes, int length, short speech[], int sampleRate, int channels, int bitsPerSample )
{
	int offset = 0;
	int size = 0;
	int frameSize = PCM_FRAME_SIZE(sampleRate);

	unsigned char  pcmFrame_8b1[1024/*frameSize*/];
	unsigned char  pcmFrame_8b2[1024/*frameSize*/ << 1];
	unsigned short pcmFrame_16b1[1024/*frameSize*/];
	unsigned short pcmFrame_16b2[1024/*frameSize*/ << 1];

	if ( 8 == bitsPerSample && 1 == channels )
	{
		size = (bitsPerSample / 8) * frameSize * channels;
		if ( length < size )
			return 0;
		
//		fprintf( stderr, "PCM frame, %d bps, %d channels, size = %d\n", bitsPerSample, channels, size );
		
		offset += ReadBytes( bytes + offset, &pcmFrame_8b1[0], size );

		for ( int x = 0; x < frameSize; x++ )
		{
			speech[x] = (short)( (short)pcmFrame_8b1[x] << 7 );
		}
	}
	else if ( 8 == bitsPerSample && 2 == channels )
	{
		size = (bitsPerSample / 8) * frameSize * channels;
		if ( length < size )
			return 0;

//		fprintf( stderr, "PCM frame, %d bps, %d channels, size = %d\n", bitsPerSample, channels, size );
		
		offset += ReadBytes( bytes + offset, &pcmFrame_8b2[0], size );

		for ( int x = 0, y = 0; y < frameSize; y++, x += 2 )
		{
//			speech[y] = (short)( (short)pcmFrame_8b2[x + 0] << 7 );
//			speech[y] = (short)( (short)pcmFrame_8b2[x + 1] << 7 );

			short ush1 = (short)pcmFrame_8b2[x + 0];
			short ush2 = (short)pcmFrame_8b2[x + 1];
			short ush = (ush1 + ush2) >> 1;
			speech[y] = (short)( (short)ush << 7 );
		}
	}
	else if ( 16 == bitsPerSample && 1 == channels )
	{
		size = (bitsPerSample / 8) * frameSize * channels;
		if ( length < size )
			return 0;

//		fprintf( stderr, "PCM frame, %d bps, %d channels, size = %d\n", bitsPerSample, channels, size );
		
		offset += ReadBytes( bytes + offset, &pcmFrame_16b1[0], size );

		for ( int x = 0; x < frameSize; x++ )
		{
			speech[x] = (short)( pcmFrame_16b1[x + 0] );
		}
	}
	else if ( 16 == bitsPerSample && 2 == channels )
	{
		size = (bitsPerSample / 8) * frameSize * channels;
		if ( length < size )
			return 0;

//		fprintf( stderr, "PCM frame, %d bps, %d channels, size = %d\n", bitsPerSample, channels, size );
		
		offset += ReadBytes( bytes + offset, &pcmFrame_16b2[0], size );

		for( int x = 0, y = 0; y < frameSize; y++, x += 2 )
		{
//			speech[y] = (short)( pcmFrame_16b2[x+0] );
			speech[y] = (short)( (int)((int)pcmFrame_16b2[x + 0] + (int)pcmFrame_16b2[x + 1]) ) >> 1;
		}
	}

	if ( offset < frameSize * channels )
	{
		return 0;
	}
	
	return offset;
}

#pragma mark -

@implementation WAV

+ (NSData *)header:(NSUInteger)frameCount
{
	return [self header:frameCount
			   channels:1
			 sampleRate:DEFAULT_SAMPLE_RATE
				bitRate:DEFAULT_BIT_DEPTH];
}

+ (NSData *)header:(NSUInteger)frameCount
		  channels:(short)channels
		sampleRate:(int)sampleRate
		   bitRate:(short)bitRate
{
	NSMutableData * headerData = [NSMutableData data];

// riff header
	
	RIFFHEADER riff = { 0 };
	memcpy( riff.chRiffID,		"RIFF", 4 );
	memcpy( riff.chRiffFormat,	"WAVE", 4 );
	riff.nRiffSize = 4;
	riff.nRiffSize += sizeof( XCHUNKHEADER );
	riff.nRiffSize += sizeof( WAVEFORMATX );
	riff.nRiffSize += sizeof( XCHUNKHEADER );
	riff.nRiffSize += frameCount * 160/*PCM_FRAME_SIZE(sampleRate)*/ * sizeof(short);
	[headerData appendBytes:(const void *)&riff length:sizeof(RIFFHEADER)];

	XCHUNKHEADER chunk = { 0 };
	memcpy( chunk.chChunkID, "fmt ", 4 );
	chunk.nChunkSize = sizeof(WAVEFORMATX);
	[headerData appendBytes:(const void *)&chunk length:sizeof(XCHUNKHEADER)];

	WAVEFORMATX wfx = { 0 };
	wfx.nFormatTag		= 1;
	wfx.nChannels		= 1;
	wfx.nSamplesPerSec	= sampleRate;
	wfx.nAvgBytesPerSec = 16000;
	wfx.nBlockAlign		= bitRate / 8;
	wfx.nBitsPerSample	= bitRate;
	[headerData appendBytes:(const void *)&wfx length:sizeof(WAVEFORMATX)];

	XCHUNKHEADER chunk2 = { 0 };
	memcpy( chunk2.chChunkID, "data", 4 );
	chunk2.nChunkSize = frameCount * PCM_FRAME_SIZE(sampleRate) * sizeof(short);
	[headerData appendBytes:(const void *)&chunk2 length:sizeof(XCHUNKHEADER)];

	return headerData;
}

+ (NSInteger)parseOffset:(NSData *)data
{
	if ( nil == data || 0 == data.length )
		return 0;
	
	return (NSUInteger)ReadAudioOffset( (const char *)data.bytes, data.length );
}

+ (NSInteger)parseFrame:(NSData *)data offset:(NSInteger)offset toSpeech:(short *)speech
{
	return [self parseFrame:data offset:offset toSpeech:speech sampleRate:DEFAULT_SAMPLE_RATE channels:1 bitDepth:16];
}

+ (NSInteger)parseFrame:(NSData *)data offset:(NSInteger)offset toSpeech:(short *)speech sampleRate:(NSInteger)sampleRate channels:(NSUInteger)channels bitDepth:(NSUInteger)bitsPerSample
{
	if ( nil == data || 0 == data.length )
		return 0;

	char *	bytes = (char *)data.bytes + offset;
	int		length = data.length - offset;

	if ( length <= 0 )
		return 0;
	
	return ReadPCMFrame( bytes, length, speech, sampleRate, channels, bitsPerSample );
}

@end

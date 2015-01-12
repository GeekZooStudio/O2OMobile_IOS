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

#import "caf.h"
#import "wav.h"
#import "utility.h"

#pragma mark -

static int ReadAudioOffset( const char * bytes, int length )
{
    if ( NULL == bytes || 0 == length )
	{
        return 0;
    }

	int				offset = 0;
	unsigned char	cafHeader[4] = { 0 };
	
	if ( length < 4 )
	{
        return 0;
    }

	offset += ReadBytes( bytes + offset, &cafHeader[0], 4 );
	
	if ( strncmp( (char *)cafHeader, "caff", 4 ) )
	{
		return 0;
	}
    
	unsigned short	fileVersion;
	unsigned short	fileFlags;
    unsigned int	magicHeaders[3] = { 0x64657363, 0x66726565, 0x64617461 };
	
	fileVersion = ReadU16( bytes + offset );
	fileFlags = ReadU16( bytes + offset + 2 );
	
	offset += 4;
	
    for ( int i = 0; i < 3; ++i )
	{
		int					chunkType = 0;
		signed long long	chunkSize = 0;
		
		chunkType = ReadU32( bytes + offset ); offset += 4;
		if ( chunkType != magicHeaders[i] )
		{
			return 0;
		}

		chunkSize = Read64( bytes + offset ); offset += 8;
		if ( chunkSize <= 0 )
		{
			return 0;
		}

		if ( 2 == i )
		{
			break;
		}
		
		offset += chunkSize;
    }

    return offset;
}

#pragma mark -

@implementation CAF

+ (NSInteger)parseOffset:(NSData *)data
{
	return (NSUInteger)ReadAudioOffset( (const char *)data.bytes, data.length );
}

@end

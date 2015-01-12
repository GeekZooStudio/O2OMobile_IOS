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

#import "AudioType.h"

#pragma mark -

@implementation AudioType

DEF_INT( UNKNOWN,	0 )
DEF_INT( AMR,		1 );
DEF_INT( WAV,		2 );
DEF_INT( CAF,		3 );

+ (NSInteger)guessType:(NSData *)data
{
	if ( nil == data )
		return self.UNKNOWN;

	const char * header = (const char *)data.bytes;

	if ( data.length >= 6 )
	{
		if ( 0 == strncmp( header, "#!AMR\n", 6 ) )
		{
			return self.AMR;
		}
	}
	else if ( data.length >= 4 )
	{
		if ( 0 == strncmp( header, "caff", 4 ) )
		{
			return self.CAF;
		}
		else if ( 0 == strncmp( header, "riff", 4 ) )
		{
			return self.WAV;
		}
	}

	return self.UNKNOWN;
}

@end

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

#import "CommentModel.h"

#pragma mark -

#undef	PAGE_SIZE
#define PAGE_SIZE	(10)

#pragma mark -

@implementation CommentModel

DEF_SIGNAL( DID_COMMENT )
DEF_SIGNAL( DID_COMMENT_FAIL )

DEF_SINGLETON( CommentModel )

- (void)load
{
}

- (void)unload
{
}

#pragma mark -

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
}

#pragma mark -

- (void)commentWithText:(NSString *)text rank:(int)rank
{
    CONTENT * content = [[[CONTENT alloc] init] autorelease];
    
    if ( text && text.length )
    {
        content.text = text;
    }
    else
    {
        content.text = @"";
    }

	[API_COMMENT_SEND cancel:self];
    
	API_COMMENT_SEND * api = [API_COMMENT_SEND apiWithResponder:self];
    
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;
    
    api.req.order_id = self.order_id;
	api.req.content = content;
    api.req.rank = @(rank);
	
	api.whenUpdate = ^
	{
		@normalize(api);
        
		if ( api.sending )
		{
			[self sendUISignal:self.RELOADING];
		}
		else
		{
			if ( api.succeed && api.resp.succeed.boolValue )
			{
                [self sendUISignal:self.DID_COMMENT];
			}
            else
            {
                [self sendUISignal:self.DID_COMMENT_FAIL];
            }
		}
	};
    
	[api send];
}

@end

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

#import "FooterLoader_iPhone.h"

#pragma mark -

@implementation FooterLoader_iPhone

DEF_OUTLET( BeeUIActivityIndicatorView,	ind );
DEF_OUTLET( BeeUILabel,					state );

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
	self.ind.hidden = YES;
//	self.state.text = @"点击加载更多";
}

- (void)unload
{
}

#pragma mark -

ON_SIGNAL3( FooterLoader_iPhone, STATE_CHANGED, signal )
{
	if ( self.loading )
	{
		self.ind.animating = YES;
		self.state.text = __TEXT(@"xlistview_header_hint_loading");
	}
	else
	{
		self.ind.animating = NO;

		if ( self.more )
		{
			self.userInteractionEnabled = YES;
			self.state.text = @"点击加载更多";
		}
		else
		{
			self.userInteractionEnabled = NO;
			self.state.text = __TEXT(@"xlistview_footer_hint_over");
		}
	}
}

@end

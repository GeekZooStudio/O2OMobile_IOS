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

#import "HeaderLoader_iPhone.h"

#pragma mark -

@implementation HeaderLoader_iPhone

DEF_OUTLET( BeeUIImageView,				logo );
DEF_OUTLET( BeeUIImageView,				arrow );
DEF_OUTLET( BeeUIActivityIndicatorView,	ind );
DEF_OUTLET( BeeUILabel,					state2 );
DEF_OUTLET( BeeUILabel,					date );

@synthesize lastDate = _lastDate;

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
    self.lastDate = [NSDate date];
    
	self.state2.text = __TEXT(@"xlistview_header_hint_normal");
	self.arrow.hidden = NO;
	self.ind.hidden = YES;
	self.date.text = [NSString stringWithFormat:@"%@%@",__TEXT(@"xlistview_header_last_time"),[self.lastDate timeAgo]];
}

- (void)unload
{
}

#pragma mark -

ON_SIGNAL3( HeaderLoader_iPhone, STATE_CHANGED, signal )
{
	if ( self.animated )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.2f];
	}
    
	if ( self.pulling )
	{
		self.arrow.hidden = NO;
		self.arrow.transform = CGAffineTransformRotate( CGAffineTransformIdentity, (M_PI / 360.0f) * -359.0f );
		
		self.state2.text = __TEXT( @"xlistview_header_hint_ready" );
		self.date.text = [NSString stringWithFormat:@"%@%@", __TEXT(@"xlistview_header_last_time"),[self.lastDate timeAgo]];
	}
	else if ( self.loading )
	{
		self.ind.animating = YES;
		self.arrow.hidden = YES;
		
		self.state2.text = __TEXT(@"xlistview_header_hint_loading");
		self.date.text = [NSString stringWithFormat:@"%@%@", __TEXT(@"xlistview_header_last_time"),[self.lastDate timeAgo]];
        
        self.lastDate = [NSDate date];
	}
	else
	{
		self.arrow.hidden = NO;
		self.arrow.transform = CGAffineTransformIdentity;
		
		self.ind.animating = NO;
        
		self.state2.text = __TEXT(@"xlistview_header_hint_normal");
		self.date.text = [NSString stringWithFormat:@"%@%@", __TEXT(@"xlistview_header_last_time"),[self.lastDate timeAgo]];
	}
	
	if ( self.animated )
	{
		[UIView commitAnimations];
	}
    
	self.RELAYOUT();
}

ON_SIGNAL3( HeaderLoader_iPhone, FRAME_CHANGED, signal )
{
	self.RELAYOUT();
}

@end

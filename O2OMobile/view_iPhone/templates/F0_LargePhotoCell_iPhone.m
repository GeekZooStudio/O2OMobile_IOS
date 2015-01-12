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

#import "F0_LargePhotoCell_iPhone.h"

#pragma mark -

@implementation F0_LargePhotoCell_iPhone

DEF_OUTLET( BeeUIImageView, photo );

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
}

- (void)unload
{
}

- (void)dataDidChanged
{
	USER * user = self.data;
	
	if ( user.avatar.thumb.length )
	{
		[self.photo GET:user.avatar.thumb useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
	}
	else if ( user.avatar.large.length )
	{
		[self.photo GET:user.avatar.large useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
	}
	else
	{
		self.photo.data = @"e8_profile_no_avatar.png";
	}
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

- (void)showInContainer:(id)container
{
	UIView * containerView = nil;
	
	if ( [container isKindOfClass:[UIView class]] )
	{
		containerView = container;
	}
	else if ( [container isKindOfClass:[UIViewController class]] )
	{
		containerView = [container view];
	}

	if ( containerView )
	{
		[containerView transitionFade];
		[containerView addSubview:self];
	}
}

- (void)hide
{
	[self.superview transitionFade];
	[self removeFromSuperview];
}

ON_SIGNAL2( mask, signal )
{
	[self hide];
}

@end

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

#import "F0_ProfileHeaderCell_iPhone.h"

#pragma mark -

@implementation F0_ProfileHeaderCell_iPhone
{
	BOOL _loading;
}

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView,	avatar );
DEF_OUTLET( BeeUILabel,		name );
DEF_OUTLET( BeeUILabel,		sign );
DEF_OUTLET( BeeUILabel,		balance );
DEF_OUTLET( BeeUIButton,	refresh );

- (void)load
{
    self.name.adjustsFontSizeToFitWidth = YES;
}

- (void)unload
{
}

- (void)dataDidChanged
{
	UserModel * userModel = self.data;
	if ( userModel )
	{
		// self.avatar.url = userModel.user.avatar.large;
		if ( userModel.user.avatar.thumb.length )
		{
			[self.avatar GET:userModel.user.avatar.thumb useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
		}
		else if ( userModel.user.avatar.large.length )
		{
			[self.avatar GET:userModel.user.avatar.large useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
		}
		else
		{
			self.avatar.data = @"e8_profile_no_avatar.png";
		}
		
		if ( userModel.user.nickname && userModel.user.nickname.length )
		{
			self.name.text = userModel.user.nickname;
		}
		else
		{
			self.name.text = @"";
		}
		
		if ( userModel.user.signature && userModel.user.signature.length )
		{
			self.sign.text = userModel.user.signature;
		}
		else
		{
			self.sign.text = @"没有签名";
		}

		if ( userModel && [[UserModel sharedInstance].user.id isEqualToNumber:userModel.user.id] )
		{
			self.balance.text = [NSString stringWithFormat:@"%@%@%@", __TEXT(@"balance"),userModel.balance ? [userModel.balance currencyStyleString]: @"0.00",__TEXT(@"yuan")];
		}
		else
		{
			self.balance.text = @"";
		}

		if ( [userModel loading] )
		{
			[self startRotate];
		}
	}
}

- (void)startRotate
{
	if ( NO == _loading )
	{
		self.refresh.transform = CGAffineTransformIdentity;
		
		[self rotateStep1];
		
		_loading = YES;
	}
}

- (void)rotateStep1
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(rotateStep2)];

	self.refresh.transform = CGAffineTransformMakeRotation( - (M_PI - 0.0001) );
	
	[UIView commitAnimations];
}

- (void)rotateStep2
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(rotateStop)];
	
	self.refresh.transform = CGAffineTransformMakeRotation( - (M_PI * 1.9f) );
	
	[UIView commitAnimations];
}

- (void)rotateStop
{
	_loading = NO;
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end

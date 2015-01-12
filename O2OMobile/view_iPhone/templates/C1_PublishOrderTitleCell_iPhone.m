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

#import "C1_PublishOrderTitleCell_iPhone.h"

#pragma mark -

@implementation C1_PublishOrderTitleCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUILabel,      title )
DEF_OUTLET( BeeUIButton,     toggle )
DEF_OUTLET( BeeUIImageView,  indictor )
DEF_OUTLET( BeeUIImageView,  background )

@synthesize expanded = _expanded;

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
}

- (void)layoutDidFinish
{
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated
{
    if ( animated )
    {
        self.toggle.userInteractionEnabled = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didAnimationStop)];
    }
    
    if ( expanded )
    {
        self.indictor.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }
    else
    {
        
        self.indictor.layer.transform = CATransform3DIdentity;
    }
    
    if ( animated )
    {
        [UIView commitAnimations];
    }
}

- (void)didAnimationStop
{
    self.toggle.userInteractionEnabled = YES;
}

- (void)setExpanded:(BOOL)expanded
{
    if ( expanded == _expanded )
        return;
    
    _expanded = expanded;
    
    [self setExpanded:expanded animated:YES];
}

#pragma mark -

- (void)enableToggle
{
    self.indictor.hidden = NO;
    self.toggle.enabled = YES;
}

- (void)disableToggle
{
    self.indictor.hidden = YES;
    self.toggle.enabled = NO;
}

#pragma mark - signal

ON_SIGNAL3( C1_PublishOrderTitleCell_iPhone, toggle, signal )
{
    self.expanded = !self.expanded;
}

@end

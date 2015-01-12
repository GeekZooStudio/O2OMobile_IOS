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

#import "F8_ReviewBoardCell_iPhone.h"

#pragma mark -

@implementation F8_ReviewBoardCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView,	avatar )
DEF_OUTLET( BeeUILabel,		name )
DEF_OUTLET( BeeUIImageView, star1 )
DEF_OUTLET( BeeUIImageView, star2 )
DEF_OUTLET( BeeUIImageView, star3 )
DEF_OUTLET( BeeUIImageView, star4 )
DEF_OUTLET( BeeUIImageView, star5 )
DEF_OUTLET( BeeUILabel,		time )
DEF_OUTLET( BeeUILabel,		text )

- (void)load
{
    self.avatar.tapEnabled = YES;
}

- (void)unload
{
}

- (void)dataDidChanged
{
	COMMENT * comment = self.data;
	if ( comment )
	{
		self.avatar.url = comment.user.avatar.large;
		self.name.text = comment.user.nickname;
		self.time.text = [[comment.created_at asNSDate] timeAgo];
        
        if ( comment.content.text && comment.content.text.length )
        {
            self.text.text = comment.content.text;
        }
        else
        {
            self.text.text = @"无评价";
        }
		
		[self updateStars:comment.rank];
	}
}

#pragma mark -

- (void)updateStars:(NSNumber *)rank
{
    switch ( rank.integerValue )
    {
        case 0:
        {
            [self offStars];
        }
            break;
        case 1:
        {
            [self offStars];
            self.star1.data = @"b7_star_on.png";
        }
            break;
        case 2:
        {
            [self offStars];
            self.star1.data = @"b7_star_on.png";
            self.star2.data = @"b7_star_on.png";
        }
            break;
        case 3:
        {
            [self onStars];
            self.star4.data = @"b7_star_off.png";
            self.star5.data = @"b7_star_off.png";
        }
            break;
        case 4:
        {
            [self onStars];
            self.star5.data = @"b7_star_off.png";
        }
            break;
        case 5:
        {
            [self onStars];
        }
            break;
            
        default:
            break;
    }
}

- (void)offStars
{
    self.star1.data = @"b7_star_off.png";
    self.star2.data = @"b7_star_off.png";
    self.star3.data = @"b7_star_off.png";
    self.star4.data = @"b7_star_off.png";
    self.star5.data = @"b7_star_off.png";
}

- (void)onStars
{
    self.star1.data = @"b7_star_on.png";
    self.star2.data = @"b7_star_on.png";
    self.star3.data = @"b7_star_on.png";
    self.star4.data = @"b7_star_on.png";
    self.star5.data = @"b7_star_on.png";
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end

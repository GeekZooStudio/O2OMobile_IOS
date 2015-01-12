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

#import "D4_OrderCommentInfoCell_iPhone.h"

#pragma mark -

@implementation D4_OrderCommentInfoCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    self.avatar.tapEnabled = YES;
    self.name.adjustsFontSizeToFitWidth = YES;
}

- (void)unload
{
}

- (void)dataDidChanged
{
    USER * user = self.data[@"user"];
    COMMENT * comment = self.data[@"comment"];
    
    if ( self.data )
    {
        self.avatar.data = user.avatar.thumb;
        self.name.data = user.nickname;
        self.time.data = [[comment.created_at asNSDate] timeAgo];
        [self updateStars:comment.rank];
    }
    
    if ( comment.content.text && comment.content.text.length )
    {
        self.content.data = comment.content.text;
    }
    else
    {
        self.content.data = @"无评价";
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

#pragma mark -

- (void)updateStars:(NSNumber *)rate
{
    int rank = rate.intValue;
    
    switch ( rank )
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

@end

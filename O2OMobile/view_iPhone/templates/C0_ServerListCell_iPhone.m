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

#import "C0_ServerListCell_iPhone.h"
#import "LOCATION+Distance.h"
#import "model.h"

#pragma mark -

@implementation C0_ServerListCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, avatar )
DEF_OUTLET( BeeUILabel, name )
DEF_OUTLET( BeeUILabel, distance )
DEF_OUTLET( BeeUIImageView, star1 )
DEF_OUTLET( BeeUIImageView, star2 )
DEF_OUTLET( BeeUIImageView, star3 )
DEF_OUTLET( BeeUIImageView, star4 )
DEF_OUTLET( BeeUIImageView, star5 )
DEF_OUTLET( BeeUILabel, price )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        SIMPLE_USER * user = self.data;
        
        if ( user.avatar.thumb.length )
        {
            [self.avatar GET:user.avatar.thumb useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
        }
        else if ( user.avatar.large.length )
        {
            [self.avatar GET:user.avatar.large useCache:YES placeHolder:[UIImage imageNamed:@"e8_profile_no_avatar.png"]];
        }
        else
        {
            self.avatar.data = @"e8_profile_no_avatar.png";
        }
        
        self.name.data = user.nickname;
        self.distance.data = [NSString stringWithFormat:@"%.f %@", user.location.distance,__TEXT(@"meter")]; 
        self.price.data = [NSString stringWithFormat:@"%@%@",user.current_service_price,__TEXT(@"yuan")];
        [self updateStars:user.comment_goodrate];
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

#pragma mark -

- (void)updateStars:(NSString *)rate
{
    int rank = ( (rate.floatValue) * 100 ) / 20 + 1;
    
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

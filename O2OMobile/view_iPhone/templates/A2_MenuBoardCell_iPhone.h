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

#import "Bee.h"
#import "BadgeNumber_iPhone.h"

#pragma mark -

@interface A2_MenuBoardCell_iPhone : BeeUICell

AS_OUTLET( BeeUIImageView, avatar )
AS_OUTLET( BeeUILabel, name )
AS_OUTLET( BeeUILabel, balance )
AS_OUTLET( BeeUIButton, signin )

AS_OUTLET( BadgeNumber_iPhone, message_badge )

AS_OUTLET( BeeUIImageView, home_item_icon )
AS_OUTLET( BeeUIImageView, publish_item_icon )
AS_OUTLET( BeeUIImageView, receive_item_icon )
AS_OUTLET( BeeUIImageView, message_item_icon )
AS_OUTLET( BeeUIImageView, invitation_item_icon )

AS_OUTLET( BeeUILabel, home_title )
AS_OUTLET( BeeUILabel, publish_title )
AS_OUTLET( BeeUILabel, receive_title )
AS_OUTLET( BeeUIButton, receive )
AS_OUTLET( BeeUILabel, message_title )
AS_OUTLET( BeeUILabel, invitation_title )

AS_OUTLET( BeeUIImageView, ac1 )
AS_OUTLET( BeeUIImageView, ac2 )
AS_OUTLET( BeeUIImageView, ac3 )
AS_OUTLET( BeeUIImageView, ac4 )
AS_OUTLET( BeeUIImageView, ac5 )

AS_OUTLET( BeeUILabel, invitation )

- (void)selectHome;

- (void)selectPublish;

- (void)selectReceive;

- (void)selectMessage;

@end

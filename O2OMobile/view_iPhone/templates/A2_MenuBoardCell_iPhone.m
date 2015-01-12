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

#import "A2_MenuBoardCell_iPhone.h"
#import "model.h"

#pragma mark -

@implementation A2_MenuBoardCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, avatar )
DEF_OUTLET( BeeUILabel, name )
DEF_OUTLET( BeeUILabel, balance )
DEF_OUTLET( BeeUIButton, signin )

DEF_OUTLET( BadgeNumber_iPhone, message_badge )

DEF_OUTLET( BeeUIImageView, home_item_icon )
DEF_OUTLET( BeeUIImageView, publish_item_icon )
DEF_OUTLET( BeeUIImageView, receive_item_icon )
DEF_OUTLET( BeeUIImageView, message_item_icon )
DEF_OUTLET( BeeUIImageView, invitation_item_icon )

DEF_OUTLET( BeeUILabel, home_title )
DEF_OUTLET( BeeUILabel, publish_title )
DEF_OUTLET( BeeUILabel, receive_title )
DEF_OUTLET( BeeUIButton, receive )
DEF_OUTLET( BeeUILabel, message_title )
DEF_OUTLET( BeeUILabel, invitation_title )

DEF_OUTLET( BeeUIImageView, ac1 )
DEF_OUTLET( BeeUIImageView, ac2 )
DEF_OUTLET( BeeUIImageView, ac3 )
DEF_OUTLET( BeeUIImageView, ac4 )
DEF_OUTLET( BeeUIImageView, ac5 )

DEF_OUTLET( BeeUILabel, invitation )

#pragma mark -

- (void)load
{
    [self selectHome];
}

- (void)unload
{
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        USER * user = ((UserModel *)self.data).user;
		
		if ( user )
		{
            if ( user.user_group.intValue == USER_GROUP_NEWBEE )
            {
                self.receive_title.text = @"申请自由人";
                self.receive.enabled = YES;
            }
            else if ( user.user_group.intValue == USER_GROUP_FREEMAN_INREVIEW )
            {
                self.receive_title.text = @"自由人申请审核中";
                self.receive.enabled = NO;
                
                self.receive_title.adjustsFontSizeToFitWidth = YES;
            }
            else
            {
                self.receive_title.text = @"接单";
                self.receive.enabled = YES;
            }

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
		}
        
        UserModel * userModel = self.data;
        if ( userModel.balance )
        {
            self.balance.data = [NSString stringWithFormat:@"%@%@%@",__TEXT(@"balance"),[userModel.balance currencyStyleString],__TEXT(@"yuan")];
        }
        else
        {
            self.balance.data = [NSString stringWithFormat:@"%@0%@", __TEXT(@"balance"),__TEXT(@"yuan")];
        }
    }
}

- (void)layoutDidFinish
{
}

#pragma mark -

- (void)deselectAll
{
    self.home_item_icon.data = @"a3_ico_home.png";
    self.publish_item_icon.data = @"a3_ico_issue.png";
    self.receive_item_icon.data = @"a3_ico_receive.png";
    self.message_item_icon.data = @"a3_ico_message.png";
    self.invitation_item_icon.data = @"a3_ico_friends.png";
    
    self.home_title.textColor = HEX_RGB( 0xffffff );
    self.publish_title.textColor = HEX_RGB( 0xffffff );
    self.receive_title.textColor = HEX_RGB( 0xffffff );
    self.message_title.textColor = HEX_RGB( 0xffffff );
    self.invitation_title.textColor = HEX_RGB( 0xffffff );
    
    self.ac1.data = @"ico_right_grey.png";
    self.ac2.data = @"ico_right_grey.png";
    self.ac3.data = @"ico_right_grey.png";
    self.ac4.data = @"ico_right_grey.png";
    self.ac5.data = @"ico_right_grey.png";
}

- (void)selectHome
{
    [self deselectAll];
    
    self.home_item_icon.data = @"a3_ico_home_selected.png";
    self.home_title.textColor = HEX_RGB( 0xc1f961 );
    self.ac1.data = @"ico_right_green.png";
}

- (void)selectPublish
{
    [self deselectAll];
    
    self.publish_item_icon.data = @"a3_ico_issue_selected.png";
    self.publish_title.textColor = HEX_RGB( 0xc1f961 );
    self.ac2.data = @"ico_right_green.png";
}

- (void)selectReceive
{
    [self deselectAll];
    
    self.receive_item_icon.data = @"a3_ico_receive_selected.png";
    self.receive_title.textColor = HEX_RGB( 0xc1f961 );
    self.ac3.data = @"ico_right_green.png";
}

- (void)selectMessage
{
    [self deselectAll];
    
    self.message_item_icon.data = @"a3_ico_message_selected.png";
    self.message_title.textColor = HEX_RGB( 0xc1f961 );
    self.ac4.data = @"ico_right_green.png";
}

- (void)selectInvitation
{
    [self deselectAll];
    
    self.invitation_item_icon.data = @"a3_ico_friends_selected.png";
    self.invitation_title.textColor = HEX_RGB( 0xc1f961 );
    self.ac5.data = @"ico_right_green.png";
}

#pragma mark -

ON_SIGNAL3( A2_MenuBoardCell_iPhone, profile, signal )
{
    [self deselectAll];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, home, signal )
{
    [self selectHome];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, publish, signal )
{
    [self selectPublish];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, receive, signal )
{
    
    [self selectReceive];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, message, signal )
{
    [self selectMessage];
}

ON_SIGNAL3( A2_MenuBoardCell_iPhone, refferal, signal )
{
    [self selectInvitation];
}

@end

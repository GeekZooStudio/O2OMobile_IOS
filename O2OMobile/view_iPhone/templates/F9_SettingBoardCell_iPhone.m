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

#import "F9_SettingBoardCell_iPhone.h"

#pragma mark -

@implementation F9_SettingBoardCell_iPhone

DEF_OUTLET( BeeUIButton, service )
DEF_OUTLET( BeeUILabel, service_title )
DEF_OUTLET( BeeUIImageView, service_arrow )
DEF_OUTLET( BeeUISwitch, sys_msg )

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
	self.sys_msg.on = [[ConfigModel sharedInstance] isPushEnable];
    
    if ( self.data )
    {
        USER * user = self.data;
        switch ( user.user_group.intValue )
        {
            case USER_GROUP_NEWBEE:
            case USER_GROUP_FREEMAN_INREVIEW:
            {
                self.service_title.textColor = HEX_RGB( 0x989898 );
                self.service_arrow.hidden = YES;
                self.service.enabled = NO;
            }
                break;
            case USER_GROUP_FREEMAN:
            {
                self.service_title.textColor = HEX_RGB( 0x333333 );
                self.service_arrow.hidden = NO;
                self.service.enabled = YES;
            }
                break;
            default:
                break;
        }
        self.service_title.textColor = HEX_RGB( 0x333333 );
        self.service_arrow.hidden = NO;
        self.service.enabled = YES;
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end

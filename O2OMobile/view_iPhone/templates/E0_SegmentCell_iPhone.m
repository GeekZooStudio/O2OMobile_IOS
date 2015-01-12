//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "E0_SegmentCell_iPhone.h"

#pragma mark -

@implementation E0_SegmentCell_iPhone

DEF_OUTLET( BeeUIButton,	one );
DEF_OUTLET( BeeUIButton,	two );

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

- (void)load
{
    _currentTab = -1;
}

- (void)unload
{
}

- (void)layoutDidFinish
{
}

ON_SIGNAL3( E0_SegmentCell_iPhone, one, signal )
{
	[self selectOne];
}

ON_SIGNAL3( E0_SegmentCell_iPhone, two, signal )
{
	[self selectTwo];
}

- (void)selectOne
{
    _currentTab = 0;
    
	$(self.one).SET_CLASS( @"item left active" );
	$(self.two).SET_CLASS( @"item right normal" );
}

- (void)selectTwo
{
    _currentTab = 1;
    
	$(self.one).SET_CLASS( @"item left normal" );
	$(self.two).SET_CLASS( @"item right active" );
}

@end

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

#import "F0_ProfileSkillGroupCell_iPhone.h"
#import "F0_ProfileSkillRowCell_iPhone.h"
#import "F0_ProfileSkillCell_iPhone.h"

#pragma mark -

@implementation F0_ProfileSkillGroupCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

- (void)load
{
}

- (void)unload
{
}

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
	UserModel * userModel = data;
	if ( nil == userModel )
	{
		return CGSizeMake( width, 0.0f );
	}
	else
	{
		if ( 0 == userModel.user.my_certification.count )
		{
			return CGSizeMake( width, 34 );
		}
		else
		{
			return CGSizeMake( width, (userModel.user.my_certification.count + 3) / 4 * 34 );
		}
	}
}

- (void)dataDidChanged
{
	UserModel * userModel = self.data;
	if ( userModel )
	{
		@weakify(self)
		
		self.list.total = userModel.user.my_certification.count;
		self.list.lineCount = 4;
		
		self.list.whenReloading = ^
		{
			@normalize(self)
			
			for ( BeeUIScrollItem * item in self.list.items )
			{
				item.clazz = [F0_ProfileSkillCell_iPhone class];
				item.data = [userModel.user.my_certification objectAtIndex:item.index];
				item.rule = BeeUIScrollLayoutRule_Tile;
				item.size = CGSizeMake( self.list.width / 4.0f, 34 );
			}
		};

		if ( NO == self.list.reloaded )
		{
			[self.list reloadData];
		}
		else
		{
			[self.list asyncReloadData];
		}
	}
}

- (void)layoutWillBegin
{
}

- (void)layoutDidFinish
{
}

@end

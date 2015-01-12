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

#import "F8_ReviewBoard_iPhone.h"
#import "F8_ReviewBoardCell_iPhone.h"
#import "HeaderLoader_iPhone.h"
#import "FooterLoader_iPhone.h"
#import "F0_ProfileBoard_iPhone.h"

#import "AppBoard_iPhone.h"

#pragma mark -

@implementation F8_ReviewBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( F8_ReviewBoard_iPhone )

DEF_OUTLET( BeeUIScrollView, list )

@synthesize uid = _uid;
@synthesize commentListModel = _commentListModel;

- (void)load
{
	self.commentListModel = [CommentListModel model];
	[self.commentListModel addObserver:self];
}

- (void)unload
{
	[self.commentListModel removeObserver:self];
	self.commentListModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationBarShown = YES;
	self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
	self.navigationBarTitle = __TEXT(@"evaluation_list");

	self.list.headerClass = [HeaderLoader_iPhone class];
    self.list.headerShown = YES;
    
    self.list.footerClass = [FooterLoader_iPhone class];
    self.list.footerShown = YES;

	self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	
	@weakify( self )
	
	self.list.whenReloading = ^
	{
		@normalize( self );
		
		self.list.total = self.commentListModel.comments.count;
		
		for ( BeeUIScrollItem * item in self.list.items )
		{
			item.clazz = [F8_ReviewBoardCell_iPhone class];
			item.data = [self.commentListModel.comments objectAtIndex:item.index];
			item.size = CGSizeAuto;
		}
	};
	self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.commentListModel firstPage];
    };
    self.list.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.commentListModel nextPage];
    };
    self.list.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.commentListModel nextPage];
    };
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	self.commentListModel.uid = self.uid;

	if ( NO == self.commentListModel.loaded )
    {
        [self.commentListModel loadCache];
		[self.commentListModel firstPage];
    }
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL3( F8_ReviewBoardCell_iPhone, avatar, signal )
{
    F0_OtherProfileBoard_iPhone * board = [F0_OtherProfileBoard_iPhone board];
    board.uid = self.uid;
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - CommentListModel

ON_SIGNAL3( CommentListModel, RELOADING, signal )
{
	if ( 0 == self.commentListModel.comments.count )
	{
		self.list.headerLoading = YES;
		self.list.footerLoading = NO;
		self.list.footerShown = NO;
	}
	else
	{
		self.list.headerLoading = NO;
		self.list.footerLoading = self.commentListModel.comments.count ? YES : NO;
		self.list.footerShown = YES;
	}
	
	[self.list asyncReloadData];
}

ON_SIGNAL3( CommentListModel, RELOADED, signal )
{
	self.list.headerLoading = NO;
	self.list.footerLoading = NO;
	self.list.footerMore = self.commentListModel.more;
	self.list.footerShown = YES;

	[self.list asyncReloadData];
}

@end

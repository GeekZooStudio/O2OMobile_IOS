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

#import "H0_MessageBoard_iPhone.h"
#import "H0_MessageCell_iPhone.h"
#import "HeaderLoader_iPhone.h"
#import "FooterLoader_iPhone.h"
#import "D1_OrderBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"

#import "NoConnectionCell_iPhone.h"

#import "AppBoard_iPhone.h"

#pragma mark -

@implementation H0_MessageBoard_iPhone
{
    BOOL _isBack;
}

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( H0_MessageBoard_iPhone )

DEF_OUTLET( BeeUIScrollView, list1 )
DEF_OUTLET( BeeUIScrollView, list2 )

DEF_MODEL( MessageListModel, messageListModel )
DEF_MODEL( SystemMessageListModel, systemMessageListModel )

- (void)load
{
    self.messageListModel = [MessageListModel sharedInstance];
    [self.messageListModel addObserver:self];
    
    self.systemMessageListModel = [SystemMessageListModel modelWithObserver:self];
    
    _isBack = NO;
}

- (void)unload
{
    [self.messageListModel removeObserver:self];
    [self.messageListModel cancelMessages];
    
    [self.systemMessageListModel removeObserver:self];
    [self.systemMessageListModel cancelMessages];
	self.systemMessageListModel = nil;
}

#pragma mark -

- (NSInteger)currentTab
{
	return self.segment.currentTab;
}

- (void)reloadAll
{
	if ( 0 == [self currentTab] )
	{
        [self.messageListModel loadCache];
        [self.messageListModel firstPage];
	}
	else
	{
        [self.systemMessageListModel loadCache];
        [self.systemMessageListModel firstPage];
	}
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
    self.segment = [H0_SegmentCell_iPhone cell];
    
	self.navigationBarShown = YES;
	self.navigationBarLeft = [UIImage imageNamed:@"b0_btn_menu.png"];
	self.navigationBarTitle = self.segment;

	@weakify(self);
    
    // LIST1
    self.list1.headerClass = [HeaderLoader_iPhone class];
    self.list1.headerShown = YES;
    
    self.list1.footerClass = [FooterLoader_iPhone class];
    self.list1.footerShown = YES;
    
    self.list1.lineCount = 1;
    self.list1.animationDuration = 0.25f;
    
    self.list1.whenReloading = ^
    {
        @normalize(self);
        
        self.list1.total = self.messageListModel.messages.count;
        
//        if ( self.messageListModel.loaded && 0 == self.messageListModel.messages.count )
//        {
//            self.list1.total = 1;
//            
//            BeeUIScrollItem * item = self.list1.items[0];
//            //            item.clazz = [NoResultCell class];
//            item.size = self.list1.size;
//            item.rule = BeeUIScrollLayoutRule_Tile;
//        }
//        else
        {
            for ( int i = 0; i < self.messageListModel.messages.count; i++ )
            {
                BeeUIScrollItem * item = self.list1.items[i];
                
                item.clazz = [H0_MessageCell_iPhone class];
                item.size = CGSizeMake( self.list1.width, 90 );
                item.data = [self.messageListModel.messages safeObjectAtIndex:i];
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list1.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.messageListModel firstPage];
        
    };
    self.list1.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.messageListModel nextPage];
    };
    self.list1.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.messageListModel nextPage];
    };
    
    // LIST2
    self.list2.headerClass = [HeaderLoader_iPhone class];
    self.list2.headerShown = YES;
    
    self.list2.footerClass = [FooterLoader_iPhone class];
    self.list2.footerShown = YES;
    
    self.list2.lineCount = 1;
    self.list2.animationDuration = 0.25f;
    
    self.list2.whenReloading = ^
    {
        @normalize(self);
        
        self.list2.total = self.systemMessageListModel.messages.count;
        
//        if ( NO == self.systemMessageListModel.loaded && 0 == self.systemMessageListModel.messages.count )
//        {
//            if ( NO == [BeeReachability isReachable] )
//            {
//                self.list2.total = 1;
//                
//                BeeUIScrollItem * item = self.list2.items[0];
//                item.clazz = [NoConnectionCell_iPhone class];
//                item.size = self.list2.size;
//                item.rule = BeeUIScrollLayoutRule_Tile;
//                
//                self.list2.footerShown = NO;
//            }
//        }
//        else
        {
            for ( int i = 0; i < self.systemMessageListModel.messages.count; i++ )
            {
                BeeUIScrollItem * item = self.list2.items[i];
                
                item.clazz = [H0_MessageCell_iPhone class];
                item.size = CGSizeMake( self.list2.width, 90 );
                
                MESSAGE * message = [self.systemMessageListModel.messages safeObjectAtIndex:i];
                message.is_readed = [NSNumber numberWithBool:YES];
                item.data = message;
                
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list2.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.systemMessageListModel firstPage];
        
    };
    self.list2.whenFooterRefresh = ^
    {
        @normalize(self);
        
        [self.systemMessageListModel nextPage];
    };
    self.list2.whenReachBottom = ^
    {
        @normalize(self);
        
        [self.systemMessageListModel nextPage];
    };
    
    self.segment.data = @(self.messageListModel.unreadCount);
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    if ( self.firstEnter )
	{
		[self selectSegmentOne];
	}
}

ON_DID_APPEAR( signal )
{
    if ( NO == _isBack )
    {
        [self reloadAll];
    }
    else
    {
        _isBack = NO;
    }
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[AppBoard_iPhone sharedInstance].menuShown = [AppBoard_iPhone sharedInstance].menuShown ? NO : YES;
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

#pragma mark - H0_SegmentCell_iPhone

ON_SIGNAL3( H0_SegmentCell_iPhone, one, signal )
{
    [self selectSegmentOne];
}

ON_SIGNAL3( H0_SegmentCell_iPhone, two, signal )
{
    [self selectSegmentTwo];
}

- (void)selectSegmentOne
{
    if ( 0 == [self currentTab] )
        return;
    
    self.list1.hidden = NO;
    self.list2.hidden = YES;
    
    [self.segment selectOne];
    
    [self.messageListModel loadCache];
    [self.messageListModel firstPage];
}

- (void)selectSegmentTwo
{
    if ( 1 == [self currentTab] )
        return;
    
    self.list1.hidden = YES;
    self.list2.hidden = NO;
    
    [self.segment selectTwo];
    
    [self.systemMessageListModel loadCache];
    [self.systemMessageListModel firstPage];
}

#pragma mark - H0_MessageCell_iPhone

ON_SIGNAL3( H0_MessageCell_iPhone, mask, signal )
{
    if ( [AppBoard_iPhone sharedInstance].menuShown )
        return;
    
    MESSAGE * message = signal.sourceCell.data;

	if ( NO == [message.is_readed boolValue] )
	{
		[self.messageListModel readMessage:message.id];
	}

    _isBack = YES;
    
	if ( MESSAGE_TYPE_SYSTEM == message.type.intValue )
	{
        if ( message.url.length )
        {
            WebViewBoard_iPhone * board = [WebViewBoard_iPhone board];
            board.urlString = message.url;
            
            [self.stack pushBoard:board animated:YES];
        }
	}
	else if ( MESSAGE_TYPE_ORDER == message.type.intValue )
	{
		if ( message.order_id.integerValue )
		{
			D1_OrderBoard_iPhone * board = [D1_OrderBoard_iPhone board];
			board.order_id = message.order_id;

			[self.stack pushBoard:board animated:YES];
		}
	}
    else if ( MESSAGE_TYPE_OTHER == message.type.intValue )
    {
        if ( message.url.length )
        {
            WebViewBoard_iPhone * board = [WebViewBoard_iPhone board];
            board.urlString = message.url;

            [self.stack pushBoard:board animated:YES];
        }
    }
}

#pragma mark -

ON_SIGNAL3( NoConnectionCell_iPhone, refresh, signal )
{
    if ( 0 == [self currentTab] )
	{
        [self.messageListModel firstPage];
	}
	else
	{
        [self.systemMessageListModel firstPage];
	}
}

#pragma mark - MessageListModel

ON_SIGNAL3( MessageListModel, RELOADING, signal )
{
	if ( 0 == self.messageListModel.messages.count )
	{
		self.list1.footerLoading = NO;
        self.list1.footerShown = NO;
	}
	else
	{
		self.list1.footerLoading = self.messageListModel.messages.count ? YES : NO;
        self.list1.footerShown = YES;
	}
	
	[self.list1 reloadData];
}

ON_SIGNAL3( MessageListModel, RELOADED, signal )
{
	[self dismissTips];
    
	self.list1.headerLoading = NO;
	self.list1.footerLoading = NO;
	self.list1.footerMore = self.messageListModel.more;
	self.list1.footerShown = self.list1.total ? YES : NO;
	
	[self.list1 reloadData];
}

ON_SIGNAL3( MessageListModel, UPDATING, signal )
{
}

ON_SIGNAL3( MessageListModel, UPDATED, signal )
{
	self.segment.data = @(self.messageListModel.unreadCount);
    
    [self.list1 reloadData];
}

ON_SIGNAL3( MessageListModel, READING, signal )
{
}

ON_SIGNAL3( MessageListModel, READED, signal )
{
    [self.messageListModel reload];
}

#pragma mark - SystemMessageListModel

ON_SIGNAL3( SystemMessageListModel, RELOADING, signal )
{
	if ( 0 == self.systemMessageListModel.messages.count )
	{
		self.list2.footerLoading = NO;
        self.list2.footerShown = NO;
	}
	else
	{
		self.list2.footerLoading = self.systemMessageListModel.messages.count ? YES : NO;
        self.list2.footerShown = YES;
	}
	
	[self.list2 reloadData];
}

ON_SIGNAL3( SystemMessageListModel, RELOADED, signal )
{
	[self dismissTips];
    
	self.list2.headerLoading = NO;
	self.list2.footerLoading = NO;
	self.list2.footerMore = self.systemMessageListModel.more;
	self.list2.footerShown = YES;
	
	[self.list2 reloadData];
}

@end

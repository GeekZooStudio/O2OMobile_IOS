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

#import "bee.services.share.h"
#import "bee.services.share.weixin.h"
#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentopen.h"
#import "D3_OrderCommentBoard_iPhone.h"
#import "D3_OrderCommentCell_iPhone.h"
#import "D3_OrderCommentDoneCell_iPhone.h"
#import "D3_CommentStarsCell_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface D3_OrderCommentBoard_iPhone()
@property (nonatomic, assign) D3_OrderCommentCell_iPhone * cell;
@property (nonatomic, assign) D3_OrderCommentDoneCell_iPhone * doneCell;
@end

@implementation D3_OrderCommentBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_MODEL( CommentModel , commentModel )

- (void)load
{
    self.commentModel = [CommentModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.commentModel )
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    self.navigationBarShown = YES;
    self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
    
    self.shareMask.alpha = 0.0f;
	self.shareMask.userInteractionEnabled = NO;
	self.shareMask.blurRadius = 5;
	self.shareMask.tintColor = [UIColor blackColor];
	
	self.shareCell.alpha = 0.0f;
	self.shareCell.userInteractionEnabled = NO;
    
    @weakify(self);
    
    self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	
    if ( self.order.innerStatus == BAUserOrderStatusNeedComment ||
        self.order.innerStatus == BAUserOrderStatusEmployeePayConformed ||
        self.order.innerStatus == BAUserOrderStatusEmployerPayConformed)
    {
        self.navigationBarTitle = __TEXT(@"evaluate_complete");
        self.list.whenReloading = ^
        {
            @normalize(self);
            
            self.list.total = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.size = CGSizeMake( self.list.width, self.list.height );
            item.clazz = [D3_OrderCommentCell_iPhone class];
            item.data = self.order;
        };
        
        self.list.whenReloaded = ^
        {
            @normalize(self);
            self.cell = (D3_OrderCommentCell_iPhone *)((BeeUIScrollItem *)self.list.items[0]).view;
        };
    }
    else
    {
        self.navigationBarTitle = __TEXT(@"evaluate_complete");
        [self showDoneMask];
    }
    
    [self observeNotification:BeeUIKeyboard.SHOWN];
    [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self observeNotification:BeeUIKeyboard.HIDDEN];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:BeeUIKeyboard.SHOWN];
    [self unobserveNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self unobserveNotification:BeeUIKeyboard.HIDDEN];
}
ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    self.commentModel.order_id = self.order.id;
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

#pragma mark -

ON_SIGNAL3( D3_OrderCommentCell_iPhone, comment, signal )
{
    NSString * text = self.cell.comment_textarea.text;
    
    // 至少一星
    int rank = self.cell.stars.currentIndex > 0 ?: 1;
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [self.commentModel commentWithText:text rank:rank];
}

ON_SIGNAL3( D3_OrderCommentDoneCell_iPhone, share, signal )
{
    [self showShare];
}

ON_SIGNAL3( D3_OrderShareCell_iPhone, cancel, signal )
{
    [self hideShare];
}

#pragma mark - 

ON_SIGNAL3( D3_OrderCommentCell_iPhone, comment_textarea, signal )
{
    if ( [signal is:BeeUITextView.WILL_ACTIVE] )
    {
        
    }
    else if ( [signal is:BeeUITextView.WILL_DEACTIVE] )
    {
        
    }
}

#pragma mark -

ON_NOTIFICATION2( BeeUIKeyboard , notification )
{
    // 385 = button.bottom
    CGFloat delta = [UIScreen mainScreen].bounds.size.height - 450;
    
    if ( [notification is:BeeUIKeyboard.SHOWN])
    {
        CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
        [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight - delta, 0)];
        [self.list setContentOffset:CGPointMake(0, keyboardHeight - delta) animated:NO];
    }
    else if ([notification is:BeeUIKeyboard.HEIGHT_CHANGED])
    {
        CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
        [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight - delta, 0)];
        [self.list setContentOffset:CGPointMake(0, keyboardHeight - delta) animated:NO];
    }
    else if ( [notification is:BeeUIKeyboard.HIDDEN] )
    {
        [self.list setBaseInsets:UIEdgeInsetsZero];
    }
}

ON_SIGNAL3( CommentModel, RELOADING, signal )
{
    [self presentLoadingTips:__TEXT(@"please_later_on")];
}

ON_SIGNAL3( CommentModel, DID_COMMENT, signal )
{
    [self dismissTips];
    [self.view endEditing:YES];
    [self.view transitionFade];
    [self showDoneMask];
}

ON_SIGNAL3( CommentModel, DID_COMMENT_FAIL, signal )
{
    [self presentFailureTips:__TEXT(@"evaluate_failed")];
}

#pragma mark -

- (void)showShare
{
	[UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         $(self.shareCell).SET_CLASS( @"cell-show" ).RELAYOUT();
                         $(self.shareMask).SET_CLASS( @"mask-show" ).RELAYOUT();
                     }
                     completion:^(BOOL finished) {
                         self.shareCell.userInteractionEnabled = YES;
                         self.shareMask.userInteractionEnabled = YES;
                     }];
}

- (void)hideShare
{
	[UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         $(self.shareCell).SET_CLASS( @"cell-hide" ).RELAYOUT();
                         $(self.shareMask).SET_CLASS( @"mask-hide" ).RELAYOUT();
                     }
                     completion:^(BOOL finished) {
                         self.shareCell.userInteractionEnabled = NO;
                         self.shareMask.userInteractionEnabled = NO;
                     }];
}

- (void)hideShareThenToggleMenu
{
	if ( $(self.shareCell).HAS_CLASS( @"cell-show" ) )
	{
		[UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             $(self.shareCell).SET_CLASS( @"cell-hide" ).RELAYOUT();
                             $(self.shareMask).SET_CLASS( @"mask-hide" ).RELAYOUT();
                         } completion:^(BOOL finished) {
                             self.shareCell.userInteractionEnabled = NO;
                             self.shareMask.userInteractionEnabled = NO;
                             
                             [AppBoard_iPhone sharedInstance].menuShown = [AppBoard_iPhone sharedInstance].menuShown ? NO : YES;
                         }];
	}
	else
	{
		[AppBoard_iPhone sharedInstance].menuShown = [AppBoard_iPhone sharedInstance].menuShown ? NO : YES;
	}
}

#pragma mark -

ON_SIGNAL3( D3_OrderCommentBoard_iPhone, shareMask, signal )
{
	[self hideShare];
}

#pragma mark -

ON_SIGNAL3( D3_OrderShareCell_iPhone, weibo, signal )
{
	[self hideShare];
    
    [self presentMessageTips:__TEXT(@"please_buy_authorized_edition")];
	
//	ALIAS( bee.services.share.sinaweibo, share );
//    share.post.title = __TEXT(@"share_title");
//	share.post.text = [self richShareContent];
//	share.post.url = [self shareUrl];;
//	
//	share.whenShareBegin = ^
//	{
//		[self presentLoadingTips:__TEXT(@"sharing")];
//	};
//	share.whenShareSucceed = ^
//	{
//		[self dismissTips];
//		[self presentSuccessTips:__TEXT(@"share_succeed")];
//	};
//	share.whenShareFailed = ^
//	{
//		[self dismissTips];
//		[self presentFailureTips:__TEXT(@"share_failed")];
//	};
//	share.whenShareCancelled = ^
//	{
//		[self dismissTips];
//	};
//	
//	share.SHARE();
}

ON_SIGNAL3( D3_OrderShareCell_iPhone, weixin, signal )
{
	[self hideShare];
	
    [self presentMessageTips:__TEXT(@"please_buy_authorized_edition")];
    
//	ALIAS( bee.services.share.weixin, share );
//    share.post.thumb = [UIImage imageNamed:@"Icon.png"];
//	share.post.title = [self shareContent];
//	share.post.text = [self shareContent];
//	share.post.url = [self shareUrl];  
//	
//	share.whenShareBegin = ^
//	{
//		[self presentLoadingTips:__TEXT(@"sharing")];
//	};
//	share.whenShareSucceed = ^
//	{
//		[self dismissTips];
//		[self presentSuccessTips:__TEXT(@"share_succeed")];
//	};
//	share.whenShareFailed = ^
//	{
//		[self dismissTips];
//		[self presentFailureTips:__TEXT(@"share_failed")];
//	};
//	share.whenShareCancelled = ^
//	{
//		[self dismissTips];
//	};
//	
//	share.SHARE_TO_TIMELINE();
}

- (NSString *)shareUrl
{
    return [NSString stringWithFormat:@"%@/%@", [ServerConfig sharedInstance].shareUrl, self.order.id];
}

- (NSString *)richShareContent
{
    return [NSString stringWithFormat:@"＃O2OMobile＃ %@ ＠O2OMobile", __TEXT(@"share_content")];
}

- (NSString *)shareContent
{
    return __TEXT(@"share_content");
}

ON_SIGNAL3( D3_OrderShareCell_iPhone, qzone, signal )
{
	[self hideShare];
	
    [self presentMessageTips:__TEXT(@"please_buy_authorized_edition")];
    
//	ALIAS( bee.services.share.tencentOpen, share );
//	
//    UIImage * image = [UIImage imageNamed:@"Icon.png"];
//
//	share.post.title = [self shareContent];
//	share.post.url = [self shareUrl];
//	share.post.photo = UIImagePNGRepresentation(image);
//	share.whenShareBegin = ^
//	{
//		[self presentLoadingTips:__TEXT(@"sharing")];
//	};
//	share.whenShareSucceed = ^
//	{
//		[self dismissTips];
//		[self presentSuccessTips:__TEXT(@"share_succeed")];
//	};
//	share.whenShareFailed = ^
//	{
//		[self dismissTips];
//		[self presentFailureTips:__TEXT(@"share_failed")];
//	};
//	share.whenShareCancelled = ^
//	{
//		[self dismissTips];
//	};
//	
//	share.SHARE_TO_QZONE();
}

- (void)showDoneMask
{
    if ( nil == self.doneCell )
    {
        self.doneCell = [[D3_OrderCommentDoneCell_iPhone alloc] init];
        self.doneCell.FROM_NAME(@"D3_OrderCommentDoneCell_iPhone.xml");
        self.doneCell.frame = self.bounds;
    }
    
    [self.view insertSubview:self.doneCell aboveSubview:self.list];
}

@end

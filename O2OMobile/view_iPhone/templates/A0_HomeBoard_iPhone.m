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

#import "A0_HomeBoard_iPhone.h"
#import "MenuButton_iPhone.h"
#import "AppBoard_iPhone.h"
#import "C0_ServerListBoard_iPhone.h"
#import "A0_RequestListBoard_iPhone.h"
#import "A0_ServiceBoard_iPhone.h"
#import "GRKPageViewController.h"
#import "A0_HomeTitleView_iPhone.h"

#pragma mark -

@interface A0_HomeBoard_iPhone()<GRKPageViewControllerDataSource, GRKPageViewControllerDelegate>
@property (nonatomic, retain) GRKPageViewController * pageViewController;
@property (nonatomic, retain) A0_RequestListBoard_iPhone * orderBoard;
@property (nonatomic, retain) A0_ServiceBoard_iPhone * serviceBoard;
@property (nonatomic, retain) A0_HomeTitleView_iPhone * titleCell;
@end

@implementation A0_HomeBoard_iPhone

DEF_SINGLETON( A0_HomeBoard_iPhone )

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( MenuButton_iPhone, menuButton )
DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( BeeUIImageView, tag )

DEF_NOTIFICATION( FILTRATE )
DEF_NOTIFICATION( PUBLISH )

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
    self.pageViewController = [[GRKPageViewController alloc] init];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self.pageViewController setCurrentIndex:0 animated:NO];
    
    
    @weakify(self);
    
    self.orderBoard = [A0_RequestListBoard_iPhone board];
    self.orderBoard.whenExpandChanged = ^(BOOL expanded)
    {
        @normalize(self);
        
        if( expanded )
        {
            self.navigationBarRight = [UIImage imageNamed:@"b2_close.png"];
        }
        else
        {
            self.navigationBarRight = [UIImage imageNamed:@"b1_icon_filter.png"];
        }
    };
    
    self.serviceBoard = [A0_ServiceBoard_iPhone board];
    
    [self displayViewController:self.pageViewController];
    
    self.titleCell = [[A0_HomeTitleView_iPhone alloc] init];
    self.titleCell.FROM_NAME( [self.titleCell UIResourceName] );
    self.titleCell.pager.numberOfPages = [self pageCount];
    self.titleCell.title.text = self.serviceBoard.title;
    
    self.navigationBarShown = YES;
	self.navigationBarTitle = self.titleCell;
    self.navigationBarLeft = [UIImage imageNamed:@"b0_btn_menu.png"];
    self.navigationBarRight = [UIImage imageNamed:@"b0_btn_search.png"];
    
    [self.view bringSubviewToFront:self.tag];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [AppBoard_iPhone sharedInstance].menuPannable = YES;
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [AppBoard_iPhone sharedInstance].menuPannable = NO;
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
    NSInteger currentIndex = self.pageViewController.currentIndex;
    
    switch ( currentIndex )
    {
        case 0:
        {
            [self postNotification:self.PUBLISH];
        }
            break;
        case 1:
        {
            [self postNotification:self.FILTRATE];
            
//            if( self.orderBoard.filter.expanded )
//            {
//                self.navigationBarRight = [UIImage imageNamed:@"b2_close.png"];
//            }
//            else
//            {
//                self.navigationBarRight = [UIImage imageNamed:@"b1_icon_filter.png"];
//            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -

- (void)displayViewController:(UIViewController *)viewController
{
    viewController.view.frame = self.view.bounds;
    //Add the page to the view and view controller hierarchies
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void)removeViewController:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}


#pragma mark - GRKPageViewControllerDataSource

- (NSUInteger)pageCount
{
    return 2;
}

- (UIViewController *)viewControllerForIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            return self.serviceBoard;
        case 1:
            return self.orderBoard;
        default:
//            NSLog(@"Page index %lu out of range.", (unsigned long)index);
            break;
    }
    
    return nil;
}

#pragma mark - GRKPageViewControllerDelegate

- (void)changedIndexOffset:(CGFloat)indexOffset forPageViewController:(GRKPageViewController *)controller
{
    //    NSLog(@"Index Offset: %f", indexOffset);
}

- (void)changedIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller
{
    self.titleCell.pager.currentPage = index;
    
    switch ( index ) {
        case 0:
        {
            self.navigationBarRight = [UIImage imageNamed:@"b0_btn_search.png"];
            self.titleCell.title.text = self.serviceBoard.title;
        }
            break;
        case 1:
        {
            self.navigationBarRight = [UIImage imageNamed:@"b1_icon_filter.png"];
            self.titleCell.title.text = self.orderBoard.title;
        }
            break;
        default:
            break;
    }
}

@end

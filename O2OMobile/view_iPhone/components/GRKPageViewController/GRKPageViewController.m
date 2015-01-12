//
//  GRKPageViewController.m
//
//  Created by Levi Brown on November 18, 2013.
//  Copyright (c) 2013 Levi Brown <mailto:levigroker@gmail.com>
//  This work is licensed under the Creative Commons Attribution 3.0
//  Unported License. To view a copy of this license, visit
//  http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
//  Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
//  USA.
//
//  The above attribution and the included license must accompany any version
//  of the source code. Visible attribution in any binary distributable
//  including this work (or derivatives) is not required, but would be
//  appreciated.
//

#import "GRKPageViewController.h"

@interface GRKPageViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) NSUInteger pageCount;
@property (nonatomic,strong) NSMutableArray *pages;
//These values are stored off before we start rotation so we adjust our content offset appropriately during rotation
@property (nonatomic,assign) NSUInteger firstVisiblePageIndexBeforeRotation;
@property (nonatomic,assign) CGFloat percentScrolledIntoFirstVisiblePage;
@property (nonatomic,assign) NSUInteger internalIndex;
@property (nonatomic,assign) NSUInteger pendingIndex;

@end

@implementation GRKPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    //Setup constraints to keep the scroll view pinned to our view's size.
    UIView *containedView = self.scrollView;
    containedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[containedView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(containedView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[containedView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(containedView)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self initPages];
    //Update our current index (if needed) now that we are initialized and layed out properly
    if (self.internalIndex != self.pendingIndex)
    {
        [self setCurrentIndex:self.pendingIndex animated:NO];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    //Upon rotation we need to re-init to handle potential size changes
    [self initPages];
}

- (void)initPages
{
    self.scrollView.frame = [self frameForPagingScrollView];
    [self updatePageCount];
    //NOTE: contentSizeForPagingScrollView require self.pageCount to be set (which is set by [self updatePageCount])
    CGSize contentSize = [self contentSizeForPagingScrollView];
    self.scrollView.contentSize = contentSize;

    [self tilePages];
    //We adjust existing pages sizes since tilePages does not modify a page size once it is created.
    [self adjustFramesOfVisiblePages];
}

#pragma mark - Acessors

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    [self setCurrentIndex:currentIndex animated:NO];
}

- (void)setCurrentIndex:(NSUInteger)index animated:(BOOL)animated
{
    //Ensure we have been initialized completely
    if (self.pages)
    {
        if (index < self.pageCount)
        {
            CGFloat width = CGRectGetWidth(self.scrollView.bounds);
            CGFloat destX = index * width;
            CGPoint contentOffset = self.scrollView.contentOffset;

            contentOffset.x = destX;

            [self.scrollView setContentOffset:contentOffset animated:animated];
        }
    }
    else
    {
        //If we haven't asked the delegate for pages yet, then we can't set the pending index yet so we save the desired index
        //and try again in viewWillAppear once we've initialized ourselves completely.
        self.pendingIndex = index;
    }
}

- (NSUInteger)currentIndex
{
    return self.internalIndex;
}

#pragma mark Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //The scrollView bounds have not yet been updated for the new interface orientation. So this is a good
    //place to calculate the content offset that we will need in the new orientation
    CGFloat offset = self.scrollView.contentOffset.x;
    CGFloat pageWidth = self.scrollView.bounds.size.width;

    if (offset >= 0)
    {
        self.firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
        self.percentScrolledIntoFirstVisiblePage = (offset - (self.firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    }
    else
    {
        self.firstVisiblePageIndexBeforeRotation = 0;
        self.percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Recalculate scrollView contentSize and page size will be updated by the call to initPages from viewWillLayoutSubviews, so we don't need to do that again here.

    //Adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = self.scrollView.bounds.size.width;
    CGFloat newOffset = (self.firstVisiblePageIndexBeforeRotation * pageWidth) + (self.percentScrolledIntoFirstVisiblePage * pageWidth);
    self.scrollView.contentOffset = CGPointMake(newOffset, 0);
}

#pragma mark - Paging Logic

- (void)updatePageCount
{
    self.pageCount = [self.dataSource pageCount];
    if (!self.pages)
    {
        self.pages = [NSMutableArray arrayWithCapacity:self.pageCount];
    }
    
    NSUInteger populated = self.pages.count;
    
    NSUInteger previousPageCount = self.pages.count;
    if (self.pageCount < previousPageCount)
    {
        //Shrink the pages array
        NSMutableIndexSet *removeIndcies = [NSMutableIndexSet indexSet];
        for (NSUInteger index = self.pageCount; index < populated; ++index)
        {
            [removeIndcies addIndex:index];
            id obj = [self.pages objectAtIndex:index];
            if (![obj isEqual:[NSNull null]])
            {
                UIViewController *page = (UIViewController *)obj;
                [self removePage:page withIndex:index];
            }
        }
        [self.pages removeObjectsAtIndexes:removeIndcies];
    }
    else
    {
        //Pad the pages array with NSNull, if needed
        for (NSUInteger index = previousPageCount; index < self.pageCount; ++index)
        {
            [self.pages addObject:[NSNull null]];
        }
    }
    
}

- (void)tilePages
{
    // Calculate which pages are visible
    CGRect visibleBounds = self.scrollView.bounds;
    CGFloat indexOffset = CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds);
    NSInteger firstNeededPageIndex = floorf(indexOffset);
    NSInteger lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds) -1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, (NSInteger)self.pageCount - 1);

    //DEBUG
    //NSLog(@"firstNeededPageIndex: %d, lastNeededPageIndex: %d", firstNeededPageIndex, lastNeededPageIndex);
    //END

    for (NSUInteger index = 0; index < self.pageCount; ++index)
    {
        id obj = [self.pages objectAtIndex:index];

        if (index < firstNeededPageIndex || index > lastNeededPageIndex)
        {
            //Remove pages outside the visible range
            if (![obj isEqual:[NSNull null]])
            {
                UIViewController *page = (UIViewController *)obj;
                [self removePage:page withIndex:index];
            }
        }
        else
        {
            //Be sure we have the pages we need
            if ([obj isEqual:[NSNull null]])
            {
                UIViewController *page = [self.dataSource viewControllerForIndex:index];
                [self addPage:page withIndex:index];
            }
        }
    }

    //Inform our delegate of the changes

    if ([self.delegate respondsToSelector:@selector(changedIndexOffset:forPageViewController:)])
    {
        [self.delegate changedIndexOffset:indexOffset forPageViewController:self];
    }

    if (firstNeededPageIndex == lastNeededPageIndex)
    {
        if (self.internalIndex != firstNeededPageIndex)
        {
            self.internalIndex = firstNeededPageIndex;
            self.pendingIndex = self.internalIndex;

            if ([self.delegate respondsToSelector:@selector(changedIndex:forPageViewController:)])
            {
                [self.delegate changedIndex:self.internalIndex forPageViewController:self];
            }
        }
    }

    //DEBUG
    //NSString *descriptions = [self.pages componentsJoinedByString:@", "];
    //NSLog(@"Pages: [%@]", descriptions);
    //END
}

- (void)removePage:(UIViewController *)page withIndex:(NSUInteger)index
{
    //Replace the page in our array with padding (NSNull)
    [self.pages replaceObjectAtIndex:index withObject:[NSNull null]];

    //Remove the page from the view and view controller hierarchies
    [page willMoveToParentViewController:nil];
    [page.view removeFromSuperview];
    [page removeFromParentViewController];
}

- (void)addPage:(UIViewController *)page withIndex:(NSUInteger)index
{
    if (page)
    {
        //Keep track of the page in our page array
        [self.pages replaceObjectAtIndex:index withObject:page];

        //Set the frame of the page in our scroll view
        page.view.frame = [self frameForPageAtIndex:index];

        //Add the page to the view and view controller hierarchies
        [self addChildViewController:page];
        [self.scrollView addSubview:page.view];
        [page didMoveToParentViewController:self];
    }
}

#pragma mark - Frame Calculations

- (void)adjustFramesOfVisiblePages
{
    //Adjust the frames of each visible page
    NSUInteger count = self.pages.count;
    for (NSUInteger index = 0; index < count; ++index)
    {
        id obj = [self.pages objectAtIndex:index];
        if (![obj isEqual:[NSNull null]])
        {
            UIViewController *page = (UIViewController *)obj;
            page.view.frame = [self frameForPageAtIndex:index];
        }
    }
}

- (CGRect)frameForPagingScrollView
{
    CGRect frame = self.view.bounds;
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    CGRect bounds = self.scrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.origin.x = (bounds.size.width * index);
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView
{
    CGRect bounds = self.scrollView.bounds;
    return CGSizeMake(bounds.size.width * self.pageCount, bounds.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

@end

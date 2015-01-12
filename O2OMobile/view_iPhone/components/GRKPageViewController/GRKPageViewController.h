//
//  GRKPageViewController.h
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

#import <UIKit/UIKit.h>
@class GRKPageViewController;

///
/// @name GRKPageViewControllerDataSource
///

@protocol GRKPageViewControllerDataSource <NSObject>

/**
 Called by the `GRKPageViewController` to determine how many pages (view controllers) will be presented.
 */
- (NSUInteger)pageCount;
/**
 Called by the `GRKPageViewController` to retrieve an instance of the view controller to display at the given index.
 @param index The index for which to return an instance of a `UIViewController`.
 */
- (UIViewController *)viewControllerForIndex:(NSUInteger)index;

@end

///
/// @name GRKPageViewControllerDelegate
///

@protocol GRKPageViewControllerDelegate <NSObject>

@optional
/**
 Called continiously with the indexOffset as a transition is underway from one view controller to another.
 This could be used to similarlly transition another view as the page index is changing.
 @param indexOffset A float whose integer value is the current index and whose floating point value is the
 percentage of transition from one index to the next. i.e. this might return 1.35 which indicates we are
 transitioning betwen index 1 and index 2, and 65% of the page at index 1 is showing, while 35% of the
 page at index 2 is showing.
 @param controller A reference to the `GRKPageViewController` sending the message.
 */
- (void)changedIndexOffset:(CGFloat)indexOffset forPageViewController:(GRKPageViewController *)controller;
/**
 Called once when a new view controller page is fully displayed.
 @param index The index of the currently displayed view controller.
 @param controller A reference to the `GRKPageViewController` sending the message.
 */
- (void)changedIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller;

@end

///
/// @name GRKPageViewController
///

@interface GRKPageViewController : UIViewController <UIScrollViewDelegate>

/**
 The object to use as the `GRKPageViewControllerDataSource`
 */
@property (nonatomic,weak) id<GRKPageViewControllerDataSource> dataSource;
/**
 The object to use as the `GRKPageViewControllerDelegate`
 */
@property (nonatomic,weak) id<GRKPageViewControllerDelegate> delegate;
/**
 The index of the currently displayed view controller.
 */
@property (nonatomic,assign) NSUInteger currentIndex;

/**
 Displays the view controller at the given index, optionally animating the transition.
 @param index The index of the view controller to transition to.
 @param animated If `YES` then animate the transition from the current index to the given index.
 If `NO` no animation will take place and the new index will take effect immediately.
 */
- (void)setCurrentIndex:(NSUInteger)index animated:(BOOL)animated;

@end

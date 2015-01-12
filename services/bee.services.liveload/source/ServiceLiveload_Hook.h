//
//  ServiceLiveload_Hook.h
//  dribbble
//
//  Created by QFish on 2/9/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#if (TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface UIView (ServiceLiveloadHook)
+ (void)hook;
@end

#endif	// #if (TARGET_IPHONE_SIMULATOR)
//
//  ServiceLiveload_Watcher.h
//  dribbble
//
//  Created by QFish on 2/10/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR)

#import <Foundation/Foundation.h>

@interface ServiceLiveload_Watcher : NSObject

AS_SINGLETON( ServiceLiveload_Watcher );

+ (void)setWatcher:(id)watcher forPath:(NSString *)path;
+ (void)removeWatcher:(id)watcher forPath:(NSString *)path;

@end

#endif  // #if (TARGET_IPHONE_SIMULATOR)

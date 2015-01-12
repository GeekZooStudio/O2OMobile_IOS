//
//  ServiceLiveload_Category.m
//  dribbble
//
//  Created by QFish on 2/10/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR)

#import "ServiceLiveload.h"
#import "ServiceLiveload_Watcher.h"
#import "ServiceLiveload_Category.h"

NSString *_LiveloadUIAbsoluteFilePath(const char *currentFilePath, NSString *relativeFilePath) {
    NSString *currentDirectory = [[NSString stringWithUTF8String:currentFilePath] stringByDeletingLastPathComponent];
    return [currentDirectory stringByAppendingPathComponent:relativeFilePath];
}

@implementation NSObject (ServiceLiveload)

- (void)__liveReloadWithObject:(id)obj;
{
}

- (void)__reloadDefaultStlye;
{
    NSString * defaultPath = [ServiceLiveload sharedInstance].defaultStyle;
    BeeUIStyle * style = [[BeeUIStyleManager sharedInstance]
                          fromFile:defaultPath useCache:NO];
    [BeeUIStyleManager sharedInstance].defaultStyle = style;
}

- (NSString *)LiveloadUIResourcePath
{
    return nil;
}

- (NSString *)LiveloadUIResourcePathKey
{
    return nil;
}

- (void)setWatchPath:(NSString *)watchPath
{
    if ( watchPath && watchPath.length )
    {
        [ServiceLiveload_Watcher setWatcher:self forPath:watchPath];
    }
}

@end

#pragma mark - categories

@implementation UIView (ServiceLiveload)
- (void)__liveReloadWithObject:(id)obj
{
    if ( [obj isEqualToString:[ServiceLiveload sharedInstance].defaultStyle] )
    {
        [self __reloadDefaultStlye];
    }
    
    [self removeAllSubviews];
    self.FROM_FILE([self LiveloadUIResourcePath]);
    self.RELAYOUT();
}
@end

@implementation BeeUIScrollView (ServiceLiveload)
- (void)__liveReloadWithObject:(id)obj
{
    if ( [obj isEqualToString:[ServiceLiveload sharedInstance].defaultStyle] )
    {
        [self __reloadDefaultStlye];
    }
    
    [self setReuseEnable:NO];
    [self reloadData];
}
@end

@implementation UITableView (ServiceLiveload)
- (void)__liveReloadWithObject:(id)obj
{
    [self reloadData];
}
@end

@implementation UIViewController (ServiceLiveload)
- (void)__liveReloadWithObject:(id)obj
{
    [self.view removeAllSubviews];
    self.view.FROM_FILE([self LiveloadUIResourcePath]);
    self.view.RELAYOUT();
}
@end

#endif  // #if (TARGET_IPHONE_SIMULATOR)
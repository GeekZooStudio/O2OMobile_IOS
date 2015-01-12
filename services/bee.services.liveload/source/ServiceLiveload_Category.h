//
//  ServiceLiveload_Category.h
//  dribbble
//
//  Created by QFish on 2/10/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#if (TARGET_IPHONE_SIMULATOR)

#undef	SUPPORT_LIVE_RELOAD_WITH_PATH_KEY
#define SUPPORT_LIVE_RELOAD_WITH_PATH_KEY( __key ) \
- (NSString *)LiveloadUIResourcePath { \
NSString * _path_ = [NSString stringWithFormat: \
@"%@.xml", [self UIResourceName]]; \
return LIVE_UI_ABSOLUTE_PATH(_path_);}\
- (NSString *)LiveloadUIResourcePathKey \
{ return [ServiceLiveload pathForKey:( __key )];}\

#undef	SUPPORT_LIVE_RELOAD_WITH_PATH
#define SUPPORT_LIVE_RELOAD_WITH_PATH( __path ) \
- (NSString *)LiveloadUIResourcePath \
{ return LIVE_UI_ABSOLUTE_PATH( __path );}

#undef	SUPPORT_LIVE_RELOAD
#define SUPPORT_LIVE_RELOAD() \
- (NSString *)LiveloadUIResourcePath { \
NSString * _path_ = [NSString stringWithFormat: \
@"%@.xml", [self UIResourceName]]; \
return LIVE_UI_ABSOLUTE_PATH(_path_);}

#define LIVE_UI_ABSOLUTE_PATH(relativePath) \
_LiveloadUIAbsoluteFilePath(__FILE__, relativePath)

NSString * _LiveloadUIAbsoluteFilePath(const char *currentFilePath, NSString *relativeFilePath);

@interface NSObject (ServiceLiveload)

- (void)__liveReloadWithObject:(id)obj;

- (void)setWatchPath:(NSString *)watchPath;

- (NSString *)LiveloadUIResourcePath;
- (NSString *)LiveloadUIResourcePathKey;


@end

#endif  // #if (TARGET_IPHONE_SIMULATOR)

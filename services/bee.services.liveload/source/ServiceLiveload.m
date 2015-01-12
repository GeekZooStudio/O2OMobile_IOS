//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//
//  Copyright (c) 2014-2015, Geek Zoo Studio
//  http://www.bee-framework.com
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

#import "ServiceLiveload.h"
#import "ServiceLiveload_Hook.h"
#import "ServiceLiveload_Watcher.h"

#if (TARGET_IPHONE_SIMULATOR)

#pragma mark -

static NSMutableDictionary * __uipaths = nil;

@interface ServiceLiveload()
- (void)saveCache;
- (void)loadCache;
@end

#pragma mark -

@implementation ServiceLiveload
{
	
}

DEF_SINGLETON( ServiceLiveload );

SERVICE_AUTO_LOADING( YES );
SERVICE_AUTO_POWERON( YES );

+ (void)load
{
    [UIView hook];
}

+ (void)setDefaultStyleFile:(NSString *)filePath
{
    [ServiceLiveload sharedInstance].defaultStyle = filePath;
}

+ (void)setPath:(NSString *)path forkey:(NSString *)key
{
    if ( __uipaths == nil )
    {
        __uipaths = [[NSMutableDictionary alloc] init];
    }
    
    if ( path.length && key.length )
    {
        NSMutableArray * subPaths = __uipaths[key];
        
        if ( subPaths )
        {
            if ( ![subPaths containsObject:path] )
                [subPaths addObject:path];
        }
        else
        {
            subPaths = [[NSMutableArray alloc] initWithObjects:path, nil];
            [__uipaths setValue:subPaths forKey:key];
        }
    }
    else
    {
        NSLog( @"LiveUIPath for %@ isn't loaded", key );
    }
}

+ (NSArray *)pathForKey:(NSString *)key
{
    if ( key && key.length )
        return __uipaths[key];
    else
        NSLog(@"error key!");
    
    return nil;
}

+ (NSDictionary *)paths
{
    return __uipaths;
}

- (void)load
{
	[self loadCache];
}

- (void)unload
{
    [self saveCache];
}

- (void)loadCache
{
    
}

- (void)saveCache
{
    
}

#pragma mark -

- (void)powerOn
{
}

- (void)powerOff
{
}

- (void)serviceWillActive
{
}

- (void)serviceDidActived
{
}

- (void)serviceWillDeactive
{
}

- (void)serviceDidDeactived
{
}

#pragma mark -

@end
#endif  // #if (TARGET_IPHONE_SIMULATOR)

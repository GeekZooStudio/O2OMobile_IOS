//
//  ServiceLiveload_Hook.m
//  dribbble
//
//  Created by QFish on 2/9/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR)

#import "ServiceLiveload.h"
#import "ServiceLiveload_Hook.h"
#import "ServiceLiveload_Watcher.h"
#import "ServiceLiveload_Category.h"

#import "UIView+BeeUITemplate.h"

static BOOL __swizzled_liveload__ = NO;

static void (*__didMoveToSuperview_liveload__)( id, SEL );
static void (*__dealloc_liveload__)( id, SEL );

static NSMutableDictionary * __myResponderMap_liveload = nil;

#pragma mark -

@interface NSObject(ServiceLiveloadPrivate)
- (void)setupWatcherWithWatchPath:(NSString *)path;
+ (void *)swizz:(Class)clazz method:(SEL)sel1 with:(SEL)sel2;
@end

#pragma mark -

@interface UIView(ServiceLiveloadPrivate)

- (void)myDealloc_liveload;
- (void)mySetTemplateName_liveload:(NSString *)name;

@end

#pragma mark -

@implementation UIView (ServiceLiveloadHook)

+ (void)hook
{
    if ( NO == __swizzled_liveload__ )
	{
        [NSObject swizz:[UIView class] method:@selector(setTemplateName:) with:@selector(mySetTemplateName_liveload:)];
        
        __didMoveToSuperview_liveload__ = [self swizz:[UIView class] method:@selector(didMoveToSuperview) with:@selector(myDidMoveToSuperview_liveload)];
        
//        __dealloc_liveload__ = [self swizz:[UIView class] method:@selector(dealloc) with:@selector(myDealloc_liveload)];
        
        __swizzled_liveload__ = YES;
    }
    
    if ( !__myResponderMap_liveload )
    {
        __myResponderMap_liveload = [[NSMutableDictionary nonRetainingDictionary] retain];
    }
}

- (void)mySetTemplateName_liveload:(NSString *)name
{
    BeeUITemplate * temp = nil;
    
    NSString * shadowPath = [self getShadowPath];
    
    if ( shadowPath && shadowPath.length )
    {
        temp = [[BeeUITemplateManager sharedInstance] fromFile:shadowPath];
    }
    else
    {
        temp = [[BeeUITemplateManager sharedInstance] fromName:name];
    }
    
	if ( temp && temp.rootLayout )
	{
		self.layout = temp.rootLayout;
		[self.layout buildFor:self];
	}
}

- (void)cleanup_liveload
{
    NSString * shadowPath = [self getShadowPath];
    
    if ( shadowPath && shadowPath.length )
    {
        NSObject * responder = [self getResponder];
        
        [ServiceLiveload_Watcher removeWatcher:responder
                                       forPath:[self LiveloadUIResourcePath]];
        [ServiceLiveload_Watcher removeWatcher:responder
                                       forPath:[ServiceLiveload sharedInstance].defaultStyle];
        [self removResonpder];
    }
}

- (void)myDealloc_liveload
{
    [self cleanup_liveload];
    
    if ( __dealloc_liveload__ )
    {
        __dealloc_liveload__( self, _cmd );
    }
}

- (void)myDidMoveToSuperview_liveload
{
    NSString * shadowPath = [self getShadowPath];
    
    if ( self.superview ) // added to superView
    {
        if ( shadowPath && shadowPath.length )
        {
            NSObject * responder = [self getResponder];
            
            [responder setupWatcherWithWatchPath:shadowPath];
            
            NSArray * exPaths = [ServiceLiveload pathForKey:[responder UIResourceName]];
            
            if ( exPaths && exPaths.count )
            {
                for ( NSString * aPath in exPaths )
                {
                    [responder setupWatcherWithWatchPath:aPath];
                }
            }
        }
    }
    else // removed from superView
    {
        if ( shadowPath && shadowPath.length )
        {
            [self cleanup_liveload];
        }
    }
    
	if ( __didMoveToSuperview_liveload__ )
	{
		__didMoveToSuperview_liveload__( self, _cmd );
	}
}

#pragma mark -

- (NSString *)getShadowPath
{
    if ( self.viewController )
    {
        return [self.viewController LiveloadUIResourcePath];
    }
    else
    {
        return [self LiveloadUIResourcePath];
    }
}

- (void)removResonpder
{
    if ( __myResponderMap_liveload[[self UIResourceName]] )
    {
        [__myResponderMap_liveload removeObjectForKey:[self UIResourceName]];
    }
}

- (NSObject *)getResponder
{
    UIView * view = self;
    NSObject * responder = __myResponderMap_liveload[[self UIResourceName]];
 
    if ( !responder )
    {
        if ( view.viewController != nil )
        {
            responder = view.viewController;
        }
        else
        {
            while ( view )
            {
                if ( [view isKindOfClass:[UIScrollView class]] ||
                    [view isKindOfClass:[UIScrollView class]] )
                {
                    responder = view;
                    break;
                }
                
                view = view.superview;
            }
        }
        
        
        if ( !responder )
            responder = self;
        
        __myResponderMap_liveload[[self UIResourceName]] = responder;
    }
    
    return responder;
}

@end

@implementation NSObject(ServiceLiveloadPrivate)

+ (void *)swizz:(Class)clazz method:(SEL)sel1 with:(SEL)sel2
{
	Method method;
	IMP implement;
	IMP implement2;
	
	// swizz UIView methods
    
	method = class_getInstanceMethod( clazz, sel1 );
	implement = (void *)method_getImplementation( method );
	implement2 = class_getMethodImplementation( clazz, sel2 );
	method_setImplementation( method, implement2 );
    
	return implement;
}

// TODO: remove watcher when dealloced

- (void)setupWatcherWithWatchPath:(NSString *)watchPath
{
    NSString * defaultPath = [ServiceLiveload sharedInstance].defaultStyle;
    
    [self setWatchPath:watchPath];
    [self setWatchPath:defaultPath];
}

@end

#endif	// #if (TARGET_IPHONE_SIMULATOR)
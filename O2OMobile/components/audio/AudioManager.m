//
//  AudioManager.m
//  lingjun
//
//  Created by QFish on 8/22/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "UserModel.h"
#import "AudioManager.h"
#import "AudioPlayer.h"

@interface AudioManager()
@property (nonatomic, assign) BOOL       playing;
@end

@implementation AudioManager

DEF_SINGLETON( AudioManager );
DEF_NOTIFICATION( REFRESH_PLAY );

- (id)init
{
    self = [super init];
    if ( self )
    {
        [self observeNotification:AudioPlayer.PLAYING];
        [self observeNotification:AudioPlayer.STOPPED];
        [self observeNotification:AudioPlayer.FAILED];
    }
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];

    [super dealloc];
}

#pragma mark -

ON_NOTIFICATION3( AudioPlayer, PLAYING, notification )
{
    self.playing = YES;
}

ON_NOTIFICATION3( AudioPlayer, STOPPED, notification )
{
    self.playing = NO;
    
    [self postNotification:self.REFRESH_PLAY];
}

ON_NOTIFICATION3( AudioPlayer, FAILED, notification )
{
    self.playing = NO;
    
    [self postNotification:self.REFRESH_PLAY];
}

#pragma mark -

- (void)play:(NSString *)path
{
	NSData * data = [AudioManager audioWithName:path];
	if ( data )
	{
		self.playing = YES;

		[[AudioPlayer sharedInstance] playData:data];
	}
	else
	{
		self.playing = NO;
		
		[[AudioPlayer sharedInstance] stop];
	}
}

- (BOOL)playing:(NSString *)path
{
	return self.playing;
}

- (void)stop
{
	self.playing = NO;

	[[AudioPlayer sharedInstance] stop];
}

#pragma mark - audio

+ (BOOL)removeAudioWithName:(NSString *)name
{
    NSString * path = [AudioManager audioPathWithName:name];
    
    if ( [AudioManager exists:path] )
    {
        NSError * error = nil;
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        
        if ( nil == error )
        {
            return YES;
        }
    }
    return NO;
}

+ (NSData *)audioWithName:(NSString *)name
{
    NSData *	data = nil;
    NSString * path = [AudioManager audioPathWithName:name];
    
    if ( [AudioManager exists:path] )
    {
        NSError * error = nil;
        
        data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
        
        if ( error )
        {
            return nil;
        }
    }
    
    return data;
}

+ (NSString *)audioPathWithName:(NSString *)name
{
    NSString * audioDir = [AudioManager audioDir];

    if ( audioDir && audioDir.length )
    {
        return [[audioDir stringByAppendingPathComponent:[name MD5]] stringByAppendingPathExtension:@"amr"];
    }    else
    {
        return nil;
    }
}

+ (BOOL)saveAudio:(NSData *)data name:(NSString *)name
{
    if ( name && name.length )
    {
        NSError *	error = nil;
        NSString *	path = [AudioManager audioPathWithName:name];
        
        [data writeToFile:path options:NSDataWritingFileProtectionComplete error:&error];
        
        if ( nil == error )
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)moveAudioWithName:(NSString *)srcName to:(NSString *)dstName;
{
    NSString * srcPath = [AudioManager audioPathWithName:srcName];
    NSString * dstPath = [AudioManager audioPathWithName:dstName];
    
    if ( [AudioManager exists:srcPath] )
    {
        NSError * error = nil;
        
        [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:&error];
        
        if ( nil == error )
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)clearAudioLibrary
{
    if ( nil == [UserModel sharedInstance].user )
    {
        return NO;
    }
    
    NSString * uid = [NSString stringWithFormat:@"%@", [UserModel sharedInstance].user.id.stringValue];
    
    NSString * fullPath = [NSString stringWithFormat:@"%@/%@/", [BeeSandbox libCachePath], [uid MD5]];
    
    if ( YES == [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:NULL] )
    {
        NSError * error = nil;
        BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
        if ( ret && nil == error )
        {
            return YES;
        }
        else
        {
            ERROR( @"AudioManager : %@", error );
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

+ (NSString *)audioDir
{
    if ( nil == [UserModel sharedInstance].user )
    {
        return nil;
    }
    
    NSString * uid = [NSString stringWithFormat:@"%@", [UserModel sharedInstance].user.id.stringValue];
    
    NSString * fullPath = [NSString stringWithFormat:@"%@/%@/audio/", [BeeSandbox libCachePath], [uid MD5]];
    
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:NULL] )
    {
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:fullPath
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:nil];
        if ( NO == ret )
            return NO;
    }

    return fullPath;
}

+ (BOOL)exists:(NSString *)name;
{
	NSString * fullName = name;
	if ( nil == fullName )
		return NO;
	
	BOOL isDirectory = NO;
	BOOL returnValue = [[NSFileManager defaultManager] fileExistsAtPath:fullName isDirectory:&isDirectory];
	if ( NO == returnValue || YES == isDirectory )
		return NO;
	
	return YES;
}

@end

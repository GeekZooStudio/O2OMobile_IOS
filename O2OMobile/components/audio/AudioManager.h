//
//  AudioManager.h
//  lingjun
//
//  Created by QFish on 8/22/13.
//  Copyright (c) 2013 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTempAudioPrefix @"file-"

@interface AudioManager : NSObject

AS_SINGLETON( AudioManager );
AS_NOTIFICATION( REFRESH_PLAY );

- (void)play:(NSString *)path;
- (BOOL)playing:(NSString *)path;
- (void)stop;

+ (NSData *)audioWithName:(NSString *)name;
+ (BOOL)removeAudioWithName:(NSString *)name;

+ (NSString *)audioPathWithName:(NSString *)name;

+ (BOOL)saveAudio:(NSData *)data name:(NSString *)name;

+ (BOOL)moveAudioWithName:(NSString *)srcName to:(NSString *)dstName;

+ (BOOL)clearAudioLibrary;

@end

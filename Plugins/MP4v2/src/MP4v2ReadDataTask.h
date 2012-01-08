//
//  mp4v2 ReadDataTask.h
//  MetaZ
//
//  Created by Brian Olsen on 19/01/10.
//  Copyright 2010 Maven-Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MetaZKit/MetaZKit.h>
#import "MP4v2DataProvider.h"

@interface MP4v2ReadDataTask : NSOperation
{
    MP4v2DataProvider* provider;
    NSMutableDictionary* tagdict;
    NSString* fileName;
    NSLock *lock;
}
+ (id)taskWithProvider:(MP4v2DataProvider*)provider fromFileName:(NSString *)fileName dictionary:(NSMutableDictionary *)tagdict;
- (id)initWithProvider:(MP4v2DataProvider*)provider fromFileName:(NSString *)fileName dictionary:(NSMutableDictionary *)tagdict;
- (void)main;
@end


@interface MP4v2PictureReadDataTask : MZTaskOperation
{
    NSMutableDictionary* tagdict;
    NSString* file;
}
@property(readonly) NSString* file;

+ (id)taskWithDictionary:(NSMutableDictionary *)tagdict;
- (id)initWithDictionary:(NSMutableDictionary *)tagdict;

@end


@interface MP4v2ChapterReadDataTask : MZParseTaskOperation
{
    NSMutableDictionary* tagdict;
}

+ (id)taskWithFileName:(NSString*)fileName dictionary:(NSMutableDictionary *)tagdict;
- (id)initWithFileName:(NSString*)fileName dictionary:(NSMutableDictionary *)tagdict;

@end

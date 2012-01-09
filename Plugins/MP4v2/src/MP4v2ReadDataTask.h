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

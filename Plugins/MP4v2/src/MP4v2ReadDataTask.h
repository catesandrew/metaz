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

@class MP42File;

@interface MP4v2ReadDataTask : MZOperation
{
    MP4v2DataProvider* provider;
    MZReadOperationsController* controller;
}
+ (id)taskWithController:(MZReadOperationsController*)theController 
            fromFileName:(NSString *)fileName 
                dictionary:(NSMutableDictionary *)tagdict;
- (id)initWithController:(MZReadOperationsController*)theController 
            fromFileName:(NSString *)fileName 
                dictionary:(NSMutableDictionary *)tagdict;
- (void)operationFinished;

@end


@interface MP4v2FileReadOperation : NSOperation
{
    NSLock *lock;
    MP4v2ReadDataTask* readDataTask;
    NSMutableDictionary* tagdict;
    NSString* fileName;
    NSArray* tags;
    NSDictionary* read_mapping;
    NSDictionary* rating_read;
}

+ (id)operationWithReadDataTask:(MP4v2ReadDataTask*)theTask 
            fromFileName:(NSString *)theFileName 
                dictionary:(NSMutableDictionary *)theTagdict;
- (id)initWithReadDataTask:(MP4v2ReadDataTask*)theTask 
            fromFileName:(NSString *)theFileName 
                dictionary:(NSMutableDictionary *)theTagdict;
- (void)main;

@end



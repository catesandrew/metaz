//
//  mp4v2 WriteManager.h
//  MetaZ
//
//  Created by Brian Olsen on 29/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MetaZKit/MetaZKit.h>
#import "MP4v2DataProvider.h"

@class MP42File;

@interface MP4v2WriteOperationsController : MZOperationsController
{
    id<MZDataWriteDelegate> delegate;
    MP4v2DataProvider* provider;
    MetaEdits* edits;
}

+ (id)controllerWithProvider:(id<MZDataProvider>)provider
                    delegate:(id<MZDataWriteDelegate>)delegate
                       edits:(MetaEdits *)edits;

- (id)initWithProvider:(id<MZDataProvider>)provider
              delegate:(id<MZDataWriteDelegate>)delegate
                 edits:(MetaEdits *)edits;

- (void)operationsFinished;
- (void)notifyPercent:(NSInteger)percent;

@end

@interface MP4v2MainWriteTask : MZOperation
{
    MP4v2WriteOperationsController* controller;
    MetaEdits* data;
}

+ (id)taskWithController:(MP4v2WriteOperationsController*)controller
             metaEdits:(MetaEdits *)meta;
- (id)initWithController:(MP4v2WriteOperationsController*)controller
             metaEdits:(MetaEdits *)meta;
@end


@interface MP4v2FileWriteOperation : NSOperation
{
    NSLock *lock;
    MetaEdits* data;
    MP4v2WriteOperationsController* controller;
    
    NSDictionary* write_mapping;
    NSDictionary* rating_write;
}

+ (id)operationWithController:(MP4v2WriteOperationsController*)theController metaEdits:(MetaEdits *)meta;
- (id)initWithController:(MP4v2WriteOperationsController*)theController metaEdits:(MetaEdits *)meta;
- (void)main;

@end
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

@interface MP4v2MainWriteTask : MZTaskOperation
{
    MP4v2WriteOperationsController* controller;
    NSLock *lock;
}

+ (id)taskWithController:(MP4v2WriteOperationsController*)controller;
- (id)initWithController:(MP4v2WriteOperationsController*)controller;
- (void)main;

@end
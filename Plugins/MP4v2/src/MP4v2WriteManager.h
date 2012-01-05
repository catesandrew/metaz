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

@interface MP4v2ChapterWriteTask : MZTaskOperation
{
    NSString* chaptersFile;
}
+ (id)taskWithFileName:(NSString *)fileName chaptersFile:(NSString *)chaptersFile;
- (id)initWithFileName:(NSString *)fileName chaptersFile:(NSString *)chaptersFile;

@end

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
    NSString* pictureFile;
}

+ (id)taskWithController:(MP4v2WriteOperationsController*)controller
             pictureFile:(NSString *)file;
- (id)initWithController:(MP4v2WriteOperationsController*)controller
             pictureFile:(NSString *)file;

@end

/*
@interface APWriteManager : NSOperation <MZDataController>
{
    NSTask* task;
    BOOL finished;
    NSString* pictureFile;
    NSString* chaptersFile;
    MetaEdits* edits;
    id<MZDataWriteDelegate> delegate;
    APDataProvider* provider;
    NSPipe* err;
}
@property(readonly) NSTask* task;
@property(readonly) id<MZDataWriteDelegate> delegate;
@property(readonly) MetaEdits* edits;
@property(readonly) APDataProvider* provider;
@property(getter=isFinished,assign) BOOL finished;

+ (id)managerForProvider:(APDataProvider*)provider
                    task:(NSTask *)task
                delegate:(id<MZDataWriteDelegate>)delegate
                   edits:(MetaEdits *)edits
             pictureFile:(NSString *)file
            chaptersFile:(NSString *)chapterFile;
- (id)initForProvider:(APDataProvider*)provider
                 task:(NSTask *)task
             delegate:(id<MZDataWriteDelegate>)delegate
                edits:(MetaEdits *)edits
          pictureFile:(NSString *)file
         chaptersFile:(NSString *)chapterFile;

- (void)start;

- (BOOL)isConcurrent;
- (BOOL)isExecuting;
//- (BOOL)isFinished;

- (void)cancel;

- (void)taskTerminated:(NSNotification *)note;
- (void)handlerGotData:(NSNotification *)note;

@end
*/
//
//  mp4v2 WriteManager.m
//  MetaZ
//
//  Created by Brian Olsen on 29/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import "MP4v2WriteManager.h"

@implementation MP4v2WriteOperationsController

+ (id)controllerWithProvider:(id<MZDataProvider>)provider
                    delegate:(id<MZDataWriteDelegate>)delegate
                       edits:(MetaEdits *)edits
{
    return [[[self alloc] initWithProvider:provider delegate:delegate edits:edits] autorelease];
}

- (id)initWithProvider:(id<MZDataProvider>)theProvider
              delegate:(id<MZDataWriteDelegate>)theDelegate
                 edits:(MetaEdits *)theEdits
{
    self = [super init];
    if(self)
    {
        provider = [theProvider retain];
        delegate = [theDelegate retain];
        edits = [theEdits retain];
    }
    return self;
}

- (void)operationsFinished
{
    if(self.error || self.cancelled)
    {
        if([delegate respondsToSelector:@selector(dataProvider:controller:writeCanceledForEdits:error:)])
            [delegate dataProvider:provider controller:self writeCanceledForEdits:edits error:error];
    }
    else
    {
        if([delegate respondsToSelector:@selector(dataProvider:controller:writeFinishedForEdits:)])
            [delegate dataProvider:provider controller:self writeFinishedForEdits:edits];
    }

    [provider removeWriteManager:self];
}

- (void)notifyPercent:(NSInteger)percent
{
    if([delegate respondsToSelector:@selector(dataProvider:controller:writeFinishedForEdits:percent:)])
        [delegate dataProvider:provider controller:self writeFinishedForEdits:edits percent:percent];
}

@end


@implementation MP4v2MainWriteTask

+ (id)taskWithController:(MP4v2WriteOperationsController*)controller
{
    return [[[self alloc] initWithController:controller] autorelease];
}

- (id)initWithController:(MP4v2WriteOperationsController*)theController
{
    self = [super init];
    if(self)
    {
        lock = [[NSLock alloc] init];
        controller = [theController retain];
    }
    return self;
}

- (void)dealloc
{
    [controller release];
    [lock release];
    [super dealloc];
}

- (void)main
{
    [lock lock];
    [lock unlock];
}

@end
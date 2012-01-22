//
//  mp4v2 MetaProvider.m
//  MetaZ
//
//  Created by Brian Olsen on 23/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import "MP4v2DataProvider.h"
#import "MP4v2WriteManager.h"
#import "MP4v2ReadDataTask.h"
#import "MP42File.h"

@interface MP4v2DataProvider ()

@end

@implementation MP4v2DataProvider

- (id)init
{
    self = [super init];
    if(self)
    {
        writes = [[NSMutableArray alloc] init];
        types = [[NSArray alloc] initWithObjects:
            @"public.mpeg-4", @"com.apple.quicktime-movie",
            @"org.maven-group.mpeg4-video", nil];
        tags = [[MZTag allKnownTags] retain];
    }
    return self;
}

- (void)dealloc
{
    [writes release];
    [types release];
    [tags release];
    [super dealloc];
}

- (NSString *)identifier
{
    return @"org.maven-group.MetaZ.MP4v2Plugin";
}

-(NSArray *)types
{
    return types;
}

-(NSArray *)providedTags
{
    return tags;
}

- (id<MZDataController>)loadFromFile:(NSString *)fileName
                            delegate:(id<MZDataReadDelegate>)delegate
                               queue:(NSOperationQueue *)queue
{
    MZReadOperationsController* ctrl = [MZReadOperationsController controllerWithProvider:self fromFileName:fileName delegate:delegate];
    MP4v2ReadDataTask* dataRead = [MP4v2ReadDataTask taskWithController:ctrl fromFileName:fileName dictionary:ctrl.tagdict];
    
    [ctrl addOperation:dataRead];
        
    [ctrl addOperationsToQueue:queue];

    return ctrl;
}

-(id<MZDataController>)saveChanges:(MetaEdits *)data
                          delegate:(id<MZDataWriteDelegate>)delegate
                             queue:(NSOperationQueue *)queue;
{
    MP4v2WriteOperationsController* ctrl = [MP4v2WriteOperationsController controllerWithProvider:self delegate:delegate edits:data];
    MP4v2WriteDataTask* dataWrite = [MP4v2WriteDataTask taskWithController:ctrl metaEdits:data];
    
    [ctrl addOperation:dataWrite];
 
    [writes addObject:ctrl];
    [delegate dataProvider:self controller:ctrl writeStartedForEdits:data];
    [ctrl addOperationsToQueue:queue];
    
    return ctrl;
}


- (void)removeWriteManager:(id)writeManager
{
    [writes removeObject:writeManager];
}


@end

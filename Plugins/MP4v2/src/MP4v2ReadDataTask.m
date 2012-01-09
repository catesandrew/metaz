//
//  mp4v2 ReadDataTask.m
//  MetaZ
//
//  Created by Brian Olsen on 19/01/10.
//  Copyright 2010 Maven-Group. All rights reserved.
//

#import "MP4v2ReadDataTask.h"


@implementation MP4v2ReadDataTask

+ (id)taskWithProvider:(MP4v2DataProvider*)provider fromFileName:(NSString *)fileName dictionary:(NSMutableDictionary *)tagdict
{
    return [[[[self class] alloc] initWithProvider:provider fromFileName:fileName dictionary:tagdict] autorelease];
}

- (id)initWithProvider:(MP4v2DataProvider*)theProvider fromFileName:(NSString *)theFileName dictionary:(NSMutableDictionary *)theTagdict
{
    self = [super init];
    if(self)
    {
        lock = [[NSLock alloc] init];
        provider = [theProvider retain];
        fileName = [theFileName retain];
        tagdict = [theTagdict retain];
    }
    return self;
}

- (void)dealloc
{
    [provider release];
    [fileName release];
    [tagdict release];
    [lock release];
    [super dealloc];
}

- (void)main
{
    [lock lock];
    [provider parseData:fileName dict:tagdict];    
    [lock unlock];
}

@end

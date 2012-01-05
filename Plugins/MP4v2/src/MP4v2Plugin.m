//
//  mp4v2 Plugin.m
//  MetaZ
//
//  Created by Brian Olsen on 27/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import "MP4v2Plugin.h"
#import "MP4v2DataProvider.h"

@implementation MP4v2Plugin

- (id)init
{
    self = [super init];
    if(self)
    {
        MP4v2DataProvider* a = [[MP4v2DataProvider alloc] init];
        dataProviders  = [[NSArray arrayWithObject:a] retain];
        [a release];
    }
    return self;
}

- (void)dealloc
{
    [dataProviders release];
    [super dealloc];
}

- (BOOL)isBuiltIn
{
    return YES;
}

- (NSArray *)dataProviders
{
    return dataProviders;
}

@end

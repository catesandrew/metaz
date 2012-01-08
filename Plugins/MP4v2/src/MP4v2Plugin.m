//
//  mp4v2 Plugin.m
//  MetaZ
//
//  Created by Brian Olsen on 27/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import "MP4v2Plugin.h"
#import "MP4v2DataProvider.h"
#import "mp4v2.h"

void logCallback(MP4LogLevel loglevel, const char* fmt, va_list ap)
{
    const char* level;
    switch (loglevel) {
        case 0:
            level = "None";
            break;
        case 1:
            level = "Error";
            break;
        case 2:
            level = "Warning";
            break;
        case 3:
            level = "Info";
            break;
        case 4:
            level = "Verbose1";
            break;
        case 5:
            level = "Verbose2";
            break;
        case 6:
            level = "Verbose3";
            break;
        case 7:
            level = "Verbose4";
            break;
        default:
            level = "Unknown";
            break;
    }
    
    printf("%s: ", level);
    vprintf(fmt, ap);
    printf("\n");
//    char buffer[2048];
//    vsprintf(buffer, fmt, ap);
//    MZLoggerDebug(@"%s", buffer);
}

@implementation MP4v2Plugin

- (id)init
{
    self = [super init];
    if(self)
    {
        MP4SetLogCallback(logCallback);
        MP4LogSetLevel(MP4_LOG_ERROR);
        
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

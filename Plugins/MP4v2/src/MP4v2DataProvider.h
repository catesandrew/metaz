//
//  mp4v2 MetaProvider.h
//  MetaZ
//
//  Created by Brian Olsen on 23/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MetaZKit/MetaZKit.h>

@class MP42File;

@interface MP4v2DataProvider : NSObject <MZDataProvider>
{
    MP42File  *mp4File;
    NSArray* types;
    NSArray* tags;
    NSDictionary* read_mapping;
    NSDictionary* write_mapping;
    NSDictionary* rating_read;
    NSDictionary* rating_write;
    NSMutableArray* writes;
}

+ (int)removeChaptersFromFile:(NSString *)filePath;
+ (int)importChaptersFromFile:(NSString *)chaptersFile toFile:(NSString *)filePath;

- (id)init;
- (void)removeWriteManager:(id)writeManager;

- (void)parseData:(NSString *)fileName dict:(NSMutableDictionary *)tagdict;

@end

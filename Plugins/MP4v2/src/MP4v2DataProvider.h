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
    NSArray* types;
    NSArray* tags;
    NSMutableArray* writes;
}

- (id)init;
- (void)removeWriteManager:(id)writeManager;

- (id<MZDataController>)loadFromFile:(NSString *)fileName
                           delegate:(id<MZDataReadDelegate>)delegate 
                               queue:(NSOperationQueue *)queue;

- (id<MZDataController>)saveChanges:(MetaEdits *)data 
                           delegate:(id<MZDataWriteDelegate>)delegate 
                               queue:(NSOperationQueue *)queue;
@end

//
//  mp4v2 Plugin.h
//  MetaZ
//
//  Created by Brian Olsen on 27/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MetaZKit/MetaZKit.h>

@interface MP4v2Plugin : MZPlugin
{
    NSArray* dataProviders;
}

- (id)init;
- (NSArray *)dataProviders;

@end

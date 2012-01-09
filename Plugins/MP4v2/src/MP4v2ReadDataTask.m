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


@implementation MP4v2ChapterReadDataTask

+ (id)taskWithFileName:(NSString*)fileName dictionary:(NSMutableDictionary *)tagdict;
{
    return [[[[self class] alloc] initWithFileName:fileName dictionary:tagdict] autorelease];
}

- (id)initWithFileName:(NSString*)fileName dictionary:(NSMutableDictionary *)theTagdict;
{
    self = [super init];
    if(self)
    {
        [self setArguments:[NSArray arrayWithObjects:@"-l", fileName, nil]];
        tagdict = [theTagdict retain];
    }
    return self;
}

- (void)dealloc
{
    [tagdict release];
    [super dealloc];
}

- (void)parseData
{
    if(!tagdict)
        return;
        
//    NSString* str = [[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding] autorelease];
//    
//    NSRange f = [str rangeOfString:@"Duration "];
//    NSString* movieDurationStr = [str substringWithRange:NSMakeRange(f.location+f.length, 12)];
//    //MZLoggerDebug(@"Movie duration '%@'", movieDurationStr);
//    MZTimeCode* movieDuration = [MZTimeCode timeCodeWithString:movieDurationStr];
//    [tagdict setObject:movieDuration forKey:MZDurationTagIdent];
//    
//    NSArray* lines = [str componentsSeparatedByString:@"\tChapter #"];
//    if([lines count]>1)
//    {
//        NSMutableArray* chapters = [NSMutableArray array];
//        int len = [lines count];
//        for(int i=1; i<len; i++)
//        {
//            NSString* line = [[lines objectAtIndex:i]
//                              stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            
//            NSString* startStr = [line substringWithRange:NSMakeRange(6, 12)];
//            NSString* durationStr = [line substringWithRange:NSMakeRange(21, 12)];
//            NSString* name = [line substringWithRange:NSMakeRange(37, [line length]-38)];
//            //MZLoggerDebug(@"Found args: '%@' '%@' '%@'", start, duration, name);
//            
//            MZTimeCode* start = [MZTimeCode timeCodeWithString:startStr];
//            MZTimeCode* duration = [MZTimeCode timeCodeWithString:durationStr];
//            
//            if(!start || !duration)
//                break;
//            
//            MZTimedTextItem* item = [MZTimedTextItem textItemWithStart:start duration:duration text:name];
//            [chapters addObject:item];
//        }
//        if([chapters count] == len-1)
//            [tagdict setObject:chapters forKey:MZChaptersTagIdent];
//    }
}

@end

//
//  mp4v2 WriteManager.m
//  MetaZ
//
//  Created by Brian Olsen on 29/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import "MP4v2WriteManager.h"
#import "MP42File.h"

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


@implementation MP4v2WriteDataTask

+ (id)taskWithController:(MP4v2WriteOperationsController*)controller
             metaEdits:(MetaEdits *)meta
{
    return [[[self alloc] initWithController:controller metaEdits:meta] autorelease];
}

- (id)initWithController:(MP4v2WriteOperationsController*)theController
             metaEdits:(MetaEdits *)meta
{
    MP4v2FileWriteOperation* mp4v2FileWrite = [MP4v2FileWriteOperation operationWithMainWrite:self metaEdits:meta];
    self = [super initWithOperation:mp4v2FileWrite];
    if(self)
    {
        controller = [theController retain];
        data = [meta retain];
    }

    return self;
}

- (void)notifyPercent:(NSInteger)percent
{
    [controller notifyPercent:percent];
}

- (void)operationFinished
{
    [self operationTerminated];
}

@end



@implementation MP4v2FileWriteOperation

+ (id)operationWithMainWrite:(MP4v2WriteDataTask*)theMp4v2WriteTask metaEdits:(MetaEdits *)meta
{
    return [[[[self class] alloc] initWithMainWrite:theMp4v2WriteTask metaEdits:meta] autorelease];
}

- (id)initWithMainWrite:(MP4v2WriteDataTask*)theMp4v2WriteTask metaEdits:(MetaEdits *)meta
{
    self = [super init];
    if(self)
    {
        lock = [[NSLock alloc] init];
        mp4v2WriteTask = theMp4v2WriteTask;
        data = [meta retain];
        
// return [NSArray arrayWithObjects:  @"Composer",
// @"Tempo", 
// @"Rating Annotation", "Content Rating" 
// @"Lyrics", @"Encoded By", @"contentID", @"XID", @"iTunes Account", 
// @"Sort Composer", nil];
        
        NSArray* writemapkeys = [NSArray arrayWithObjects:
            MZTitleTagIdent, MZArtistTagIdent, MZDateTagIdent, 
            MZAlbumTagIdent, MZAlbumArtistTagIdent, MZPurchaseDateTagIdent, MZShortDescriptionTagIdent,
            MZLongDescriptionTagIdent, 
            MZTVShowTagIdent, MZTVEpisodeIDTagIdent,
            MZTVSeasonTagIdent, MZTVEpisodeTagIdent, MZTVNetworkTagIdent, MZFeedURLTagIdent,
            MZEpisodeURLTagIdent, MZCategoryTagIdent, MZKeywordTagIdent, MZAdvisoryTagIdent,
            MZPodcastTagIdent, MZCopyrightTagIdent, MZGroupingTagIdent, MZEncodingToolTagIdent,
            MZCommentTagIdent, MZGaplessTagIdent, MZCompilationTagIdent,
            MZSortTitleTagIdent, MZSortArtistTagIdent, MZSortAlbumArtistTagIdent,
            MZSortAlbumTagIdent, MZSortTVShowTagIdent, MZGenreTagIdent,
            MZStudioTagIdent, MZScreenwriterTagIdent, MZProducerTagIdent, 
            MZCoDirectorTagIdent, MZDirectorTagIdent, MZActorsTagIdent,
            nil];
        
        NSArray* writemapvalues = [NSArray arrayWithObjects:
            @"Name", @"Artist", @"Release Date",
            @"Album", @"Album Artist", @"Purchase Date", @"Description",
            @"Long Description", 
            @"TV Show", @"TV Episode ID",
            @"TV Season", @"TV Episode #", @"TV Network", @"__podcastURL",
            @"__podcastGUID",@"Category", @"Keywords", @"__advisory",
            @"__podcastFlag", @"Copyright", @"Grouping", @"Encoding Tool",
            @"Comments", @"__gapless", @"__compilation",
            @"Sort Name", @"Sort Artist", @"Sort Album Artist", 
            @"Sort Album", @"Sort TV Show", @"Genre", 
            @"Studio", @"Screenwriters", @"Producers", 
            @"Codirector", @"Director", @"Cast",
            nil];
        
        write_mapping = [[NSDictionary alloc]
            initWithObjects:writemapvalues
            forKeys:writemapkeys];
        
        NSArray* ratingkeys = [NSArray arrayWithObjects:
            // US
            [NSNumber numberWithInt:MZ_G_Rating],
            [NSNumber numberWithInt:MZ_PG_Rating],
            [NSNumber numberWithInt:MZ_PG13_Rating],
            [NSNumber numberWithInt:MZ_R_Rating],
            [NSNumber numberWithInt:MZ_NC17_Rating],
            [NSNumber numberWithInt:MZ_Unrated_Rating],

            //US-TV
            [NSNumber numberWithInt:MZ_TVY7_Rating],
            [NSNumber numberWithInt:MZ_TVY_Rating],
            [NSNumber numberWithInt:MZ_TVG_Rating],
            [NSNumber numberWithInt:MZ_TVPG_Rating],
            [NSNumber numberWithInt:MZ_TV14_Rating],
            [NSNumber numberWithInt:MZ_TVMA_Rating],

            // UK
            [NSNumber numberWithInt:MZ_U_Rating],
            [NSNumber numberWithInt:MZ_Uc_Rating],
            [NSNumber numberWithInt:MZ_PG_UK_Rating],
            [NSNumber numberWithInt:MZ_12_UK_Rating],
            [NSNumber numberWithInt:MZ_12A_Rating],
            [NSNumber numberWithInt:MZ_15_UK_Rating],
            [NSNumber numberWithInt:MZ_18_UK_Rating],
            [NSNumber numberWithInt:MZ_E_UK_Rating],
            [NSNumber numberWithInt:MZ_Unrated_UK_Rating],

            // DE
            [NSNumber numberWithInt:MZ_FSK0_Rating],
            [NSNumber numberWithInt:MZ_FSK6_Rating],
            [NSNumber numberWithInt:MZ_FSK12_Rating],
            [NSNumber numberWithInt:MZ_FSK16_Rating],
            [NSNumber numberWithInt:MZ_FSK18_Rating],

            // IE
            [NSNumber numberWithInt:MZ_G_IE_Rating],
            [NSNumber numberWithInt:MZ_PG_IE_Rating],
            [NSNumber numberWithInt:MZ_12_IE_Rating],
            [NSNumber numberWithInt:MZ_15_IE_Rating],
            [NSNumber numberWithInt:MZ_16_Rating],
            [NSNumber numberWithInt:MZ_18_IE_Rating],
            [NSNumber numberWithInt:MZ_Unrated_IE_Rating],

            // IE-TV
            [NSNumber numberWithInt:MZ_GA_Rating],
            [NSNumber numberWithInt:MZ_Ch_Rating],
            [NSNumber numberWithInt:MZ_YA_Rating],
            [NSNumber numberWithInt:MZ_PS_Rating],
            [NSNumber numberWithInt:MZ_MA_IETV_Rating],
            [NSNumber numberWithInt:MZ_Unrated_IETV_Rating],

            // CA
            [NSNumber numberWithInt:MZ_G_CA_Rating],
            [NSNumber numberWithInt:MZ_PG_CA_Rating],
            [NSNumber numberWithInt:MZ_14_Rating],
            [NSNumber numberWithInt:MZ_18_CA_Rating],
            [NSNumber numberWithInt:MZ_R_CA_Rating],
            [NSNumber numberWithInt:MZ_E_CA_Rating],
            [NSNumber numberWithInt:MZ_Unrated_CA_Rating],

            // CA-TV
            [NSNumber numberWithInt:MZ_C_CATV_Rating],
            [NSNumber numberWithInt:MZ_C8_Rating],
            [NSNumber numberWithInt:MZ_G_CATV_Rating],
            [NSNumber numberWithInt:MZ_PG_CATV_Rating],
            [NSNumber numberWithInt:MZ_14Plus_Rating],
            [NSNumber numberWithInt:MZ_18Plus_Rating],
            [NSNumber numberWithInt:MZ_Unrated_CATV_Rating],

            // AU
            [NSNumber numberWithInt:MZ_E_AU_Rating],
            [NSNumber numberWithInt:MZ_G_AU_Rating],
            [NSNumber numberWithInt:MZ_PG_AU_Rating],
            [NSNumber numberWithInt:MZ_M_AU_Rating],
            [NSNumber numberWithInt:MZ_MA15Plus_AU_Rating],
            [NSNumber numberWithInt:MZ_R18Plus_Rating],
            [NSNumber numberWithInt:MZ_Unrated_AU_Rating],

            // AU-TV
            [NSNumber numberWithInt:MZ_P_Rating],
            [NSNumber numberWithInt:MZ_C_AUTV_Rating],
            [NSNumber numberWithInt:MZ_G_AUTV_Rating],
            [NSNumber numberWithInt:MZ_PG_AUTV_Rating],
            [NSNumber numberWithInt:MZ_M_AUTV_Rating],
            [NSNumber numberWithInt:MZ_MA15Plus_AUTV_Rating],
            [NSNumber numberWithInt:MZ_AV15Plus_Rating],
            [NSNumber numberWithInt:MZ_Unrated_AUTV_Rating],

            // NZ
            [NSNumber numberWithInt:MZ_E_NZ_Rating],
            [NSNumber numberWithInt:MZ_G_NZ_Rating],
            [NSNumber numberWithInt:MZ_PG_NZ_Rating],
            [NSNumber numberWithInt:MZ_M_NZ_Rating],
            [NSNumber numberWithInt:MZ_R13_Rating],
            [NSNumber numberWithInt:MZ_R15_Rating],
            [NSNumber numberWithInt:MZ_R16_Rating],
            [NSNumber numberWithInt:MZ_R18_Rating],
            [NSNumber numberWithInt:MZ_R_NZ_Rating],
            [NSNumber numberWithInt:MZ_Unrated_NZ_Rating],

            // NZ-TV
            [NSNumber numberWithInt:MZ_G_NZTV_Rating],
            [NSNumber numberWithInt:MZ_PGR_Rating],
            [NSNumber numberWithInt:MZ_AO_Rating],
            [NSNumber numberWithInt:MZ_Unrated_NZTV_Rating],
            nil];
        
        NSArray* ratingvalues = [NSArray arrayWithObjects:                                 
            // US                    
            // @"mpaa|NR|000|",
            @"mpaa|G|100|",
            @"mpaa|PG|200|",
            @"mpaa|PG-13|300|",
            @"mpaa|R|400|",
            @"mpaa|NC-17|500|",
            @"mpaa|Unrated|600|",

            // US-TV
            @"us-tv|TV-Y7|100|",
            @"us-tv|TV-Y|200|",
            @"us-tv|TV-G|300|",
            @"us-tv|TV-PG|400|",
            @"us-tv|TV-14|500|",
            @"us-tv|TV-MA|600|",
            //@"us-tv|Unrated|???|",

            // UK
            @"uk-movie|U|100|",
            @"uk-movie|Uc|150|",
            @"uk-movie|PG|200|",
            @"uk-movie|12|300|",
            @"uk-movie|12A|325|",
            @"uk-movie|15|350|",
            @"uk-movie|18|400|",
            @"uk-movie|E|600|",
            @"uk-movie|UNRATED|900|",

            // DE
            @"de-movie|FSK 0|100|",
            @"de-movie|FSK 6|200|",
            @"de-movie|FSK 12|300|",
            @"de-movie|FSK 16|400|",
            @"de-movie|FSK 18|500|",

            // IE
            @"ie-movie|G|100|",
            @"ie-movie|PG|200|",
            @"ie-movie|12|300|",
            @"ie-movie|15|350|",
            @"ie-movie|16|375|",
            @"ie-movie|18|400|",
            @"ie-movie|UNRATED|900|",

            // IE-TV
            @"ie-tv|GA|100|",
            @"ie-tv|Ch|200|",
            @"ie-tv|YA|400|",
            @"ie-tv|PS|500|",
            @"ie-tv|MA|600|",
            @"ie-tv|UNRATED|900|",

            // CA
            @"ca-movie|G|100|",
            @"ca-movie|PG|200|",
            @"ca-movie|14|325|",
            @"ca-movie|18|400|",
            @"ca-movie|R|500|",
            @"ca-movie|E|600|",
            @"ca-movie|UNRATED|900|",

            // CA-TV
            @"ca-tv|C|100|",
            @"ca-tv|C8|200|",
            @"ca-tv|G|300|",
            @"ca-tv|PG|400|",
            @"ca-tv|14+|500|",
            @"ca-tv|18+|600|",
            @"ca-tv|UNRATED|900|",

            // AU
            @"au-movie|E|0|",
            @"au-movie|G|100|",
            @"au-movie|PG|200|",
            @"au-movie|M|350|",
            @"au-movie|MA 15+|375|",
            @"au-movie|R18+|400|",
            @"au-movie|UNRATED|900|",

            // AU-TV
            @"au-tv|P|100|",
            @"au-tv|C|200|",
            @"au-tv|G|300|",
            @"au-tv|PG|400|",
            @"au-tv|M|500|",
            @"au-tv|MA 15+|550|",
            @"au-tv|AV 15+|575|",
            @"au-tv|UNRATED|900|",

            // NZ
            @"nz-movie|E|0|",
            @"nz-movie|G|100|",
            @"nz-movie|PG|200|",
            @"nz-movie|M|300|",
            @"nz-movie|R13|325|",
            @"nz-movie|R15|350|",
            @"nz-movie|R16|375|",
            @"nz-movie|R18|400|",
            @"nz-movie|R|500",
            @"nz-movie|R|UNRATED|900",

            // NZ-TV
            @"nz-tv|G|200|",
            @"nz-tv|PGR|400|",
            @"nz-tv|AO|600|",
            @"nz-tv|UNRATED|900|",
            nil];
        
        rating_write = [[NSDictionary alloc]
            initWithObjects:ratingvalues
            forKeys:ratingkeys];
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [mp4v2WriteTask release];
    [lock release];
    [rating_write release];
    [write_mapping release];
    [super dealloc];
}

-(void)main
{
    [lock lock];

    BOOL success = NO;
    BOOL optimize = NO;
    NSString* fileName = [data loadedFileName];
    MP42File* mp4File = [[MP42File alloc] initWithExistingFile:fileName andDelegate:self];
    MP42Metadata* metadata = [mp4File metadata];
    
    NSDictionary* changes = [data changes];
    for(NSString* key in [changes allKeys])
    {
        NSString* map = [write_mapping objectForKey:key]; // map - Name, key - title
        if(map)
        {
            MZTag* tag = [MZTag tagForIdentifier:key];
            id value = [changes objectForKey:key];
            value = [tag stringForObject:value];
            NSString *oldValue = [[[metadata tagsDict] valueForKey:key] retain];            
            if (![metadata setTag:value forKey:map]) {
                MZLoggerDebug(@"Value %@ not updated for key %@", value, map);
                break;
            }
            [oldValue release];
        }
    }
    
    // Special rating handling
    id rating = [changes objectForKey:MZRatingTagIdent];
    if(rating)
    {
        NSString* rate = [rating_write objectForKey:rating];
        if(rate)
        {
            if (![metadata setTag:rate forKey:@"Rating"]) {
                MZLoggerDebug(@"Rating not updated for value %@", rate);
            }
        }
    }
    
    // Special video type handling
    id stikNo = [changes objectForKey:MZVideoTypeTagIdent];
    if(stikNo)
    {
        MZVideoType stik;
        MZTag* tag = [MZTag tagForIdentifier:MZVideoTypeTagIdent];
        [tag nullConvertObject:stikNo toValue:&stik];
        NSString* stikStr = nil;
        switch (stik) {
            case MZUnsetVideoType:
                stikStr = @"";
                break;
            case MZMusicType:
                stikStr = @"Music";
                break;
            case MZAudiobookVideoType:
                stikStr = @"Audiobook";
                break;
            case MZMusicVideoType:
                stikStr = @"Music Video";
                break;
            case MZMovieVideoType:
                stikStr = @"Movie";
                break;
            case MZTVShowVideoType:
                stikStr = @"TV Show";
                break;
            case MZBookletVideoType:
                stikStr = @"Booklet";
                break;
            case MZRingtoneVideoType:
                stikStr = @"Ringtone";
                break;
        }
        if(stikStr)
        {
            if (![metadata setTag:stikStr forKey:@"Media Kind"]) {
                MZLoggerDebug(@"Media Kind not updated for value %@", stikStr);
            }
        }
    }
    
    // Special track number/count handling    
    MZTag* numberTag = [MZTag tagForIdentifier:MZTrackNumberTagIdent];
    MZTag* countTag = [MZTag tagForIdentifier:MZTrackCountTagIdent];
    id number = [changes objectForKey:[numberTag identifier]];
    if(!number)
    {
        numberTag = [MZTag tagForIdentifier:MZTVEpisodeTagIdent];
        number = [changes objectForKey:[numberTag identifier]];
    }
    id count = [changes objectForKey:[countTag identifier]];
    if(number || count)
    {
        number = [numberTag stringForObject:number];
        count = [countTag stringForObject:count];
        NSUInteger numberLen = [number length];
        NSUInteger countLen = [count length];
        
        NSString* value = @"";
        if(numberLen > 0 || countLen > 0)
        {
            if(numberLen > 0 && countLen > 0)
                value = [NSString stringWithFormat:@"%@/%@", number, count];
            else if(numberLen > 0)
                value = number;
            else
                value = [NSString stringWithFormat:@"/%@", count];
        }
        if (![metadata setTag:value forKey:@"Track #"]) {
            MZLoggerDebug(@"Track not updated for value %@", value);
        }
    }
    
    // Special disc number/count handling
    numberTag = [MZTag tagForIdentifier:MZDiscNumberTagIdent];
    countTag = [MZTag tagForIdentifier:MZDiscCountTagIdent];
    number = [changes objectForKey:[numberTag identifier]];
    count = [changes objectForKey:[countTag identifier]];
    if(number || count)
    {
        number = [numberTag stringForObject:number];
        count = [countTag stringForObject:count];
        NSUInteger numberLen = [number length];
        NSUInteger countLen = [count length];
        
        NSString* value = @"";
        if(numberLen > 0 || countLen > 0)
        {
            if(numberLen > 0 && countLen > 0)
                value = [NSString stringWithFormat:@"%@/%@", number, count];
            else if(numberLen > 0)
                value = number;
            else
                value = [NSString stringWithFormat:@"/%@", count];
        }
        if (![metadata setTag:value forKey:@"Disk #"]) {
            MZLoggerDebug(@"Disk not updated for value %@", value);
        }
    }
    
    
    // Special image handling
    id pictureObj = [changes objectForKey:MZPictureTagIdent];
    NSString* pictureFile = nil;
    if(pictureObj == [NSNull null])
    {
        if (![metadata setTag:nil forKey:@"Artwork"]) {
            MZLoggerDebug(@"Artwork not removed");
        }
    }
    else if(pictureObj)
    {
        NSData* picture = pictureObj;
        
        pictureFile = [NSString temporaryPathWithFormat:@"MetaZImage_%@.png"];
        
        //NSData *imageData = [picture TIFFRepresentation];
        NSBitmapImageRep* imageRep = [NSBitmapImageRep imageRepWithData:picture];
        picture = [imageRep representationUsingType:NSPNGFileType properties:[NSDictionary dictionary]];
        
        NSError* error = nil;
        if([picture writeToFile:pictureFile options:0 error:&error])
        {
            if (![metadata setTag:pictureFile forKey:@"Artwork"]) {
                MZLoggerDebug(@"Artwork not updated for value %@", pictureFile);
            }
        }
        else
        {
            MZLoggerError(@"Failed to write image to temp '%@' %@", pictureFile, [error localizedDescription]);
            pictureFile = nil;
        }
    }
    
    [mp4v2WriteTask notifyPercent:0.10];
//    NSString* fileName;
//    if([args count]-3 == 0)
//        fileName = [data loadedFileName];
//    else
//        fileName = [data savedTempFileName];
    
    NSError	 **outError;
    NSMutableDictionary * attributes = [[NSMutableDictionary alloc] init];
    int saveOperation = 1; /* 1 = Save, 2 = Save As */
    if (saveOperation == 1) {
        // movie file already exists, so we'll just update
        // the movie resource
        success = [mp4File updateMP4FileWithAttributes:attributes error:outError];
    } else {
        [attributes setObject:[NSNumber numberWithBool:YES] forKey:MP42Create64BitData];
        [attributes setObject:[NSNumber numberWithBool:YES] forKey:MP42Create64BitTime];
        success = [mp4File writeToUrl:fileName withAttributes:attributes error:outError];
    }
    [mp4v2WriteTask notifyPercent:0.8];
    if (optimize)
    {
        [mp4File optimize];
        optimize = NO;
    }
    [mp4v2WriteTask notifyPercent:0.9];
    [attributes release];
    
    if (pictureFile) {
        NSError* tempError = nil;
        NSFileManager* mgr = [NSFileManager manager];
        if(![mgr removeItemAtPath:pictureFile error:&tempError])
        {
            MZLoggerError(@"Failed to remove temp picture file %@", [tempError localizedDescription]);
            tempError = nil;
        }
    }

    // Special chapters handling
    // If the mp4File doesn't have a chapter track,
    // we will have to create with with mp4File addTrack()
    id chaptersObj = [changes objectForKey:MZChaptersTagIdent];
    MP42ChapterTrack* chapterTrack = [mp4File chapters];
    if(chaptersObj == [NSNull null] || (chaptersObj && [chaptersObj count] == 0))
    {
        if (chapterTrack != NULL) { 
            NSInteger chapCount = [chapterTrack chapterCount];
            if (chapCount > 0) {
                for (int i = 0; i < chapCount; i++) {
                   [chapterTrack removeChapterAtIndex:i]; 
                }
            }
        }
    }
    else if(chaptersObj)
    {
        NSArray* chapters = chaptersObj;             
        if (chapterTrack != NULL) {  
            // Loop through chapters, call [chapterTrack addChapter]
            uint32_t chapterCount = [chapters count];
            
        }
    }
    
    [mp4v2WriteTask notifyPercent:1.0];
    [mp4v2WriteTask operationFinished];
    [lock unlock];

}

@end
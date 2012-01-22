//
//  mp4v2 ReadDataTask.m
//  MetaZ
//
//  Created by Brian Olsen on 19/01/10.
//  Copyright 2010 Maven-Group. All rights reserved.
//

#import "MP4v2ReadDataTask.h"
#import "MP42File.h"

@implementation MP4v2ReadDataTask

+ (id)taskWithController:(MZReadOperationsController*)theController fromFileName:(NSString *)fileName dictionary:(NSMutableDictionary *)tagdict
{
    return [[[[self class] alloc] initWithController:theController fromFileName:fileName dictionary:tagdict] autorelease];
}

- (id)initWithController:(MZReadOperationsController*)theController fromFileName:(NSString *)theFileName dictionary:(NSMutableDictionary *)theTagdict
{
    MP4v2FileReadOperation* mp4v2FileWrite = [MP4v2FileReadOperation operationWithReadDataTask:self fromFileName:theFileName dictionary:theTagdict];
    self = [super initWithOperation:mp4v2FileWrite];
    if(self)
    {
        controller = [theController retain];
    }
    return self;
}

- (void)operationFinished
{
    [controller operationsFinished];
}

- (void)dealloc
{
    [provider release];
    [super dealloc];
}

@end


@implementation MP4v2FileReadOperation

+ (id)operationWithReadDataTask:(MP4v2ReadDataTask*)theTask fromFileName:(NSString *)theFileName dictionary:(NSMutableDictionary *)theTagdict
{
    return [[[[self class] alloc] initWithReadDataTask:theTask fromFileName:theFileName dictionary:theTagdict] autorelease];
}

- (id)initWithReadDataTask:(MP4v2ReadDataTask*)theTask fromFileName:(NSString *)theFileName dictionary:(NSMutableDictionary *)theTagdict
{
    self = [super init];
    if(self)
    {
        lock = [[NSLock alloc] init];
        readDataTask = [theTask retain];
        fileName = [theFileName retain];
        tagdict = [theTagdict retain];
        tags = [[MZTag allKnownTags] retain];
        
        // return [NSArray arrayWithObjects:  @"Composer",
        // @"Track #", @"Disk #", @"Tempo", 
        // @"Rating", @"Rating Annotation",
        // @"Studio", @"Cast", @"Director", @"Codirector", @"Producers", @"Screenwriters",
        // @"Lyrics", @"Encoded By", @"contentID", @"artistID", @"playlistID", @"genreID", @"composerID",
        // @"XID", @"iTunes Account", @"Sort Composer", @"Sort TV Show", nil];
        
        NSArray* readmapkeys = [NSArray arrayWithObjects:
            @"Name", @"Artist", @"Release Date",
            @"Album", @"Album Artist", @"Purchase Date", @"Description", 
            @"Long Description",
            @"TV Show", @"TV Episode ID",
            @"TV Season", @"TV Episode #", @"TV Network", @"__purl", // MZFeedURLTagIdent
            @"__egid", @"Category", @"Keywords", @"__rtng", //MZEpisodeURLTagIdent, MZAdvisoryTagIdent
            @"__pcst", @"Copyright", @"Grouping", @"Encoding Tool", // MZPodcastTagIdent
            @"Comments", @"__pgap", @"__cpil", @"Sort Name", // MZGaplessTagIdent, MZCompilationTagIdent
            @"Sort Artist", @"Sort Album Artist", @"Sort Album",
            @"Sort TV Show", nil];
        
        NSArray* readmapvalues = [NSArray arrayWithObjects:
            MZTitleTagIdent, MZArtistTagIdent, MZDateTagIdent,
            MZAlbumTagIdent, MZAlbumArtistTagIdent, MZPurchaseDateTagIdent, MZShortDescriptionTagIdent,
            MZLongDescriptionTagIdent, 
            MZTVShowTagIdent, MZTVEpisodeIDTagIdent,
            MZTVSeasonTagIdent, MZTVEpisodeTagIdent, MZTVNetworkTagIdent, MZFeedURLTagIdent,
            MZEpisodeURLTagIdent, MZCategoryTagIdent, MZKeywordTagIdent, MZAdvisoryTagIdent,
            MZPodcastTagIdent, MZCopyrightTagIdent, MZGroupingTagIdent, MZEncodingToolTagIdent,
            MZCommentTagIdent, MZGaplessTagIdent, MZCompilationTagIdent, MZSortTitleTagIdent,
            MZSortArtistTagIdent, MZSortAlbumArtistTagIdent, MZSortAlbumTagIdent,
            MZSortTVShowTagIdent,nil];
        
        read_mapping = [[NSDictionary alloc]
            initWithObjects:readmapvalues
            forKeys:readmapkeys];
        
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

        rating_read = [[NSDictionary alloc]
            initWithObjects:ratingkeys
            forKeys:ratingvalues];
    }
    return self;
}

- (void)dealloc
{
    [fileName release];
    [tagdict release];
    [readDataTask release];
    [lock release];
    [read_mapping release];
    [rating_read release];
    [super dealloc];
}

-(void)main
{
    [lock lock];
    
    MP42File *mp4File = [[MP42File alloc] initWithExistingFile:fileName andDelegate:self];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[tags count]];
    MP42Metadata* metadata = [mp4File metadata];    
    NSString * tag_value;
    NSString * tag_key;
    for (tag_key in metadata.tagsDict) {
        tag_value = [metadata.tagsDict valueForKey:tag_key];
        if (tag_value) {
            [dict setObject:tag_value forKey:tag_key];
        }
    }
    
    // Initialize a null value for all known keys
    for(MZTag* tag in tags)
        [tagdict setObject:[NSNull null] forKey:[tag identifier]];
    
    // Store real parsed values using a simple key -> key mapping
    for(NSString* map in [read_mapping allKeys]) //map == purd
    {
        NSString* tagId = [read_mapping objectForKey:map]; // tagId == purchaseDate
        MZTag* tag = [MZTag tagForIdentifier:tagId];
        NSString* value = [dict objectForKey:map]; // map == purd
        if(value)
            [tagdict setObject:[tag convertObjectForStorage:[tag objectFromString:value]] forKey:tagId];
    }
    
    // Special genre handling
    NSString* genre = [dict objectForKey:@"Genre"];
    if(genre)
    {
        [tagdict setObject:genre forKey:MZGenreTagIdent];
    }
    
    // Special rating handling
    NSNumber *rating_index = [dict objectForKey:@"Rating"];
    NSString *rating = [metadata ratingDescriptionFromIndex:[rating_index intValue]];
    if(rating)
    {
        id rate = [rating_read objectForKey:rating];
        if(rate)
            [tagdict setObject:rate forKey:MZRatingTagIdent];
    }
    
    // Special video type handling (stik)
    NSString* stik = [metadata mediaKindAsString];
    if(stik)
    {
        MZVideoType stikNo = MZUnsetVideoType;
        if([stik isEqualToString:@"Music"])
            stikNo = MZMusicType;
        else if([stik isEqualToString:@"Audiobook"])
            stikNo = MZAudiobookVideoType;
        else if([stik isEqualToString:@"Music Video"])
            stikNo = MZMusicVideoType;
        else if([stik isEqualToString:@"Movie"])
            stikNo = MZMovieVideoType;
        else if([stik isEqualToString:@"TV Show"])
            stikNo = MZTVShowVideoType;
        else if([stik isEqualToString:@"Booklet"])
            stikNo = MZBookletVideoType;
        else if([stik isEqualToString:@"Ringtone"])
            stikNo = MZRingtoneVideoType;
        if(stikNo!=MZUnsetVideoType)
        {
            MZTag* tag = [MZTag tagForIdentifier:MZVideoTypeTagIdent];
            [tagdict setObject:[tag nullConvertValueToObject:&stikNo]
                        forKey:MZVideoTypeTagIdent];
        }
    }
    
    // Special handling for cast, directors, producers and screenwriters
    NSString* value = [dict objectForKey:@"Cast"];
    if(value)
    {
        [tagdict setObject:value forKey:MZActorsTagIdent];
    }
    
    value = [dict objectForKey:@"Director"];
    if(value)
    {
        [tagdict setObject:value forKey:MZDirectorTagIdent];
    }
    
    value = [dict objectForKey:@"Codirector"];
    if(value)
    {
        [tagdict setObject:value forKey:MZCoDirectorTagIdent];
    }
    
    value = [dict objectForKey:@"Producers"];
    if(value)
    {
        [tagdict setObject:value forKey:MZProducerTagIdent];
    }
    
    value = [dict objectForKey:@"Screenwriters"];
    if(value)
    {
        [tagdict setObject:value forKey:MZScreenwriterTagIdent];
    }
    
    value = [dict objectForKey:@"Studio"];
    if(value)
    {
        [tagdict setObject:value forKey:MZStudioTagIdent];
    }
    
    // Special handling of track
    NSString* trkn = [dict objectForKey:@"Track #"];
    if(trkn)
    {
        NSArray* trks = [trkn componentsSeparatedByString:@"/"];
        NSAssert([trks count] < 3, @"Only two tracks");
        
        MZTag* tag1 = [MZTag tagForIdentifier:MZTrackNumberTagIdent];
        NSNumber* num = [tag1 objectFromString:[trks objectAtIndex:0]];
        [tagdict setObject:num forKey:MZTrackNumberTagIdent];
        
        if([trks count] == 2)
        {
            MZTag* tag2 = [MZTag tagForIdentifier:MZTrackCountTagIdent];
            NSNumber* count = [tag2 objectFromString:[trks objectAtIndex:1]];
            [tagdict setObject:count forKey:MZTrackCountTagIdent];
        }
    }
    
    // Special handling of disc num
    NSString* disk = [dict objectForKey:@"Disk #"];
    if(disk)
    {
        NSArray* trks = [disk componentsSeparatedByString:@"/"];
        NSAssert([trks count] < 3, @"Only two disks");
        
        MZTag* tag1 = [MZTag tagForIdentifier:MZDiscNumberTagIdent];
        NSNumber* num = [tag1 objectFromString:[trks objectAtIndex:0]];
        [tagdict setObject:num forKey:MZDiscNumberTagIdent];
        
        if([trks count] == 2)
        {
            MZTag* tag2 = [MZTag tagForIdentifier:MZDiscCountTagIdent];
            NSNumber* count = [tag2 objectFromString:[trks objectAtIndex:1]];
            [tagdict setObject:count forKey:MZDiscCountTagIdent];
        }
    }
    
    // Filename auto set
    [tagdict setObject:[fileName lastPathComponent] forKey:MZFileNameTagIdent];
    id title = [tagdict objectForKey:MZTitleTagIdent];
    if(![title isKindOfClass:[NSString class]])
    {
        NSString* newTitle = [MZPluginController extractTitleFromFilename:fileName];
        [tagdict setObject:newTitle forKey:MZTitleTagIdent];
    }
    
    // Special image handling
    NSImage *artwork = [metadata artwork];
    if (artwork) {
        NSArray *imageReps = [artwork representations];        
        for (NSBitmapImageRep *imageRep in imageReps) {
            if (imageRep != NULL) {
                NSData *nsdata = [imageRep TIFFRepresentation];
                if (nsdata != NULL) {
                    [tagdict setObject:nsdata forKey:MZPictureTagIdent];
                    break;
                }
            }
        }
    }
    
    // Duration
    NSUInteger duration = [mp4File movieDuration];
    if (duration) {
        MZTimeCode* movieDuration = [[MZTimeCode alloc] initWithMillis:duration];
        NSString *description = [movieDuration description];
        MZLoggerDebug(@"Movie duration '%@'", description);
        [tagdict setObject:movieDuration forKey:MZDurationTagIdent];
    }
    
    // Chapters
    MP42ChapterTrack* chapterTrack = [mp4File chapters];
    if (chapterTrack != NULL) {       
        NSArray *chaps = [chapterTrack chapters];
        if (chaps != NULL) {
            NSUInteger chapter_count = [chaps count];
            NSMutableArray* chapters = [NSMutableArray array];
            MP4Duration sum = 0;
            for (int i = 1; i < chapter_count; i++) {
                SBTextSample *sb_prev = [chaps objectAtIndex:i-1];
                SBTextSample *sb_current = [chaps objectAtIndex:i];
                
                NSString *ch_name = [sb_prev title];
                MP4Duration prev_timestamp = [sb_prev getTimestamp];
                MP4Duration ch_timestamp = [sb_current getTimestamp];
                
                ch_timestamp = ch_timestamp - prev_timestamp;
                
                MZTimeCode* ch_start = [[MZTimeCode alloc] initWithMillis:sum];
                MZTimeCode* ch_duration = [[MZTimeCode alloc] initWithMillis:ch_timestamp];
                
                if(!ch_start || !ch_duration)
                    break;
                
                MZTimedTextItem* item = [MZTimedTextItem textItemWithStart:ch_start duration:ch_duration text:ch_name];
                [chapters addObject:item];
                [item release];
                sum = sum + ch_timestamp;
            }
            
            // last chapter
            SBTextSample *sb_last = [chaps objectAtIndex:chapter_count-1];
            NSString *ch_name = [sb_last title];
            MP4Duration ch_timestamp = [sb_last getTimestamp];
            ch_timestamp = duration - ch_timestamp;
            
            MZTimeCode* ch_start = [[MZTimeCode alloc] initWithMillis:sum];
            MZTimeCode* ch_duration = [[MZTimeCode alloc] initWithMillis:ch_timestamp];
            
            if(ch_start && ch_duration) {
                MZTimedTextItem* item = [MZTimedTextItem textItemWithStart:ch_start duration:ch_duration text:ch_name];
                [chapters addObject:item];
                [item release];
                sum = sum + ch_timestamp;
            }
            
            if([chapters count] == chapter_count) {
                [tagdict setObject:chapters forKey:MZChaptersTagIdent];
            }
        }
    }
    
    [readDataTask operationFinished];
    [lock unlock];
}

@end
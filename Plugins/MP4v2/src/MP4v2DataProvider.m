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

+ (int)removeChaptersFromFile:(NSString *)filePath
{
    NSTask* task = [[NSTask alloc] init];
//    [task setLaunchPath:[self launchChapsPath]];
    [task setArguments:[NSArray arrayWithObjects:@"-r", filePath, nil]];
    NSPipe* err = [NSPipe pipe];
    [task setStandardError:err];
    [task setStandardOutput:err];
    [task launch];
    [task waitUntilExit];
//    [self logFromProgram:@"mp4chaps" pipe:err];
    int ret = [task terminationStatus];
    [task release];
    return ret;
}

+ (int)importChaptersFromFile:(NSString *)chaptersFile toFile:(NSString *)filePath
{
    
    NSTask* task = [[NSTask alloc] init];
//    [task setLaunchPath:[self launchChapsPath]];
    [task setArguments:[NSArray arrayWithObjects:@"--import", chaptersFile, filePath, nil]];
    NSPipe* err = [NSPipe pipe];
    [task setStandardError:err];
    [task setStandardOutput:err];
    [task launch];
    [task waitUntilExit];
//    [self logFromProgram:@"mp4chaps" pipe:err];
    int ret = [task terminationStatus];
    [task release];
    return ret;
}

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
        NSArray* readmapkeys = [NSArray arrayWithObjects:
            @"Name", @"Artist", @"Release Date",
            @"Album", @"Album Artist", @"Purchase Date", @"Description", 
            @"Long Description",
            @"TV Show", @"TV Episode ID",
            @"TV Season", @"TV Episode #", @"TV Network", @"purl", // MZFeedURLTagIdent
            @"egid", @"Category", @"Keywords", @"rtng", //MZEpisodeURLTagIdent, MZAdvisoryTagIdent
            @"pcst", @"Copyright", @"Grouping", @"Encoding Tool", // MZPodcastTagIdent
            @"Comments", @"pgap", @"cpil", @"Sort Name", // MZGaplessTagIdent, MZCompilationTagIdent
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


        NSArray* writemapkeys = [NSArray arrayWithObjects:
            MZTitleTagIdent, MZArtistTagIdent, MZDateTagIdent,
            //MZRatingTagIdent,
            MZGenreTagIdent,
            MZAlbumTagIdent, MZAlbumArtistTagIdent, MZPurchaseDateTagIdent, MZShortDescriptionTagIdent,
            MZLongDescriptionTagIdent, MZVideoTypeTagIdent,
            MZTVShowTagIdent, MZTVEpisodeIDTagIdent,
            MZTVSeasonTagIdent, MZTVEpisodeTagIdent, MZTVNetworkTagIdent, MZFeedURLTagIdent,
            MZEpisodeURLTagIdent, MZCategoryTagIdent, MZKeywordTagIdent, MZAdvisoryTagIdent,
            MZPodcastTagIdent, MZCopyrightTagIdent, MZGroupingTagIdent, MZEncodingToolTagIdent,
            MZCommentTagIdent, MZGaplessTagIdent, MZCompilationTagIdent,
            nil];
            //MZSortTitleTagIdent, MZSortArtistTagIdent, MZSortAlbumArtistTagIdent,
            //MZSortAlbumTagIdent, MZSortTVShowTagIdent,nil];
        NSArray* writemapvalues = [NSArray arrayWithObjects:
            @"title", @"artist", @"year",
            //@"contentRating",
            @"genre",
            @"album", @"albumArtist", @"purchaseDate", @"description",
            @"longdesc", @"stik",
            @"TVShowName", @"TVEpisode",
            @"TVSeasonNum", @"TVEpisodeNum", @"TVNetwork", @"podcastURL",
            @"podcastGUID",@"category", @"keyword", @"advisory",
            @"podcastFlag", @"copyright", @"grouping", @"encodingTool",
            @"comment", @"gapless", @"compilation",
            nil];
            //@"sonm", @"soar", @"soaa",
            //@"soal", @"sosn", nil];
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
            @"2",
            @"3",
            @"4",
            @"5",
            @"6",
            @"7",
            
        // US-TV
            @"9",
            @"10",
            @"11",
            @"12",
            @"13",
            @"14",
            
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
        rating_read = [[NSDictionary alloc]
            initWithObjects:ratingkeys
                    forKeys:ratingvalues];

    }
    return self;
}

- (void)dealloc
{
    [writes release];
    [types release];
    [tags release];
    [read_mapping release];
    [write_mapping release];
    [rating_read release];
    [rating_write release];
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
    MZReadOperationsController* op = [MZReadOperationsController
        controllerWithProvider:self
                  fromFileName:fileName
                      delegate:delegate];
    
    MP4v2ReadDataTask* dataRead = [MP4v2ReadDataTask taskWithProvider:self fromFileName:fileName dictionary:op.tagdict];
    [op addOperation:dataRead];
        
    [op addOperationsToQueue:queue];

    return op;
}

- (void)parseData:(NSString *)fileName dict:(NSMutableDictionary *)tagdict
{
    mp4File = [[MP42File alloc] initWithExistingFile:fileName andDelegate:self];

    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[tags count]];
    MP42Metadata* metadata = [mp4File metadata];    
    NSString * tag_value;
    NSString * tag_key;
    for (tag_key in metadata.tagsDict) {
        tag_value = [metadata.tagsDict valueForKey:tag_key];
        if (tag_value) {
//            MZLoggerDebug(@"%@ %@", tag_key, tag_value);
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
//        MZLoggerDebug(@"%@ %@", tagId, value);
        if(value)
            [tagdict setObject:[tag convertObjectForStorage:[tag objectFromString:value]] forKey:tagId];
    }
    
    // Special genre handling
    NSString* genre = [dict objectForKey:@"Genre"];
    if(genre)
    {
//        MZLoggerDebug(@"Genre %@", genre);
        [tagdict setObject:genre forKey:MZGenreTagIdent];
    }
    
    // Special rating handling
    NSNumber *rating = [dict objectForKey:@"Rating"];
    NSString *rating_index = [rating stringValue];
    if(rating)
    {
//        MZLoggerDebug(@"Rating %@", rating);
        id rate = [rating_read objectForKey:rating_index];
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
                MP4Duration prev_timestamp = [sb_prev mp4Duration];
                MP4Duration ch_timestamp = [sb_current mp4Duration];
                ch_timestamp = ch_timestamp - prev_timestamp;
                
                MZTimeCode* ch_start = [[MZTimeCode alloc] initWithMillis:sum];
                MZTimeCode* ch_duration = [[MZTimeCode alloc] initWithMillis:ch_timestamp];
                
//              NSString *start_description = [ch_start description];
//              NSString *duration_description = [ch_duration description];
//              MZLoggerDebug(@"Chapter: '%@':'%@'-'%@'", ch_name, start_description, duration_description)
                
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
            MP4Duration ch_timestamp = [sb_last mp4Duration];
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
}

void sortTags(NSMutableArray* args, NSDictionary* changes, NSString* tag, NSString* sortType)
{
    id value = [changes objectForKey:tag];
    if(value == [NSNull null])
        value = @"";
    if(value)
    {
        [args addObject:@"--sortOrder"];
        [args addObject:sortType];
        [args addObject:value];
    }
}


-(id<MZDataController>)saveChanges:(MetaEdits *)data
          delegate:(id<MZDataWriteDelegate>)delegate
             queue:(NSOperationQueue *)queue;
{
    NSMutableArray* args = [NSMutableArray array];
    [args addObject:[data loadedFileName]];
    
    [args addObject:@"--output"];
    [args addObject:[data savedTempFileName]];
    
    NSDictionary* changes = [data changes];
    for(NSString* key in [changes allKeys])
    {
        NSString* map = [write_mapping objectForKey:key];
        if(map)
        {
            MZTag* tag = [MZTag tagForIdentifier:key];
            id value = [changes objectForKey:key];
            value = [tag stringForObject:value];
            [args addObject:[@"--" stringByAppendingString:map]];
            [args addObject:value];
        }
    }
    
    // Special rating handling
    id rating = [changes objectForKey:MZRatingTagIdent];
    if(rating)
    {
        MZLoggerDebug(@"Rating %@", rating);
        NSString* rate = [rating_write objectForKey:rating];
        if(rate)
        {
            [args addObject:@"--rDNSatom"];
            [args addObject:rate];
            [args addObject:@"name=iTunEXTC"];
            [args addObject:@"domain=com.apple.iTunes"];
        }
    }
    
    // Special video type handling
    /*
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
            case MZMovieVideoType:
                stikStr = @"Movie";
                break;
            case MZNormalVideoType:
                stikStr = @"Normal";
                break;
            case MZAudiobookVideoType:
                stikStr = @"Audiobook";
                break;
            case MZWhackedBookmarkVideoType:
                stikStr = @"Whacked Bookmark";
                break;
            case MZMusicVideoType:
                stikStr = @"Music Video";
                break;
            case MZShortFilmVideoType:
                stikStr = @"Short Film";
                break;
            case MZTVShowVideoType:
                stikStr = @"TV Show";
                break;
            case MZBookletVideoType:
                stikStr = @"Booklet";
                break;
        }
        if(stikStr)
        {
            [args addObject:@"--stik"];
            [args addObject:stikStr];
        }
    }
    */
    
    // Sort tags
    sortTags(args, changes, MZSortTitleTagIdent, @"name");
    sortTags(args, changes, MZSortArtistTagIdent, @"artist");
    sortTags(args, changes, MZSortAlbumArtistTagIdent, @"albumartist");
    sortTags(args, changes, MZSortAlbumTagIdent, @"album");
    sortTags(args, changes, MZSortTVShowTagIdent, @"show");
    sortTags(args, changes, MZSortComposerTagIdent, @"composer");
    
    // Special track number/count handling
    {
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
            [args addObject:@"--tracknum"];
            [args addObject:value];
        }
    }

    // Special disc number/count handling
    {
        MZTag* numberTag = [MZTag tagForIdentifier:MZDiscNumberTagIdent];
        MZTag* countTag = [MZTag tagForIdentifier:MZDiscCountTagIdent];
        id number = [changes objectForKey:[numberTag identifier]];
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
            [args addObject:@"--disk"];
            [args addObject:value];
        }
    }
    
    // Special image handling
    id pictureObj = [changes objectForKey:MZPictureTagIdent];
    NSString* pictureFile = nil;
    if(pictureObj == [NSNull null])
    {
        [args addObject:@"--artwork"];
        [args addObject:@"REMOVE_ALL"];
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
            [args addObject:@"--artwork"];
            [args addObject:@"REMOVE_ALL"];
            [args addObject:@"--artwork"];
            [args addObject:pictureFile];
        }
        else
        {
            MZLoggerError(@"Failed to write image to temp '%@' %@", pictureFile, [error localizedDescription]);
            pictureFile = nil;
        }
    }
    
    //Special handling for directors, producers, actors, screenwriters
    NSString* actors = [changes objectForKey:MZActorsTagIdent];
    NSString* directors = [changes objectForKey:MZDirectorTagIdent];
    NSString* producers = [changes objectForKey:MZProducerTagIdent];
    NSString* screenwriters = [changes objectForKey:MZScreenwriterTagIdent];
    if(actors || directors || producers || screenwriters)
    {
        if(!actors)
            actors = [data actors];
        if(!directors)
            directors = [data director];
        if(!producers)
            producers = [data producer];
        if(!screenwriters)
            screenwriters = [data screenwriter];
        if(actors == (NSString*)[NSNull null])
            actors = nil;
        if(directors == (NSString*)[NSNull null])
            directors = nil;
        if(producers == (NSString*)[NSNull null])
            producers = nil;
        if(screenwriters == (NSString*)[NSNull null])
            screenwriters = nil;

        [args addObject:@"--rDNSatom"];
        if(actors || directors || producers || screenwriters)
        {
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            if(actors)
            {
                NSArray* arr = [actors componentsSeparatedByString:@","];
                NSMutableArray* arr2 = [NSMutableArray array];
                for(NSString* actor in arr)
                {
                    NSString* trimmed = [actor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if([trimmed length] > 0) {
                        NSDictionary* nameDict = [NSDictionary dictionaryWithObject:trimmed forKey:@"name"];
                        [arr2 addObject:nameDict];
                    }
                }
                [dict setObject:arr2 forKey:@"cast"];
            }
            if(directors)
            {
                NSArray* arr = [directors componentsSeparatedByString:@","];
                NSMutableArray* arr2 = [NSMutableArray array];
                for(NSString* actor in arr)
                {
                    NSString* trimmed = [actor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if([trimmed length] > 0) {
                        NSDictionary* nameDict = [NSDictionary dictionaryWithObject:trimmed forKey:@"name"];
                        [arr2 addObject:nameDict];
                    }
                }
                [dict setObject:arr2 forKey:@"directors"];
            }
            if(producers)
            {
                NSArray* arr = [producers componentsSeparatedByString:@","];
                NSMutableArray* arr2 = [NSMutableArray array];
                for(NSString* actor in arr)
                {
                    NSString* trimmed = [actor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if([trimmed length] > 0) {
                        NSDictionary* nameDict = [NSDictionary dictionaryWithObject:trimmed forKey:@"name"];
                        [arr2 addObject:nameDict];
                    }
                }
                [dict setObject:arr2 forKey:@"producers"];
            }
            if(screenwriters)
            {
                NSArray* arr = [screenwriters componentsSeparatedByString:@","];
                NSMutableArray* arr2 = [NSMutableArray array];
                for(NSString* actor in arr)
                {
                    NSString* trimmed = [actor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if([trimmed length] > 0) {
                        NSDictionary* nameDict = [NSDictionary dictionaryWithObject:trimmed forKey:@"name"];
                        [arr2 addObject:nameDict];
                    }
                }
                [dict setObject:arr2 forKey:@"screenwriters"];
            }
            
            NSData* xmlData = [NSPropertyListSerialization dataFromPropertyList:dict
                                       format:NSPropertyListXMLFormat_v1_0
                                       errorDescription:NULL];
            NSString* movi = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
            [args addObject:movi];
        }
        else {
            [args addObject:@""];
        }
        [args addObject:@"name=iTunMOVI"];
        [args addObject:@"domain=com.apple.iTunes"];
    }
    
    NSString* fileName;
    if([args count]-3 == 0)
        fileName = [data loadedFileName];
    else
        fileName = [data savedTempFileName];
        
    MP4v2WriteOperationsController* ctrl = 
        [MP4v2WriteOperationsController controllerWithProvider:self
                                                   delegate:delegate
                                                      edits:data];

    MP4v2MainWriteTask* mainWrite = [MP4v2MainWriteTask taskWithController:ctrl pictureFile:pictureFile];
    [mainWrite setLaunchPath:[self launchPath]];
    [mainWrite setArguments:args];
    [ctrl addOperation:mainWrite];

    // Sometimes when writing to a network drive the file is left in a state
    // (I think it is a cache flush issue) so that a subsequent chapter write
    // breaks the file. I hope (have not encountered the issue in a long time)
    // that this extra chapter read at least detects the issue.
//    MP4v2ChapterReadDataTask* chapterRead = [MP4v2ChapterReadDataTask taskWithFileName:fileName dictionary:nil];
//    [chapterRead setLaunchPath:[self launchChapsPath]];
//    [chapterRead addDependency:mainWrite];
//    [ctrl addOperation:chapterRead];

    // Special chapters handling
    id chaptersObj = [changes objectForKey:MZChaptersTagIdent];
    NSString* chaptersFile = nil;
    if(chaptersObj == [NSNull null] || (chaptersObj && [chaptersObj count] == 0))
    {
        chaptersFile = @"";
    }
    else if(chaptersObj)
    {
        NSArray* chapters = chaptersObj;
        chaptersFile = [NSString temporaryPathWithFormat:@"MetaZChapters_%@.txt"];

        NSString* data = [[chapters arrayByPerformingSelector:@selector(description)]
            componentsJoinedByString:@"\n"];
                
        NSError* error = nil;
        if(![data writeToFile:chaptersFile atomically:NO encoding:NSUTF8StringEncoding error:&error])
        {
            MZLoggerError(@"Failed to write chapters to temp '%@' %@", chaptersFile, [error localizedDescription]);
            chaptersFile = nil;
        }
    }
    
    if(chaptersFile)
    {
        MP4v2ChapterWriteTask* chapterWrite = [MP4v2ChapterWriteTask
                taskWithFileName:fileName
                    chaptersFile:chaptersFile];
        [chapterWrite setLaunchPath:[self launchChapsPath]];
//        [chapterWrite addDependency:chapterRead];
        [ctrl addOperation:chapterWrite];
    }

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

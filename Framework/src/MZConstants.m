//
//  MZConstants.m
//  MetaZ
//
//  Created by Brian Olsen on 02/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import <MetaZKit/MZConstants.h>


// Info
NSString* const MZFileNameTagIdent = @"fileName";
NSString* const MZPictureTagIdent = @"picture";
NSString* const MZTitleTagIdent = @"title";
NSString* const MZArtistTagIdent = @"artist";
NSString* const MZDateTagIdent = @"date";
NSString* const MZRatingTagIdent = @"rating";
NSString* const MZGenreTagIdent = @"genre";
NSString* const MZAlbumTagIdent = @"album";
NSString* const MZAlbumArtistTagIdent = @"albumArtist";
NSString* const MZPurchaseDateTagIdent = @"purchaseDate";
NSString* const MZShortDescriptionTagIdent = @"shortDescription";
NSString* const MZLongDescriptionTagIdent = @"longDescription";

// Video
NSString* const MZVideoTypeTagIdent = @"videoType";
NSString* const MZActorsTagIdent = @"actors";
NSString* const MZDirectorTagIdent = @"director";
NSString* const MZCoDirectorTagIdent = @"codirector";
NSString* const MZProducerTagIdent = @"producer";
NSString* const MZScreenwriterTagIdent = @"screenwriter";
NSString* const MZStudioTagIdent = @"studio";
NSString* const MZTVShowTagIdent = @"tvShow";
NSString* const MZTVEpisodeIDTagIdent = @"tvEpisodeID";
NSString* const MZTVSeasonTagIdent = @"tvSeason";
NSString* const MZTVEpisodeTagIdent = @"tvEpisode";
NSString* const MZTVNetworkTagIdent = @"tvNetwork";


// Sort
NSString* const MZSortTitleTagIdent = @"sortTitle";
NSString* const MZSortArtistTagIdent = @"sortArtist";
NSString* const MZSortAlbumTagIdent = @"sortAlbum";
NSString* const MZSortAlbumArtistTagIdent = @"sortAlbumArtist";
NSString* const MZSortTVShowTagIdent = @"sortTvShow";
NSString* const MZSortComposerTagIdent = @"sortComposer";

// MetaX Advanced
NSString* const MZFeedURLTagIdent = @"feedURL";
NSString* const MZEpisodeURLTagIdent = @"episodeURL";
NSString* const MZCategoryTagIdent = @"category";
NSString* const MZKeywordTagIdent = @"keyword";
NSString* const MZAdvisoryTagIdent = @"advisory";
NSString* const MZPodcastTagIdent = @"podcast";
NSString* const MZCopyrightTagIdent = @"copyright";
NSString* const MZTrackNumberTagIdent = @"trackNo";
NSString* const MZTrackCountTagIdent = @"trackCount";
NSString* const MZDiscNumberTagIdent = @"discNo";
NSString* const MZDiscCountTagIdent = @"discCount";
NSString* const MZGroupingTagIdent = @"grouping";
NSString* const MZEncodingToolTagIdent = @"encodingTool";
NSString* const MZCommentTagIdent = @"comment";
NSString* const MZGaplessTagIdent = @"gapless";
NSString* const MZCompilationTagIdent = @"compilation";


NSString* const MZChaptersTagIdent = @"chapters";
NSString* const MZChapterNamesTagIdent = @"chapterNames";
NSString* const MZDurationTagIdent = @"duration";

NSString* const MZIMDBTagIdent = @"imdb";
NSString* const MZASINTagIdent = @"asin";
NSString* const MZDVDSeasonTagIdent = @"dvdSeason";
NSString* const MZDVDEpisodeTagIdent = @"dvdEpisode";

/* Notifications */
NSString* const MZDataProviderLoadedNotification = @"MZDataProviderLoadedNotification";
NSString* const MZDataProviderWritingStartedNotification = @"MZDataProviderWritingStartedNotification";
NSString* const MZDataProviderWritingCanceledNotification = @"MZDataProviderWritingCanceledNotification";
NSString* const MZDataProviderWritingFinishedNotification = @"MZDataProviderWritingFinishedNotification";
NSString* const MZSearchFinishedNotification = @"MZSearchFinishedNotification";
NSString* const MZUndoActionNameNotification = @"MZUndoActionNameNotification";
NSString* const MZMetaEditsDeallocating = @"MZMetaEditsDeallocating";

NSString* const MZMetaEditsNotificationKey = @"MZMetaEditsNotificationKey";
NSString* const MZUndoActionNameKey = @"MZUndoActionNameKey";
NSString* const MZDataControllerNotificationKey = @"MZDataControllerNotificationKey";
NSString* const MZDataControllerErrorKey = @"MZDataControllerErrorKey";

// Standard alert ids
NSString* const MZDataProviderFileAlreadyLoadedWarningKey = @"alerts.warnings.fileAlreadyLoaded";


void MZRelease(const void * ns)
{
    id obj = (id)ns;
    [obj release];
}

const void * MZRetain(const void * ns)
{
    id obj = (id)ns;
    return [obj retain];
}

CFStringRef MZCopyDescription(const void *ns)
{
    id obj = (id)ns;
    return (CFStringRef)[obj description];
}

@implementation MZConstants

+ (NSString *) movieGenreFromIndex: (NSInteger)index {
    if ((index >= 0 && index < 127) || index == 255) {
        genreType_t *genre = (genreType_t*) genreMovieType_strings;
        genre += index - 1;
        return genre->english_name;
    }
    else return nil;
}

+ (uint16_t) movieGenreIdFromIndex: (NSInteger)index {
    if ((index >= 0 && index < 127) || index == 255) {
        genreType_t *genre = (genreType_t*) genreMovieType_strings;
        genre += index - 1;
        return genre->id;
    }
    else return 0;
}

+ (NSInteger) movieGenreIndexFromString: (NSString *)genreString {
    NSInteger genreIndex = 0;
    genreType_t *genreList;
    NSInteger k = 0;
    for ( genreList = (genreType_t*) genreMovieType_strings; genreList->english_name; genreList++, k++ ) {
        if ([genreString isEqualToString:genreList->english_name]) {
            genreIndex = k + 1;
            break;
        }
    }
    return genreIndex;
}

+ (uint16_t) movieGenreIdFromString: (NSString *)genreString {
    genreType_t *genreList;
    for ( genreList = (genreType_t*) genreMovieType_strings; genreList->english_name; genreList++) {
        if ([genreString isEqualToString:genreList->english_name]) {
            return genreList->id;
        }
    }
    return 0;
}

+ (NSString *) tvGenreFromIndex: (NSInteger)index {
    if ((index >= 0 && index < 127) || index == 255) {
        genreType_t *genre = (genreType_t*) genreTvType_strings;
        genre += index - 1;
        return genre->english_name;
    }
    else return nil;
}

+ (uint16_t) tvGenreIdFromIndex: (NSInteger)index {
    if ((index >= 0 && index < 127) || index == 255) {
        genreType_t *genre = (genreType_t*) genreTvType_strings;
        genre += index - 1;
        return genre->id;
    }
    else return 0;
}

+ (NSInteger) tvGenreIndexFromString: (NSString *)genreString {
    NSInteger genreIndex = 0;
    genreType_t *genreList;
    NSInteger k = 0;
    for ( genreList = (genreType_t*) genreTvType_strings; genreList->english_name; genreList++, k++ ) {
        if ([genreString isEqualToString:genreList->english_name])
            genreIndex = k + 1;
    }
    return genreIndex;
}

+ (uint16_t) tvGenreIdFromString: (NSString *)genreString {
    genreType_t *genreList;
    for ( genreList = (genreType_t*) genreTvType_strings; genreList->english_name; genreList++) {
        if ([genreString isEqualToString:genreList->english_name]) {
            return genreList->id;
        }
    }
    return 0;
}

+ (NSString *) ratingFromIndex: (NSInteger)index {
    iTMF_rating_t *rating = (iTMF_rating_t*) rating_strings;
    rating += index;
    return rating->english_name;    
}

+ (NSString *) ratingDescriptionFromIndex: (NSInteger)index {
    if (index >= 0 && index < 71) {
        iTMF_rating_t *rating = (iTMF_rating_t*) rating_strings;
        rating += index;
        return rating->rating;    
    }
    else return nil;
}

+ (NSInteger) ratingIndexFromString: (NSString *)ratingString{
    NSInteger ratingIndex = 0;
    iTMF_rating_t *ratingList;
    NSInteger k = 0;
    for ( ratingList = (iTMF_rating_t*) rating_strings; ratingList->english_name; ratingList++, k++ ) {
        if ([ratingString isEqualToString:ratingList->english_name]) {
            ratingIndex = k;
            break;
        }
    }
    return ratingIndex;
}

+ (NSInteger) ratingDescriptionIndexFromString: (NSString *)ratingString{
    NSInteger ratingIndex = 0;
    iTMF_rating_t *ratingList;
    NSInteger k = 0;
    for ( ratingList = (iTMF_rating_t*) rating_strings; ratingList->rating; ratingList++, k++ ) {
        if ([ratingString isEqualToString:ratingList->rating]) {
            ratingIndex = k;
            break;
        }
    }
    return ratingIndex;
}

+ (NSArray *) availableRatings
{
    NSMutableArray *ratingsArray = [[NSMutableArray alloc] init];
    iTMF_rating_t *rating;
    for ( rating = (iTMF_rating_t*) rating_strings; rating->english_name; rating++ )
        [ratingsArray addObject:rating->english_name];
    
    return [ratingsArray autorelease];
}

+ (NSArray *) availableMovieGenres
{
    NSMutableArray *genres = [[NSMutableArray alloc] init];
    genreType_t *genre;
    for ( genre = (genreType_t*) genreMovieType_strings; genre->english_name; genre++ )
        [genres addObject:genre->english_name];
    
    return [genres autorelease];
}

+ (NSArray *) availableTvGenres
{
    NSMutableArray *genres = [[NSMutableArray alloc] init];
    genreType_t *genre;
    for ( genre = (genreType_t*) genreTvType_strings; genre->english_name; genre++ )
        [genres addObject:genre->english_name];
    
    return [genres autorelease];
}
@end

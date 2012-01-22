
#ifdef __cplusplus
#define MZKIT_EXTERN		extern "C"
#else
#define MZKIT_EXTERN		extern
#endif

typedef struct iTMF_rating_t
{
    NSString* rating;
    NSString* english_name;
    
} iTMF_rating_t;

typedef struct mediaKind_t
{
    uint8_t stik;
    NSString *english_name;
    
} mediaKind_t;

typedef struct contentRating_t
{
    uint8_t rtng;
    NSString *english_name;
    
} contentRating_t;

typedef struct genreType_t
{
    uint16_t id;
    NSString *english_name;
    
} genreType_t;

static const genreType_t genreMovieType_strings[] = {
	{ 4401, @"Action & Adventure" },
	{ 4402, @"Anime" },
	{ 4403, @"Classics" },
	{ 4404, @"Comedy" },
	{ 4405, @"Documentary" },
	{ 4406, @"Drama" },
	{ 4407, @"Foreign" },
	{ 4408, @"Horror" },
	{ 4409, @"Independent" },
	{ 4410, @"Kids & Family" },
	{ 4411, @"Musicals" },
	{ 4412, @"Romance" },
	{ 4413, @"Sci-Fi & Fantasy" },
	{ 4414, @"Short Films" },
	{ 4415, @"Special Interest" },
	{ 4416, @"Thriller" },
	{ 4417, @"Sports" },
	{ 4418, @"Western" },
	{ 4419, @"Urban" },
	{ 4420, @"Holiday" },
	{ 4421, @"Made for TV" },
	{ 4422, @"Concert Films" },
	{ 4423, @"Music Documentaries" },
	{ 4424, @"Music Feature Films" },
	{ 4425, @"Japanese Cinema" },
	{ 4426, @"Jidaigeki" },
	{ 4427, @"Tokusatsu" },
	{ 4428, @"Korean Cinema" },
    
    {0, @"undefined" } // must be last 
}; 

static const genreType_t genreTvType_strings[] = {
	{ 4000, @"Comedy" },
	{ 4001, @"Drama" },
	{ 4002, @"Animation" },
	{ 4003, @"Action & Adventure" },
	{ 4003, @"Action & Adventure" },
	{ 4004, @"Classic" },
	{ 4005, @"Kids" },
	{ 4005, @"Nonfiction" },
	{ 4007, @"Reality TV" },
	{ 4008, @"Sci-Fi & Fantasy" },
	{ 4009, @"Sports" },
	{ 4010, @"Teens" },
	{ 4011, @"Latino TV" },
    
    {0, @"undefined" } // must be last      
}; 

static const contentRating_t contentRating_strings[] = {
    {0, @"None"},
    {2, @"Clean"},
    {4, @"Explicit"},
    {0, NULL},
}; 

static const mediaKind_t mediaKind_strings[] = {
    {1, @"Music"},
    {2, @"Audiobook"},
    {6, @"Music Video"},
    {9, @"Movie"},
    {10, @"TV Show"},
    {11, @"Booklet"},
    {14, @"Ringtone"},  
    {0, NULL},
};  

static const iTMF_rating_t rating_strings[] = {
    {@"--", @"-- United States"},
    {@"mpaa|NR|000|", @"Not Rated"},          // 1
    {@"mpaa|G|100|", @"G"},
    {@"mpaa|PG|200|", @"PG"},
    {@"mpaa|PG-13|300|", @"PG-13"},
    {@"mpaa|R|400|", @"R" },
    {@"mpaa|NC-17|500|", @"NC-17"},
    {@"mpaa|Unrated|???|", @"Unrated"},
    {@"--", @""},
    {@"us-tv|TV-Y|100|", @"TV-Y"},            // 9
    {@"us-tv|TV-Y7|200|", @"TV-Y7"},
    {@"us-tv|TV-G|300|", @"TV-G"},
    {@"us-tv|TV-PG|400|", @"TV-PG"},
    {@"us-tv|TV-14|500|", @"TV-14"},
    {@"us-tv|TV-MA|600|", @"TV-MA"},
    {@"us-tv|Unrated|???|", @"Unrated"},
    {@"--", @"-- United Kingdom"},
    {@"uk-movie|NR|000|", @"Not Rated"},      // 17
    {@"uk-movie|U|100|", @"U"},
    {@"uk-movie|Uc|150|", @"Uc"},
    {@"uk-movie|PG|200|", @"PG"},
    {@"uk-movie|12|300|", @"12"},
    {@"uk-movie|12A|325|", @"12A"},
    {@"uk-movie|15|350|", @"15"},
    {@"uk-movie|18|400|", @"18"},
    {@"uk-movie|R18|600|", @"R18"},
    {@"uk-movie|E|0|", @"Exempt" },
    {@"uk-movie|Unrated|???|", @"Unrated"},
    {@"--", @""},
    {@"uk-tv|Caution|500|", @"Caution"},      // 29
    {@"--", @"-- Germany"},
    {@"de-movie|ab 0 Jahren|75|", @"ab 0 Jahren"},		// 31
    {@"de-movie|ab 6 Jahren|100|", @"ab 6 Jahren"},
    {@"de-movie|ab 12 Jahren|200|", @"ab 12 Jahren"},
    {@"de-movie|ab 16 Jahren|500|", @"ab 16 Jahren"},
    {@"de-movie|ab 18 Jahren|600|", @"ab 18 Jahren"},
    {@"--", @""},
    {@"de-tv|ab 0 Jahren|75|", @"ab 0 Jahren"},		// 37
    {@"de-tv|ab 6 Jahren|100|", @"ab 6 Jahren"},
    {@"de-tv|ab 12 Jahren|200|", @"ab 12 Jahren"},
    {@"de-tv|ab 16 Jahren|500|", @"ab 16 Jahren"},
    {@"de-tv|ab 18 Jahren|600|", @"ab 18 Jahren"},
    {@"--", @"-- Australia"},
    {@"au-movie|G|100|", @"G"},               // 43
    {@"au-movie|PG|200|", @"PG"},
    {@"au-movie|M|350|", @"M"},
    {@"au-movie|MA15+|375|", @"MA 15+"},
    {@"au-movie|R18+|400|", @"R18+"},
    {@"--", @""},
    {@"au-tv|P|100|", @"P"},                  // 49
    {@"au-tv|C|200|", @"C"},
    {@"au-tv|G|300|", @"G"},
    {@"au-tv|PG|400|", @"PG"},
    {@"au-tv|M|500|", @"M"},
    {@"au-tv|MA15+|550|", @"MA 15+"},
    {@"au-tv|AV15+|575|", @"AV 15+"},
    {@"au-tv|R18+|600|", @"R18+"},
    {@"--", @"-- France"},
    {@"fr-movie|Tout Public|100|", @"Tout Public"},     // 58
    {@"fr-movie|-10|100|", @"-10"},
    {@"fr-movie|-12|300|", @"-12"},
    {@"fr-movie|-16|375|", @"-16"},
    {@"fr-movie|-18|400|", @"-18"},
    {@"fr-movie|Unrated|???|", @"Unrated"},
    {@"--", @""},
    {@"fr-tv|-10|100|", @"-10"},              // 65
    {@"fr-tv|-12|200|", @"-12"},
    {@"fr-tv|-16|500|", @"-16"},
    {@"fr-tv|-18|600|", @"-18"},
    {@"--", @""},
    {@"--", @"Unknown"},                      // 70
    {NULL, NULL},
};

typedef enum
{
    MZUnsetVideoType = -1,
    MZMusicType = 1,
    MZAudiobookVideoType = 2,
    MZMusicVideoType = 6,
    MZMovieVideoType = 9,
    MZTVShowVideoType = 10,
    MZBookletVideoType = 11,
    MZRingtoneVideoType = 14
    
} MZVideoType;

typedef enum 
{
    CR_NONE = 0,
    CR_CLEAN = 2,
    CR_EXPLICIT = 4
    
} MZContentRating;

typedef enum
{
    TV_COMEDY = 4000,
    TV_DRAMA = 4001,
    TV_ANIMATION = 4002,
    TV_ACTION_ADVENTURE = 4003,
    TV_CLASSIC = 4004,
    TV_KIDS = 4005,
    TV_NONFICTION = 4006,
    TV_REALITY = 4007,
    TV_SCI_FI_FANTASY = 4008,
    TV_SPORTS = 4009,
    TV_TEENS = 4010,
    TV_LATINO = 4011
    
} MZTvGenreType;

typedef enum
{
    FILM_ACTION_ADVENTURE = 4401,
    FILM_ANIME = 4402,
    FILM_CLASSICS = 4403,
    FILM_COMEDY = 4404,
    FILM_DOCUMENTARY = 4405,
    FILM_DRAMA = 4406,
    FILM_FOREIGN = 4407,
    FILM_HORROR = 4408,
    FILM_INDEPENDENT = 4409,
    FILM_KIDS_FAMILY = 4410,
    FILM_MUSICALS = 4411,
    FILM_ROMANCE = 4412,
    FILM_SCI_FI_FANTASY = 4413,
    FILM_SHORT_FILMS = 4414,
    FILM_SPECIAL_INTEREST = 4415,
    FILM_THRILLER = 4416,
    FILM_SPORTS = 4417,
    FILM_WESTERN = 4418,
    FILM_URBAN = 4419,
    FILM_HOLIDAY = 4420,
    FILM_MADE_FOR_TV = 4421,
    FILM_CONCERT_FILMS = 4422,
    FILM_MUSIC_DOCUMENTARIES = 4423,
    FILM_MUSIC_FEATURE_FILMS = 4424,
    FILM_JAPANESE_CINEMA = 4425,
    FILM_JIDAIGEKI = 4426,
    FILM_TOKUSATSU = 4427,
    FILM_KOREAN_CINEMA = 4428
    
} MZMovieGenreType;

typedef enum
{
    MZNoRating = 0,

    //US
    MZ_G_Rating,
    MZ_PG_Rating,
    MZ_PG13_Rating,
    MZ_R_Rating,
    MZ_NC17_Rating,
    MZ_Unrated_Rating,
    
    //US-TV
    MZ_TVY_Rating,
    MZ_TVY7_Rating,
    MZ_TVG_Rating,
    MZ_TVPG_Rating,
    MZ_TV14_Rating,
    MZ_TVMA_Rating,
    
    // UK
    MZ_U_Rating,
    MZ_Uc_Rating,
    MZ_PG_UK_Rating,
    MZ_12_UK_Rating,
    MZ_12A_Rating,
    MZ_15_UK_Rating,
    MZ_18_UK_Rating,
    MZ_E_UK_Rating,
    MZ_Unrated_UK_Rating,

    // DE
    MZ_FSK0_Rating,
    MZ_FSK6_Rating,
    MZ_FSK12_Rating,
    MZ_FSK16_Rating,
    MZ_FSK18_Rating,
    
    // IE
    MZ_G_IE_Rating,
    MZ_PG_IE_Rating,
    MZ_12_IE_Rating,
    MZ_15_IE_Rating,
    MZ_16_Rating,
    MZ_18_IE_Rating,
    MZ_Unrated_IE_Rating,
    
    // IE-TV
    MZ_GA_Rating,
    MZ_Ch_Rating,
    MZ_YA_Rating,
    MZ_PS_Rating,
    MZ_MA_IETV_Rating,
    MZ_Unrated_IETV_Rating,
    
    // CA
    MZ_G_CA_Rating,
    MZ_PG_CA_Rating,
    MZ_14_Rating,
    MZ_18_CA_Rating,
    MZ_R_CA_Rating,
    MZ_E_CA_Rating,
    MZ_Unrated_CA_Rating,
    
    // CA-TV
    MZ_C_CATV_Rating,
    MZ_C8_Rating,
    MZ_G_CATV_Rating,
    MZ_PG_CATV_Rating,
    MZ_14Plus_Rating,
    MZ_18Plus_Rating,
    MZ_Unrated_CATV_Rating,
    
    // AU
    MZ_E_AU_Rating,
    MZ_G_AU_Rating,
    MZ_PG_AU_Rating,
    MZ_M_AU_Rating,
    MZ_MA15Plus_AU_Rating,
    MZ_R18Plus_Rating,
    MZ_Unrated_AU_Rating,
    
    // AU-TV
    MZ_P_Rating,
    MZ_C_AUTV_Rating,
    MZ_G_AUTV_Rating,
    MZ_PG_AUTV_Rating,
    MZ_M_AUTV_Rating,
    MZ_MA15Plus_AUTV_Rating,
    MZ_AV15Plus_Rating,
    MZ_Unrated_AUTV_Rating,
    
    // NZ
    MZ_E_NZ_Rating,
    MZ_G_NZ_Rating,
    MZ_PG_NZ_Rating,
    MZ_M_NZ_Rating,
    MZ_R13_Rating,
    MZ_R15_Rating,
    MZ_R16_Rating,
    MZ_R18_Rating,
    MZ_R_NZ_Rating,
    MZ_Unrated_NZ_Rating,
    
    // NZ-TV
    MZ_G_NZTV_Rating,
    MZ_PGR_Rating,
    MZ_AO_Rating,
    MZ_Unrated_NZTV_Rating,
} MZRating;

// Info
MZKIT_EXTERN NSString* const MZFileNameTagIdent;
MZKIT_EXTERN NSString* const MZPictureTagIdent;
MZKIT_EXTERN NSString* const MZTitleTagIdent;
MZKIT_EXTERN NSString* const MZArtistTagIdent;
MZKIT_EXTERN NSString* const MZDateTagIdent;
MZKIT_EXTERN NSString* const MZRatingTagIdent;
MZKIT_EXTERN NSString* const MZGenreTagIdent;
MZKIT_EXTERN NSString* const MZAlbumTagIdent;
MZKIT_EXTERN NSString* const MZAlbumArtistTagIdent;
MZKIT_EXTERN NSString* const MZPurchaseDateTagIdent;
MZKIT_EXTERN NSString* const MZShortDescriptionTagIdent;
MZKIT_EXTERN NSString* const MZLongDescriptionTagIdent;

// Video
MZKIT_EXTERN NSString* const MZVideoTypeTagIdent;
MZKIT_EXTERN NSString* const MZActorsTagIdent;
MZKIT_EXTERN NSString* const MZDirectorTagIdent;
MZKIT_EXTERN NSString* const MZCoDirectorTagIdent;
MZKIT_EXTERN NSString* const MZProducerTagIdent;
MZKIT_EXTERN NSString* const MZScreenwriterTagIdent;
MZKIT_EXTERN NSString* const MZStudioTagIdent;
MZKIT_EXTERN NSString* const MZTVShowTagIdent;
MZKIT_EXTERN NSString* const MZTVEpisodeIDTagIdent;
MZKIT_EXTERN NSString* const MZTVSeasonTagIdent;
MZKIT_EXTERN NSString* const MZTVEpisodeTagIdent;
MZKIT_EXTERN NSString* const MZTVNetworkTagIdent;


// Sort
MZKIT_EXTERN NSString* const MZSortTitleTagIdent;
MZKIT_EXTERN NSString* const MZSortArtistTagIdent;
MZKIT_EXTERN NSString* const MZSortAlbumTagIdent;
MZKIT_EXTERN NSString* const MZSortAlbumArtistTagIdent;
MZKIT_EXTERN NSString* const MZSortTVShowTagIdent;
MZKIT_EXTERN NSString* const MZSortComposerTagIdent;

// MetaX Advanced
MZKIT_EXTERN NSString* const MZFeedURLTagIdent;
MZKIT_EXTERN NSString* const MZEpisodeURLTagIdent;
MZKIT_EXTERN NSString* const MZCategoryTagIdent;
MZKIT_EXTERN NSString* const MZKeywordTagIdent;
MZKIT_EXTERN NSString* const MZAdvisoryTagIdent;
MZKIT_EXTERN NSString* const MZPodcastTagIdent;
MZKIT_EXTERN NSString* const MZCopyrightTagIdent;
MZKIT_EXTERN NSString* const MZTrackNumberTagIdent;
MZKIT_EXTERN NSString* const MZTrackCountTagIdent;
MZKIT_EXTERN NSString* const MZDiscNumberTagIdent;
MZKIT_EXTERN NSString* const MZDiscCountTagIdent;
MZKIT_EXTERN NSString* const MZGroupingTagIdent;
MZKIT_EXTERN NSString* const MZEncodingToolTagIdent;
MZKIT_EXTERN NSString* const MZCommentTagIdent;
MZKIT_EXTERN NSString* const MZGaplessTagIdent;
MZKIT_EXTERN NSString* const MZCompilationTagIdent;


MZKIT_EXTERN NSString* const MZChaptersTagIdent;
MZKIT_EXTERN NSString* const MZChapterNamesTagIdent;
MZKIT_EXTERN NSString* const MZDurationTagIdent;

MZKIT_EXTERN NSString* const MZIMDBTagIdent;
MZKIT_EXTERN NSString* const MZASINTagIdent;
MZKIT_EXTERN NSString* const MZDVDSeasonTagIdent;
MZKIT_EXTERN NSString* const MZDVDEpisodeTagIdent;

/* Notifications */
MZKIT_EXTERN NSString* const MZDataProviderLoadedNotification;
MZKIT_EXTERN NSString* const MZDataProviderWritingStartedNotification;
MZKIT_EXTERN NSString* const MZDataProviderWritingCanceledNotification;
MZKIT_EXTERN NSString* const MZDataProviderWritingFinishedNotification;
MZKIT_EXTERN NSString* const MZSearchFinishedNotification;
MZKIT_EXTERN NSString* const MZUndoActionNameNotification;
MZKIT_EXTERN NSString* const MZMetaEditsDeallocating;

MZKIT_EXTERN NSString* const MZMetaEditsNotificationKey;
MZKIT_EXTERN NSString* const MZUndoActionNameKey;
MZKIT_EXTERN NSString* const MZDataControllerNotificationKey;
MZKIT_EXTERN NSString* const MZDataControllerErrorKey;

// Standard alert ids
MZKIT_EXTERN NSString* const MZDataProviderFileAlreadyLoadedWarningKey;


void MZRelease(const void * ns);
const void * MZRetain(const void * ns);
CFStringRef MZCopyDescription(const void *ns);



@interface MZConstants {
}
+ (uint16_t) movieGenreIdFromString: (NSString *)genreString;
+ (uint16_t) movieGenreIdFromIndex: (NSInteger)index;
+ (NSString *) movieGenreFromIndex: (NSInteger)index;
+ (NSInteger) movieGenreIndexFromString: (NSString *)genreString;
+ (NSString *) movieGenreFromId: (uint16_t)id;

+ (uint16_t) tvGenreIdFromString: (NSString *)genreString;
+ (uint16_t) tvGenreIdFromIndex: (NSInteger)index;
+ (NSString *) tvGenreFromIndex: (NSInteger)index;
+ (NSInteger) tvGenreIndexFromString: (NSString *)genreString;
+ (NSString *) tvGenreFromId: (uint16_t)id;

+ (NSString *) ratingFromIndex: (NSInteger)index;
+ (NSString *) ratingDescriptionFromIndex: (NSInteger)index;
+ (NSInteger) ratingIndexFromString: (NSString *)ratingString;
+ (NSInteger) ratingDescriptionIndexFromString: (NSString *)ratingString;
+ (NSArray *) availableRatings;
+ (NSArray *) availableTvGenres;
+ (NSArray *) availableMovieGenres;

@end
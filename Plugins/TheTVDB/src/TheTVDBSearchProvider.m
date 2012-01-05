//
//  TheTVDBSearchProvider.m
//  MetaZ
//
//  Created by Nigel Graham on 09/04/10.
//  Copyright 2010 Maven-Group. All rights reserved.
//

#import "TheTVDBSearchProvider.h"
#import "TheTVDBPlugin.h"

@implementation TheTVDBSearchProvider

- (void)dealloc
{
    [icon release];
    [supportedSearchTags release];
    [menu release];
    [super dealloc];
}

- (NSImage *)icon
{
    if(!icon)
    {
        icon = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://thetvdb.com/favicon.ico"]];
    }
    return icon;
}

- (NSString *)identifier
{
    return @"org.maven-group.MetaZ.TheTVDBPlugin";
}

- (NSArray *)supportedSearchTags
{
    if(!supportedSearchTags)
    {
        NSMutableArray* ret = [NSMutableArray array];
        [ret addObject:[MZTag tagForIdentifier:MZTitleTagIdent]];
        [ret addObject:[MZTag tagForIdentifier:MZVideoTypeTagIdent]];
        [ret addObject:[MZTag tagForIdentifier:MZTVShowTagIdent]];
        [ret addObject:[MZTag tagForIdentifier:MZTVSeasonTagIdent]];
        supportedSearchTags = [[NSArray alloc] initWithArray:ret];
    }
    return supportedSearchTags;
}

- (NSMenu *)menuForResult:(MZSearchResult *)result
{
    if(!menu)
    {
        menu = [[NSMenu alloc] initWithTitle:@"TheTVDB"];
        NSMenuItem* item = [menu addItemWithTitle:@"View episode in Browser" action:@selector(view:) keyEquivalent:@""];
        [item setTarget:self];
        item = [menu addItemWithTitle:@"View season in Browser" action:@selector(viewSeason:) keyEquivalent:@""];
        [item setTarget:self];
        item = [menu addItemWithTitle:@"View series in Browser" action:@selector(viewSeries:) keyEquivalent:@""];
        [item setTarget:self];
    }
    for(NSMenuItem* item in [menu itemArray])
        [item setRepresentedObject:result];
    return menu;
}

/*
- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem
{
    SEL action = [anItem action];
    if(action == @selector(imdb:))
    {
        return 
    }
    return action == @selector(view:);
}
*/

- (void)view:(id)sender
{
    MZSearchResult* result = [sender representedObject];
    NSNumber* series = [result valueForKey:TVDBSeriesIdTagIdent];
    NSString* season = [result valueForKey:TVDBSeasonIdTagIdent];
    NSString* episode = [result valueForKey:TVDBEpisodeIdTagIdent];
    
    NSString* str = [[NSString stringWithFormat:
        @"http://thetvdb.com/?tab=episode&seriesid=%d&seasonid=%@&id=%@",
        [series unsignedIntValue], season, episode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:str];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)viewSeason:(id)sender
{
    MZSearchResult* result = [sender representedObject];
    NSNumber* series = [result valueForKey:TVDBSeriesIdTagIdent];
    NSString* season = [result valueForKey:TVDBSeasonIdTagIdent];
    
    NSString* str = [[NSString stringWithFormat:
        @"http://thetvdb.com/?tab=season&seriesid=%d&seasonid=%@",
        [series unsignedIntValue], season] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:str];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)viewSeries:(id)sender
{
    MZSearchResult* result = [sender representedObject];
    NSNumber* series = [result valueForKey:TVDBSeriesIdTagIdent];
    
    NSString* str = [[NSString stringWithFormat:
        @"http://thetvdb.com/?tab=series&id=%d",
        [series unsignedIntValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:str];
    [[NSWorkspace sharedWorkspace] openURL:url];
}


- (BOOL)searchWithData:(NSDictionary *)data
              delegate:(id<MZSearchProviderDelegate>)delegate
                 queue:(NSOperationQueue *)queue;
{
    [self cancelSearch];

    NSNumber* videoKindObj = [data objectForKey:MZVideoTypeTagIdent];
    NSString* show = [data objectForKey:MZTVShowTagIdent];
    NSNumber* seasonNo = [data objectForKey:MZTVSeasonTagIdent];
    NSNumber* episodeNo = [data objectForKey:MZTVEpisodeTagIdent];
    if(!([videoKindObj intValue] == MZTVShowVideoType && show && seasonNo))
    {
        return NO;
    }
    
    NSUInteger season = [seasonNo integerValue];
    NSInteger episode = -1;
    if(episodeNo)
        episode = [episodeNo integerValue];
    
    TheTVDBSearch* search = [TheTVDBSearch searchWithProvider:self delegate:delegate queue:queue];
    
    /*
    TheTVDBUpdateMirrors* mirrors = [[TheTVDBUpdateMirrors alloc] init];
    [search addOperation:mirrors];
    [mirrors release];
    */
    
    TheTVDBGetSeries* seriesSearch = [[TheTVDBGetSeries alloc] initWithSearch:search name:show season:season episode:episode];
    //[seriesSearch addDependency:mirrors];
    [search addOperation:seriesSearch];
    [seriesSearch release];
    
    [self startSearch:search];
    MZLoggerDebug(@"Sent request to TheTVDB");
    [search addOperationsToQueue:queue];
    return YES;
}

@end

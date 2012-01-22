//
//  GenreDataSource.m
//  MetaZ
//
//  Created by Brian Olsen on 09/10/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import "GenreDataSource.h"

@implementation GenreDataSource

- (id)init
{
    self = [super init];
    if(self) {
        // TODO: Check video kind and use appropriate genre list
        genres = [[NSUserDefaults standardUserDefaults] arrayForKey:@"genres_movie"];
        if(!genres)
            genres = [NSArray array];
        
        NSSet* set = [NSSet setWithArray:genres];
        NSArray *availableGenres = [MZConstants availableMovieGenres];
        for (NSString* genre in availableGenres) {
            set = [set setByAddingObject:genre];
        }
        
        genres = [set allObjects];
        genres = [[genres sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] retain];
        [[NSUserDefaults standardUserDefaults] setObject:genres forKey:@"genres_movie"];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"genres_movie" options:0 context:NULL];
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(dataWritingStarted:)
                   name:MZDataProviderWritingStartedNotification
                 object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [genres release];
    [super dealloc];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return [genres count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    return [genres objectAtIndex:index];
}

- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)aString
{
    return [genres indexOfObject:aString];
}

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)uncompletedString
{
    uncompletedString = [uncompletedString lowercaseString];
    for(NSString* genre in genres)
    {
        NSString* cmp = [genre lowercaseString];
        if([cmp hasPrefix:uncompletedString] || [cmp isEqual:uncompletedString])
            return genre;
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqual:@"genres_movie"] && object == [NSUserDefaults standardUserDefaults])
    {
        NSSet* set = [NSSet setWithArray:genres];
        NSArray* newGenres = [set allObjects];
        newGenres = [newGenres sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [self willChangeValueForKey:@"genres_movie"];
        genres = [newGenres retain];
        [self didChangeValueForKey:@"genres_movie"];
    }
}


- (void)dataWritingStarted:(NSNotification *)note
{
    MetaEdits* edits = [[note userInfo] objectForKey:MZMetaEditsNotificationKey];
    NSString* genre = [edits genre];
    if(genre)
    {
        NSSet* set = [NSSet setWithArray:genres];
        set = [set setByAddingObject:genre];
        NSArray* newGenres = [set allObjects];
        newGenres = [newGenres sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [self willChangeValueForKey:@"genres_movie"];
        genres = [newGenres retain];
        [[NSUserDefaults standardUserDefaults] setObject:genres forKey:@"genres_movie"];
        [self didChangeValueForKey:@"genres_movie"];
    }
}

@end

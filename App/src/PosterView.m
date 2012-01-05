//
//  PosterView.m
//  MetaZ
//
//  Created by Brian Olsen on 25/09/09.
//  Copyright 2009 Maven-Group. All rights reserved.
//

#import "PosterView.h"
#import "Utilities.h"
#import "Resources.h"

@implementation PosterView

@synthesize retryButton;
@synthesize indicator;
@synthesize leftButton;
@synthesize rightButton;

- (void)dealloc
{
    [retryButton release];
    [indicator release];
    [error release];
    [super dealloc];
}

- (void)awakeFromNib
{
    //dumpMethods([self superclass]);
    actionHack = [self action];
    [self setAction:NULL];
}

- (void)setStatus:(PosterImageStatus)newStatus
{
    [self willChangeValueForKey:@"imageSize"];
    status = newStatus;
    if(status != MZErrorPosterImage)
    {
        [error release];
        error = nil;
    }
    if(status != MZOKPosterImage)
        [self setObjectValue:nil];
    [self didChangeValueForKey:@"imageSize"];
}

- (NSString *)statusImage
{
    switch (status) {
        case MZErrorPosterImage:
            return MZFadedIconError;
        case MZFatalErrorPosterImage:
            return MZFadedIconFatalError;
        case MZMultiplePosterImage:
        case MZNotApplicablePosterImage:
            return MZFadedIconMultiple;
    }
    return MZFadedIcon;
}

- (void)reportError:(NSError *)theError
{
    [self willChangeValueForKey:@"imageSize"];
    status = MZErrorPosterImage;
    [error release];
    error = [theError retain];
    MZLoggerError(@"Poster error: %d %@", [error code], [error domain]);
    MZLoggerError(@"    Description - %@", [error localizedDescription]);
    MZLoggerError(@"    Reason - %@", [error localizedFailureReason]);
    MZLoggerError(@"    Suggestion - %@", [error localizedRecoverySuggestion]);
    if([error localizedRecoveryOptions])
    {
        for(NSString* str in [error localizedRecoveryOptions])
            MZLoggerError(@"        %@", str);
    }
    [self didChangeValueForKey:@"imageSize"];
}

- (void)setObjectValue:(id < NSCopying >)object
{
    [self willChangeValueForKey:@"imageSize"];
    [super setObjectValue:object];
    [self didChangeValueForKey:@"imageSize"];
    if(!object)
        [self setImage:[NSImage imageNamed:[self statusImage]]];
}

- (NSImage *)objectValue
{
    NSImage* ret = [super objectValue];
    if(ret == [NSImage imageNamed:MZFadedIcon] ||
        ret == [NSImage imageNamed:MZFadedIconError] ||
        ret == [NSImage imageNamed:MZFadedIconFatalError] ||
        ret == [NSImage imageNamed:MZFadedIconMultiple])
    {
        return nil;
    }
    return ret;
}

- (void)setImage:(NSImage*)image
{
    [self willChangeValueForKey:@"imageSize"];
    if(!image)
        image = [NSImage imageNamed:[self statusImage]];
    [super setImage:image];
    [self didChangeValueForKey:@"imageSize"];
}

- (NSString*)imageSize
{
    if(error)
        return [error localizedDescription];
    switch (status) {
        case MZMultiplePosterImage:
            return NSLocalizedString(@"Editing Multiple", @"Text for size text field when editing multiple");
        case MZNotApplicablePosterImage:
            return NSLocalizedString(@"Not Applicable", @"Text for size text field when picture not applicable");
    }
    NSSize size = [[self objectValue] size];
    if(NSEqualSizes(size, NSZeroSize))
        return NSLocalizedString(@"No Image", @"Text for size text field when no image is present");
    return [NSString stringWithFormat:@"%.0fx%.0f", size.width, size.height];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    //MZLoggerDebug(@"Test Down %d %d", [theEvent clickCount], [self ignoresMultiClick]);
    if([theEvent clickCount] == 2 && [self isEnabled])
        [NSApp sendAction:actionHack to:[self target] from:self];
    [super mouseDown:theEvent];
}

/*
- (void)mouseUp:(NSEvent *)theEvent
{
    MZLoggerDebug(@"Test Up %d %d", [theEvent clickCount], [self ignoresMultiClick]);
    [super mouseUp:theEvent];
}
*/

- (void)moveLeft:(id)sender
{
    if([leftButton isHidden])
        NSBeep();
    else
        [leftButton performClick:self];
}

- (void)moveRight:(id)sender
{
    if([rightButton isHidden])
        NSBeep();
    else
        [rightButton performClick:self];
}

- (void)keyDown:(NSEvent *)theEvent
{
    NSString* ns = [theEvent charactersIgnoringModifiers];
    if([ns length] == 1)
    {
        unichar ch = [ns characterAtIndex:0];
        switch(ch) {
            case NSNewlineCharacter:
            case NSCarriageReturnCharacter:
            case NSEnterCharacter:
                if([retryButton isHidden] && [indicator isHidden])
                {
                    [NSApp sendAction:actionHack to:[self target] from:self];
                    return;
                }
                else if(![retryButton isHidden])
                {
                    [retryButton performClick:self];
                    return;
                }
                break;
            case NSBackspaceCharacter:
            case NSDeleteCharacter:
                if([self image] == [NSImage imageNamed:MZFadedIcon] ||
                   [self image] == [NSImage imageNamed:MZFadedIconError] ||
                   [self image] == [NSImage imageNamed:MZFadedIconFatalError])
                {
                    NSBeep();
                }
        }
    }
    [super keyDown:theEvent];
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender
{
    if(![self isEnabled])
        return NSDragOperationNone;
    return [super draggingEntered:sender];
}

- (NSDragOperation)draggingUpdated:(id < NSDraggingInfo >)sender
{
    if(![self isEnabled])
        return NSDragOperationNone;
    return [super draggingUpdated:sender];
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender
{
    if(![self isEnabled])
        return NO;
    return [super performDragOperation:sender];
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender
{
    if(![self isEnabled])
        return NO;
    return [super prepareForDragOperation:sender];
}


@end

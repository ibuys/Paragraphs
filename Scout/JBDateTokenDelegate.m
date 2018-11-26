//
//  JBDateTokenDelegate.m
//  Paragraphs
//
//  Created by Jonathan Buys on 8/7/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBDateTokenDelegate.h"

@implementation JBDateTokenDelegate

- (void)awakeFromNib
{
    [dateTokenField setTokenizingCharacterSet:[NSCharacterSet newlineCharacterSet]];
    [dateTokenField setTokenStyle: NSPlainTextTokenStyle];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *dateFormatArray = [defaults valueForKey:@"dateFormatArray"];
    NSArray *dateTokenArray;
        
    if( [dateFormatArray count] == 0)
    {
        NSLog(@"1");
        dateTokenArray = [NSArray arrayWithObjects:@"January", @"23", @",", @"2013", nil];

    } else {
        NSLog(@"2");
        
        dateTokenArray = [NSArray arrayWithArray:dateFormatArray];
    }
    
    [dateTokenField setObjectValue:dateTokenArray];

}


- (NSArray *)tokenField:(NSTokenField *)tokenField shouldAddObjects:(NSArray *)tokens atIndex:(NSUInteger)index
{
    return tokens;
}

- (NSArray *)tokenField:(NSTokenField *)tokenFieldArg
completionsForSubstring:(NSString *)substring
           indexOfToken:(NSInteger)tokenIndex
    indexOfSelectedItem:(NSInteger *)selectedIndex
{
    
    NSArray *trackNames = [NSArray arrayWithObjects:@"01", @"23", @"2013", @"2", @"1", @"Jan", @"January", @"13", nil];
    NSArray *matchingTracks = [trackNames filteredArrayUsingPredicate:
                               [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", substring]];
    return matchingTracks;
}

- (id)tokenField:(NSTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString
{
    return editingString;
}

- (NSTokenStyle)tokenField:(NSTokenField *)tokenField styleForRepresentedObject:(id)representedObject
{
    representedObject = [representedObject stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
            
    
    if ([representedObject isEqualToString:@"2"] || [representedObject isEqualToString:@"23"])
    {
        return NSDefaultTokenStyle;
        
    } else if ([representedObject isEqualToString:@"1"] || [representedObject isEqualToString:@"01"] || [representedObject isEqualToString:@"Jan"] || [representedObject isEqualToString:@"January"])
    {
        return NSRoundedTokenStyle;
        
    } else if ([representedObject isEqualToString:@"13"] || [representedObject isEqualToString:@"2013"])
    {
        return NSRoundedTokenStyle;
        
    }
    
    else {
        return NSPlainTextTokenStyle;
    }
}

- (BOOL)tokenField:(NSTokenField *)tokenField hasMenuForRepresentedObject:(id)representedObject
{
    return YES;
}

- (NSMenu *)tokenField:(NSTokenField *)tokenField menuForRepresentedObject:(id)representedObject
{
    
    NSMenu *tokenMenu = [[NSMenu alloc] init];
    
    NSMenuItem *monthSingleDigit = [[NSMenuItem alloc] initWithTitle:@"1" action:@selector(editCellAction:) keyEquivalent:@""];
    [monthSingleDigit setTarget:self];
    
    NSMenuItem *monthDoubleDigit = [[NSMenuItem alloc] initWithTitle:@"01" action:@selector(editCellAction:) keyEquivalent:@""];
    [monthDoubleDigit setTarget:self];
    
    NSMenuItem *monthShortWord = [[NSMenuItem alloc] initWithTitle:@"Jan" action:@selector(editCellAction:) keyEquivalent:@""];
    [monthShortWord setTarget:self];
    
    NSMenuItem *monthLongWord = [[NSMenuItem alloc] initWithTitle:@"January" action:@selector(editCellAction:) keyEquivalent:@""];
    [monthLongWord setTarget:self];

    NSMenuItem *yearShortWord = [[NSMenuItem alloc] initWithTitle:@"13" action:@selector(editCellAction:) keyEquivalent:@""];
    [yearShortWord setTarget:self];

    NSMenuItem *yearLongWord = [[NSMenuItem alloc] initWithTitle:@"2013" action:@selector(editCellAction:) keyEquivalent:@""];
    [yearLongWord setTarget:self];

    NSMenuItem *dayShortWord = [[NSMenuItem alloc] initWithTitle:@"2" action:@selector(editCellAction:) keyEquivalent:@""];
    [dayShortWord setTarget:self];

    NSMenuItem *dayLongWord = [[NSMenuItem alloc] initWithTitle:@"23" action:@selector(editCellAction:) keyEquivalent:@""];
    [dayLongWord setTarget:self];


    if (!representedObject)
        return nil;
    
    if ([representedObject isEqualToString:@"1"] || [representedObject isEqualToString:@"01"] || [representedObject isEqualToString:@"Jan"] || [representedObject isEqualToString:@"January"])
    {
        [tokenMenu addItem:monthSingleDigit];
        [tokenMenu addItem:monthDoubleDigit];
        [tokenMenu addItem:monthShortWord];
        [tokenMenu addItem:monthLongWord];
        
    } else if ([representedObject isEqualToString:@"2"] || [representedObject isEqualToString:@"23"])

    {
        [tokenMenu addItem:dayShortWord];
        [tokenMenu addItem:dayLongWord];
        
    } else if ([representedObject isEqualToString:@"13"] || [representedObject isEqualToString:@"2013"])
    {
        [tokenMenu addItem:yearShortWord];
        [tokenMenu addItem:yearLongWord];
        
    } else {
        return nil;
    }
    
    return tokenMenu;
}

- (IBAction)editCellAction:(id)sender
{
    
	NSText *fieldEditor = [dateTokenField currentEditor];
	NSRange textRange = [fieldEditor selectedRange];
	
	NSString *replacedString = [sender title];
	[fieldEditor replaceCharactersInRange:textRange withString:replacedString];
	[fieldEditor setSelectedRange:NSMakeRange(textRange.location, [replacedString length])];
    
    
    NSMutableArray *tokenArray = [NSMutableArray arrayWithArray:[dateTokenField objectValue]];
    NSMutableArray *newTokenArray = [[NSMutableArray alloc] init];
    NSCharacterSet *nonAlphaNumeric = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    for (NSString *token in tokenArray)
    {
        // NSLog(@"token: %@", token);
        NSRange ranger = [token rangeOfCharacterFromSet:nonAlphaNumeric];
        if ( ranger.location != NSNotFound)
        {
            
            NSScanner *scanner = [NSScanner scannerWithString:token];
            NSString *first;
            NSString *second;
            NSString *third;
            
            if ([scanner scanCharactersFromSet:nonAlphaNumeric intoString:&first])
            {
                [newTokenArray addObject:first];
            }
            
            
            if ([scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&second])
            {
                [newTokenArray addObject:second];
            }
            
            if ([scanner scanCharactersFromSet:nonAlphaNumeric intoString:&third])
            {
                [newTokenArray addObject:third];
            }
            
        } else {
            [newTokenArray addObject:token];
        }
    }
    
    
    [dateTokenField setObjectValue:[NSArray arrayWithArray:newTokenArray]];
    
}



@end



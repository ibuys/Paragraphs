//
//  JBPrefsController.m
//  Scout
//
//  Created by Jonathan Buys on 11/20/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBPrefsController.h"
#import "JBAppSupportDir.h"
#import "MGPreferencePanel.h"

@implementation JBPrefsController



-(void)awakeFromNib
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults valueForKey:@"siteName"] length] > 0)
    {
        [siteNameTextField setStringValue:[defaults valueForKey:@"siteName"]];
    }
    
    if ([[defaults valueForKey:@"siteURL"] length] > 0)
    {
        [siteURLTextField setStringValue:[defaults valueForKey:@"siteURL"]];
    }
    
    [self populateStylesPopUpButton];
    
    if ([[defaults valueForKey:@"textEditorTheme"] length] > 0)
    {
        NSMenu *themeMenu = [stylePopUpButton menu];
        NSMenuItem *defaultItem = [themeMenu itemWithTitle:[defaults valueForKey:@"textEditorTheme"]];
        [stylePopUpButton selectItem:defaultItem];
    }
    
    

    NSDictionary *licenseDict = [defaults objectForKey:@"licenseDict"];
    if ([licenseDict count] > 0)
    {
        NSString *owner = [licenseDict valueForKey:@"Name"];
        NSString *purchased = [licenseDict valueForKey:@"Timestamp"];
        [licenseOwner setStringValue:owner];
        [licensePurchase setStringValue:purchased];
        
    }

}


- (void) populateStylesPopUpButton
{
	[stylePopUpButton removeAllItems];
//	[stylePopUpButton addItemWithTitle:@"Default"];
	
//	NSArray *styleFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@"style"
//															 inDirectory:nil];
    
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    NSString *path;
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    
    
    NSString *mediaPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:mediaPath];
    //  NSLog(@"themes path = %@", mediaPath);
    
    NSString *file;
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString: @"pts"])
        {
            [stylePopUpButton addItemWithTitle:[[file lastPathComponent] stringByDeletingPathExtension]];
        }
    }
    
}


-(void)doneEditPrefs
{
//    NSLog(@"done edit prefs");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[siteNameTextField stringValue] length] > 0)
    {
        [defaults setValue:[siteNameTextField stringValue] forKeyPath:@"siteName"];
    }
    
    if ([[siteURLTextField stringValue] length] > 0)
    {
        NSString *siteURL = [siteURLTextField stringValue];
        NSString *fullURL;
        NSRange range = [siteURL rangeOfString:@"http://"];
        
        if (range.location != NSNotFound)
        {
            fullURL = siteURL;
        } else {
            
            NSString *httpString = @"http://";
            fullURL = [httpString stringByAppendingString:siteURL];
        }

        [defaults setValue:fullURL forKeyPath:@"siteURL"];
    }

    
    if ([[dateTokenField stringValue] length] > 0)
    {
        NSLog(@"here: %@", [dateTokenField stringValue]);
        NSString *customDateString = [self dateFormatterString:[dateTokenField stringValue]];
        [defaults setValue:customDateString forKey:@"dateFormat"];
        [defaults setValue:[dateTokenField objectValue] forKey:@"dateFormatArray"];
    }
    
    

    [defaults setValue:[[stylePopUpButton selectedItem] title] forKeyPath:@"textEditorTheme"];
    
    
}


- (NSString *)dateFormatterString: (NSString *)retrievedString
{
    
    retrievedString = [retrievedString stringByReplacingOccurrencesOfString:@"January" withString:@"MMMM"];
    retrievedString = [retrievedString stringByReplacingOccurrencesOfString:@"Jan" withString:@"MMM"];
    retrievedString = [retrievedString stringByReplacingOccurrencesOfString:@"2013" withString:@"yyyy"];
    retrievedString = [retrievedString stringByReplacingOccurrencesOfString:@"13" withString:@"yy"];
    retrievedString = [retrievedString stringByReplacingOccurrencesOfString:@"23" withString:@"dd"];
    retrievedString = [retrievedString stringByReplacingOccurrencesOfString:@"01" withString:@"MM"];
    retrievedString = [retrievedString stringByReplacingOccurrencesOfString:@"2" withString:@"d"];
    

    NSLog(@"retrievedString = %@", retrievedString);
    return retrievedString;
}


- (BOOL)copyToDropbox
{
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    NSURL *basePath = [NSURL fileURLWithPath:[appSupDir applicationSupportDirectory]];
    NSURL *dropBoxDir = [NSURL fileURLWithPath:[appSupDir dropboxDir]];
    
    NSURL *postsBaseURL = [basePath URLByAppendingPathComponent:@"posts"];
    NSURL *mediaBaseURL = [basePath URLByAppendingPathComponent:@"media"];
    NSURL *templatesBaseURL = [basePath URLByAppendingPathComponent:@"templates"];

    NSURL *dbPostsURL = [dropBoxDir URLByAppendingPathComponent:@"posts"];
    NSURL *dbMediaURL = [dropBoxDir URLByAppendingPathComponent:@"media"];
    NSURL *dbTemplatesURL = [dropBoxDir URLByAppendingPathComponent:@"templates"];

    

    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSError *error;
    
    BOOL returnCode;
    
    NSLog(@"Copy items at: %@", postsBaseURL);
    NSLog(@"To Dropbox at: %@", dbPostsURL);
    
    if ([fileMan copyItemAtURL:postsBaseURL toURL:dbPostsURL error:&error])
    {
        returnCode = YES;
        [fileMan removeItemAtURL:postsBaseURL error:&error];
    } else {
        NSLog(@"Error: %@", [error description]);
        returnCode =  NO;
    }
    
    NSLog(@"Copy items at: %@", mediaBaseURL);
    NSLog(@"To Dropbox at: %@", dbMediaURL);
    
    if ([fileMan copyItemAtURL:mediaBaseURL toURL:dbMediaURL error:&error])
    {
        returnCode =  YES;
        [fileMan removeItemAtURL:mediaBaseURL error:&error];

    } else {
        NSLog(@"Error: %@", [error description]);
        returnCode =  NO;
    }

    NSLog(@"Copy items at: %@", templatesBaseURL);
    NSLog(@"To Dropbox at: %@", dbTemplatesURL);
    
    if ([fileMan copyItemAtURL:templatesBaseURL toURL:dbTemplatesURL error:&error])
    {
        returnCode =  YES;
        [fileMan removeItemAtURL:templatesBaseURL error:&error];

    } else {
        NSLog(@"Error: %@", [error description]);
        returnCode =  NO;
    }

    return returnCode;
}

- (BOOL)removeDropboxData
{
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    NSURL *basePath = [NSURL fileURLWithPath:[appSupDir applicationSupportDirectory]];
    NSURL *dropBoxDir = [NSURL fileURLWithPath:[appSupDir dropboxDir]];
    
    NSURL *postsBaseURL = [basePath URLByAppendingPathComponent:@"posts"];
    NSURL *mediaBaseURL = [basePath URLByAppendingPathComponent:@"media"];
    NSURL *templatesBaseURL = [basePath URLByAppendingPathComponent:@"templates"];
    
    NSURL *dbPostsURL = [dropBoxDir URLByAppendingPathComponent:@"posts"];
    NSURL *dbMediaURL = [dropBoxDir URLByAppendingPathComponent:@"media"];
    NSURL *dbTemplatesURL = [dropBoxDir URLByAppendingPathComponent:@"templates"];
    
    
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSError *error;
    
    BOOL returnCode;
    
    NSLog(@"Copy items at: %@", dbPostsURL);
    NSLog(@"To Dropbox at: %@", postsBaseURL);

    if ([fileMan copyItemAtURL:dbPostsURL toURL:postsBaseURL error:&error])
    {
        returnCode = YES;
        [fileMan removeItemAtURL:dbPostsURL error:&error];
    } else {
        NSLog(@"Error: %@", [error description]);
        returnCode =  NO;
    }
    
    NSLog(@"Copy items at: %@", dbMediaURL);
    NSLog(@"To Dropbox at: %@", mediaBaseURL);
    
    if ([fileMan copyItemAtURL:dbMediaURL toURL:mediaBaseURL error:&error])
    {
        returnCode =  YES;
        [fileMan removeItemAtURL:dbMediaURL error:&error];
        
    } else {
        NSLog(@"Error: %@", [error description]);
        returnCode =  NO;
    }
    
    NSLog(@"Copy items at: %@", dbTemplatesURL);
    NSLog(@"To Dropbox at: %@", templatesBaseURL);
    
    if ([fileMan copyItemAtURL:dbTemplatesURL toURL:templatesBaseURL error:&error])
    {
        returnCode =  YES;
        [fileMan removeItemAtURL:dbTemplatesURL error:&error];
        
    } else {
        NSLog(@"Error: %@", [error description]);
        returnCode =  NO;
    }
    
    return returnCode;

}


-(void)launchLicense
{
    [prefsWindow makeKeyAndOrderFront:self];
    [prefPanel changePanes:@"openLicense"];
}


@end

//
//  JBFirstRunViewController.m
//  Scout
//
//  Created by Jon Buys on 11/19/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBFirstRunViewController.h"
#import "JBFirstRunMover.h"
#import "JBWindowController.h"

@implementation JBFirstRunViewController

- (void)awakeFromNib
{
    [niceBox setCornerRadius:15.0];
    [[firstRunView window] makeFirstResponder:siteTitleTextField];
    
    JBFirstRunMover *firstRun = [[JBFirstRunMover alloc] init];
    [firstRun copyDefaultTemplate];
    NSLog(@"User Name: %@", NSFullUserName());

    NSString *userName = NSFullUserName();
    NSString *initialTitle = [userName stringByAppendingString:@"'s Site"];
    [siteTitleTextField setStringValue:initialTitle];

}

- (IBAction)setFolderAndSite:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[siteTitleTextField stringValue] forKey:@"siteName"];
    NSString *siteURL = [urlTextField stringValue];
    NSString *fullURL;
    NSRange range = [siteURL rangeOfString:@"http://"];
    
    if (range.location != NSNotFound)
    {
        fullURL = siteURL;
    } else {
        
        NSString *httpString = @"http://";
        fullURL = [httpString stringByAppendingString:siteURL];
    }
    
        
    [defaults setValue:fullURL forKey:@"siteURL"];
    [windowController finishFirstRun:nil];

    // OK, now we can say that first run is done. 
    [defaults setBool:YES forKey:@"firstLaunch"];

}

-(IBAction)setDropboxSync:(id)sender
{
    
}

-(IBAction)setSite44:(id)sender
{
    
}


@end

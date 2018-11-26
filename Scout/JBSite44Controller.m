//
//  JBSite44Controller.m
//  Scout
//
//  Created by Jonathan Buys on 2/15/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBSite44Controller.h"
#import "JBWindowController.h"

@implementation JBSite44Controller

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)awakeFromNib
{
    [linkWithDropboxButton setEnabled:NO];
}

-(IBAction)checkSite44API:(id)sender
{
    NSError *error;
    
    NSString *domainToCheck = [site44DomainTextField stringValue];
    NSString *fullDomain = [domainToCheck stringByAppendingString:@".site44.com"];
    NSString *apiAddress = @"http://www.site44.com/api/available/";
    NSString *fullQueryURL = [apiAddress stringByAppendingString:fullDomain];
    
    
    NSURL *url = [ NSURL URLWithString:fullQueryURL];
    NSString *test = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"test = %@", test);
    
    
    if ([test rangeOfString:@"true"].location != NSNotFound)
    {
        NSString *success = [NSString stringWithFormat:@"OK, that domain is available!\n Your new site will be available at %@.", fullDomain];
        
        [instructionLabel setStringValue:success];
        [linkWithDropboxButton setEnabled:YES];

    } else {
        NSString *sorry = [NSString stringWithFormat:@"Sorry, that domain is not available. Try again?"];
        
        [instructionLabel setStringValue:sorry];
        [linkWithDropboxButton setEnabled:NO];
    }

}

-(IBAction)linkSite44andDropbox:(id)sender
{
    NSString *domainToCheck = [site44DomainTextField stringValue];
    NSString *fullDomain = [domainToCheck stringByAppendingString:@".site44.com"];
    NSString *apiAddress = @"http://www.site44.com/admin/create/";
    NSString *fullQueryURL = [apiAddress stringByAppendingString:fullDomain];
    
    [windowController loadSite44WebViewWithDomain:fullQueryURL];
}

@end

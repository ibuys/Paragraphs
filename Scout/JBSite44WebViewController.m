//
//  JBSite44WebViewController.m
//  Scout
//
//  Created by Jonathan Buys on 2/15/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBSite44WebViewController.h"
#import "JBWindowController.h"
#import "JBAppSupportDir.h"

@implementation JBSite44WebViewController

- (void)loadSite:(NSString *)urlString
{
    sitePath = [urlString lastPathComponent];
    NSLog(@"sitePath = %@", sitePath);
    NSLog(@"urlSTring = %@", urlString);
    
    NSURL*url=[NSURL URLWithString:urlString];
    NSLog(@"url = %@", url);

    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [[webView mainFrame] loadRequest:request];
}

-(IBAction)cancel:(id)sender
{
    [windowController cancelSite44Webview:self];
}

-(IBAction)finish:(id)sender
{
    NSLog(@"sitePath = %@", sitePath);

    [windowController finishSite44Webview:self];
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    NSString *publishPath = [appSupDir site44Dir];
    NSString *fullPubPath = [publishPath stringByAppendingPathComponent:sitePath];
    
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:fullPubPath forKey:@"publishPath"];
    [defaults setBool:YES forKey:@"useSite44"];
}



@end

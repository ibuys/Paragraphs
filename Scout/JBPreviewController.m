//
//  JBPreviewController.m
//  Scout
//
//  Created by Jon Buys on 12/22/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBPreviewController.h"
#import "JBAppSupportDir.h"
#import "JBSiteBuilder.h"

@implementation JBPreviewController



- (void)previewText:(JBPost *)passedPost;
{
        
    JBSiteBuilder *siteBuilder = [[JBSiteBuilder alloc] init];
    NSString *fullHTMLString = [siteBuilder buildPost:passedPost];
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    NSString *path;
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }

    
    [[webView mainFrame] loadHTMLString:fullHTMLString baseURL:[NSURL fileURLWithPath:path]];
}

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id)listener
{
//    NSLog(@"called: %@", [request URL]);
//    NSString *host = [[request URL] host];
    
    if ([[request URL] isFileURL])
    {
        [listener use];
    } else {
        [listener ignore];
    }
    
}


@end

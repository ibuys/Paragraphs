//
//  JBSite44WebViewController.h
//  Scout
//
//  Created by Jonathan Buys on 2/15/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@class JBWindowController;

@interface JBSite44WebViewController : NSObject
{
    IBOutlet WebView *webView;
    IBOutlet JBWindowController *windowController;
    NSString *sitePath;
}

- (void)loadSite:(NSString *)url;
-(IBAction)cancel:(id)sender;
-(IBAction)finish:(id)sender;

@end

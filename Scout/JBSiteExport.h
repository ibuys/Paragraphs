//
//  JBSiteExport.h
//  Scout
//
//  Created by Jonathan Buys on 9/1/12.
//
//

#import <Foundation/Foundation.h>
#import "JBMarkdownConverter.h"
#import "JBPost.h"
#import "JBSiteBuilder.h"

@class JBAppDelegate;

@interface JBSiteExport : NSObject
{
    IBOutlet NSArrayController *postsArrayController;
    IBOutlet NSWindow *mWindow;
    IBOutlet JBAppDelegate *appDelegate;
    IBOutlet NSProgressIndicator *publishProgressIndicator;

    NSURL* rootSaveDirectory;

}

- (IBAction)exportSite:(id)sender;
- (NSString *)postURL:(JBPost *)post;
- (NSURL *)rootSaveDirectory;

- (NSString *)postPath:(JBPost *)post;
- (NSString *)postFolder:(JBPost *)post;
//-(void)exportPostsForFTP;

@end


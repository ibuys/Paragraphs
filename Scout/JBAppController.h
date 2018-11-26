//
//  JBAppController.h
//
//  Created by Jon Buys on 12/21/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBWindowController.h"
#import "HGMarkdownHighlighter.h"
@class JBAppDelegate;

@interface JBAppController : NSObject
{
    IBOutlet JBWindowController *myWindowController;
    IBOutlet JBAppDelegate *appDelegate;
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSTextView *mainTextEditorView;
    IBOutlet NSArrayController *postArrayController;
    IBOutlet NSTableView *postList;
    IBOutlet NSBox *mainBox;
    
    HGMarkdownHighlighter *hl1;
    NSString *markdownDirectory;
    
    IBOutlet NSMenuItem *newPostMenuItem;
    IBOutlet NSMenuItem *previewMenuItem;
    IBOutlet NSMenuItem *deletePostMenuItem;
    IBOutlet NSMenuItem *publishMenuItem;
    IBOutlet NSButton *previewButton;
    IBOutlet NSButton *libraryButton;
    IBOutlet NSButton *newPostButton;
    IBOutlet NSMenuItem *setFontMenuItem;
    IBOutlet NSProgressIndicator *publishProgressIndicator;

    
}

- (IBAction)segControlClicked:(id)sender;

- (void)highlightNow;
- (void)readClearTextStylesFromTextView;
- (void)hlDeactivate;
- (void)hlActivate;
- (void)clearHighlighting;

- (void) setTextView1Styles:(NSString *)styleName;

- (void)normalStart;

-(IBAction)flipLinkRefType:(id)sender;
-(IBAction)openFarmdogHomePage:(id)sender;
-(IBAction)sendFeedbackEmail:(id)sender;
- (IBAction)returnFirstPost:(id)sender;

-(IBAction)toggleFont:(id)sender;



@end

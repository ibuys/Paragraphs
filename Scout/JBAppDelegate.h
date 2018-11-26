//
//  JBAppDelegate.h
//  Scout
//
//  Created by Jonathan Buys on 11/19/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JBScoutTemplateController.h"
#import "MAAttachedWindow.h"

@class JBAppController;
@class JBWindowController;

//#import <Quartz/Quartz.h>

@interface JBAppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>
{
    
    NSMutableArray *markdownFilesArray;
    NSUndoManager *undoManager;
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSToolbar *mainToolbar;
    IBOutlet NSSplitView *mySplitView;
    IBOutlet NSArrayController *markdownFilesArrayContoller;
    IBOutlet NSTableView *mainTableView;
    IBOutlet NSTextView *mainTextView;

    IBOutlet NSView *view;
    IBOutlet NSView *textHoldingView;
    IBOutlet NSScrollView *textScrollView;
    IBOutlet NSImageView *myImageView;
    
    IBOutlet JBAppController *appController;
    IBOutlet JBWindowController *windowController;
    IBOutlet NSMenuItem *setFontMenuItem;
    
    MAAttachedWindow *attachedWindow;

    NSMetadataQuery *query;
    NSRange savedRange;

    NSDate *lastDBScan;
//    QLPreviewPanel* previewPanel;

//    SCEvents *_events;
    IBOutlet NSMenuItem *newPostMenuItem;
    IBOutlet NSMenuItem *previewMenuItem;
    IBOutlet NSMenuItem *deletePostMenuItem;
    IBOutlet NSMenuItem *publishMenuItem;
    IBOutlet NSMenuItem *updatesMenuItem;
    
    // AppleScript
    NSString *foobaz;
    

    

}

#pragma mark -
#pragma mark Properties

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain)NSMutableArray *markdownFilesArray;


#pragma mark -
#pragma mark Actions

//- (IBAction)computeMD5HashOfBinary:(id)sender;

-(void)saveText;
-(void)newPost;
-(void)checkForText;
-(void)saveAllPosts;
-(void)boundsDidChangeNotification:(NSNotification *)notification;

- (IBAction)closeMAWindow:(id)sender;
- (IBAction)showMainWindow:(id)sender;
- (IBAction)deletePost:(id)sender;
- (IBAction)newPost:(id)sender;

//- (IBAction)checkForUpdates:(id)sender;


@end

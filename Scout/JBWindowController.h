//
//  JBWindowController.h
//  Scout
//
//  Created by Jon Buys on 12/21/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "JBAppDelegate.h"
#import "JBPreviewController.h"
#import "JBTextView.h"
#import "JBPrefsController.h"

@class JBAppController;
@class JBSiteExport;
@class JBSite44WebViewController;
@class JBSplitView;
@class JBMediaManagerController;

@interface JBWindowController : NSWindowController
{
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSView *mainView;
    IBOutlet NSSplitView *mainSplitView;
    IBOutlet NSView *leftView;
    IBOutlet NSView *leftSplitView;
    IBOutlet NSView *rightSplitView;
    IBOutlet NSView *mainTextEditorView;
    IBOutlet JBTextView *mainTextView;
    IBOutlet JBAppDelegate *appDelegate;
    IBOutlet NSArrayController *postArrayController;
    IBOutlet JBAppController *myAppController;
    IBOutlet JBSplitView *splitViewController;
    IBOutlet NSButton *previewButton;
    
    
    IBOutlet NSMenuItem *previewPostMenuItem;
    IBOutlet NSMenuItem *showLibraryMenuItem;
    IBOutlet NSMenuItem *showMediaMenuItem;
    IBOutlet NSMenuItem *showThemesMenuItem;
    IBOutlet NSMenuItem *showPrefsMenuItem;
    
    IBOutlet NSButton *newPostButton;
    IBOutlet NSButton *showLibraryButton;
    IBOutlet NSSegmentedControl *previewPostSegmentedControl;
    IBOutlet NSToolbar *mainToolBar;
    
    NSImageView *tempImageView;

    // First Run
    IBOutlet NSView *firstRunView;

    // Media Manager
    IBOutlet NSView *mediaManagerView;
    IBOutlet NSPanel *mediaManagerPanel;
    IBOutlet NSView *mediaBrowser;
    IBOutlet JBMediaManagerController *mediaManager;
    
    BOOL mediaManagerShown;
    
    
//    // FTP Controller
//    IBOutlet NSView *ftpControllerView;
//    IBOutlet JBSiteExport *siteExporter;
//    BOOL ftpControllerShown;
    

    // Prefs
    IBOutlet NSView *prefsView;
    IBOutlet NSWindow *prefsWindow;
    IBOutlet JBPrefsController *prefsController;
    IBOutlet NSPopUpButton *stylePopUpButton;
    BOOL prefsShown;
    
    // Preview
    IBOutlet NSView *previewView;
    IBOutlet JBPreviewController *previewController;
    BOOL previewShown;
    BOOL wasLibraryOpen;
    NSImage *imageStorage;
    NSRange savedRange;
    
    // Theme Chooser
    IBOutlet NSView *themeChooserView;
    IBOutlet NSPanel *themeChooserPanel;
    IBOutlet NSCollectionView *mainThemeCollectionView;
    BOOL themeChooserViewShown;
    
    // Empty Posts View
    IBOutlet NSView *emptyPostsView;
    
    // Site44
    BOOL site44shown;
    BOOL site44Webviewshown;

    IBOutlet NSView *site44View;
    IBOutlet NSView *site44WebView;
    IBOutlet JBSite44WebViewController *site44WebViewController;
    
//    // Menu Items
//    IBOutlet NSMenuItem *previewPostMenuItem;
//    IBOutlet NSMenuItem *mediaManagerMenuItem;
//    IBOutlet NSMenuItem *themeChooserMenuItem;
//    IBOutlet NSMenuItem *prefsMenuItem;
//    IBOutlet NSMenuItem *newPostMenuItem;

    CATransition *transition;

}


- (IBAction)finishFirstRun:(id)sender;
- (BOOL)loadView:(NSView *)viewToLoad intoView:(NSView *)parentView;
- (void)loadFirstLaunch;
- (void)normalStart;
- (IBAction)toggleMediaManager:(id)sender;

- (IBAction)togglePrefs:(id)sender;
- (IBAction)doneEditPrefs:(id)sender;
- (IBAction) styleSelected:(id)sender;

- (IBAction)togglePreview:(id)sender;
- (IBAction)toggleThemeChooser:(id)sender;
//- (IBAction)toggleFTPView:(id)sender;
- (IBAction)loadTextEditor:(id)sender;
- (void)dropFromMediaManager:(NSString *)fileToUse;
- (void)setTextEditorFromPreview;
- (void)setPreviewFromTextEditor;
- (BOOL)previewShown;
- (BOOL)mediaManagerShown;
- (void)setEmptyPostsView;

- (IBAction)showReleaseNotes:(id)sender;
- (void) addImageWithPath:(NSString *) path;



@end

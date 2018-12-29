//
//  JBAppDelegate.m
//  Scout
//
//  Created by Jonathan Buys on 11/19/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBAppDelegate.h"
#import "JBPost.h"
#import "JBAppSupportDir.h"
#import "JBAppController.h"
#import "JBWindowController.h"
#import "JBDropboxSync.h"

#import "NSURL+DirectoryObserver.h"

//#ifndef MAC_APP_STORE
//#import "Sparkle/SUUpdater.h"
//#endif

// expiration is used for any (beta) builds that aren't for the Mac App Store
#ifndef MAC_APP_STORE
#define USE_EXPIRATION 1
#else
#define USE_EXPIRATION 0
#endif

@implementation JBAppDelegate
@synthesize markdownFilesArray;


-(id)init {
    if ( self = [super init] )
    {
        markdownFilesArray = [[NSMutableArray alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (![defaults boolForKey:@"firstLaunch"])
        {
        //    NSLog(@"First Launch");
        
            // Create the 
            [defaults setBool:YES forKey:@"tabViewCollapsed"];

            undoManager = [[NSUndoManager alloc] init];
            [self addObserver:self
                   forKeyPath:@"markdownFilesArray"
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:NULL];

        }
    }
#if DEBUG
    NSLog(@"DEBUG");
#endif
    
    return self;
}

-(void)awakeFromNib
{
    [self performSelector:@selector(checkForText) withObject:nil afterDelay:0.05];
    
#ifdef MAC_APP_STORE
	[[updatesMenuItem menu] removeItem:updatesMenuItem];
#endif
    
}


- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
}

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{
    
    //  NSLog(@"applicationWillFinishLaunching");
    
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];// 1
    [appleEventManager setEventHandler:self andSelector:@selector(handleGetURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"firstLaunch"])
    {
        
#ifdef MAC_APP_STORE
//        NSLog(@"Mac App Store Build");
        // Remove the check for updates menu item
        
#else
//        [updatesMenuItem setTarget:self];
//        [updatesMenuItem setAction:@selector(checkForUpdates:)];
//        //  NSLog(@"Web Site Build");
//        
//        
//        // markdownDirectory = [defaults valueForKey:@"markdownDirectory"];
//        JBAppSupportDir *myAppSupDir = [[JBAppSupportDir alloc] init];
//        
//        NSString *scoutDir = [myAppSupDir applicationSupportDirectory];
//        //  NSLog(@"scoutDir = %@", scoutDir);
//        
//        
//        NSFileManager *localFileManager=[[NSFileManager alloc] init];
//        NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:scoutDir];
//        NSString *file;
//        
//        NSMutableArray *checkArray = [[NSMutableArray alloc] init];
//        
//        while (file = [dirEnum nextObject])
//        {
//            if ([[file pathExtension] isEqualToString: @"paragraphslicense"])
//            {
//            //    NSLog(@"found a license: %@", file);
//                [checkArray addObject:file];
//            }
//        }
//        
//        
//        NSString *plock = [scoutDir stringByAppendingString:@"/.plock"];
//        // NSLog(@"plock = %@", plock);
//        
//        //[localFileManager fileExistsAtPath:plock];
//        
//        
//        // First, check to see if we have a license
//        
//        BOOL haveLicense = NO;
//        // Lets look for one.
//        if ([checkArray count] == 1)
//        {
//            haveLicense = YES;
//            // OK Found a license!
//         //   NSLog(@"OK Found a license!");
//            file = [scoutDir stringByAppendingPathComponent:[checkArray objectAtIndex:0]];
//            
//            // Check the license
//            JBChecker *newChecker = [[JBChecker alloc] init];
//            
//            if (![newChecker licenseCheck:file])
//            {
//                NSLog(@"Sorry, something is wrong with the license file");
//                [NSApp terminate:self];
//            }             
//        } else {
//            
//        //    NSLog(@"ok, no license file");
//            // OK, no license
//            // Next, check the plock file
//            
//            // Check the plock file
//            if ([localFileManager fileExistsAtPath:plock])
//            {
//                // Found the plock file
//            //    NSLog(@"Found the plock file, how many days do we have left?");
//                
//                // read the file
//                NSError *error;
//                NSString *launchesLeft = [NSString stringWithContentsOfFile:plock encoding:NSUTF8StringEncoding error:&error];
//                NSUInteger launchesLeftInt = [launchesLeft intValue];
//                NSUInteger maxLaunches = 14;
//           //     NSLog(@"launchesLeftInt = %li", (unsigned long)launchesLeftInt);
//                
//                
//                // Are we past the free trial?
//                if (launchesLeftInt < maxLaunches)
//                {
//                    haveLicense = YES;
//                    
//                    // NO, that's cool, keep going.
////                    NSLog(@"keep going");
////                    NSLog(@"launchesLeftInt = %li", (unsigned long)launchesLeftInt);
////                    
////                    
////                    NSLog(@"launchesLeftInt = %lu", (unsigned long)launchesLeftInt);
////                    
//                    NSUInteger printInt = 14 - launchesLeftInt;
////                    NSLog(@"printInt = %lu", (unsigned long)printInt);
//                    
//                    if (printInt == 1)
//                    {
//                        [[NSAlert alertWithMessageText:@"Paragraphs Trial Almost Over"
//                                         defaultButton:@"OK"
//                                       alternateButton:nil
//                                           otherButton:nil
//                             informativeTextWithFormat:@"Thank you for trying Paragraphs, this is the last free launch, please visit farmdog.co to purchase a license and unlock Paragraphs."] runModal];
//                        
//                    } else {
//                        
//                        [[NSAlert alertWithMessageText:@"Paragraphs Trial"
//                                         defaultButton:@"OK"
//                                       alternateButton:nil
//                                           otherButton:nil
//                             informativeTextWithFormat:@"Thank you for trying Paragraphs, there are %lu launches remaining.", (unsigned long)printInt] runModal];
//                        
//                    }
//                    
//                    launchesLeftInt = launchesLeftInt + 1;
//                    NSString *llIString = [[NSNumber numberWithUnsignedInteger:launchesLeftInt] stringValue];
//                    [llIString writeToFile:plock atomically:YES encoding:NSUTF8StringEncoding error:&error];
//                    
//                } else {
////                    NSLog(@"no license, and no free trial left, sorry!");
//                    haveLicense = NO;
//                }
//                
//            } else {
//                NSLog(@"Sorry, I need a file that is not present.");
//                [NSApp terminate:self];
//            }
//        }
//        
//        
//        if (!haveLicense)
//        {
//            [[NSAlert alertWithMessageText:@"Paragraphs Trial Expired"
//                             defaultButton:@"OK"
//                           alternateButton:nil
//                               otherButton:nil
//                 informativeTextWithFormat:@"Thank you for trying Paragraphs, the trial has now ended, please visit farmdog.co to purchase a license and unlock Paragraphs."] runModal];
//            
////            NSLog(@"terminate, sorry.");
//            [NSApp terminate:self];
//        }
//        
//        
//        // Are we past the free trial?
        
#endif
        
        
    }

    
    
    
    
    
    
    
    
    
    [[textScrollView contentView] setPostsBoundsChangedNotifications: YES];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter] ;
    [center addObserver: self
               selector: @selector(boundsDidChangeNotification:)
                   name: NSViewBoundsDidChangeNotification
                 object: [textScrollView contentView]];
    
    
    JBAppSupportDir *myAppSupDir = [[JBAppSupportDir alloc] init];
    
    
    NSString *scoutDir;
    
//    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        scoutDir = [myAppSupDir dropboxDir];
        
        
    } else {
        scoutDir = [myAppSupDir applicationSupportDirectory];
        
    }
    
    
//    NSString *markdownDirectory = [scoutDir stringByAppendingPathComponent:@"posts"];
    // NSLog(@"markdownDirectory = %@", markdownDirectory);
//    NSURL * postsURL = [NSURL fileURLWithPath:markdownDirectory];
    //   NSLog(@"postsURL = %@", postsURL);
    
//    if ([defaults boolForKey:@"dropboxSync"])
//    {
//        [postsURL addDirectoryObserver:self options:0 resumeToken:nil];
//    }
    
    
    lastDBScan = [NSDate date];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    
    if ([defaults boolForKey:@"firstLaunch"])
    {
        
        undoManager = [[NSUndoManager alloc] init];
        [self addObserver:self
               forKeyPath:@"markdownFilesArray"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
        
    }
    
    
    
    
    
//#ifndef DEBUG
//#ifndef MAC_APP_STORE
//	// check that a trial version isn't installed
//	NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
//	NSString *pathToAppStoreVersion = [workspace absolutePathForAppBundleWithIdentifier:@"com.farmdog.paragraphs"];
//    NSLog(@"pathToAppStoreVersion = %@", pathToAppStoreVersion);
//	if (pathToAppStoreVersion)
//    {
//		NSString *message = [NSString stringWithFormat:@"It looks like you have a copy of Paragraphs from the Mac App Store installed in \"%@\".\n\nThe application you just launched is a trial version and should be removed. Would you like to quit now so you can move this unneeded file to the Trash?\n\nHint: Use the \"Move to Trash\" item in the \"File\" menu after the Finder window appears.", [pathToAppStoreVersion stringByDeletingLastPathComponent]];
//        
//        
//		NSInteger result = [[NSAlert alertWithMessageText:@"Multiple Copies Installed" defaultButton:@"Quit and Reveal in Finder" alternateButton:@"Continue" otherButton:nil informativeTextWithFormat:@"%@", message] runModal];
//		if (result == NSAlertDefaultReturn) {
//			[workspace selectFile:[[NSBundle mainBundle] bundlePath] inFileViewerRootedAtPath:nil];
//			exit(0);
//		}
//	}
//#endif
//#endif

    
#if DEBUG
#if USE_EXPIRATION
    NSLog(@"USE_EXPIRATION");

	[self checkExpiration];
#endif
#endif
}




#if USE_EXPIRATION

- (void)checkExpiration
{
	NSDate *today = [NSDate date];
    
	// pick the date to expire on
	NSDate *expireDate = [NSDate dateWithString:@"2013-05-15 00:00:00 -0800"];
    NSLog(@"Expire Date: %@", [expireDate description]);
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"h:mm a 'on' EEEE',' MMMM d',' yyyy"];
 	NSString *expireDateString = [dateFormatter stringFromDate:expireDate];
    
	if (! [[today laterDate:expireDate] isEqualToDate:expireDate]) {
		[[NSAlert alertWithMessageText:@"Paragraphs Beta" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"This beta release of Paragraphs expired at %@.", expireDateString] runModal];
		[[NSApplication sharedApplication] terminate:self];
	}
	else {
		[[NSAlert alertWithMessageText:@"Paragraphs Beta" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"This release of Paragraphs is a beta and will expire at %@.", expireDateString] runModal];
	}
}

#endif


- (void)undo:(id)sender
{
    [undoManager undo];
}

- (void)redo:(id)sender
{
    [undoManager redo];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    int kindOfChange = [[change objectForKey:NSKeyValueChangeKindKey] intValue];
    NSUInteger index = [[change objectForKey:NSKeyValueChangeIndexesKey] firstIndex];
    
    JBPost *p;
    
    if (kindOfChange == NSKeyValueChangeInsertion)
    {
        p = [[change objectForKey:NSKeyValueChangeNewKey] lastObject];
        [[undoManager prepareWithInvocationTarget:self] removePostAtIndex:index];
    } else {

        p = [[change objectForKey:NSKeyValueChangeOldKey] lastObject];
        [[undoManager prepareWithInvocationTarget:self] addPost:p atIndex:index];
    }
}

- (void)addPost:(JBPost *)person atIndex:(NSUInteger)index
{

    [markdownFilesArrayContoller addObject:person];
    [markdownFilesArrayContoller rearrangeObjects];
    [mainTableView reloadData];
}

- (void)removePostAtIndex:(NSUInteger)index
{
    NSLog(@"test remove");
    [markdownFilesArray removeObjectAtIndex:index];
    [markdownFilesArrayContoller rearrangeObjects];
    [mainTableView reloadData];

}


- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

-(void)checkForText
{
    if([mainTextView string]==(id) [NSNull null] || [[mainTextView string] length]==0 || [[mainTextView string]isEqual:@""])
    {
        [self disablePreview:nil];
    } else {
        [self enablePreview:nil];
    }
}

#pragma mark window delegate methods

- (void)windowWillMiniaturize:(NSNotification *)notification
{
    if ([windowController mediaManagerShown])
    {
        [windowController toggleMediaManager:self];
    }
}

// -------------------------------------------------------------------------------
//	window:willUseFullScreenPresentationOptions:proposedOptions
//
//  Delegate method to determine the presentation options the window will use when
//  transitioning to full-screen mode.
// -------------------------------------------------------------------------------
//- (NSApplicationPresentationOptions)window:(NSWindow *)window willUseFullScreenPresentationOptions:(NSApplicationPresentationOptions)proposedOptions
//{
//    // customize our appearance when entering full screen:
//    // we don't want the dock to appear but we want the menubar to hide/show automatically
//    //
//    return (NSApplicationPresentationFullScreen |       // support full screen for this window (required)
//            NSApplicationPresentationHideDock |         // completely hide the dock
//            NSApplicationPresentationAutoHideMenuBar |  // yes we want the menu bar to show/hide
//            NSApplicationPresentationAutoHideToolbar);
//}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag
{
    if( !flag )
        [_window makeKeyAndOrderFront:nil];
    
    return YES;
}

- (void)windowWillStartLiveResize:(NSNotification *)notification
{
    
    if (attachedWindow)
    {
        [self closeMAWindow:nil];
    }
    
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification
{
    [appController clearHighlighting];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"useSerif"])
    {
        [mainTextView setFont:[NSFont fontWithName:@"Courier Prime" size:20]];
    } else {
        [mainTextView setFont:[NSFont fontWithName:@"mplus-1c-regular" size:20]];
    }

    [[mainTextView textContainer] setLineFragmentPadding:200.0f];
    
    NSRect insertionRect=[[mainTextView layoutManager] boundingRectForGlyphRange:[mainTextView selectedRange] inTextContainer:[mainTextView textContainer]];
    NSPoint scrollPoint=NSMakePoint(0,insertionRect.origin.y+insertionRect.size.height+2*300-[[NSScreen mainScreen] frame].size.height);
    [mainTextView scrollPoint:scrollPoint];
    
    [appController hlActivate];

    [appController readClearTextStylesFromTextView];

    if (attachedWindow)
    {
        [self closeMAWindow:nil];
    }
    
}


- (void)windowWillExitFullScreen:(NSNotification *)notification
{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"useSerif"])
    {
        [mainTextView setFont:[NSFont fontWithName:@"Courier Prime" size:14]];
    } else {
        [mainTextView setFont:[NSFont fontWithName:@"mplus-1c-regular" size:14]];
    }

    
    
    

    [[mainTextView textContainer] setLineFragmentPadding:15.0f];


    [appController readClearTextStylesFromTextView];

    if (attachedWindow)
    {
        [self closeMAWindow:nil];
    }

}



- (void)windowDidResignKey:(NSNotification *)notification
{
//    [self saveText];
    if (!attachedWindow)
    {
        [self closeMAWindow:nil];
    }

}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return undoManager;
}

#pragma mark application delegate methods


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self saveText];
    if (attachedWindow)
    {
        [self closeMAWindow:nil];
    }
    
    BOOL tabViewCollapsed = [mySplitView isSubviewCollapsed:[[mySplitView subviews] objectAtIndex: 0]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:tabViewCollapsed forKey:@"tabViewCollapsed"];


}

- (void)applicationWillResignActive:(NSNotification *)aNotification
{
    [self saveText];
    if (attachedWindow)
    {
        [self closeMAWindow:nil];
    }
    
}

- (void)applicationWillHide:(NSNotification *)aNotification
{
    [self saveText];
    if (attachedWindow)
    {
        [self closeMAWindow:nil];
    }
    
}


#pragma mark Custom Code

-(void)setTitle
{
    NSString *currentText = [mainTextView string];
    if(currentText == (id) [NSNull null] || [currentText length]==0 || [currentText isEqual:@""])
    {
        // ignore
        
    } else {
        JBPost *currentPost = [[markdownFilesArrayContoller selectedObjects] objectAtIndex:0];
        NSString *titleString;
        
        NSScanner* scanner = [NSScanner scannerWithString:[mainTextView string]];
        
        [scanner scanUpToString:@"\n" intoString:&titleString];
        
        titleString = [titleString stringByReplacingOccurrencesOfString:@"title: " withString:@""];
        
        [currentPost setTitle:titleString];

    }
}

-(void)saveText
{

//    NSLog(@"301 - saveText");

    NSString *currentText = [mainTextView string];
    if(currentText == (id) [NSNull null] || [currentText length]==0 || [currentText isEqual:@""])
    {
        // ignore
        
    } else {
//        NSLog(@"302 - saveText");
        JBPost *currentPost = [[markdownFilesArrayContoller selectedObjects] objectAtIndex:0];
        [self setTitle];
        
        NSString *currentPath = [currentPost path];
        
//        if([currentPost text] ==(id) [NSNull null] || [[currentPost text]  length]==0 || [[currentPost text]  isEqual:@""])
//        {
//            [currentPost setText:[mainTextView string]];
//        }
        savedRange = [mainTextView selectedRange];
//        NSScrollView *savedScroll= [mainTextView enclosingScrollView];
//        NSScroller *scroller = [savedScroll verticalScroller];
//        float position = [scroller doubleValue]; // between 0.0 and 1.0

        [currentPost setText:[mainTextView string]];
        
        [mainTextView setSelectedRange:savedRange];

        [mainTextView scrollRangeToVisible:savedRange];
        
        NSDate *currentDate = [currentPost date];
        NSString *scoutDir;
        
        JBAppSupportDir *myAppSupDir = [[JBAppSupportDir alloc] init];
        
        NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
        
        if ([defaults boolForKey:@"dropboxSync"])
        {
            scoutDir = [myAppSupDir dropboxDir];
            
            
        } else {
            scoutDir = [myAppSupDir applicationSupportDirectory];
            
        }
        
        
        NSString *markdownDirectory = [scoutDir stringByAppendingPathComponent:@"posts"];
        
        
        if(currentPath==(id) [NSNull null] || [currentPath length]==0 || [currentPath isEqual:@""])
        {
            //NSLog(@"currentPath is NULL");
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-SSSS"];
            
            NSString *formattedDateString = [dateFormatter stringFromDate:currentDate];
            NSString *formattedTitle = [[currentPost title] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            NSString *one = [formattedDateString stringByAppendingString:@"##"];
            NSString *two = [one stringByAppendingString:formattedTitle];
            
            
            
            
            //  NSLog(@"No Path! Let's give it one.");
            
            currentPath = [markdownDirectory stringByAppendingPathComponent:two];
            currentPath = [currentPath stringByAppendingString:@".markdown"];
            [currentPost setValue:currentPath forKey:@"path"];
        }
        
        //        NSLog(@"path = %@", currentPath);
        //        NSLog(@"title = %@", currentTitle);
        //        NSLog(@"text = %@", currentText);
        
        
        //    [currentPost setValue:currentText forKey:@"text"];
        
        NSError *error;
        
        if (![currentText writeToFile:currentPath atomically:YES encoding:NSUTF8StringEncoding error:&error])
        {
            NSLog(@"saveText = Whoops, that did not work: %@", [error description]);
        }
     //    NSLog(@"303 - end");

    }


}


-(void)savePost:(JBPost *)currentPost
{

//    NSLog(@"savePost");
    NSString *currentPath = [currentPost path];
    NSString *currentText = [currentPost text];
        
    NSError *error;
    
    if (![currentText writeToFile:currentPath atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"savePost = Whoops, that did not work: %@", [error description]);
    }
}


-(void)saveAllPosts
{
 //   NSLog(@"201 - about to save all posts");
    // Save the current post text.
    [self saveText];

    for(JBPost *currentPost in [markdownFilesArrayContoller arrangedObjects])
    {
        [self savePost:currentPost];
    }

    
}

- (IBAction)newPost:(id)sender
{
    [mainWindow makeKeyAndOrderFront:self];
    
    for(NSWindow* win in [NSApp windows])
    {
        if([win isMiniaturized])
        {
            [win deminiaturize:self];
        }
    }
    
    if ((![[markdownFilesArrayContoller arrangedObjects] count]) > 0)
    {
        [windowController loadTextEditor:self]; 
    }
    

    JBPost *newPost = [[JBPost alloc] init];
    [newPost setDate:[NSDate date]];
    [markdownFilesArrayContoller addObject:newPost];
    
    if ([windowController previewShown])
    {
        [windowController togglePreview:self];
    }
    
    //    [myWindowController loadTextEditor:nil];
    [markdownFilesArrayContoller rearrangeObjects];
    
    [self performSelector:@selector(saveText) withObject:nil afterDelay:5.0];
    
    [deletePostMenuItem setEnabled:YES];
    [mainWindow makeFirstResponder:mainTextView];
    
}

-(IBAction)deletePost:(id)sender
{
    NSString *currentText = [mainTextView string];
    if(currentText == (id) [NSNull null] || [currentText length]==0 || [currentText isEqual:@""])
    {
        [markdownFilesArrayContoller removeObject:[[markdownFilesArrayContoller selectedObjects] objectAtIndex:0]];
    } else {
        
        // Setup a few strings
        NSString *okString = NSLocalizedString(@"OK", nil);
        NSString *cancelString = NSLocalizedString(@"Cancel", nil);
        NSString *areYouSure = NSLocalizedString(@"areYouSure", nil);
        NSString *deletePostString = NSLocalizedString(@"DeletePost", nil);
        
        
        NSString *jbConfirmDeleteScoutKey = @"jbConfirmDeleteScoutKey";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // Get the post to delete
        JBPost *currentPost = [[markdownFilesArrayContoller selectedObjects] objectAtIndex:0];
        
        
        // Check to see if alerts are suppressed
        if ([defaults boolForKey:jbConfirmDeleteScoutKey])
        {
            //NSLog(@"Deleting post without confirmation");
            NSString *currentPath = [currentPost path];
            NSFileManager* fm = [[NSFileManager alloc] init];
            NSError* err = nil;
            
            [fm removeItemAtPath:currentPath error:&err];
            if (err) {
                NSLog(@"oops: %@", err);
            }
            
            
            [markdownFilesArrayContoller removeObject:currentPost];
            
        } else {
            
            // Create the alert and show it
            
            
            NSAlert* alert = [NSAlert new];
            NSArray *a = [markdownFilesArrayContoller selectedObjects];
            NSObject *b = [a objectAtIndex:0];
            
            
            [alert setInformativeText: areYouSure];
            [alert setMessageText: [NSString stringWithFormat: @"%@ %@",deletePostString, [b valueForKey:@"title"]]];
            [alert addButtonWithTitle:okString];
            [alert addButtonWithTitle:cancelString];
            [alert setShowsSuppressionButton:YES];
            [alert setAlertStyle:NSCriticalAlertStyle];
            
            // Show the alert
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // Do the delete
                NSString *currentPath = [currentPost path];
                NSFileManager* fm = [[NSFileManager alloc] init];
                NSError* err = nil;
                
                [fm removeItemAtPath:currentPath error:&err];
                if (err) {
                    NSLog(@"oops: %@", err);
                }
                
                
                [markdownFilesArrayContoller removeObject:currentPost];
                [mainTableView reloadData];
                
            }
            
            if ([[alert suppressionButton] state] == NSOnState)
            {
                // Suppress this alert from now on.
                [defaults setBool:YES forKey:jbConfirmDeleteScoutKey];
            }
            
        }
        
        
        if ((![[markdownFilesArrayContoller arrangedObjects] count]) > 0)
        {
            NSLog(@"No more posts, disable the menu items.");
            [previewMenuItem setEnabled:NO];
            [deletePostMenuItem setEnabled:NO];
            [publishMenuItem setEnabled:NO];
            [windowController setEmptyPostsView];            
        }
        

    }
}

- (BOOL) application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    NSString *extension = [filename pathExtension];
    
    if ([extension isEqualToString:@"paragraphslicense"])
    {
      //  NSLog(@"License file, process");
        
//        JBChecker *newChecker = [[JBChecker alloc] init];
//        
//        if ([newChecker licenseCheck:filename])
//        {
        //  NSLog(@"OK, got a license, so launch the preferences and select the license tab");
            
//            CFURLRef filePathUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filename, NULL, NO);
//            NSLog(@"filePathUrl = %@", filePathUrl);

            
            NSString *filePrefix = @"file:/";
            NSString *fullFilePath = [filePrefix stringByAppendingString:filename];
          //  NSLog(@"fullFilePath: %@", fullFilePath);
            fullFilePath = [fullFilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          //  NSLog(@"fullFilePath2: %@", fullFilePath);

            NSURL *appSupportPath;
            
            
            JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
            
            
            NSString *path;
                        
            path = [appSupDir applicationSupportDirectory];            
            
            appSupportPath = [NSURL fileURLWithPath:path];
            
            
            NSURL *fullPath = [appSupportPath URLByAppendingPathComponent:[filename lastPathComponent]];
         //   NSLog(@"Source = %@", [[NSURL alloc] initFileURLWithPath:filename]);
         //   NSLog(@"Destination = %@", fullPath);
            
            NSError *error = nil;
            
            if ([[NSFileManager defaultManager] copyItemAtURL:[[NSURL alloc] initFileURLWithPath:filename] toURL:fullPath error:&error])
            {
           //     NSLog(@"Copied license file over");
                // OK, now pop open the preferences, and the new license should be there. If the preferences are already open... then what?
                
                [windowController togglePrefs:@"openLicense"];
                NSUserNotification *notification = [[NSUserNotification alloc] init];
                notification.title = @"Paragraphs Licensed!";
                notification.informativeText = @"Thank you for registering Paragraphs. All restrictions have been removed, enjoy!";
                notification.soundName = NSUserNotificationDefaultSoundName;
                
                [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];

                if (![[NSFileManager defaultManager] removeItemAtPath:filename error:&error])
                {
                    NSLog(@"Could not remove old license file");
                }
                
                return YES;
            }
            else
            {
             //   NSLog(@"copy of license failed");
                [[NSAlert alertWithError:error] runModal];
                
                return NO;
            }


//        }
        
        
        
        return YES;
    }
    
    
    if ([extension isEqualToString:@"ptf"])
    {
        JBScoutTemplateController *importTemplateController = [[JBScoutTemplateController alloc] init];
        
        if ([importTemplateController importFromFile:filename])
        {
            [windowController toggleThemeChooser:self];
            
            return YES;
        } else {
            return NO;
        }

    }

    if ([extension isEqualToString:@"pts"])
    {
        JBScoutTemplateController *importTemplateController = [[JBScoutTemplateController alloc] init];
        
        if ([importTemplateController importFromFile:filename])
        {
            [windowController toggleThemeChooser:self];
            
            return YES;
        } else {
            return NO;
        }
        
    }

    return NO;
}

- (IBAction)enablePreview:sender
{
    [previewMenuItem setEnabled:YES];
    [publishMenuItem setEnabled:YES];
}

- (IBAction)disablePreview:sender
{
    [previewMenuItem setEnabled:NO];
    [publishMenuItem setEnabled:NO];

}

- (IBAction)showMainWindow:(id)sender
{
    [mainWindow makeKeyAndOrderFront:nil];
    
}


#pragma mark textview delegate methods

- (void)textDidChange:(NSNotification *)aNotification
{
    if([mainTextView string]==(id) [NSNull null] || [[mainTextView string] length]==0 || [[mainTextView string]isEqual:@""])
    {
        [self disablePreview:nil];
    } else {
        [self enablePreview:nil];
    }
}

- (void)textDidEndEditing:(NSNotification *)aNotification
{
    [self saveText];
}


- (BOOL)textView:(NSTextView *)aTextView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex
{
//    NSLog(@"clickedOnLink %@", link);
    if ([link rangeOfString:@"file:/"].location != NSNotFound)
    {
//        NSLog(@"Link is a local file");

        link = [link stringByReplacingOccurrencesOfString:@"file:" withString:@""];

        NSImage *currentImage = [[NSImage alloc] initWithContentsOfFile:link];
        
        NSRect newRect = [mainTextView firstRectForCharacterRange:NSMakeRange(charIndex, 0)];

        NSRect finalRect = [mainWindow convertRectFromScreen:newRect];
        
        NSPoint newPoint;
        newPoint.x = finalRect.origin.x;
        newPoint.y = finalRect.origin.y;
        
        NSScreen *mainScreen = [NSScreen mainScreen];
        NSRect screenRect = [mainScreen visibleFrame];
        NSUInteger screenHeight = screenRect.size.height;

        NSUInteger maxPosition;
        
        if (([mainWindow styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask)
        
        {
            maxPosition = newRect.origin.y + 160;
        } else {
            maxPosition = newRect.origin.y + 95;

        }
        
        
        if (screenHeight > maxPosition)
        {
            [self toggleWindow:currentImage atPoint:newPoint flipped:YES];
        } else {
            [self toggleWindow:currentImage atPoint:newPoint flipped:NO];

        }
        
        return YES;
    }

    return NO;
}


- (void)toggleWindow:(NSImage *)previewImage atPoint:(NSPoint)myPoint flipped:(BOOL)flipped
{
    if (!attachedWindow)
    {
        NSPoint buttonPoint = myPoint;
        
        
        if (flipped)
        {
            attachedWindow = [[MAAttachedWindow alloc] initWithView:view
                                                    attachedToPoint:buttonPoint
                                                           inWindow:mainWindow
                                                             onSide:3
                                                         atDistance:15.0];

        } else {
            attachedWindow = [[MAAttachedWindow alloc] initWithView:view
                                                    attachedToPoint:buttonPoint
                                                           inWindow:mainWindow
                                                             onSide:1
                                                         atDistance:1.0];

        }
        
        [attachedWindow setBorderWidth:0];
        [attachedWindow setHasArrow:YES];
        [attachedWindow setDrawsRoundCornerBesideArrow:YES];
        
        [myImageView setImage:previewImage];
        [mainWindow addChildWindow:attachedWindow ordered:NSWindowAbove];
        [attachedWindow makeKeyAndOrderFront:nil];
    } else {
        [mainWindow removeChildWindow:attachedWindow];
        [attachedWindow orderOut:self];
        attachedWindow = nil;
    }
}

- (IBAction)closeMAWindow:(id)sender;
{
    [mainWindow removeChildWindow:attachedWindow];
    [attachedWindow orderOut:self];
    attachedWindow = nil;
}

- (void)boundsDidChangeNotification:(NSNotification *)notification
{
    [self closeMAWindow:nil];
}


#pragma mark Directory Observer Delegate Methods

//- (void)observedDirectory:(NSURL*)observedURL childrenAtURLDidChange:(NSURL*)changedURL historical:(BOOL)historical resumeToken:(ArchDirectoryObservationResumeToken)resumeToken
//{
//    NSLog(@"Files in %@ have changed!", changedURL.path);
//    
//    JBDropboxSync *syncCheck = [[JBDropboxSync alloc] init];
//    
//    // OK, we know something changed, and we know what file changed, now we need to figure out what to do about it.
//    
//    // If the file was not removed, check to see if it is new or not.
//    
//    // If the file is new, add it to Scout.
//    
//    NSMutableDictionary *postStatus = [syncCheck postStatus:[markdownFilesArrayContoller arrangedObjects] checkPost:changedURL.path];
//    
//    NSString *newPostStatus = [postStatus objectForKey:@"newPost"];
//    NSString *removePostStatus = [postStatus objectForKey:@"removePost"];
//    
//    if ([newPostStatus isEqualToString:@"YES"])
//    {
//        JBPost *newSyncedPost = [syncCheck postFromString:changedURL.path];
//        [markdownFilesArrayContoller addObject:newSyncedPost];
//        [markdownFilesArrayContoller rearrangeObjects];
//        [mainTableView reloadData];
//        
//        NSString *infoText = [NSString stringWithFormat:@"The post titled %@ was added to your library", [newSyncedPost title]];
//
//        NSUserNotification *notification = [[NSUserNotification alloc] init];
//        notification.title = @"New Post Synced From Dropbox!";
//        notification.informativeText = infoText;
//        notification.soundName = NSUserNotificationDefaultSoundName;
//        
//        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
//    }
//
//    
//    
//    if ([removePostStatus isEqualToString:@"YES"])
//    {
//        // OK, a file is missing. We will figure out which one it is and remove it.
//        
//        NSUInteger indexOfPostToRemove = [syncCheck indexOfPostToRemove:[markdownFilesArrayContoller arrangedObjects] withString:changedURL.path];
//        
//        if (indexOfPostToRemove)
//        {
//            NSLog(@"INdex of post to remove: %lu", (unsigned long)indexOfPostToRemove);
//            JBPost *postToRemove = [[markdownFilesArrayContoller arrangedObjects] objectAtIndex:indexOfPostToRemove];
//            NSString *infoText = [NSString stringWithFormat:@"The post titled %@ was removed from your library", [postToRemove title]];
//
//            [markdownFilesArrayContoller removeObjectAtArrangedObjectIndex:indexOfPostToRemove];
//            [markdownFilesArrayContoller rearrangeObjects];
//            [mainTableView reloadData];
//            
//            
//            
//            NSUserNotification *notification = [[NSUserNotification alloc] init];
//            notification.title = @"Syncronization Complete!";
//            notification.informativeText = infoText;
//            notification.soundName = NSUserNotificationDefaultSoundName;
//            
//            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
//
//        }
//
//    }
//
//    
//    // If the file is not new, check to see if it is being edited right now.
//    
//    // If the file is being edited... I don't know what to do here.... Maybe a new UI that shows the new file...
//    
//    // If the file is not being edited, update the JBPost object with the new data.
//    
//    if ([newPostStatus isEqualToString:@"NO"])
//    {
//        if ([removePostStatus isEqualToString:@"NO"])
//        {
//            NSLog(@"Update an existing post");
//            // Update an existing post
//            
//            NSUInteger indexOfPostToUpdate = [syncCheck indexOfPostToRemove:[markdownFilesArrayContoller arrangedObjects] withString:changedURL.path];
//            JBPost *postToUpdate = [syncCheck postFromString:changedURL.path];
//            JBPost *existingPost = [[markdownFilesArrayContoller arrangedObjects] objectAtIndex:indexOfPostToUpdate];
//
//            [existingPost setDate:[postToUpdate date]];
//            [existingPost setTitle:[postToUpdate title]];
//            [existingPost setText:[postToUpdate text]];
//
//            [markdownFilesArrayContoller rearrangeObjects];
//            [mainTableView reloadData];
//        }
//
//    }
//
//    
//    
//    // Easy, right? :)
//    
//}
//
//- (void)observedDirectory:(NSURL*)observedURL descendantsAtURLDidChange:(NSURL*)changedURL reason:(ArchDirectoryObserverDescendantReason)reason historical:(BOOL)historical resumeToken:(ArchDirectoryObservationResumeToken)resumeToken {
//    NSLog(@"Descendents below %@ have changed!", changedURL.path);
//}
//
//- (void)observedDirectory:(NSURL*)observedURL ancestorAtURLDidChange:(NSURL*)changedURL historical:(BOOL)historical resumeToken:(ArchDirectoryObservationResumeToken)resumeToken {
//    NSLog(@"%@, ancestor of your directory, has changed!", changedURL.path);
//}
//
//
//-(void)checkFileAgainstCache:(NSString *)path
//{
//    NSLog(@"Check this file: %@", path);
//    
//}


#pragma mark AppleScript

-(void)newPost
{
    [self newPost:self];
}


#pragma mark bookmarklet

- (void)handleGetURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    
//    NSLog(@"Called!");
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    
    if ([url rangeOfString:@"paragraphs:url=" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSLog(@"New Post From Web Page: %@", url);
        NSString *title;
        NSString *text;
        NSString *link;
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:url];
        [scanner scanUpToString:@"http:" intoString:NULL];
        [scanner scanUpToString:@"title=" intoString:&link];
        [scanner scanUpToString:@"text=" intoString:&title];
        [scanner scanUpToString:@"\n" intoString:&text];
        
        title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        title = [title stringByReplacingOccurrencesOfString:@"title=" withString:@""];

        text = [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        text = [text stringByReplacingOccurrencesOfString:@"text=" withString:@""];
        
//        NSLog(@"Link = %@", link);
//        NSLog(@"Title = %@", title);
//        NSLog(@"Text = %@", [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        
        
        NSString *textPartOne = [title stringByAppendingString:@"\n\n[Jump to Post]("];
        NSString *textPartOnePointOne = [textPartOne stringByAppendingString:link];
        NSString *textPartOnePointTwo = [textPartOnePointOne stringByAppendingString:@")\n\n>"];
        NSString *textPartFour = [textPartOnePointTwo stringByAppendingString:text];
        NSString *textPartFive = [textPartFour stringByAppendingString:@"\n\n"];
        
        
        
        JBPost *post = [markdownFilesArrayContoller newObject];
        
        post.title = title;
        post.text = textPartFive;
        post.date = [NSDate date];
        
        [markdownFilesArrayContoller addObject:post];
        [markdownFilesArrayContoller rearrangeObjects];
        [mainTableView reloadData];
        
    }
    
}
- (IBAction)checkForUpdates:(id)sender
{
//#ifndef MAC_APP_STORE
//	[[SUUpdater sharedUpdater] checkForUpdates:sender];
//#endif

}




@end



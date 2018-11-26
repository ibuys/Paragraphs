//
//  JBWindowController.m
//  Scout
//
//  Created by Jon Buys on 12/21/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBWindowController.h"
#import "JBFirstRunViewController.h"
#import "JBPost.h"
#import "JBSiteExport.h"
#import "JBAppController.h"
#import "JBSplitView.h"
#import "JBMediaManagerController.h"

@implementation JBWindowController

- (id)init {
    self = [super init];
    if( self != nil ) {
        // Do my quick initialization here

    }
    return self;
}

- (void)awakeFromNib
{
    [mainWindow setRestorable:YES];
}

#pragma mark First Launch
- (void)loadFirstLaunch
{
    
   // NSLog(@"First launch, load the JBFirstRunViewController");
    [mainWindow setStyleMask:[mainWindow styleMask] & ~NSResizableWindowMask];

    NSWindowCollectionBehavior behavior = [mainWindow collectionBehavior];
    behavior ^= NSWindowCollectionBehaviorFullScreenPrimary;
    [mainWindow setCollectionBehavior:behavior];

    if (![NSBundle loadNibNamed:@"First Run View" owner:self])
    {
        NSLog(@"Error loading Xib for First Run View!");
        
    } else {
        [mainToolBar setVisible:NO];
        [showLibraryButton setEnabled:NO];
        [previewButton setEnabled:NO];
        [newPostButton setEnabled:NO];

        [showLibraryButton setHidden:YES];
        [previewButton setHidden:YES];
        [newPostButton setHidden:YES];

        [firstRunView setFrame:[mainView frame]];
        [mainView setSubviews:[NSArray arrayWithObject:firstRunView]];
        NSLog(@"We should have the first run view now.");
    }
}


- (IBAction)finishFirstRun:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"useSerif"];

    NSError *error;
    NSString *pathToFirstPost = [[NSBundle mainBundle] pathForResource:@"first_post" ofType:@"md"];
    NSString *firstPostText = [NSString stringWithContentsOfFile:pathToFirstPost encoding:NSUTF8StringEncoding error:&error];

    
    [showLibraryButton setEnabled:YES];
    [previewButton setEnabled:YES];
    [newPostButton setEnabled:YES];
    
    [showLibraryButton setHidden:NO];
    [previewButton setHidden:NO];
    [newPostButton setHidden:NO];

    NSWindowCollectionBehavior behavior = [mainWindow collectionBehavior];
    behavior |= NSWindowCollectionBehaviorFullScreenPrimary;
    [mainWindow setCollectionBehavior:behavior];

    JBPost *post = [[JBPost alloc] initWithTitle:@"First Post" andText:firstPostText andPath:@"" andDate:[NSDate date]];
    [postArrayController addObject:post];
    
    
    transition = [CATransition animation];
    [transition setType:kCATransitionFade];
  //  [transition setSubtype:kCATransitionFromLeft];
    [transition setDuration:0.40];
    NSDictionary *ani = [NSDictionary dictionaryWithObject:transition forKey:@"subviews"];


    [mainView setAnimations:ani];
    

    
    [mainSplitView setFrame:[mainView frame]];
    [mainTextEditorView setFrame:[rightSplitView frame]];
  
    [mainView setWantsLayer:YES];
    
  //  [mainView setSubviews:[NSArray arrayWithObject:mainSplitView]];
    
    [rightSplitView setSubviews:[NSArray arrayWithObject:mainTextEditorView]];
    
    [mainWindow makeFirstResponder:mainTextView];
    [mainWindow setStyleMask:[mainWindow styleMask] | NSResizableWindowMask];
    [[mainView animator] replaceSubview:[[mainView subviews] objectAtIndex:0] with:mainSplitView];

    [myAppController normalStart];
    
}

#pragma mark Normal Run

- (void)normalStart
{
    [mainSplitView setFrame:[mainView frame]];
    [mainTextEditorView setFrame:[rightSplitView frame]];
    [mainView setWantsLayer:YES];
    [mainView setSubviews:[NSArray arrayWithObject:mainSplitView]];
    [rightSplitView setSubviews:[NSArray arrayWithObject:mainTextEditorView]];
    [mainWindow makeFirstResponder:mainTextView];

}

- (BOOL)loadView:(NSView *)viewToLoad intoView:(NSView *)parentView
{
    
    [viewToLoad setFrame:[parentView frame]];
    transition = [CATransition animation];
    
    NSImageView *myImageView = [[NSImageView alloc] init];
    
    if ([viewToLoad isEqual:mainTextEditorView])
    {
        NSImage *image = [[NSImage alloc] initWithData:[mainTextEditorView dataWithPDFInsideRect:[mainTextEditorView bounds]]];
//        NSPDFImageRep *imgRep = [[image representations] objectAtIndex: 0];
//        NSData *data = [imgRep PDFRepresentation];
//        JBAppSupportDir *myAppSupDir = [[JBAppSupportDir alloc] init];
//        NSString *scoutDir = [[myAppSupDir applicationSupportDirectory] stringByAppendingString:@"/file.pdf"];
//        
//        [data writeToFile:scoutDir atomically: NO];
        
        [myImageView setFrame:[mainTextEditorView frame]];
        [myImageView setImage:image];
        NSView *tempView = [[mainTextEditorView subviews] objectAtIndex:0];
        
        [mainTextEditorView replaceSubview:tempView with:myImageView];

        [transition setType:kCATransitionReveal];

        [transition setSubtype:kCATransitionFromBottom];
        [transition setDuration:0.35];
        
        NSDictionary *ani = [NSDictionary dictionaryWithObject:transition forKey:@"subviews"];
        [parentView setAnimations:ani];
        
        [[parentView animator] replaceSubview:[[parentView subviews] objectAtIndex:0] with:viewToLoad];
        [mainTextEditorView replaceSubview:myImageView with:tempView];


    } else {
        [transition setType:kCATransitionMoveIn];

        [transition setSubtype:kCATransitionFromTop];
        [transition setDuration:0.35];
        
        NSDictionary *ani = [NSDictionary dictionaryWithObject:transition forKey:@"subviews"];
        [parentView setAnimations:ani];
        
        [[parentView animator] replaceSubview:[[parentView subviews] objectAtIndex:0] with:viewToLoad];

    }
    
    

    return NO;
}

- (void)setEmptyPostsView
{
    if (![NSBundle loadNibNamed:@"Empty Posts" owner:self])
    {
        NSLog(@"Error loading Xib for Empty Posts!");
        
    } else {

        [self loadView:emptyPostsView intoView:rightSplitView];
    }
}



#pragma mark Media Manager

- (BOOL)mediaManagerShown
{
    return mediaManagerShown;
}

- (IBAction)toggleMediaManager:(id)sender
{

    if (mediaManagerShown)
    {
        [showMediaMenuItem setTitle:@"Show Media Manager"];
        [mediaManagerPanel close];
        mediaManagerShown = NO;

    } else {
        
        if (![NSBundle loadNibNamed:@"Media Manager View" owner:self])
        {
            NSLog(@"Error loading Xib for Media Manager View!");
            
        } 

        [mediaManagerPanel makeKeyAndOrderFront:self];        
        [mainWindow makeFirstResponder:mediaBrowser];
        [showMediaMenuItem setTitle:@"Close Media Manager"];

        mediaManagerShown = YES;
        
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    
    if ([[notification object] isEqual:mediaManagerPanel])
    {
        [showMediaMenuItem setTitle:@"Show Media Manager"];
        mediaManagerShown = NO;

    }
    
}

- (void) addImageWithPath:(NSString *) path
{
    [mediaManager addImageWithPath:path];
}


#pragma mark Prefrences

- (IBAction)togglePrefs:(id)sender
{
    if (!prefsWindow)
	{
		[NSBundle loadNibNamed:@"Prefs" owner:self];
	}
    
    if( [sender respondsToSelector:@selector(isEqualToString:)] )
    {

        if ([sender isEqualToString:@"openLicense"])
        {
            [prefsController launchLicense];

        }
    
    } else {
        
        [prefsWindow makeKeyAndOrderFront:self];
    }
    
}

- (IBAction)doneEditPrefs:(id)sender
{
	[prefsWindow orderOut:nil];
	[self prefsPanelWillClose];
}


- (void)prefsPanelWillClose;
{
   // NSLog(@"prefsPanelWillClose");
}

- (IBAction) styleSelected:(id)sender
{
    NSLog(@"styleSelected: %@", [[stylePopUpButton selectedItem] title]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[[stylePopUpButton selectedItem] title] forKeyPath:@"textEditorTheme"];
    [myAppController setTextView1Styles:[[stylePopUpButton selectedItem] title]];
}

#pragma mark Preview


- (void)setTextEditorFromPreview
{
    
    if (wasLibraryOpen)
    {
        [splitViewController toggleLeftView:self];
    }
    
    [self loadView:mainTextEditorView intoView:rightSplitView];
    previewShown = NO;
    [mainWindow makeFirstResponder:mainTextView];
    
    [showLibraryMenuItem setEnabled:YES];
    [showLibraryButton setEnabled:YES];

    [showMediaMenuItem setEnabled:YES];
    [showThemesMenuItem setEnabled:YES];
    
    [previewPostMenuItem setTitle:@"Preview Post"];
    
    if ([previewPostSegmentedControl selectedSegment] == 1)
    {
        [previewPostSegmentedControl setSelectedSegment:0];
    }
    

}

- (void)setPreviewFromTextEditor
{
    JBPost *currentPost = [[postArrayController selectedObjects] objectAtIndex:0];
    [currentPost setText:[mainTextView string]];

    [self setPreviewFromTextEditor:currentPost];

}

- (void)setPreviewFromTextEditor:(JBPost *)currentPost
{
    
    
    if (previewShown)
    {
        
    } else {
        
        BOOL tabViewCollapsed = [mainSplitView isSubviewCollapsed:[[mainSplitView subviews] objectAtIndex: 0]];

        //    NSLog(tabViewCollapsed ? @"Yes" : @"No");
        
        if (tabViewCollapsed)
        {
            //        NSLog(@"Library Was Not Open");
            wasLibraryOpen = NO;
            
            //            [splitViewController uncollapseTabView];
            //            [showLibraryMenuItem setTitle:@"Hide Library"];
        } else {
            //        NSLog(@"Library Was Open");
            
            [splitViewController toggleLeftView:self];
            wasLibraryOpen = YES;
            [showLibraryMenuItem setTitle:@"Show Library"];
            
            
        }
        
        
        [showLibraryMenuItem setEnabled:NO];
        [showLibraryButton setEnabled:NO];
        
        [showMediaMenuItem setEnabled:NO];
        [showThemesMenuItem setEnabled:NO];
        
        [previewPostMenuItem setTitle:@"End Preview"];
        
        if (![NSBundle loadNibNamed:@"Preview" owner:self])
        {
            NSLog(@"Error loading Xib for Preview!");
            
        } else {
            
            [appDelegate closeMAWindow:nil];
            [self loadView:previewView intoView:rightSplitView];
            
            [appDelegate saveText];
            
            
            
//            JBPost *currentPost = [[postArrayController selectedObjects] objectAtIndex:0];
            
            JBPost *copyOfPost = [[JBPost alloc] init];
            
            
            [copyOfPost setTitle:[currentPost title]];
            //        NSLog(@"copyOfPost Title = %@", [copyOfPost title]);
            //        NSLog(@"currentPost Title = %@", [currentPost title]);
            
            [copyOfPost setPath:[currentPost path]];
            //        NSLog(@"copyOfPost Path = %@", [copyOfPost path]);
            //        NSLog(@"currentPost Path = %@", [currentPost path]);
            
            [copyOfPost setDate:[currentPost date]];
            //        NSLog(@"copyOfPost Date = %@", [copyOfPost date]);
            //        NSLog(@"currentPost Date = %@", [currentPost date]);
            
            
            // NSLog(@"before = %@", [copyOfPost text]);
            [copyOfPost setText:[currentPost text]];
//            [currentPost setText:[mainTextView string]];
            
            // NSLog(@"after = %@", [copyOfPost text]);
            
            NSString *firstLine;
            
            NSScanner* scanner = [NSScanner scannerWithString:[currentPost text]];
            [scanner scanUpToString:@"\n" intoString:&firstLine];
            NSString *firstLineStripped = [[copyOfPost text] substringFromIndex:[firstLine length]];
            
            [copyOfPost setText:firstLineStripped];
            
            [previewController previewText:copyOfPost];
            
            previewShown = YES;
            
            if ([previewPostSegmentedControl selectedSegment] == 0)
            {
                [previewPostSegmentedControl setSelectedSegment:1];
            }
            
        }

    }

}

- (IBAction)togglePreview:(id)sender
{
    if (previewShown)
    {
        [self setTextEditorFromPreview];
        [mainTextView setSelectedRange:savedRange];
        [mainTextView scrollRangeToVisible:savedRange];

        
    } else {
        
        savedRange = [mainTextView selectedRange];
        
        JBPost *currentPost = [[postArrayController selectedObjects] objectAtIndex:0];
        [currentPost setText:[mainTextView string]];

        [self setPreviewFromTextEditor:currentPost];

    }
}
- (IBAction)showReleaseNotes:(id)sender
{
    NSURL *launchURL = [NSURL URLWithString:@"http://farmdog.co/paragraphs/releasenotes.html"];
	
	if (launchURL == nil)
	{
		NSLog(@"launchURL is nil");
	}
	
	//NSLog(@"launchURL = %@", launchURL);
    
	NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
	[workSpace openURL:launchURL];
}


- (BOOL)previewShown
{
    return previewShown;
}

#pragma mark Theme Chooser


- (IBAction)toggleThemeChooser:(id)sender
{
   // NSLog(@"Toggle Theme Chooser");
    
    if (themeChooserViewShown)
    {
        [themeChooserPanel close];
        [showThemesMenuItem setTitle:@"Show Theme Chooser"];

        themeChooserViewShown = NO;
        
    } else {
        if (![[NSBundle mainBundle] loadNibNamed:@"Theme Chooser" owner:self topLevelObjects:nil])
        {
            NSLog(@"Error loading Xib for Theme Chooser!");            
        }

        [themeChooserPanel makeKeyAndOrderFront:self];
        [showThemesMenuItem setTitle:@"Close Theme Chooser"];
        themeChooserViewShown = YES;
    }
}



# pragma mark TextEditor

- (IBAction)loadTextEditor:(id)sender
{
    [self loadView:mainTextEditorView intoView:rightSplitView];
    [mainWindow makeFirstResponder:mainTextView];
}

# pragma mark glue methods

- (void)dropFromMediaManager:(NSString *)fileToUse
{
    [mainTextView dropFromMediaManager:fileToUse];
  //  [self toggleMediaManager:nil];
}


- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if (menuItem == previewPostMenuItem)
    {
        if([mainTextView string]==(id) [NSNull null] || [[mainTextView string] length]==0 || [[mainTextView string]isEqual:@""])
        {
            return NO;
        } else {
            return YES;
        }
        
    } else {
        return YES;
    }
}


@end



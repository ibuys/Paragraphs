//
//  JBAppController.m
//  Scout
//
//  Created by Jon Buys on 12/21/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBAppController.h"
#import "JBAppSupportDir.h"
#import "JBPost.h"
#import "JBJekyllImporter.h"
#import "JBAppDelegate.h"
#import "JBColorWithHex.h"
#import "JBFormdTaskController.h"
#import "NSWindow+TitleButtons.h"
#import "NSWindow+FullScreen.h"
#import "JBvOnePointOne.h"

@implementation JBAppController


- (void)awakeFromNib
{
        
//    [mainWindow addViewToTitleBar:libraryButton atXPosition:70];
//    [mainWindow addViewToTitleBar:newPostButton atXPosition:100];
//    [mainWindow addViewToTitleBar:publishProgressIndicator atXPosition:130];
//
//    [mainWindow addViewToTitleBar:previewButton atXPosition:mainWindow.frame.size.width - previewButton.frame.size.width - 30];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"firstLaunch"])
    {

        [myWindowController loadFirstLaunch];
    } else {
        
        if (![defaults boolForKey:@"version1.0.1"])
        {
            JBvOnePointOne *onePone = [[JBvOnePointOne alloc] init];
            [onePone newVersionRun];
        }
        
        
        [myWindowController normalStart];
        [self normalStart];
    }
}

- (void)normalStart
{
    
    [self loadPostArray];
    
    if ([[postArrayController arrangedObjects] count] == 0)
    {
       // NSLog(@"Nothing in the array controler");
        JBPost *newPost = [postArrayController newObject];
        [newPost setDate:[NSDate date]];
        [postArrayController addObject:newPost];
        [postList reloadData];
        NSIndexSet *rowIndex = [NSIndexSet indexSetWithIndex: 0];
        [postList selectRowIndexes:rowIndex byExtendingSelection:NO];
    }

    [self disableFancyFeaturesInTextView:mainTextEditorView];
    
    
    hl1 = [[HGMarkdownHighlighter alloc] initWithTextView:mainTextEditorView];
	hl1.makeLinksClickable = YES;
    hl1.parseAndHighlightAutomatically = YES;
    [hl1 activate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults boolForKey:@"useSerif"])
    {
        [mainTextEditorView setFont:[NSFont fontWithName:@"Courier Prime" size:14]];
        [defaults setBool:YES forKey:@"useSerif"];
        [setFontMenuItem setTitle:@"Use Sans-serif Font"];
    } else {
        [mainTextEditorView setFont:[NSFont fontWithName:@"mplus-1c-regular" size:14]];
        [defaults setBool:NO forKey:@"useSerif"];
        [setFontMenuItem setTitle:@"Use Serif Font"];
    }
    
    if ([[defaults valueForKey:@"textEditorTheme"] length] > 0)
    {
        [self setTextView1Styles:[defaults valueForKey:@"textEditorTheme"]];
    } else {
        [self setTextView1Styles:@"Default"];
        
    }
    
    

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    [postList setSortDescriptors:[NSArray arrayWithObject:sort]];
    

    [self performSelector:@selector(highlightNow) withObject:nil afterDelay:0.01];
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *postPath = [path stringByAppendingPathComponent:@"posts"];
    [self setMarkdownDirectory:postPath];
    [postList reloadData];
//    [postList selectRowIndexes:0 byExtendingSelection:NO];
    [mainWindow makeFirstResponder:mainTextEditorView];


    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [postList selectRowIndexes:indexSet byExtendingSelection:NO];

}

- (void)loadPostArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
   // markdownDirectory = [defaults valueForKey:@"markdownDirectory"];
    JBAppSupportDir *myAppSupDir = [[JBAppSupportDir alloc] init];

    NSString *scoutDir;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        scoutDir = [myAppSupDir dropboxDir];
        
        
    } else {
        scoutDir = [myAppSupDir applicationSupportDirectory];
        
    }
    
    
    
    
    markdownDirectory = [scoutDir stringByAppendingPathComponent:@"posts"];

    
    // NSLog(@"markdownDirectory to read through: %@", markdownDirectory);
    
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:markdownDirectory];

    
    NSString *file;
    NSString *dateString;
    NSDate *thisPostDate;
    
    while (file = [dirEnum nextObject])
    {
        if ([[file pathExtension] isEqualToString: @"markdown"])
        {
            // process the document
            //  NSLog(@"I found this file: %@", file);
            
            
            NSRange splitterRange = [file rangeOfString:@"##"];
            if (splitterRange.location != NSNotFound)
            {
                NSScanner* scanner = [NSScanner scannerWithString:file];
                [scanner scanUpToString:@"##" intoString:&dateString];
                //     NSLog(@"dateString: %@", dateString);
                
                
                NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
                NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                
                [myDateFormatter setLocale:enUSPOSIXLocale];
                [myDateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-SSSS"];
                thisPostDate = [myDateFormatter dateFromString:dateString];
                
            }
            
            
            
            
            
            
            
            
            
            NSError *error;
            NSString *titleString;
            NSString *tmpText = [NSString stringWithContentsOfFile:[markdownDirectory stringByAppendingPathComponent:file] encoding:NSUTF8StringEncoding error:&error];
            
            NSRange range = [tmpText rangeOfString:@"title: "];
            
            if (range.location != NSNotFound)
            {
                NSScanner* scanner = [NSScanner scannerWithString:tmpText];
                [scanner scanUpToString:@"title: " intoString:NULL];
                [scanner scanUpToString:@"\n" intoString:&titleString];
                
                titleString = [titleString stringByReplacingOccurrencesOfString:@"title: " withString:@""];
            } else {
                NSScanner* scanner = [NSScanner scannerWithString:tmpText];
                [scanner scanUpToString:@"\n" intoString:&titleString];
                
            }
            
            
            JBPost *post = [[JBPost alloc]initWithTitle:titleString andText:tmpText andPath:[markdownDirectory stringByAppendingPathComponent:file] andDate:thisPostDate];
            
            // NSLog(@"Post Title: %@", [post title]);
            [postArrayController addObject:post];
        }
    }
    
    //  NSLog(@"In the array: %@", [markdownFilesArrayContoller arrangedObjects]);
    [postList reloadData];
    
}

- (void)setMarkdownDirectory:(NSString *)path
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:path forKey:@"markdownDirectory"];
    //    NSLog(@"Just set %@ as the markdownDirectory", path);
    
    //  NSLog(@"rootSaveDirectory in setMarkdownDirectory: %@", path);
    
}
- (void)hlDeactivate
{
    [hl1 deactivate];
}

- (void)hlActivate
{
    [hl1 activate];
}

- (void)highlightNow
{
    [hl1 parseAndHighlightNow];
}

- (void)clearHighlighting
{
    [hl1 clearHighlighting];
}

- (void)readClearTextStylesFromTextView
{
    [hl1 readClearTextStylesFromTextView];
}

- (void) disableFancyFeaturesInTextView:(NSTextView *)tv
{
    if ([tv respondsToSelector:@selector(setAutomaticTextReplacementEnabled:)])
        [tv setAutomaticTextReplacementEnabled:NO];
    if ([tv respondsToSelector:@selector(setAutomaticSpellingCorrectionEnabled:)])
        [tv setAutomaticSpellingCorrectionEnabled:NO];
    [tv setSmartInsertDeleteEnabled:NO];
}

- (void) setTextView1Styles:(NSString *)styleName
{
 //   NSLog(@"stylename = %@", styleName);
    
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    NSString *path;
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    
    
    NSString *mediaPath = [path stringByAppendingPathComponent:@"templates"];
    mediaPath = [mediaPath stringByAppendingPathComponent:styleName];
    NSString *styleFilePath = [mediaPath stringByAppendingString:@".pts"];
 //   NSLog(@"styleFilePath = %@", styleFilePath);
    
    
    
    // check the styleFilePath to make sure there is a file there.
    bool b=[[NSFileManager defaultManager] fileExistsAtPath:styleFilePath];

    
    
    if (b)
    {
        NSString *styleContents = [NSString stringWithContentsOfFile:styleFilePath
                                                            encoding:NSUTF8StringEncoding
                                                               error:NULL];
        
        
        // Check styleContents
        if(styleContents == (id) [NSNull null] || [styleContents length]==0 || [styleContents isEqual:@""])
        {
          // Ignore
        } else {
            
            NSString *backgroundHex;
            NSScanner* scanner = [NSScanner scannerWithString:styleContents];
            [scanner scanUpToString:@"background:" intoString:NULL];
            [scanner scanUpToString:@"\n" intoString:&backgroundHex];
            
            // Check backgroundHex
            if(backgroundHex == (id) [NSNull null] || [backgroundHex length]==0 || [backgroundHex isEqual:@""])
            {
                // Ignore
            } else {
                
                NSArray *chunks = [backgroundHex componentsSeparatedByString: @" "];
                if ([chunks count] > 0)
                {
                    NSString *hexString = [chunks objectAtIndex:1];
                    // Check objectAtIndex:1
                    if(hexString == (id) [NSNull null] || [hexString length]==0 || [hexString isEqual:@""])
                    {
                        // Ignore
                    } else {
                        
                        NSColor *newBGColor = [JBColorWithHex colorWithHex:[chunks objectAtIndex:1]];
                        [mainBox setFillColor:newBGColor];
                        
                        [hl1
                         applyStylesFromStylesheet:styleContents
                         withErrorHandler:^(NSArray *errorMessages) {
                             NSMutableString *errorsInfo = [NSMutableString string];
                             for (NSString *str in errorMessages)
                             {
                                 [errorsInfo appendString:@"• "];
                                 [errorsInfo appendString:str];
                                 [errorsInfo appendString:@"\n"];
                             }
                             
                             NSAlert *alert = [NSAlert alertWithMessageText:@"There were some errors when parsing the stylesheet:"
                                                              defaultButton:@"Ok"
                                                            alternateButton:nil
                                                                otherButton:nil
                                                  informativeTextWithFormat:@"%@", errorsInfo];
                             [alert runModal];
                         }];
                        
                        [hl1
                         applyStylesFromStylesheet:styleContents
                         withErrorHandler:^(NSArray *errorMessages) {
                             NSMutableString *errorsInfo = [NSMutableString string];
                             for (NSString *str in errorMessages)
                             {
                                 [errorsInfo appendString:@"• "];
                                 [errorsInfo appendString:str];
                                 [errorsInfo appendString:@"\n"];
                             }
                             
                             NSAlert *alert = [NSAlert alertWithMessageText:@"There were some errors when parsing the stylesheet:"
                                                              defaultButton:@"Ok"
                                                            alternateButton:nil
                                                                otherButton:nil
                                                  informativeTextWithFormat:@"%@", errorsInfo];
                             [alert runModal];
                         }];

                        
                        
                        
                        
                        [hl1 highlightNow];

                    }
                }
            }
        }
    }
}

-(IBAction)toggleFont:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"useSerif"])
    {
        
        if ([mainWindow mn_isFullScreen])
        {
            [mainTextEditorView setFont:[NSFont fontWithName:@"Courier Prime" size:20]];
        } else {
            [mainTextEditorView setFont:[NSFont fontWithName:@"Courier Prime" size:14]];
        }

        [defaults setBool:YES forKey:@"useSerif"];
        [setFontMenuItem setTitle:@"Use Sans-serif Font"];
        
    } else {
        
        if ([mainWindow mn_isFullScreen])
        {
            [mainTextEditorView setFont:[NSFont fontWithName:@"mplus-1c-regular" size:20]];
        } else {
            [mainTextEditorView setFont:[NSFont fontWithName:@"mplus-1c-regular" size:14]];
        }

        [defaults setBool:NO forKey:@"useSerif"];
        [setFontMenuItem setTitle:@"Use Serif Font"];
    }
    
    
    
    
    
    
    if ([[defaults valueForKey:@"textEditorTheme"] length] > 0)
    {
        [self setTextView1Styles:[defaults valueForKey:@"textEditorTheme"]];
    } else {
        [self setTextView1Styles:@"Default"];
        
    }
}



- (IBAction)jekyllImport:(id)sender
{
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setCanCreateDirectories:YES];
    
    int i;
    NSURL* myRootSaveDirectory;
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [openDlg URLs];
        
        // Loop through all the files and process them.
        // Eh, there should only ever be one. But still.
        for( i = 0; i < [files count]; i++ )
        {
            myRootSaveDirectory = [files objectAtIndex:i];
            
            NSLog(@"rootSaveDirectory: %@", myRootSaveDirectory);
        }
    }

    NSArray *importedPosts;
    NSLog(@"importedPosts: %@", importedPosts);
    
    JBJekyllImporter *jekyll = [[JBJekyllImporter alloc] init];
    importedPosts = [jekyll importJekyllPosts:myRootSaveDirectory];
    
    NSLog(@"adding posts to array controller");
    [postArrayController addObjects:importedPosts];
    
    NSLog(@"save everything");
    [appDelegate saveAllPosts];
    
    NSLog(@"rearrange objects");
    [postArrayController rearrangeObjects];
    
}

- (IBAction)segControlClicked:(id)sender
{
    NSInteger clickedSegment = [sender selectedSegment];
    NSInteger clickedSegmentTag = [[sender cell] tagForSegment:clickedSegment];
    if(clickedSegmentTag == 1)
	{
//		NSLog(@"Preview Post");
        [myWindowController setPreviewFromTextEditor];
	}
	
	if(clickedSegmentTag == 0)
	{
		//JBConfirmDelete *confirmDelete;
//		NSLog(@"Edit Post");
        [myWindowController setTextEditorFromPreview];
	}
	
}

-(IBAction)flipLinkRefType:(id)sender
{
    JBFormdTaskController *myFormd = [[JBFormdTaskController alloc] init];
    NSString *postText = [mainTextEditorView string];
    NSLog(@"Here: %@", [myFormd runPythonScriptWithString:postText]);
}

-(IBAction)openFarmdogHomePage:(id)sender
{
    NSURL *launchURL = [NSURL URLWithString:@"http://farmdog.co"];
	
	if (launchURL == nil)
	{
		NSLog(@"launchURL is nil");
	}
	
	//NSLog(@"launchURL = %@", launchURL);
    
	NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
	[workSpace openURL:launchURL];

}

-(IBAction)sendFeedbackEmail:(id)sender
{
    NSString *mailString = @"mailto:jon@farmdog.co?&subject=Feedback%20regarding%20Paragraphs%20&body=";

    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
	[workSpace openURL:[NSURL URLWithString:mailString]];
}

- (IBAction)returnFirstPost:(id)sender
{
    NSError *error;
    NSString *pathToFirstPost = [[NSBundle mainBundle] pathForResource:@"first_post" ofType:@"md"];
    NSString *firstPostText = [NSString stringWithContentsOfFile:pathToFirstPost encoding:NSUTF8StringEncoding error:&error];
    
    JBPost *post = [[JBPost alloc] initWithTitle:@"First Post" andText:firstPostText andPath:@"" andDate:[NSDate date]];
    [postArrayController addObject:post];
}

@end

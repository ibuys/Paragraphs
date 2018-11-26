//
//  JBSiteExport.m
//  Scout
//
//  Created by Jonathan Buys on 9/1/12.
//
//

#import "JBSiteExport.h"
#import "JBAppSupportDir.h"
#import "JBAppDelegate.h"

@implementation JBSiteExport

- (IBAction)exportSite:(id)sender
{
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    [processInfo disableSuddenTermination];
    [publishProgressIndicator setBezeled:YES];
    [publishProgressIndicator startAnimation:sender];

  //  NSLog(@"101");
    [appDelegate saveAllPosts];

    [self exportPosts];
    
  //  NSLog(@"102");

   // [self exportPosts];
    [publishProgressIndicator stopAnimation:sender];

    [processInfo enableSuddenTermination];
}



-(void)exportPosts
{
    // Round up all the posts
//    NSLog(@"201");

    NSArray *allPostsArray = [postsArrayController arrangedObjects];
    
    if ([allPostsArray count] > 0)
    {
        NSURL *siteRootDir = [self rootSaveDirectory];
        if(siteRootDir)
        {
            NSError *error = nil;
            JBSiteBuilder *siteBuilder = [[JBSiteBuilder alloc] init];
            
            int y;
            if ([allPostsArray count] > 10)
            {
                y = 10;
            } else {
                y = (int)[allPostsArray count];
            }
            
            NSArray *frontPagePostsArray;
            NSRange theRange;
            
            theRange.location = 0;
            theRange.length = y;
            
            frontPagePostsArray = [allPostsArray subarrayWithRange:theRange];
            
            
            // Get the index.html file from JBSiteBuilder
            
            NSString *indexHTML = [siteBuilder buildIndex:frontPagePostsArray];
            //            NSLog(@"indexHTML = %@", indexHTML);
            
            
            if ([indexHTML writeToURL:[siteRootDir URLByAppendingPathComponent:@"index.html"] atomically:YES encoding:NSUTF8StringEncoding error:&error])
            {
                //       NSLog(@"OK, we should have a good index.html file");
            }
            // NSLog(@"indexHTML = %@", indexHTML);
            
            
            
            
            NSString *cssFile = [siteBuilder defaultCSS];
            if ([cssFile writeToURL:[siteRootDir URLByAppendingPathComponent:@"stylesheets/base.css"] atomically:YES encoding:NSUTF8StringEncoding error:&error])
            {
                //    NSLog(@"OK, we should have a good CSS file");
                
            }
            
            NSString *archiveHTML = [siteBuilder buildArchive:[postsArrayController arrangedObjects]];
            if ([archiveHTML writeToURL:[siteRootDir URLByAppendingPathComponent:@"toc.html"] atomically:YES encoding:NSUTF8StringEncoding error:&error])
            {
                //    NSLog(@"OK, we should have a good Archive file");
                
            }
            
            
            
            NSString *atomXML = [siteBuilder buildAtomXML:frontPagePostsArray];
            
            if(atomXML==(id) [NSNull null] || [atomXML length]==0 || [atomXML isEqual:@""])
            {
                NSLog(@"No atom xml file");
            } else {
                if ( [atomXML writeToURL:[siteRootDir URLByAppendingPathComponent:@"atom.xml"] atomically:YES encoding:NSUTF8StringEncoding error:&error])
                {
                    //     NSLog(@"atom.xml written to disk");
                } else {
                    NSLog(@"error writing atom.xml: %@", error);
                }
            }
            
            for (JBPost *tempPost in allPostsArray)
            {
                
                JBPost *postObject = [[JBPost alloc] initWithTitle:tempPost.title andText:tempPost.text andPath:tempPost.path andDate:tempPost.date];
                
                
                NSString *titleString;
                
                NSScanner* scanner = [NSScanner scannerWithString:[postObject text]];
                [scanner scanUpToString:@"\n" intoString:&titleString];
                
                
                NSRange range = [titleString rangeOfString:@"@@"];
                
                if (range.location != NSNotFound)
                {
                    //  NSLog(@"Page post found!");
                    titleString = [titleString stringByReplacingOccurrencesOfString:@"@@ " withString:@""];
                    
                    postObject.title = titleString;
                    
                    NSString *postString = [siteBuilder buildPostWithoutCSS:postObject];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *siteURL = [defaults valueForKey:@"siteURL"];

                    if(siteURL==(id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
                    {
                    } else {
                        siteURL = [siteURL stringByAppendingString:@"/media"];
                    }

                    NSString *imgSrcPrefix = @"img src=\"";
                    NSString *imgSrcFull = [imgSrcPrefix stringByAppendingString:siteURL];
                    //                    NSString *imgSrcFull = [imgSrcMiddle stringByAppendingString:@"/"];
                    
                    postString = [postString stringByReplacingOccurrencesOfString:@"img src=\"/media" withString:imgSrcFull];
                    
                    postString = [postString stringByReplacingOccurrencesOfString:@"img src=\"media" withString:imgSrcFull];
                    
                    NSString *pagePath = [self pagePath:postObject];
                    NSURL *fullPostPath = [siteRootDir URLByAppendingPathComponent:pagePath];
                    
                    if ([postString writeToURL:fullPostPath atomically:YES encoding:NSUTF8StringEncoding error:&error])
                    {
                        //NSLog(@"OK, we should have a good post file");
                    } else {
                        //NSLog(@"Problem exporting post: %@", [error description]);
                        
                    }
                    
                    
                } else {
                    
                    NSString *postString = [siteBuilder buildPostWithoutCSS:postObject];
                    
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *siteURL = [defaults valueForKey:@"siteURL"];
                    
                    if(siteURL==(id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
                    {
                    } else {
                        siteURL = [siteURL stringByAppendingString:@"/media"];
                    }
                    
                    NSString *imgSrcPrefix = @"img src=\"";
                    NSString *imgSrcFull = [imgSrcPrefix stringByAppendingString:siteURL];
//                    NSString *imgSrcFull = [imgSrcMiddle stringByAppendingString:@"/"];
                    
                    postString = [postString stringByReplacingOccurrencesOfString:@"img src=\"/media" withString:imgSrcFull];

                    postString = [postString stringByReplacingOccurrencesOfString:@"img src=\"media" withString:imgSrcFull];
//                    NSLog(@"postString = %@", postString);
                    
                    
                    // Build the post save path
                    NSString *postFolder = [self postFolder:postObject];
                    NSString *tempPostURL = [self postPath:postObject];
                    //  NSString *finalPostURL = [self postURL:postObject];
                    
                    NSURL *postPath = [siteRootDir URLByAppendingPathComponent:tempPostURL];
                    NSURL *postFolderPath = [siteRootDir URLByAppendingPathComponent:postFolder];
                    
                    //                NSLog(@"postPath: %@", postPath);
                    //                NSLog(@"postFolderPath: %@", [postFolderPath absoluteString]);
                    
                    
                    NSFileManager *fileManager = [[NSFileManager alloc] init];
                    NSError *error = nil;
                    
                    
                    // Check for the post directory
                    
                    
                    BOOL isDir;
                    BOOL exists = [fileManager fileExistsAtPath:[[postFolderPath absoluteString] stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""] isDirectory:&isDir];
                    if (exists)
                    {
                        /* file exists */
                        if (isDir)
                        {
                            //     NSLog(@"Scout Post Directory Exists");
                        }
                    } else {
                        if (![fileManager createDirectoryAtURL:postFolderPath withIntermediateDirectories:NO attributes:nil error:&error]) {
                            //   NSLog(@"Error: %@", error);
                        }
                    }
                    
                    
                    
                    // NSString *path = [self postPath:postObject];
                    // NSURL *pathURL = [NSURL fileURLWithPath:path];
                    
                    if ([postString writeToURL:postPath atomically:YES encoding:NSUTF8StringEncoding error:&error])
                    {
                        //NSLog(@"OK, we should have a good post file");
                    } else {
                        //NSLog(@"Problem exporting post: %@", [error description]);
                        
                    }
                    
                }
            }
            
            [self exportMedia:siteRootDir];
            [self exportJS:siteRootDir];
            [self exportFDir:siteRootDir];
            
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = @"Site Published!";
            notification.informativeText = @"Paragraphs has finished publishing your site.";
            notification.soundName = NSUserNotificationDefaultSoundName;
            
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];

        }
    }
}

-(void)exportMedia:(NSURL *)siteRootDir
{
    
   // NSLog(@"siteRootDir = %@", siteRootDir);
    
    // Create app support media path
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    
   // NSLog(@"path = %@", path);
    
//    NSString *filePrefix = @"file:/";
//    path = [filePrefix stringByAppendingString:path];
   // NSLog(@"path = %@", path);

    NSURL *pathURL = [NSURL fileURLWithPath:path];
   // NSLog(@"pathURL = %@", pathURL);
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSString *sourceMediaPath = [path stringByAppendingPathComponent:@"media"];
    NSURL *sourceMediaURL = [pathURL URLByAppendingPathComponent:@"media"];
   // NSLog(@"sourceMediaURL = %@", sourceMediaURL );

    
    
    // Create destination media path
    NSURL *destinationMediaPathURL = [siteRootDir URLByAppendingPathComponent:@"media"];
   // NSString *destinationMediaPath = [[destinationMediaPathURL absoluteString] stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
   // NSLog(@"destinationMediaPathURL = %@", destinationMediaPathURL);

    
    
    
    // Check to make sure both paths exist
    
    if (![fileMan fileExistsAtPath:sourceMediaPath])
    {
            NSLog(@"Error: Media directory does not exist.");
        
    } else {
        
        
        NSDirectoryEnumerator* en = [fileMan enumeratorAtPath:sourceMediaPath];
        // NSLog(@"enumerator: %@", en);
        
        NSError* err = nil;
        BOOL res;
        
        NSString* sourceMediaFile;
        while (sourceMediaFile = [en nextObject])
        {
          //  NSString *fullSourcePath = [sourceMediaPath stringByAppendingPathComponent:sourceMediaFile];
            NSURL *fullSourceURL = [sourceMediaURL URLByAppendingPathComponent:sourceMediaFile];
           // NSLog(@"fullSourceURL = %@", fullSourceURL );
          //  NSString *fullDestinationPath = [destinationMediaPath stringByAppendingPathComponent:sourceMediaFile];
            NSURL *fullDestinationURL = [destinationMediaPathURL URLByAppendingPathComponent:sourceMediaFile];

         //   res = [fileMan copyItemAtPath:fullSourcePath toPath:fullDestinationPath error:&err];
            res = [fileMan copyItemAtURL:fullSourceURL toURL:fullDestinationURL error:&err];
            
            if (!res && err)
            {
              //NSLog(@"oops: %@", [err description]);
                
                // If the file already exists, just ignore it.
            }
        }

    }
}

-(void)exportJS:(NSURL *)siteRootDir
{
    // Find the current theme:
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *themeName = [defaults valueForKey:@"defaultTheme"];
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *templatesDir = [path stringByAppendingPathComponent:@"templates"];
    

    NSString *themeDir = [templatesDir stringByAppendingPathComponent:themeName];

    // Get the javascript out of the theme
    NSFileManager *fileMan = [NSFileManager defaultManager];

    NSDirectoryEnumerator* en = [fileMan enumeratorAtPath:themeDir];
 //   NSLog(@"en = %@", en);
    
    NSString* sourceFile;

    while (sourceFile = [en nextObject])
    {
        if ([[sourceFile pathExtension] isEqual:@"js"])
        {
            // Copy the file
            
            NSString *fullSourcePath = [themeDir stringByAppendingPathComponent:sourceFile];
            NSString *midDestinationPath1 = [[siteRootDir absoluteString] stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
            NSString *midDestinationPath2 = [midDestinationPath1 stringByAppendingPathComponent:@"js"];
            NSString *fullDestinationPath = [midDestinationPath2 stringByAppendingPathComponent:sourceFile];
            
            NSError* err = nil;
            BOOL res;

            res = [fileMan copyItemAtPath:fullSourcePath toPath:fullDestinationPath error:&err];
            
            if (!res && err)
            {
                //  NSLog(@"oops: %@", err);
                
                // If the file already exists, just ignore it.
            }

        }
    }
}

-(void)exportFDir:(NSURL *)siteRootDir
{
    NSLog(@"exportFDir");
    // Find the current theme:
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *themeName = [defaults valueForKey:@"defaultTheme"];
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    NSString *path = [appSupDir applicationSupportDirectory];
    
    NSLog(@"path = %@", path);
    NSString *templatesDir = [path stringByAppendingPathComponent:@"templates"];
    NSLog(@"templatesDir = %@", templatesDir);
    
    
    NSString *themeDir = [templatesDir stringByAppendingPathComponent:themeName];
    NSLog(@"Theme Dir: %@", themeDir);
    
    NSString *fDir = [themeDir stringByAppendingPathComponent:@"f"];
    
    // Get the javascript out of the theme
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator* en = [fileMan enumeratorAtPath:fDir];
    //   NSLog(@"en = %@", en);
    
    NSString* sourceFile;
    
    while (sourceFile = [en nextObject])
    {
        NSLog(@"Source File : %@", sourceFile);
        // Copy the file
            
        NSString *fullSourcePath = [fDir stringByAppendingPathComponent:sourceFile];
        NSString *midDestinationPath1 = [[siteRootDir absoluteString] stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
        NSString *midDestinationPath2 = [midDestinationPath1 stringByAppendingPathComponent:@"f"];
        NSString *fullDestinationPath = [midDestinationPath2 stringByAppendingPathComponent:sourceFile];
        
        NSError* err = nil;
        BOOL res;
        
        res = [fileMan copyItemAtPath:fullSourcePath toPath:fullDestinationPath error:&err];
        
        if (!res && err)
        {
            //  NSLog(@"oops: %@", err);
            
            // If the file already exists, just ignore it.
        }
    }
}


#pragma mark Creating Directory Structure

- (NSURL *)rootSaveDirectory
{
    int i; // Loop counter.
    BOOL isDir;

    NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSError *error = nil;
    NSURL* myRootSaveDirectory;

    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setCanCreateDirectories:YES];
    
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [openDlg URLs];
        
        
        for( i = 0; i < [files count]; i++ )
        {
            myRootSaveDirectory = [files objectAtIndex:i];
        }
    } else {
        return NULL;
    }

    

    NSURL *styleSheetDir = [myRootSaveDirectory URLByAppendingPathComponent:@"stylesheets"];
//    NSLog(@"stylesheetdir = %@", styleSheetDir);
    
    // Check for the styleSheetDir directory
	
	if ([fileManager fileExistsAtPath:[styleSheetDir absoluteString] isDirectory:&isDir] && isDir)
    {
//		NSLog(@"Scout styleSheetDir Directory Exists");
		
	} else {
		if (![fileManager createDirectoryAtURL:styleSheetDir withIntermediateDirectories:NO attributes:nil error:&error]) {
		//	NSLog(@"Error: %@", error);
		}
	}
	// End Check for styleSheetDir Directory

    NSURL *mediaDir = [myRootSaveDirectory URLByAppendingPathComponent:@"media"];
//    NSLog(@"mediaDir = %@", mediaDir);
    
    // Check for the styleSheetDir directory
	
	if ([fileManager fileExistsAtPath:[mediaDir absoluteString] isDirectory:&isDir] && isDir)
    {
//		NSLog(@"Scout mediaDir Directory Exists");
		
	} else {
		if (![fileManager createDirectoryAtURL:mediaDir withIntermediateDirectories:NO attributes:nil error:&error]) {
		//	NSLog(@"Error: %@", error);
		}
	}
	// End Check for styleSheetDir Directory

    
    NSURL *jsDir = [myRootSaveDirectory URLByAppendingPathComponent:@"js"];
   // NSLog(@"jsDir = %@", jsDir);
    
    
    // Check for the styleSheetDir directory
	
	if ([fileManager fileExistsAtPath:[jsDir absoluteString] isDirectory:&isDir] && isDir)
    {
//		NSLog(@"Scout jsDir Directory Exists");
		
	} else {
		if (![fileManager createDirectoryAtURL:jsDir withIntermediateDirectories:NO attributes:nil error:&error]) {
//			NSLog(@"Error: %@", error);
		}
	}
	// End Check for styleSheetDir Directory
    

    NSURL *fDir = [myRootSaveDirectory URLByAppendingPathComponent:@"f"];
    // NSLog(@"jsDir = %@", jsDir);
    
    
    // Check for the styleSheetDir directory
	
	if ([fileManager fileExistsAtPath:[fDir absoluteString] isDirectory:&isDir] && isDir)
    {
        //		NSLog(@"Scout jsDir Directory Exists");
		
	} else {
		if (![fileManager createDirectoryAtURL:fDir withIntermediateDirectories:NO attributes:nil error:&error]) {
            //			NSLog(@"Error: %@", error);
		}
	}
	// End Check for f Directory

    NSURL *imagesDir = [myRootSaveDirectory URLByAppendingPathComponent:@"images"];
   // NSLog(@"imagesDir = %@", imagesDir);
    
    
    // Check for the imagesDir directory
	
	if ([fileManager fileExistsAtPath:[imagesDir absoluteString] isDirectory:&isDir] && isDir)
    {
//		NSLog(@"Scout imagesDir Directory Exists");
		
	} else {
		if (![fileManager createDirectoryAtURL:imagesDir withIntermediateDirectories:NO attributes:nil error:&error])
        {
//		NSLog(@"Error: %@", error);
		}
	}
	// End Check for imagesDir Directory
    

    return myRootSaveDirectory;
}


- (NSString *)postURL:(JBPost *)post
{
    NSDate *postDate = [post valueForKey:@"date"];
    NSString *postTitle = [post valueForKey:@"title"];
    
    NSString *postTitleEscaped = [postTitle stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    NSString *postDateFormated = [postDate descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    
    NSString *postStartFormat = [postDateFormated stringByAppendingPathComponent:postTitleEscaped];
    NSString *postFinalURL = [postStartFormat stringByAppendingPathExtension:@"html"];
    
    return postFinalURL;
}


- (NSString *)postPath:(JBPost *)post
{
    NSDate *postDate = [post valueForKey:@"date"];
    NSString *postTitle = [post valueForKey:@"title"];
    
    NSString *postTitleEscaped = [postTitle stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-"] invertedSet];
    postTitleEscaped = [[postTitleEscaped componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
//     NSLog (@"Result: %@", postTitleEscaped);

    
    
    
    
    
    NSString *postDateFormated = [postDate descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    
    NSString *postStartFormat = [postDateFormated stringByAppendingPathComponent:postTitleEscaped];
    NSString *postFinalURL = [postStartFormat stringByAppendingPathExtension:@"html"];
    return postFinalURL;
}


- (NSString *)postFolder:(JBPost *)post
{
    NSDate *postDate = [post valueForKey:@"date"];        
    NSString *formattedDateString = [postDate descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    
    return formattedDateString;
}


- (NSString *)pagePath:(JBPost *)post
{
    NSString *postTitle = [post valueForKey:@"title"];
    
    NSString *postTitleEscaped = [postTitle stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        
    NSString *postFinalURL = [postTitleEscaped stringByAppendingPathExtension:@"html"];
//       NSLog(@"HEREHEREH %@", postFinalURL);
    return postFinalURL;
}

@end














//-(void)exportPostsForFTP
//{
//    // Round up all the posts
//
//    NSArray *allPostsArray = [postsArrayController arrangedObjects];
//
//    if ([allPostsArray count] > 0)
//    {
//
//        JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
//        NSString *path = [appSupDir applicationSupportDirectory];
//
//        NSString *sourceFTPPath = [path stringByAppendingPathComponent:@"ftpExport"];
//        NSLog(@"sourceFTPPath is: %@", sourceFTPPath);
//
//        NSURL *siteRootDir = [[NSURL alloc] initFileURLWithPath:sourceFTPPath];
//
//
//        NSFileManager *fileManager = [[NSFileManager alloc] init];
//        NSError *error = [[NSError alloc] init];
//        BOOL isDir;
//
//        NSURL *styleSheetDir = [siteRootDir URLByAppendingPathComponent:@"stylesheets"];
//        //  NSLog(@"stylesheetdir = %@", styleSheetDir);
//
//        // Check for the styleSheetDir directory
//
//        if ([fileManager fileExistsAtPath:[styleSheetDir absoluteString] isDirectory:&isDir] && isDir)
//        {
//            //		NSLog(@"Scout styleSheetDir Directory Exists");
//
//        } else {
//            if (![fileManager createDirectoryAtURL:styleSheetDir withIntermediateDirectories:NO attributes:nil error:&error]) {
//                //	NSLog(@"Error: %@", error);
//            }
//        }
//        // End Check for styleSheetDir Directory
//
//        NSURL *mediaDir = [siteRootDir URLByAppendingPathComponent:@"media"];
//        //    NSLog(@"mediaDir = %@", mediaDir);
//
//        // Check for the styleSheetDir directory
//
//        if ([fileManager fileExistsAtPath:[mediaDir absoluteString] isDirectory:&isDir] && isDir)
//        {
//            //	NSLog(@"Scout mediaDir Directory Exists");
//
//        } else {
//            if (![fileManager createDirectoryAtURL:mediaDir withIntermediateDirectories:NO attributes:nil error:&error]) {
//                //	NSLog(@"Error: %@", error);
//            }
//        }
//        // End Check for styleSheetDir Directory
//
//
//        NSURL *jsDir = [siteRootDir URLByAppendingPathComponent:@"js"];
//        //   NSLog(@"jsDir = %@", jsDir);
//
//
//        // Check for the styleSheetDir directory
//
//        if ([fileManager fileExistsAtPath:[jsDir absoluteString] isDirectory:&isDir] && isDir)
//        {
//            //	NSLog(@"Scout jsDir Directory Exists");
//
//        } else {
//            if (![fileManager createDirectoryAtURL:jsDir withIntermediateDirectories:NO attributes:nil error:&error]) {
//                //	NSLog(@"Error: %@", error);
//            }
//        }
//        // End Check for styleSheetDir Directory
//
//
//
//        NSURL *imagesDir = [siteRootDir URLByAppendingPathComponent:@"images"];
//        //   NSLog(@"imagesDir = %@", imagesDir);
//
//
//        // Check for the imagesDir directory
//
//        if ([fileManager fileExistsAtPath:[imagesDir absoluteString] isDirectory:&isDir] && isDir)
//        {
//            //	NSLog(@"Scout imagesDir Directory Exists");
//
//        } else {
//            if (![fileManager createDirectoryAtURL:imagesDir withIntermediateDirectories:NO attributes:nil error:&error])
//            {
//                //NSLog(@"Error: %@", error);
//            }
//        }
//        // End Check for imagesDir Directory
//
//
//        NSLog(@"Root Save Directory is: %@", siteRootDir);
//        JBSiteBuilder *siteBuilder = [[JBSiteBuilder alloc] init];
//
//        int y;
//        if ([allPostsArray count] > 10)
//        {
//            y = 10;
//        } else {
//            y = (int)[allPostsArray count];
//        }
//
//        NSArray *frontPagePostsArray;
//        NSRange theRange;
//
//        theRange.location = 0;
//        theRange.length = y;
//
//        frontPagePostsArray = [allPostsArray subarrayWithRange:theRange];
//
//
//        // Get the index.html file from JBSiteBuilder
//
//        NSString *indexHTML = [siteBuilder buildIndex:frontPagePostsArray];
//
//        if ([indexHTML writeToURL:[siteRootDir URLByAppendingPathComponent:@"index.html"] atomically:YES encoding:NSUTF8StringEncoding error:&error])
//        {
//           // NSLog(@"OK, we should have a good index.html file");
//        }
//
//        NSString *cssFile = [siteBuilder defaultCSS];
//        if ([cssFile writeToURL:[siteRootDir URLByAppendingPathComponent:@"stylesheets/base.css"] atomically:YES encoding:NSUTF8StringEncoding error:&error])
//        {
////            NSLog(@"cssFile : %@", [siteRootDir URLByAppendingPathComponent:@"stylesheets/base.css"] );
////            NSLog(@"OK, we should have a good CSS file");
//
//        }
//
//        NSString *archiveHTML = [siteBuilder buildArchive:[postsArrayController arrangedObjects]];
//        if ([archiveHTML writeToURL:[siteRootDir URLByAppendingPathComponent:@"toc.html"] atomically:YES encoding:NSUTF8StringEncoding error:&error])
//        {
////            NSLog(@"archiveHTML : %@", [siteRootDir URLByAppendingPathComponent:@"toc.html"] );
////
////            NSLog(@"OK, we should have a good Archive file");
//
//        }
//
//        NSString *atomXML = [siteBuilder buildAtomXML:frontPagePostsArray];
//        if ( [atomXML writeToURL:[siteRootDir URLByAppendingPathComponent:@"atom.xml"] atomically:YES encoding:NSUTF8StringEncoding error:&error])
//        {
////            NSLog(@"atom.xml written to disk");
//        }
//
//
//        for (JBPost *tempPost in allPostsArray)
//        {
//
//            JBPost *postObject = [[JBPost alloc] initWithTitle:tempPost.title andText:tempPost.text andPath:tempPost.path andDate:tempPost.date];
//
//
//            NSString *titleString;
//
//            NSScanner* scanner = [NSScanner scannerWithString:[postObject text]];
//            [scanner scanUpToString:@"\n" intoString:&titleString];
//
//
//            NSRange range = [titleString rangeOfString:@"@@"];
//
//            if (range.location != NSNotFound)
//            {
//              //  NSLog(@"Page post found!");
//                titleString = [titleString stringByReplacingOccurrencesOfString:@"@@ " withString:@""];
//
//                postObject.title = titleString;
//
//                NSString *postString = [siteBuilder buildPostWithoutCSS:postObject];
//                postString = [postString stringByReplacingOccurrencesOfString:@"img src=\"media" withString:@"img src=\"/media"];
//
//                NSString *pagePath = [self pagePath:postObject];
//                NSURL *fullPostPath = [siteRootDir URLByAppendingPathComponent:pagePath];
//
//                if ([postString writeToURL:fullPostPath atomically:YES encoding:NSUTF8StringEncoding error:&error])
//                {
//                    //NSLog(@"OK, we should have a good post file");
//                } else {
//                    //NSLog(@"Problem exporting post: %@", [error description]);
//
//                }
//
//
//            } else {
//
//                NSString *postString = [siteBuilder buildPostWithoutCSS:postObject];
//                postString = [postString stringByReplacingOccurrencesOfString:@"img src=\"media" withString:@"img src=\"/media"];
//
//
//                // Build the post save path
//                NSString *postFolder = [self postFolder:postObject];
//                NSString *tempPostURL = [self postPath:postObject];
//                //  NSString *finalPostURL = [self postURL:postObject];
//
//                NSURL *postPath = [siteRootDir URLByAppendingPathComponent:tempPostURL];
//                NSURL *postFolderPath = [siteRootDir URLByAppendingPathComponent:postFolder];
//
//                //                NSLog(@"postPath: %@", postPath);
//                //                NSLog(@"postFolderPath: %@", [postFolderPath absoluteString]);
//
//
//
//
//                // Check for the post directory
//
//
//                BOOL isDir;
//                BOOL exists = [fileManager fileExistsAtPath:[[postFolderPath absoluteString] stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""] isDirectory:&isDir];
//                if (exists)
//                {
//                    /* file exists */
//                    if (isDir)
//                    {
//                        //     NSLog(@"Scout Post Directory Exists");
//                    }
//                } else {
//                    if (![fileManager createDirectoryAtURL:postFolderPath withIntermediateDirectories:NO attributes:nil error:&error]) {
//                      //  NSLog(@"Error: %@", error);
//                    }
//                }
//
//
//
//                // NSString *path = [self postPath:postObject];
//                // NSURL *pathURL = [NSURL fileURLWithPath:path];
//
//                if ([postString writeToURL:postPath atomically:YES encoding:NSUTF8StringEncoding error:&error])
//                {
//                    //NSLog(@"OK, we should have a good post file");
//                } else {
//                    //NSLog(@"Problem exporting post: %@", [error description]);
//
//                }
//
//            }
//        }
//
//        [self exportMedia:siteRootDir];
//        [self exportJS:siteRootDir];
//
//    }
//}
//


//
//  JBDropboxSync.m
//  Scout
//
//  Created by Jonathan Buys on 2/15/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBDropboxSync.h"
#import "JBAppSupportDir.h"
#import "JBPost.h"

@implementation JBDropboxSync


- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


- (NSMutableDictionary *)postStatus:(NSArray *)currentPosts checkPost:(NSString *)changedPost
{
    NSMutableDictionary *postStatus = [[NSMutableDictionary alloc] init];

    // Load the posts from disk
    NSArray *currentPostsOnDisk = [self buildTempArray];
    
    // Do the arrays have the same number of posts?
    
    if ([currentPostsOnDisk count] > [currentPosts count])
    {
        NSLog(@"There are more posts on disk than in the cache");
        [postStatus setObject:@"YES" forKey:@"newPost"];
        return postStatus;
    }
    
    if ([currentPostsOnDisk count] < [currentPosts count])
    {
        NSLog(@"There are more posts in the cache than on disk");
        [postStatus setObject:@"NO" forKey:@"newPost"];
        [postStatus setObject:@"YES" forKey:@"removePost"];

        return postStatus;
    }

    if ([currentPostsOnDisk count] == [currentPosts count])
    {
        NSLog(@"Number of posts are in sync");
        [postStatus setObject:@"NO" forKey:@"newPost"];
        [postStatus setObject:@"NO" forKey:@"removePost"];
        
        return postStatus;
    }

    
//    NSEnumerator *currentPostsEnumerator = [currentPosts objectEnumerator];
//    
//    for (JBPost *postOnDisk in currentPostsOnDisk)
//    {
//        if (postOnDisk != [currentPostsEnumerator nextObject])
//        {
//            //We have found a pair of two different objects.
//            NSLog(@"JBPost %@ is not the same as current post", postOnDisk.title);
//            [postStatus setObject:postOnDisk forKey:@"modifiedPost"];
//            return postStatus;
//
//        }
//    }
    
    return postStatus;
}


- (NSArray *)buildTempArray
{
    NSLog(@"Building Temp Array");
        
    NSMutableArray *postsOnDisk = [[NSMutableArray alloc] init];
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
    
    
    
    
    NSString *markdownDirectory = [scoutDir stringByAppendingPathComponent:@"posts"];
    
    
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
            [postsOnDisk addObject:post];
        }
    }
    
    //  NSLog(@"In the array: %@", [markdownFilesArrayContoller arrangedObjects]);

    return [NSArray arrayWithArray:postsOnDisk];
}


- (JBPost *)postFromString:(NSString *)file
{
    file = [file lastPathComponent];
    NSLog(@"postFromString file: %@", file);
    NSString *dateString;
    NSDate *thisPostDate;

    JBAppSupportDir *myAppSupDir = [[JBAppSupportDir alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *scoutDir;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        scoutDir = [myAppSupDir dropboxDir];
        
        
    } else {
        scoutDir = [myAppSupDir applicationSupportDirectory];
        
    }
    
    NSString *markdownDirectory = [scoutDir stringByAppendingPathComponent:@"posts"];

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

    
    

    return post;
}


- (NSUInteger)indexOfPostToRemove:(NSArray *)currentArray withString:(NSString *)path
{
    for (JBPost *tempPost in currentArray)
    {
//        NSLog(@"tempPost.path = %@", [tempPost path]);
//        NSLog(@"passed path = %@", path);
        
        if ([[tempPost path] isEqualToString:path])
        {
            return [currentArray indexOfObject:tempPost];
        }
    }
    
    return 1;
}

@end














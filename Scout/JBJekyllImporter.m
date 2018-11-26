//
//  JBJekyllImporter.m
//  Scout
//
//  Created by Jon Buys on 12/7/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBJekyllImporter.h"
#import "JBPost.h"
#import "JBAppSupportDir.h"

@implementation JBJekyllImporter


-(NSArray *)importJekyllPosts:(NSURL *)jekyllDirectory;
{
    
 
 //   jekyllDirectory = [jekyllDirectory stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
    NSLog(@"jekyllDir = %@", jekyllDirectory);

    NSMutableArray *postsArray = [[NSMutableArray alloc] init];
    
    NSURL *fileURL;
    NSDate *thisPostDate;
    
    
//    NSFileManager *localFileManager=[NSFileManager defaultManager];
//    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:jekyllDirectory];


    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
                                         enumeratorAtURL:jekyllDirectory
                                         includingPropertiesForKeys:NULL
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             NSLog(@"Error processing file: %@", [error description]);
                                             // Return YES if the enumeration should continue after the error.
                                             return YES;
                                         }];
    
//    unsigned long long size = 0;
    
//    for (NSURL *url in enumerator) {
//        NSError *error;
//        NSNumber *totalFileSize;
//        [url getResourceValue:&totalFileSize forKey:NSURLTotalFileSizeKey error:&error];
//        
//        size += [totalFileSize longLongValue];
//    }

    
    while (fileURL = [enumerator nextObject])
    {
        NSString *file;
        
        file = [[fileURL relativeString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        
        
        NSLog(@"Is this markdown?: %@", file);

        if ([[file pathExtension] isEqualToString: @"markdown"])
        {
            
            // process the document
            NSLog(@"I found this file: %@", file);
            
            
            
            
            //pull the content from the file into memory
            NSData* data = [NSData dataWithContentsOfFile:file];
            //convert the bytes from the file into a string
            NSString* string = [[NSString alloc] initWithBytes:[data bytes]
                                                         length:[data length]
                                                       encoding:NSUTF8StringEncoding];

            
            
            
            
            
            
            
            
            
            

            // Get the date of the post
            
            NSString *newStr = [[file lastPathComponent] substringWithRange:NSMakeRange(0, 10)];
            NSLog(@"newDateString = %@", newStr);

            NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            
            [myDateFormatter setLocale:enUSPOSIXLocale];
            [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
            thisPostDate = [myDateFormatter dateFromString:newStr];

            NSLog(@"thisPostDate = %@", thisPostDate);
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            // Get the title of the post
              NSString *titleString;
//            NSString *tmpText = [NSString stringWithContentsOfFile:[[jekyllDirectory relativeString] stringByAppendingPathComponent:file] encoding:NSUTF8StringEncoding error:&error];
            
            NSRange range = [string rangeOfString:@"title: "];
            
            if (range.location != NSNotFound)
            {
                NSScanner* scanner = [NSScanner scannerWithString:string];
                [scanner scanUpToString:@"title: " intoString:NULL];
                [scanner scanUpToString:@"\n" intoString:&titleString];
                
                titleString = [titleString stringByReplacingOccurrencesOfString:@"title: " withString:@""];
            } else {
                NSScanner* scanner = [NSScanner scannerWithString:string];
                [scanner scanUpToString:@"\n" intoString:&titleString];
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            // Get the text of the post
            NSString *textString;
            
            NSRange yamlHeaderRange = [string rangeOfString:@"---"];
            
            if (yamlHeaderRange.location != NSNotFound)
            {
                textString = [[string substringFromIndex:NSMaxRange(yamlHeaderRange)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                NSRange yamlHeaderRange2 = [textString rangeOfString:@"---"];
                
                if (yamlHeaderRange2.location != NSNotFound)
                {
                    textString = [[textString substringFromIndex:NSMaxRange(yamlHeaderRange2)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                }
                
                NSString *combined = [titleString stringByAppendingString:textString];
                textString = combined;


            } else {
                
                textString = string;
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            

            // Create a new URL for the post
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
           // NSString *markdownDirectory = [defaults valueForKey:@"markdownDirectory"];
            
            
            JBAppSupportDir *myAppSupDir = [[JBAppSupportDir alloc] init];
            
            NSString *scoutDir;
            
            
            if ([defaults boolForKey:@"dropboxSync"])
            {
                scoutDir = [myAppSupDir dropboxDir];
                
                
            } else {
                scoutDir = [myAppSupDir applicationSupportDirectory];
                
            }
            
            
            
            
            NSString *markdownDirectory = [scoutDir stringByAppendingPathComponent:@"posts"];
            


            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-SSSS"];
            
            NSString *formattedDateString = [dateFormatter stringFromDate:thisPostDate];
            NSString *formattedTitle = [titleString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            NSString *one = [formattedDateString stringByAppendingString:@"##"];
            NSString *two = [one stringByAppendingString:formattedTitle];
            
            
            
            
            NSLog(@"No Path! Let's give it one.");
            
            NSString *currentPath = [markdownDirectory stringByAppendingPathComponent:two];
            currentPath = [currentPath stringByAppendingString:@".markdown"];

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            // Create a new JBPost object and set date, title, text, and path
            
            JBPost *post = [[JBPost alloc] init];
            
            [post setDate:thisPostDate];
            [post setTitle:titleString];
            [post setText:textString];
            [post setPath:currentPath];
            
            NSLog(@"JBPost = %@", post);
            
            
             NSLog(@"Post Title: %@", [post title]);
            [postsArray addObject:post];
        }
    }
    
    //  NSLog(@"In the array: %@", [markdownFilesArrayContoller arrangedObjects]);

    return postsArray;
}



@end

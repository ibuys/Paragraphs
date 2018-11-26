//
//  JBvOnePointOne.m
//  Paragraphs
//
//  Created by Jonathan Buys on 5/13/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBvOnePointOne.h"
#import "JBAppSupportDir.h"

@implementation JBvOnePointOne

- (id)init
{
    self = [super init];
    if (self)
    {
        //
    }
    return self;
}


- (void)newVersionRun
{
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    NSString *path = [appSupDir applicationSupportDirectory];

    NSError *error;
    NSString *templatePath = [path stringByAppendingPathComponent:@"templates"];

    // Update FreshInstall Theme
    
    NSString *freshFullPath = [templatePath stringByAppendingPathComponent:@"fresh_install.ptf"];
    
    
    NSString *freshItemToCopy = [[NSBundle mainBundle] pathForResource:@"fresh_install" ofType:@"ptf"];
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    if (![fileMan removeItemAtPath:freshFullPath error:&error])
    {
        NSLog(@"Sorry, I can't update fresh install theme.");
    } 
    
    
    if (![fileMan fileExistsAtPath:freshFullPath])
    {
        if (![fileMan copyItemAtPath:freshItemToCopy toPath:freshFullPath error:&error])
        {
            NSLog(@"Uh oh, error copying file.");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Sorry, something went wrong."];
            [alert setInformativeText:[error description]];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // OK clicked, whatever
                
            }
        } 
    }

    
    // Copy over new monochrome theme
    NSString *photoStyleFullPath = [templatePath stringByAppendingPathComponent:@"Monochrome.pts"];
    NSString *photoStyleItemToCopy = [[NSBundle mainBundle] pathForResource:@"Monochrome" ofType:@"pts"];
    
    if (![fileMan fileExistsAtPath:photoStyleFullPath])
    {
        if (![fileMan copyItemAtPath:photoStyleItemToCopy toPath:photoStyleFullPath error:&error])
        {
            NSLog(@"Uh oh, error copying file.");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Sorry, something went wrong."];
            [alert setInformativeText:[error description]];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // OK clicked, whatever
                
            }
        }
    }

    if (!error)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"version1.1"];
//        NSLog(@"version 1.0.1 set");
    } else {
        NSLog(@"Version 1.0.1 NOT set. Something went wrong.");
    }
}


@end

//
//  JBFirstRunMover.m
//  Scout
//
//  Created by Jonathan Buys on 11/28/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBFirstRunMover.h"
#import "JBAppSupportDir.h"

@implementation JBFirstRunMover

- (void)copyDefaultTemplate
{
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    NSString *path = [appSupDir applicationSupportDirectory];
    
    NSError *error;
    NSString *plock = [path stringByAppendingString:@"/.plock"];
    NSString *zeroDay = @"0";
    [zeroDay writeToFile:plock atomically:YES encoding:NSUTF8StringEncoding error:&error];

    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSString *templatePath = [path stringByAppendingPathComponent:@"templates"];
    
    if (![fileMan fileExistsAtPath:templatePath])
    {
        NSError *er;
        
        
        if (![fileMan createDirectoryAtPath:templatePath withIntermediateDirectories:NO attributes:nil error:&er])
        {
            NSLog(@"Uh oh, error creating templatePath.");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Sorry, something went wrong."];
            [alert setInformativeText:[er description]];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // OK clicked, whatever
                
            }
        }
    }
    
    
    NSString *defaultStyleFullPath = [templatePath stringByAppendingPathComponent:@"Default.pts"];
    NSString *defaultStyleItemToCopy = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"pts"];
    
    if (![fileMan fileExistsAtPath:defaultStyleFullPath])
    {
        if (![fileMan copyItemAtPath:defaultStyleItemToCopy toPath:defaultStyleFullPath error:&error])
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


    NSString *solLightStyleFullPath = [templatePath stringByAppendingPathComponent:@"Solarized-light.pts"];
    NSString *solLightStyleItemToCopy = [[NSBundle mainBundle] pathForResource:@"Solarized-light" ofType:@"pts"];
    
    if (![fileMan fileExistsAtPath:solLightStyleFullPath])
    {
        if (![fileMan copyItemAtPath:solLightStyleItemToCopy toPath:solLightStyleFullPath error:&error])
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

    NSString *solDarkStyleFullPath = [templatePath stringByAppendingPathComponent:@"Solarized-dark.pts"];
    NSString *solDarkStyleItemToCopy = [[NSBundle mainBundle] pathForResource:@"Solarized-dark" ofType:@"pts"];
    
    if (![fileMan fileExistsAtPath:solDarkStyleFullPath])
    {
        if (![fileMan copyItemAtPath:solDarkStyleItemToCopy toPath:solDarkStyleFullPath error:&error])
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

    NSString *fullPath = [templatePath stringByAppendingPathComponent:@"default.ptf"];
    NSString *itemToCopy = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"ptf"];    
    
    if (![fileMan fileExistsAtPath:fullPath])
    {
        if (![fileMan copyItemAtPath:itemToCopy toPath:fullPath error:&error])
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
    
    NSString *plainFullPath = [templatePath stringByAppendingPathComponent:@"plain.ptf"];
    
    
    NSString *plainItemToCopy = [[NSBundle mainBundle] pathForResource:@"plain" ofType:@"ptf"];
    
    if (![fileMan fileExistsAtPath:plainFullPath])
    {
        if (![fileMan copyItemAtPath:plainItemToCopy toPath:plainFullPath error:&error])
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
    
    NSString *freshFullPath = [templatePath stringByAppendingPathComponent:@"fresh_install.ptf"];
    
    
    NSString *freshItemToCopy = [[NSBundle mainBundle] pathForResource:@"fresh_install" ofType:@"ptf"];
    
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


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:fullPath forKey:@"defaultTheme"];
    
    // Let's get the rest of the directory structure built as well:
    
    NSString *postPath = [path stringByAppendingPathComponent:@"posts"];
    
    if (![fileMan fileExistsAtPath:postPath])
    {
        NSError *er;
        
        
        if (![fileMan createDirectoryAtPath:postPath withIntermediateDirectories:NO attributes:nil error:&er])
        {
            NSLog(@"Uh oh, error creating postPath.");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Sorry, something went wrong."];
            [alert setInformativeText:[er description]];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // OK clicked, whatever
                
            }
        }
    }

    
    NSString *mediaPath = [path stringByAppendingPathComponent:@"media"];
    
    if (![fileMan fileExistsAtPath:mediaPath])
    {
        NSError *er;
        
        
        if (![fileMan createDirectoryAtPath:mediaPath withIntermediateDirectories:NO attributes:nil error:&er])
        {
            NSLog(@"Uh oh, error creating mediaPath.");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Sorry, something went wrong."];
            [alert setInformativeText:[er description]];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // OK clicked, whatever
                
            }
        }
    }
    
    
    // Added March 19, 2013
    // Move over the coffee.png file for a nice first run preview.
    NSString *coffeeFullPath = [mediaPath stringByAppendingPathComponent:@"coffee.png"];
    
    NSError *coffeeError;
    
    NSString *coffeeItemToCopy = [[NSBundle mainBundle] pathForResource:@"coffee" ofType:@"png"];
    
    if (![fileMan fileExistsAtPath:coffeeFullPath])
    {
        if (![fileMan copyItemAtPath:coffeeItemToCopy toPath:coffeeFullPath error:&coffeeError])
        {
            NSLog(@"Uh oh, error copying file.");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Sorry, something went wrong."];
            [alert setInformativeText:[coffeeError description]];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // OK clicked, whatever
                
            }
        }
    }
    
    // end of March 19, 2013 addition
    
    

    NSString *ftpExportPath = [path stringByAppendingPathComponent:@"ftpExport"];
    
    if (![fileMan fileExistsAtPath:ftpExportPath])
    {
        NSError *er;
        
        
        if (![fileMan createDirectoryAtPath:ftpExportPath withIntermediateDirectories:NO attributes:nil error:&er])
        {
            NSLog(@"Uh oh, error creating ftpExportPath.");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Sorry, something went wrong."];
            [alert setInformativeText:[er description]];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // OK clicked, whatever
                
            }
        }
    }

}

@end

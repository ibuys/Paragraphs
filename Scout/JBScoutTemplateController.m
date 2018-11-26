//
//  JBScoutTemplateController.m
//  Scout
//
//  Created by Jon Buys on 9/14/12.
//
//

#import "JBScoutTemplateController.h"
#import "JBAppSupportDir.h"

@implementation JBScoutTemplateController


- (BOOL)importFromFile:(NSString *)filename
{
  //  NSLog(@"Called importFromFile method for this file: %@", filename);
    
    NSString *extension = [filename pathExtension];

    if ([extension isEqualToString:@"pts"])
    {
        if (![self copyTemplate:filename])
        {
            return NO;
        }

    } else if ([extension isEqualToString:@"ptf"])
    {
        if (![self checkTemplate:filename])
        {
            return NO;
        }
        
        if (![self copyTemplate:filename])
        {
            return NO;
        }

    }
    
    return YES;
}

- (BOOL)copyTemplate:(NSString *)filename
{
    
  //  NSLog(@"filename: %@", filename);
    NSString *filePrefix = @"file://";
    NSString *fullFilePath = [filePrefix stringByAppendingString:filename];
  //  NSLog(@"fullFilePath: %@", fullFilePath);

    NSURL *appSupportPath;
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    NSString *path;
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }

    
    appSupportPath = [NSURL fileURLWithPath:path];

    
    
    
    
    
    
    NSURL *templatesPath = [appSupportPath URLByAppendingPathComponent:@"Templates"];
   // NSLog(@"templatesPath = %@", templatesPath);
    
    NSURL *fullPath = [templatesPath URLByAppendingPathComponent:[filename lastPathComponent]];
   // NSLog(@"fullPath = %@", fullPath);
    
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] copyItemAtURL:[NSURL URLWithString:fullFilePath] toURL:fullPath error:&error])
    {
        return YES;
    }
    else
    {
//        NSLog(@"copyTemplate failed");
        [[NSAlert alertWithError:error] runModal];

        return NO;
    }
}

- (BOOL)checkTemplate:(NSString *)filename
{
    NSURL *theURL = [NSURL fileURLWithPath:filename isDirectory:NO];
    NSError *err;
    if ([theURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }
    
    NSURL *atomURL = [theURL URLByAppendingPathComponent:@"atom.xml"];
    NSURL *atomTemplateURL = [theURL URLByAppendingPathComponent:@"atomTemplate.xml"];
    NSURL *baseURL = [theURL URLByAppendingPathComponent:@"base.css"];
    NSURL *defaultURL = [theURL URLByAppendingPathComponent:@"default.html"];
    NSURL *indexTemplateURL = [theURL URLByAppendingPathComponent:@"indexTemplate.html"];
    NSURL *postURL = [theURL URLByAppendingPathComponent:@"post.html"];
    NSURL *robotsURL = [theURL URLByAppendingPathComponent:@"robots.txt"];
    NSURL *screenshotURL = [theURL URLByAppendingPathComponent:@"screenshot.png"];
    NSURL *tocURL = [theURL URLByAppendingPathComponent:@"toc.html"];


    
    if ([atomURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }

    
    if ([atomTemplateURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }

    
    if ([baseURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }


    if ([defaultURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }

    
    if ([indexTemplateURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }

    
    if ([postURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }

    
    if ([robotsURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }

    
    if ([screenshotURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }

    
    if ([tocURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        [[NSAlert alertWithError:err] runModal];
        return NO;
    }

    
    return YES;
}



@end

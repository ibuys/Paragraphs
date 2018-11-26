//
//  JBSiteBuilder.m
//  Scout
//
//  Created by Jonathan Buys on 11/27/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBSiteBuilder.h"
#import "JBMarkdownConverter.h"
#import "JBAppSupportDir.h"

@implementation JBSiteBuilder

- (NSString *)buildPost:(JBPost *)postObject
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Get the date
    NSDate *postDate = [postObject date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *dateFormat = [defaults valueForKey:@"dateFormat"];
    if(dateFormat == (id) [NSNull null] || [dateFormat length]==0 || [dateFormat isEqual:@""])
    {
        [dateFormatter setDateFormat:@"MM dd, yyyy"];
    } else {
        [dateFormatter setDateFormat:dateFormat];
    }
    
    
    
    // Bulletproof...
    NSString *postDateFormated;
    if([dateFormatter stringFromDate:postDate]==(id) [NSNull null] || [[dateFormatter stringFromDate:postDate] length]==0 || [[dateFormatter stringFromDate:postDate] isEqual:@""])
    {
        
    } else {
        postDateFormated = [dateFormatter stringFromDate:postDate];
    }
    
    
    NSString *siteURL;
    if([defaults valueForKey:@"siteURL"]==(id) [NSNull null] || [[defaults valueForKey:@"siteURL"] length]==0 || [[defaults valueForKey:@"siteURL"] isEqual:@""])
    {
    } else {
        siteURL = [defaults valueForKey:@"siteURL"];
        // NSLog(@"siteURL = %@", siteURL);
    }

    
     
    NSString *siteName;
    if([defaults valueForKey:@"siteName"]==(id) [NSNull null] || [[defaults valueForKey:@"siteName"] length]==0 || [[defaults valueForKey:@"siteName"] isEqual:@""])
    {
    } else {
        siteName = [defaults valueForKey:@"siteName"];
        // NSLog(@"siteName = %@", siteName);
    }

    
    
    NSString *finalPostURL = [self postURL:postObject];
    // NSLog(@"finalPostURL = %@", finalPostURL);

    // Build the post HTML
    
    NSString *postRawHTML;
    if([postObject text]==(id) [NSNull null] || [[postObject text] length]==0 || [[postObject text] isEqual:@""])
    {
    } else {
        JBMarkdownConverter *mdConverter = [[JBMarkdownConverter alloc] init];
        postRawHTML = [mdConverter markdown2HTML:[postObject text]];
        // NSLog(@"postRawHTML = %@", postRawHTML);
    }

    NSString *postTemplate = [self postTemplate];
    // NSLog(@"postTemplate = %@", postTemplate);

        
    // Build the final post page
    NSString *post1;
    if(postRawHTML==(id) [NSNull null] || [postRawHTML length]==0 || [postRawHTML isEqual:@""])
    {
    } else {
        post1 = [postTemplate stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:postRawHTML];
        // NSLog(@"post1 = %@", post1);
    }
   


    
    
    
    NSString *post2;
    if(postDateFormated==(id) [NSNull null] || [postDateFormated length]==0 || [postDateFormated isEqual:@""])
    {
    } else {
        post2 = [post1 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_DATE_YYYY" withString:postDateFormated];
        //     NSLog(@"post2 = %@", post2);
    }

    
    
    
    
    

    NSString *post3;
    if([postObject valueForKey:@"title"]==(id) [NSNull null] || [[postObject valueForKey:@"title"] length]==0 || [[postObject valueForKey:@"title"] isEqual:@""])
    {
        
    } else {
        post3 = [post2 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_TITLE_YYYY" withString:[postObject valueForKey:@"title"]];
        //     NSLog(@"post3 = %@", post3);
    }

    
    
    
    
    
    
    if(siteURL==(id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
    {
    } else {
        siteURL = [siteURL stringByAppendingString:@"/"];
    }

    
    
    
    
    
    
    
    NSString *post4;
    if(finalPostURL==(id) [NSNull null] || [finalPostURL length]==0 || [finalPostURL isEqual:@""])
    {
    } else {
        if(siteURL==(id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
        {
            
        } else {
            post4 = [post3 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_URL_YYYY" withString:[siteURL stringByAppendingString:finalPostURL]];
            //     NSLog(@"post4 = %@", post4);

        }
        
    }

   

    
    
    
    
    
    NSString *post5;
    if(post4==(id) [NSNull null] || [post4 length]==0 || [post4 isEqual:@""])
    {
    } else {
        post5 = [[self defaultTemplate] stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:post4];
        //     NSLog(@"post5 = %@", post5);
    }

    
    
    
    
    
    
    
    
    
    
    
    NSString *cssBulder = @"<style>";
    if([self defaultCSS]==(id) [NSNull null] || [[self defaultCSS] length]==0 || [[self defaultCSS] isEqual:@""])
    {
    } else {
        cssBulder = [cssBulder stringByAppendingString:[self defaultCSS]];
    }
    cssBulder = [cssBulder stringByAppendingString:@"</style>"];
    
    
    
    
    
    
    NSString *cssTmp;
    if(cssBulder==(id) [NSNull null] || [cssBulder length]==0 || [cssBulder isEqual:@""])
    {
    } else {
        cssTmp = [post5 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CSS_YYYY" withString:cssBulder];
        cssTmp = [cssTmp stringByReplacingOccurrencesOfString:@"<base href=\"YYYY_SCOUT_URL_YYYY\" />" withString:@""];
        //     NSLog(@"cssTmp = %@", cssTmp);
    }
    

    NSString *post6;
    if(siteURL==(id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
    {
    } else {
        post6 = [cssTmp stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_URL_YYYY" withString:siteURL];
        //     NSLog(@"post6 = %@", post6);
    }
    
    
    
    NSString *post7;
    if(siteName==(id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        post7 = [post6 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_TITLE_YYYY" withString:siteName];
        //     NSLog(@"post7 = %@", post7);
    }

    
    
    
    NSString *post8;
    if(siteName==(id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        post8 = [post7 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_PAGE_TITLE_YYYY" withString:siteName];
        //     NSLog(@"post8 = %@", post8);
    }

    
    return post8;
}












- (NSString *)buildThemePreview:(JBPost *)postObject withTheme:(NSString *)theme
{
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *postDate = [postObject date];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [defaults valueForKey:@"dateFormat"];
    if(dateFormat == (id) [NSNull null] || [dateFormat length]==0 || [dateFormat isEqual:@""])
    {
        [dateFormatter setDateFormat:@"MM dd, yyyy"];
    } else {
        [dateFormatter setDateFormat:dateFormat];
    }

    
    
    NSString *postDateFormated;
    if([dateFormatter stringFromDate:postDate]==(id) [NSNull null] || [[dateFormatter stringFromDate:postDate] length]==0 || [[dateFormatter stringFromDate:postDate] isEqual:@""])
    {
        
    } else {
        postDateFormated = [dateFormatter stringFromDate:postDate];
    }
   // NSLog(@"postDateFormatted = %@", postDateFormated);
    
    NSString *siteURL;
    if([defaults valueForKey:@"siteURL"]==(id) [NSNull null] || [[defaults valueForKey:@"siteURL"] length]==0 || [[defaults valueForKey:@"siteURL"] isEqual:@""])
    {
    } else {
        siteURL = [defaults valueForKey:@"siteURL"];
        // NSLog(@"siteURL = %@", siteURL);
    }
    
    
    
    NSString *siteName;
    if([defaults valueForKey:@"siteName"]==(id) [NSNull null] || [[defaults valueForKey:@"siteName"] length]==0 || [[defaults valueForKey:@"siteName"] isEqual:@""])
    {
    } else {
        siteName = [defaults valueForKey:@"siteName"];
        // NSLog(@"siteName = %@", siteName);
    }
    
    
    
    NSString *finalPostURL = [self postURL:postObject];
    // NSLog(@"finalPostURL = %@", finalPostURL);
    
    
    // Build the post HTML
    
    NSString *postRawHTML;
    if([postObject text]==(id) [NSNull null] || [[postObject text] length]==0 || [[postObject text] isEqual:@""])
    {
    } else {
        JBMarkdownConverter *mdConverter = [[JBMarkdownConverter alloc] init];
        postRawHTML = [mdConverter markdown2HTML:[postObject text]];
        // NSLog(@"postRawHTML = %@", postRawHTML);
    }
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    
    
    
    
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];

    NSString *themeDir;
    if(theme == (id) [NSNull null] || [theme length]==0 || [theme isEqual:@""])
    {
    } else {
        themeDir = [themesPath stringByAppendingPathComponent:theme];

    }

    NSError *error;
    NSString *postTemplate;
    postTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"post.html"]  encoding:NSUTF8StringEncoding error:&error];
    
    if(postTemplate == (id) [NSNull null] || [postTemplate length]==0 || [postTemplate isEqual:@""])
    {
        NSLog(@"post template failed to load: %@", [error description]);
        return @"";
    }

    
    
    
    
    
    
    // Build the final post page
    
    NSString *post1;
    if(postRawHTML == (id) [NSNull null] || [postRawHTML length]==0 || [postRawHTML isEqual:@""])
    {
    } else {
        post1 = [postTemplate stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:postRawHTML];
    }
    
    
    
    
    
    
    
    
    
    
    
    NSString *post2;
    if(postDateFormated == (id) [NSNull null] || [postDateFormated length]==0 || [postDateFormated isEqual:@""])
    {
    } else {
        post2 = [post1 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_DATE_YYYY" withString:postDateFormated];
    }
    
    
    
    
    
    
    
    
    
    


    
    NSString *post3;
    if([postObject valueForKey:@"title"] == (id) [NSNull null] || [[postObject valueForKey:@"title"] length]==0 || [[postObject valueForKey:@"title"] isEqual:@""])
    {
    } else {
        post3 = [post2 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_TITLE_YYYY" withString:[postObject valueForKey:@"title"]];
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    siteURL = [siteURL stringByAppendingString:@"/"];

    NSString *post4;
    if(finalPostURL == (id) [NSNull null] || [finalPostURL length]==0 || [finalPostURL isEqual:@""])
    {
    } else {
        post4 = [post3 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_URL_YYYY" withString:[siteURL stringByAppendingString:finalPostURL]];
    }
    
    
    
    
    
    
    
    NSError *err;
    NSString *defaultTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"default.html"]  encoding:NSUTF8StringEncoding error:&err];
    if(defaultTemplate == (id) [NSNull null] || [defaultTemplate length]==0 || [defaultTemplate isEqual:@""])
    {
        NSLog(@"default template failed to load: %@", [err description]);
        return @"";
    }
    
    
    
    
    

    
    NSString *post5;
    if(post4 == (id) [NSNull null] || [post4 length]==0 || [post4 isEqual:@""])
    {
    } else {
        post5 = [defaultTemplate stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:post4];
    }

    
    
    
    
    
    
    
    
    
    NSString *cssBulder = @"<style>";
    NSString *cssTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"base.css"]  encoding:NSUTF8StringEncoding error:nil];
    if(cssTemplate ==(id) [NSNull null] || [cssTemplate length]==0 || [cssTemplate isEqual:@""])
    {
        NSLog(@"CSS Failed to load");
    } else {
        cssBulder = [cssBulder stringByAppendingString:cssTemplate];
      //  NSLog(@"cssBuilder = %@", cssBulder);
    }
    cssBulder = [cssBulder stringByAppendingString:@"</style>"];
//    NSLog(@"cssBuilder = %@", cssBulder);
    
    NSString *cssTmp;
    if(cssBulder==(id) [NSNull null] || [cssBulder length]==0 || [cssBulder isEqual:@""])
    {
        NSLog(@"cssBuilder is blank");
    } else {
        cssTmp = [post5 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CSS_YYYY" withString:cssBulder];
        cssTmp = [cssTmp stringByReplacingOccurrencesOfString:@"<base href=\"YYYY_SCOUT_URL_YYYY\" />" withString:@""];
        //     NSLog(@"cssTmp = %@", cssTmp);
    }
//    NSLog(@"cssTmp = %@", cssTmp);
    
    NSString *post6;
    if(siteURL==(id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
    {
    } else {
        post6 = [cssTmp stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_URL_YYYY" withString:siteURL];
        //     NSLog(@"post6 = %@", post6);
    }
   // NSLog(@"post6 = %@", post6);

    
    
    NSString *post7;
    if(siteName==(id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        post7 = [post6 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_TITLE_YYYY" withString:siteName];
        //     NSLog(@"post7 = %@", post7);
    }
    
   // NSLog(@"post7 = %@", post7);

    
    
    NSString *post8;
    if(siteName==(id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        post8 = [post7 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_PAGE_TITLE_YYYY" withString:siteName];
        //     NSLog(@"post8 = %@", post8);
    }
  //  NSLog(@"post8 = %@", post8);

    return post8;
}


























- (NSString *)buildIndex:(NSArray *)frontPagePosts
{
  //  NSLog(@"frontPagePosts = %@", frontPagePosts);

    if ([frontPagePosts count] > 0)
    {
        NSString *siteURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"siteURL"];
//        NSLog(@"siteURL = %@", siteURL);

        NSString *siteName = [[NSUserDefaults standardUserDefaults] valueForKey:@"siteName"];
//        NSLog(@"siteName = %@", siteName);

        NSString *indexScoutContent = @"";
        NSString *indexTemplate = [self indexTemplate];
//        NSLog(@"indexTemplate = %@", indexTemplate);

        NSString *defaultTemplate = [self defaultTemplate];
//        NSLog(@"defaultTemplate = %@", defaultTemplate);

        siteURL = [siteURL stringByAppendingString:@"/"];

        for (JBPost *postObject in frontPagePosts)
        {
            
            NSScanner* scanner;
            NSString *titleString;
            if([postObject text] == (id) [NSNull null] || [[postObject text] length]==0 || [[postObject text] isEqual:@""])
            {
            } else {
                scanner = [NSScanner scannerWithString:[postObject text]];
                [scanner scanUpToString:@"\n" intoString:&titleString];
                titleString = [titleString stringByAppendingString:@"\n"];

            }



            NSRange range = [titleString rangeOfString:@"@@ "];
            
            if (range.location == NSNotFound)
            {
                
//                NSLog(@"Not a page, process.");
                
                NSString *tempPostDate = [self postDate:postObject];
                
//                NSLog(@"tempPostDate = %@", tempPostDate);
                
                NSString *buildingScoutContent;
                if([self postTemplate] == (id) [NSNull null] || [[self postTemplate] length]==0 || [[self postTemplate] isEqual:@""])
                {
                } else {
                    buildingScoutContent = [[self postTemplate] stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CSS_YYYY" withString:@""];
                }

                
                
                
                
                
                NSString *buildingScoutContent1;
                if([postObject valueForKey:@"title" ] == (id) [NSNull null] || [[postObject valueForKey:@"title" ] length]==0 || [[postObject valueForKey:@"title" ] isEqual:@""])
                {
                } else {
                    buildingScoutContent1 = [buildingScoutContent stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_TITLE_YYYY" withString:[postObject valueForKey:@"title" ]];

                }

                
                
                
                
                
                
                
                
                
                NSString *finalPostURL = [self postURL:postObject];
//                NSLog(@"finalPostURL = %@", finalPostURL);
                
                
                
                
                
                NSString *sitePlusFinal;
                if(finalPostURL == (id) [NSNull null] || [finalPostURL length]==0 || [finalPostURL isEqual:@""])
                {
                } else {
                    sitePlusFinal = [siteURL stringByAppendingString:finalPostURL];
                    
                }

                
                
                
                
                NSString *post4;
                if(sitePlusFinal == (id) [NSNull null] || [sitePlusFinal length]==0 || [sitePlusFinal isEqual:@""])
                {
                } else {
                    post4 = [buildingScoutContent1 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_URL_YYYY" withString:sitePlusFinal];
                    
                }

                
                
                
                
                
                
                
                
                
                
                
                
                NSString *textWithoutTitle = [[scanner string] stringByReplacingOccurrencesOfString:titleString withString:@""];

                
                
                
                
                
                
                
                
                
                
                
                
                NSString *buildingScoutContent2;
                if(textWithoutTitle == (id) [NSNull null] || [textWithoutTitle length]==0 || [textWithoutTitle isEqual:@""])
                {
                } else {
                    JBMarkdownConverter *mdConverter = [[JBMarkdownConverter alloc] init];

                    buildingScoutContent2 = [post4 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:[mdConverter markdown2HTML:textWithoutTitle]];
                    
                }

                
                
                
                
                
                
                
                

                
                NSString *buildingScoutContent3;
                if(tempPostDate == (id) [NSNull null] || [tempPostDate length]==0 || [tempPostDate isEqual:@""])
                {
                } else {
                    buildingScoutContent3 = [buildingScoutContent2 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_DATE_YYYY" withString:tempPostDate];
                    
                }

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                if(buildingScoutContent3 == (id) [NSNull null] || [buildingScoutContent3 length]==0 || [buildingScoutContent3 isEqual:@""])
                {
                } else {
                    indexScoutContent = [indexScoutContent stringByAppendingString:buildingScoutContent3];
                    
                }
                


            }
        }
        
        

        NSString *tempIndex;
        if(indexScoutContent == (id) [NSNull null] || [indexScoutContent length]==0 || [indexScoutContent isEqual:@""])
        {
        } else {
            tempIndex = [indexTemplate stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_CONTENT_YYYY" withString:indexScoutContent];            
        }

        
        
        // Build the index.html file for writing to disk
        
        NSString *indexHTML1;
        if(siteURL == (id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
        {
        } else {
            indexHTML1 = [defaultTemplate stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_URL_YYYY" withString:siteURL];
        }

        
        

        NSString *indexHTML2;
        if(siteName == (id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
        {
        } else {
            indexHTML2 = [indexHTML1 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_TITLE_YYYY" withString:siteName];
        }

        
        
        
        NSString *indexHTML3;
        if(siteName == (id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
        {
        } else {
            indexHTML3 = [indexHTML2 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_PAGE_TITLE_YYYY" withString:siteName];
        }
        

        
        NSString *indexHTML4;
        if(tempIndex == (id) [NSNull null] || [tempIndex length]==0 || [tempIndex isEqual:@""])
        {
        } else {
            indexHTML4 = [indexHTML3 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:tempIndex];
        }

        
        
        NSString *indexHTML5;
        if(indexHTML4 == (id) [NSNull null] || [indexHTML4 length]==0 || [indexHTML4 isEqual:@""])
        {
        } else {
            indexHTML5 = [indexHTML4 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CSS_YYYY" withString:@""];
        }


        return indexHTML5;
        
    } else {
        
        return nil;
    }
    
}




- (NSString *)buildArchive:(NSArray *)allPosts
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    // Build posts list
    NSString *postRawHTML =  @"<ul>";
    
    for (JBPost *postObject in allPosts)
    {
        NSString *titleString;
        
        NSScanner* scanner = [NSScanner scannerWithString:[postObject text]];
        [scanner scanUpToString:@"\n" intoString:&titleString];
        titleString = [titleString stringByAppendingString:@"\n"];

        NSRange range = [titleString rangeOfString:@"@@"];
        
        if (range.location != NSNotFound)
        {

        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            NSString *dateFormat = [defaults valueForKey:@"dateFormat"];
            if(dateFormat == (id) [NSNull null] || [dateFormat length]==0 || [dateFormat isEqual:@""])
            {
                [dateFormatter setDateFormat:@"MM dd, yyyy"];
            } else {
                [dateFormatter setDateFormat:dateFormat];
            }

            
            NSDate *postDate = [postObject date];
            NSString *postDateFormated = [dateFormatter stringFromDate:postDate];
            
            NSString *finalPostURL = [self postURL:postObject];
            NSString *postTitle = [postObject title];
            
            postRawHTML = [postRawHTML stringByAppendingString:@"\n <li><span>"];
            
            if(postDateFormated == (id) [NSNull null] || [postDateFormated length]==0 || [postDateFormated isEqual:@""])
            {
            } else {
                postRawHTML = [postRawHTML stringByAppendingString:postDateFormated];
                
            }
            
            postRawHTML = [postRawHTML stringByAppendingString:@" : "];
            postRawHTML = [postRawHTML stringByAppendingString:@"<a href=\""];

            NSString *siteURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"siteURL"];

            postRawHTML = [postRawHTML stringByAppendingString:siteURL];
            
            postRawHTML = [postRawHTML stringByAppendingString:@"/"];

            
            if(finalPostURL == (id) [NSNull null] || [finalPostURL length]==0 || [finalPostURL isEqual:@""])
            {
            } else {
                postRawHTML = [postRawHTML stringByAppendingString:finalPostURL];
                
            }

            postRawHTML = [postRawHTML stringByAppendingString:@"\">"];
            
            if(postTitle == (id) [NSNull null] || [postTitle length]==0 || [postTitle isEqual:@""])
            {
            } else {
                postRawHTML = [postRawHTML stringByAppendingString:postTitle];
                
            }

            
            postRawHTML = [postRawHTML stringByAppendingString:@"</a></li> <br /> \n"];

        }
    }
    
    postRawHTML = [postRawHTML stringByAppendingString:@"</ul>"];
    

    
    
    
    
    
    NSString *siteURL = [defaults valueForKey:@"siteURL"];
    siteURL = [siteURL stringByAppendingString:@"/"];

    NSString *siteName = [defaults valueForKey:@"siteName"];


    
    
    NSString *postTemplate = [self postTemplate];
    
    
    // Build the final post page
    
    NSString *post1;
    if(postRawHTML == (id) [NSNull null] || [postRawHTML length]==0 || [postRawHTML isEqual:@""])
    {
    } else {
        post1 = [postTemplate stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:postRawHTML];
        
    }

    
    
    
    
    NSString *post3 = [post1 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_TITLE_YYYY" withString:@"Archive"];
    //  NSLog(@"post3 = %@", post3);
        
    NSString *post5;
    if(post3 == (id) [NSNull null] || [post3 length]==0 || [post3 isEqual:@""])
    {
    } else {
        post5 = [[self defaultTemplate] stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:post3];
        
    }

    
    
    
    NSString *cssTmp = [post5 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CSS_YYYY" withString:@""];
    

    
    
    
    NSString *post6;
    if(siteURL == (id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
    {
    } else {
        post6 = [cssTmp stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_URL_YYYY" withString:siteURL];
        
    }


    
    
    
    
    NSString *post7;
    if(siteName == (id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        post7 = [post6 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_TITLE_YYYY" withString:siteName];
        
    }
    


    
    NSString *post8;
    if(siteName == (id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        post8 = [post7 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_PAGE_TITLE_YYYY" withString:siteName];
        
    }


    NSString *post9 = [post8 stringByReplacingOccurrencesOfString:@"Posted on YYYY_SCOUT_POST_DATE_YYYY" withString:@""];

    
    return post9;

}

- (NSString *)buildPostWithoutCSS:(JBPost *)postObject
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *postDate = [postObject date];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *dateFormat = [defaults valueForKey:@"dateFormat"];
    if(dateFormat == (id) [NSNull null] || [dateFormat length]==0 || [dateFormat isEqual:@""])
    {
        [dateFormatter setDateFormat:@"MM dd, yyyy"];
    } else {
        [dateFormatter setDateFormat:dateFormat];
    }

    
    NSString *postDateFormated;
    if([dateFormatter stringFromDate:postDate]==(id) [NSNull null] || [[dateFormatter stringFromDate:postDate] length]==0 || [[dateFormatter stringFromDate:postDate] isEqual:@""])
    {
        
    } else {
        postDateFormated = [dateFormatter stringFromDate:postDate];
    }
    
    
    
    
    
    NSString *siteURL;
    if([defaults valueForKey:@"siteURL"]==(id) [NSNull null] || [[defaults valueForKey:@"siteURL"] length]==0 || [[defaults valueForKey:@"siteURL"] isEqual:@""])
    {
    } else {
        siteURL = [defaults valueForKey:@"siteURL"];
    }
    
    
    
    NSString *siteName;
    if([defaults valueForKey:@"siteName"]==(id) [NSNull null] || [[defaults valueForKey:@"siteName"] length]==0 || [[defaults valueForKey:@"siteName"] isEqual:@""])
    {
    } else {
        siteName = [defaults valueForKey:@"siteName"];
    }
    
    
    NSString *finalPostURL = [self postURL:postObject];
    
    
    NSString *titleString;
    
    NSScanner* scanner = [NSScanner scannerWithString:[postObject text]];
    [scanner scanUpToString:@"\n" intoString:&titleString];
    titleString = [titleString stringByAppendingString:@"\n"];
    NSString *textWithoutTitle = [[scanner string] stringByReplacingOccurrencesOfString:titleString withString:@""];
   // NSLog(@"textWithoutTitle = %@", textWithoutTitle);

    
    
    
    NSString *postRawHTML;
    if(textWithoutTitle==(id) [NSNull null] || [textWithoutTitle length]==0 || [textWithoutTitle isEqual:@""])
    {
    } else {
        JBMarkdownConverter *mdConverter = [[JBMarkdownConverter alloc] init];

        postRawHTML = [mdConverter markdown2HTML:textWithoutTitle];
    }
    
    
    

    
    
    NSString *postTemplate = [self postTemplate];
    
    
    NSString *post1;
    if(postRawHTML==(id) [NSNull null] || [postRawHTML length]==0 || [postRawHTML isEqual:@""])
    {
    } else {
        post1 = [postTemplate stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:postRawHTML];
        // NSLog(@"post1 = %@", post1);
    }
    
    
    
    
    
    
    NSString *post2;
    if(postDateFormated==(id) [NSNull null] || [postDateFormated length]==0 || [postDateFormated isEqual:@""])
    {
    } else {
        post2 = [post1 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_DATE_YYYY" withString:postDateFormated];
        //     NSLog(@"post2 = %@", post2);
    }
    
    
    
    
    
    
    
    NSString *post3;
    if([postObject valueForKey:@"title"]==(id) [NSNull null] || [[postObject valueForKey:@"title"] length]==0 || [[postObject valueForKey:@"title"] isEqual:@""])
    {
        
    } else {
        post3 = [post2 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_TITLE_YYYY" withString:[postObject valueForKey:@"title"]];
        //     NSLog(@"post3 = %@", post3);
    }
    
    

    siteURL = [siteURL stringByAppendingString:@"/"];

    NSString *post4;
    if(finalPostURL==(id) [NSNull null] || [finalPostURL length]==0 || [finalPostURL isEqual:@""])
    {
    } else {
        post4 = [post3 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_URL_YYYY" withString:[siteURL stringByAppendingString:finalPostURL]];
        //     NSLog(@"post2 = %@", post2);
    }

    //   NSLog(@"post4 = %@", post4);
    
    NSString *post5;
    if(post4==(id) [NSNull null] || [post4 length]==0 || [post4 isEqual:@""])
    {
    } else {
        post5 = [[self defaultTemplate] stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:post4];
        //     NSLog(@"post2 = %@", post2);
    }

    //  NSLog(@"post5 = %@", post5);
        
    
    
    NSString *cssTmp = [post5 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CSS_YYYY" withString:@""];
    //  NSLog(@"cssTmp = %@", cssTmp);
    
    NSString *post6;
    if(siteURL==(id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
    {
    } else {
        post6 = [cssTmp stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_URL_YYYY" withString:siteURL];
        //     NSLog(@"post2 = %@", post2);
    }

    //  NSLog(@"post6 = %@", post6);
    
    NSString *post7;
    if(siteName==(id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        post7 = [post6 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_TITLE_YYYY" withString:siteName];
        //     NSLog(@"post7 = %@", post7);
    }
    
    
    
    
    NSString *post8;
    if(siteName==(id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        post8 = [post7 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_PAGE_TITLE_YYYY" withString:siteName];
        //     NSLog(@"post8 = %@", post8);
    }
    
    return post8;
}

- (NSString *)buildAtomXML:(NSArray *)frontPagePosts
{
    NSString *atomTemplate = [self atomTemplate];
    if(atomTemplate==(id) [NSNull null] || [atomTemplate length]==0 || [atomTemplate isEqual:@""])
    {
        return nil;
    }

   // NSLog(@"atomTemplate = %@", atomTemplate);
    
    NSString *atomXml = [self atomXml];
    if(atomXml==(id) [NSNull null] || [atomXml length]==0 || [atomXml isEqual:@""])
    {
        return nil;
    }
    
    // NSLog(@"atomXml = %@", atomXml);


    NSString *siteName = [[NSUserDefaults standardUserDefaults] valueForKey:@"siteName"];
    if(siteName==(id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
        return nil;
    }

   // NSLog(@"siteName = %@", siteName);

    NSString *siteURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"siteURL"];
    if(siteURL==(id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
    {
        return nil;
    }

    NSString *indexScoutContent = @"<p></p>";
    
    
    for (JBPost *postObject in frontPagePosts)
    {
        NSString *titleString;
        
        NSScanner* scanner = [NSScanner scannerWithString:[postObject text]];
        [scanner scanUpToString:@"\n" intoString:&titleString];
        titleString = [titleString stringByAppendingString:@"\n"];

        NSRange range = [titleString rangeOfString:@"@@"];
        
        if (range.location != NSNotFound)
        {
            
        } else {
            
            
            NSString *tempPostURL = [self postURL:postObject];
            NSString *tempPostDate = [self postDate:postObject];
            
            siteURL = [siteURL stringByAppendingString:@"/"];
            
            NSString *buildingScoutContent;
            if(tempPostURL==(id) [NSNull null] || [tempPostURL length]==0 || [tempPostURL isEqual:@""])
            {
            } else {
                buildingScoutContent = [atomTemplate stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_URL_YYYY"
                                                                               withString:[siteURL stringByAppendingPathComponent:tempPostURL]];
            }
            
            
            
            NSString *buildingScoutContent1;
            if([postObject valueForKey:@"title" ]==(id) [NSNull null] || [[postObject valueForKey:@"title" ] length]==0 || [[postObject valueForKey:@"title" ] isEqual:@""])
            {
            } else {
                buildingScoutContent1 = [buildingScoutContent stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_TITLE_YYYY"
                                                                                        withString:[postObject valueForKey:@"title" ]];
            }
            
            
            NSString *buildingScoutContent2;
            if([postObject valueForKey:@"text" ]==(id) [NSNull null] || [[postObject valueForKey:@"text" ] length]==0 || [[postObject valueForKey:@"text" ] isEqual:@""])
            {
            } else {
                JBMarkdownConverter *mdConverter = [[JBMarkdownConverter alloc] init];

                buildingScoutContent2 = [buildingScoutContent1 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_CONTENT_YYYY"
                                                                                         withString:[mdConverter markdown2HTML:[postObject valueForKey:@"text" ]]];
            }
            
            
            NSString *buildingScoutContent3;
            if(tempPostDate==(id) [NSNull null] || [tempPostDate length]==0 || [tempPostDate isEqual:@""])
            {
            } else {
                buildingScoutContent3 = [buildingScoutContent2 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_POST_DATE_YYYY"
                                                                                         withString:tempPostDate];
            }
            
            
            NSString *buildingScoutContent4;
            if([postObject valueForKey:@"title"]==(id) [NSNull null] || [[postObject valueForKey:@"title"] length]==0 || [[postObject valueForKey:@"title"] isEqual:@""])
            {
            } else {
                buildingScoutContent4 = [buildingScoutContent3 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_AUTHOR_YYYY"
                                                                                         withString:[postObject valueForKey:@"title"]];
            }
            
            
            
            if(buildingScoutContent4==(id) [NSNull null] || [buildingScoutContent4 length]==0 || [buildingScoutContent4 isEqual:@""])
            {
            } else {
                indexScoutContent = [indexScoutContent stringByAppendingString:buildingScoutContent4];
            }        

            
            
        }
    }
    
    NSString *tempIndex;
    if(indexScoutContent==(id) [NSNull null] || [indexScoutContent length]==0 || [indexScoutContent isEqual:@""])
    {
    } else {
        tempIndex = [atomXml stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_5ATOMPOSTS_YYYY" withString:indexScoutContent];
    }

    
    
    // Build the atom.xml file for writing to disk
    
    NSString *indexHTML1;
    if(siteURL==(id) [NSNull null] || [siteURL length]==0 || [siteURL isEqual:@""])
    {
    } else {
        indexHTML1 = [tempIndex stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_URL_YYYY" withString:siteURL];
    }
    

    NSString *indexHTML2;
    if(siteName==(id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        indexHTML2 = [indexHTML1 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_TITLE_YYYY" withString:siteName];
    }

    NSString *indexHTML3;
    if(siteName==(id) [NSNull null] || [siteName length]==0 || [siteName isEqual:@""])
    {
    } else {
        indexHTML3 = [indexHTML2 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_PAGE_TITLE_YYYY" withString:siteName];
    }

    NSString *indexHTML4;
    if(tempIndex==(id) [NSNull null] || [tempIndex length]==0 || [tempIndex isEqual:@""])
    {
    } else {
        indexHTML4 = [indexHTML3 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CONTENT_YYYY" withString:tempIndex];
    }

    NSString *indexHTML5 = [indexHTML4 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_AUTHOR_YYYY" withString:@""];
    NSString *indexHTML6 = [indexHTML5 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_SUBTITLE_YYYY" withString:@""];
    NSString *indexHTML7 = [indexHTML6 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CURRENTDATE_YYYY" withString:[[NSDate date] description] ];
    NSString *indexHTML8 = [indexHTML7 stringByReplacingOccurrencesOfString:@"YYYY_SCOUT_CURRENTYEAR_YYYY" withString:@"" ];
    
 //   NSLog(@"atom indexHTML8= %@", indexHTML8);
    return indexHTML8;
    
}

- (NSString *)postTemplate
{
    
    
    
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
    NSString *themesPath;
    if(path==(id) [NSNull null] || [path length]==0 || [path isEqual:@""])
    {
    } else {
        themesPath = [path stringByAppendingPathComponent:@"templates"];
    }


    NSString *themeDir = [defaults valueForKey:@"defaultTheme"];
    
    
    if(themeDir==(id) [NSNull null] || [themeDir length]==0 || [themeDir isEqual:@""])
    {
    } else {
        themeDir = [themesPath stringByAppendingPathComponent:[themeDir lastPathComponent]];
    }
    


    NSError *error;
    NSString *postTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"post.html"]  encoding:NSUTF8StringEncoding error:&error];
    
    if(postTemplate==(id) [NSNull null] || [postTemplate length]==0 || [postTemplate isEqual:@""])
    {
        NSLog(@"Error loading the postTemplate: %@", [error description]);
        return nil;
    }
    
    // NSLog(@"postTemplate from method: %@", postTemplate);
    return postTemplate;
}


- (NSString *)defaultTemplate
{
    NSString *defaultTemplate;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *themeDir = [defaults valueForKey:@"defaultTheme"];
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
   // NSLog(@"themeDir = %@", [themeDir lastPathComponent]);
    
    if(themeDir==(id) [NSNull null] || [themeDir length]==0 || [themeDir isEqual:@""])
    {
    } else {
        themeDir = [themesPath stringByAppendingPathComponent:[themeDir lastPathComponent]];
    }
   // NSLog(@"themeDir = %@", themeDir);

    NSError *error;

    defaultTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"default.html"]  encoding:NSUTF8StringEncoding error:&error];
    if(defaultTemplate==(id) [NSNull null] || [defaultTemplate length]==0 || [defaultTemplate isEqual:@""])
    {
        NSLog(@"Error loading the defaultTemplate: %@", [error description]);
        return nil;
    }

    return defaultTemplate;
}

- (NSString *)defaultCSS
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSError *error;

    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSString *themeDir = [defaults valueForKey:@"defaultTheme"];
   // NSLog(@"themeDir = %@", themeDir);
    
    if(themeDir==(id) [NSNull null] || [themeDir length]==0 || [themeDir isEqual:@""])
    {
    } else {
        themeDir = [themesPath stringByAppendingPathComponent:[themeDir lastPathComponent]];
    }
   // NSLog(@"themeDir = %@", themeDir);

    
    
    NSString *defaultCSS;
    defaultCSS = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"base.css"]  encoding:NSUTF8StringEncoding error:nil];
    if(defaultCSS==(id) [NSNull null] || [defaultCSS length]==0 || [defaultCSS isEqual:@""])
    {
        NSLog(@"Error loading the defaultCSS: %@", [error description]);
        return nil;
    }

   // NSLog(@"defaultCSS = %@", defaultCSS);
    return defaultCSS;
}


- (NSString *)postURL:(JBPost *)post
{
    NSError *error;
    NSDate *postDate = [post date];
    if([postDate description]==(id) [NSNull null] || [[postDate description] length]==0 || [[postDate description] isEqual:@""])
    {
        NSLog(@"Error loading the postDate: %@", [error description]);
        return nil;
    }
    
    NSString *postTitle = [post title];
    if(postTitle==(id) [NSNull null] || [postTitle length]==0 || [postTitle isEqual:@""])
    {
        NSLog(@"Error loading the postTitle: %@", [error description]);
        return nil;
    }

  //  NSLog(@"postTitle = %@", postTitle);

    NSString *postTitleEscaped = [postTitle stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-"] invertedSet];
    postTitleEscaped = [[postTitleEscaped componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
  //  NSLog (@"Result: %@", postTitleEscaped);
    

    
    
    NSString *postDateFormated = [postDate descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
  //  NSLog(@"postDateFormated = %@", postDateFormated);

    postDateFormated = [postDateFormated stringByAppendingString:@"/"];

    NSString *postStartFormat = [postDateFormated stringByAppendingString:postTitleEscaped];
  //  NSLog(@"postStartFormat = %@", postStartFormat);

    NSString *postFinalURL = [postStartFormat stringByAppendingPathExtension:@"html"];
    if(postFinalURL==(id) [NSNull null] || [postFinalURL length]==0 || [postFinalURL isEqual:@""])
    {
        NSLog(@"Error loading the postFinalURL: %@", [error description]);
        return nil;
    }

  //  NSLog(@"postFinalURL = %@", postFinalURL);

    return postFinalURL;
}

- (NSString *)postDate:(JBPost *)post
{
    NSDate *postDate = [post date];
    NSError *error;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *dateFormat = [defaults valueForKey:@"dateFormat"];
    if(dateFormat == (id) [NSNull null] || [dateFormat length]==0 || [dateFormat isEqual:@""])
    {
        [dateFormatter setDateFormat:@"MM dd, yyyy"];
    } else {
        [dateFormatter setDateFormat:dateFormat];
    }

    
    NSString *postDateFormated = [dateFormatter stringFromDate:postDate];
    if(postDateFormated==(id) [NSNull null] || [postDateFormated length]==0 || [postDateFormated isEqual:@""])
    {
        NSLog(@"Error loading the postDateFormated: %@", [error description]);
        return nil;
    }
    
    return postDateFormated;
}


#pragma mark Building Strings

- (NSString *)indexTemplate
{
    NSError *error;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
//    NSLog(@"index template path = %@", path);
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
//    NSLog(@"themes path = %@", themesPath);

    NSString *themeDir = [[defaults valueForKey:@"defaultTheme"] lastPathComponent];
//     NSLog(@"themeDir = %@", themeDir);
    
    themeDir = [themesPath stringByAppendingPathComponent:themeDir];
//     NSLog(@"themeDir = %@", themeDir);
    
    
    
    NSString *indexTemplate;
    indexTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"indexTemplate.html"] encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"indexTemplate return = %@", indexTemplate);
    if(indexTemplate==(id) [NSNull null] || [indexTemplate length]==0 || [indexTemplate isEqual:@""])
    {
        NSLog(@"Error loading the indexTemplate: %@", [error description]);
        return nil;
    }

    return indexTemplate;
}

- (NSString *)atomTemplate
{
    NSError *error;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSString *themeDir = [[defaults valueForKey:@"defaultTheme"] lastPathComponent];
//     NSLog(@"themeDir = %@", themeDir);
    
    themeDir = [themesPath stringByAppendingPathComponent:themeDir];
//     NSLog(@"themeDir = %@", themeDir);
    
    
    
    NSString *atomTemplate;
    atomTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"atomTemplate.xml"]  encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"atomTemplate = %@", atomTemplate);
    if(atomTemplate==(id) [NSNull null] || [atomTemplate length]==0 || [atomTemplate isEqual:@""])
    {
        NSLog(@"Error loading the atomTemplate: %@", [error description]);
        return nil;
    }

    return atomTemplate;
}

- (NSString *)atomXml
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSString *themeDir = [[defaults valueForKey:@"defaultTheme"] lastPathComponent];
    //     NSLog(@"themeDir = %@", themeDir);
    
    themeDir = [themesPath stringByAppendingPathComponent:themeDir];
    //     NSLog(@"themeDir = %@", themeDir);

    
    NSString *atomXml;
    atomXml = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"atom.xml"]  encoding:NSUTF8StringEncoding error:nil];
    NSError *error;

    if(atomXml==(id) [NSNull null] || [atomXml length]==0 || [atomXml isEqual:@""])
    {
        NSLog(@"Error loading the atomXml: %@", [error description]);
        return nil;
    }

    return atomXml;
}

- (NSString *)colophonTemplate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSString *themeDir = [[defaults valueForKey:@"defaultTheme"] lastPathComponent];
    //     NSLog(@"themeDir = %@", themeDir);
    
    themeDir = [themesPath stringByAppendingPathComponent:themeDir];
    //     NSLog(@"themeDir = %@", themeDir);

    NSString *colophonTemplate;
    colophonTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"colophon.markdown"]  encoding:NSUTF8StringEncoding error:nil];
    NSError *error;
    
    if(colophonTemplate==(id) [NSNull null] || [colophonTemplate length]==0 || [colophonTemplate isEqual:@""])
    {
        NSLog(@"Error loading the colophonTemplate: %@", [error description]);
        return nil;
    }

    return colophonTemplate;
}

- (NSString *)contactTemplate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSString *themeDir = [[defaults valueForKey:@"defaultTheme"] lastPathComponent];
    //     NSLog(@"themeDir = %@", themeDir);
    
    themeDir = [themesPath stringByAppendingPathComponent:themeDir];
    //     NSLog(@"themeDir = %@", themeDir);

    NSString *contactTemplate;
    contactTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"contact.html"]  encoding:NSUTF8StringEncoding error:nil];
    NSError *error;
    
    if(contactTemplate==(id) [NSNull null] || [contactTemplate length]==0 || [contactTemplate isEqual:@""])
    {
        NSLog(@"Error loading the contactTemplate: %@", [error description]);
        return nil;
    }

    return contactTemplate;
}

- (NSString *)indexTxtTemplate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSString *themeDir = [[defaults valueForKey:@"defaultTheme"] lastPathComponent];
    //     NSLog(@"themeDir = %@", themeDir);
    
    themeDir = [themesPath stringByAppendingPathComponent:themeDir];
    //     NSLog(@"themeDir = %@", themeDir);

    NSString *indexTxtTemplate;
    indexTxtTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"index.txt"]  encoding:NSUTF8StringEncoding error:nil];
    NSError *error;
    
    if(indexTxtTemplate==(id) [NSNull null] || [indexTxtTemplate length]==0 || [indexTxtTemplate isEqual:@""])
    {
        NSLog(@"Error loading the indexTxtTemplate: %@", [error description]);
        return nil;
    }

    return indexTxtTemplate;
}

- (NSString *)robotsTemplate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSString *themeDir = [[defaults valueForKey:@"defaultTheme"] lastPathComponent];
    //     NSLog(@"themeDir = %@", themeDir);
    
    themeDir = [themesPath stringByAppendingPathComponent:themeDir];
    //     NSLog(@"themeDir = %@", themeDir);

    NSString *robotsTemplate;
    robotsTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"robots.txt"]  encoding:NSUTF8StringEncoding error:nil];
    NSError *error;
    
    if(robotsTemplate==(id) [NSNull null] || [robotsTemplate length]==0 || [robotsTemplate isEqual:@""])
    {
        NSLog(@"Error loading the robotsTemplate: %@", [error description]);
        return nil;
    }

    return robotsTemplate;
}

- (NSString *)tocTemplate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSString *themeDir = [[defaults valueForKey:@"defaultTheme"] lastPathComponent];
    //     NSLog(@"themeDir = %@", themeDir);
    
    themeDir = [themesPath stringByAppendingPathComponent:themeDir];
    //     NSLog(@"themeDir = %@", themeDir);

    NSString *tocTemplate;
    tocTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"toc.html"]  encoding:NSUTF8StringEncoding error:nil];
    NSError *error;
    
    if(tocTemplate==(id) [NSNull null] || [tocTemplate length]==0 || [tocTemplate isEqual:@""])
    {
        NSLog(@"Error loading the tocTemplate: %@", [error description]);
        return nil;
    }

    return tocTemplate;
}

- (NSString *)fourOhFourTemplate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    // NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *path;
    
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    NSString *themesPath = [path stringByAppendingPathComponent:@"templates"];
    
    NSString *themeDir = [[defaults valueForKey:@"defaultTheme"] lastPathComponent];
    //     NSLog(@"themeDir = %@", themeDir);
    
    themeDir = [themesPath stringByAppendingPathComponent:themeDir];
    //     NSLog(@"themeDir = %@", themeDir);

    NSString *fourOhFourTemplate;
    fourOhFourTemplate = [[NSString alloc] initWithContentsOfFile:[themeDir stringByAppendingPathComponent:@"404.html"]  encoding:NSUTF8StringEncoding error:nil];
    NSError *error;
    
    if(fourOhFourTemplate==(id) [NSNull null] || [fourOhFourTemplate length]==0 || [fourOhFourTemplate isEqual:@""])
    {
        NSLog(@"Error loading the fourOhFourTemplate: %@", [error description]);
        return nil;
    }

    return fourOhFourTemplate;
}



@end

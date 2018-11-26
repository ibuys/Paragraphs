//
//  JBThemeChooserController.m
//  Scout
//
//  Created by Jon Buys on 12/29/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBThemeChooserController.h"
#import "JBAppSupportDir.h"
#import "JBTheme.h"
#import "JBSiteBuilder.h"
#import "JBPost.h"

@implementation JBThemeChooserController

- (void)awakeFromNib
{
  //  NSLog(@"awakeFromNib");
    
    // Read the themes directory
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
    
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:mediaPath];
  //  NSLog(@"themes path = %@", mediaPath);
    
    NSString *file;
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString: @"ptf"])
        {
            // Create a new theme object from each
            // Load them into the array
          //  NSLog(@"scout template file: %@", [mediaPath stringByAppendingPathComponent:file]);
            [self processTemplate:[mediaPath stringByAppendingPathComponent:file]];
        }
    }


    [themesArrayController addObserver:self forKeyPath:@"selectedObjects"
                         options:NSKeyValueObservingOptionNew context:nil];
    
    
    [highlightBox setCornerRadius:50.0];
    
    
    
    
    
    
    NSString *defaultTheme = [defaults valueForKey:@"defaultTheme"];
    NSArray *themesArray = [themesArrayController arrangedObjects];
  //  NSLog(@"themesArray = %@", themesArray);
    NSIndexSet *fakeIndexSet = [NSIndexSet indexSetWithIndex:0];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [mainCollectionView setSelectionIndexes:fakeIndexSet];

    for (JBTheme *searchTheme in themesArray)
    {
        if ([searchTheme.themeName isEqual:defaultTheme])
        {
            NSUInteger selectedIndex = [themesArray indexOfObject:searchTheme];
            indexSet = [NSIndexSet indexSetWithIndex:selectedIndex];
          //  NSLog(@"Theme should be: %@", searchTheme.themeName);
        }
    }
    

    [mainCollectionView setSelectionIndexes:indexSet];

}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSArray *selectedArray = [object selectedObjects];
  //  NSLog(@"selectedArray = %@", selectedArray);
    
    
    JBTheme *selectedTheme;
    
    
    if ([selectedArray count] != 0)
    {
        selectedTheme = [selectedArray objectAtIndex:0];
        NSString *themeName = [selectedTheme themeName];
      //  NSLog(@"selection Changed: %@", themeName);
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:themeName forKey:@"defaultTheme"];
        
    }
    
    
}


//- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element
//    defaultMenuItems:(NSArray *)defaultMenuItems
//{
//    // disable right-click context menu
//    return nil;
//}

//- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange
//     toDOMRange:(DOMRange *)proposedRange
//       affinity:(NSSelectionAffinity)selectionAffinity
// stillSelecting:(BOOL)flag
//{
//    // disable text selection
//    return NO;
//}


//- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame  decisionListener:(id < WebPolicyDecisionListener >)listener
//
//{
//    
//    NSUInteger actionType = [[actionInformation objectForKey:WebActionNavigationTypeKey] unsignedIntValue];
//    if (actionType == WebNavigationTypeLinkClicked)
//    {
//        // Disable links in webView
//    
//    } else {
//        [listener use];
//    }
//    
//}

-(void)processTemplate:(NSString *)templatePath
{
    // NSLog(@"templatePath = %@", templatePath);
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:templatePath];
    JBTheme *newTheme = [[JBTheme alloc] init];

    NSString *file;
    while (file = [dirEnum nextObject])
    {
        if ([file isEqualToString: @"default.html"])
        {
            NSError *error;
            NSString *index = [NSString stringWithContentsOfFile:[templatePath stringByAppendingPathComponent:file] encoding:NSUTF8StringEncoding error:&error];
            [newTheme setThemeIndex:index];
            // NSLog(@"file = %@", file);
        }
        
        if ([file isEqualToString: @"screenshot.png"])
        {
            NSImage *screenshot = [[NSImage alloc] initWithContentsOfFile:[templatePath stringByAppendingPathComponent:file]];
            [newTheme setThemeThumbnailImage:screenshot];
            // NSLog(@"file = %@", file);
        }
    }
    
    [newTheme setThemeName:[templatePath lastPathComponent]];
    
    [themesArrayController addObject:newTheme];

}


@end

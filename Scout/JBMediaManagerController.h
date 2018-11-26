//
//  JBMediaManagerController.h
//  Scout
//
//  Created by Jonathan Buys on 11/27/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
#import "JBWindowController.h"

@interface JBMediaManagerController : NSObject
{
    IBOutlet IKImageBrowserView * imageBrowser;
    
	//the array that contains the items to show in the image browser
    NSMutableArray *images;
	
	//for search: filtered items are stored in this array (and initial indexes are stored in filteredOutIndexes)
    NSMutableArray *filteredOutImages;
	NSMutableIndexSet *filteredOutIndexes;
    
    IBOutlet JBWindowController *windowControl;   
}

- (void)setupBrowsing;
- (void) addImageWithPath:(NSString *) path;

- (IBAction) zoomSliderDidChange:(id)sender;
- (IBAction) searchFieldChanged:(id) sender;
- (IBAction)addImageToText:(id)sender;
@end

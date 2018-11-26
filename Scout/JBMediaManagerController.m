//
//  JBMediaManagerController.m
//  Scout
//
//  Created by Jonathan Buys on 11/27/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBMediaManagerController.h"
#import "JBAppSupportDir.h"

/* Our datasource object : represents one item in the browser */
@interface MyImageObject : NSObject
{
    NSString *path;
}
@end

@implementation MyImageObject


- (void) setPath:(NSString *) aPath
{
    if(path != aPath){
        path = aPath;
    }
}

#pragma mark -
#pragma mark item data source protocol

- (NSString *)  imageRepresentationType
{
	return IKImageBrowserPathRepresentationType;
}

- (id)  imageRepresentation
{
	return path;
}

- (NSString *) imageUID
{
    return path;
}

- (id) imageTitle
{
	return [path lastPathComponent];
}

@end

@implementation JBMediaManagerController

- (void) awakeFromNib
{
    [self setupBrowsing];
  //  NSLog(@"awakeFromNib");
}

#pragma mark -
#pragma mark import images from file system

/*
 code that parse a repository and add all entries to our datasource array,
 */



- (void) addImageWithPath:(NSString *) path
{
   // NSLog(@"addImageWithPath: %@", path);
    MyImageObject *item;
    
    NSString *filename = [path lastPathComponent];
    
	/* skip '.*' */
	if([filename length] > 0){
		char *ch = (char*) [filename UTF8String];
		
		if(ch)
			if(ch[0] == '.')
				return;
	}
	
	item = [[MyImageObject alloc] init];
	[item setPath:path];
	[images addObject:item];
    [imageBrowser reloadData];
}

- (void) addImagesFromDirectory:(NSString *) path
{
    long i, n;
    BOOL dir;
//	NSLog(@"path = %@", path);
    path = [path stringByReplacingOccurrencesOfString:@"file://localhost/" withString:@""];
    
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&dir];
    
    if(dir)
    {
      //  NSLog(@"OK, found a directory at %@", path);
        NSArray *content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        
        n = [content count];
        
        for(i=0; i<n; i++)
			[self addImageWithPath:[path stringByAppendingPathComponent:[content objectAtIndex:i]]];
    }
    else
        [self addImageWithPath:path];
    
  //  NSLog(@"adding Images from directory");
	
	[imageBrowser reloadData];
}



#pragma mark -
#pragma mark setupBrowsing


- (void) setupBrowsing
{
    
    // TODO Use an array controler to add images to the "images" array.
    
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    
    
    NSString *path;
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }
    
    NSString *mediaPath = [path stringByAppendingPathComponent:@"media"];

	//allocate our datasource array: will contain instances of MyImageObject
    images = [[NSMutableArray alloc] init];
    
	//-- add two directory to the datasource at launch
	[self addImagesFromDirectory:mediaPath];
    [imageBrowser setCanControlQuickLookPanel:YES];
}


#pragma mark -
#pragma mark actions


- (IBAction) zoomSliderDidChange:(id)sender
{
    [imageBrowser setZoomValue:[sender floatValue]/10];
}

- (void) imageBrowser:(IKImageBrowserView *) aBrowser cellWasDoubleClickedAtIndex:(NSUInteger) index
{
  //  NSLog(@"Double Clicked this: %@", [[[imageBrowser cellForItemAtIndex:index] representedItem] imageTitle]);
    
    NSString *imageToInsert = [[[imageBrowser cellForItemAtIndex:index] representedItem] imageTitle];

    [windowControl dropFromMediaManager:imageToInsert];

}


- (IBAction)addImageToText:(id)sender;
{

    NSUInteger firstIndex = [[imageBrowser selectionIndexes] firstIndex];
    NSString *imageToInsert = [[[imageBrowser cellForItemAtIndex:firstIndex] representedItem] imageTitle];
    [windowControl dropFromMediaManager:imageToInsert];
}

#pragma mark -
#pragma mark  drag'n drop

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	return [self draggingUpdated:sender];
}


- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
//	if ([sender draggingSource] == imageBrowser)
//		return NSDragOperationCopy;
	
    return NSDragOperationCopy;
}


- (BOOL) performDragOperation:(id <NSDraggingInfo>)sender
{
    NSData *data = nil;
    NSString *errorDescription;
    
	// if we are dragging from the browser itself, ignore it
	if ([sender draggingSource] == imageBrowser)
		return NO;
	
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    
    if ([[pasteboard types] containsObject:NSFilenamesPboardType])
        data = [pasteboard dataForType:NSFilenamesPboardType];
	
    if(data)
    {
        NSArray *filenames = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:kCFPropertyListImmutable format:nil errorDescription:&errorDescription];
		
        long i, n;
        n = [filenames count];
        for(i=0; i<n; i++){
			MyImageObject *item = [[MyImageObject alloc] init];
            NSString *fullPath = [self copyNewMedia:[filenames objectAtIndex:i]];
			[item setPath:fullPath];
			[images insertObject:item atIndex:[imageBrowser indexAtLocationOfDroppedItem]];
        }
		
		[imageBrowser reloadData];
    }
	
	return YES;
}

- (NSString *)copyNewMedia:(NSString *)fileName
{
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    NSString *path = [appSupDir applicationSupportDirectory];
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSString *mediaPath = [path stringByAppendingPathComponent:@"media"];
    
    if (![fileMan fileExistsAtPath:mediaPath])
    {
        NSError *er;
        
        
        if (![fileMan createDirectoryAtPath:mediaPath withIntermediateDirectories:NO attributes:nil error:&er])
        {
            NSLog(@"Uh oh, error copying file.");
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
    
    NSString *fullPath = [mediaPath stringByAppendingPathComponent:[[fileName lastPathComponent] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    
    NSError *error;
    
    NSURL *itemToCopy = [NSURL fileURLWithPath:fileName];
    NSURL *pathToCopyTo = [NSURL fileURLWithPath:fullPath];
    
    
    if (![fileMan fileExistsAtPath:fullPath])
    {
        if (![fileMan copyItemAtURL:itemToCopy toURL:pathToCopyTo error:&error])
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
    
    return fullPath;
}

#pragma mark -
#pragma mark IKImageBrowserDataSource

/* implement image-browser's datasource protocol
 Our datasource representation is a simple mutable array
 */

- (NSUInteger) numberOfItemsInImageBrowser:(IKImageBrowserView *) view
{
    return [images count];
}

- (id) imageBrowser:(IKImageBrowserView *) aBrowser itemAtIndex:(NSUInteger)index;

{
    return [images objectAtIndex:index];
}


#pragma mark -
#pragma mark optional datasource methods : reordering / removing

- (void) imageBrowser:(IKImageBrowserView *) aBrowser removeItemsAtIndexes: (NSIndexSet *) indexes
{
   // NSLog(@"delete item");
    
	NSArray *tempArray = [images objectsAtIndexes:indexes];
    
    for (MyImageObject *tempObject in tempArray)
    {
        NSString *path = [tempObject imageRepresentation];
        
        NSFileManager *myFileManager = [NSFileManager defaultManager];
        NSError *error;
        
        if ([myFileManager removeItemAtPath:path error:&error])
        {
            //NSLog(@"File should be gone");
        } else {
            NSLog(@"Error removing file: %@", [error description]);
        }

        
    }
    
	[images removeObjectsAtIndexes:indexes];
	[imageBrowser reloadData];
}

- (BOOL) imageBrowser:(IKImageBrowserView *) aBrowser moveItemsAtIndexes: (NSIndexSet *)indexes toIndex:(unsigned int)destinationIndex
{
    NSLog(@"rearrange");
	NSArray *tempArray = [images objectsAtIndexes:indexes];
	[images removeObjectsAtIndexes:indexes];
	
	destinationIndex -= [indexes countOfIndexesInRange:NSMakeRange(0, destinationIndex)];
	[images insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(destinationIndex, [tempArray count])]];
	[imageBrowser reloadData];
	
	return YES;
}




#pragma mark -
#pragma mark search

/*
 this code filters the "images" array depending on the current search field value. All items that are filtered-out are kept in the
 "filteredOutImages" array (and corresponding indexes are kept in "filteredOutIndexes" in order to restore these indexes when the search field is cleared
 */

- (BOOL) keyword:(NSString *) aKeyword matchSearch:(NSString *) search
{
    NSRange r = [aKeyword rangeOfString:search options:NSCaseInsensitiveSearch];
    // November 27, 2012 I changed r.location>=0 to r.location>=1
    // December 15, 2012 - changed it back, and then just removed that part entirely. r.location>=0 is always true.
   // return (r.length>0 && r.location>=0);
    return (r.length>0);
}

- (IBAction) searchFieldChanged:(id) sender
{
	if(filteredOutImages == nil){
		//first time we use the search field
		filteredOutImages = [[NSMutableArray alloc] init];
		filteredOutIndexes = [[NSMutableIndexSet alloc] init];
	}
	else{
		//restore the original datasource, and restore the initial ordering if possible
        
		NSUInteger lastIndex = [filteredOutIndexes lastIndex];
		if(lastIndex >= [images count] + [filteredOutImages count]){
			//can't restore previous indexes, just insert filtered items at the beginning
			[images insertObjects:filteredOutImages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [filteredOutImages count])]];
		}
		else
			[images insertObjects:filteredOutImages atIndexes:filteredOutIndexes];
        
		[filteredOutImages removeAllObjects];
		[filteredOutIndexes removeAllIndexes];
	}
	
	//add filtered images to the filteredOut array
	NSString *searchString = [sender stringValue];
    
    if(searchString != nil && [searchString length] > 0)
    {
		long i, n;
		
		n = [images count];
		
		for(i=0; i<n; i++)
        {
			MyImageObject *anItem = [images objectAtIndex:i];
			
			if([self keyword:[anItem imageTitle] matchSearch:searchString] == NO)
            {
				[filteredOutImages addObject:anItem];
				[filteredOutIndexes addIndex:i];
			}
		}
	}
	
	//remove filtered-out images from the datasource array
	[images removeObjectsInArray:filteredOutImages];
	
	//reflect changes in the browser
	[imageBrowser reloadData];
}



@end

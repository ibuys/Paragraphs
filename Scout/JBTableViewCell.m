//
//  JBTableViewCell.m
//  Go2
//
//  Created by Jonathan Buys on 10/24/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBTableViewCell.h"


@implementation JBTableViewCell

#define kIconImageSize		50.0

#define kImageOriginXOffset 3
#define kImageOriginYOffset 10

#define kTextOriginXOffset	2
#define kTextOriginYOffset	2
#define kTextHeightAdjust	4

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	//
	// Let's get fancy!
	//
	
	
	//Used to detect where our files are
	//	NSBundle *bundle = [NSBundle mainBundle];
	//	
	//	//Allocates and loads the images into the application which will be used for our NSStatusItem
	//	backgroundImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Chalkboard" ofType:@"png"]];	
	//	[backgroundImage setFlipped:YES];
	//
	//	[backgroundImage drawInRect:cellFrame
	//			 fromRect:NSMakeRect(0,0,[backgroundImage size].width, [backgroundImage size].height)
	//			operation:NSCompositeSourceAtop
	//			 fraction:1.0];
	//	
	//
	// No More fancy?
	//
	
	NSPoint textPoint;
	
	// Get the NSManaged object for this cell
	NSObject* data = [self objectValue];
	NSString* title  = [data valueForKey:@"title"];
	NSString *tags = [data valueForKey:@"tags"];
	
	// Get the icon
	
    // Actually, we should probably create a new icon set for this, one for published, one for draft, and one for... I don't know what.
	NSString *iconImage = @"/Applications/Safari.app";
	NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:iconImage];
	[image setFlipped:NO];
	
	NSImageInterpolation interpolation = [[NSGraphicsContext currentContext] imageInterpolation];
	[[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];	
	
	//	[image drawInRect:NSMakeRect(cellFrame.origin.x+10,yOffset+10,cellFrame.size.height-20, cellFrame.size.height-20)
	//			fromRect:NSMakeRect(0,0,[image size].width, [image size].height)
	//		   operation:NSCompositeSourceOver
	//			fraction:1.0];
	
	NSPoint point = NSMakePoint(cellFrame.origin.x+10, cellFrame.origin.y+10);
	[image setScalesWhenResized:YES];
    [image setFlipped:YES];
	//[image compositeToPoint:point operation:NSCompositeSourceOver]; // Depricated in 10.8
    [image drawAtPoint:point fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	
	
	[[NSGraphicsContext currentContext] setImageInterpolation: interpolation];
	
	
	// Setup the URL display
	myDefaultStyle = [NSMutableParagraphStyle alloc];
	[myDefaultStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	
	textPoint.x = cellFrame.origin.x + 55;
	textPoint.y = cellFrame.origin.y + 27;
	
	NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithObjectsAndKeys: [NSColor grayColor], NSForegroundColorAttributeName, [NSFont systemFontOfSize:10], NSFontAttributeName, myDefaultStyle, NSParagraphStyleAttributeName,nil];
	
	if ([self isHighlighted]) 
	{
		[textAttributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	} else {
		[textAttributes setValue:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
	}	
	[tags drawInRect:NSMakeRect(cellFrame.origin.x+55,cellFrame.origin.y+24,cellFrame.size.width-60, cellFrame.size.height) withAttributes:textAttributes];
	
	// Setup the main label 
	textPoint.x = cellFrame.origin.x + 55;
	textPoint.y = cellFrame.origin.y + 10;
	[textAttributes setValue:[NSFont systemFontOfSize:13] forKey:NSFontAttributeName];
	
	if ([self isHighlighted]) 
	{
		[textAttributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	} else {
		[textAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
	}
	[title drawInRect:NSMakeRect(cellFrame.origin.x+55,cellFrame.origin.y+7,cellFrame.size.width-60, cellFrame.size.height) withAttributes:textAttributes];
	//NSLog(@"frameRect = %@", NSStringFromRect(NSMakeRect(cellFrame.origin.x+55,cellFrame.origin.y+10,cellFrame.size.width, cellFrame.size.height)));
}	

- (void)setObjectValue:(id <NSCopying>)object {
    id oldObjectValue = [self objectValue];
    if (object != oldObjectValue) {
		//  [object retain];
		//       [oldObjectValue release];
        [super setObjectValue:[NSValue valueWithNonretainedObject:object]];
    }
}

- (id)objectValue {
    return [[super objectValue] nonretainedObjectValue];
}

//- (NSLineBreakMode)lineBreakMode
//{
//	return NSLineBreakByWordWrapping;
//}
//
//- (BOOL)truncatesLastVisibleLine
//{
//	return YES;
//}



@end

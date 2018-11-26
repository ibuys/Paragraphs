//
//  JBCollectionViewItem.m
//  Scout
//
//  Created by Jonathan Buys on 11/21/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBCollectionViewItem.h"
#import "JBCollectedThemeView.h"

@implementation JBCollectionViewItem

@synthesize backgroundBox = _backgroundBox;

- (void)setSelected:(BOOL)flag
{
    [super setSelected: flag];
   // NSLog(@"anything? Bueler?");
//
//
//    NSImage *gradImage = [NSImage imageWithSize:NSMakeSize(200, 200) flipped:NO drawingHandler:^BOOL(NSRect dstRect)
//    {
//
//        NSGradient *grad = [[NSGradient alloc] initWithStartingColor:[NSColor darkGrayColor] endingColor:[NSColor lightGrayColor]];
//        [grad drawInRect:dstRect angle:315];
//
//        return YES;
//    }];
//    
//
//    NSColor *gradColor = [NSColor colorWithPatternImage:gradImage];
//    
//    NSBox *view = _backgroundBox;
//    NSColor *color;
//    NSColor *lineColor;
//    
//    if (flag)
//    {
//        color = gradColor;
//        lineColor = [NSColor blackColor];
//    } else {
//        color = gradColor;
//        lineColor = [NSColor controlBackgroundColor];
//    }
//    
//    [view setBorderColor:lineColor];
//    [view setFillColor:color];
}

- (void) awakeFromNib
{
    NSBox *view = _backgroundBox;
    
//    NSImage *gradImage = [NSImage imageWithSize:NSMakeSize(150, 150) flipped:NO drawingHandler:^BOOL(NSRect dstRect)
//                          {
//                              
//                              NSGradient *grad = [[NSGradient alloc] initWithStartingColor:[NSColor darkGrayColor] endingColor:[NSColor lightGrayColor]];
//                              [grad drawInRect:dstRect angle:315];
//                              
//                              return YES;
//                          }];
//    
//    NSImage *archiveImage = [[NSImage alloc] initWithData:[gradImage TIFFRepresentation]];
//    NSColor *gradColor = [NSColor colorWithPatternImage:archiveImage];
//
//    [view setFillColor:gradColor];
    
    [view setTitlePosition:NSNoTitle];
    [view setBoxType:NSBoxCustom];
    [view setCornerRadius:8.0];
    [view setBorderType:NSLineBorder];
}

-(id) copyWithZone:(NSZone *)zone
{
	id obj = [super copyWithZone:zone];
    
	// load the nib	
	return obj;
}

- (void) setRepresentedObject:(id)representedObject
{
	[super setRepresentedObject:representedObject];
}



@end

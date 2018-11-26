//
//  JBWhiteView.m
//  Scout
//
//  Created by Jonathan Buys on 11/20/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBWhiteView.h"

@implementation JBWhiteView

- (void)drawRect:(NSRect)rect
{
    // draw a basic gradient for the view background
    
    NSColor* gradientBottom = [NSColor colorWithCalibratedWhite:0.25 alpha:1.0];
    NSColor* gradientTop    = [NSColor colorWithCalibratedWhite:0.45 alpha:1.0];
    
	NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:gradientBottom
                                                         endingColor:gradientTop];
    [gradient drawInRect:self.bounds angle:90.0];
}

@end

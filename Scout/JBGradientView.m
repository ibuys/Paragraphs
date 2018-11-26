//
//  JBGradientView.m
//  
//
//  Created by Jonathan Buys on 1/29/10.
//  Copyright 2010 B6 Systems Inc.. All rights reserved.
//

#import "JBGradientView.h"


@implementation JBGradientView

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

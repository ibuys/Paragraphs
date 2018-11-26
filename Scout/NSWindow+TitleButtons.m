//
//  NSWindow+TitleButtons.m
//  Paragraphs
//
//  Created by Jonathan Buys on 4/19/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "NSWindow+TitleButtons.h"

@implementation NSWindow (TitleButtons)

-(void)addViewToTitleBar:(NSView*)viewToAdd atXPosition:(CGFloat)x
{
    viewToAdd.frame = NSMakeRect(x, [[self contentView] frame].size.height, viewToAdd.frame.size.width, [self heightOfTitleBar]);
    
    NSUInteger mask = 0;
    if( x > self.frame.size.width / 2.0 )
    {
        mask |= NSViewMinXMargin;
    }
    else
    {
        mask |= NSViewMaxXMargin;
    }
    [viewToAdd setAutoresizingMask:mask | NSViewMinYMargin];
    
    [[[self contentView] superview] addSubview:viewToAdd];
}

-(CGFloat)heightOfTitleBar
{
    NSRect outerFrame = [[[self contentView] superview] frame];
    NSRect innerFrame = [[self contentView] frame];
    
    return outerFrame.size.height - innerFrame.size.height;
}

@end

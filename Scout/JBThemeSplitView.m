//
//  JBThemeSplitView.m
//  Scout
//
//  Created by Jon Buys on 12/30/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBThemeSplitView.h"

@implementation JBThemeSplitView


# pragma mark NSSplitView Delegate Methods

/*
 * Controls the minimum size of the left subview (or top subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	//NSLog(@"%@:%s proposedMinimum: %f",[self class], _cmd, proposedMinimumPosition);
    
    // Get the height of the window
    
    NSRect fullSizeFrame = [mySplitView frame];
    NSUInteger fullSize = fullSizeFrame.size.height;
    
    // return the height of the window - 154
	return fullSize - 154;
}

/*
 * Controls the minimum size of the right subview (or lower subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	return proposedMaximumPosition - 154;
}

-(BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview
{
    return subview != bottomView;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview;
{
    //NSView* rightView = [[splitView subviews] objectAtIndex:0];
    return NO;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex;
{
    //NSView* rightView = [[splitView subviews] objectAtIndex:1];
    return NO;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex;
{
    return YES;
}

- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex
{
    return NSZeroRect;
}




@end

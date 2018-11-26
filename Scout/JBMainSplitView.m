//
//  JBMainSplitView.m
//  Scout
//
//  Created by Jonathan Buys on 11/30/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBMainSplitView.h"

@implementation JBMainSplitView

#pragma mark NSSplitView Delegate Methods

/*
 * Controls the minimum size of the left subview (or top subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	//NSLog(@"%@:%s proposedMinimum: %f",[self class], _cmd, proposedMinimumPosition);
	//return proposedMinimumPosition + 223;
    return 25;
}

/*
 * Controls the minimum size of the right subview (or lower subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	//NSLog(@"%@:%s proposedMaximum: %f",[self class], _cmd, proposedMaximumPosition);
	//return proposedMaximumPosition - 520;
    return 25;
}

//- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex
//{
//    return NSZeroRect;
//}

//- (void)splitViewWillResizeSubviews:(NSNotification *)aNotification
//{
//   // NSLog(@"will resize");
//    [mySplitView setPosition:223 ofDividerAtIndex:1];
//}

-(BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview
{
    return subview != topView;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview;
{
    //NSView* rightView = [[splitView subviews] objectAtIndex:0];
    return ([subview isEqual:topView]);
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex;
{
    //NSView* rightView = [[splitView subviews] objectAtIndex:1];
    return ([subview isEqual:bottomView]);
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex;
{
    return YES;
}


- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex
{
    return NSZeroRect;
}


#pragma mark Actions

-(IBAction)toggleTopView:(id)sender
{
    BOOL tabViewCollapsed = [mySplitView isSubviewCollapsed:[[mySplitView subviews] objectAtIndex: 0]];
    if (tabViewCollapsed) {
        [self uncollapseTabView];
        [toggleShowPathView setTitle:@"Hide Quick Bar"];
    } else {
        [self collapseTabView];
        [toggleShowPathView setTitle:@"Show Quick Bar"];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:tabViewCollapsed forKey:@"tabViewCollapsed"];
    //NSLog(@"Should tabViewCollapsed? = %d", tabViewCollapsed);

}

-(void)collapseTabView
{    
    NSView *top  = [[mySplitView subviews] objectAtIndex:0];
    NSView *bottom = [[mySplitView subviews] objectAtIndex:1];
    
    NSRect topFrame = [top frame];
    saveTopFrame = topFrame;
    saveBottomFrame = [bottom frame];
    NSRect overallFrame = [mySplitView frame]; //???
    [top setHidden:YES];
    [bottom setFrameSize:NSMakeSize(overallFrame.size.width,topFrame.size.height)];
    [mySplitView display];
}

-(void)uncollapseTabView
{
        
    NSView *top  = [[mySplitView subviews] objectAtIndex:0];
    NSView *bottom = [[mySplitView subviews] objectAtIndex:1];
    [top setHidden:NO];
    
    CGFloat dividerThickness = [mySplitView dividerThickness];
    
    // get the different frames
    NSRect topFrame = [top frame];
    NSRect bottomFrame = [bottom frame];
    
    // Adjust right frame size
    //  rightFrame.size.width = (save.size.width-rightFrame.size.width-dividerThickness);
    bottomFrame.size.width = saveBottomFrame.size.width;
    topFrame.origin.x = bottomFrame.size.width + dividerThickness;
    [bottom setFrameSize:bottomFrame.size];
    [top setFrame:saveTopFrame];
    [mySplitView display];
}


@end

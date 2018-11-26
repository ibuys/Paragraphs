//
//  JBSplitView.m
//  Scout
//
//  Created by Jonathan Buys on 9/18/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBSplitView.h"


@implementation JBSplitView


- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


-(void)awakeFromNib
{

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"tabViewCollapsed"])
    {
        [leftView setHidden:YES];

    }
}

# pragma mark NSSplitView Delegate Methods

/*
 * Controls the minimum size of the left subview (or top subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	//NSLog(@"%@:%s proposedMinimum: %f",[self class], _cmd, proposedMinimumPosition);
	//return proposedMinimumPosition + 223;
    return 223;
}

/*
 * Controls the minimum size of the right subview (or lower subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	//NSLog(@"%@:%s proposedMaximum: %f",[self class], _cmd, proposedMaximumPosition);
	//return proposedMaximumPosition - 520;
    return 223;
}


-(BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview
{
    return subview != leftView;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview;
{
    //NSView* rightView = [[splitView subviews] objectAtIndex:0];
    return ([subview isEqual:leftView]);
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex;
{
    //NSView* rightView = [[splitView subviews] objectAtIndex:1];
    return ([subview isEqual:rightView]);
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex;
{
    return YES;
}










# pragma mark Action

-(IBAction)toggleLeftView:(id)sender
{
    BOOL tabViewCollapsed = [mySplitView isSubviewCollapsed:[[mySplitView subviews] objectAtIndex: 0]];

    if (tabViewCollapsed)
    {
        [self uncollapseTabView];
        [toggleSplitViewMenuItem setTitle:@"Hide Library"];
        [[mySplitView window] makeFirstResponder:mainTableView];
    } else {
        [self collapseTabView];
        [toggleSplitViewMenuItem setTitle:@"Show Library"];
        [[mySplitView window] makeFirstResponder:textEditor];
    }
}


-(void)collapseTabView
{
    [self animateDividerToPosition:0];
    [self performSelector:@selector(setLeftHidden) withObject:nil afterDelay:0.15f];
    [mySplitView display];
}

-(void)uncollapseTabView
{
    [self animateDividerToPosition:223];
    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
    [left setHidden:NO];
    
    [mySplitView display];
}

- (void)setLeftHidden
{
    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
    [left setHidden:YES];
    
}

- (void)animateDividerToPosition:(CGFloat)dividerPosition
{
    
    // Get the views named
    NSView *view0 = [[mySplitView subviews] objectAtIndex:0];
    NSView *view1 = [[mySplitView subviews] objectAtIndex:1];
    
    // Get the size of each view
    NSRect view0Rect = [view0 frame];
    NSRect view1Rect = [view1 frame];
    
    // Get the size of the entire window
    NSRect overalRect = [mySplitView frame];
    
    // Get the size of the divider
    CGFloat dividerSize = [mySplitView dividerThickness];
    
    // Find out if we shoudl auto resize the subviews (should be yes?)
    BOOL view0AutoResizes = [view0 autoresizesSubviews];
    BOOL view1AutoResizes = [view1 autoresizesSubviews];
    
    // set subviews target size
    
    view0Rect.origin.x = MIN(0, dividerPosition);
    view0Rect.size.width = MAX(0, dividerPosition);
    
    
    view1Rect.origin.x = MAX(0, dividerPosition + dividerSize);
    view1Rect.size.width = MAX(0, overalRect.size.width - view0Rect.size.width - dividerSize);

    
    // make sure views are visible after previous collapse
    [view0 setHidden:NO];
    [view1 setHidden:NO];
    
    // disable delegate interference
    id delegate = [mySplitView delegate];
    [mySplitView setDelegate:nil];
    
	[NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.15f];
        [[NSAnimationContext currentContext] setCompletionHandler:^(void)
         {
             [view0 setAutoresizesSubviews:view0AutoResizes];
             [view1 setAutoresizesSubviews:view1AutoResizes];
             [mySplitView setDelegate:delegate];
         }];

    [[view1 animator] setFrame: view1Rect];
    [[view0 animator] setFrame: view0Rect];
    
	[NSAnimationContext endGrouping];

}


@end

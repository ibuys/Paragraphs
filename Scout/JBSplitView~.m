//
//  JBSplitView.m
//  Scout
//
//  Created by Jonathan Buys on 9/18/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBSplitView.h"


@implementation JBSplitView

-(void)awakeFromNib
{
    
    
    if ([[NSUserDefaults standardUserDefaults]  valueForKey:@"firstLaunch16"])
	{
		//NSLog(@"Not first launch of Go2 v1.6");
        BOOL tabViewCollapsed = [[NSUserDefaults standardUserDefaults] boolForKey:@"tabViewCollapsed"];
        //  NSLog(@"tabViewCollapsed = %d", tabViewCollapsed);
        
        // OK, this seems backwards to me, but it works.
        if (tabViewCollapsed == NO)
        {
            //    NSLog(@"This should be collappsed.");
            [self collapseTabView];
        }
        
		
	} else {
		
	//	NSLog(@"First Launch of Scout from JBSplitView");
        
	}
}


/*
 * Controls the minimum size of the left subview (or top subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	//NSLog(@"%@:%s proposedMinimum: %f",[self class], _cmd, proposedMinimumPosition);
	return proposedMinimumPosition + 150;
}

/*
 * Controls the minimum size of the right subview (or lower subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
	//NSLog(@"%@:%s proposedMaximum: %f",[self class], _cmd, proposedMaximumPosition);
	return proposedMaximumPosition - 200;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview;
{
    NSView* rightView = [[splitView subviews] objectAtIndex:0];
    return ([subview isEqual:rightView]);
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex;
{
    return YES;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex;
{
    NSView* rightView = [[splitView subviews] objectAtIndex:1];
    return ([subview isEqual:rightView]);
}

-(IBAction)toggleRightView:(id)sender;
{
    BOOL rightViewCollapsed = [mySplitView isSubviewCollapsed:[[mySplitView subviews] objectAtIndex: 1]];
    if (rightViewCollapsed) {
        [self uncollapseRightView];
    } else {
        [self collapseRightView];
    }
}
-(void)collapseRightView
{
    NSView *right = [[mySplitView subviews] objectAtIndex:1];
    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
    NSRect leftFrame = [left frame];
    NSRect overallFrame = [mySplitView frame]; //???
    [right setHidden:YES];
    [left setFrameSize:NSMakeSize(overallFrame.size.width,leftFrame.size.height)];
    [mySplitView display];
}

-(void)uncollapseRightView
{
    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
    NSView *right = [[mySplitView subviews] objectAtIndex:1];
    [right setHidden:NO];
    CGFloat dividerThickness = [mySplitView dividerThickness];
    // get the different frames
    NSRect leftFrame = [left frame];
    NSRect rightFrame = [right frame];
    // Adjust left frame size
    leftFrame.size.width = (leftFrame.size.width-rightFrame.size.width-dividerThickness);
    rightFrame.origin.x = leftFrame.size.width + dividerThickness;
    [left setFrameSize:leftFrame.size];
    [right setFrame:rightFrame];
    [mySplitView display];
}

-(IBAction)toggleLeftView:(id)sender
{
    [[[mySplitView subviews] objectAtIndex:0] setHidden:NO];
    BOOL tabViewCollapsed = [mySplitView isSubviewCollapsed:[[mySplitView subviews] objectAtIndex: 0]];
    if (tabViewCollapsed) {
        [self uncollapseTabView];
        [toggleSplitViewMenuItem setTitle:@"Hide Library"];
    } else {
        [self collapseTabView];
        [toggleSplitViewMenuItem setTitle:@"Show Library"];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:tabViewCollapsed forKey:@"tabViewCollapsed"];
    NSLog(@"Should tabViewCollapsed? = %d", tabViewCollapsed);
    
    
}


-(void)collapseTabView
{
    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
    NSView *right = [[mySplitView subviews] objectAtIndex:1];
    
    NSRect leftFrame = [left frame];
    saveLeftFrame = leftFrame;
    saveRightFrame = [right frame];
    NSRect overallFrame = [mySplitView frame]; //???
    [left setHidden:YES];
    [right setFrameSize:NSMakeSize(overallFrame.size.width,leftFrame.size.height)];
    [mySplitView display];
}

-(void)uncollapseTabView
{
    NSView *left  = [[mySplitView subviews] objectAtIndex:0];
    NSView *right = [[mySplitView subviews] objectAtIndex:1];
    [left setHidden:NO];
    
    CGFloat dividerThickness = [mySplitView dividerThickness];
    
    // get the different frames
    NSRect leftFrame = [left frame];
    NSRect rightFrame = [right frame];
    
    // Adjust right frame size
    //  rightFrame.size.width = (save.size.width-rightFrame.size.width-dividerThickness);
    rightFrame.size.width = saveRightFrame.size.width;
    leftFrame.origin.x = rightFrame.size.width + dividerThickness;
    [right setFrameSize:rightFrame.size];
    [left setFrame:saveLeftFrame];
    [mySplitView display];
}




@end

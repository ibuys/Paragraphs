//
//  JBSplitView.h
//  Scout
//
//  Created by Jonathan Buys on 9/18/10.
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface JBSplitView : NSObject
{
    IBOutlet NSSplitView *mySplitView;
    IBOutlet NSView *leftView;
    IBOutlet NSView *rightView;
    NSRect saveLeftFrame;
    NSRect saveRightFrame;
    
    IBOutlet NSMenuItem *toggleSplitViewMenuItem;
    NSInteger lastLeftViewWidth;
    
//    IBOutlet NSSearchField *searchField;
    IBOutlet NSTextView *textEditor;
    IBOutlet NSTableView *mainTableView;
}
-(void)collapseTabView;
-(void)uncollapseTabView;

-(IBAction)toggleLeftView:(id)sender;;

@end

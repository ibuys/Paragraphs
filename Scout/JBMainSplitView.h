//
//  JBMainSplitView.h
//  Scout
//
//  Created by Jonathan Buys on 11/30/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBMainSplitView : NSObject
{
    IBOutlet NSSplitView *mySplitView;
    IBOutlet NSView *topView;
    IBOutlet NSView *bottomView;
    NSRect saveTopFrame;
    NSRect saveBottomFrame;
    
    IBOutlet NSMenuItem *toggleShowPathView;
    NSInteger lastTopViewWidth;
}

-(IBAction)toggleTopView:(id)sender;;

@end

//
//  JBThemeSplitView.h
//  Scout
//
//  Created by Jon Buys on 12/30/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBThemeSplitView : NSObject
{
    IBOutlet NSSplitView *mySplitView;
    IBOutlet NSView *topView;
    IBOutlet NSView *bottomView;
    
    NSInteger lastLeftViewWidth;
}

@end

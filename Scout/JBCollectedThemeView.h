//
//  JBCollectedThemeView.h
//  Scout
//
//  Created by Jon Buys on 12/29/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBCollectedThemeView : NSView
{
    IBOutlet NSBox *highlightBox;
    
    BOOL m_isSelected;
}

-(void)setSelected:(BOOL)flag;
-(BOOL)selected;

@end

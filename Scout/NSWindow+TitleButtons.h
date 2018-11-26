//
//  NSWindow+TitleButtons.h
//  Paragraphs
//
//  Created by Jonathan Buys on 4/19/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (TitleButtons)

-(void)addViewToTitleBar:(NSView*)viewToAdd atXPosition:(CGFloat)x;
-(CGFloat)heightOfTitleBar;

@end

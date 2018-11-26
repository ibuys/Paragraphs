//
//  JBParagraphDocLibrary.m
//  Paragraphs
//
//  Created by Jonathan Buys on 4/22/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBParagraphDocLibrary.h"

@implementation JBParagraphDocLibrary

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
//    NSString *pathToLinen = [[NSBundle mainBundle] pathForResource:@"linen" ofType:@"png"];
//    NSImage *myImage = [[NSImage alloc] initWithContentsOfFile:pathToLinen];
//
//    [[NSColor colorWithPatternImage: myImage] setFill];
//    NSRectFill(dirtyRect);

}

@end

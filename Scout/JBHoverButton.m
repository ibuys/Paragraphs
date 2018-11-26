//
//  JBHoverButton.m
//  Scout
//
//  Created by Jonathan Buys on 12/18/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBHoverButton.h"

@interface NSButtonCell()
- (void)_updateMouseTracking;
@end

@implementation JBHoverButton
@synthesize hoverImage;

- (void)mouseEntered:(NSEvent *)event {
    if (hoverImage != nil && [hoverImage isValid]) {
        _oldImage = [(NSButton *)[self controlView] image];
        [(NSButton *)[self controlView] setImage:hoverImage];
    }
}

- (void)mouseExited:(NSEvent *)event {
    if (_oldImage != nil && [_oldImage isValid]) {
        [(NSButton *)[self controlView] setImage:_oldImage];
        _oldImage = nil;
    }
}

- (void)_updateMouseTracking {
    [super _updateMouseTracking];
    if ([self controlView] != nil && [[self controlView] respondsToSelector:@selector(_setMouseTrackingForCell:)]) {
        [[self controlView] performSelector:@selector(_setMouseTrackingForCell:) withObject:self];
    }
}

- (void)setHoverImage:(NSImage *)newImage
{
    hoverImage = newImage;
    [[self controlView] setNeedsDisplay:YES];
}


@end

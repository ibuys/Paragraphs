//
//  NSWindow+FullScreen.m
//  Paragraphs
//
//  Created by Jonathan Buys on 4/17/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "NSWindow+FullScreen.h"

@implementation NSWindow (FullScreen)

- (BOOL)mn_isFullScreen
{
    return (([self styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask);
}

@end

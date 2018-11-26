//
//  JBHoverButton.h
//  Scout
//
//  Created by Jonathan Buys on 12/18/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBHoverButton : NSButtonCell
{
    NSImage *_oldImage;
    NSImage *hoverImage;
}
@property (nonatomic) NSImage *hoverImage;

@end

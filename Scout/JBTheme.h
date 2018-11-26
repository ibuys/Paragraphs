//
//  JBTheme.h
//  Scout
//
//  Created by Jon Buys on 12/29/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBTheme : NSObject
{
    NSImage *themeThumbnailImage;
    NSString *themeName;
    NSString *themeIndex;
}

@property (readwrite, retain) NSString *themeName, *themeIndex;
@property (readwrite, retain) NSImage *themeThumbnailImage;


@end

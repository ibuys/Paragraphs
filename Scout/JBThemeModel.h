//
//  JBThemeModel.h
//  Scout
//
//  Created by Jonathan Buys on 11/21/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBThemeModel : NSObject
{
    NSString *name;
    NSString *path;
}

@property(retain, readwrite) NSString * name;
@property(retain, readwrite) NSString * path;

@end

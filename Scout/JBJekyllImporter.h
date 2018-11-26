//
//  JBJekyllImporter.h
//  Scout
//
//  Created by Jon Buys on 12/7/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JBJekyllImporter : NSObject
{
}

-(NSArray *)importJekyllPosts:(NSURL *)jekyllDirectory;


@end

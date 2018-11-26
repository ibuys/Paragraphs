//
//  JBAppleScriptNewPost.m
//  Scout
//
//  Created by Jonathan Buys on 3/21/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBAppleScriptNewPost.h"
#import "scriptLog.h"

@implementation JBAppleScriptNewPost


- (id)performDefaultImplementation
{
//    NSDictionary * theArguments = [self evaluatedArguments];
	id theResult;
    
    [[[NSApplication sharedApplication] delegate] performSelector:@selector(newPost)];
    
    // Whatever...
    return theResult;

}

@end

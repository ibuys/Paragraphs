//
//  JBThemeTitleTransformer.m
//  Paragraphs
//
//  Created by Jonathan Buys on 4/13/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBThemeTitleTransformer.h"

@implementation JBThemeTitleTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return YES; }

- (id)transformedValue:(id)value
{
    
	if(value)
    {
		return [[value stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	}else{
		return nil;
	}
}

@end

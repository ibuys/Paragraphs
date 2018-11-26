//
//  JBDateValueTransformer.m
//  Scout
//
//  Created by Jonathan Buys on 3/20/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBDateValueTransformer.h"

@implementation JBDateValueTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return YES; }

- (id)transformedValue:(id)value
{
    
	if(value){
		return [value descriptionWithCalendarFormat:@"%m/%d/%Y" timeZone:nil
                                             locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	}else{
		return nil;
	}
}

@end

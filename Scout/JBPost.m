//
//  JBPost.m
//  Scout Writer
//
//  Created by Jonathan Buys on 11/12/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBPost.h"

@implementation JBPost

@synthesize title;
@synthesize text;
@synthesize path;
@synthesize date;

- (id)initWithTitle:(NSString *)theTitle andText:(NSString *)theText andPath:(NSString *)thePath andDate:(NSDate *)theDate
{
    
    if ( self = [super init] )
    {
        title = theTitle;
        text = theText;
        path = thePath;
        date = theDate;

    }
    return self;
}

@end

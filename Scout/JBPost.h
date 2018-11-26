//
//  JBPost.h
//  Scout Writer
//
//  Created by Jonathan Buys on 11/12/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBPost : NSObject
{
@private
    NSString *title;
    NSString *text;
    NSString *path;
    NSDate *date;
}


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSDate *date;

- (id)initWithTitle:(NSString *)theTitle andText:(NSString *)theText andPath:(NSString *)thePath andDate:(NSDate *)theDate;

@end

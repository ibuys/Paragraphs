//
//  JBThemeController.m
//  Scout
//
//  Created by Jonathan Buys on 11/21/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBThemeController.h"

@implementation JBThemeController

@synthesize collectionView = _collectionView;
@synthesize arrayController = _arrayController;

- (void)awakeFromNib
{
    
    _collection = [[NSMutableArray alloc] initWithObjects:
                   [NSDictionary dictionaryWithObject:@"Hello" forKey:@"label"],
                   [NSDictionary dictionaryWithObject:@"World" forKey:@"label"],
                   nil];
    
}

- (IBAction) addItem:(id)sender
{
	[self.arrayController addObject:
	 [NSDictionary dictionaryWithObject:@"Hello" forKey:@"label"]];
}

- (IBAction) removeItem:(id)sender
{
	NSUInteger index = [[self.arrayController selectionIndexes] firstIndex];
	[self.arrayController removeObjectAtArrangedObjectIndex:index];
}


@end

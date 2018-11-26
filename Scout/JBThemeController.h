//
//  JBThemeController.h
//  Scout
//
//  Created by Jonathan Buys on 11/21/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBThemeModel.h"

@interface JBThemeController : NSObject
{
	NSCollectionView *_collectionView;
	NSMutableArray *_collection;
	NSArrayController *_arrayController;
}

@property (nonatomic, retain) IBOutlet NSCollectionView *collectionView;
@property (nonatomic, retain) IBOutlet NSArrayController *arrayController;

- (IBAction) addItem:(id)sender;
- (IBAction) removeItem:(id)sender;

@end

//
//  JBCollectionViewItem.h
//  Scout
//
//  Created by Jonathan Buys on 11/21/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JBCollectedThemeView;

@interface JBCollectionViewItem : NSCollectionViewItem
{
    NSTextField *_label;
    NSBox *_backgroundBox;
}

@property (nonatomic, retain) IBOutlet NSBox *backgroundBox;

@end

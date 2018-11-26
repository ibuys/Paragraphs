//
//  JBThemeChooserController.h
//  Scout
//
//  Created by Jon Buys on 12/29/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface JBThemeChooserController : NSObject
{
    IBOutlet NSArrayController *themesArrayController;
    IBOutlet NSCollectionView *mainCollectionView;
    IBOutlet NSBox *highlightBox;
}

@end

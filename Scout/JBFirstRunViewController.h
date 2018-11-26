//
//  JBFirstRunViewController.h
//  Scout
//
//  Created by Jon Buys on 11/19/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBValidateTextField.h"
#import "JBWindowController.h"

@interface JBFirstRunViewController : NSObject
{
    IBOutlet NSView *firstRunView;
    
    IBOutlet NSTextField *siteTitleTextField;
    IBOutlet NSBox *niceBox;
    IBOutlet JBValidateTextField *validator;
    IBOutlet NSTextField *urlTextField;
    IBOutlet JBWindowController *windowController;
    
    
    NSURL* rootSaveDirectory;
}

-(IBAction)setDropboxSync:(id)sender;
-(IBAction)setSite44:(id)sender;

@end

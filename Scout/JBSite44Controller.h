//
//  JBSite44Controller.h
//  Scout
//
//  Created by Jonathan Buys on 2/15/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBWindowController;

@interface JBSite44Controller : NSObject
{
    IBOutlet NSTextField *site44DomainTextField;
    IBOutlet NSTextField *instructionLabel;
    IBOutlet JBWindowController *windowController;
    IBOutlet NSButton *linkWithDropboxButton;
}

-(IBAction)checkSite44API:(id)sender;
-(IBAction)linkSite44andDropbox:(id)sender;

@end

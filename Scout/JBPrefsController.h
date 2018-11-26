//
//  JBPrefsController.h
//  Scout
//
//  Created by Jonathan Buys on 11/20/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MGPreferencePanel;

@interface JBPrefsController : NSObject
{

    IBOutlet NSTextField *siteNameTextField;
    IBOutlet NSTextField *siteURLTextField;
    IBOutlet NSPopUpButton *stylePopUpButton;
    IBOutlet NSTextField *licenseOwner;
    IBOutlet NSTextField *licensePurchase;
    IBOutlet NSWindow *prefsWindow;
    IBOutlet MGPreferencePanel *prefPanel;
    IBOutlet NSTokenField *dateTokenField;
}

-(void)doneEditPrefs;
-(void)launchLicense;

//-(IBAction)setDropboxSync:(id)sender;
//-(IBAction)setPublishPath:(id)sender;

@end

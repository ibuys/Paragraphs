//
//  JBValidateTextField.h
//  Go
//
//  Created by Jon Buys on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JBValidateTextField : NSObject 
{
	IBOutlet NSTextField *urlTextField;
	IBOutlet NSTextField *siteTitleTextField;
	IBOutlet NSButton *markdownPathButton;
    
    IBOutlet NSButton *urlOKButton;

	IBOutlet NSSearchField *searchField;
	
	NSURL *myUrl;
	BOOL setButtonOK;
}

- (BOOL) validateUrl: (NSString *) candidate;
- (void)checkAgain;


@end

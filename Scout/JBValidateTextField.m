//
//  JBValidateTextField.m
//  Go
//
//  Created by Jon Buys on 7/26/10.
//  Updated on November 26, 2012
//  Copyright 2010 Farmdog Software. All rights reserved.
//

#import "JBValidateTextField.h"

@implementation JBValidateTextField

- (void)awakeFromNib
{
	setButtonOK = NO;
	[urlOKButton setEnabled:NO];
//    [urlOKButton setHidden:YES];

}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
	
	if (![[siteTitleTextField stringValue] isEqualToString:@""])
	{
       // NSLog(@"siteTitleTextField has a string");
        
        if (![[urlTextField stringValue] isEqualToString:@""])
        {
               // NSLog(@"urlTextField has a string %@", [urlTextField stringValue]);

            if ([self validateUrl:[urlTextField stringValue]])
            {
                [urlOKButton setEnabled:YES];
//                [urlOKButton setHidden:NO];

                [urlOKButton setTitle:@"Let's Get Started"];
                            
            } else {
                [urlOKButton setEnabled:NO];
//                [urlOKButton setHidden:YES];

            }
        } else {

            [urlOKButton setEnabled:NO];
//            [urlOKButton setHidden:YES];

        }
	}
}



- (BOOL) validateUrl: (NSString *) candidate
{
 	NSString *urlRegEx = @"[a-z|0-9]*.*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}


- (void)checkAgain
{
    if (![[siteTitleTextField stringValue] isEqualToString:@""])
	{
        // NSLog(@"siteTitleTextField has a string");
        
        if (![[urlTextField stringValue] isEqualToString:@""])
        {
            // NSLog(@"urlTextField has a string %@", [urlTextField stringValue]);
            
            if (![[markdownPathButton title] isEqualToString:@"{    Choose Folder    }"])
            {
                NSLog(@"markdownPathButton title is %@", [markdownPathButton title]);
                
                if ([self validateUrl:[urlTextField stringValue]])
                {
                    [urlOKButton setEnabled:YES];
                    [urlOKButton setHidden:NO];

                    [urlOKButton setTitle:@"Let's Get Started"];
                    
                } else {
                    [urlOKButton setEnabled:NO];
                    [urlOKButton setHidden:YES];

                }
            } else {                
                [urlOKButton setEnabled:NO];
                [urlOKButton setHidden:YES];

            }
        } else {
            
            [urlOKButton setEnabled:NO];
            [urlOKButton setHidden:YES];

        }
	}
}

@end



//
//  JBTextView.h
//  Scout
//
//  Created by Jonathan Buys on 10/28/12.
//
//

#import <Cocoa/Cocoa.h>
#import "JBAppSupportDir.h"

@class JBWindowController;

@interface JBTextView : NSTextView
{
    IBOutlet JBWindowController *windowController;
}
- (void)dropFromMediaManager:(NSString *)fileToUse;
- (void)performFindPanelAction:(id)sender;

-(IBAction)surroundItalics:(id)sender;
-(IBAction)surroundBold:(id)sender;
-(IBAction)insertLink:(id)sender;

@end

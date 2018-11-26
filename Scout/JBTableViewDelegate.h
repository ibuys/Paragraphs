//
//  JBTableViewDelegate.h
//  Scout
//
//  Created by Jonathan Buys on 10/30/12.
//
//

#import <Foundation/Foundation.h>
#import "JBAppController.h"
#import "JBAppDelegate.h"

@interface JBTableViewDelegate : NSObject <NSTableViewDelegate>
{
    IBOutlet NSTextView *mainTextView;
    IBOutlet NSTableView *mainTableView;
//    IBOutlet NSSearchField *mySearchField;
    IBOutlet JBAppController *myAppController;
    IBOutlet JBAppDelegate *myAppDelegate;
    IBOutlet NSWindow *mainWindow;

}

@end

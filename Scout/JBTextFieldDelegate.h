//
//  JBTextFieldDelegate.h
//  Scout
//
//  Created by Jonathan Buys on 10/30/12.
//
//

#import <Foundation/Foundation.h>

@interface JBTextFieldDelegate : NSObject <NSTextFieldDelegate>
{
    IBOutlet NSTextField *titleTextField;
    IBOutlet NSTableView *mainTableView;
}

@end

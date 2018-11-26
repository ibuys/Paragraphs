//
//  JBTextFieldDelegate.m
//  Scout
//
//  Created by Jonathan Buys on 10/30/12.
//
//

#import "JBTextFieldDelegate.h"

@implementation JBTextFieldDelegate

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    NSLog(@"textDidEndEditing");
    [mainTableView reloadData];
    
}

//- (void)controlTextDidChange:(NSNotification *)aNotification
//{
//    NSLog(@"textDidChange = %@", aNotification);
//
//}


@end

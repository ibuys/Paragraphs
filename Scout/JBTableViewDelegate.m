//
//  JBTableViewDelegate.m
//  Scout
//
//  Created by Jonathan Buys on 10/30/12.
//
//

#import "JBTableViewDelegate.h"
#import "JBSingletonMutableArray.h"
#import "NSWindow+FullScreen.h"

@implementation JBTableViewDelegate


- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    [myAppController highlightNow];
    [myAppDelegate checkForText];
    [myAppDelegate closeMAWindow:nil];
    
//    NSString *searchString = [mySearchField stringValue];
//    
//    if(searchString==(id) [NSNull null] || [searchString length]==0 || [searchString isEqual:@""])
//    {
//        // Nothing there, carry on.
//    } else {
//        NSString *textString = [mainTextView string];
//        NSRange foundRange = [textString rangeOfString:searchString options:NSCaseInsensitiveSearch];
//        NSLayoutManager *layout = [mainTextView layoutManager];
//        NSRect rect = [layout boundingRectForGlyphRange:foundRange
//                                        inTextContainer:[mainTextView textContainer] ];
//        
//        [mainTextView setSelectedRange:foundRange];
//        [mainTextView scrollRectToVisible:rect];
//        [mainTextView showFindIndicatorForRange:foundRange];
//    }
//    
//   
//    if ([mainWindow mn_isFullScreen])
//    {
//        [mainTextView setFont:[NSFont fontWithName:@"Courier-Prime" size:20]];
//    } else {
//        [mainTextView setFont:[NSFont fontWithName:@"Courier-Prime" size:12]];
//    }
}



@end

//
//  JBArrowDownOutOfSearchField.m
//  Go2
//
//  Created by Jonathan Buys on 9/21/11.
//  Copyright 2011 Farmdog Software. All rights reserved.
//

#import "JBArrowDownOutOfSearchField.h"

@implementation JBArrowDownOutOfSearchField

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;
    if (commandSelector == @selector(moveDown:)) {
            // down arrow pressed
            // NSLog(@"OK, now move to the next key view");
        [[textView window] makeFirstResponder:myTableView];
        
		result = YES;
	}
    return result;
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
//    NSLog(@"textDidEndEditing");
    NSString *searchString = [mySearchField stringValue];

    if(searchString==(id) [NSNull null] || [searchString length]==0 || [searchString isEqual:@""])
    {
        // Nothing there, carry on.
    } else {
        

        
        NSString *textString = [mainTextView string];

        NSRange foundRange;
        
        
        NSLayoutManager *layout = [mainTextView layoutManager];
        NSRect rect = [layout boundingRectForGlyphRange:foundRange
                                        inTextContainer:[mainTextView textContainer] ];

        [mainTextView setSelectedRange:foundRange];
        [mainTextView scrollRectToVisible:rect];
        [mainTextView showFindIndicatorForRange:foundRange];
    }

//    NSRange foundRange = [textString rangeOfString:searchString];
//    NSLog(@"Range = %@", NSStringFromRange(foundRange));
//    
}


@end

//
//  JBTextView.m
//  Scout
//
//  Created by Jonathan Buys on 10/28/12.
//
//

#import "JBTextView.h"
#import "JBSingletonMutableArray.h"
#import "JBWindowController.h"

@implementation JBTextView

- (void)awakeFromNib
{
    [[super textContainer] setLineFragmentPadding:15.0f];

    [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];

    NSMenu* textViewContextualMenu = [super menu];
    
    
    NSMutableArray * itemsToRemove = [NSMutableArray array];
    for( NSMenuItem *item in [textViewContextualMenu itemArray] )
    {
        
        if( [[item title] isEqualToString:@"Substitutions"] )
        {
            [itemsToRemove addObject:item];
        }

        if( [[item title] isEqualToString:@"Transformations"] )
        {
            [itemsToRemove addObject:item];
        }

        if( [[item title] isEqualToString:@"Layout Orientation"] )
        {
            [itemsToRemove addObject:item];
        }
        
        if( [[item title] isEqualToString:@"Services"] )
        {
            [itemsToRemove addObject:item];
        }


    }
    
    for( NSMenuItem * item in itemsToRemove )
    {
        [textViewContextualMenu removeItem:item];
    }

    [textViewContextualMenu addItem:[NSMenuItem separatorItem]];
    [textViewContextualMenu addItemWithTitle:@"Bold" action:@selector(surroundBold:) keyEquivalent:@""];
    [textViewContextualMenu addItemWithTitle:@"Italic" action:@selector(surroundItalics:) keyEquivalent:@""];
    [textViewContextualMenu addItemWithTitle:@"Link" action:@selector(insertLink:) keyEquivalent:@""];
    [textViewContextualMenu addItem:[NSMenuItem separatorItem]];

}

- (void)insertText:(id)insertString
{
        
    NSRange mySelectedRange = self.selectedRange;
    NSUInteger endAt = mySelectedRange.location;
   // NSLog(@"endAt: %lu", (unsigned long)endAt);
    
    NSUInteger startAt = endAt - 1;
   // NSLog(@"startAt: %lu", (unsigned long)startAt);

    if([self string]==(id) [NSNull null] || [[self string] length]==0 || [[self string] isEqual:@""])
    {
        [super insertText:insertString];
        return;
    }
    
    NSRange foundRange;
    if (endAt > 0)
    {
        NSString *firstSub = [[self string] substringToIndex:endAt];
        NSString *secondSub = [firstSub substringFromIndex:startAt];
        foundRange = [secondSub rangeOfString:@"\n"];
    }
    
    if (foundRange.location != NSNotFound)
    {
     //   NSLog(@"foundRange.location is not equal to NSNotFound, so it's a return");
        [super insertText:insertString];

    } else {
        
        [super insertText:insertString];
        
        // if the insert string isn't one character in length, it cannot be a brace character
        if ([insertString length] != 1)
            return;
        
        unichar firstCharacter = [insertString characterAtIndex:0];
        
        switch (firstCharacter) {
            case '(':
                [super insertText:@")"];
                break;
            case '[':
                [super insertText:@"]"];
                break;
            case '{':
                [super insertText:@"}"];
                break;
                
            case '#':
                [super insertText:@"#"];
                break;
                
            case '*':
                [super insertText:@"*"];
                break;
                
            case '`':
                [super insertText:@"`"];
                break;
                
            case '<':
                [super insertText:@">"];
                break;
                
            default:
                return;
        }
        
        // adjust the selected range since we inserted an extra character
        [self setSelectedRange:NSMakeRange(self.selectedRange.location - 1, 0)];
    }
}

//- (void)keyUp:(NSEvent *)theEvent
//{
   // NSLog(@"keyUp: %@", theEvent);
    
//    if ([theEvent keyCode] == 51)
//    {
//        NSRange selection = [self selectedRange];
//        
//       // NSLog(@"Delete Key Pressed at: %lu", selection.location);
//        
//        JBSingletonMutableArray *jbsArray = [JBSingletonMutableArray singleton];
//        NSRange fullRange = [jbsArray findCurrentLocation:selection];
//        
//        if (fullRange.location != 0)
//        {
//            [self setSelectedRange:fullRange];
//        }
//        
//
//    }
//}


//- (NSPoint)textContainerOrigin
//{
//    NSPoint origin = [super textContainerOrigin];
//    NSPoint newOrigin = NSMakePoint(origin.x + 5.0f, origin.y);
//    return newOrigin;
//}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender
{
    return NSDragOperationCopy;
}

//- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
//{
//
//    NSPoint mouseLoc = [sender draggingLocation];
//    NSPoint charLoc = [[self window] convertBaseToScreen:mouseLoc];
//    NSUInteger charIndex = [self characterIndexForPoint:charLoc];
//    [self setSelectedRange:NSMakeRange(charIndex,0)];
//
//    return [super draggingUpdated:sender];
//}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{

    NSPasteboard *pboard;
    pboard = [sender draggingPasteboard];

    if ( [[pboard types] containsObject:NSFilenamesPboardType] )
    {
        
        [super performDragOperation:sender];

        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        
        NSString *filesStart = @"file://";
        NSString *fileURLString = [filesStart stringByAppendingString:[files objectAtIndex:0]];

        NSString *markdownStart = @"![](media/";
        NSString *markdownEndParen = @")";
        
        NSString *firstPart = [markdownStart stringByAppendingString:[[fileURLString lastPathComponent] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        NSString *finalString = [firstPart stringByAppendingString:markdownEndParen];
        
        [self insertText:finalString replacementRange:[self selectedRange]];

//        [self performSelectorInBackground:@selector(copyNewMedia:) withObject:[files objectAtIndex:0]];
        [self copyNewMedia:[files objectAtIndex:0]];
        return YES;
    }
    
    
    if ([[pboard types] containsObject:NSURLPboardType])
    {
        
        NSArray *urlsArray = [pboard propertyListForType:NSURLPboardType];
        
        NSString *fileURLString = [urlsArray objectAtIndex:0];

        
        
        NSString *linkopen = @"[";
        NSString *linkClose = @"](";
        NSString *urlCloseParen = @")";
        
        NSString *buildLink = [linkopen stringByAppendingString:linkClose];
        buildLink = [buildLink stringByAppendingString:fileURLString];
        NSString *finalString = [buildLink stringByAppendingString:urlCloseParen];
        
        [self insertText:finalString replacementRange:[self selectedRange]];
        
        return YES;
    }
    

    if ( [[pboard types] containsObject:NSStringPboardType] )
    {
       // NSLog(@"performDragOperation NSString Drag: %@", [sender draggingSource]);

        
         [super performDragOperation:sender];
        return YES;
    }

    
    return NO;
}


- (NSImage *)dragImageForSelectionWithEvent:(NSEvent *)event origin:(NSPointPointer)origin
{
        
    NSPasteboard *pboard;
    pboard = [NSPasteboard pasteboardWithName:NSDragPboard ];
    NSImage *imageContents;
    
    
    if ( [[pboard types] containsObject:NSStringPboardType] )
    {
        
        NSRange selectedTextRange = [self selectedRange];
        NSString *selectedText = [[self string] substringWithRange:selectedTextRange];
        NSString *pathText;
        NSScanner* scanner = [NSScanner scannerWithString:selectedText];
        [scanner scanUpToString:@"(" intoString:NULL];
        [scanner scanUpToString:@")" intoString:&pathText];
        
        pathText = [pathText stringByReplacingOccurrencesOfString:@"(" withString:@""];

        JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
     //   NSString *path = [appSupDir applicationSupportDirectory];
        
        
        NSString *path;
        
        NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
        
        if ([defaults boolForKey:@"dropboxSync"])
        {
            path = [appSupDir dropboxDir];
            
            
        } else {
            path = [appSupDir applicationSupportDirectory];
            
        }

        NSString *fullPath = [path stringByAppendingPathComponent:pathText];

        
        // NSLog(@" NSString Drag: %@", fullPath);
        imageContents = [[NSImage alloc] initWithContentsOfFile:fullPath];

        NSImage *scaledImage = [self imageResize:imageContents forWidth:128];
        
        
//        JBSingletonMutableArray *jbsArray = [JBSingletonMutableArray singleton];
//        [jbsArray emptyArray];
        return scaledImage;

    }
    return nil;
}

- (NSImage *)imageResize:(NSImage*)anImage forWidth:(int)width
{
    CGSize newSize = CGSizeMake(width, anImage.size.height * (float)width / (float)anImage.size.width);

    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid])
    {
       // NSLog(@"Invalid Image");
    } else
    {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    //    [sourceImage compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}



- (void)dropFromMediaManager:(NSString *)fileToUse
{
    
    NSString *markdownStart = @"![](media";
    NSString *markdownEndParen = @")";
    
    NSString *firstPart = [markdownStart stringByAppendingPathComponent:fileToUse];
    NSString *finalString = [firstPart stringByAppendingString:markdownEndParen];
    
    [self insertText:finalString replacementRange:[self selectedRange]];
    
   // [self setSelectedRange:RANGE]                       
    // override keyDown, watch for delete key, check for bool if justDroppedMedia is set,
    // Or... set the array in the textView, empty the array when the selected post changes,
    // And, when the text is highlighted send the range to the array
    // then, override keydown, look for delete, check if the location of the delete key is inside one of the ranges in the array
    // if it is, select the entire range, using the code above, next delete key press should delete the entire text token.
    
}

- (void)copyNewMedia:(NSString *)fileName
{
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    NSString *path;
 
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"dropboxSync"])
    {
        path = [appSupDir dropboxDir];
        
        
    } else {
        path = [appSupDir applicationSupportDirectory];
        
    }

    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSString *mediaPath = [path stringByAppendingPathComponent:@"media"];

    if (![fileMan fileExistsAtPath:mediaPath])
    {
        NSError *er;
        
        if (![fileMan createDirectoryAtPath:mediaPath withIntermediateDirectories:NO attributes:nil error:&er])
        {
            NSLog(@"Uh oh, error copying file.");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Sorry, something went wrong."];
            [alert setInformativeText:[er description]];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // OK clicked, whatever
                
            }
        }
    }
    
    NSString *fullPath = [mediaPath stringByAppendingPathComponent:[[fileName lastPathComponent] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
       
    NSError *error;
    
    NSURL *itemToCopy = [NSURL fileURLWithPath:fileName];
    NSURL *pathToCopyTo = [NSURL fileURLWithPath:fullPath];
    
    
    if (![fileMan fileExistsAtPath:fullPath])
    {
        if (![fileMan copyItemAtURL:itemToCopy toURL:pathToCopyTo error:&error])
        {
            NSLog(@"Uh oh, error copying file.");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Sorry, something went wrong."];
            [alert setInformativeText:[error description]];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                // OK clicked, whatever
                
            }
        } else {
            // Let the window controler know that we have a new image.
            NSString *imagePath = [pathToCopyTo absoluteString];
            imagePath = [imagePath stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
            imagePath = [imagePath stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
            [windowController addImageWithPath:imagePath];
        }

    }
    
}

-(NSData *)getImageBinary:(NSString *)fileName
{
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:fileName];
    NSData *imgData = [img TIFFRepresentation];
    
    return imgData;
}



#pragma mark TextSurround


-(IBAction)surroundItalics:(id)sender
{
    NSString *selectedText = [[self string] substringWithRange:[self selectedRange]];
    NSString *italicMark = @"*";
    
    if(selectedText==(id) [NSNull null] || [selectedText length]==0 || [selectedText isEqual:@""])
    {
        [self insertText:@"**"];
        
        [self setSelectedRange:NSMakeRange(self.selectedRange.location - 1, 0)];

    } else {
        NSString *finalString = [italicMark stringByAppendingString:selectedText];
        finalString = [finalString stringByAppendingString:italicMark];
        
        
        [self insertText:finalString replacementRange:[self selectedRange]];
    }
}

-(IBAction)surroundBold:(id)sender
{
    NSString *selectedText = [[self string] substringWithRange:[self selectedRange]];
    NSString *boldMark = @"**";
    
    if(selectedText==(id) [NSNull null] || [selectedText length]==0 || [selectedText isEqual:@""])
    {
        [self insertText:@"****"];
        
        [self setSelectedRange:NSMakeRange(self.selectedRange.location - 2, 0)];
        
    } else {
        
        NSString *finalString = [boldMark stringByAppendingString:selectedText];
        finalString = [finalString stringByAppendingString:boldMark];
        
        
        [self insertText:finalString replacementRange:[self selectedRange]];

    }

    
}


-(IBAction)insertLink:(id)sender
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], nil];
	NSDictionary *options = [NSDictionary dictionary];
	NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];
    NSString *selectedText = [[self string] substringWithRange:[self selectedRange]];
    NSString *linkopen = @"[";
    NSString *linkClose = @"](";
    NSString *urlCloseParen = @")";
    NSString *buildLink = [linkopen stringByAppendingString:selectedText];
    buildLink = [buildLink stringByAppendingString:linkClose];

	if (copiedItems != nil)
	{
		NSString *urlRegEx = @"[a-z]{2,9}://[a-z|0-9]*.*";
		NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];

		if ([urlTest evaluateWithObject:[copiedItems objectAtIndex:0]])
		{
            buildLink = [buildLink stringByAppendingString:[copiedItems objectAtIndex:0]];

            
		} else {
            buildLink = [buildLink stringByAppendingString:@"url"];
            
        }
        
        NSString *finalString = [buildLink stringByAppendingString:urlCloseParen];
        
        [self insertText:finalString replacementRange:[self selectedRange]];
	} else {
        buildLink = [buildLink stringByAppendingString:@"url"];
        NSString *finalString = [buildLink stringByAppendingString:urlCloseParen];
        [self insertText:finalString replacementRange:[self selectedRange]];
    }
}

#pragma mark Find Panel

- (void)performFindPanelAction:(id)sender
{
    [super performFindPanelAction:sender];
}



@end


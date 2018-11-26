//
//  JBPreviewController.h
//  Scout
//
//  Created by Jon Buys on 12/22/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "JBPost.h"

@interface JBPreviewController : NSObject
{
    IBOutlet WebView *webView;
}

- (void)previewText:(JBPost *)passedPost;

@end

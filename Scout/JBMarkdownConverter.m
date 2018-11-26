//
//  JBMarkdownConverter.m
//  Paragraphs
//
//  Created by Jonathan Buys on 7/3/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBMarkdownConverter.h"
#import "stack.h"
#import "markdown.h"
#import "buffer.h"
#import "html.h"

@implementation JBMarkdownConverter

- (NSString *)markdown2HTML:(NSString *)rawMarkdown
{
    const char * prose = [rawMarkdown UTF8String];
    struct buf *ib, *ob;
    
    long length = [rawMarkdown lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1;
    
    ib = bufnew(length);
    bufgrow(ib, length);
    memcpy(ib->data, prose, length);
    ib->size = length;
    
    ob = bufnew(64);
    
    struct sd_callbacks callbacks;
    struct html_renderopt options;
    struct sd_markdown *markdown;
    
    
    sdhtml_renderer(&callbacks, &options, 0);
    markdown = sd_markdown_new(0, 16, &callbacks, &options);
    
    sd_markdown_render(ob, ib->data, ib->size, markdown);
    sd_markdown_free(markdown);
    
    
    NSString *shinyNewHTML = [NSString stringWithUTF8String: ob->data];
    
    return shinyNewHTML;
}

@end

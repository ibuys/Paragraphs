//
//  JBSiteBuilder.h
//  Scout
//
//  Created by Jonathan Buys on 11/27/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBPost.h"

@interface JBSiteBuilder : NSObject
{
    
}
- (NSString *)buildPost:(JBPost *)postObject;
- (NSString *)buildThemePreview:(JBPost *)postObject withTheme:(NSString *)theme;
- (NSString *)buildPostWithoutCSS:(JBPost *)postObject;
- (NSString *)buildIndex:(NSArray *)frontPagePosts;
- (NSString *)defaultCSS;
- (NSString *)buildAtomXML:(NSArray *)frontPagePosts;
- (NSString *)buildArchive:(NSArray *)allPosts;

@end

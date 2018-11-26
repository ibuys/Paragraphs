//
//  JBDropboxSync.h
//  Scout
//
//  Created by Jonathan Buys on 2/15/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JBPost;

@interface JBDropboxSync : NSObject
{
}

- (NSMutableDictionary *)postStatus:(NSArray *)currentPosts checkPost:(NSString *)changedPost;
- (JBPost *)postFromString:(NSString *)file;
- (NSUInteger)indexOfPostToRemove:(NSArray *)currentArray withString:(NSString *)path;


@end

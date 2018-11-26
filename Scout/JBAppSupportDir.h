//
//  JBAppSupportDir.h
//  Scout
//
//  Created by Jonathan Buys on 11/27/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBAppSupportDir : NSObject
{
    
}

- (NSString *)findOrCreateDirectory:(NSSearchPathDirectory)searchPathDirectory
                           inDomain:(NSSearchPathDomainMask)domainMask
                appendPathComponent:(NSString *)appendComponent
                              error:(NSError **)errorOut;
- (NSString *)applicationSupportDirectory;
- (NSString *)dropboxDir;
- (NSString *)site44Dir;

@end

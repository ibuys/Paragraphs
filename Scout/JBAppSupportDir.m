//
//  JBAppSupportDir.m
//  Scout
//
//  Created by Jonathan Buys on 11/27/12.
//  Copyright (c) 2012 Farmdog Software. All rights reserved.
//

#import "JBAppSupportDir.h"

enum
{
	DirectoryLocationErrorNoPathFound,
	DirectoryLocationErrorFileExistsAtLocation
};

NSString * const DirectoryLocationDomain = @"DirectoryLocationDomain";

@implementation JBAppSupportDir

//
// findOrCreateDirectory:inDomain:appendPathComponent:error:
//
// Method to tie together the steps of:
//	1) Locate a standard directory by search path and domain mask
//  2) Select the first path in the results
//	3) Append a subdirectory to that path
//	4) Create the directory and intermediate directories if needed
//	5) Handle errors by emitting a proper NSError object
//
// Parameters:
//    searchPathDirectory - the search path passed to NSSearchPathForDirectoriesInDomains
//    domainMask - the domain mask passed to NSSearchPathForDirectoriesInDomains
//    appendComponent - the subdirectory appended
//    errorOut - any error from file operations
//
// returns the path to the directory (if path found and exists), nil otherwise
//

- (NSString *)findOrCreateDirectory:(NSSearchPathDirectory)searchPathDirectory
                           inDomain:(NSSearchPathDomainMask)domainMask
                appendPathComponent:(NSString *)appendComponent
                              error:(NSError **)errorOut
{
   // NSLog(@"called");
	//
	// Search for the path
	//
	NSArray* paths = NSSearchPathForDirectoriesInDomains(
                                                         searchPathDirectory,
                                                         domainMask,
                                                         YES);
	if ([paths count] == 0)
	{
		if (errorOut)
		{
			NSDictionary *userInfo =
            [NSDictionary dictionaryWithObjectsAndKeys:
             NSLocalizedStringFromTable(
                                        @"No path found for directory in domain.",
                                        @"Errors",
                                        nil),
             NSLocalizedDescriptionKey,
             [NSNumber numberWithInteger:searchPathDirectory],
             @"NSSearchPathDirectory",
             [NSNumber numberWithInteger:domainMask],
             @"NSSearchPathDomainMask",
             nil];
			*errorOut =
            [NSError
             errorWithDomain:DirectoryLocationDomain
             code:DirectoryLocationErrorNoPathFound
             userInfo:userInfo];
		}
		return nil;
	}
	
	//
	// Normally only need the first path returned
	//
	NSString *resolvedPath = [paths objectAtIndex:0];
    
	//
	// Append the extra path component
	//
	if (appendComponent)
	{
		resolvedPath = [resolvedPath stringByAppendingPathComponent:appendComponent];
       // NSLog(@"resolvedPath = %@", resolvedPath);
	}
	
	//
	// Create the path if it doesn't exist
	//
	NSError *error = nil;
	BOOL success = [[NSFileManager defaultManager] 
                    createDirectoryAtPath:resolvedPath
                    withIntermediateDirectories:YES
                    attributes:nil
                    error:&error];
	if (!success)
	{
		if (errorOut)
		{
			*errorOut = error;
		}
		return nil;
	}
	
	//
	// If we've made it this far, we have a success
	//
    
	if (errorOut)
	{
		*errorOut = nil;
	}
    
	return resolvedPath;
}

//
// applicationSupportDirectory
//
// Returns the path to the applicationSupportDirectory (creating it if it doesn't
// exist).
//

- (NSString *)applicationSupportDirectory
{
	NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
	NSError *error;
	NSString *result =
    
    [self
     findOrCreateDirectory:NSApplicationSupportDirectory
     inDomain:NSUserDomainMask
     appendPathComponent:executableName
     error:&error];
	
    if (!result)
	{
		NSLog(@"Unable to find or create application support directory:\n%@", error);
	}
    
	return result;
}

- (NSString *)dropboxDir
{
    
        
	NSString *resolvedPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Dropbox/Apps/FarmdogScout"];
	return resolvedPath;

}

- (NSString *)site44Dir
{
    NSString *resolvedPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Dropbox/Apps/site44"];
	return resolvedPath;

}

@end

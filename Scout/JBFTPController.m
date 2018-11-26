//
//  JBFTPController.m
//  Scout
//
//  Created by Jon Buys on 1/5/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBFTPController.h"
#import "JBAppSupportDir.h"

@implementation JBFTPController

- (id)init
{
    self = [super init];
    if( self != nil )
    {
        // Do my quick initialization here
    }
    return self;
}


#pragma mark action methods

- (void) uploadFile :(NSString *)file
{
    //----- get the file to upload as an NSData object
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath = [NSString stringWithFormat: @"%@/%@", applicationDocumentsDir, @"image.jpg"];
    uploadData = [NSData dataWithContentsOfFile: filepath];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    uploadFile = [BRRequestUpload initWithDelegate: self];
    uploadFile.path = file;
    uploadFile.hostname = [defaults valueForKey:@"siteHostname"];
    uploadFile.username = [defaults valueForKey:@"username"];
    uploadFile.password = [defaults valueForKey:@"password"];
    
    [uploadFile start];
}

- (void) downloadFile :(NSString *)file
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    downloadData = [NSMutableData dataWithCapacity: 1];
    
    downloadFile = [BRRequestDownload initWithDelegate: self];
    downloadFile.hostname = [defaults valueForKey:@"siteHostname"];
    downloadFile.path = file;
    downloadFile.username = [defaults valueForKey:@"username"];
    downloadFile.password = [defaults valueForKey:@"password"];
    
    [downloadFile start];
}

- (void) deleteFile:(NSString *)file
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    deleteFile = [BRRequestDelete initWithDelegate: self];
    deleteFile.path = file;
    deleteFile.hostname = [defaults valueForKey:@"siteHostname"];

    deleteFile.username = [defaults valueForKey:@"username"];
    deleteFile.password = [defaults valueForKey:@"password"];

    [deleteFile start];
}


- (void) createDirectory:(NSString *)directory
{
    
    
    
    createDir = [BRRequestCreateDirectory initWithDelegate: self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *pubPath = [defaults valueForKey:@"pubPath"];
    if(pubPath !=(id) [NSNull null] || [pubPath length] !=0 || ![pubPath isEqual:@""])
    {
        directory = [pubPath stringByAppendingPathComponent:directory];
    }
    

    createDir.hostname = [defaults valueForKey:@"siteHostname"];
    NSLog(@"hostname = %@", [defaults valueForKey:@"siteHostname"]);
    
    createDir.path = directory;
    NSLog(@"directory = %@", directory);

    createDir.username = [defaults valueForKey:@"username"];
    NSLog(@"username = %@", [defaults valueForKey:@"username"]);

    createDir.password = [defaults valueForKey:@"password"];
    NSLog(@"password = %@", [defaults valueForKey:@"password"]);

    
    [createDir start];
}

- (void) deleteDirectory:(NSString *)directory
{
    deleteDir = [BRRequestDelete initWithDelegate: self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    deleteDir.hostname = [defaults valueForKey:@"siteHostname"];
    deleteDir.path = [defaults valueForKey:@"sitePath"];
    deleteDir.username = [defaults valueForKey:@"username"];
    deleteDir.password = [defaults valueForKey:@"password"];
    
    [deleteDir start];
}

- (void) requestDataAvailable: (BRRequestDownload *) request;
{
    [downloadData appendData: request.receivedData];
}

#pragma mark IBActions

- (IBAction) cancelAction :(id)sender
{
    if (uploadFile)
    {
        uploadFile.cancelDoesNotCallDelegate = TRUE;
        [uploadFile cancelRequest];
    }
    
    if (downloadFile)
    {
        downloadFile.cancelDoesNotCallDelegate = TRUE;
        [downloadFile cancelRequest];
    }
}


#pragma mark delegate methods

-(void) requestCompleted: (BRRequest *) request
{
    if (request == createDir)
    {
        NSLog(@"%@ completed!", request);
        
        createDir = nil;
    }
    
    if (request == deleteDir)
    {
        NSLog(@"%@ completed!", request);
        
        deleteDir = nil;
    }
    
    if (request == listDir)
    {
        //called after 'request' is completed successfully
        NSLog(@"%@ completed!", request);
        
        //we print each of the files name
        for (NSDictionary *file in listDir.filesInfo)
        {
            NSLog(@"%@", [file objectForKey:(id)kCFFTPResourceName]);
            
            //logview.text = [NSString stringWithFormat: @"%@\n%@", logview.text, [file objectForKey:(id)kCFFTPResourceName]];
        }
        
//        logview.text = [NSString stringWithFormat: @"%@\n", logview.text];
//        [logview scrollRangeToVisible: NSMakeRange([logview.text length] - 1, 1)];
        
        NSLog(@"%@", listDir.filesInfo);
        
        listDir = nil;
    }
    
    if (request == downloadFile)
    {
        //called after 'request' is completed successfully
        NSLog(@"%@ completed!", request);
        
        NSError *error;
        
        //----- save the downloadData as a file object
        NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filepath = [NSString stringWithFormat: @"%@/%@", applicationDocumentsDir, @"image.jpg"];
        
        [downloadData writeToFile: filepath options:NSDataWritingAtomic error: &error];
        downloadData = nil;
        downloadFile = nil;
    }
    
    if (request == uploadFile)
    {
        NSLog(@"%@ completed!", request);
        uploadFile = nil;
    }
    
    if (request == deleteFile)
    {
        NSLog(@"%@ completed!", request);
        deleteFile = nil;
    }
    
}

-(void) requestFailed:(BRRequest *) request
{
    if (request == createDir)
    {
        NSLog(@"%@", request.error.message);
        
        createDir = nil;
    }
    
    if (request == deleteDir)
    {
        NSLog(@"%@", request.error.message);
        
        deleteDir = nil;
    }
    
    if (request == listDir)
    {
        //logview.text = [NSString stringWithFormat: @"%@\n\nList Dir Failed with %@", logview.text, request.error.message];
        
        //called if 'request' ends in error
        //we can print the error message
        NSLog(@"%@", request.error.message);
        
        listDir = nil;
    }
    
    if (request == downloadFile)
    {
        NSLog(@"%@", request.error.message);
        
        downloadFile = nil;
    }
    
    if (request == uploadFile)
    {
        NSLog(@"%@", request.error.message);
        
        uploadFile = nil;
    }
    
    if (request == deleteFile)
    {
        NSLog(@"%@", request.error.message);
        deleteFile = nil;
    }
}

-(BOOL) shouldOverwriteFileWithRequest: (BRRequest *) request
{
    //----- set this as appropriate if you want the file to be overwritten
    if (request == uploadFile)
    {
        //----- if uploading a file, we set it to YES
        return YES;
    }
    
    //----- anything else (directories, etc) we set to NO
    return NO;
}

- (void) percentCompleted: (BRRequest *) request
{
    NSLog(@"%f completed...", request.percentCompleted);
    NSLog(@"%ld bytes this iteration", request.bytesSent);
    NSLog(@"%ld total bytes", request.totalBytesSent);
}

- (long) requestDataSendSize: (BRRequestUpload *) request
{
    //----- user returns the total size of data to send. Used ONLY for percentComplete
    return [uploadData length];
}


#pragma mark Interaction

- (void)publishSite
{
//    NSError *error = [[NSError alloc] init];
    NSLog(@"publishSite");
    JBAppSupportDir *appSupDir = [[JBAppSupportDir alloc] init];
    NSString *path = [appSupDir applicationSupportDirectory];
    
    NSString *sourceFTPPath = [path stringByAppendingPathComponent:@"ftpExport"];
    NSLog(@"sourceFTPPath is: %@", sourceFTPPath);
    
//    NSURL *siteRootDir = [[NSURL alloc] initFileURLWithPath:sourceFTPPath];
    
    
    // parse the contents of siteRootDir, enumerating each file recursivly
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:sourceFTPPath];
    
    NSString *file;
//    NSString *dateString;
//    NSDate *thisPostDate;
    NSArray *subpaths;
    BOOL isDir;

    while (file = [dirEnum nextObject])
    {
        path = [sourceFTPPath stringByAppendingPathComponent:file];
       // NSLog(@"file = %@", file);
        
//        NSDictionary *attributesDictionary = [fileManager attributesOfFileSystemForPath:file error:&error];
//        NSLog(@"attributes = %@", attributesDictionary);
        
        if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir)
        {
            // If the file is a directory, create the directory on the ftp server

            NSLog(@" Found a directory");
            [self createDirectory:file];

            subpaths = [fileManager subpathsAtPath:path];
        } else {
            [self uploadFile:file];
        }

    }
    // If the file is a file, upload the file to the ftp server
    // If the file is a directory, enumerate the directory and upload each file to the ftp server
    

}


@end

//
//  JBFTPController.h
//  Scout
//
//  Created by Jon Buys on 1/5/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import <Foundation/Foundation.h>

//---------- include files
#import "BRRequestListDirectory.h"
#import "BRRequestCreateDirectory.h"
#import "BRRequestUpload.h"
#import "BRRequestDownload.h"
#import "BRRequestDelete.h"

@interface JBFTPController : NSObject <BRRequestDelegate>
{
    BRRequestCreateDirectory *createDir;
    BRRequestDelete * deleteDir;
    BRRequestListDirectory *listDir;
    
    BRRequestDownload * downloadFile;
    BRRequestUpload *uploadFile;
    BRRequestDelete *deleteFile;

    NSMutableData *downloadData;
    NSData *uploadData;

}

- (void)publishSite;

@end

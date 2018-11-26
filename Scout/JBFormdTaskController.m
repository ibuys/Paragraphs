//
//  JBFormdTaskController.m
//  Paragraphs
//
//  Created by Jonathan Buys on 3/26/13.
//  Copyright (c) 2013 Farmdog Software. All rights reserved.
//

#import "JBFormdTaskController.h"

@implementation JBFormdTaskController

- (NSString *)runPythonScriptWithString:(NSString *)postText
{
    NSTask* task = [[NSTask alloc] init];
    task.launchPath = [[NSBundle mainBundle] pathForResource:@"formd" ofType:nil];
    task.arguments = [NSArray arrayWithObjects: @"-f", nil];
    
    // NSLog breaks if we don't do this...
    [task setStandardInput: [NSPipe pipe]];
    
    NSPipe *stdInPipe = nil;
    stdInPipe = [NSPipe pipe];
    [task setStandardInput:stdInPipe];

    NSFileHandle* taskInput = [[ task standardInput ] fileHandleForWriting ];

    
    
    NSPipe *stdOutPipe = nil;
    stdOutPipe = [NSPipe pipe];
    [task setStandardOutput:stdOutPipe];
    
    NSPipe* stdErrPipe = nil;
    stdErrPipe = [NSPipe pipe];
    [task setStandardError: stdErrPipe];
    
    [task launch];
    
    [ taskInput writeData:[postText dataUsingEncoding:NSUTF8StringEncoding]];

    NSData* data = [[stdOutPipe fileHandleForReading] readDataToEndOfFile];
    
    [task waitUntilExit];
    
    NSInteger exitCode = task.terminationStatus;
    
    if (exitCode != 0)
    {
        NSLog(@"Error!");
        return nil;
    }
    
    return [[NSString alloc] initWithBytes: data.bytes length:data.length encoding: NSUTF8StringEncoding];
}



@end

////
////  JBSingletonMutableArray.m
////  Scout
////
////  Created by Jonathan Buys on 12/28/12.
////  Copyright (c) 2012 Farmdog Software. All rights reserved.
////
//
//#import "JBSingletonMutableArray.h"
//
//@implementation JBSingletonMutableArray
//
//+(JBSingletonMutableArray *)singleton
//{
//    static dispatch_once_t pred;
//    static JBSingletonMutableArray *shared = nil;
//    
//    dispatch_once(&pred, ^{
//        shared = [[JBSingletonMutableArray alloc] init];
//    });
//    return shared;
//}
//
//
//
//-(id)init {
//    if ( self = [super init] )
//    {
//        postLinkRangeArray = [[NSMutableArray alloc] init];
//    }
//    return self;
//}
//
//
//
//-(void)addRangeToArray:(NSRange)range
//{
//    
//    // [a addObject:[NSValue valueWithRange:r]];
//    // NSRange r = [[a objectAtIndex:4] rangeValue];
//
//    [postLinkRangeArray addObject:[NSValue valueWithRange:range]];
//}
//
//-(void)emptyArray
//{
//    [postLinkRangeArray removeAllObjects];
//}
//
//-(NSRange)findCurrentLocation:(NSRange)location
//{
//   // NSLog(@"findCurrentLocation");
//    
//
//    for (NSValue *rangeValue in postLinkRangeArray)
//    {
//        NSRange r = [rangeValue rangeValue];
//        
//        NSUInteger cursorLocation = location.location;
//        
//        if (r.location < cursorLocation)
//        {
//            if (r.location + r.length > cursorLocation)
//            {
//             //   NSLog(@"found it");
//                return r;
//            }
//        }
//        
//        
//    }
//    return NSMakeRange(0, 0);
//}
//
//
//
//@end

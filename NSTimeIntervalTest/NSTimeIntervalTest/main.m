//
//  main.m
//  NSTimeIntervalTest
//
//  Created by stone on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // 我到要看看，他打印出来到底是个什么东西！
        NSDate *testDate = [NSDate date];
        NSTimeInterval testInterval = [testDate timeIntervalSince1970];
        
        NSLog(@"\nThe NSTimeInterval is:\n%g\n", testInterval);
    }
    return 0;
    // 也就是别名
}


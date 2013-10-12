//
//  main.m
//  CFStringTest
//
//  Created by stone on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        NSString *originalString = @"http:// 牛www.google.com.hk";
        NSString *covertString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)originalString, CFSTR("牛"), CFSTR(" "), kCFStringEncodingUTF8);
        [covertString autorelease];
        NSLog(@"\noriginal:\n%@\ncovert:\n%@*", originalString, covertString);
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

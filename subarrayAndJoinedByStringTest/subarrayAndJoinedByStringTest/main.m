//
//  main.m
//  subarrayAndJoinedByStringTest
//
//  Created by stone on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // 加入子数组是什么作用？
        NSArray *testArray = [NSArray arrayWithObjects:
                              @"a", @"b", 
                              [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], nil];
        NSLog(@"\nThe original array is:\n%@\nand count is:%lu", testArray, testArray.count);
        NSArray *testArray2 = [testArray subarrayWithRange:NSMakeRange(1, 2)];
        NSLog(@"\nThe subed array is:\n%@\nand count is:%lu", testArray2, testArray2.count);
        
        NSString *testString = [testArray componentsJoinedByString:@"分隔符"];
        NSLog(@"\nNow show the JoinedString:\n%@", testString);
        // 不是什么加入子数组，而是通过Rang构造一个新的数组
        // 第二个方法就是，将数组中的元素再加上分隔符，构成一个字符串
        
//        NSMutableArray *testMutableArray = [NSMutableArray array];
//        [testMutableArray addObject:testString];
//        for (NSString *str in testMutableArray)
//        {
//            NSLog(@"\nThe str in the Loop is:\n%@", str);
//        }
        
    }
    return 0;
}


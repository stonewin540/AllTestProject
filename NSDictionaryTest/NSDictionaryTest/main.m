//
//  main.m
//  NSDictionaryTest
//
//  Created by stone on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // 只是想测试一下，快速枚举字典的话，他是否默认取出里面的key
        NSDictionary *testDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"value1", @"key1", @"value2", @"key2", 
                                        @"value3", @"key3", @"value4", @"key4", nil];
        for (id str in testDictionary)
        {
            NSLog(@"\nstr is:%@", str);
        }
        // 结果是肯定的，就是那么回事！
    }
    return 0;
}


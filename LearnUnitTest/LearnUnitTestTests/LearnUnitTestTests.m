//
//  LearnUnitTestTests.m
//  LearnUnitTestTests
//
//  Created by stone win on 3/6/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LUTObject.h"

@interface LearnUnitTestTests : XCTestCase

@property (nonatomic, strong) NSMutableArray *LUTObjects;

@end

@implementation LearnUnitTestTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.LUTObjects = [[NSMutableArray alloc] init];
    NSUInteger count = arc4random() % 10;
    for (int i = 0; i < count; i++)
    {
        LUTObject *object = [[LUTObject alloc] init];
        XCTAssert(nil != object, @"Nil object generated!!");
        [self.LUTObjects addObject:object];
    }
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.LUTObjects = nil;
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testCount
{
    XCTAssert(0 != [self.LUTObjects count], @"We have nothing!");
    
    [self.LUTObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LUTObject *lut = obj;
        XCTAssert(nil != lut.message, @"Woo, object not init");
        NSLog(@"%@", lut.message);
    }];
}

@end

//
//  LUTObject.m
//  LearnUnitTest
//
//  Created by stone win on 3/6/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import "LUTObject.h"

@implementation LUTObject

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _objectId = [NSString stringWithFormat:@"%u", arc4random() % 65536];
        _duration = @(arc4random() % 1024);
        _message = [NSString stringWithFormat:@"This is NO.%@ object, and duration is %@", _objectId, _duration];
    }
    return self;
}

@end

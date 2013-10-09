//
//  CTContainer.m
//  ConsumerTest
//
//  Created by stone win on 9/3/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "CTContainer.h"

@implementation CTContainer
{
    NSMutableArray *_container;
    NSLock *_locker;
    __weak id<CTContainerDelegate> _delegate;
}

#pragma mark - Helpers

- (void)setDelegate:(id<CTContainerDelegate>)delegate
{
    _delegate = delegate;
}

- (BOOL)addProduct:(id)product
{
    [_locker lock];
    
    if ([_container count] >= [CTContainer capacity])
    {
        [_locker unlock];
        return NO;
    }
    
    [_container insertObject:product atIndex:0];
    if (_delegate && [_delegate respondsToSelector:@selector(container:didStroeProduct:)])
    {
        [_delegate container:self didStroeProduct:product];
    }
    [_locker unlock];
    return YES;
}

- (BOOL)removeProduct:(id)product
{
    [_locker lock];
    
    if (![_container count] || ![_container containsObject:product])
    {
        [_locker unlock];
        return NO;
    }
    
    [_container removeObject:product];
    if (_delegate && [_delegate respondsToSelector:@selector(container:didRemoveProduct:)])
    {
        [_delegate container:self didRemoveProduct:product];
    }
    [_locker unlock];
    return YES;
}

- (id)product
{
    return [_container lastObject];
}

- (BOOL)containsProduct:(id)product
{
    return [_container containsObject:product];
}

- (NSUInteger)count
{
    return [_container count];
}

- (void)removeAllProducts
{
    [_container removeAllObjects];
}

#pragma mark - Publics

+ (id)defaultContainer
{
    static CTContainer *container;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        container = [[CTContainer alloc] init];
    });
    return container;
}

+ (void)setDelegate:(id<CTContainerDelegate>)delegate
{
    [[CTContainer defaultContainer] setDelegate:delegate];
}

+ (NSUInteger)capacity
{
    return 3;
}

+ (BOOL)addProduct:(id)product
{
    return [[CTContainer defaultContainer] addProduct:product];
}

+ (BOOL)removeProduct:(id)product
{
    return [[CTContainer defaultContainer] removeProduct:product];
}

+ (id)product
{
    return [[CTContainer defaultContainer] product];
}

+ (BOOL)containsProduct:(id)product
{
    return [[CTContainer defaultContainer] containsProduct:product];
}

+ (NSUInteger)count
{
    return [[CTContainer defaultContainer] count];
}

+ (void)removeAllProducts
{
    [[CTContainer defaultContainer] removeAllProducts];
}

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _container = [[NSMutableArray alloc] init];
        _locker = [[NSLock alloc] init];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _container];
}

@end

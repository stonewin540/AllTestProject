//
//  CTProducer.m
//  ConsumerTest
//
//  Created by stone win on 9/3/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "CTProducer.h"
#import "CTContainer.h"
#import <pthread.h>

static dispatch_queue_t _produceQueue;
static pthread_mutex_t _mutex;

@implementation CTProducer
{
    dispatch_semaphore_t _produceSemaphore;
    dispatch_semaphore_t _waitingSemaphore;
    BOOL _stop;
    NSUInteger _capability;
}

#pragma mark - Helpers

+ (NSArray *)productType
{
    static NSArray *productType;
    if (!productType)
    {
        productType = [[NSArray alloc] initWithObjects:@"Huam🍔", @"Chips🍟", @"Coca-cola", nil];
    }
    return productType;
}

- (id)anyProduct
{
    static NSUInteger productIndex = 0;
    
    productIndex = productIndex>=[CTContainer capacity] ? 0 : productIndex;
    id product = [[CTProducer productType] objectAtIndex:productIndex++];
    
    return product;
}

- (BOOL)produce
{
    if ([CTContainer count] >= [CTContainer capacity])
    {
        return NO;
    }
    
    pthread_mutex_lock(&_mutex);
    id product = [self anyProduct];
    if (_delegate && [_delegate respondsToSelector:@selector(producer:willProduce:)])
    {
        [_delegate producer:self willProduce:product];
    }
    pthread_mutex_unlock(&_mutex);
    
    usleep((_capability*.8f) * MCSEC_PER_SEC);
    
    pthread_mutex_lock(&_mutex);
    if (_delegate && [_delegate respondsToSelector:@selector(producer:didProduce:)])
    {
        [_delegate producer:self didProduce:product];
    }
    BOOL succeed = [CTContainer addProduct:product];
    pthread_mutex_unlock(&_mutex);
    
    if (!succeed) return succeed;
    usleep((_capability*.2f) * MCSEC_PER_SEC);
    
    return succeed;
}

#pragma mark - Publics

- (void)startProduce
{
    dispatch_async(_produceQueue, ^{
        
        while (!_stop)
        {
            while ([self produce] && !_stop)
            {
                dispatch_semaphore_signal(_produceSemaphore);
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(producerWillWaiting:)])
            {
                [_delegate producerWillWaiting:self];
            }
            dispatch_semaphore_wait(_waitingSemaphore, DISPATCH_TIME_FOREVER);
        }
        
    });
}

- (void)stopProduce
{
    _stop = YES;
    dispatch_semaphore_signal(_waitingSemaphore);
    pthread_mutex_destroy(&_mutex);
}

#pragma mark - Lifecycle

- (id)initWithProduceSemaphore:(dispatch_semaphore_t)produceSemaphore waitingSemaphore:(dispatch_semaphore_t)waitingSemaphore capability:(NSUInteger)capability
{
    self = [super init];
    if (self)
    {
        _produceQueue = dispatch_queue_create("com.CTProducer.produceQueue", DISPATCH_QUEUE_CONCURRENT);
        _produceSemaphore = produceSemaphore;
        _waitingSemaphore = waitingSemaphore;
        _capability = capability;
        pthread_mutex_init(&_mutex, NULL);
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"%s", __FUNCTION__);
}

@end

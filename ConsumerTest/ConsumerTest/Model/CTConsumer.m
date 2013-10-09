//
//  CTConsumer.m
//  ConsumerTest
//
//  Created by stone win on 9/3/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "CTConsumer.h"
#import "CTContainer.h"
#import <pthread.h>

static dispatch_queue_t _consumQueue;
static pthread_mutex_t _mutex;

@implementation CTConsumer
{
    dispatch_semaphore_t _consumSemaphore;
    dispatch_semaphore_t _waitingSemaphore;
    BOOL _stop;
    NSUInteger _capability;
}

- (BOOL)consum
{
    pthread_mutex_lock(&_mutex);
    // if nil==product means the container is empty!
    id product = [CTContainer product];
    if (!product)
    {
        pthread_mutex_unlock(&_mutex);
        return NO;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(consumer:willConsum:)])
    {
        [_delegate consumer:self willConsum:product];
    }
    BOOL succeed = [CTContainer removeProduct:product];
    pthread_mutex_unlock(&_mutex);
    usleep((_capability*.8f) * MCSEC_PER_SEC);
    
    if (_delegate && [_delegate respondsToSelector:@selector(consumer:didConsum:)])
    {
        [_delegate consumer:self didConsum:product];
    }
    usleep((_capability*.2f) * MCSEC_PER_SEC);
    
    return succeed;
}

#pragma mark - Publics

- (void)startConsum
{
    dispatch_async(_consumQueue, ^{
        
        while (!_stop)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(consumerWillWait:)])
            {
                [_delegate consumerWillWait:self];
            }
            dispatch_semaphore_wait(_waitingSemaphore, DISPATCH_TIME_FOREVER);
                        
            while ([self consum] && !_stop)
            {
                
            }
            dispatch_semaphore_signal(_consumSemaphore);
        }
        
    });
}

- (void)stopConsum
{
    _stop = YES;
    dispatch_semaphore_signal(_waitingSemaphore);
    pthread_mutex_destroy(&_mutex);
}

#pragma mark - Lifecycle

- (id)initWithConsumSemaphore:(dispatch_semaphore_t)consumSemaphore waitingSemaphore:(dispatch_semaphore_t)waitingSemaphore capability:(NSUInteger)capability
{
    self = [super init];
    if (self)
    {
        _consumQueue = dispatch_queue_create("com.CTConsumer.consumQueue", DISPATCH_QUEUE_CONCURRENT);
        _consumSemaphore = consumSemaphore;
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

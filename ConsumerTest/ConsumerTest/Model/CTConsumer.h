//
//  CTConsumer.h
//  ConsumerTest
//
//  Created by stone win on 9/3/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTConsumerDelgate;

@interface CTConsumer : NSObject

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) id<CTConsumerDelgate> delegate;

- (id)initWithConsumSemaphore:(dispatch_semaphore_t)consumSemaphore waitingSemaphore:(dispatch_semaphore_t)waitingSemaphore capability:(NSUInteger)capability;
- (void)startConsum;
- (void)stopConsum;

@end

@protocol CTConsumerDelgate <NSObject>

- (void)consumer:(CTConsumer *)consumer willConsum:(id)product;
- (void)consumer:(CTConsumer *)consumer didConsum:(id)product;
- (void)consumerWillWait:(CTConsumer *)consumer;

@end

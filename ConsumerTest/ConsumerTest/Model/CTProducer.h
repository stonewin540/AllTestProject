//
//  CTProducer.h
//  ConsumerTest
//
//  Created by stone win on 9/3/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTProducerDelegate;

@interface CTProducer : NSObject

@property (nonatomic, assign) NSUInteger tag;
@property (nonatomic, weak) id<CTProducerDelegate> delegate;

- (id)initWithProduceSemaphore:(dispatch_semaphore_t)produceSemaphore waitingSemaphore:(dispatch_semaphore_t)waitingSemaphore capability:(NSUInteger)capability;
- (void)startProduce;
- (void)stopProduce;
+ (NSArray *)productType;

@end

@protocol CTProducerDelegate <NSObject>

- (void)producer:(CTProducer *)producer willProduce:(id)product;
- (void)producer:(CTProducer *)producer didProduce:(id)product;
- (void)producerWillWaiting:(CTProducer *)producer;

@end

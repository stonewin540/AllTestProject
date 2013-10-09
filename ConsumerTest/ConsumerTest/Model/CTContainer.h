//
//  CTContainer.h
//  ConsumerTest
//
//  Created by stone win on 9/3/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTContainerDelegate;

@interface CTContainer : NSObject

+ (id)defaultContainer;
+ (void)setDelegate:(id<CTContainerDelegate>)delegate;
+ (NSUInteger)capacity;
+ (BOOL)addProduct:(id)product;
+ (BOOL)removeProduct:(id)product;
+ (id)product;
+ (BOOL)containsProduct:(id)product;
+ (NSUInteger)count;
+ (void)removeAllProducts;

@end

@protocol CTContainerDelegate <NSObject>

- (void)container:(CTContainer *)container didStroeProduct:(id)product;
- (void)container:(CTContainer *)container didRemoveProduct:(id)product;

@end

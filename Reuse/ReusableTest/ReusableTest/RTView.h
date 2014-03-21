//
//  RTView.h
//  ReusableTest
//
//  Created by stone win on 5/14/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTCell.h"

@protocol RTViewDataSource;
@protocol RTViewDelegate;

@interface RTView : UIScrollView

@property (nonatomic, weak) id<RTViewDataSource> rtDataSource;
@property (nonatomic, weak) id<RTViewDelegate> rtDelegate;

- (RTCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier;
- (void)reloadData;

@end

@protocol RTViewDataSource <NSObject>

@required
- (NSUInteger)numberOfRowsInReusableView;
- (RTCell *)reusableView:(RTView *)reusableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol RTViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (CGFloat)reusableView:(RTView *)reusableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)reusableView:(RTView *)reusableView willDisplayCell:(RTCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

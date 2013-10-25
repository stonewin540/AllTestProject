//
//  PGVTView.h
//  PagingGridViewTest
//
//  Created by stone win on 10/25/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGVTItem.h"

@class PGVTView;
@protocol PGVTViewDataSource <NSObject>

@required
- (NSInteger)pagingGridView:(PGVTView *)pagingGridView numberOfItemsInSection:(NSInteger)section;
- (PGVTItem *)pagingGridView:(PGVTView *)pagingGridView itemForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@protocol PGVTViewDelegate <UIScrollViewDelegate>

@end

@interface PGVTView : UIScrollView

@property (nonatomic, weak) id<PGVTViewDataSource> dataSource;
@property (nonatomic, weak) id<PGVTViewDelegate> delegate;

- (PGVTItem *)dequeueReuseableItemForReuseIdentifier:(NSString *)reuseIdentifer;

@end

//
//  SRTScrollSelector.h
//  ZhiyueSD
//
//  Created by stone win on 3/19/14.
//  Copyright (c) 2014 micromedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRTScrollSelectorDelegate;

@interface SRTScrollSelector : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, weak) id<SRTScrollSelectorDelegate> delegate;

- (void)reloadData;
- (void)selectedTitleAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

@end

@protocol SRTScrollSelectorDelegate <NSObject>

@required
- (void)scrollSelector:(SRTScrollSelector *)selector didSelectTitleAtIndexPath:(NSIndexPath *)indexPath;

@end

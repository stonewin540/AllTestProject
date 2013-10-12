//
//  DummyScrollView.h
//  ScrollPagingManully
//
//  Created by stone on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 *  这个类就是为了帮助扩展主ScrollView以外的空间的控件，
 *  可以响应拖动的类。
 *  只做了一件事重写
 *  - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
 *  方法
 */

#import <UIKit/UIKit.h>

@interface DummyScrollView : UIView

@property (retain, nonatomic) UIScrollView *dummyScrollView;

@end

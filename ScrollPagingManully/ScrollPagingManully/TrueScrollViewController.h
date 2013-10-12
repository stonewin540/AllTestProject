//
//  TrueScrollViewController.h
//  ScrollPagingManully
//
//  Created by stone on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 *  这是一个主view，很普通，所有控件添加到这里，
 *  主要的ScrollView以及功能扩展的View都放到这里
 *  其实DummyScrollView不用声明为成员也可以，
 *  只是为了试验功能摸清套路才声明为成员
 */

#import <UIKit/UIKit.h>
@class DummyScrollView;

@interface TrueScrollViewController : UIViewController <UIScrollViewDelegate>

@property (retain, nonatomic) UIScrollView *trueScrollView;
@property (assign, nonatomic) DummyScrollView *dummy;

@end

//
//  SecondViewController.h
//  scrollSubThreeScrollViewTest
//
//  Created by 斯敦  文 on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

{
    UIScrollView *_mainScrollView00;
    UIScrollView *_mainScrollView01;
    UIScrollView *_mainScrollView02;
    int recycleScrollViewTags[3];
    int recycleScrollViewAlpha[3];
}

@property (nonatomic, retain) UIScrollView *mainScrollView00;
@property (nonatomic, retain) UIScrollView *mainScrollView01;
@property (nonatomic, retain) UIScrollView *mainScrollView02;

@end

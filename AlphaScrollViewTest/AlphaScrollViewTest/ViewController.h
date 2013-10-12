//
//  ViewController.h
//  AlphaScrollViewTest
//
//  Created by stone on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubTopicTableView;

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *testScrollView;
@property (retain, nonatomic) SubTopicTableView *subTopicTableView;
@property (retain, nonatomic) NSMutableDictionary *userInfo;

@end

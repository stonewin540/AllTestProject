//
//  SubTopicTableView.h
//  AlphaScrollViewTest
//
//  Created by stone on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTopicTableView : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *dataArray;

@end

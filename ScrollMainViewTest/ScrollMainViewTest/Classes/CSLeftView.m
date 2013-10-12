//
//  CSLeftView.m
//  ScrollMainViewTest
//
//  Created by 文 斯敦 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CSLeftView.h"

@implementation CSLeftView

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITableView *tMainTable = [[UITableView alloc] initWithFrame:self.bounds 
                                                               style:UITableViewStylePlain];
        [tMainTable setBackgroundColor:[UIColor lightGrayColor]];
        [tMainTable setScrollsToTop:NO];
        [self addSubview:tMainTable];
        [tMainTable release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

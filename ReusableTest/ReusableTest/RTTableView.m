//
//  RTTableView.m
//  ReusableTest
//
//  Created by stone win on 5/14/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "RTTableView.h"

@implementation RTTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reloadData
{
    NSLog(@"%s", __FUNCTION__);
    [super reloadData];
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

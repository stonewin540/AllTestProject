//
//  CSRightView.m
//  ScrollMainViewTest
//
//  Created by 文 斯敦 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CSRightView.h"

@implementation CSRightView

- (void)dealloc
{
    [_naviSearchBar release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        //[tapGesture setNumberOfTapsRequired:1];
        [tapGesture setDelegate:self];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        UITableView *tMainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, 320, 460 - 43) 
                                                               style:UITableViewStylePlain];
        [tMainTable setBackgroundColor:[UIColor lightGrayColor]];
        [tMainTable setScrollsToTop:NO];
        [self addSubview:tMainTable];
        [tMainTable release];
        UISearchBar *tSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 48)];
        [tSearch setBackgroundImage:[UIImage imageNamed:@"topBarBackgroundWithShadow.png"]];
        [self addSubview:tSearch];
        _naviSearchBar = [tSearch retain];
        [tSearch release];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
       shouldReceiveTouch:(UITouch *)touch
{
    if ([_naviSearchBar isFirstResponder]) [_naviSearchBar resignFirstResponder];
    return YES;
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

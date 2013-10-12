//
//  ViewController.m
//  AlphaScrollViewTest
//
//  Created by stone on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SubTopicTableView.h"

#define kButtonCount 10
#define kButtonWidth (320 / 5)
#define kButtonHeight 24
#define kButtonOffset(a) (kButtonWidth) * ((a) + 2)

@interface ViewController ()
- (void)whenButtonTap:(id)sender;
@end

@implementation ViewController

@synthesize testScrollView;
@synthesize subTopicTableView;
@synthesize userInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 添加TableView到自己的界面里
    self.subTopicTableView = [[SubTopicTableView alloc] initWithStyle:UITableViewStylePlain];
    [self.view addSubview:subTopicTableView.view];
    
    // 实例化10个button放到scrollView中
    for (int i = 0; i < kButtonCount; i++)
    {
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [NSString string];
        [tempBtn setTag:i];
        [tempBtn setUserInteractionEnabled:YES];
        [tempBtn setFrame:CGRectMake((kButtonOffset(i)), 0, kButtonWidth, kButtonHeight)];
        [tempBtn setTitle:[NSString stringWithFormat:@"button%d", i] forState:UIControlStateNormal];
        [tempBtn addTarget:self action:@selector(whenButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.testScrollView addSubview:tempBtn];
    }
    
    // 设置scrollView的相关参数
    [self.testScrollView setContentSize:CGSizeMake(((14 * kButtonWidth)), self.testScrollView.frame.size.height)];
    [self.testScrollView setShowsVerticalScrollIndicator:NO];
    [self.testScrollView setShowsHorizontalScrollIndicator:NO];
    [self.testScrollView setBackgroundColor:[UIColor blackColor]];
    [self.testScrollView setDelegate:self];
    // 界面一展示就滑动到button2的位置
    [self.testScrollView setContentOffset:CGPointMake((kButtonWidth * 2), 0)];
    
    // 给tableView装入数据
    self.subTopicTableView.dataArray = [NSMutableArray array];
    // 这个是为了模拟从网络取回的字典数据
    self.userInfo = [NSMutableDictionary dictionary];
    for (int i = 0; i < 10; i++)
    {
        NSString *stringObject = [NSString stringWithFormat:@"Button2Row%d", i];
        [self.subTopicTableView.dataArray addObject:stringObject];
        [self.userInfo setValue:[NSString stringWithFormat:@"button%d", i] forKey:[NSString stringWithFormat:@"%d", i]];
    }
}

- (void)viewDidUnload
{
    [self setTestScrollView:nil];
    [self setSubTopicTableView:nil];
    [self setUserInfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [self.testScrollView release];
    [self.subTopicTableView release];
    [self.userInfo release];
    [super dealloc];
}

#pragma mark - Customize

// 点击任一button，会滚动到相应的button的位置
- (void)whenButtonTap:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)sender;
        NSLog(@"\nThe current button tag is:\n%d", btn.tag);
        [self.testScrollView setContentOffset:CGPointMake(((kButtonWidth) * btn.tag), 0) animated:YES];
        [self whenScrollDidStopWithButtonIndex:btn.tag];
    }
}

// 当scrollView停止滚动，tableView界面就要换成相应的数据
- (void)whenScrollDidStopWithButtonIndex:(NSInteger)index
{
    NSString *userInfoText = [self.userInfo objectForKey:[NSString stringWithFormat:@"%d", index]];
    UIButton *btn = (UIButton *)[self.testScrollView viewWithTag:index];
    NSString *btnText = nil;
    // 这里不加判断的话每次到button0的位置都会崩掉，加上判断就没有查原因
    if (index >= 1)
    {
        btnText = btn.titleLabel.text;
    }
    else
    {
        btnText = @"button0";
    }
    if ([userInfoText isEqualToString:btnText])
    {
        [self.subTopicTableView.dataArray removeAllObjects];
        for (int i = 0; i < 10; i++)
        {
            NSString *stringObject = [NSString stringWithFormat:@"Button%dRow%d", index, i];
            [self.subTopicTableView.dataArray addObject:stringObject];
        }
        [self.subTopicTableView.tableView reloadData];
    }
}

#pragma mark - ScrollView Delegate

// 因为将pagingEnable设为NO，没有了吸附感。这个方法应该实现让每个button都有吸附感
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float index = roundf(scrollView.contentOffset.x / kButtonWidth);
    NSLog(@"\nThe index is:\n%f\nthe mod is:\n", index);
    
    [scrollView setContentOffset:CGPointMake(((kButtonWidth) * index), 0) animated:YES];
    [self whenScrollDidStopWithButtonIndex:index];
}

@end

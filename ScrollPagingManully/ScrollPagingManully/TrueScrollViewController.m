//
//  TrueScrollViewController.m
//  ScrollPagingManully
//
//  Created by stone on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TrueScrollViewController.h"
#import "DummyScrollView.h"

@interface TrueScrollViewController ()

@end

@implementation TrueScrollViewController

@synthesize trueScrollView = _trueScrollView;
@synthesize dummy = _dummy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    // 构建好自己的view
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    // 功能扩展的view设置为红色
    self.dummy = [[[DummyScrollView alloc] initWithFrame:CGRectMake(0, ((viewHeight / 2) - 20), 320, 40)] autorelease];
    [self.dummy setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.1]];
    
    // 主要的ScrollView设置为黑色
    // 必须设置的参数为clipsToBounds，设置为NO，
    // 这样他才会将超出他Frame的控件显示出来
    CGRect trueScrollFrame = CGRectMake(((viewWidth / 2) - 45), 0, 90, 40);
    self.trueScrollView = [[[UIScrollView alloc] initWithFrame:trueScrollFrame] autorelease];
    [self.trueScrollView setDelegate:self];
    [self.trueScrollView setClipsToBounds:NO];
    [self.trueScrollView setPagingEnabled:YES];
    [self.trueScrollView setShowsHorizontalScrollIndicator:NO];
    [self.trueScrollView setBackgroundColor:[UIColor blackColor]];
    
    // 为了测试Button的响应设置的UILabel
    UILabel *label = [[[UILabel alloc] initWithFrame:self.trueScrollView.frame] autorelease];
    [label setCenter:CGPointMake(label.center.x, (label.center.y + 260))];
    [label setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.3f]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"Label"];
    
    // 没什么大不了，添加几个Button而已
    // 背景设置为灰色
    CGFloat contentOffset = 0.0f;
    for (int i = 0; i < 10; i++)
    {
        CGRect buttonFrame = CGRectMake(contentOffset, 0, 90, 40);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:buttonFrame];
        [button setUserInteractionEnabled:YES];
        [button addTarget:self action:@selector(whenButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:0.5f]];
        [button setTag:i];
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [self.trueScrollView addSubview:button];
        
        contentOffset += button.frame.size.width;
        [self.trueScrollView setContentSize:CGSizeMake(contentOffset, self.trueScrollView.frame.size.height)];
    }
    
    // 主要的ScrollView要添加到功能扩展的View中
    [self.dummy addSubview:self.trueScrollView];
    // 再将功能扩展的View，添加到本类的View
    [self.view addSubview:self.dummy];
    [self.view addSubview:label];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc
{
    [_trueScrollView release];
    [_dummy release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTrueScrollView:nil];
    [self setDummy:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Button Action
// 虽然滚动效果出来了，但是button不能响应动作事件，可惜！
- (void)whenButtonTapped:(UIButton *)sender
{
    for (UIView *label in self.view.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            UILabel *textLabel = (UILabel *)label;
            [textLabel setText:[NSString stringWithFormat:@"Button%d", sender.tag]];
        }
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 当减速动作完成的时候一定要开启吸附感选项
    [scrollView setPagingEnabled:YES];
    // 但即使开启了选项还是会出差错，所以算出Button的索引
    UIView *btn = [scrollView viewWithTag:4];
    CGFloat btnWidth = btn.frame.size.width;
    CGFloat btnIndex = roundf(scrollView.contentOffset.x / btnWidth);
    // 让ScrollView主动移动过去
    [scrollView setContentOffset:CGPointMake((btnIndex * btnWidth), 0) animated:YES];
    
//    NSLog(@"\nScrollView Center:%f\n\n\n", scrollView.center.x);
//    for (UIView *bt in scrollView.subviews)
//    {
//        NSLog(@"\nView tag:%d....View center%f\n", bt.tag, bt.center.x);
//    }
//    
//    NSLog(@"\n\n\nContentSize / btnWidth:%f\n\n", btnIndex);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 如果是在拖拽状态，一定要有吸附感
    if (scrollView.dragging && scrollView.tracking)
    {
        [scrollView setPagingEnabled:YES];
    }
    
    // 如果手已经离开了tracking就为假了，但这时dragging依然为真，所以不可以用吸附感
    if (!scrollView.tracking && scrollView.dragging)
    {
        [scrollView setPagingEnabled:NO];
    }
}

@end

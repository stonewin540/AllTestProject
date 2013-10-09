//
//  BGTViewController.m
//  BackgroundTest
//
//  Created by stone win on 6/4/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "BGTViewController.h"
#import "BGTAppDelegate.h"

@interface BGTViewController ()

@end

@implementation BGTViewController

- (void)buttonTapped:(UIButton *)sender
{
    // 是否影响手势的响应，关键就在window的backgroundColor上
    BGTAppDelegate *delegate = (BGTAppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.window.backgroundColor)
    {
        delegate.window.backgroundColor = nil;
    }
    else
    {
        delegate.window.backgroundColor = [UIColor whiteColor];
    }
}

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
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    CGRect frame = CGRectInset(self.view.bounds, 0, 40);
    frame.origin.y = 0;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.contentSize = CGSizeMake(frame.size.width*2, frame.size.height*2);
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < 2; i++)
    {
        frame.size = CGSizeMake(100, 100);
        frame.origin.x = i * (frame.size.width+20);
        frame.origin.y = 0;
        
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor greenColor];
        [scrollView addSubview:view];
    }
    
    frame.size = CGSizeMake(50, 30);
    frame.origin.x = (CGRectGetWidth(self.view.bounds)-frame.size.width) / 2;
    frame.origin.y = CGRectGetHeight(self.view.bounds) - frame.size.height;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"tap" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

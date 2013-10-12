//
//  CSMainViewController.m
//  ScrollMainViewTest
//
//  Created by 文 斯敦 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CSMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CSLeftView.h"
#import "CSRightView.h"

@interface CSMainViewController ()

{
    UIScrollView *_mainScrollView;
    UIView *_centerView;
    UIView *_leftView;
    UIView *_rightView;
    
    // Navigation part
    UIImageView *_naviBarImageView;
    UIButton *_leftButton;
    UIButton *_rightButton;
    
    // CenterView Body
    UIScrollView *_CVRootScrollView;
    
    // CenterView Header
    UIView *_CVHeaderView;
    UIScrollView *_CVHeaderScrollView;
    UIPageControl *_CVHeaderPageControl;
}

@end

@implementation CSMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_mainScrollView release];
    [_centerView release];
    [_leftView release];
    [_rightView release];
    
    // Navigation part
    [_naviBarImageView release];
    [_leftButton release];
    [_rightButton release];
    
    // CenterView Body
    [_CVRootScrollView release];
    
    // CenterView Header
    [_CVHeaderView release];
    [_CVHeaderScrollView release];
    [_CVHeaderPageControl release];
    [super dealloc];
}
- (void)viewDidUnload
{
    _mainScrollView = nil;
    _centerView = nil;
    _leftView = nil;
    _rightView = nil;
    
    // Navigation part
    if (_naviBarImageView) [_naviBarImageView release];
    _naviBarImageView = nil;
    if (_leftButton) [_leftButton release];
    _leftButton = nil;
    if (_rightButton) [_rightButton release];
    _rightButton = nil;
    
    // CenterView Body
    if (_CVRootScrollView) [_CVRootScrollView release];
    _CVRootScrollView = nil;
    
    // CenterView Header
    if (_CVHeaderView) [_CVHeaderView release];
    _CVHeaderView = nil;
    if (_CVHeaderScrollView) [_CVHeaderScrollView release];
    _CVHeaderScrollView = nil;
    if (_CVHeaderPageControl) [_CVHeaderPageControl release];
    _CVHeaderPageControl = nil;
    [super viewDidUnload];
}

- (void)loadView
{
    UIView *tmpView = [[UIView alloc] init];
    self.view = tmpView;
    [tmpView release];
    
    UIScrollView *tmpMainScroll = [[UIScrollView alloc] init];
    [tmpMainScroll setFrame:CGRectMake(0, 0, 320, 460)];
    [tmpMainScroll setBackgroundColor:[UIColor brownColor]];
    [tmpMainScroll setShowsHorizontalScrollIndicator:NO];
    [tmpMainScroll setPagingEnabled:YES];
    [tmpMainScroll setBounces:NO];
    [tmpMainScroll setScrollsToTop:NO];
    [self.view addSubview:tmpMainScroll];
    _mainScrollView = [tmpMainScroll retain];
    [tmpMainScroll release];
    
    UIView *tmpLeft = [[CSLeftView alloc] initWithFrame:CGRectMake(-260, 0, 260, 460)];
    //[tmpLeft setFrame:];
    [tmpLeft setBackgroundColor:[UIColor greenColor]];
    [_mainScrollView addSubview:tmpLeft];
    _leftView = [tmpLeft retain];
    [tmpLeft release];
    
    UIView *tmpRight = [[CSRightView alloc] initWithFrame:CGRectMake(320, 0, 260, 460)];
    //[tmpRight setFrame:];
    [tmpRight setBackgroundColor:[UIColor blueColor]];
    [_mainScrollView addSubview:tmpRight];
    _rightView = [tmpRight retain];
    [tmpRight release];
    
    UIView *tmpCenter = [[UIView alloc] init];
    [tmpCenter setFrame:CGRectMake(0, 0, 320, 460)];
    [tmpCenter setBackgroundColor:[UIColor cyanColor]];
    [_mainScrollView addSubview:tmpCenter];
    _centerView = [tmpCenter retain];
    [tmpCenter release];
    
    [_centerView.layer setShadowOpacity:100];
    [_centerView.layer setShadowOffset:CGSizeMake(0, 0)];
    
    [_mainScrollView setContentSize:CGSizeMake(320 + 260, 460)];
    [_mainScrollView setContentInset:UIEdgeInsetsMake(0, 260, 0, 0)];
    
    // Navigation part
    UIImageView *tmpNaviBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topBarBackgroundWithShadow.png"]];
    [tmpNaviBar setFrame:CGRectMake(0, 0, 320, 48)];
    [_mainScrollView addSubview:tmpNaviBar];
    _naviBarImageView = [tmpNaviBar retain];
    [tmpNaviBar release];
    
    UIButton *tmpLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpLeftBtn setImage:[UIImage imageNamed:@"modeList.png"] 
                forState:UIControlStateNormal];
    [tmpLeftBtn setFrame:CGRectMake(0, 0, 64, 42)];
    [tmpLeftBtn addTarget:self 
                   action:@selector(whenLeftButtonTapped:) 
         forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:tmpLeftBtn];
    _leftButton = [tmpLeftBtn retain];
    
    UIButton *tRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tRBtn setImage:[UIImage imageNamed:@"modeImages_topic.png"] 
           forState:UIControlStateNormal];
    [tRBtn setFrame:CGRectMake(256, 0, 64, 42)];
    [tRBtn addTarget:self 
              action:@selector(whenRightButtonTapped:) 
    forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:tRBtn];
    _rightButton = [tRBtn retain];
    
    UIScrollView *tCVRootScroll = [[UIScrollView alloc] init];
    [tCVRootScroll setFrame:CGRectMake(0, 43, 320, 460 - 43)];
    [tCVRootScroll setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [tCVRootScroll setScrollsToTop:YES];
    [_centerView insertSubview:tCVRootScroll belowSubview:_naviBarImageView];
    _CVRootScrollView = [tCVRootScroll retain];
    [tCVRootScroll release];
    
    // CenterView Header
    UIView *tCVHeader = [[UIView alloc] init];
    [tCVHeader setFrame:CGRectMake(0, 0, 320, 180)];
    [tCVHeader setBackgroundColor:[UIColor lightGrayColor]];
    [_CVRootScrollView addSubview:tCVHeader];
    _CVHeaderView = [tCVHeader retain];
    [tCVHeader release];
    
    UIScrollView *tCVScroll = [[UIScrollView alloc] init];
    [tCVScroll setFrame:_CVHeaderView.bounds];
    [tCVScroll setBackgroundColor:[UIColor brownColor]];
    [tCVScroll setShowsHorizontalScrollIndicator:NO];
    [tCVScroll setShowsVerticalScrollIndicator:NO];
    [tCVScroll setPagingEnabled:YES];
    [tCVScroll setScrollsToTop:NO];
    [_CVHeaderView addSubview:tCVScroll];
    _CVHeaderScrollView = [tCVScroll retain];
    [tCVScroll release];
    
    UIPageControl *tCVPageControl = [[UIPageControl alloc] init];
    [tCVPageControl setFrame:CGRectMake(0, CGRectGetHeight(_CVHeaderScrollView.bounds) - 15, 320, 15)];
    [tCVPageControl setBackgroundColor:[UIColor colorWithRed:0 
                                                       green:0 
                                                        blue:0 
                                                       alpha:0.7]];
    [tCVPageControl setNumberOfPages:9];
    [tCVPageControl setCurrentPage:0];
    [_CVHeaderView addSubview:tCVPageControl];
    _CVHeaderPageControl = [tCVPageControl retain];
    [tCVPageControl release];
    
    CGSize contentSize = CGSizeMake(320, 180 * 6);
    [_CVRootScrollView setContentSize:contentSize];
    for (int i = 1; i <= 5; i++)
    {
        UIView *tView = [[UIView alloc] init];
        [tView setFrame:CGRectMake(0, (180 * i), 320, 180)];
        [tView setBackgroundColor:[UIColor colorWithRed:((arc4random() % 255) / 255.f) 
                                                  green:((arc4random() % 255) / 255.f) 
                                                   blue:((arc4random() % 255) / 255.f) 
                                                  alpha:1]];
        [_CVRootScrollView addSubview:tView];
        [tView release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self displayCenterHeaderScroll];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Initialize Display
- (void)displayCenterHeaderScroll
{
    NSBundle *tMainBundle = [NSBundle mainBundle];
    CGSize contentSize = CGSizeMake(0, CGRectGetHeight(_CVHeaderScrollView.bounds));
    for (int i = 1; i <= 9; i++)
    {
        NSString *tName = [NSString stringWithFormat:@"header%d", i];
        NSString *tPath = [tMainBundle pathForResource:tName ofType:@"png"];
        NSData *tData = [[NSData alloc] initWithContentsOfMappedFile:tPath];
        UIImage *tImg = [[UIImage alloc] initWithData:tData];
        UIImageView *tContentView = [[UIImageView alloc] initWithImage:tImg];
        [tContentView setFrame:CGRectMake((320 * (i - 1)), 0, CGRectGetWidth(_CVHeaderScrollView.bounds), CGRectGetHeight(_CVHeaderScrollView.bounds))];
        [_CVHeaderScrollView addSubview:tContentView];
        contentSize.width += CGRectGetWidth(tContentView.bounds);
        [tData release];
        [tImg release];
        [tContentView release];
    }
    [_CVHeaderScrollView setContentSize:contentSize];
}

#pragma mark - Actions
- (void)whenLeftButtonTapped:(UIButton *)sender
{
    [_mainScrollView setContentOffset:CGPointMake(-260, 0) animated:YES];
}

- (void)whenRightButtonTapped:(UIButton *)sender
{
    [_mainScrollView setContentOffset:CGPointMake(260, 0) animated:YES];
}

@end

//
//  ToolBarViewController.m
//  RandomColorTest
//
//  Created by 文 斯敦 on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ToolBarViewController.h"
#import "QuartzFunView.h"

@interface ToolBarViewController ()

@property (nonatomic, retain) UIToolbar *topToolbar;
@property (nonatomic, retain) UIToolbar *bottomToolbar;
@property (nonatomic, retain) UISegmentedControl *topSegment;
@property (nonatomic, retain) UISegmentedControl *bottomSegment;
@property (nonatomic, retain) QuartzFunView *quartzFunView;

- (void)whenTopSegmentTapped:(UISegmentedControl *)sender;
- (void)whenBottomSegmentTapped:(UISegmentedControl *)sender;

@end

@implementation ToolBarViewController

@synthesize topToolbar = _topToolbar;
@synthesize bottomToolbar = _bottomToolbar;
@synthesize topSegment = _topSegment;
@synthesize bottomSegment = _bottomSegment;
@synthesize quartzFunView = _quartzFunView;

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
    [_topToolbar release];
    [_bottomToolbar release];
    [_topSegment release];
    [_bottomSegment release];
    [_quartzFunView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Random", nil]];
    self.bottomSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Line", @"Rect", @"Ellipse", @"Image", nil]];
    [_topSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_bottomSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_topSegment addTarget:self action:@selector(whenTopSegmentTapped:) forControlEvents:UIControlEventValueChanged];
    [_bottomSegment addTarget:self action:@selector(whenBottomSegmentTapped:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *tmpTopButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.topSegment];
    UIBarButtonItem *tmpBottomButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.bottomSegment];
    [tmpTopButtonItem setStyle:UIBarButtonItemStyleBordered];
    [tmpTopButtonItem setWidth:(self.view.bounds.size.width - 12.f)];
    [tmpBottomButtonItem setStyle:UIBarButtonItemStyleBordered];
    [tmpBottomButtonItem setWidth:tmpTopButtonItem.width];
    
    self.topToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 44.f)];
    self.bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, (480.f - 20.f - 44.f), self.view.bounds.size.width, 44.f)];
    [_topToolbar setBarStyle:UIBarStyleDefault];
    [_topToolbar setItems:[NSArray arrayWithObject:tmpTopButtonItem]];
    [_bottomToolbar setBarStyle:UIBarStyleDefault];
    [_bottomToolbar setItems:[NSArray arrayWithObject:tmpBottomButtonItem]];
    
    self.quartzFunView = [[QuartzFunView alloc] initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, (480.f - 20.f - 44.f - 44.f))];
    
    [self.view addSubview:self.topToolbar];
    [self.view addSubview:self.bottomToolbar];
    [self.view addSubview:self.quartzFunView];
    
    [self.topSegment release];
    [self.bottomSegment release];
    [tmpTopButtonItem release];
    [tmpBottomButtonItem release];
    [self.topToolbar release];
    [self.bottomToolbar release];
}

- (void)viewDidUnload
{
    [self setTopToolbar:nil];
    [self setBottomToolbar:nil];
    [self setTopSegment:nil];
    [self setBottomSegment:nil];
    [self setQuartzFunView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - SegmentedControl Actions

- (void)whenTopSegmentTapped:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case kRedColorTab:
            break;
        case kGreenColorTab:
            break;
        case kBlueColorTab:
            break;
        case kYellowColorTab:
            break;
    }
}

- (void)whenBottomSegmentTapped:(UISegmentedControl *)sender
{
    NSLog(@"whenButtomSegmentTapped: index:%d", sender.selectedSegmentIndex);
}

@end

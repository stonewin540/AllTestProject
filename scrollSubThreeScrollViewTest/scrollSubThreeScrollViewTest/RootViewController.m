//
//  RootViewController.m
//  scrollSubThreeScrollViewTest
//
//  Created by 斯敦  文 on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "SecondViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"RootViewTabBar"];
        [self.navigationItem setTitle:@"RootViewNavigationItem"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    [super loadView];
    
    NSZone *colorZone = NSDefaultMallocZone();
    NSZoneMalloc(colorZone, 1);
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 480.f)];
    UIColor *viewBackgroundColor = [[UIColor allocWithZone:colorZone] initWithRed:0.5f green:0.f blue:0.5f alpha:1.f];
    self.view = tmpView;
    [self.view setBackgroundColor:viewBackgroundColor];
    [tmpView release];
    [viewBackgroundColor release];
    NSZoneFree(colorZone, NULL);
    
    CGFloat scrollHeight = 480.f - 20.f - 44.f - 49.f;
    CGFloat screenWith = 320.f;
    UIFont *textFont = [UIFont systemFontOfSize:45.f];
    CGSize textSize = [@"aButton" sizeWithFont:textFont];
    CGRect buttonFrame = CGRectMake(((screenWith - textSize.width) / 2.f), ((scrollHeight - textSize.height) / 2.f), (textSize.width + 20.f), textSize.height);
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setFrame:buttonFrame];
    [aButton setTitle:@"aButton" forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(whenButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aButton.titleLabel setFont:textFont];
    [aButton.titleLabel setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:aButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Button action
- (void)whenButtonTapped:(UIButton *)sender
{
    SecondViewController *secondViewController = [[SecondViewController alloc] initWithNibName:nil bundle:nil];
    [secondViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:secondViewController animated:YES];
    [secondViewController release];
}

@end

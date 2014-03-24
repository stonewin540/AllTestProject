//
//  SRTViewController.m
//  SimpleReuseTest
//
//  Created by stone win on 3/21/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import "SRTViewController.h"
#import "SRTScrollSelector.h"

@interface SRTViewController ()

@end

@implementation SRTViewController

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
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    SRTScrollSelector *selector = [[SRTScrollSelector alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), 40)];
    selector.backgroundColor = [UIColor redColor];
    selector.titles = @[@"title0", @"title1", @"title2", @"title3", @"title4", @"title5", @"title6", @"title7", @"title8", @"title9", @"title10"];
    [self.view addSubview:selector];
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

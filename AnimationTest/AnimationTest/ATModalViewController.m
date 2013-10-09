//
//  ATModalViewController.m
//  AnimationTest
//
//  Created by stone win on 1/30/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "ATModalViewController.h"

@interface ATModalViewController ()

@end

@implementation ATModalViewController
{
    
}

#pragma mark - Actions

- (void)dismissButtonTapped:(UIBarButtonItem *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Lifecycle

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
    self.view = [[UIView alloc] init];
    
    // Dismiss button
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(dismissButtonTapped:)];
    self.navigationItem.leftBarButtonItem = item;
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

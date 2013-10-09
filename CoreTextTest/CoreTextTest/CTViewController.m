//
//  CTViewController.m
//  CoreTextTest
//
//  Created by stone win on 1/5/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "CTViewController.h"
#import "CTView.h"

#define CHECK   printf("%s\n", __PRETTY_FUNCTION__)

@interface CTViewController ()

@end

@implementation CTViewController

#pragma mark - Actions

- (void)nextButtonTapped:(UIBarButtonItem *)sender
{
    UIViewController *controller = [[UIViewController alloc] init];
    [self.navigationController pushViewController:controller
                                         animated:YES];
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
    CTView *view = [[CTView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.opaque = YES;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"next"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(nextButtonTapped:)];
    self.navigationItem.rightBarButtonItem = next;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//
//  ViewController.m
//  AutoLayout
//
//  Created by cai xuejun on 12-9-24.
//  Copyright (c) 2012年 caixuejun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor redColor];
    [aView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:aView];
    
    UIView *bView = [[UIView alloc] init];
    bView.backgroundColor = [UIColor blueColor];
    [bView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:bView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(aView, bView);
    
    [self.view addConstraints:
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=50)-[aView(100)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=50)-[aView(50)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
   
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[bView(==aView)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bView(==aView)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bView]-(>=50)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=50)-[bView]" options:0 metrics:nil views:views]];
//    [self.view addConstraint:
//     [NSLayoutConstraint constraintWithItem:bView
//                                  attribute:NSLayoutAttributeLeft
//                                  relatedBy:NSLayoutRelationEqual
//                                     toItem:aView
//                                  attribute:NSLayoutAttributeRight
//                                 multiplier:1
//                                   constant:10]];
//    
//    [self.view addConstraint:
//     [NSLayoutConstraint constraintWithItem:bView
//                                  attribute:NSLayoutAttributeTop
//                                  relatedBy:NSLayoutRelationEqual
//                                     toItem:aView
//                                  attribute:NSLayoutAttributeTop
//                                 multiplier:1
//                                   constant:0]];
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor magentaColor];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:view];
    
    views = NSDictionaryOfVariableBindings(view);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H|-[view]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=150)-[view]-|" options:0 metrics:nil views:views]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

//- (UIViewController *)childViewControllerForStatusBarStyle
//{
//    return self;
//}

@end

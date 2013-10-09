//
//  ATViewController.m
//  AnimationTest
//
//  Created by stone win on 1/22/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ATViewController.h"
#import "ATModalViewController.h"

@interface ATViewController ()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *modalView;

@end

@implementation ATViewController
{
    CGRect _frame;
}

#pragma mark - Actions

- (void)dismissButtonTapped:(UIBarButtonItem *)sender
{
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -.0025f;
    transform = CATransform3DRotate(transform, M_PI / 32, 1, 0, 0);
    
    CATransform3D toTransform = CATransform3DTranslate(transform, 0, 50, 0);
    
    CABasicAnimation *translation = [CABasicAnimation animation];
    translation.keyPath = @"transform";
    translation.removedOnCompletion = NO;
    translation.fillMode = kCAFillModeForwards;
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.toValue = [NSValue valueWithCATransform3D:toTransform];
    translation.duration = .6;
//    translation.beginTime = .35;
    
    CABasicAnimation *rotate = [CABasicAnimation animation];
    rotate.keyPath = @"transform";
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rotate.duration = .4;
    rotate.beginTime = .3;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[ translation, rotate ];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = 2;
    
    [self.view.layer addAnimation:group
                           forKey:nil];
     
}

- (void)presentButtonTapped:(UIBarButtonItem *)sender
{
    ATModalViewController *modalController = [[ATModalViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:modalController];
    navigationController.navigationBarHidden = NO;
    [self presentModalViewController:navigationController
                            animated:YES];
    
    
    CGPoint point = self.view.layer.anchorPoint;
    point.y = 1;
    self.view.layer.anchorPoint = point;
    point = self.view.layer.position;
    point.y = 416;
    self.view.layer.position = point;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -.0025f;
    transform = CATransform3DRotate(transform, M_PI / 32, 1, 0, 0);
    
    CABasicAnimation *rotate = [CABasicAnimation animation];
    rotate.keyPath = @"transform";
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotate.toValue = [NSValue valueWithCATransform3D:transform];
    rotate.duration = .6;
    
    CATransform3D toTransform = CATransform3DTranslate(transform, 0, -50, 0);
    
    CABasicAnimation *translation = [CABasicAnimation animation];
    translation.keyPath = @"transform";
    translation.removedOnCompletion = NO;
    translation.fillMode = kCAFillModeForwards;
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.toValue = [NSValue valueWithCATransform3D:toTransform];
    translation.duration = .3;
    translation.beginTime = .35;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[ rotate, translation ];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = 2;
    
    [self.view.layer addAnimation:group
                           forKey:nil];
     
}

- (void)viewSwiped:(UISwipeGestureRecognizer *)sender
{
    if (_centerView.frame.origin.x >= 250)
    {
        [UIView animateWithDuration:.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             CGRect frame = _centerView.frame;
                             frame.origin.x = 0;
                             _centerView.frame = frame;
                             
                         } completion:^(BOOL finished) {
                             
                             if (finished)
                             {
                                 
                             }
                             
                         }];
    }
    else
    {
        [UIView animateWithDuration:.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             CGRect frame = _centerView.frame;
                             frame.origin.x = 250;
                             _centerView.frame = frame;
                             
                         } completion:^(BOOL finished) {
                             
                             if (finished)
                             {
                                 
                             }
                             
                         }];
    }
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
    
    // Left view
    _frame = CGRectMake(0, 0, 250, 416);
    
    _leftView = [[UIView alloc] initWithFrame:_frame];
    _leftView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_leftView];
    
    // Center view
    _frame = CGRectMake(0, 0, 320, 416);
    
    _centerView = [[UIView alloc] initWithFrame:_frame];
    _centerView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_centerView];
    
    // Shadow
    CGPathRef path = CGPathCreateWithRect(_centerView.bounds, NULL);
    _centerView.layer.shadowOffset = CGSizeMake(-1, 0);
    _centerView.layer.shadowOpacity = 10;
    _centerView.layer.shadowPath = path;
    CGPathRelease(path);
    
    // Present button
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Present"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(presentButtonTapped:)];
    self.navigationItem.rightBarButtonItem = item;
    
    // Dismiss button
    item = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss"
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(dismissButtonTapped:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] init];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [swipe addTarget:self
              action:@selector(viewSwiped:)];
    [_centerView addGestureRecognizer:swipe];
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

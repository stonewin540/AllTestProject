//
//  TTRootViewController.m
//  Transform3DTest
//
//  Created by 文 斯敦 on 12-8-21.
//  Copyright (c) 2012年 cutt. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

#import "TTRootViewController.h"

#define BUTTON_WIDTH 320 / 3
#define BUTTON_HEIGHT 40

@interface TTRootViewController ()

{
    UIView *_headerView;
    CALayer *_aLayer;
}

@end

@implementation TTRootViewController

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
    UIView *aView = [[UIView alloc] init];
    [aView setBackgroundColor:[UIColor clearColor]];
    [self setView:aView];
    [aView release];
    
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    [headerView setBackgroundColor:[UIColor colorWithRed:0
                                                   green:0
                                                    blue:0
                                                   alpha:0.5f]];
    [self.view addSubview:headerView];
    _headerView = [headerView retain];
    [headerView release];
    
    UIView *dont1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [dont1 setBackgroundColor:[UIColor redColor]];
    [_headerView addSubview:dont1];
    [dont1 release];
    
    UIView *dont2 = [[UIView alloc] initWithFrame:CGRectMake(320 - 10, 0, 10, 10)];
    [dont2 setBackgroundColor:[UIColor greenColor]];
    [_headerView addSubview:dont2];
    [dont2 release];
    
    UIView *dont3 = [[UIView alloc] initWithFrame:CGRectMake(320 - 10, 240 - 10, 10, 10)];
    [dont3 setBackgroundColor:[UIColor blueColor]];
    [_headerView addSubview:dont3];
    [dont3 release];
    
    UIView *dont4 = [[UIView alloc] initWithFrame:CGRectMake(0, 240 - 10, 10, 10)];
    [dont4 setBackgroundColor:[UIColor blackColor]];
    [_headerView addSubview:dont4];
    [dont4 release];
    
    
    
    
    CALayer *aLayer = [CALayer layer];
    [aLayer setBounds:CGRectMake(0, 0, 100, 100)];
    [aLayer setPosition:CGPointMake(320 / 2, 240 + 30)];
    [aLayer setBackgroundColor:[UIColor whiteColor].CGColor];
    [aLayer setBorderColor:[UIColor redColor].CGColor];
    [aLayer setBorderWidth:3];
    [self.view.layer addSublayer:aLayer];
    _aLayer = [aLayer retain];
    [aLayer release];
    
    
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(0, 460 - BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [button1 setTitle:@"button1"
             forState:UIControlStateNormal];
    [button1 addTarget:self
                action:@selector(whenButton1Tapped:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake(1 + BUTTON_WIDTH, 460 - BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [button2 setTitle:@"button2"
             forState:UIControlStateNormal];
    [button2 addTarget:self
                action:@selector(whenButton2Tapped:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setFrame:CGRectMake(1 + (2 * BUTTON_WIDTH), 460 - BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [button3 setTitle:@"reset"
             forState:UIControlStateNormal];
    [button3 addTarget:self
                action:@selector(whenButton3Tapped:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)dealloc
{
    [_headerView release];
    [_aLayer release];
    [super dealloc];
}

- (void)setViewNil:(id)aView
{
    if (aView) [aView release];
    aView = nil;
}
- (void)viewDidUnload
{
    [self setViewNil:_headerView];
    [self setViewNil:_aLayer];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions
- (void)whenButton1Tapped:(UIButton *)sender
{
    //CHECKIN;
    //CATransform3D transform = CATransform3DMakeTranslation(20, 20, 0);
    //CATransform3D transform = CATransform3DMakeScale(0.9f, 0.9f, 0);
    
    //CATransform3D transform = CATransform3DMakeRotation(30 * (M_PI / 180), 0, 0, 1);
    //[_headerView.layer setTransform:transform];
    
    //NSNumber *aValue = [NSNumber numberWithInt:20];
    //[_headerView.layer setValue:aValue
    //                 forKeyPath:@"transform.translation.x"];
    //[_headerView.layer setValue:aValue
    //                 forKeyPath:@"transform.translation.y"];
    
    
    
//    for (CALayer *layer in self.view.layer.sublayers)
//    {
//        if (layer.name) [layer removeFromSuperlayer];
//    }
//    [_headerView setAlpha:0];
//    CALayer *aLayer = [CALayer layer];
//    [aLayer setName:@"aLayer"];
//    [aLayer setFrame:_headerView.frame];
//    [aLayer setBackgroundColor:[UIColor purpleColor].CGColor];
//    [self.view.layer addSublayer:aLayer];
//    for (CALayer *layer in self.view.layer.sublayers)
//    {
//        NSLog(@"sublayers: %@", layer.name);
//    }
    
    
    
//    _headerView.layer.position = CGPointMake(20, 20);
//    _headerView.layer.opacity = 0.2f;
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.duration = 3;
//    animation.repeatCount = 0;
//    animation.autoreverses = YES;
//    animation.fromValue = [NSNumber numberWithInt:1];
//    animation.toValue = [NSNumber numberWithInt:0];
//    [_headerView.layer addAnimation:animation forKey:@"animateOpacity"];
    
    
    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:2];
//    _aLayer.cornerRadius = (0 == _aLayer.cornerRadius)? 10: 0;
//    _aLayer.opacity = (1 == _aLayer.opacity)? 0.5f: 1;
//    /*
//     * 添加的layer就好用，有动画效果，view自己的layer就没有
//     _headerView.layer.cornerRadius = (0 == _headerView.layer.cornerRadius)? 10: 0;
//     _headerView.layer.opacity = (1 == _headerView.layer.opacity)? 0.5f: 1;
//     */
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:3];
//    CGPoint aPosition = _aLayer.position;
//    aPosition.x = 0 == aPosition.x? 320 / 2: 0;
//    _aLayer.position = aPosition;
//    [CATransaction commit];
//    [CATransaction commit];
    
    
    
}

- (void)whenButton2Tapped:(UIButton *)sender
{
    //CHECKIN;
    //CATransform3D transform = CATransform3DTranslate(_headerView.layer.transform, 20, 20, 0);
    //CATransform3D transform = CATransform3DScale(_headerView.layer.transform, 0.9f, 0.9f, 0);
    
    //CATransform3D transform = CATransform3DRotate(_headerView.layer.transform, 30 * (M_PI / 180), 0, 0, 1);
    //CATransform3D transform =  CATransform3DInvert(_headerView.layer.transform);
    //[_headerView.layer setTransform:transform];
    
    //NSNumber *xValue = [_headerView.layer valueForKeyPath:@"transform.translation.x"];
    //NSNumber *yValue = [_headerView.layer valueForKeyPath:@"transform.translation.y"];
    //NSNumber *aValue = [NSNumber numberWithFloat:20 + [xValue floatValue]];
    //NSNumber *bValue = [NSNumber numberWithFloat:20 + [yValue floatValue]];
    //[_headerView.layer setValue:aValue
    //                 forKeyPath:@"transform.translation.x"];
    //[_headerView.layer setValue:bValue
    //                 forKeyPath:@"transform.translation.y"];
    
    
    
//    NSArray *sublayers = [self.view.layer sublayers];
//    for (CALayer *layer in sublayers)
//    {
//        if ([@"aLayer" isEqualToString:layer.name])
//        {
//            CALayer *bLayer = [CALayer layer];
//            [bLayer setName:@"bLayer"];
//            [bLayer setFrame:_headerView.frame];
//            [bLayer setBackgroundColor:[UIColor brownColor].CGColor];
//            [self.view.layer replaceSublayer:layer with:bLayer];
//            break;
//        }
//    }
//    for (CALayer *layer in self.view.layer.sublayers)
//    {
//        NSLog(@"sublayers: %@", layer.name);
//    }
    
    
    
//    [_headerView.layer removeAnimationForKey:@"animateOpacity"];
}

- (void)whenButton3Tapped:(UIButton *)sender
{
    //CHECKIN;
    //[_headerView.layer setTransform:CATransform3DIdentity];
    
    
    
//    [_headerView setAlpha:1];
//    for (CALayer *layer in self.view.layer.sublayers)
//    {
//        if (layer.name) [layer removeFromSuperlayer];
//    }
//    for (CALayer *layer in self.view.layer.sublayers)
//    {
//        NSLog(@"sublayers: %@", layer.name);
//    }
    
    
    
//    [_headerView.layer setPosition:CGPointMake(320 / 2, 240 / 2)];
//    [_headerView.layer setOpacity:1];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer
                        forKey:(NSString *)event
{
    CATransition *animation = nil;
    
    
    
    return animation;
}

@end

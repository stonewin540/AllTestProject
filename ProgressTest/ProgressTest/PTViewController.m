//
//  PTViewController.m
//  ProgressTest
//
//  Created by stone win on 10/8/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "PTViewController.h"
#import "PTView.h"

@interface PTViewController ()

@property (nonatomic, strong) PTView *progressView;

@end

@implementation PTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)buttonTapped:(UIButton *)button
{
    switch (button.tag)
    {
        case 1:
            _progressView.promptLabel.text = @"发布失败";
            _progressView.failureImage = [UIImage imageNamed:@"background_deliver_failure.png"];
            _progressView.state = TransmissionStateFailure;
            break;
        case 2:
            _progressView.speed = 50;
            _progressView.promptLabel.text = @"正在发布…";
            _progressView.uploadingImage = [UIImage imageNamed:@"background_deliver_uploading.png"];
            _progressView.state = TransmissionStateUploading;
            break;
        default:
            _progressView.promptLabel.text = @"发布成功";
            _progressView.succeedImage = [UIImage imageNamed:@"background_deliver_succeed.png"];
            _progressView.state = TransmissionStateSucceed;
            break;
    }
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    CGRect frame;
    frame.origin = CGPointMake(0, 20);
    frame.size = CGSizeMake(CGRectGetWidth(self.view.frame), 100);
    _progressView = [[PTView alloc] initWithFrame:frame];
    [self.view addSubview:_progressView];
    
    frame.size = CGSizeMake(50, 20);
    frame.origin.y = CGRectGetHeight(self.view.frame) - 20 - frame.size.height;
    
    for (int i=0; i<3; i++)
    {
        frame.origin.x = i * frame.size.width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = frame;
        button.tag = i;
        [button setTitle:[NSString stringWithFormat:@"tap%d", i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [_progressView start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

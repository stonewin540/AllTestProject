//
//  ViewController.m
//  GIFTest
//
//  Created by stone on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize testImageView, imageArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 得到一个装满UIImage的数组
    self.imageArray = [self buildImageArray];
    
    
    CGRect imageViewRect = CGRectMake(0, 0, 300, 300);
    self.testImageView = [[[UIImageView alloc] initWithFrame:imageViewRect] autorelease];
    [testImageView setCenter:self.view.center];
    [testImageView setBackgroundColor:[UIColor blackColor]];
    // 将数组赋给UIImageView的动画图片数组
    [testImageView setAnimationImages:self.imageArray];
    [testImageView setAnimationDuration:2.];
    // 设置图片在UIImageView中显示的位置，是否填满ImageView
    [testImageView setContentMode:UIViewContentModeScaleAspectFit];
    [testImageView startAnimating];
    
    [self.view addSubview:self.testImageView];
    
    // 间隔5秒以后，将动画停止
    [self stopAnimationInTime:100.0];
}

- (void)viewDidUnload
{
    [self setTestImageView:nil];
    [self setImageArray:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [testImageView release];
    [imageArray release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Customize

- (NSArray *)buildImageArray
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++)
    {
        NSMutableString *tempString = [NSMutableString stringWithString:@"images"];
        if (i >= 1)
        {
            tempString = nil;
            tempString = [NSMutableString stringWithFormat:@"images-%d", i];
        }
        
        UIImage *image = [UIImage imageNamed:[tempString stringByAppendingString:@".jpeg"]];
        [tempArray addObject:image];
    }
    
    return tempArray;
}

- (void)stopAnimationInTime:(NSTimeInterval)timeInterval
{
    [self.testImageView performSelector:@selector(stopAnimating) withObject:nil afterDelay:timeInterval];
}

@end

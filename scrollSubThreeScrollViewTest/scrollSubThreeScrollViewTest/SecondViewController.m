//
//  SecondViewController.m
//  scrollSubThreeScrollViewTest
//
//  Created by 斯敦  文 on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize mainScrollView00 = _mainScrollView00;
@synthesize mainScrollView01 = _mainScrollView01;
@synthesize mainScrollView02 = _mainScrollView02;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    UIColor *viewBackgroundColor = [[UIColor allocWithZone:colorZone] initWithRed:0.5f green:0.f blue:0.5f alpha:1.f];
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 480.f)];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                       style:UIBarButtonItemStylePlain 
                                                                      target:self 
                                                                      action:@selector(whenBackButtonTapped:)];
    self.view = tmpView;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [self.view setBackgroundColor:viewBackgroundColor];
    [tmpView release];
    [backButtonItem release];
    [viewBackgroundColor release];
    
    UIScrollView *tmpMainScrollView00 = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIScrollView *tmpMainScrollView01 = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIScrollView *tmpMainScrollView02 = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.mainScrollView00 = tmpMainScrollView00;
    self.mainScrollView01 = tmpMainScrollView01;
    self.mainScrollView02 = tmpMainScrollView02;
    [tmpMainScrollView00 release];
    [tmpMainScrollView01 release];
    [tmpMainScrollView02 release];
    
    for (int i = 0; i < 3; i++)
    {
        int scrollViewTag = i + 6;
        CGFloat contentSizeHeight = 0.f;
        CGFloat scrollHeight = 480.f - 20.f - 44.f - 49.f;
        CGFloat screenWith = 320.f;
        UIFont *textSizeFont = [UIFont systemFontOfSize:150.f];
        UIColor *scrollBackgroundColor = [[UIColor allocWithZone:nil] initWithWhite:1.f alpha:0.5f];
        NSString *mainScrollViewName = [NSString stringWithFormat:@"mainScrollView0%d", i];
        UIScrollView *mainScrollView = [self valueForKey:mainScrollViewName];
        
        for (int j = 0; j < 3; j++)
        {
            char tmpChar = ('A' + i);
            NSString *tmpTextString = [[NSString alloc] initWithCString:&tmpChar encoding:NSUTF8StringEncoding];
            CGSize textWillBeSize = [tmpTextString sizeWithFont:textSizeFont];
            CGRect labelFrame = CGRectMake(((screenWith - textWillBeSize.width) / 2.f), ((j * scrollHeight) + ((fabsf(scrollHeight - textWillBeSize.height) / 2))), textWillBeSize.width, textWillBeSize.height);
            UIColor *labelBackgroundColor = [[UIColor allocWithZone:colorZone] initWithRed:0.f green:1.f blue:0.f alpha:0.5f];
            UILabel *contentLabel = [[UILabel alloc] init];
            [contentLabel setFrame:labelFrame];
            [contentLabel setFont:textSizeFont];
            [contentLabel setText:tmpTextString];
            [contentLabel setTextAlignment:UITextAlignmentCenter];
            [contentLabel setBackgroundColor:labelBackgroundColor];
            [mainScrollView addSubview:contentLabel];
            [tmpTextString release];
            [labelBackgroundColor release];
            [contentLabel release];
            contentSizeHeight += scrollHeight;
        }
        
        [mainScrollView setBackgroundColor:scrollBackgroundColor];
        [mainScrollView setFrame:CGRectMake((i * screenWith), 0.f, 320.f, scrollHeight)];
        [mainScrollView setContentSize:CGSizeMake(320.f, contentSizeHeight)];
        [mainScrollView setScrollsToTop:YES];
        [mainScrollView setAlpha:0.f];
        [mainScrollView setTag:scrollViewTag];
        recycleScrollViewTags[i] = scrollViewTag;
        recycleScrollViewAlpha[i] = 0;
        [self.view addSubview:mainScrollView];
        [scrollBackgroundColor release];
        NSZoneFree(colorZone, NULL);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int length = sizeof(recycleScrollViewAlpha) / sizeof(int);
    for (int i = 0; i < length; i++)
	{
        if (0 == recycleScrollViewTags[i] % 3)
        {
            UIScrollView *tmpMainScrollView = (UIScrollView *)[self.view viewWithTag:recycleScrollViewTags[i]];
            recycleScrollViewAlpha[i] = 1;
            [tmpMainScrollView setAlpha:(CGFloat)recycleScrollViewAlpha[i]];
            break;
        }
    }
    
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(whenSwipeLeft:)];
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(whenSwipeRight:)];
    [leftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [rightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:leftGesture];
    [self.view addGestureRecognizer:rightGesture];
    [leftGesture release];
    [rightGesture release];
}

- (void)viewDidUnload
{
    [self setMainScrollView00:nil];
    [self setMainScrollView01:nil];
    [self setMainScrollView02:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    NSZone *dataZone = NSCreateZone(160, 320, YES);
    NSZoneMalloc(dataZone, 160);
    NSSetZoneName(dataZone, @"DATA");
    NSLog(@"We get a %@ zone with function.", NULL == dataZone? @"NULL": NSZoneName(dataZone));
    NSZoneFree(dataZone, NULL);
    NSRecycleZone(dataZone);
    NSLog(@"We get a %@ zone with function.", NULL == dataZone? @"NULL": NSZoneName(dataZone));
    
    [_mainScrollView00 release];
    [_mainScrollView01 release];
    [_mainScrollView02 release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Gesture actions
- (void)whenSwipeLeft:(UIGestureRecognizer *)sender
{
    int length = sizeof(recycleScrollViewAlpha) / sizeof(int);
    for (int i = 0; i < length; i++)
    {
        if (1 == recycleScrollViewAlpha[i])
        {
            /*
            printf("[0 == i? 2: (i - 1 >= 0? i - 1: 0)]: %d\n"
                   "[2 == i? 0: (i + 1 < 3? i + 1: 2)]: %d\n", 
                   0 == i? 2: (i - 1 >= 0? i - 1: 0), 2 == i? 0: (i + 1 < 3? i + 1: 2));
             */
            int currentIndex = i;
            int nextIndex = 2 == i? 0: (i + 1 < 3? i + 1: 2);
            int preIndex = 0 == i? 2: (i - 1 >= 0? i - 1: 0);
            recycleScrollViewAlpha[currentIndex] = 0;
            recycleScrollViewAlpha[nextIndex] = 1;
            recycleScrollViewAlpha[preIndex] = 0;
            UIScrollView *currentScrollView = nil;
            UIScrollView *preScrollView = nil;
            UIScrollView *nextScrollView = nil;
            preScrollView = (UIScrollView *)[self.view viewWithTag:recycleScrollViewTags[preIndex]];
            currentScrollView = (UIScrollView *)[self.view viewWithTag:recycleScrollViewTags[currentIndex]];
            nextScrollView = (UIScrollView *)[self.view viewWithTag:recycleScrollViewTags[nextIndex]];
            
            CGRect currentFrame = currentScrollView.frame;
            CGRect preFrame = preScrollView.frame;
            CGRect nextFrame = nextScrollView.frame;
            currentFrame.origin.x = -320.f;
            preFrame.origin.x = 320.f;
            nextFrame.origin.x = 320.f;
            [nextScrollView setFrame:nextFrame];
            nextFrame.origin.x = 0.f;
            
            [nextScrollView setAlpha:(CGFloat)recycleScrollViewAlpha[nextIndex]];
            [UIView animateWithDuration:0.4f animations:^(void){
                [currentScrollView setFrame:currentFrame];
                [nextScrollView setFrame:nextFrame];
                [preScrollView setFrame:preFrame];
            } completion:^(BOOL finished){
                if (finished)
                {
                    [currentScrollView setAlpha:(CGFloat)recycleScrollViewAlpha[currentIndex]];
                    [preScrollView setAlpha:(CGFloat)recycleScrollViewAlpha[preIndex]];
                }
            }];
            
            break;
        }
    }
}

- (void)whenSwipeRight:(UIGestureRecognizer *)sender
{
    int length = sizeof(recycleScrollViewAlpha) / sizeof(int);
    for (int i = 0; i < length; i++)
    {
        if (1 == recycleScrollViewAlpha[i])
        {
            int currentIndex = i;
            int nextIndex = 0 == i? 2: (i - 1 >= 0? i - 1: 0);
            int preIndex = 2 == i? 0: (i + 1 < 3? i + 1: 2);
            recycleScrollViewAlpha[currentIndex] = 0;
            recycleScrollViewAlpha[nextIndex] = 1;
            recycleScrollViewAlpha[preIndex] = 0;
            UIScrollView *currentScrollView = nil;
            UIScrollView *preScrollView = nil;
            UIScrollView *nextScrollView = nil;
            preScrollView = (UIScrollView *)[self.view viewWithTag:recycleScrollViewTags[preIndex]];
            currentScrollView = (UIScrollView *)[self.view viewWithTag:recycleScrollViewTags[currentIndex]];
            nextScrollView = (UIScrollView *)[self.view viewWithTag:recycleScrollViewTags[nextIndex]];
            
            CGRect currentFrame = currentScrollView.frame;
            CGRect preFrame = preScrollView.frame;
            CGRect nextFrame = nextScrollView.frame;
            currentFrame.origin.x = 320.f;
            preFrame.origin.x = -320.f;
            nextFrame.origin.x = -320.f;
            [nextScrollView setFrame:nextFrame];
            nextFrame.origin.x = 0.f;
            
            [nextScrollView setAlpha:(CGFloat)recycleScrollViewAlpha[nextIndex]];
            [UIView animateWithDuration:0.4f animations:^(void){
                [currentScrollView setFrame:currentFrame];
                [nextScrollView setFrame:nextFrame];
                [preScrollView setFrame:preFrame];
            } completion:^(BOOL finished){
                if (finished)
                {
                    [currentScrollView setAlpha:(CGFloat)recycleScrollViewAlpha[currentIndex]];
                    [preScrollView setAlpha:(CGFloat)recycleScrollViewAlpha[preIndex]];
                }
            }];
            
            break;
        }
    }
}

#pragma mark - Button Actions
- (void)whenBackButtonTapped:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  CTTViewController.m
//  CustomTextViewTest
//
//  Created by stone win on 3/1/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import "CTTViewController.h"

@interface CTTViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation CTTViewController
{
    CTTInputType _currentInputType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewTapped:(UITapGestureRecognizer *)sender
{
    [self.textView resignFirstResponder];
}

- (void)inputButtonTapped:(UIButton *)sender
{
    NSRange range = self.textView.selectedRange;
    NSString *text = [self.textView.text stringByInsertingString:[NSString stringWithFormat:@"%d", sender.tag] withRange:range];
    self.textView.text = text;
    
    range.location++;
    self.textView.selectedRange = range;
}

- (UIView *)aInputView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    view.backgroundColor = [UIColor brownColor];
    
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * (44 + 5), 0, 44, 44)];
        button.backgroundColor = [UIColor lightTextColor];
        button.tag = i;
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(inputButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

- (void)accessoryButtonTapped:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            if (CTTInputTypeNormal != _currentInputType)
            {
                _currentInputType = CTTInputTypeNormal;
                self.textView.inputView = nil;
            }
            break;
        }
        case 1:
        {
            if (CTTInputTypeCustom != _currentInputType)
            {
                _currentInputType = CTTInputTypeCustom;
                self.textView.inputView = [self aInputView];
            }
            break;
        }
        default:
            break;
    }
    
    [self.textView resignFirstResponder];
    [self.textView becomeFirstResponder];
}

- (UIView *)aAccessoryView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor blueColor];
    
    for (int i = 0; i < 2; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * (44 + 1), 0, 44, 44)];
        button.backgroundColor = [UIColor greenColor];
        button.tag = i;
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(accessoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tap];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 150)];
    self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
    [self.textView performSelectorOnMainThread:@selector(setInputAccessoryView:) withObject:[self aAccessoryView] waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

@end

@implementation NSString (Emoticon)

- (NSString *)stringByReplacingEmoticon
{
    NSString *text = [self copy];
    if (![text length])
    {
        return nil;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[.+?\\]" options:0 error:NULL];
    NSArray *results = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    if ([results count])
    {
        NSTextCheckingResult *result = [results lastObject];
        if ([text length] == result.range.location + result.range.length)
        {
            text = [text substringToIndex:result.range.location];
        }
        else
        {
            text = [text substringToIndex:[text length] - 1];
        }
    }
    else
    {
        text = [text substringToIndex:[text length] - 1];
    }
    return text;
}

- (NSString *)stringByInsertingString:(NSString *)insertion withRange:(NSRange)range
{
    NSString *text = [self copy];
    NSString *pre = [text substringWithRange:NSMakeRange(0, range.location)];
    NSString *post = [text substringFromIndex:range.location + range.length];
    text = [NSString stringWithFormat:@"%@%@%@", pre, insertion, post];
    return text;
}

@end

//
//  TVRTViewController.m
//  TextViewRealignTest
//
//  Created by stone win on 2/27/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "TVRTViewController.h"

#define FONT_TEXTVIEW   [UIFont systemFontOfSize:20]

@interface TVRTViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation TVRTViewController
{
    CGRect _frame;
    CGSize _previousContentSize;
}

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
    self.view = [[UIView alloc] initWithFrame:APPFRAME];
    
    // Text view
    _frame = CGRectMake(0, 88, APPSIZE.width, 48);
    
    self.textView = [[UITextView alloc] initWithFrame:_frame];
    _textView.backgroundColor = [UIColor greenColor];
    //_textView.font = FONT_TEXTVIEW;
    _textView.text = @"准备开始";
    _textView.delegate = self;
    [self.view addSubview:_textView];
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

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _previousContentSize = textView.contentSize;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize currentContentSize = textView.contentSize;
    UIFont *font = textView.font;
    
    if (_previousContentSize.height < currentContentSize.height)
    {
        _frame = textView.frame;
        _frame.origin.y -= font.lineHeight;
        _frame.size.height += font.lineHeight;
        textView.frame = _frame;
    }
    else if (_previousContentSize.height > currentContentSize.height)
    {
        _frame = textView.frame;
        _frame.origin.y += font.lineHeight;
        _frame.size.height -= font.lineHeight;
        textView.frame = _frame;
    }
    
    _previousContentSize = currentContentSize;
}

@end

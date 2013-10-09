//
//  CTViewController.m
//  ConsumerTest
//
//  Created by stone win on 9/2/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "CTViewController.h"
#import "CTConsumerViewController.h"
#import "CTContainer.h"

@interface CTViewController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UILabel *producerLabel;
@property (nonatomic, strong) UILabel *consumerLabel;
@property (nonatomic, strong) UILabel *consumerCountLabel;
@property (nonatomic, strong) UILabel *producerCountLabel;

@end

@implementation CTViewController
{
    NSUInteger _producerCapability;
    NSUInteger _consumerCapability;
    NSUInteger _numberOfConsumer;
    NSUInteger _numberOfProducer;
}

#pragma mark - Actions

- (void)producerSliderChanged:(UISlider *)sender
{
    _producerCapability = roundf(sender.value);
    _producerLabel.text = [NSString stringWithFormat:@"%02d", _producerCapability];
}

- (void)consumerSliderChanged:(UISlider *)sender
{
    _consumerCapability = roundf(sender.value);
    _consumerLabel.text = [NSString stringWithFormat:@"%02d", _consumerCapability];
}

- (void)consumerCountSliderChanged:(UISlider *)sender
{
    _numberOfConsumer = roundf(sender.value);
    _consumerCountLabel.text = [NSString stringWithFormat:@"%02d", _numberOfConsumer];
}

- (void)producerCountSliderChanged:(UISlider *)sender
{
    _numberOfProducer = roundf(sender.value);
    _producerCountLabel.text = [NSString stringWithFormat:@"%02d", _numberOfProducer];
}

- (void)startButtonTapped:(UIButton *)sender
{
    CTConsumerViewController *controller = [[CTConsumerViewController alloc] init];
    controller.title = @"ConsumerView";
    controller.produceCapability = _producerCapability;
    controller.consumCapability = _consumerCapability;
    controller.numberOfConsumer = _numberOfConsumer;
    controller.numberOfProducer = _numberOfProducer;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Views

- (void)adjustButtonFrame
{
    CGRect frame;
    
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
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    
    NSString *text = @"produce capability: ";
    UIFont *font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    CGRect frame;
    frame.size = [text sizeWithFont:font];
    frame.origin.x = 10;
    frame.origin.y = 10;
    
    UILabel *producerDescLabel = [[UILabel alloc] initWithFrame:frame];
    producerDescLabel.text = text;
    producerDescLabel.textAlignment = NSTextAlignmentLeft;
    producerDescLabel.font = font;
    [self.view addSubview:producerDescLabel];
    
    text = @"00";
    frame.size = [text sizeWithFont:font];
    frame.origin.x = CGRectGetMaxX(producerDescLabel.frame);
    
    _producerLabel = [[UILabel alloc] initWithFrame:frame];
    _producerLabel.text = text;
    _producerLabel.textAlignment = NSTextAlignmentLeft;
    _producerLabel.font = font;
    [self.view addSubview:_producerLabel];
    
    frame.origin.x = 10;
    frame.origin.y = CGRectGetMaxY(_producerLabel.frame);
    frame.size.width = 300;
    
    UISlider *producerSlider = [[UISlider alloc] initWithFrame:frame];
    producerSlider.backgroundColor = [UIColor greenColor];
    producerSlider.minimumValue = 0;
    producerSlider.maximumValue = 10;
    producerSlider.value = 0;
    [producerSlider addTarget:self action:@selector(producerSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:producerSlider];
    
    text = @"consum capability: ";
    frame.origin.y = CGRectGetMaxY(producerSlider.frame);
    frame.size = [text sizeWithFont:font];
    
    UILabel *consumerDescLabel = [[UILabel alloc] initWithFrame:frame];
    consumerDescLabel.text = text;
    consumerDescLabel.textAlignment = NSTextAlignmentLeft;
    consumerDescLabel.font = font;
    [self.view addSubview:consumerDescLabel];
    
    text = @"00";
    frame.size = [text sizeWithFont:font];
    frame.origin.x = CGRectGetMaxX(consumerDescLabel.frame);
    
    _consumerLabel = [[UILabel alloc] initWithFrame:frame];
    _consumerLabel.text = text;
    _consumerLabel.textAlignment = NSTextAlignmentLeft;
    _consumerLabel.font = font;
    [self.view addSubview:_consumerLabel];
    
    frame.origin.x = 10;
    frame.origin.y = CGRectGetMaxY(_consumerLabel.frame);
    frame.size.width = 300;
    
    UISlider *consumerSlider = [[UISlider alloc] initWithFrame:frame];
    consumerSlider.backgroundColor = [UIColor greenColor];
    consumerSlider.minimumValue = 0;
    consumerSlider.maximumValue = 10;
    consumerSlider.value = 0;
    [consumerSlider addTarget:self action:@selector(consumerSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:consumerSlider];
    
    // consumer count
    text = @"number of consumer: ";
    frame.size = [text sizeWithFont:font];
    frame.origin.y = CGRectGetMaxY(consumerSlider.frame);
    
    UILabel *consumerCountDescLabel = [[UILabel alloc] initWithFrame:frame];
    consumerCountDescLabel.text = text;
    consumerCountDescLabel.textAlignment = NSTextAlignmentLeft;
    consumerCountDescLabel.font = font;
    [self.view addSubview:consumerCountDescLabel];
    
    _numberOfConsumer = 1;
    text = @"01";
    frame.size = [text sizeWithFont:font];
    frame.origin.x = CGRectGetMaxX(consumerCountDescLabel.frame);
    
    _consumerCountLabel = [[UILabel alloc] initWithFrame:frame];
    _consumerCountLabel.text = text;
    _consumerCountLabel.textAlignment = NSTextAlignmentLeft;
    _consumerCountLabel.font = font;
    [self.view addSubview:_consumerCountLabel];
    
    frame.origin.x = 10;
    frame.origin.y = CGRectGetMaxY(_consumerCountLabel.frame);
    frame.size.width = 300;
    
    UISlider *consumerCountSlider = [[UISlider alloc] initWithFrame:frame];
    consumerCountSlider.backgroundColor = [UIColor greenColor];
    consumerCountSlider.minimumValue = 1;
    consumerCountSlider.maximumValue = [CTContainer capacity];
    consumerCountSlider.value = 0;
    [consumerCountSlider addTarget:self action:@selector(consumerCountSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:consumerCountSlider];
    
    // producer count
    text = @"number of producer: ";
    frame.size = [text sizeWithFont:font];
    frame.origin.y = CGRectGetMaxY(consumerCountSlider.frame);
    
    UILabel *producerCountDescLabel = [[UILabel alloc] initWithFrame:frame];
    producerCountDescLabel.text = text;
    producerCountDescLabel.textAlignment = NSTextAlignmentLeft;
    producerCountDescLabel.font = font;
    [self.view addSubview:producerCountDescLabel];
    
    _numberOfProducer = 1;
    text = @"01";
    frame.size = [text sizeWithFont:font];
    frame.origin.x = CGRectGetMaxX(producerCountDescLabel.frame);
    
    _producerCountLabel = [[UILabel alloc] initWithFrame:frame];
    _producerCountLabel.text = text;
    _producerCountLabel.textAlignment = NSTextAlignmentLeft;
    _producerCountLabel.font = font;
    [self.view addSubview:_producerCountLabel];
    
    frame.origin.x = 10;
    frame.origin.y = CGRectGetMaxY(_producerCountLabel.frame);
    frame.size.width = 300;
    
    UISlider *producerCountSlider = [[UISlider alloc] initWithFrame:frame];
    producerCountSlider.backgroundColor = [UIColor greenColor];
    producerCountSlider.minimumValue = 1;
    producerCountSlider.maximumValue = [CTContainer capacity];
    producerCountSlider.value = 0;
    [producerCountSlider addTarget:self action:@selector(producerCountSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:producerCountSlider];
    
    // button
    frame.size = CGSizeMake(100, 60);
    frame.origin.x = (CGRectGetWidth(self.view.frame)-frame.size.width) / 2;
    frame.origin.y = CGRectGetMaxY(producerCountSlider.frame) + 10;
    
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = frame;
    [_startButton addTarget:self action:@selector(startButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_startButton setTitle:@"start" forState:UIControlStateNormal];
    [self.view addSubview:_startButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self adjustButtonFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (![self isViewLoaded])
    {
        self.startButton = nil;
    }
}

@end

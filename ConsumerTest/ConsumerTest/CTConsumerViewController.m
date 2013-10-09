//
//  CTConsumerViewController.m
//  ConsumerTest
//
//  Created by stone win on 9/2/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "CTConsumerViewController.h"
#import "CTProducer.h"
#import "CTConsumer.h"
#import "CTContainer.h"

@interface CTConsumerViewController () <CTProducerDelegate, CTConsumerDelgate, CTContainerDelegate>

@property (nonatomic, strong) UIView *producerView;
@property (nonatomic, strong) UIView *productTypeView;
@property (nonatomic, strong) UILabel *producerWaitLabel;
@property (nonatomic, strong) UIView *consumerView;
@property (nonatomic, strong) UIView *consumTypeView;
@property (nonatomic, strong) UILabel *consumerWaitLabel;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation CTConsumerViewController
{
    NSMutableArray *_producers;
    NSMutableArray *_consumers;
}

#pragma mark - Helpers

#define kTagPrefixProducer  1309040
#define kTagPrefixConsumer  1309041
- (void)startGame
{
    [CTContainer setDelegate:self];
    _producers = [[NSMutableArray alloc] init];
    _consumers = [[NSMutableArray alloc] init];
    
    dispatch_semaphore_t consumeSemaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_t produceSemaphore = dispatch_semaphore_create(0);
    
    for (int i=0; i<_numberOfProducer; i++)
    {
        CTProducer *producer = [[CTProducer alloc] initWithProduceSemaphore:produceSemaphore waitingSemaphore:consumeSemaphore capability:_produceCapability];
        producer.delegate = self;
        producer.tag = i + kTagPrefixProducer;
        [_producers addObject:producer];
    }
    [_producers makeObjectsPerformSelector:@selector(startProduce)];
    
    for (int i=0; i<_numberOfConsumer; i++)
    {
        CTConsumer *consumer = [[CTConsumer alloc] initWithConsumSemaphore:consumeSemaphore waitingSemaphore:produceSemaphore capability:_consumCapability];
        consumer.delegate = self;
        consumer.tag = i + kTagPrefixConsumer;
        [_consumers addObject:consumer];
    }
    [_consumers makeObjectsPerformSelector:@selector(startConsum)];
}

- (void)stopGame
{
    [_producers makeObjectsPerformSelector:@selector(stopProduce)];
    [_consumers makeObjectsPerformSelector:@selector(stopConsum)];
    [CTContainer removeAllProducts];
}

#pragma makr - Views

- (void)loadProducerView
{
    CGRect frame = CGRectZero;
    frame.size.width = CGRectGetWidth(self.view.frame);
    frame.size.height = (CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.navigationController.navigationBar.frame)) / 2;
    
    _producerView = [[UIView alloc] initWithFrame:frame];
    _producerView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:_producerView];
    
    // product type view
    frame.size.height = 50;
    
    _productTypeView = [[UIView alloc] initWithFrame:frame];
    _productTypeView.backgroundColor = [UIColor whiteColor];
    [_producerView addSubview:_productTypeView];
    
    frame.size.width = 100;
    
    for (int i=0; i<[CTContainer capacity]; i++)
    {
        frame.origin.x = i * (frame.size.width+10);
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor darkGrayColor];
        label.text = @"nil";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.tag = i + kTagPrefixProducer;
        [_productTypeView addSubview:label];
    }
    
    // waiting label
    NSString *text = @"producer is waiting…";
    UIFont *font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    frame.size.width = [text sizeWithFont:font].width;
    frame.size.height = 60;
    frame.origin.x = roundf((CGRectGetWidth(_producerView.frame)-frame.size.width) / 2);
    frame.origin.y = roundf(((CGRectGetHeight(_producerView.frame)-CGRectGetMaxY(_productTypeView.frame))-frame.size.height) / 2) + CGRectGetHeight(_productTypeView.frame);
    
    _producerWaitLabel = [[UILabel alloc] initWithFrame:frame];
    _producerWaitLabel.backgroundColor = [UIColor yellowColor];
    _producerWaitLabel.text = text;
    _producerWaitLabel.textAlignment = NSTextAlignmentCenter;
    _producerWaitLabel.textColor = [UIColor blackColor];
    _producerWaitLabel.font = font;
    _producerWaitLabel.hidden = YES;
    [_producerView addSubview:_producerWaitLabel];
}

- (void)loadConsumerView
{
    CGRect frame = CGRectZero;
    frame.size.width = CGRectGetWidth(self.view.frame);
    frame.size.height = (CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.navigationController.navigationBar.frame)) / 2;
    frame.origin.y = frame.size.height;
    
    _consumerView = [[UIView alloc] initWithFrame:frame];
    _consumerView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_consumerView];
    
    frame.size.height = 50;
    frame.origin.y = CGRectGetHeight(_consumerView.frame) - frame.size.height;
    
    _consumTypeView = [[UIView alloc] initWithFrame:frame];
    _consumTypeView.backgroundColor = [UIColor whiteColor];
    [_consumerView addSubview:_consumTypeView];
    
    frame.size.width = 100;
    frame.origin.y = 0;
    
    for (int i=0; i<[CTContainer capacity]; i++)
    {
        frame.origin.x = i * (frame.size.width+10);
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor darkGrayColor];
        label.text = @"nil";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.tag = i + kTagPrefixConsumer;
        [_consumTypeView addSubview:label];
    }
    
    // waiting label
    NSString *text = @"consumer is waiting…";
    UIFont *font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    frame.size.width = [text sizeWithFont:font].width;
    frame.size.height = 60;
    frame.origin.x = roundf((CGRectGetWidth(_consumerView.frame)-frame.size.width) / 2);
    frame.origin.y = roundf((CGRectGetMinY(_consumTypeView.frame)-frame.size.height) / 2);
    
    _consumerWaitLabel = [[UILabel alloc] initWithFrame:frame];
    _consumerWaitLabel.backgroundColor = [UIColor yellowColor];
    _consumerWaitLabel.text = text;
    _consumerWaitLabel.textAlignment = NSTextAlignmentCenter;
    _consumerWaitLabel.textColor = [UIColor blackColor];
    _consumerWaitLabel.font = font;
    _consumerWaitLabel.hidden = YES;
    [_consumerView addSubview:_consumerWaitLabel];
}

- (void)loadContainerView
{
    CGRect frame;
    frame.size = CGSizeMake(CGRectGetWidth(self.view.frame), 50);
    frame.origin.x = 0;
    frame.origin.y = CGRectGetHeight(_producerView.frame) - (frame.size.height/2);
    
    _containerView = [[UIView alloc] initWithFrame:frame];
    _containerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_containerView];
    
    // product type label
    frame.size.width = 100;
    frame.origin.y = 0;
    
    for (int i=0; i<[CTContainer capacity]; i++)
    {
        frame.origin.x = i * (frame.size.width+10);
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor redColor];
        label.text = @"empty";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.tag = (NSInteger)[[CTProducer productType] objectAtIndex:i];
        [_containerView addSubview:label];
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
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self loadProducerView];
    [self loadConsumerView];
    [self loadContainerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startGame];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - CTProducer Delegate

- (void)setProducerWaitLabelHidden:(BOOL)hidden
{
    SEL selector = @selector(setHidden:);
    NSMethodSignature *signature = [[_producerWaitLabel class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:_producerWaitLabel];
    [invocation setSelector:selector];
    [invocation setArgument:&hidden atIndex:2];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
}

- (void)setProducerLabelWithTag:(NSUInteger)tag text:(NSString *)text backgroundColor:(UIColor *)backgroundColor
{
    UILabel *label = (UILabel *)[_productTypeView viewWithTag:tag];
    if (!label) return;
    [label performSelectorOnMainThread:@selector(setText:) withObject:text waitUntilDone:YES];
    [label performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:backgroundColor waitUntilDone:YES];
}

- (void)producer:(CTProducer *)producer willProduce:(id)product
{
    [self setProducerWaitLabelHidden:YES];
    [self setProducerLabelWithTag:producer.tag text:product backgroundColor:[UIColor redColor]];
}

- (void)producer:(CTProducer *)producer didProduce:(id)product
{
    [self setProducerLabelWithTag:producer.tag text:product backgroundColor:[UIColor greenColor]];
}

- (void)producerWillWaiting:(CTProducer *)producer
{
    [self setProducerWaitLabelHidden:NO];
    [self setProducerLabelWithTag:producer.tag text:@"idle" backgroundColor:[UIColor redColor]];
}

#pragma mark - CTConsumer Delegate

- (void)setConsumerWaitLabelHidden:(BOOL)hidden
{
    SEL selector = @selector(setHidden:);
    NSMethodSignature *signature = [[_consumerWaitLabel class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:_consumerWaitLabel];
    [invocation setSelector:selector];
    [invocation setArgument:&hidden atIndex:2];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
}

- (void)setConsumerLabelWithTag:(NSUInteger)tag text:(NSString *)text backgroundColor:(UIColor *)backgroundColor
{
    UILabel *label = (UILabel *)[_consumTypeView viewWithTag:tag];
    if (!label) return;
    [label performSelectorOnMainThread:@selector(setText:) withObject:text waitUntilDone:YES];
    [label performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:backgroundColor waitUntilDone:YES];
}

- (void)consumer:(CTConsumer *)consumer willConsum:(id)product
{
    [self setConsumerWaitLabelHidden:YES];
    [self setConsumerLabelWithTag:consumer.tag text:product backgroundColor:[UIColor greenColor]];
}

- (void)consumer:(CTConsumer *)consumer didConsum:(id)product
{
    [self setConsumerLabelWithTag:consumer.tag text:product backgroundColor:[UIColor redColor]];
}

- (void)consumerWillWait:(CTConsumer *)consumer
{
    [self setConsumerWaitLabelHidden:NO];
    [self setConsumerLabelWithTag:consumer.tag text:@"idle" backgroundColor:[UIColor redColor]];
}

#pragma mark - CTContainer Delegate

- (void)container:(CTContainer *)container didStroeProduct:(id)product
{
    NSInteger tag = (NSInteger)product;
    UILabel *label = (UILabel *)[_containerView viewWithTag:tag];
    if (!label) return;
    [label performSelectorOnMainThread:@selector(setText:) withObject:product waitUntilDone:YES];
    [label performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor greenColor] waitUntilDone:YES];
}

- (void)container:(CTContainer *)container didRemoveProduct:(id)product
{
    NSInteger tag = (NSInteger)product;
    UILabel *label = (UILabel *)[_containerView viewWithTag:tag];
    if (!label) return;
    [label performSelectorOnMainThread:@selector(setText:) withObject:@"empty" waitUntilDone:YES];
    [label performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor redColor] waitUntilDone:YES];
}

@end

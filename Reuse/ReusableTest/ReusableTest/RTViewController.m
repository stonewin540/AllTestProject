//
//  RTViewController.m
//  ReusableTest
//
//  Created by stone win on 5/14/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "RTViewController.h"
#import "RTTableView.h"
#import "RTView.h"

@interface RTViewController () <UITableViewDataSource, UITableViewDelegate, RTViewDataSource, RTViewDelegate>
@property (nonatomic, strong) RTTableView *tableView;
@property (nonatomic, strong) RTView *reusableView;
@end

@implementation RTViewController
{
    CGRect _frame;
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
    _frame = [UIScreen mainScreen].applicationFrame;
    _frame.size.width = 320;
    _frame.size.height -= 44;
    
    self.view = [[UIView alloc] initWithFrame:_frame];
    
    // table view
    _frame = self.view.bounds;
    _frame.size.width /= 2;
    
    self.tableView = [[RTTableView alloc] initWithFrame:_frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor redColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    // reusable view
    _frame.origin.x = CGRectGetMaxX(_tableView.frame);
    
    self.reusableView = [[RTView alloc] initWithFrame:_frame];
    _reusableView.backgroundColor = [UIColor greenColor];
    _reusableView.rtDataSource = self;
    _reusableView.rtDelegate = self;
    [self.view addSubview:_reusableView];
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

#define kNumberOfRows   4
#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kNumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RTCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
    }
    
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(_tableView.frame) / 2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = NSStringFromCGRect(cell.frame);
}

#pragma mark RTView DataSource

- (NSUInteger)numberOfRowsInReusableView
{
    return kNumberOfRows;
}

- (RTCell *)reusableView:(RTView *)reusableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    RTCell *cell = [reusableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (nil == cell)
    {
        cell = [[RTCell alloc] initWithReuseIdentifier:Identifier];
    }
    
    return cell;
}

#pragma mark - RTView Delegate

- (CGFloat)reusableView:(RTView *)reusableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(_reusableView.frame) / 2;
}

- (void)reusableView:(RTView *)reusableView willDisplayCell:(RTCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = NSStringFromCGRect(cell.frame);
}

@end

//
//  PGVTViewController.m
//  PagingGridViewTest
//
//  Created by stone win on 10/25/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "PGVTViewController.h"
#import "PGVTView.h"

@interface PGVTViewController () <PGVTViewDataSource, PGVTViewDelegate>

@property (nonatomic, strong) PGVTView *pagingGridView;

@end

@implementation PGVTViewController

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
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _pagingGridView = [[PGVTView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0, 20)];
    _pagingGridView.backgroundColor = [UIColor blueColor];
    _pagingGridView.dataSource = self;
    _pagingGridView.delegate = self;
    [self.view addSubview:_pagingGridView];
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

#pragma mark - PGVTView DataSource

- (NSInteger)pagingGridView:(PGVTView *)pagingGridView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (PGVTItem *)pagingGridView:(PGVTView *)pagingGridView itemForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    PGVTItem *item = [pagingGridView dequeueReuseableItemForReuseIdentifier:identifier];
    
    if (!item)
    {
        item = [[PGVTItem alloc] initWithStyle:PGVTItemStyleDefault reuseIdentifier:identifier];
        item.contentView.backgroundColor = [UIColor colorWithRed:arc4random()/255.f green:arc4random()/255.f blue:arc4random()/255.f alpha:1];
    }
    
    item.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return item;
}

#pragma mark - PGVTView Delegate

@end

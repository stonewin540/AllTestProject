//
//  IIOTViewController.m
//  ImageIOTest
//
//  Created by stone win on 10/31/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "IIOTViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IIOTDetailViewController.h"

@interface IIOTViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@end

@implementation IIOTViewController

#pragma mark - Helper

- (ALAsset *)assetForIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger count = [_assets count];
    if (!count) return nil;
    NSInteger row = indexPath.row;
    if (row<0 || row>=count) return nil;
    ALAsset *asset = _assets[row];
    if (![asset isKindOfClass:[ALAsset class]]) return nil;
    return asset;
}

- (void)loadAssetsWithGroup:(ALAssetsGroup *)group
{
    if (!group) return;
    
    _assets = [[NSMutableArray alloc] init];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result)
        {
            [_assets addObject:result];
        }
        else
        {
            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

#pragma mark - 
#pragma mark Lifecycle

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
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    __block ALAssetsGroup *assetsGroup = nil;
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            assetsGroup = group;
        }
        else
        {
            [self loadAssetsWithGroup:assetsGroup];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_assets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ALAsset *asset = [self assetForIndexPath:indexPath];
    UIImage *image = nil;
    if (asset)
    {
        image = [UIImage imageWithCGImage:[asset thumbnail]];
    }
    
    if (image) cell.imageView.image = image;
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IIOTDetailViewController *controller = [[IIOTDetailViewController alloc] init];
    controller.text = [NSString stringWithFormat:@"%d", indexPath.row];
    controller.asset = [self assetForIndexPath:indexPath];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

@end

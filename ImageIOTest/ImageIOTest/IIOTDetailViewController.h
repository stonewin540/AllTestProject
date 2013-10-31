//
//  IIOTDetailViewController.h
//  ImageIOTest
//
//  Created by stone win on 10/31/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface IIOTDetailViewController : UIViewController
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) ALAsset *asset;
@end

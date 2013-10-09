//
//  PTView.h
//  ProgressTest
//
//  Created by stone win on 10/8/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TransmissionStateSucceed,
    TransmissionStateFailure,
    TransmissionStateUploading,
} TransmissionState;

@interface PTView : UIView

@property (nonatomic, strong, readonly) UILabel *promptLabel;
@property (nonatomic, assign) TransmissionState state;
@property (nonatomic, assign) NSTimeInterval speed;
@property (nonatomic, strong) UIImage *succeedImage;
@property (nonatomic, strong) UIImage *failureImage;
@property (nonatomic, strong) UIImage *uploadingImage;

@end

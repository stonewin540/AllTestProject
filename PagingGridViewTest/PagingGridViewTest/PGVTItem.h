//
//  PGVTItem.h
//  PagingGridViewTest
//
//  Created by stone win on 10/25/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PGVTItemStyleDefault,
} PGVTItemStyle;

@interface PGVTItem : UIView

@property (nonatomic, assign, readonly) PGVTItemStyle style;
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

// UI
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

- (instancetype)initWithStyle:(PGVTItemStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

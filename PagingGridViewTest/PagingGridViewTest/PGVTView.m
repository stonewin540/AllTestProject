//
//  PGVTView.m
//  PagingGridViewTest
//
//  Created by stone win on 10/25/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "PGVTView.h"

#define kItemHeight 44

@implementation PGVTView
{
    NSMutableDictionary *_reuseableItems;
    NSMutableDictionary *_visibleItems;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _reuseableItems = [[NSMutableDictionary alloc] init];
        _visibleItems = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)reloadData
{
    NSInteger numberOfItems = 0;
    if (_dataSource)
    {
        numberOfItems = [_dataSource pagingGridView:self numberOfItemsInSection:0];
        CGSize contentSize = CGSizeMake(CGRectGetWidth(self.frame), numberOfItems*kItemHeight);
        self.contentSize = contentSize;
        numberOfItems = ceilf(CGRectGetHeight(self.frame) / kItemHeight);
    }
    
    
    CGRect itemFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kItemHeight);
    for (int i=0; i<numberOfItems; i++)
    {
        itemFrame.origin.y = i * itemFrame.size.height;
        PGVTItem *item = nil;
        if (_dataSource)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            item = [_dataSource pagingGridView:self itemForRowAtIndexPath:indexPath];
            item.frame = itemFrame;
            [_visibleItems setObject:item forKey:indexPath];
            [self addSubview:item];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self reloadData];
}

- (PGVTItem *)dequeueReuseableItemForReuseIdentifier:(NSString *)reuseIdentifer
{
    NSMutableSet *set = [_reuseableItems objectForKey:reuseIdentifer];
    PGVTItem *item = [set anyObject];
    [set removeObject:item];
    return item;
}

- (void)enqueueReuseableItem:(PGVTItem *)item
{
    NSMutableSet *set = [_reuseableItems objectForKey:item.reuseIdentifier];
    if (!set)
    {
        set = [[NSMutableSet alloc] init];
        [_reuseableItems setObject:set forKey:item.reuseIdentifier];
    }
    [set addObject:item];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

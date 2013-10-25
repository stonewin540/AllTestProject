//
//  PGVTView.m
//  PagingGridViewTest
//
//  Created by stone win on 10/25/13.
//  Copyright (c) 2013 stone win. All rights reserved.
//

#import "PGVTView.h"

@implementation PGVTView
{
    NSMutableDictionary *_itemPool;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _itemPool = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)reloadData
{
    NSInteger numberOfItems = 0;
    if (_dataSource)
    {
        numberOfItems = [_dataSource pagingGridView:self numberOfItemsInSection:0];
    }
    
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.frame), 0);
    CGRect itemFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 44);
    for (int i=0; i<numberOfItems; i++)
    {
        itemFrame.origin.y = i * itemFrame.size.height;
        PGVTItem *item = nil;
        if (_dataSource)
        {
            item = [_dataSource pagingGridView:self itemForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            item.frame = itemFrame;
            [self enqueueReuseableItem:item];
            [self addSubview:item];
            contentSize.height += itemFrame.size.height;
        }
    }
    
    self.contentSize = contentSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self reloadData];
}

- (PGVTItem *)dequeueReuseableItemForReuseIdentifier:(NSString *)reuseIdentifer
{
    NSMutableSet *set = [_itemPool objectForKey:reuseIdentifer];
    PGVTItem *item = [set anyObject];
    return item;
}

- (void)enqueueReuseableItem:(PGVTItem *)item
{
    NSMutableSet *set = [_itemPool objectForKey:item.reuseIdentifier];
    if (!set)
    {
        set = [[NSMutableSet alloc] init];
        [_itemPool setObject:set forKey:item.reuseIdentifier];
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

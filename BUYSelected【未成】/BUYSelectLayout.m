//
//  BUYSelectLayout.m
//  buy
//
//  Created by dbjyz on 15/12/30.
//  Copyright © 2015年 跟谁买. All rights reserved.
//

#import "BUYSelectLayout.h"
#import "SectionHeadCollectionReusableView.h"

@interface BUYSelectLayout()

@end

static const NSUInteger DaysPerWeek = 7;
static const CGFloat HeightPerHour = 50;
static const CGFloat DayHeaderHeight = 40;
static const CGFloat HourHeaderWidth = 100;

@implementation BUYSelectLayout
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

/**
 *  只要显示的边界发生改变就重新布局:
 内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
 */
//当边界更改时是否更新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds))
    {
        return YES;
    }
    
    return NO;
}

/**
 *  用来设置collectionView停止滚动那一刻的位置
 *
 *  @param proposedContentOffset 原本collectionView停止滚动那一刻的位置
 *  @param velocity              滚动速度
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 1.计算出scrollView最后会停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    // 计算屏幕最中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    // 3.遍历所有属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attrs.center.x - centerX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}

/**
 *  一些初始化工作最好在这里实现
 */
- (void)prepareLayout
{
    [super prepareLayout];

    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    /*
    //获取每个分组的cell的个数
    int cellNum = [self.collectionView numberOfItemsInSection:0];
    //获取有几组
    int sectionNum = [self.collectionView numberOfSections];
     */
}


//获取当前的item
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *cellArray = [NSMutableArray array];
    int sectionNum = [self.collectionView numberOfSections];
    for (int k=0; k<sectionNum; k++) {
        
        int cellNum = [self.collectionView numberOfItemsInSection:k];
        //add cells
        for (int i=0; i< cellNum;i++ )
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:k];
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            [cellArray addObject:attributes];
        }
    }
    
    return cellArray;
}



/**
 * 该方法为每个item绑定一个Layout属性~
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame = CGRectZero;
    
    if (indexPath.row == 0) {
         frame = CGRectMake(10, 0+indexPath.section*250, SCREEN_WIDTH-20, 120);
    }else{
        CGFloat boderMargin = 10;//间距
        CGFloat Width = (SCREEN_WIDTH-4*boderMargin)/3;
        
        frame = CGRectMake(boderMargin+(boderMargin+Width)*(indexPath.row-1), 130+indexPath.section*250, Width, Width);
    }
    //计算每个Cell的位置
    attributes.frame = frame;
    
    return attributes;
}



/**
 * 该方法为每个section绑定一个Layout属性~
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    CGFloat totalWidth = [self collectionViewContentSize].width;
    if ([kind isEqualToString:@"DayHeaderView"]) {
        CGFloat availableWidth = totalWidth - HourHeaderWidth;
        CGFloat widthPerDay = availableWidth / DaysPerWeek;
        attributes.frame = CGRectMake(HourHeaderWidth + (widthPerDay * indexPath.item), 0, widthPerDay, DayHeaderHeight);
        attributes.zIndex = -10;
    } else if ([kind isEqualToString:@"HourHeaderView"]) {
        attributes.frame = CGRectMake(0, DayHeaderHeight + HeightPerHour * indexPath.item, totalWidth, HeightPerHour);
        attributes.zIndex = -10;
    }
    return attributes;
}




//设置整体能滑动的区域
- (CGSize)collectionViewContentSize
{
   int sectionNum = [self.collectionView numberOfSections];
   return CGSizeMake(SCREEN_WIDTH, sectionNum*250+130);
}


@end




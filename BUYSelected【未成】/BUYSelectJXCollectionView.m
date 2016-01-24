//
//  BUYSelectJXCollectionView.m
//  buy
//
//  Created by dbjyz on 15/12/29.
//  Copyright © 2015年 跟谁买. All rights reserved.
//

#import "BUYSelectJXCollectionView.h"
#import "BUYSelectJXCell.h"
#import "SectionHeadCollectionReusableView.h"
#import "BUYSelectLayout.h"

static  NSString *const meSelectJXCell = @"BUYSelectJXCell";
static  NSString *const meSectionHeadCollectionReusableView = @"SectionHeadCollectionReusableView";

@implementation BUYSelectJXCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource      = self;
        self.delegate        = self;
        [self registerClass:[BUYSelectJXCell class] forCellWithReuseIdentifier:meSelectJXCell];
        [self registerClass:[SectionHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:meSectionHeadCollectionReusableView];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}


#pragma mark - UICollectionViewDelegate

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BUYSelectJXCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:meSelectJXCell forIndexPath:indexPath];
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"选中选中选中选中选中选中选中");    
}


#pragma -------------处理section等-------------需要和cell一样注册等
//添加section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 9;
}

//设置section头部的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 30);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    SectionHeadCollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:meSectionHeadCollectionReusableView forIndexPath:indexPath];
    }
    return reusableview;
}



@end
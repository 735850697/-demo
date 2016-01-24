//
//  SliderTopNavView.m
//  SliderView
//
//  Created by imqiuhang on 15/3/28.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "QHNavSliderMenu.h"

#define sliderBtnTagStartPoint 10102

@implementation QHNavSliderMenu
{
    NSInteger curSelectRow;
    UIView *bottomTabLine;
    QHNavSliderMenuType menuType;
    UIScrollView *contentScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame andStyleModel:(QHNavSliderMenuStyleModel *)aStyleModel andDelegate:(id<QHNavSliderMenuDelegate>)delegate  showType:(QHNavSliderMenuType)type;{
    if (self=[super initWithFrame:frame]) {
        styleModel     = aStyleModel;
        curSelectRow   = -1;
        menuType       = type;
        sliderDelegate = delegate;
        [self initSliderTopNavView:type];
    }
    return self;
}

- (void)selectAtRow:(NSInteger)row andDelegate:(BOOL)delegate {
    
    if (row>styleModel.menuTitles.count-1||row<0) {
        return;
    }
    if (row==curSelectRow) {
        if (delegate&&[sliderDelegate respondsToSelector:@selector(navSliderMenuDidReSelectAtRow:)]) {
            [sliderDelegate navSliderMenuDidReSelectAtRow:row];
        }
        return;
    }
    if(delegate&&[sliderDelegate respondsToSelector:@selector(navSliderMenuDidSelectAtRow:)]) {
        [sliderDelegate navSliderMenuDidSelectAtRow:row];
    }
    
    
    
    UIButton *unSelectBtn =(UIButton *)[contentScrollView viewWithTag:curSelectRow+sliderBtnTagStartPoint];
    UIButton *selectBtn=(UIButton *)[contentScrollView viewWithTag:row+sliderBtnTagStartPoint];
    if (menuType==QHNavSliderMenuTypeTitleOnly) {
        [UIView animateWithDuration:ABS(row-curSelectRow)*0.1 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (styleModel.autoSuitLineViewWithdForBtnTitle) {
                float width = [QHUtil countWidthOfString:styleModel.menuTitles[row] WithHeight:100 Font:styleModel.titleLableFont];
                bottomTabLine.width = width;
            }
            bottomTabLine.centerX=selectBtn.centerX;
        } completion:^(BOOL finished) {
            unSelectBtn.selected=NO;
            selectBtn.selected=YES;
        }];
    }else {
        unSelectBtn.selected=NO;
        selectBtn.selected=YES;
    }
    
    
    curSelectRow=row;
    _currentSelectIndex = curSelectRow;
    [self adjustToScrollView:curSelectRow];
}

//点击后适当滚动以适应
- (void)adjustToScrollView :(NSInteger)row {
    
    if (styleModel.donotScrollTapViewWhileScroll) {
        return;
    }
    
    UIButton *selectBtn=(UIButton *)[contentScrollView viewWithTag:row+sliderBtnTagStartPoint];
    
    if(styleModel.sizeToFitScreenWidth) {
        
    }else {
        
        
        float offsetx = selectBtn.left - contentScrollView.width/2.f+ styleModel.menuWidth/2.f;
        
        offsetx=offsetx<0?0:offsetx;
        offsetx = offsetx+contentScrollView.width>(contentScrollView.contentSize.width)?contentScrollView.contentSize.width-contentScrollView.width:offsetx;
        
        [contentScrollView setContentOffset:CGPointMake(offsetx, contentScrollView.contentOffset.y) animated:YES];
    }
    
    
    
}

- (void)sliderBtnSelectEvent:(UIButton *)sender {
    
    [self selectAtRow:sender.tag-sliderBtnTagStartPoint andDelegate:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([sliderDelegate respondsToSelector:@selector(navScrollViewDidScroll:)]) {
        [sliderDelegate navScrollViewDidScroll:scrollView.contentOffset.x];
    }
}

- (void)initSliderTopNavView:(QHNavSliderMenuType)type {
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:contentScrollView];
    
    NSAssert(styleModel.menuTitles, @"顶部滑动栏标题为空?");
    if (type==QHNavSliderMenuTypeTitleAndImage) {
        if(!styleModel.menuImagesNormal) {
            NSAssert(0, @"QHNavSliderMenuTypeTitleAndImage却未传入未选中的显示图片数组?");
        }
        if (!styleModel.menuImagesSelect) {
            NSAssert(0, @"QHNavSliderMenuTypeTitleAndImage却未传入选中时的显示图片数组?");
        }
        
        if(styleModel.menuTitles.count<styleModel.menuImagesNormal.count||styleModel.menuTitles.count<styleModel.menuImagesSelect.count) {
            NSAssert(0, @"标题和图片的数量不一致!");
        }
    }
    
    if (!styleModel.sliderMenuTextColorForNormal) {
        styleModel.sliderMenuTextColorForNormal = QHRGB(140, 140, 140);;
    }
    if (!styleModel.sliderMenuTextColorForSelect) {
        styleModel.sliderMenuTextColorForSelect = YMSBrandColor;
    }
    if (!styleModel.titleLableFont ) {
        styleModel.titleLableFont  = defaultFont(12);
    }
    if (styleModel.menuWidth <=0) {
        styleModel.menuWidth = screenWidth /4.f;
    }
    if (styleModel.menuHorizontalSpacing<=0 ) {
        styleModel.menuHorizontalSpacing = 0.f;
    }
    
    contentScrollView.showsVerticalScrollIndicator   = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.scrollsToTop = NO;
    contentScrollView.bounces = YES;
    contentScrollView.delegate = self;
    contentScrollView.contentSize = CGSizeMake((styleModel.menuWidth+styleModel.menuHorizontalSpacing)*styleModel.menuTitles.count+styleModel.menuHorizontalSpacing, 0);
    
    if (styleModel.sizeToFitScreenWidth||styleModel.sizeInMiddle) {
        contentScrollView.scrollEnabled = NO;
    }
    
    for(int i=0;i<styleModel.menuTitles.count;i++) {
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake((styleModel.menuHorizontalSpacing+styleModel.menuWidth)*i, 0, styleModel.menuWidth, contentScrollView.height)];
        btn.centerY = contentScrollView.height/2.f;
        [btn addTarget:self action:@selector(sliderBtnSelectEvent:) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenHighlighted=NO;
        btn.selected=i==0?YES:NO;
        btn.tag = sliderBtnTagStartPoint+i;//加上初始值防止tag冲突 计算的时候要减去初始值对应row
        [btn setTitle:styleModel.menuTitles[i] forState:UIControlStateNormal];
        [btn setTitle:styleModel.menuTitles[i] forState:UIControlStateSelected];
        
        [btn setTitleColor:styleModel.sliderMenuTextColorForSelect forState:UIControlStateSelected];
        [btn setTitleColor:styleModel.sliderMenuTextColorForNormal forState:UIControlStateNormal];
        btn.titleLabel.font=styleModel.titleLableFont;
        [contentScrollView addSubview:btn];
        
        if(styleModel.sizeToFitScreenWidth) {
            float leftGap = styleModel.menuWidth+70.f;
            btn.centerX = contentScrollView.width /2.f-((int)(styleModel.menuTitles.count/2)-i)*leftGap;
        }
        
        if (styleModel.sizeInMiddle) {
            
            btn.centerX = contentScrollView.width/2.f + (float)(i-(styleModel.menuTitles.count - 1.f)/2.f)*(styleModel.menuWidth + styleModel.menuHorizontalSpacing/2.f);
        }
        
        if (type==QHNavSliderMenuTypeTitleAndImage) {
            [btn setImage:styleModel.menuImagesNormal[i] forState:UIControlStateNormal];
            [btn setImage:styleModel.menuImagesSelect[i] forState:UIControlStateSelected];
            CGRect imgBounds = btn.imageView.bounds;
            UIEdgeInsets imgInsets = UIEdgeInsetsZero;
            UIEdgeInsets titleInsets = UIEdgeInsetsZero;
            imgInsets.bottom = btn.frame.size.height / 2 -10;
            imgInsets.right = (btn.frame.size.width - imgBounds.size.width)/2;
            imgInsets.left = (btn.frame.size.width - imgBounds.size.width)/2;
            titleInsets.top = btn.frame.size.height / 2 ;
            titleInsets.left =-imgBounds.size.width;
            [btn setImageEdgeInsets:imgInsets];
            [btn setTitleEdgeInsets:titleInsets];
        }
        
        
    }
    
    if (menuType==QHNavSliderMenuTypeTitleOnly) {
        
        bottomTabLine=[[UIView alloc] initWithFrame:CGRectMake(styleModel.menuHorizontalSpacing, 0, styleModel.menuWidth, styleModel.lineHeight>0?styleModel.lineHeight:2)];
        bottomTabLine.bottom = contentScrollView.height;
        bottomTabLine.backgroundColor = styleModel.lineColor?styleModel.lineColor:styleModel.sliderMenuTextColorForSelect;
        [contentScrollView addSubview:bottomTabLine];
        
        if (styleModel.sizeToFitScreenWidth) {
            bottomTabLine.left = ((UIButton *)[contentScrollView viewWithTag:0+sliderBtnTagStartPoint]).left;
        }
        
        [self selectAtRow:0 andDelegate:NO];
    }
    
    if (!styleModel.hideViewBottomLineView) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 0.5f)];
        lineView.backgroundColor = YMSLineViewColor;
        self.clipsToBounds = NO;
        [self addSubview:lineView];
        
    }
    
    
}


@end

@implementation QHNavSliderMenuStyleModel

+ (instancetype)menuStyleModelForHome {
    QHNavSliderMenuStyleModel *model       = [QHNavSliderMenuStyleModel new];
    model.sizeToFitScreenWidth             = YES;
    model.hideViewBottomLineView           = YES;
    model.titleLableFont                   = defaultFont(17);
    model.lineHeight                       = 4.f;
    model.sliderMenuTextColorForNormal     = YMSNavTitleColor;
    model.sliderMenuTextColorForSelect     = YMSNavTitleColor;
    model.lineColor                        = YMSBrandColor;
    model.autoSuitLineViewWithdForBtnTitle = YES;
    model.sizeInMiddle                     = YES;
    model.menuHorizontalSpacing            = 40.f;
    
    return model;
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
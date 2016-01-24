//
//  SectionHeadCollectionReusableView.m
//  buy
//
//  Created by dbjyz on 15/12/30.
//  Copyright © 2015年 跟谁买. All rights reserved.
//

#import "SectionHeadCollectionReusableView.h"
#import "UIView+UIBaseAttributeView.h"

@interface SectionHeadCollectionReusableView()
@property(strong, nonatomic)UILabel * titleLabel;

@end

@implementation SectionHeadCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addView];
    }
    return self;
}

-(void)addView{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [_titleLabel SetLabelBaseAttributeLabel:_titleLabel Font:Z20 TextCorlor:C6 BgColor:nil numberOfLines:1 cornerRadius:0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"午餐时间";
    [self addSubview:_titleLabel];
}
@end

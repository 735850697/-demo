//
//  BUYSelectJXCell.m
//  buy
//
//  Created by dbjyz on 15/12/29.
//  Copyright © 2015年 跟谁买. All rights reserved.
//

#import "BUYSelectJXCell.h"
#import "UIView+UIBaseAttributeView.h"
@interface BUYSelectJXCell()
@property(strong, nonatomic)UIImageView * bgImageView;//背景图片
@property(strong, nonatomic)UIView * lineLeftView;//左侧线条
@property(strong, nonatomic)UIView * lineRightView;//右侧线条
@property(strong, nonatomic)UILabel * titleLabel;//标题
@property(strong, nonatomic)UILabel * contentLabel;//内容详情
@end

@implementation BUYSelectJXCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor redColor];
//        [self addView];
        
    }
    return self;
}


-(void)addView{
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.clipsToBounds = YES;
    _bgImageView.image = [UIImage imageNamed:@"默认加载图片"];
    [self addSubview:_bgImageView];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.bounds.size.width, 21)];
    _titleLabel.text = @"圣诞";
    [_titleLabel SetLabelBaseAttributeLabel:_titleLabel Font:Z22 TextCorlor:C10 BgColor:nil numberOfLines:1 cornerRadius:0];
    [_bgImageView addSubview:_titleLabel];
    
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), self.bounds.size.width, 21)];
    [_contentLabel SetLabelBaseAttributeLabel:_contentLabel Font:Z20 TextCorlor:C10 BgColor:nil numberOfLines:1 cornerRadius:0];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = @"圣诞大餐";
    [_bgImageView addSubview:_contentLabel];
    
//    _lineLeftView = [[UILabel alloc] init];
//    _lineLeftView.backgroundColor = [UIColor redColor];
//    [_bgImageView addSubview:_lineLeftView];
//    
//    _lineRightView = [[UIView alloc] init];
//    _lineRightView.backgroundColor = [UIColor redColor];
//    [_bgImageView addSubview:_lineRightView];
    
}

- (void)prepareForReuse

{
    [super prepareForReuse];
    
}

//  重点:防止cell错乱
- (void)layoutSubviews{
    
    [super layoutSubviews];
//    [self addView];
}

-(void)Layout{
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgImageView).with.offset(_bgImageView.bounds.size.height/4);
        make.centerX.equalTo(_bgImageView);
        make.height.mas_equalTo(16);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(_bgImageView);
        make.height.mas_greaterThanOrEqualTo(16);
    }];
    
    [_lineLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabel.mas_left).with.offset(-5);
        make.top.equalTo(_titleLabel).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(10, 1));
    }];
    
    [_lineRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).with.offset(5);
        make.top.equalTo(_titleLabel).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(10, 1));
    }];
    
}


@end

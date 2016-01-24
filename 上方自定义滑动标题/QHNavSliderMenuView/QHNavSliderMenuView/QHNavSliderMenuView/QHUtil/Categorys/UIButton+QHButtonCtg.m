//
//  UIButton+QHButtonCtg.m
//  yimashuo
//
//  Created by imqiuhang on 15/8/17.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "UIButton+QHButtonCtg.h"

@implementation UIButton (QHButtonCtg)

- (void)setTitle:(NSString *)aTitle andFont:(UIFont *)aFont andTitleColor:(UIColor *)textColor andBgColor:(UIColor *)bgColor andRadius:(float)radius {
    [self setTitle:aTitle forState:UIControlStateNormal];
    self.titleLabel.font = aFont;
    [self setTitleColor:textColor forState:UIControlStateNormal];
    if (bgColor) {
        self.backgroundColor = bgColor;
    }
    
    if (radius>0) {
        self.layer.cornerRadius = radius;
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
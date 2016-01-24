//
//  buttonView.m
//  cell
//
//  Created by dbjyz on 15/8/28.
//  Copyright (c) 2015年 dbjyz. All rights reserved.
//

#import "buttonView.h"

@interface buttonView ()

@property (nonatomic, strong) UIButton * numLabel;

@property (nonatomic, strong) UIButton * textLabel;

@end


@implementation buttonView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       // self.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 50);
    }
    return self;
}



//生成按钮
-(UIView *)getButton:(NSInteger)index :(NSString *)numTitle :(NSString *)textTitle :(CGRect)frame{
   
    self.frame = frame;
    _numLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_numLabel setTitle:numTitle forState:UIControlStateNormal];
    _numLabel.frame = CGRectMake(0, 0, self.frame.size.width, 20);
    _numLabel.tag = index;
    [_numLabel addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_numLabel];
    
    
    _textLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _textLabel.frame = CGRectMake(0, 20, self.frame.size.width, 30);
    [_textLabel setTitle:textTitle forState:UIControlStateNormal];
    _textLabel.tag = index;
    [_textLabel addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_textLabel];

    return self;
}


-(void)dianji:(UIButton *)btn{
    
    [self.delegate ClickBtn:btn.tag];

}


@end

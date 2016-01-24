//
//  DBSelectView.m
//  danbai_client_ios
//
//  Created by 赵璞 on 15/8/5.
//  Copyright (c) 2015年 db. All rights reserved.
//

#import "DBSelectView.h"

@interface DBSelectView ()

@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIButton *button2;

//记录当前被选中的按钮
@property (nonatomic, weak) UIButton *nowSelectedBtn;
@end

@implementation DBSelectView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.button1.frame = CGRectMake(0, 0, 160, 36);

    [self.button1 setBackgroundImage:[UIImage imageNamed:@"tab_left_default"] forState:UIControlStateNormal];
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"tab_left_selected"] forState:UIControlStateSelected];
    
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.button2.frame = CGRectMake(0, 0, 160, 36);
    
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"tab_right_default"] forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"tab_right_selected"] forState:UIControlStateSelected];
    

    [self.button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.button2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    
}

//＊＊＊＊＊＊＊＊＊＊懒加载＊＊＊＊＊＊＊＊＊＊＊＊＊＊
//设置button的坐标
-(void)setTitle_one:(NSString *)title_one{
    _title_one = title_one;
    
    //调用方法
    [self addBtnToView:self.button1 title:self.title_one tag:10];
    
}

-(void)setTitle_two:(NSString *)title_two{
    _title_two = title_two;
    [self addBtnToView:self.button2 title:self.title_two tag:11];
}


//在view上添加button
- (void)addBtnToView:(UIButton *)btn title:(NSString *)title tag:(NSInteger)tag
{

    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:DBTextThemeColor forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [self addSubview:btn];
    
}

//便利构造方法
+ (instancetype)selectView;
{
    DBSelectView *selectView = [[self alloc] init];

    return selectView;
}

//设置控件的frame   怎么调用的？？？？
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewH = self.bounds.size.height;
    CGFloat viewW = self.bounds.size.width;
    CGFloat btnW = (viewW - 26)/2;
    CGFloat btnH = viewH;
    //计算间距
    CGFloat margin = 12;
    
    self.button1.frame = CGRectMake(margin, 0, btnW, btnH);
    self.button2.frame = CGRectMake(margin + btnW , 0, btnW, btnH);
    
}

#pragma mark - 按钮的Action
- (void)btnClick:(UIButton *)sender
{
    
    if (self.nowSelectedBtn == sender) return;
    
    for (int i = 10; i < 12 ; i++) {
        //根据tag 获取到其他的button
        UIButton *btn = (UIButton *)[self viewWithTag:i];
        // 判断点击的是哪个button
        if (btn.tag == [(UIButton *)sender tag] && !btn.selected) {
            //选中
            btn.selected = !btn.isSelected;
        }else{
            //非选中
            btn.selected = NO;
        }
    }
    
    
    //通知代理点击
    if ([self.delegate respondsToSelector:@selector(selectView:didSelectedButtonFrom:to:)]) {
        [self.delegate selectView:self didSelectedButtonFrom:self.nowSelectedBtn.tag to:sender.tag];
    }
    
    self.nowSelectedBtn = sender;
}

//有代理时，点击按钮  是怎么执行的？？？
- (void)setDelegate:(id<DBSelectViewDelegate>)delegate
{
    _delegate = delegate;
    
    [self btnClick:self.button1];
}


- (void)lineToIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(selectView:didChangeSelectedView:)]) {
                [self.delegate selectView:self didChangeSelectedView:10];
            }
            self.button1.selected = YES;
            self.button2.selected = NO;
            self.nowSelectedBtn = self.button1;
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(selectView:didChangeSelectedView:)]) {
                [self.delegate selectView:self didChangeSelectedView:11];
            }
            self.button1.selected = NO;
            self.button2.selected = YES;
            self.nowSelectedBtn = self.button2;
            break;
        default:
            break;
    }
}



@end

//
//  YFComponent.m
//  iOS122
//
//  Created by 颜风 on 15/10/14.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import "YFComponent.h"
@interface YFComponent ()
@end

@implementation YFComponent
@dynamic virtualModel;
@synthesize model = _model;

- (instancetype)init
{
    self = [super init];
    
    if (nil != self) {
        [self mcSetup: NO];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    
    if (nil != self) {
        [self mcSetup: NO];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (nil != self) {
        [self mcSetup: YES];
    }
    
    return self;
}

/**
 *  是否从xib初始化此类.
 *
 *  @param isFromXib 是否从xib或sb初始化此类.
 *
 *  注意: 无论此类是否从xib或sb初始化,组件内部都将从xib文件初始化.
 *
 *  @return 实例对象.
 */
- (instancetype) mcSetup: (BOOL) isFromXib
{
    UIView * contentView = [[[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options:nil] firstObject];
    self.contentView = contentView;
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 这一句,是区别初始化方式后的,核心不同.
    self.translatesAutoresizingMaskIntoConstraints = ! isFromXib;
    
    [self addSubview: contentView];
    
    self.backgroundColor = contentView.backgroundColor;
    
    if (nil == self.backgroundColor) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeLeft multiplier: 1.0 constant: 0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeRight multiplier: 1.0 constant: 0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeTop multiplier: 1.0 constant: 0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem: contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeBottom multiplier: 1.0 constant: 0]];
    
    [self setup];
    
    return self;
}


- (void)setup
{
    /* 子类需要继承此方法,以完成自定义初始化操作. */
}

- (void)reloadData
{
    /* 子类根据需要,自行实现. */
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


- (void)back
{
    if (nil != self.viewController.navigationController) {
        [self.viewController.navigationController popViewControllerAnimated: YES];
    }
    else{
        [self.viewController  dismissViewControllerAnimated: YES completion:NULL];
    }
}

- (NSLayoutConstraint *)heightContronstraint
{
    __block NSLayoutConstraint * heightCons = nil;
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * obj, NSUInteger idx, BOOL *stop) {
        if (NSLayoutAttributeHeight == obj.firstAttribute && nil == obj.secondItem && [obj.firstItem isEqual: self]) {
            heightCons = obj;
            
            * stop = YES;
        }
    }];
    
    
    return heightCons;
}

+ (instancetype)sharedInstance
{
    /* 子类应根据需要重写这个方法. */
    return nil;
}

- (id)virtualModel
{
    return nil;
}

- (void)setModel:(id)model
{
    _model = model;
    
    // 更新视图.
    [self updateView];
}

- (id)model
{
    id model = _model;
    
    if(YES == self.isTest){
        model = self.virtualModel;
    }
    
    return model;
}

- (void)updateView
{
    /*子类应根据需要重写此方法.默认不做任何处理.*/
}


- (BOOL)isTest
{
    /* 子类应根据自己需要,重写这个方法. */
    return NO;
}
@end

//
//  YFComponent.h
//  iOS122
//
//  Created by 颜风 on 15/10/14.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  可复用组件.用于编写可嵌套的 xib 组件.
 *
 *  适用场景: 需要静态确定布局的页面内的UI元素的复用性问题.
 *  使用方法: 在xib或storyboard中,将某一用于占位的view的 custom class 设为对一个的 component, 则初始化时,会自动使用此component对应的xib文件中的内容去替换对应位置.
 *  注意: 对于可动态确定布局的部分,如tableView中的cell,直接自行从xib初始化即可,不必继承于 MCComponent.
 */
@interface YFComponent : UIView

@property (strong, nonatomic) UIView * contentView; //!< 真正的内容视图.
@property (weak, nonatomic, readonly) UIViewController * viewController; //!< 当前视图所在的控制器.
@property (weak, nonatomic, readonly)NSLayoutConstraint * heightContronstraint; //!< 高度的约束.不存在,则返回nil.
@property (strong, nonatomic) id virtualModel; //!< 虚拟model.用于测试.默认返回nil.当不为nil,优先使用它.
@property (strong, nonatomic)  id model; //!< 视图数据模型.内部会自动根据virtualModel的值,进行不同的处理.
@property (assign, nonatomic, readonly) BOOL isTest; //!< 是否是测试.如果是,将优先使用 virtualModel来替换model.系统内部处理.默认为NO.

/**
 *   初始化.
 *
 *   子类需要继承此方法,以完成自定义初始化操作. 不要手动调用此方法.
 */
- (void)setup;

/**
 *  重新加载数据.
 *
 *  子类可根据需要,具体实现此方法.
 */
- (void)reloadData;


/**
 *  返回上一级.
 */
- (void) back;

/**
 *  便利构造器.子类应根据需要重写.
 *
 *  @return 默认返回self.
 */
+ (instancetype)sharedInstance;

/**
 *  更新视图.
 *
 *  子类应根据需要重写此方法.默认不做任何处理.
 */
- (void) updateView;

@end


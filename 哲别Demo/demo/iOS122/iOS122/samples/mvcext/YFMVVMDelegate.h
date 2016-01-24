//
//  YFMVVMDelegate.h
//  iOS122
//
//  Created by 颜风 on 15/10/13.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol YFMVVMRequestDelegate;



/**
 *  MVVM协议,用于规定MVVM模式的基本约定.
 *
 *  常用于约定"V",此处的V,指的是视图的载体,或者是连接点.可以是一个View,也可以是一个控制器,或者任意NSObject对象.
 */
@protocol YFMVVMDelegate <NSObject>

@required
@property (nonatomic, strong) id model; //!< 数据模型,用于表示从外部传入的数据.
@property (nonatomic, strong, readonly) id viewModel; //!< 数据模型,用于表示直接在视图上显示的数据模型.

@optional
@property (nonatomic, strong) id<YFMVVMRequestDelegate> request; //!< 网络请求.用于联网动态更新数据.

@end

/**
 *  用于规定MVVM中的request网络请求的协议.
 */
@protocol YFMVVMRequestDelegate <NSObject>

@required

/**
 *  获取数据.
 *
 *  @param component   MVVM组件中的V部分,可以是一个View,也可以是一个控制器,或者任意NSObject对象.
 *  @param success     请求成功时的回调.会把视图模型回调出去.
 *  @param failure     请求失败时的回调.会把错误信息回调出去.
 */
-(void) get: (id<YFMVVMDelegate>) component
    success: (void (^)(id))success
    failure:(void (^)(NSError *))failure;

@optional

/**
 *  重置页码,从头刷新.
 *
 *  下次调用 get:success:failure 方法时,会获取最新的数据.
 */
-(void) reset;

/**
 *  移动到下一页.
 *
 *  下次调用 get:success:failure 方法时,会获取下一页的数据.
 */
-(void) nextPage;

@end
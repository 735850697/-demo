//
//  KSCache.h
//  KSNetRequestDemo
//
//  Created by KS on 15/11/27.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSCache : NSObject

/**
 *  清除缓存
 */
+ (BOOL)cleanCache;

/**
 *  插入缓存
 *
 *  @param object  json对象
 *  @param primary 请求URL
 */
+ (void)updateObject:(nonnull id)object withURL:(nonnull NSString*)primary parameter:(nullable id)parameter;

/**
 *  读取缓存
 *
 *  @param primary   请求url
 *  @param parameter 请求参数
 *
 *  @return nil
 */
+ (nullable id)selectObjectWithURL:(nonnull NSString*)primary parameter:(nullable id)parameter;

@end

//
//  YFBlogListItemViewModel.h
//  iOS122
//
//  Created by 颜风 on 15/10/22.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YFArticleModel;

/**
 *  用于博客列表,单个单元格的视图模型.
 */
@interface YFBlogListItemViewModel : NSObject
@property (copy, nonatomic) NSString * blogId; //!< 文章id.
@property (copy, nonatomic) NSString * intro; //!< 用于显示的文章介绍.

/**
 *  便利构造器,方便从YFArticleModel初始化.
 *
 *  @param model 文章模型.
 *
 *  @return 类实例对象.
 */
- (instancetype)initWithArticleModel: (YFArticleModel *) model;

@end

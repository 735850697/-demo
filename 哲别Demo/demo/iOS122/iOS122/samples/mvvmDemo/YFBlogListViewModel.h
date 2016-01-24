//
//  YFBlogListViewModel.m
//  iOS122
//
//  Created by 颜风 on 15/10/21.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>


@class YFCategoryArticleListModel;


/**
 *  文章列表的视图模型.
 */
@interface YFBlogListViewModel : NSObject
@property (copy, nonatomic) NSArray * blogListItemViewModels; //!< 文章.内部存储的应为文章列表单元格的视图模型.注意: 刷新操作,存储第一页数据;翻页操作,将存储所有的数据,并按页面排序.

/**
 *  使用一个分类文章列表数据模型来快速初始化.
 *
 *  @param model 文章列表模型.
 *
 *  @return 实例对象.
 */


- (instancetype)initWithCategoryArtilceListModel: (YFCategoryArticleListModel *) model;

/**
 *  获取首页的数据.常用于下拉刷新.
 *
 */
- (void)first;

/**
 *  翻页,获取下一页的数据.常用于上拉加载更多.
 */
- (void)next;


@end

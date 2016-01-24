//
//  YFCategoryArticleListModel.h
//  iOS122
//
//  Created by 颜风 on 15/10/21.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  分类文章列表.
 */
@interface YFCategoryArticleListModel : NSObject
@property (copy, nonatomic) NSString * category; //!< 分类
@property (strong, nonatomic) NSArray * articles; //!< 此分类下的文章列表.

@end

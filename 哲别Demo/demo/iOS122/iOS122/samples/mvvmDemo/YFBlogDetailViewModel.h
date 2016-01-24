//
//  YFBlogDetailViewModel
//  iOS122
//
//  Created by 颜风 on 15/10/21.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFArticleModel;

/**
 *  文章详情的视图模型.
 */

@interface YFBlogDetailViewModel : NSObject
@property (copy, nonatomic) NSString * content; // 要显示的内容.
@property (copy, nonatomic) NSString * blogId; //!< 博客ID.

- (instancetype)initWithModel: (YFArticleModel *) model;

@end

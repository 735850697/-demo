//
//  YFArticleModel.h
//  iOS122
//
//  Created by 颜风 on 15/10/14.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface YFArticleModel : NSObject
@property (strong, nonatomic) NSString * id; //!< 文章唯一标识.
@property (copy, nonatomic) NSString * title; //!< 文章标题.
@property (copy, nonatomic) NSString * desc; //!< 文章简介.
@property (copy, nonatomic) NSString * body; //!< 文章详情.

@end

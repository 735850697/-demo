//
//  YFPostModel.h
//  iOS122
//
//  Created by 颜风 on 15/10/28.
//  Copyright © 2015年 iOS122. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

/**
 *  文章.
 */
@interface YFPostModel : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString * postId; //!< 文章唯一标识.
@property (copy, nonatomic) NSString * title; //!< 文章标题.
@property (copy, nonatomic) NSString * desc; //!< 文章简介.
@property (copy, nonatomic) NSString * body; //!< 文章详情.

@end

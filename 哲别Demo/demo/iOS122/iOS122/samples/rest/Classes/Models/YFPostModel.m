//
//  YFPostModel.m
//  iOS122
//
//  Created by 颜风 on 15/10/28.
//  Copyright © 2015年 iOS122. All rights reserved.
//

#import "YFPostModel.h"

@implementation YFPostModel

/**
 *  用于指定模型属性与JSON数据字段的对应关系.
 *
 *  @return 模型属性与JSON数据字段的对应关系:以模型属性为键,JSON字段为值.
 */

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary * dictMap = @{
                               @"postId": @"objectId",
                               @"title": @"title",
                               @"desc": @"desc",
                               @"body": @"body"
                               };
    
    return dictMap;
}

@end

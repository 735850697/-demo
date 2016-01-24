//
//  YFUserModel.m
//  iOS122
//
//  Created by 颜风 on 15/10/29.
//  Copyright © 2015年 iOS122. All rights reserved.
//

#import "YFUserModel.h"

@implementation YFUserModel
/**
 *  用于指定模型属性与JSON数据字段的对应关系.
 *
 *  @return 模型属性与JSON数据字段的对应关系:以模型属性为键,JSON字段为值.
 */

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary * dictMap = @{
                               @"name": @"username",
                               @"token": @"sessionToken"
                               };
    
    return dictMap;
}

@end

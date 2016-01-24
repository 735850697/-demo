//
//  YFUserModel.h
//  iOS122
//
//  Created by 颜风 on 15/10/29.
//  Copyright © 2015年 iOS122. All rights reserved.
//

#import <Mantle/Mantle.h>

/**
 *  用户.
 */
@interface YFUserModel : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic) NSString * name; // 用户名称.
@property (copy, nonatomic) NSString * token; // TOKEN值,登录成功后,可以获取.

@end

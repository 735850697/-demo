//
//  YFAPIManager.h
//  iOS122
//
//  Created by 颜风 on 15/10/28.
//  Copyright © 2015年 iOS122. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@class RACSignal, YFUserModel;

@interface YFAPIManager : AFHTTPRequestOperationManager

@property (strong, nonatomic) YFUserModel * user; //!< 当前登录的用户,可能为nil.
@property (assign, nonatomic, readonly) BOOL isAuthenticated; //!< 是否已经登录.

/**
 *  一个单例.
 *
 *  @return 共享的实例对象.
 */
+ (instancetype) sharedInstance;

@end

/**
 *  用户信息相关的操作.
 */
@interface YFAPIManager (User)


/**
 *  用户登录.
 *
 *  获取到用户数据后,会自动更新User属性,所以仅需要在必要的地方观察user属性即可.
 *
 *  @param username 用户名.
 *  @param password 用户密码.
 *
 *  @return RACSingal对象,sendNext的是此类的的单例实例.
 */
- (RACSignal *)signInUsingUsername:(NSString *)username passowrd:(NSString *)password;

/**
 *  登出.
 *
 *  登出,其实就是把 user 属性设为nil.
 *
 *  @return sendNext为此类的单例实例.
 */
- (RACSignal *) logout;

@end

/**
 *  文章相关操作.
 */
@interface YFAPIManager (Post)

/**
 *  获取文章详情.
 *
 *  @param postId 文章id.
 *
 *  @return sendNext为获取到的文章数据模型.
 */
- (RACSignal *) fetchPostDetail: (NSString *) postId;

@end
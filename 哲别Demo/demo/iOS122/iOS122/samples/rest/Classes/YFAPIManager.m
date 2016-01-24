//
//  YFAPIManager.m
//  iOS122
//
//  Created by 颜风 on 15/10/28.
//  Copyright © 2015年 iOS122. All rights reserved.
//

#import "YFAPIManager.h"
#import <AFNetworking.h>
#import <ReactiveCocoa.h>
#import <CommonCrypto/CommonDigest.h>
#import <RACAFNetworking.h>
#import <Aspects.h>
#import "YFUserModel.h"
#import "YFPostModel.h"

/* API相关常量. */
NSString * const API_CLIENT_ID = @"8XUotkNh3zt0VXkdL9UwV4Ca"; //!< 对应LeanCloud控制台的App ID.
NSString * const API_CLIENT_SECRET = @"Xam5LnvBDwHdTVeoeG7T7Mvb"; //!< 对应 LeanCloud控制台的Master Key
NSString * const API_BASE_URL = @"https://leancloud.cn/1.1/"; //!< 对应 LeanCloud Rest API 接口基地址.


/**
 请求方式.
 */
typedef enum : NSUInteger {
    YFAPIManagerMethodGet,
    YFAPIManagerMethodPost,
    YFAPIManagerMethodPut,
    YFAPIManagerMethodDelete,
    YFAPIManagerMethodPatch
} YFAPIManagerMethod;


/**
 *  私有扩展,其他网路请求的基础.
 */
@interface YFAPIManager (Private)

/**
 *  内部统一使用这个方法来向服务端发送请求
 *
 *  @param method       请求方式.
 *  @param relativePath 相对路径.
 *  @param parameters   参数.
 *  @param resultClass  从服务端获取到JSON数据后，使用哪个Class来将JSON转换为OC的Model.此类应继承自MTLModel,并遵守 <MTLJSONSerializing> 协议.
 *
 *  @return RACSignal 信号对象.sendNext返回的是转换后的Model.
 */
- (RACSignal *)requestWithMethod:(YFAPIManagerMethod)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;

@end

@interface YFAPIManager ()
@property (copy, nonatomic, readonly) NSString * apiClientId; //!< 客户端id,默认直接返回API_CLIENT_ID.
@property (copy, nonatomic, readonly) NSString * apiClientSecret; //!< 此处返回的是加密后的可直接用于网络请求签权的Key,形如: sign,timestamp[,master] 其中sign为将 timestamp 加上 App key（或者 master key）组成的字符串，在对它做 MD5 签名后的结果;timestamp为客户端产生本次请求的 unix 时间戳，精确到毫秒;字符串 "master"，当使用 master key 签名请求的时候，必须加上这个后缀明确说明是使用 master key.此为LeanCloud要求的加密鉴权方式,详见: https://leancloud.cn/docs/rest_api.html#更安全的鉴权方式

@end


@implementation YFAPIManager


+ (instancetype)sharedInstance
{
    static YFAPIManager * manager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[YFAPIManager alloc] initWithBaseURL: [NSURL URLWithString: API_BASE_URL]];
    });
    
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL: url];
    
    if (nil != self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // 设置超时和缓存策略.
        [self.requestSerializer aspect_hookSelector:@selector(requestWithMethod:
                                                              URLString:
                                                              parameters:
                                                              error:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>info){
            /* 在方法调用后,来获取返回值,然后更改其属性. */
            // __autoreleasing 关键字是必须的,默认的 __strong,会引起后续代码的野指针崩溃.
            __autoreleasing NSMutableURLRequest *  request = nil;
            
            NSInvocation *invocation = info.originalInvocation;

            [invocation getReturnValue: &request];
            
            if (nil != request) {
                request.timeoutInterval = 30;
                request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                
                [invocation setReturnValue: &request];
            }
        }error: NULL];
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [self.requestSerializer setValue: self.apiClientId forHTTPHeaderField: @"X-LC-Id"];
        
        @weakify(self);
        
        // 每次发送请求前,都需要更新一下 请求头中的 apiClientSecret,因为它是时间戳相关的.
        [self aspect_hookSelector:NSSelectorFromString(@"rac_requestPath:parameters:method:") withOptions:AspectPositionBefore usingBlock:^{
            @strongify(self);
            
            [self.requestSerializer setValue: self.apiClientSecret forHTTPHeaderField: @"X-LC-Sign"];
            
        } error:NULL];
        
        // 每次用户数据更新时,都需要重新设置下请求头中的token值.
        [RACObserve(self, user) subscribeNext:^(YFUserModel * user) {
            @strongify(self);
            
            [self.requestSerializer setValue:user.token forHTTPHeaderField: @"X-LC-Session"];
        }];
        
        // 设置isAuthenticated.
        RAC(self, isAuthenticated) = [RACSignal combineLatest:@[RACObserve(self, user)] reduce:^id{
            @strongify(self);
            
            BOOL isLogin = YES;
            
            if (nil == self.user || nil == self.user.token) {
                isLogin = NO;
            }
            
            return [NSNumber numberWithBool: isLogin];
        }];
    }
    
    return self;
}

- (NSString *)apiClientId
{
    return API_CLIENT_ID;
}

- (NSString *)apiClientSecret
{
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970] * 1000; //!< 精确到毫秒.此处的精度损失,是预期行为.
    
    NSString * sign = [NSString stringWithFormat:@"%ld%@", (long)timestamp, API_CLIENT_SECRET];
    
    sign = [self md5Str:sign isLower: YES];
    
    NSString * apiClientSecret = [NSString stringWithFormat: @"%@,%ld,master", sign, (long)timestamp];
    
    return apiClientSecret;
}

/**
 *  将字符串md5加密,并返回加密后的结果.
 *
 *  @param originalStr 原始字符串.
 *  @param lower       是否返回小写形式: YES,返回全小写形式;NO,返回全大写形式.
 *
 *  @return md5 加密后的结果.
 */
- (NSString *) md5Str: (NSString *) originalStr isLower: (BOOL) lower
{
    const char *original = [originalStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original, (CC_LONG)strlen(original), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    NSString * md5Result = [hash lowercaseString];
    
    if (NO == lower) {
        md5Result = [md5Result uppercaseString];
    }
    
    return md5Result;
}



@end

@implementation YFAPIManager (Private)

- (RACSignal *)requestWithMethod:(YFAPIManagerMethod)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass
{
    RACSignal * signal = nil;
    
    if (method == YFAPIManagerMethodGet) {
        signal = [self rac_GET:relativePath parameters:parameters];
    }
    
    if (method == YFAPIManagerMethodPut) {
        signal = [self rac_PUT:relativePath parameters:parameters];
    }
    
    if (method == YFAPIManagerMethodPost) {
        signal = [self rac_POST:relativePath parameters:parameters];
    }
    
    if (method == YFAPIManagerMethodPatch) {
        signal = [self rac_PATCH:relativePath parameters:parameters];
    }
    
    if (method == YFAPIManagerMethodDelete) {
        signal = [self rac_DELETE:relativePath parameters:parameters];
    }
    
    return [[signal reduceEach:^id(NSDictionary *response){
        id responseModel = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:response error:NULL];
        
        return responseModel;
    }]replayLazily];
}

@end

@implementation YFAPIManager (User)

- (RACSignal *)signInUsingUsername:(NSString *)username passowrd:(NSString *)password
{
    NSDictionary *parameters = @{
                                 @"username": username,
                                 @"password": password,
                                 };
    
    // 需要配对使用@weakify 与 @strongify 宏,以防止block内的可能的循环引用问题.
    @weakify(self);
    
    return [[[[self rac_GET:@"login" parameters:parameters]
               // reduceEach的作用是传入多个参数，返回单个参数，是基于`map`的一种实现
               reduceEach:^id(NSDictionary *response){
                   @strongify(self);
                   
                   YFUserModel * user = [MTLJSONAdapter modelOfClass:[YFUserModel class] fromJSONDictionary: response error: NULL];
                   
                   self.user = user;
                   
                   return self;
               }]
              // 避免side effect,有点类似于 "懒加载".
              replayLazily]
            setNameWithFormat:@"%@ -signInUsingUsername: %@, password: %@",self.class, username, password];
}

- (RACSignal *)logout
{
    @weakify(self);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        self.user = nil;
        
        [subscriber sendNext: self];
        [subscriber sendCompleted];
        
        return nil;
    }] setNameWithFormat:@"%@ -logout", self.class];
}
@end

@implementation YFAPIManager (Post)

- (RACSignal *)fetchPostDetail:(NSString *)postId
{
    return [[self requestWithMethod:YFAPIManagerMethodGet relativePath:[NSString stringWithFormat:@"classes/Post/%@", postId] parameters:nil resultClass: [YFPostModel class]] setNameWithFormat: @"%@ -fetchPostDetail: %@", self.class, postId];
}

@end


//
//  YFBlogDetailViewModel.m
//  iOS122
//
//  Created by 颜风 on 15/10/21.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import "YFBlogDetailViewModel.h"
#import <ReactiveCocoa.h>
#import "YFArticleModel.h"
#import <RACAFNetworking.h>
#import <MJExtension.h>

@interface YFBlogDetailViewModel ()
@property (strong, nonatomic) AFHTTPRequestOperationManager * httpClient;
@property (copy, nonatomic) NSString * requestPath; //!< 完整接口地址.

@end
@implementation YFBlogDetailViewModel

- (instancetype)init
{
    self = [self initWithModel: nil];
    
    return self;
}

- (instancetype)initWithModel:(YFArticleModel *)model
{
    self = [super init];
    
    if (nil != self) {
        // 设置self.blogId与model.id的相互关系.
        [RACObserve(model, id) subscribeNext:^(id x) {
            self.blogId = x;
        }];
        
        [self setup];
    }
    
    return self;
}

/**
 *  公共的与Model无关的初始化.
 */
- (void)setup
{
    // 初始化网络请求相关的信息.
    self.httpClient = [AFHTTPRequestOperationManager manager];
    self.httpClient.requestSerializer = [AFJSONRequestSerializer serializer];
    self.httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 接口完整地址,肯定是受id影响.
    [RACObserve(self, blogId) subscribeNext:^(NSString * blogId) {
        NSString * path = [NSString stringWithFormat: @"http://www.ios122.com/find_php/index.php?viewController=YFPostViewController&model[id]=%@", blogId];
        
        self.requestPath = path;
    }];
    
    // 每次完整的数据接口变化时,必然要同步更新 self.content 的值.
    [RACObserve(self, requestPath) subscribeNext:^(NSString * path) {
        [[self.httpClient rac_GET:path parameters:nil] subscribeNext:^(RACTuple *JSONAndHeaders) {
            // 使用MJExtension将JSON转换为对应的数据模型.
            YFArticleModel * model = [YFArticleModel objectWithKeyValues:JSONAndHeaders.first];
           
            self.content = model.body;
        }];
    }];
}

@end

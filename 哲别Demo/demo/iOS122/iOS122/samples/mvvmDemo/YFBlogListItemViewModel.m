//
//  YFBlogListItemViewModel.m
//  iOS122
//
//  Created by 颜风 on 15/10/22.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import "YFBlogListItemViewModel.h"
#import <ReactiveCocoa.h>
#import "YFArticleModel.h"

@implementation YFBlogListItemViewModel

- (instancetype)initWithArticleModel:(YFArticleModel *)model
{
    self = [super init];
    
    if (nil != self) {
        // 设置intro属性和model的属性的级联关系.
        RAC(self, intro) = [RACSignal combineLatest:@[RACObserve(model, title), RACObserve(model, desc)] reduce:^id(NSString * title, NSString * desc){
            NSString * intro = [NSString stringWithFormat: @"标题:%@ 内容:%@", model.title, model.desc];
            
            return intro;
        }];
        
        // 设置self.blogId与model.id的相互关系.
        [RACObserve(model, id) subscribeNext:^(id x) {
            self.blogId = x;
        }];
    }
    
    return self;
}
@end

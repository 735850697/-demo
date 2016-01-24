//
//  YFMVVMPostViewController.m
//  iOS122
//
//  Created by 颜风 on 15/10/21.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import "YFMVVMPostViewController.h"
#import "YFBlogDetailViewModel.h"
#import <ReactiveCocoa.h>

@interface YFMVVMPostViewController ()
@property (strong, nonatomic) UIWebView * webView;
@end

@implementation YFMVVMPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [RACObserve(self.viewModel, content) subscribeNext:^(id x) {
        [self updateView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIWebView *)webView
{
    if (nil == _webView) {
        _webView = [[UIWebView alloc] init];
        
        [self.view addSubview: _webView];
        
        [_webView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    
    return _webView;
}

/**
 * 更新视图.
 */
- (void) updateView
{
    [self.webView loadHTMLString: self.viewModel.content baseURL:nil];
}

@end

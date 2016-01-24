//
//  YFMVCPostViewController.m
//  iOS122
//
//  Created by 颜风 on 15/10/16.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import "YFMVCPostViewController.h"
#import "YFArticleModel.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>


@interface YFMVCPostViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView * webView;
@property (strong, nonatomic) YFArticleModel * article;
@end

@implementation YFMVCPostViewController

- (UIWebView *)webView
{
    if (nil == _webView) {
        _webView = [[UIWebView alloc] init];
        
        [self.view addSubview: _webView];
        
        [_webView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
    }
    
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self updateData];
}


/**
 * 更新视图.
 */
- (void) updateView
{
    [self.webView loadHTMLString: self.article.body baseURL:nil];
}

/**
 *  更新数据.
 *
 *  数据更新后,会自动更新视图.
 */

- (void)updateData
{
    [MBProgressHUD showHUDAddedTo:self.view animated: YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString * urlStr = [NSString stringWithFormat: @"http://www.ios122.com/find_php/index.php?viewController=YFPostViewController&model[id]=%@", self.articleID];
    
    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.article = [YFArticleModel objectWithKeyValues: responseObject];
        
        [self updateView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
    }];
}


@end

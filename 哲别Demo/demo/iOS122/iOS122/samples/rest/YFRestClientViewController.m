//
//  YFRestClientViewController.m
//  iOS122
//
//  Created by 颜风 on 15/10/29.
//  Copyright © 2015年 iOS122. All rights reserved.
//

#import "YFRestClientViewController.h"
#import "YFAPI.h"
#import <ReactiveCocoa.h>

@interface YFRestClientViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation YFRestClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 测试账户 testuser1 & testpwd1.
    [[YFAPIManager sharedInstance] signInUsingUsername:@"testuser1" passowrd:@"testpwd1"];
    
    [[[YFAPIManager sharedInstance] fetchPostDetail: @"56308138e4b0feb4c8ba2a34"] subscribeNext:^(YFPostModel * x) {
        NSLog(@"%@", x.body);
        
        [self.webView loadHTMLString:x.body baseURL:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

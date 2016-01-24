//
//  ViewController.m
//  06-倒计时Demo
//
//  Created by zkx on 15/12/3.
//  Copyright © 2015年 zkx. All rights reserved.
//

#import "ViewController.h"
#import "CountDownServer.h"

#define kCountDownForVerifyCode @"CountDownForVerifyCode"

@interface ViewController ()

//按钮
@property (nonatomic,strong) UIButton *button;

// 文字
@property (nonatomic,strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 100, 80, 40)];
    self.button.backgroundColor = [UIColor blueColor];
    self.button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-120, 40)];
    self.textField.textColor = [UIColor redColor];
    //显示边框
    self.textField.layer.borderWidth = 2;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textField.layer.masksToBounds = YES;
    
    self.textField.layer.cornerRadius = 5;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.placeholder = @"请输入验证码";
    [self.view addSubview:self.textField];
    
    //点击按钮触发事件
    [self.button addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    //通知中心监测通知事件
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(countDownUpdate:) name:@"CountDownUpdate" object:nil];
    
}

//点击按钮事件
- (void)btnPressed
{
    [CountDownServer startCountDown:30 identifier:kCountDownForVerifyCode];
    
}


//接收到通知实现的方法
- (void)countDownUpdate:(NSNotification *)noti
{
    NSString *identifier = [noti.userInfo objectForKey:@"CountDownIdentifier"];
    if ([identifier isEqualToString:kCountDownForVerifyCode]) {
        NSNumber *n = [noti.userInfo objectForKey:@"SecondsCountDown"];
        
        [self performSelectorOnMainThread:@selector(updateVerifyCodeCountDown:) withObject:n waitUntilDone:YES];
    }
}

- (void)updateVerifyCodeCountDown:(NSNumber *)num{
    if ([num integerValue] == 0){
       self.textField.placeholder = @"请输入验证码";
        
        self.button.enabled = YES;
    }else{
        self.textField.placeholder = [NSString stringWithFormat:@"%@秒后可重新获取",num];
        self.button.enabled = NO;
    }
}





@end

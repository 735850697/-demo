//
//  ContentView.m
//  FDAlertViewDemo
//
//  Created by fergusding on 15/5/26.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "ContentView.h"
#import "FDAlertView.h"
//#import "MBProgressHUD.h"


@interface ContentView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation ContentView


// 初始化时加载xib文件
-(void)awakeFromNib{
    _phoneTextField.delegate = self;
    _codeTextField.delegate  = self;
    
}

//获取验证码
- (IBAction)getCode:(UIButton *)sender {
//        //验证是不是手机号validateMobile
//        if(![[NSString stringWithFormat:@"%@",_phoneTextField.text] validateMobile]){
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"请输入正确的手机号码";
//            hud.margin = 10.f;
//            hud.removeFromSuperViewOnHide = YES;
//            
//            [hud hide:YES afterDelay:3];
//            
//            return;
//        }
//        
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"phone"] = _oneCell.phoneTextField.text;
//        params[@"verificationMethod"] = @"0";
//        
//        [RequestData getVerificationWithParams:params success:^(id json) {
//            debugLog(@"获取验证码 %@",json);
//            NSString *code = [json objectForKey:@"code"];
//            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeCustomView;
//            
//            if ([code isEqualToString:@"0"]) {
//                [self timer];
//                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//                hud.labelText = @"发送成功";
//            }else {
//                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//                hud.labelText = @"发送失败";
//            }
//            
//            [hud show:YES];
//            [hud hide:YES afterDelay:2];
//        } failure:^(NSError *error) {
//            debugLog(@"获取验证码  %@",error);
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"验证码发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//            
//        }];
}

#pragma mark 设置定时器
/*-(void)timer{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示
                [_oneCell.codeButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
                _oneCell.codeButton.titleLabel.font = [UIFont systemFontOfSize:15];
                [_oneCell.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                _oneCell.codeButton.userInteractionEnabled = YES;
                [_oneCell.codeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_oneCell.codeButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
                _oneCell.codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [_oneCell.codeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                _oneCell.codeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}*/


//关闭
- (IBAction)shutdown:(id)sender {
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
}

//提交
- (IBAction)ok:(id)sender {
    FDAlertView *alert = (FDAlertView *)self.superview;
     NSLog(@"提交");
    [alert hide];
}


#pragma Mark-textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end

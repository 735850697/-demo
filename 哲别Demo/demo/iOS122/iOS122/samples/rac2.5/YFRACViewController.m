//
//  YFRACViewController.m
//  iOS122
//
//  Created by 颜风 on 15/10/19.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import "YFRACViewController.h"
#import <ReactiveCocoa.h>

@interface YFRACViewController ()
@property (copy, nonatomic) NSString * username;
@property (assign, nonatomic) BOOL createEnabled;
@property (copy, nonatomic) NSString * password;
@property (copy, nonatomic) NSString * passwordConfirmation;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) RACCommand * loginCommand;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation YFRACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [RACObserve(self, username) subscribeNext:^(NSString *newName) {
        NSLog(@"username: %@", newName);
    }];
    
    [[RACObserve(self, username)
      filter:^(NSString *newName) {
          return [newName hasPrefix:@"j"];
      }]
     subscribeNext:^(NSString *newName) {
         NSLog(@"with j: %@", newName);
     }];
    
    
    // 测试对 self.username的监听.
    for (int i = 0;  i < 10; i++) {
        if (0 == i%2) {
            self.username = [NSString stringWithFormat: @"%d", i];
        }else
        {
            self.username = [NSString stringWithFormat: @"j%d", i];
        }
    }
    
    RAC(self, createEnabled) = [RACSignal
                                combineLatest:@[ RACObserve(self, password), RACObserve(self, passwordConfirmation) ]
                                reduce:^(NSString *password, NSString *passwordConfirm) {
                                    return @([passwordConfirm isEqualToString:password]);
                                }];
    
    [RACObserve(self, createEnabled) subscribeNext: ^(NSNumber * enbable){
        NSLog(@"%@", enbable);
    }];
    
    // 测试 self.password 与 self.passwordConfirmation 对 createEnabled 的影响.
    self.password = @"iOS122";
    self.passwordConfirmation = @"iOS122";
    
    // 按钮的点击事件.
    self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        NSLog(@"button was pressed!");
        return [RACSignal empty];
    }];
    
    // 异步网络请求
    // Hooks up a "Log in" button to log in over the network.
    //
    // This block will be run whenever the login command is executed, starting
    // the login process.
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^(id sender) {
        // The hypothetical -logIn method returns a signal that sends a value when
        // the network request finishes.
        
//        return [client logIn];
        // 通过返回一个空的RACSignal模拟登陆.
        return [RACSignal empty];
    }];
    
    // -executionSignals returns a signal that includes the signals returned from
    // the above block, one for each time the command is executed.
    [self.loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        // Log a message whenever we log in successfully.
        [loginSignal subscribeCompleted:^{
            NSLog(@"Logged in successfully!");
        }];
    }];
    
    // Executes the login command when the button is pressed.
    self.loginButton.rac_command = self.loginCommand;

    // merge
    [[RACSignal
      merge:@[ [RACSignal empty], [RACSignal empty] ]]
     subscribeCompleted:^{
         NSLog(@"They're both done!");
     }];
    
    //
    [[[[RACSignal
        empty]
       flattenMap:^(id user) {
           // Return a signal that loads cached messages for the user.
           return [RACSignal
                   empty];
       }]
      flattenMap:^(NSArray *messages) {
          // Return a signal that fetches any remaining messages.
          return [RACSignal empty];
      }]
     subscribeNext:^(NSArray *newMessages) {
         NSLog(@"New messages: %@", newMessages);
     } completed:^{
         NSLog(@"Fetched all messages.");
     }];
    
    

    RAC(self.imageView, image) = [[[RACObserve(self, createEnabled)
                                    deliverOn:[RACScheduler scheduler]]
                                   map:^(id user) {
                                       // 下载头像(这在后台执行.)
                                       return  [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: @"http://ios122.bj.bcebos.com/IMG_1785.PNG"]]];
                                   }]
                                  // 现在赋值在主线程完成.
                                  deliverOn:RACScheduler.mainThreadScheduler];


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

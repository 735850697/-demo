//
//  ZHCreateViewController.m
//  ZH二维码
//
//  Created by haodf on 16/1/8.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import "ZHCreateViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"

@interface ZHCreateViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZHCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ZH生成二维码";
}
- (IBAction)createBtnAction:(id)sender {
    
    [self.textView resignFirstResponder];
    
    self.imageView.image = [QRCodeGenerator qrImageForString:self.textView.text imageSize:self.imageView.frame.size.width];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [super touchesBegan:touches withEvent:event];
    
    [self.textView resignFirstResponder];
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

//
//  ZHBarCodeViewController.m
//  ZH二维码
//
//  Created by haodf on 16/1/8.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import "ZHBarCodeViewController.h"
#import "Code39.h"

@interface ZHBarCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZHBarCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZH生成条形码";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)createBtnAction:(id)sender {
    
    [self.textView resignFirstResponder];
    UIImage *code39Image = [Code39 code39ImageFromString:self.textView.text Width:self.imageView.frame.size.width Height:self.imageView.frame.size.height];
    self.imageView.image = code39Image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.textView resignFirstResponder];
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

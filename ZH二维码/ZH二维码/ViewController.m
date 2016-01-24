//
//  ViewController.m
//  ZH二维码
//  zhanghui
//  Created by haodf on 16/1/7.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import "ViewController.h"
#import "ZBarSDK.h"
#import "ZHJuBuViewController.h"
#import "ZHCreateViewController.h"
#import "ZHBarCodeViewController.h"

@interface ViewController ()<ZBarReaderDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textVIew;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
// 全屏扫描
- (IBAction)allScan:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    
    reader.readerDelegate = self;
    
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self presentViewController:reader animated:YES completion:nil];
    
}

// 自定义局部扫描
- (IBAction)localityScan:(id)sender {
    
    ZHJuBuViewController *VC = [[ZHJuBuViewController alloc] init];
    
    __weak ViewController *weakSelf = self;
    VC.block = ^(NSString *text){
        weakSelf.textVIew.text = text;
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

// 生成二维码
- (IBAction)createBtnAction:(id)sender {
    
    ZHCreateViewController *VC = [[ZHCreateViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

// 生成条形码
- (IBAction)BarCodeBtnAction:(id)sender {
    
    ZHBarCodeViewController *VC = [[ZHBarCodeViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ZBarReaderDelegate 代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    id <NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for (symbol in results) {
        break;
    }
    NSString *text = symbol.data;
    self.textVIew.text = text;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.textVIew resignFirstResponder];
}



@end




























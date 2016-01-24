//
//  ZHJuBuViewController.m
//  ZH二维码
//
//  Created by haodf on 16/1/8.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import "ZHJuBuViewController.h"
#import "ZBarSDK.h"

@interface ZHJuBuViewController () <ZBarReaderViewDelegate>
{
    ZBarReaderView *readView;
}

@property (weak, nonatomic) IBOutlet UIView *juBuView;

@end

@implementation ZHJuBuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ZH自定义二维码扫描";
    
    readView = [ZBarReaderView new];
    
    readView.torchMode = 0;
    
    // 自定义大小
    readView.frame = CGRectMake(0, 0, 200, 200);
    
    // 设置代理
    readView.readerDelegate = self;
    
    // 将其照相机拍摄视图添加到要显示的视图上
    [self.juBuView addSubview:readView];
    
    // 二维码 条形码识别设置
    ZBarImageScanner *scanner = readView.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    // 启动，必须启动后，手机摄像头拍摄的即时图像才可以显示在readview上
    [readView start];
}

- (IBAction)cancelBtnAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [readView removeFromSuperview];
}


#pragma ZBarReaderViewDelegate
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    
    ZBarSymbol *symbol = nil;
    for (symbol in symbols) {
        break;
    }
    
    NSString *text = symbol.data;
    
    self.block (text);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [readerView removeFromSuperview];
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

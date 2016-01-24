//
//  ViewController.m
//  FDAlertViewDemo
//
//  Created by fergusding on 15/5/26.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "ViewController.h"
#import "FDAlertView.h"
#import "ContentView.h"

@interface ViewController () <FDAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showContentAlert:(id)sender {
    FDAlertView *alert = [[FDAlertView alloc] init];
    ContentView *contentView = [[NSBundle mainBundle] loadNibNamed:@"ContentView" owner:nil options:nil].lastObject;
    contentView.frame = CGRectMake(0, 0, 270, 200);
    
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 8;
    
    alert.contentView = contentView;
    alert.contentView.frame = CGRectMake(self.view.bounds.size.width/2-135,self.view.bounds.size.height/2-125, 270, 200);
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld", (long)buttonIndex);
}

@end

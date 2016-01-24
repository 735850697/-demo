//
//  ViewController.m
//  QHNavSliderMenuView
//
//  Created by imqiuhang on 15/8/12.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "FirstViewController.h"
#import "QHNavSliderMenu.h"
#import "ExampleViewController.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FirstViewController
{
    NSArray *data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"QHNavSliderMenuView";
    [self initView];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [data[indexPath.row] integerValue]==QHNavSliderMenuTypeTitleAndImage? @"图片+文字类型":@"文字类型";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExampleViewController *exampleViewController = [ExampleViewController new];
    exampleViewController.menuType = [data[indexPath.row] integerValue];
    [self.navigationController pushViewController:exampleViewController animated:YES];
}

#pragma mark -init

- (void)initView {
    
    data = @[@(QHNavSliderMenuTypeTitleAndImage),@(QHNavSliderMenuTypeTitleOnly)];
    
    UITableView *dataTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    dataTableView.delegate       = self;
    dataTableView.dataSource     = self;
    [self.view addSubview:dataTableView];
    
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
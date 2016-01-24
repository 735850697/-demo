//
//  ViewController.m
//  HACursor
//
//  Created by haha on 15/7/20.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "ViewController.h"
#import "HACursor.h"
#import "UIView+Extension.h"
#import "HATestView.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *pageViews;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //不允许有重复的标题
    self.titles = @[@"穿衣经",@"美容颜",@"好身材",@"多才艺",@"手工迷",@"美食家",@"辣妈帮",@"乐活派",@"外语角",@"魔法师",@"八卦控",@"奇葩"];
    
    //初始化生成头scrollView
    HACursor *cursor = [[HACursor alloc]init];
    cursor.backgroundColor = [UIColor whiteColor];
    cursor.frame = CGRectMake(0, 64, self.view.width, 45);
    //显示的标题栏的标题（必选！！）
    cursor.titles = self.titles;
    //需要管理的子页面（必选！！）
    cursor.pageViews = [self createPageViews];
    
    
    //设置根滚动视图的高度   设置rootScrollView的高度（必选！！）
    cursor.rootScrollViewHeight = self.view.frame.size.height - 109;
    //设置标题普通状态下的颜色
    cursor.titleNormalColor = [UIColor blackColor];
    //设置标题选中状态下的颜色
    cursor.titleSelectedColor = [UIColor redColor];
    //是否需要显示排序的按钮
    cursor.showSortbutton = YES;
    //设置最小化的字体，默认的最小值是5，小于默认值的话按默认值设置，(默认的最小值 < 设置值 <默认的最大值) 按设置的值处理
    cursor.minFontSize = 12;
    //设置最大化的字体，默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    cursor.maxFontSize = 17;
    
    //设置是否需要渐变字体的大小
    //cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
    //cursor.isGraduallyChangColor = NO;
    [self.view addSubview:cursor];
}



//根据标签生成相应的tableView
- (NSMutableArray *)createPageViews{
    NSMutableArray *pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i < self.titles.count; i++) {
        HATestView *textView = [[HATestView alloc]init];
        textView.label.text = self.titles[i];
        [pageViews addObject:textView];
    }
    return pageViews;
}

@end

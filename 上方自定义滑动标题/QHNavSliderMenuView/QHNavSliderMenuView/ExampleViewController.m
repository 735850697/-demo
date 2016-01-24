//
//  ExampleViewController.m
//  QHNavSliderMenuView
//
//  Created by imqiuhang on 15/8/12.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "ExampleViewController.h"
#import "ContentViewController.h"
@interface ExampleViewController ()<QHNavSliderMenuDelegate,UIScrollViewDelegate>

@end

@implementation ExampleViewController
{
    QHNavSliderMenu *navSliderMenu;
     NSMutableDictionary  *listVCQueue;
     UIScrollView *contentScrollView;
    int menuCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"example";
    menuCount =10;
    [self initView];
    
}



- (void)initView {
    
    ///第一个子视图为scrollView或者其子类的时候 会自动设置 inset为64 这样navSliderMenu会被下移 所以最好设置automaticallyAdjustsScrollViewInsets为no 或者[self.view addSubview:[UIView new]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    
    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray *normalImages = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray *selectImages = [[NSMutableArray alloc] initWithCapacity:10];
    for(int i=0;i<menuCount;i++) {
        [titles addObject:[NSString stringWithFormat:@"标题%i",i]];
        [normalImages addObject:[UIImage imageNamed:@"ws_leimu_gray"]];
        [selectImages addObject:[UIImage imageNamed:@"ws_leimu_pink"]];
    }
    
    model.menuTitles                   = [titles copy];
    
    
    //>>>>>>>>>>>如果是image和title类型的 则传入对应的图片数组
    if (self.menuType==QHNavSliderMenuTypeTitleAndImage) {
        model.menuImagesNormal             = [normalImages copy];
        model.menuImagesSelect             = [selectImages copy];
    }
    
    //>>>>>>>>>>>下面的几个都可以不设置也可以定制
//    model.sliderMenuTextColorForNormal = QHRGB(140, 140, 140);
//    model.sliderMenuTextColorForSelect = QHRGB(226, 12, 12);
//    model.titleLableFont               = defaultFont(12);
//    model.menuWidth                    = QHScreenWidth /4.f;
//    model.menuHorizontalSpacing        = 0.f;
    //>>>>>>>>>>>
    
    navSliderMenu = [[QHNavSliderMenu alloc] initWithFrame:(CGRect){0,64,screenWidth,50} andStyleModel:model andDelegate:self showType:self.menuType];
    navSliderMenu.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:navSliderMenu];
    
    ///如果只需要一个菜单 下面这些都可以不要  以下是个添加page视图的例子
    
    //example 用于滑动的滚动视图
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navSliderMenu.bottom, screenWidth, screenHeight-navSliderMenu.bottom)];
    contentScrollView.contentSize = (CGSize){screenWidth*menuCount,contentScrollView.contentSize.height};
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate      = self;
    contentScrollView.scrollsToTop  = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentScrollView];
    
    [self addListVCWithIndex:0];
}

#pragma mark -QHNavSliderMenuDelegate
- (void)navSliderMenuDidSelectAtRow:(NSInteger)row {
    //让scrollview滚到相应的位置
    [contentScrollView setContentOffset:CGPointMake(row*screenWidth, contentScrollView.contentOffset.y)  animated:NO];
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //用scrollView的滑动大小与屏幕宽度取整数 得到滑动的页数
    [navSliderMenu selectAtRow:(int)((scrollView.contentOffset.x+screenWidth/2.f)/screenWidth) andDelegate:NO];
    //根据页数添加相应的视图
    [self addListVCWithIndex:(int)(scrollView.contentOffset.x/screenWidth)];
    [self addListVCWithIndex:(int)(scrollView.contentOffset.x/screenWidth)+1];
    
}

#pragma mark -addVC

- (void)addListVCWithIndex:(NSInteger)index {
    if (!listVCQueue) {
        listVCQueue=[[NSMutableDictionary alloc] init];
    }
    if (index<0||index>=menuCount) {
        return;
    }
    //根据页数添加相对应的视图 并存入数组
    
    if (![listVCQueue objectForKey:@(index)]) {
        ContentViewController * contentViewController = [ContentViewController new];
        contentViewController.index = (int)index;
        [self addChildViewController:contentViewController];
        contentViewController.view.left = index*screenWidth;
        contentViewController.view.top  = 0;
        [contentScrollView addSubview:contentViewController.view];
        [listVCQueue setObject:contentViewController forKey:@(index)];
    }
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
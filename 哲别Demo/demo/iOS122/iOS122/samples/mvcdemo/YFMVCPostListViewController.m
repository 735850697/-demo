//
//  YFMVCPostListViewController.m
//  iOS122
//
//  Created by 颜风 on 15/10/14.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import "YFMVCPostListViewController.h"
#import "YFArticleModel.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import "YFMVCPostViewController.h"

@interface YFMVCPostListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * articles; //!< 文章数组,内部存储AFArticleModel类型.
@property (assign, nonatomic) NSInteger page; //!< 数据页数.表示下次请求第几页的数据.

@end

@implementation YFMVCPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)articles
{
    if (nil == _articles) {
        _articles = [NSMutableArray arrayWithCapacity: 42];
    }
    
    return _articles;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];

    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] init];
        
        [self.view addSubview: _tableView];
        
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        NSString * cellReuseIdentifier = NSStringFromClass([UITableViewCell class]);
        
        [_tableView registerClass: NSClassFromString(cellReuseIdentifier) forCellReuseIdentifier:cellReuseIdentifier];
        
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            
            [self updateData];
        }];
        
        _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self updateData];
        }];
        
    }
    
    return _tableView;
}

/**
 * 更新视图.
 */
- (void) updateView
{
    [self.tableView reloadData];
}

/**
 *  更新数据.
 *
 *  数据更新后,会自动更新视图.
 */

- (void)updateData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString * urlStr = [NSString stringWithFormat: @"http://www.ios122.com/find_php/index.php?viewController=YFPostListViewController&model[category]=%@&model[page]=%ld", self.categoryName, (long)self.page ++];
    
    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if (1 == self.page) { // 说明是在重新请求数据.
            self.articles = nil;
        }
        
        NSArray * responseArticles = [YFArticleModel objectArrayWithKeyValuesArray: responseObject];
        
        [self.articles addObjectsFromArray: responseArticles];
        
        [self updateView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];

    }];
}

# pragma mark - tabelView代理方法.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number  = self.articles.count;
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellReuseIdentifier = NSStringFromClass([UITableViewCell class]);
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellReuseIdentifier forIndexPath:indexPath];
    
    YFArticleModel * model = self.articles[indexPath.row];

    NSString * content = [NSString stringWithFormat: @"标题:%@ 内容:%@", model.title, model.desc];
    
    cell.textLabel.text = content;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到博客详情.
    YFArticleModel * articleModel = self.articles[indexPath.row];
    
    YFMVCPostViewController * postVC = [[YFMVCPostViewController alloc] init];
    
    postVC.articleID = articleModel.id;
    
    [self.navigationController pushViewController: postVC animated: YES];
}

@end

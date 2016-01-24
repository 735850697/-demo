//
//  YFMVVMPostListViewController.m
//  iOS122
//
//  Created by 颜风 on 15/10/21.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import "YFMVVMPostListViewController.h"
#import "YFBlogListViewModel.h"
#import <ReactiveCocoa.h>
#import "YFCategoryArticleListModel.h"
#import "YFBlogListViewModel.h"
#import "YFBlogListItemViewModel.h"
#import "YFArticleModel.h"
#import "YFBlogDetailViewModel.h"
#import <MJRefresh.h>
#import "YFMVVMPostViewController.h"

@interface YFMVVMPostListViewController ()

@end

@implementation YFMVVMPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [RACObserve(self.viewModel, blogListItemViewModels) subscribeNext:^(id x) {
        [self updateView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self.viewModel first];
        }];
        
        _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self.viewModel next];
        }];
        
    }
    
    return _tableView;
}

/**
 * 更新视图.
 */
- (void) updateView
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
    [self.tableView reloadData];
}

# pragma mark - tabelView代理方法.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number  = self.viewModel.blogListItemViewModels.count;
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellReuseIdentifier = NSStringFromClass([UITableViewCell class]);
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellReuseIdentifier forIndexPath:indexPath];
    
    YFBlogListItemViewModel * vm = self.viewModel.blogListItemViewModels[indexPath.row];
    
    NSString * content = vm.intro;
    
    cell.textLabel.text = content;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到博客详情.
    YFBlogListItemViewModel * itemVM = self.viewModel.blogListItemViewModels[indexPath.row];
    
    YFMVVMPostViewController * postVC = [[YFMVVMPostViewController alloc] init];
    
    YFBlogDetailViewModel * detailVM = [[YFBlogDetailViewModel alloc] init];
    detailVM.blogId = itemVM.blogId;
    
    postVC.viewModel = detailVM;
    
    [self.navigationController pushViewController: postVC animated: YES];
}

@end

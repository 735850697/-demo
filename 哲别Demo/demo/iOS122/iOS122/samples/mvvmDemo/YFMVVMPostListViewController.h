//
//  YFMVVMPostListViewController.h
//  iOS122
//
//  Created by 颜风 on 15/10/21.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFBlogListViewModel;

@interface YFMVVMPostListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (strong, nonatomic) YFBlogListViewModel * viewModel;

@end

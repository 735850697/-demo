//
//  DBSearchViewController.m
//  danbai_client_ios
//
//  Created by 赵璞 on 15/7/3.
//  Copyright (c) 2015年 db. All rights reserved.
//

#import "DBSearchViewController.h"
#import "UITableViewCell+CreateCell.h"
#import "OrganizationCell.h"
#import "DBSearchCell.h"
#import "HotSearchModel.h"
#import "myCommunitModel.h"
#import "UserModel.h"
#import "DBOrganizatinDetailsViewController.h"

#import "DBSelectView.h"

//历史搜索记录的文件路径
#define DBSearchHistoryPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hisDatas.data"]

@interface DBSearchViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITextFieldDelegate,DBSelectViewDelegate>
{
    UISearchBar *mySearchBar;
    UISearchDisplayController * mySearchDisplayController;
}

/** 搜索的类型 */
@property (nonatomic , copy) NSString *searchType;
/** 搜索的数据 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 历史搜索数据 */
@property (nonatomic, strong) NSMutableArray *hisDatas;
/** 热门数据模型 */
@property (nonatomic, strong) NSArray *hotDatas;

@property(strong ,nonatomic)DBSelectView * SearchBtn;
@property(assign, nonatomic)bool isTwo;
@property(assign, nonatomic)int n;
@property(assign, nonatomic)CGRect TableViewRect;
@property(strong , nonatomic)UITableView * TempTableView;

@property(copy, nonatomic)NSString * SearchStr;

@end

@implementation DBSearchViewController

- (NSMutableArray *)hisDatas
{
    if (_hisDatas == nil) {
        _hisDatas = [NSMutableArray arrayWithContentsOfFile:DBSearchHistoryPath];
        if (_hisDatas == nil) {
            _hisDatas = [NSMutableArray array];
        }
    }
    return _hisDatas;
}

- (NSArray *)hotDatas
{
    if (_hotDatas == nil) {
        _hotDatas = [NSArray array];
    }
    
    return _hotDatas;
}

-(NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _isTwo = NO;
    _n = 0;
    _TableViewRect = self.tableView.frame;
    _TempTableView = self.tableView;
    UIImage *patternImage = [UIImage imageNamed:@"hua_bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    //添加右按钮空间
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStylePlain target:self action:@selector(nilSymbol)];
    self.navigationItem.rightBarButtonItem = anotherButton;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupSearchBar];
    
    [self getHistoryList];
}


-(void)setupSearchBar {
    
    mySearchBar = [[UISearchBar alloc] init];
    mySearchBar.backgroundColor = [UIColor clearColor];
    mySearchBar.placeholder = @"搜索";
    mySearchBar.showsScopeBar = YES;
   // mySearchBar.scopeButtonTitles = @[@"社团",@"达人"];
    self.searchType = @"communit";
    mySearchBar.tintColor = DBThemeColor;
    
    NSDictionary *textdicSelected = [NSDictionary dictionaryWithObjectsAndKeys:DBTextThemeColor,NSForegroundColorAttributeName, nil];
    
    [mySearchBar setScopeBarButtonTitleTextAttributes:textdicSelected forState:UIControlStateSelected];
    
    NSDictionary *textdicNormal = [NSDictionary dictionaryWithObjectsAndKeys:c2,NSForegroundColorAttributeName, nil];
    [mySearchBar setScopeBarButtonTitleTextAttributes:textdicNormal forState:UIControlStateNormal];
    
    
    //遵守协议方法
    mySearchBar.delegate = self;
    //设置选项
    [mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mySearchBar sizeToFit];
    mySearchBar.frame = CGRectMake(-20, 0, SCREEN_WIDTH-60, 44);
    //mySearchBar.frame = CGRectMake(-100, 0, 100, 44);
    
    //self.tableView.tableHeaderView = mySearchBar;
    self.navigationItem.titleView=mySearchBar;
    
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    mySearchDisplayController.delegate = self;
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;

}


-(void)getHistoryList {
    [RequestData getHistoryListSuccess:^(id json) {
        debugLog(@"top10搜索列表   %@",json);
        NSString *code = [json objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            self.hotDatas = [HotSearchModel objectArrayWithKeyValuesArray:[json objectForKey:@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        debugLog(@"top10搜索列表   %@",error);
    }];
}

#pragma mark selectedScope
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    switch (selectedScope) {
        case 0:
            debugLog(@"社团");
            self.searchType = @"communit";
            break;
        case 1:
            debugLog(@"达人");
            self.searchType = @"user";
            break;
    }
}


//输入搜索文字时隐藏搜索按钮，清空时显示

//开始搜索时触发
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _n++;
    self.tableView = _TempTableView;
    if (_n==2) {
       // _TempTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        
    }
    
    _SearchBtn = [[DBSelectView alloc] initWithFrame:CGRectMake(0, 5,SCREEN_WIDTH , 26)];
    _SearchBtn.title_one = @"搜索社团";
    _SearchBtn.title_two = @"搜索达人";
    _SearchBtn.delegate = self;
    [_SearchBtn lineToIndex:0];
    
    
    searchBar.showsScopeBar = YES;
    searchBar.backgroundColor = [UIColor clearColor];
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.datas removeAllObjects];
    
    [self.tableView reloadData];

    return YES;
}



//编辑完成后触发
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    self.tableView.frame = _TableViewRect;
    //判断是否有输入,有值的话将新的字符串添加到datas[0]中并且重新写入文件，发送网络请求
    /* 发送请求 */
    if (searchBar.text.length) {
        for (NSString *text in self.hisDatas) {
            if ([text isEqualToString:searchBar.text]) {
                return YES;
            }
        }
        [self.hisDatas insertObject:searchBar.text atIndex:0];
        if (self.hisDatas.count > 3) {
            [self.hisDatas removeLastObject];
        }
        [self.hisDatas writeToFile:DBSearchHistoryPath atomically:YES];
    }

    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    
    [self.tableView reloadData];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    self.tableView.frame = _TableViewRect;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = searchBar.text;
    params[@"type"] = self.searchType;
    params[@"pageIndex"] = @"1";
    
    [RequestData searchListParams:params success:^(id json) {
        debugLog(@"搜索     %@",json);
        NSString *code = [json objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            if ([self.searchType isEqualToString:@"communit"]) {
                self.datas = [myCommunitModel objectArrayWithKeyValuesArray:[json objectForKey:@"data"]];
                
            }else if ([self.searchType isEqualToString:@"user"]) {
                
                self.datas = [UserModel objectArrayWithKeyValuesArray:[json objectForKey:@"data"]];
             
            }
            
            [self.searchDisplayController.searchResultsTableView reloadData];
            self.tableView = self.searchDisplayController.searchResultsTableView;
            self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT+100);
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        debugLog(@"搜索     %@",error);
    }];
}


//实时监听
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    //去空格
    searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _SearchStr = searchString;
    
    return YES;
}



-(void)BeginSearch{
    self.tableView.frame = _TableViewRect;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = _SearchStr;
    params[@"type"] = self.searchType;
    params[@"pageIndex"] = @"1";
    
    [RequestData searchListParams:params success:^(id json) {
        debugLog(@"搜索     %@",json);
        NSString *code = [json objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            if ([self.searchType isEqualToString:@"communit"]) {
                self.datas = [myCommunitModel objectArrayWithKeyValuesArray:[json objectForKey:@"data"]];
                
            }else if ([self.searchType isEqualToString:@"user"]) {
                
                self.datas = [UserModel objectArrayWithKeyValuesArray:[json objectForKey:@"data"]];
                
            }
            
            [self.searchDisplayController.searchResultsTableView reloadData];
            self.tableView = self.searchDisplayController.searchResultsTableView;
            self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT+100);
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        debugLog(@"搜索     %@",error);
    }];


}



#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }else {
        return 2;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return self.datas.count;
    }else {
        if (section == 0) {
            return self.hisDatas.count;
        }else {
            return self.hotDatas.count;
        }
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //搜索结果
        if ([self.searchType isEqualToString:@"user"]) {
            DBSearchCell *cell = (DBSearchCell *)[DBSearchCell cellWithTableViewNib:tableView];
            cell.userModel = self.datas[indexPath.row];
            return cell;
        }else {
            OrganizationCell *cell = (OrganizationCell *)[OrganizationCell cellWithTableViewNib:tableView];
            cell.myCommunt = self.datas[indexPath.row];
            return cell;
        }
    
    }else {
        //原始数据
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITableViewCell *cell = [UITableViewCell cellWithTableView:tableView];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = c2;
        
        if (indexPath.section == 0) {
            cell.textLabel.text = self.hisDatas[indexPath.row];
        }else {
            HotSearchModel *model = self.hotDatas[indexPath.row];
            cell.textLabel.text = model.content;
        }
        
        return cell;
    }

}

#pragma mark 设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return 80;
    }else {
        return 30;
    }
    
}

#pragma mark 点击某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isTwo = YES;
    //mySearchBar.text.clearButtonMode = UITextFieldViewModeAlways;
    mySearchBar.clearsContextBeforeDrawing = YES;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        if ([self.searchType isEqualToString:@"user"]) {
            debugLog(@"用户转跳");
            
        }else {
            myCommunitModel *model = self.datas[indexPath.row];
            DBOrganizatinDetailsViewController *detailsView = [[DBOrganizatinDetailsViewController alloc]init];
            detailsView.titleText = model.name;
            detailsView.communitId = model.communitId;
            detailsView.access = model.access;
            [self.navigationController pushViewController:detailsView animated:YES];
        }
    }else {
        [mySearchBar becomeFirstResponder];
        if (indexPath.section == 0) {
             mySearchBar.text =  self.hisDatas[indexPath.row];
        }else if (indexPath.section == 1){
            HotSearchModel *model = self.hotDatas[indexPath.row];
            mySearchBar.text = model.content;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }else {
        return 50;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *array = @[@"搜索历史",@"大家都在搜"];
    
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = DBTextThemeColor;
    label.text = array[section];
    
    CGFloat labelX = 16;
    CGFloat labelW = SCREEN_WIDTH - 32;
    CGSize labelSize = [label.text sizeWithAttributes:DBOgzNameFont];

    CGFloat labelY = 60 - labelSize.height - 5;

    label.frame = CGRectMake(labelX, labelY, labelW, labelSize.height);
    [titleView addSubview:label];
    
    if (section == 0) {
        [titleView addSubview:_SearchBtn];
    }

    return titleView;
}


#pragma Mark-SelectView
- (void)selectView:(DBSelectView *)selectView didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to{
    
    switch (to) {
        case 10:
            debugLog(@"社团");
            self.searchType = @"communit";
            break;
        case 11:
            debugLog(@"达人");
            self.searchType = @"user";
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


//********友盟统计分析接入************
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //当进入前台时开启日志统计
    [MobClick beginLogPageView:@"PageOne"];
    
    if (_isTwo) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _isTwo = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //进入后台时关闭日志统计
    [MobClick endLogPageView:@"PageOne"];
}



@end

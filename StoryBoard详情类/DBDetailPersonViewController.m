//
//  DBDetailPersonViewController.m
//  danbai_client_ios
//
//  Created by dbjyz on 15/8/5.
//  Copyright (c) 2015年 db. All rights reserved.
//

#import "DBDetailPersonViewController.h"
#import "DBdetailTableViewCell.h"
#import "UITableViewCell+CreateCell.h"
#import "DBSelectView.h"
#import "NSString+Tools.h"
#import "MJRefresh.h"
#import "DBOrganzationModel.h"
#import <UIImageView+WebCache.h>


static int pageIndex = 1;
#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height

@interface DBDetailPersonViewController ()<UITableViewDataSource,UITableViewDelegate,DBSelectViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *MyView;

@property (weak, nonatomic) IBOutlet UIImageView *PerIcon;
@property (weak, nonatomic) IBOutlet UILabel *PerNameAndCity;
@property (weak, nonatomic) IBOutlet UILabel *PerContent;
@property (weak, nonatomic) IBOutlet UILabel *Persex;

@property(strong, nonatomic)UITableView * tableViewOne;
@property(strong, nonatomic)UITableView * tableViewTwo;

//按钮封装类
@property(strong, nonatomic)DBSelectView * selectView;

//上方视图View的初始坐标
@property(assign, nonatomic)CGRect MyViewRect;
//scrollView的初始坐标
@property(assign, nonatomic)CGRect MyScrollViewRect;

@property(strong, nonatomic)NSMutableArray * refreshCreateArr;
@property(strong, nonatomic)NSMutableArray * refreshJoinArr;

@end

@implementation DBDetailPersonViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //背景平铺
    UIImage *patternImage = [UIImage imageNamed:@"hua_bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    [self setNavi];
    
    _scrollView.contentSize = CGSizeMake(DeviceWidth*2, 0);
    [self loadtableView];
    [self CreateButton];
    _MyViewRect = _MyView.frame;
    _MyScrollViewRect = _scrollView.frame;
    
    [self getUserdata];
    //获取创建的社团
    [self getListData:@"0"];
    
    //获取加入的社团
    [self getListData:@"1"];
}

//设置navi
-(void)setNavi{
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.title = self.name;

}


//获取个人信息

-(void)getUserdata{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = self.userId;
    
    [RequestData getUserInfoParams:params success:^(id json) {
        
        NSString *code = [json objectForKey:@"code"];
        NSDictionary *dataDic = [json objectForKey:@"data"];
        
        if ([code isEqualToString:@"0"]) {
            
            //注意获取的数据对象有几个
//            DBUserDetail *user = [DBUserDetail objectWithKeyValues:dataDic];
            
            DBAccount *user =[DBAccount objectWithKeyValues:dataDic];
            //根据城市编号获取城市名
            NSString *city =[NSString cityDictionary:nil valueForKey:user.cityCode];
            
            [_PerIcon sd_setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:[UIImage imageNamed:@"加载头像"]];
            
            _PerIcon.layer.cornerRadius = _PerIcon.frame.size.height/2;
            _PerIcon.layer.masksToBounds = YES;
            
            NSString * Tempstr = [user.name stringByAppendingString:@"  "];
            NSString * TempStr2 = [@"城市:" stringByAppendingString:city];
            _PerNameAndCity.text = [Tempstr stringByAppendingString:TempStr2];
            //个性签名
            if (user.signature == NULL) {
                _PerContent.text = @"做最好的自己";
            }else{
                _PerContent.text = [user.signature stringByAppendingString:@"AA"];
            }
            
            if (user.sexCode == NULL){
                _Persex.text = @"无";
            }else{
                _Persex.text = user.sexCode;
            }
            
        }else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[json objectForKey:@"message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    } failure:^(NSError *error) {
        
    }];

}




//获取社团信息数据
-(void)getListData:(NSString *)type{

    __weak typeof(self) weakSelf = self;
    __weak UITableView *tableView;
    if ([type  isEqual: @"0"]) {
        tableView = self.tableViewOne;
    }else{
        tableView = self.tableViewTwo;
    }
    
    
    //头部刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = self.userId;
        params[@"pageIndex"] = [NSString stringWithFormat:@"%d",pageIndex];
        params[@"type"] = type; //0为创建，1加入
       
        //数据请求
        [RequestData getOtherCommunitListParams:params success:^(id json) {
            NSString *code = [json objectForKey:@"code"];
            NSArray *dataArr = [json objectForKey:@"data"];
            
            NSLog(@"AA == %@",dataArr);
            
            if ([code isEqualToString:@"0"]) {
                NSArray *array = [DBOrganzationModel objectArrayWithKeyValuesArray:dataArr];
                
                //初始化tableView刷新数组
                if ([type  isEqual: @"0"]) {
                    // 创建的视图
                    //_refreshCreateArr = [[NSMutableArray alloc] initWithArray:array];
                    _refreshCreateArr = [[NSMutableArray alloc] initWithObjects:@"AAAA",@"BBBB",@"CCCC", nil];
                     [self.tableViewOne reloadData];
                }else{
                //加入的视图
                   //_refreshJoinArr = [[NSMutableArray alloc] initWithArray:array];
                    _refreshJoinArr = [[NSMutableArray alloc] initWithObjects:@"AAAA",@"BBBB",@"CCCC", nil];
                     [self.tableViewTwo reloadData];
                }
        
               
            }else {
                
            }
        } failure:^(NSError *error) {
    
        }];
        //结束刷新
        [tableView.header endRefreshing];
    }];
    
    tableView.header.autoChangeAlpha = YES;
    [self.tableViewOne.header beginRefreshing];
    [self.tableViewTwo.header beginRefreshing];
    
    
    
    //尾部刷新
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageIndex ++ ;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = self.userId;
        params[@"pageIndex"] = [NSString stringWithFormat:@"%d",pageIndex];
        params[@"type"] = type; //0为创建，1加入
        
        //数据请求
        [RequestData getOtherCommunitListParams:params success:^(id json) {
            
            NSString *code = [json objectForKey:@"code"];
            NSArray *dataArr = [json objectForKey:@"data"];
            
            if ([code isEqualToString:@"0"]) {
                NSArray *array = [DBOrganzationModel objectArrayWithKeyValuesArray:dataArr];
                
                //向刷新列表数组中添加新数据
                if ([type  isEqual: @"0"]) {
                    //创建的社团
                    [_refreshCreateArr addObjectsFromArray:array];
                    [self.tableViewOne reloadData];
                }else{
                    //加入的社团
                    [_refreshJoinArr addObjectsFromArray:array];
                    [self.tableViewTwo reloadData];
                }
                if (array.count == 0) {
                    pageIndex --;
                }
                
                
            }else {
                pageIndex --;
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    
    tableView.footer.autoChangeAlpha = YES;
    [self.tableViewOne.footer beginRefreshing];
    [self.tableViewTwo.footer beginRefreshing];
}


//添加按钮
-(void)CreateButton{
    _selectView = [DBSelectView selectView];
    _selectView.frame = CGRectMake(0, 159, DeviceWidth, 36);
    _selectView.delegate = self;
    _selectView.title_one = @"他创建的社团";
    _selectView.title_two = @"他加入的社团";
    [_MyView addSubview:_selectView];
    
}

#pragma Mark-selectViewDetegate
- (void)selectView:(DBSelectView *)selectView didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to{

    NSInteger index = to - 10;
    [UIView animateWithDuration:0.2 animations:^{
        [_scrollView setContentOffset:CGPointMake(DeviceWidth*index,0) animated:NO];
    }];
}


- (void)selectView:(DBSelectView *)selectView didChangeSelectedView:(NSInteger)to{
    
}


//生成加载tableView列表
-(void)loadtableView{
    _tableViewOne = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH , 0, DeviceWidth, DeviceHeight- (_MyViewRect.size.height+15))];
    _tableViewOne.delegate = self;
    _tableViewOne.dataSource = self;
    
    
    [_scrollView addSubview:_tableViewOne];
    
    
    _tableViewTwo = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight- (_MyViewRect.size.height+15))];
    _tableViewTwo.delegate = self;
    _tableViewTwo.dataSource = self;
    [_scrollView addSubview:_tableViewTwo];
    
    [self viewDidLayoutSubviews];

}


//设置cell的线条显示完整
-(void)viewDidLayoutSubviews {
    if ([_tableViewOne respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableViewOne setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_tableViewOne respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableViewOne setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }  
}



#pragma Mark-tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (_refreshCreateArr.count > 0 || _refreshJoinArr.count > 0) {
//        if (tableView == _tableViewOne) {
//            return _refreshCreateArr.count;
//        }else{
//            return _refreshJoinArr.count;
//        }
//    }else{
//    
//        return 0;
//    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //＊＊＊＊＊＊加载自定义cell＊＊＊＊＊＊＊
    DBdetailTableViewCell *cell = (DBdetailTableViewCell *)[DBdetailTableViewCell cellWithTableViewNib:tableView];
    
    DBOrganzationModel * Temp;
    if (tableView == _tableViewOne) {
        Temp = [_refreshCreateArr objectAtIndex:indexPath.row];
       
    }else{
        Temp = [_refreshCreateArr objectAtIndex:indexPath.row];
    }
    
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:Temp.image] placeholderImage:[UIImage imageNamed:@"加载头像"]];
//    cell.NameLab.text = Temp.name;
//    cell.contentLab.text = Temp.experience;
    
      cell.NameLab.text = @"韩国料理";
      cell.contentLab.text = @"部队锅料理第一弹";
    
    return cell;
}



#pragma mark 设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

#pragma mark 点击某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma  mark-ScrollViewDelegate
//加载scrollView和滑动都会执行此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        // 1.取出水平方向上滚动的距离
        CGFloat offsetX = scrollView.contentOffset.x;
        // 2.求出页码
        double pageDouble = offsetX / scrollView.frame.size.width;
        int pageInt = (int)(pageDouble + 0.5);
            
        [_selectView lineToIndex:pageInt];

    }else{
        
        //＊＊＊＊＊＊判断向上滑动还是向下滑动＊＊＊＊＊＊
        int _lastPosition;
        int currentPostion = scrollView.contentOffset.y;
        if (currentPostion - _lastPosition > 25) {
            _lastPosition = currentPostion;
            
            [UIView animateWithDuration:0.2 animations:^{
                _MyView.frame = CGRectMake(_MyViewRect.origin.x
                                           , _MyViewRect.origin.y-110, _MyViewRect.size.width, _MyViewRect.size.height);
                
                _scrollView.frame = CGRectMake(_MyScrollViewRect.origin.x
                                               , _MyScrollViewRect.origin.y-110,
                                               DeviceWidth,
                                               DeviceHeight-10);
            }];
        }
        else if (_lastPosition - currentPostion > 25)
        {
            _lastPosition = currentPostion;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                _MyView.frame = CGRectMake(_MyViewRect.origin.x,_MyViewRect.origin.y+44, _MyViewRect.size.width, _MyViewRect.size.height);
                _scrollView.frame = CGRectMake(_MyScrollViewRect.origin.x, _MyScrollViewRect.origin.y+44, DeviceWidth, _MyScrollViewRect.size.height);
            }];
            
        }
    }
}


@end

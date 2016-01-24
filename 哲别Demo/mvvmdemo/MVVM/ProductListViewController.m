#import "ProductListViewController.h"
#import "APIClient.h"
#import "ProductListViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "ProductListCell.h"

@interface ProductListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, strong) ProductListViewModel *viewModel;

@end

@implementation ProductListViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupViewUI];
    [self initViewModel];
    [self bindViewModel];
    [self.viewModel.fetchProductCommand execute:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setupViewUI {
    
    self.title = @"产品列表";
    self.table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
}



- (void)initViewModel {
    
    
    //管道流是：用一个数据初始化信号源，用RACCommand给信号源添加时间（给信号量绑定事件）,
    _viewModel = [ProductListViewModel new];
    @weakify(self)
    
    
    //订阅者一，一个信号源可以有多个订阅者，不同的订阅者可以通过map【转化器，经过他数据会被转换】或(和)者是filter过滤器添加条件
    [_viewModel.fetchProductCommand.executing
       //fetchProductCommand自定义的command对象，这个事是只订阅这一个fetchProductCommand
     
      subscribeNext:^(NSNumber *executing) {
        NSLog(@"command executing:%@", executing);
        if (!executing.boolValue) {
            @strongify(self)
            [self.table.header endRefreshing];
        }
    }];
    
    
    //订阅者二
    [_viewModel.fetchMoreProductCommand.executing subscribeNext:^(NSNumber *executing) {
        if (!executing.boolValue) {
            @strongify(self);
            [self.table.footer endRefreshing];
        }
    }];
    
    //订阅者三
    [_viewModel.errors subscribeNext:^(NSError *error) {
        ResponseData *data = [ResponseData objectWithKeyValues:error.userInfo];
        NSLog(@"something error:%@", data.keyValues);
        //TODO: 这里可以选择一种合适的方式将错误信息展示出来
    }];
    
}


- (void)bindViewModel {
    @weakify(self);//弱引用转换
    //初始化右边控件
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc]initWithEnabled:[[RACSignal
                                                                                             combineLatest:@[self.viewModel.fetchProductCommand.executing, self.viewModel.fetchMoreProductCommand.executing]] or]
                                                                                signalBlock:^RACSignal *(id input) {
                                                                                    @strongify(self);
                                                                                    [self.viewModel.cancelCommand execute:nil];
                                                                                    return [RACSignal empty];
                                                                                }];
    
    
    //添加观察者，一般观察者只需要添加一次（为什么是双向的，是因为他观察着双向的值即：self.viewModel, items都背观察者呢）
    
    //RACObserve(self.viewModel, items):观察self.viewModel中的items
    [RACObserve(self.viewModel, items) subscribeNext:^(id x) {
        @strongify(self);//强引用转换，强引用转换（达到双向的作用）
        [self.table reloadData];
    }];
    
    //没有更多数据时，隐藏table的footer
    RAC(self.table.footer, hidden) = [self.viewModel.hasMoreData not];
}


#pragma mark - View Method

- (void)loadData {
    
    //执行信号量，根据这个信号量，执行command绑定的事件
    [self.viewModel.fetchProductCommand execute:nil];
}

- (void)loadMoreData {
    [self.viewModel.fetchMoreProductCommand execute:nil];
}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductListCell" forIndexPath:indexPath];
    cell.viewModel = [self.viewModel itemViewModelForIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

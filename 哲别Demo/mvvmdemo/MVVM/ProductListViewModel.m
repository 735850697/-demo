#import "ProductListViewModel.h"

@interface ProductListViewModel ()

@property (nonatomic, strong) Page *page;

@end

@implementation ProductListViewModel

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        
        [self initCommand];
        
        [self initSubscribe];
    }
    return self;
}


//初始化command对象
- (void)initCommand {
    
    _fetchProductCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        //由此生成信号，由此返回的值作为初始化command的参数
        return [[[APIClient sharedClient]
                 fetchProductWithPageIndex:@(1)]
                 takeUntil:self.cancelCommand.executionSignals];//哨声响起就意味着比赛终止
    }];
    
    
    
    _fetchMoreProductCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [[[APIClient sharedClient] fetchProductWithPageIndex:@(self.page.PageIndex+1)] takeUntil:self.cancelCommand.executionSignals];
    }];
    
    
    //这个信号量，用观察者初始化，始终处于观察状态，当满足条件时执行方法
    _hasMoreData = [RACObserve(self, page) map:^id(Page *p) {
        if (p!= nil && p.PageIndex < p.PageCount) {
            return @YES;
        }
        return @NO;
    }];
    
}




//对command的订阅者进行中间返回处理
- (void)initSubscribe {
    
    //每次在订阅者订阅相应之前都会先执行此方法
    
    //此处主要是对请求的数据进行模型化封装，封装完后的数据在相应订阅者
    @weakify(self);
    [[_fetchProductCommand.executionSignals switchToLatest] subscribeNext:^(ResponseData *response) {
        @strongify(self);
        if (!response.success) {
            [self.errors sendNext:response.error];
        }
        else {
            self.items = [ProductListModel objectArrayWithKeyValuesArray:response.data];
            self.page = response.page;
        }
    }];
    
    
    
    [[_fetchMoreProductCommand.executionSignals switchToLatest] subscribeNext:^(ResponseData *response) {
        @strongify(self);
        if (!response.success) {
            [self.errors sendNext:response.error];
        }
        else {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.items];
            [arr addObjectsFromArray:[ProductListModel objectArrayWithKeyValuesArray:response.data]];
            self.items = arr;
            self.page = response.page;
        }
    }];
    
    
    
    [[RACSignal merge:@[_fetchProductCommand.errors, self.fetchMoreProductCommand.errors]] subscribe:self.errors];
}

#pragma mark - method

- (ProductListCellViewModel *)itemViewModelForIndex:(NSInteger)index {
    
    return [[ProductListCellViewModel alloc]initWithModel:[_items objectAtIndex:index]];
}

@end

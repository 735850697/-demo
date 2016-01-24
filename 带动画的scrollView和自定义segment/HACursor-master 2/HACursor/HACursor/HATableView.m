//
//  HATableView.m
//  HACursor
//
//  Created by 赵璞 on 15/8/25.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "HATableView.h"

#define clickIndex @"clickIndex"
@interface HATableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *tmpKeys;
@end

@implementation HATableView

- (NSMutableArray *)tmpKeys{
    if (!_tmpKeys) {
        _tmpKeys = [NSMutableArray arrayWithArray:self.itemKeys];
    }
    return _tmpKeys;
}



- (void)setup{
    self.delegate = self;
    self.dataSource = self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    cell.textLabel.text = self.itemKeys[indexPath.row];
    
    return cell;

}

#pragma mark 设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

#pragma mark 点击某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self deselectRowAtIndexPath:indexPath animated:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:clickIndex object:[NSNumber numberWithInteger:indexPath.row]];
}


@end

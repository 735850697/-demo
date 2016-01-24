//
//  HATableView.h
//  HACursor
//
//  Created by 赵璞 on 15/8/25.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HATableView : UITableView
@property (nonatomic, copy) NSString *selectButtonTitle;
@property (nonatomic, strong) NSMutableArray *itemKeys;
@end

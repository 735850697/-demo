//
//  DBSelectView.h
//  danbai_client_ios
//
//  Created by 赵璞 on 15/8/5.
//  Copyright (c) 2015年 db. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBSelectView;

@protocol DBSelectViewDelegate <NSObject>

@optional
//当按钮点击时通知代理
- (void)selectView:(DBSelectView *)selectView didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

- (void)selectView:(DBSelectView *)selectView didChangeSelectedView:(NSInteger)to;

@end

@interface DBSelectView : UIView

@property(nonatomic, weak) id <DBSelectViewDelegate> delegate;

@property(nonatomic, copy)NSString *title_one;
@property(nonatomic, copy)NSString *title_two;

+ (instancetype)selectView;

//滑动到当前button的方法
- (void)lineToIndex:(NSInteger)index;

@end
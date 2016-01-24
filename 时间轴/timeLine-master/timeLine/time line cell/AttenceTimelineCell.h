//
//  AttenceTimelineCell.h
//  Product
//
//  Created by ACTIVATION GROUP on 14-8-7.
//  Copyright (c) 2014年 eKang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttenceTimelineCell : UITableViewCell{
    UIView *verticalLineTopView;
    UIView *dotView;
    UIView *verticalLineBottomView;
    
    UIButton *showLab;
}

//cell的高度随着字符串的高度设置
+ (float)cellHeightWithString:(NSString *)str isContentHeight:(BOOL)b;

//给cell的赋值（并判断时第一个 或者是 最后一个）
- (void)setDataSource:(NSDictionary *)dic isFirst:(BOOL)isFirst isLast:(BOOL)isLast;

@end

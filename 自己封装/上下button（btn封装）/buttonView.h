//
//  buttonView.h
//  cell
//
//  Created by dbjyz on 15/8/28.
//  Copyright (c) 2015年 dbjyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class buttonView;

@protocol buttonViewDelegate <NSObject>

@required

-(void)ClickBtn:(NSInteger)tag;

@end


@interface buttonView : UIView

@property(nonatomic,weak) id<buttonViewDelegate> delegate;

-(UIView *)getButton:(NSInteger)index :(NSString *)numTitle :(NSString *)textTitle :(CGRect)frame;

@end

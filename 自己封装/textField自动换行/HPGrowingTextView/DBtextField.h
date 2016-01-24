//
//  DBtextField.h
//  GrowingTextViewExample
//
//  Created by dbjyz on 15/8/21.
//
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"


//设置委托代理
@class DBtextField;

@protocol DBtextFieldDelegate <NSObject>

@optional
//当按钮点击时通知代理
- (void)ClickBtn:(DBtextField *)MytextFiled;
//显示键盘
- (void)ChangeFrame:(DBtextField *)tempField :(CGSize)keyboardSize;
//隐藏键盘
- (void)ChangeFrame2:(DBtextField *)tempField;
@end


@interface DBtextField : UIView<HPGrowingTextViewDelegate>


//设置代理对象
@property(nonatomic, weak) id <DBtextFieldDelegate> delegate;

@property(strong, nonatomic)UIView *containerView;
@property(strong, nonatomic)HPGrowingTextView *textView;
@property(strong, nonatomic)UIButton *doneBtn;

@property(copy, nonatomic)NSString * titleStr;
@property(copy, nonatomic)NSString * placeholder;


@end

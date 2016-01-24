//
//  AlertViewWithBlockOrSEL.h
//  QHSimpleFrame
//
//  Created by imqiuhang on 15/4/1.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "QHHead.h"

@interface AlertViewWithBlockOrSEL : UIAlertView
- (id)initWithTitle:(NSString *)title message:(NSString *)message;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
- (void)setCancelButtonWithTitle:(NSString *)title;
- (void)setCancelButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setCancelButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action withObject:(id)object;
- (void)setCancelButtonWithTitle:(NSString *)title onTapped:(void(^)())tappedBlock;
- (void)addOtherButtonWithTitle:(NSString *)title;
- (void)addOtherButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)addOtherButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action withObject:(id)object;
- (void)addOtherButtonWithTitle:(NSString *)title onTapped:(void(^)())tappedBlock;
@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
//
//  ZHJuBuViewController.h
//  ZH二维码
//
//  Created by haodf on 16/1/8.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyBlock) (NSString *);
@interface ZHJuBuViewController : UIViewController
@property (nonatomic, copy) MyBlock block;
@end

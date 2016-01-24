//
//  YFPatternViewController.h
//  iOS122
//
//  Created by 颜风 on 15/10/13.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFMVVMDelegate.h"

@class YFPatternModel, YFArticleCollection;

@interface YFPatternViewController : UIViewController
@property (strong, nonatomic) YFPatternModel * model;

@end

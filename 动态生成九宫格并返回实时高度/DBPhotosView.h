//
//  DBPhotosView.h
//  danbai_client_ios
//
//  Created by jyz on 15/7/29.
//  Copyright (c) 2015年 db. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DBPhotosView : UIView

/**
 *  需要展示的图片
 */
@property (nonatomic, strong)  NSArray * photos;


/**
 *  根据图片的个数返回相册的最终尺寸
 */
+ (CGSize)photoListSizeWithCount:(int)count;


@end

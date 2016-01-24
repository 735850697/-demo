//
//  DBPhotosView.m
//  danbai_client_ios
//
//  Created by jyz on 15/7/29.
//  Copyright (c) 2015年 db. All rights reserved.
//

#import "DBPhotosView.h"
#import "DBPhotoImage.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


const int PhotoMargin = 5;

@implementation DBPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化9个子控件
        for (int i = 0; i < 9; i++) {
            DBPhotoImage *photoView = [[DBPhotoImage alloc] init];
            photoView.userInteractionEnabled = YES;
            photoView.tag = i;
            [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)]];
            [self addSubview:photoView];
        }
    }
    return self;
}


//点击事件  MJPhotoBrowser：网络图片浏览器（在线查看图片）
- (void)photoTap:(UITapGestureRecognizer *)recognizer
{
    NSUInteger count = self.photos.count;
    // 1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 一个MJPhoto对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        
        mjphoto.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
        
        NSString *photoUrl = self.photos[i];
        
        NSRange rang = [photoUrl rangeOfString:@"-danbai"];
        if (rang.location != NSNotFound) {
            mjphoto.url = [NSURL URLWithString:DBimageUrlString(photoUrl)];
        }else {
           mjphoto.url = [NSURL URLWithString:photoUrl];
        }

        
         // 图片路径
        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = recognizer.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = myphotos; // 设置所有的图片
    [browser show];
}



//懒加载
//设置图片的样式（排列最多9个）和大小（需要我们传入图片数组）
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    NSUInteger count = photos.count;
    
    CGFloat photoWH ;
    if (photos.count == 1) {
        photoWH = SCREEN_WIDTH - 2 * (Border20 + Border50);
    }else if (photos.count == 2 || photos.count == 4){
        photoWH = ((SCREEN_WIDTH - (Border20 + Border50)*2 - PhotoMargin) / 2.0);
    }else {
        photoWH = ((SCREEN_WIDTH - ((Border20 + Border50) + PhotoMargin)*2) / 3.0) ;
    }
    
    for (int i = 0; i<self.subviews.count; i++) {
        DBPhotoImage *image = self.subviews[i];
        if (i < count) {
            // 显示
            image.hidden = NO;
            // 边框
            int divider = (count == 4)?2:3;
            int column = i%divider;
            int row = i/divider;
            CGFloat childX = column * (photoWH + PhotoMargin);
            CGFloat childY = row *  (photoWH + PhotoMargin);
            
            if (count == 1) {
                image.frame = CGRectMake(0, 0, photoWH, photoWH*(9.0/16.0));
            } else {
                image.frame = CGRectMake(childX, childY, photoWH, photoWH);
            }
            
            image.clipsToBounds = YES;
            image.contentMode = UIViewContentModeScaleAspectFill;
            // 下载图片
            image.url = photos[i];
        } else {
            // 隐藏
            image.hidden = YES;
        }
    }

}



//计算整体的高度(需要我们传入照片的个数)
+ (CGSize)photoListSizeWithCount:(int)count
{
    if (count <= 0) return CGSizeZero;
    CGFloat photoWH ;
    if (count == 1) {
        photoWH = SCREEN_WIDTH - 2 * (Border20 + Border50);
    }else if (count == 2 || count == 4){
        photoWH = ((SCREEN_WIDTH - 2 * (Border20 + Border50) - PhotoMargin) / 2.0);
    }else {
        photoWH = ((SCREEN_WIDTH - (Border20 + Border50 + PhotoMargin)*2) / 3.0) ;
    }

    if (count == 1) {
        CGFloat photoW = SCREEN_WIDTH - 2 * (Border20 + Border50);
        return CGSizeMake(photoW, photoW*(9.0/16.0));
    } else {
        int row = (count + 2)/3;
        CGFloat width = SCREEN_WIDTH - 2 * (Border20 + Border50);
        CGFloat height = row * photoWH + (row - 1) * PhotoMargin;
        return CGSizeMake(width, height);
    }
}

@end

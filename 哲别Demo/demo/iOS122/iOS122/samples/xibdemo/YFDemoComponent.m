//
//  YFDemoComponent.m
//  iOS122
//
//  Created by 颜风 on 15/10/14.
//  Copyright (c) 2015年 iOS122. All rights reserved.
//

#import "YFDemoComponent.h"

@interface YFDemoComponent ()
@property (weak, nonatomic) IBOutlet UIImageView *imgeView;

@end

@implementation YFDemoComponent


- (void)drawRect:(CGRect)rect
{
    [super drawRect: rect];
    
    if (nil != self.image) {
        self.imgeView.image = self.image;
    }
}
@end

//
//  QHUtilAss.m
//  yimashuo
//
//  Created by imqiuhang on 15/8/20.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "QHUtilAss.h"

@implementation QHUtilAss


+ (NSString *)jsonInfo:(id)info andDefaultStr:(NSString *)defaultStr {
    if (!info) {
        return defaultStr;
    }
    
    if ([info isKindOfClass:[NSNull class]]) {
        return defaultStr;
    }
    
    if ([info isKindOfClass:[NSString class]]) {
        if ([info isNotEmptyWithSpace]) {
            //for service
            if ([info isEqualToString:@"<null>"]) {
                return defaultStr;
            }
            return [NSString stringWithFormat:@"%@", info];
        } else {
            return defaultStr;
        }
    }
    
    return [NSString stringWithFormat:@"%@", info];
    
    return @"";
}



@end




@implementation QHUtilAss(dataForTest)



@end



// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
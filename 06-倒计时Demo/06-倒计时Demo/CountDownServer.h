//
//  CountDownServer.h
//  06-倒计时Demo
//
//  Created by zkx on 15/12/3.
//  Copyright © 2015年 zkx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountDownServer : NSObject

//开始倒计时
+ (void) startCountDown:(int)total identifier:(NSString *)identifier;


//表示倒计时是否正在进行
+ (BOOL) isCountDowning:(NSString *)identifier;

@end

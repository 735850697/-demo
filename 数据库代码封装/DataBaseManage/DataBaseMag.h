//
//  DataBaseMag.h
//  databaseTest
//
//  Created by dbjyz on 15/11/23.
//  Copyright © 2015年 dbjyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
typedef void(^FailureBlock)(NSString *error); // 请求失败的block
typedef void(^SuccessBlock)(NSString *message);

@interface DataBaseMag : NSObject
@property(strong , nonatomic)FMDatabase * FMDB;
@property(strong , nonatomic)NSString * dataPath;


/**
 *  //获取数据库管理对象
 *
 *  @return 管理对象
 */
+(instancetype)getDabaBaseManage;

/**
 *  //创建数据库
 *
 *  @param 传入数据库名字
 *
 *  @return 是否成功
 */

-(void)createDataBase:(NSString *)dataName success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  关闭数据库
 */
-(void)closeDataBase;

@end

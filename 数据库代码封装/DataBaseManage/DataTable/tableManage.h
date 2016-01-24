//
//  tableManage.h
//  databaseTest
//
//  Created by dbjyz on 15/11/23.
//  Copyright © 2015年 dbjyz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FailureBlock)(NSString *error); // 请求失败的block
typedef void(^SuccessBlock)(NSString *message);        // 请求成功的block

@interface tableManage : NSObject

/**
 *  //获取表管理对象
 *
 *  @return 管理对象
 */
+(instancetype)getTableManage;

/**
 *  //创建表
 *
 *  @return table
 */
-(void)createtabel:(NSString *)tableName SQL:(NSString * )SQL success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  添加数据
 *
 *  @param keyArray   数据库字段
 *  @param SQL sql语句
 */
+(void)addDataKey:(NSString *)tableName SQL:(NSString * )SQL success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  删除某个表的数据
 *
 *  @param tableName 要删除表的名字
 *  @param SQL   sql语句
 */
-(void)deleteDataTableName:(NSString *)tableName SQL:(NSString * )SQL success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  更新数据表
 *
 *  @param tableName  表的名字
 *  @param SQL   sql数据
 */
-(void)updataDataTableName:(NSString *)tableName SQL:(NSString * )SQL success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  查询数据
 *
 *  @param tableName 表的名字
 *  @param limit     显示几条数据
 *
 *  @return 相应的数据
 */
-(NSArray *)findDataTableName:(NSString *)tableName SQL:(NSString * )SQL limit:(NSInteger)limit;

@end

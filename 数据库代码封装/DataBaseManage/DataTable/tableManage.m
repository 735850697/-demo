//
//  tableManage.m
//  databaseTest
//
//  Created by dbjyz on 15/11/23.
//  Copyright © 2015年 dbjyz. All rights reserved.
//

#import "tableManage.h"
#import "DataBaseMag.h"

@implementation tableManage

static tableManage * tableMeg = nil;

+(instancetype)getTableManage{
    if (!tableMeg) {
        tableMeg = [[tableManage alloc] init];
    }
    return tableMeg;
}


//创建表
-(void)createtabel:(NSString *)tableName SQL:(NSString * )SQL success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    FMResultSet * rs = [[DataBaseMag getDabaBaseManage].FMDB executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",tableName]];
    [rs next];//判断查询的结果下一个是否有值(把结果值取出来)
    NSInteger count = [rs intForColumnIndex:0];
    if (count) {
        
       failure(@"表已经存在！");
    }
    else{
        BOOL relute = [[DataBaseMag getDabaBaseManage].FMDB executeUpdate:SQL];
        if (relute) {
            success(@"插入成功！");
        }else{
            failure(@"插入失败！");
        }
    }
}


//向表中添加数据
+(void)addDataKey:(NSString *)tableName SQL:(NSString * )SQL success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    BOOL relute = [[DataBaseMag getDabaBaseManage].FMDB executeUpdate:SQL];
    if (relute) {
        success(@"插入成功！");
    }else{
        failure(@"插入失败！");
    }
}



//删除某个表的数据
-(void)deleteDataTableName:(NSString *)tableName SQL:(NSString * )SQL success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    BOOL relute = [[DataBaseMag getDabaBaseManage].FMDB executeUpdate:SQL];
    if (relute) {
        success(@"插入成功！");
    }else{
        failure(@"插入失败！");
    }
}


//更新数据表
-(void)updataDataTableName:(NSString *)tableName SQL:(NSString * )SQL success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    BOOL relute = [[DataBaseMag getDabaBaseManage].FMDB executeUpdate:SQL];
    if (relute) {
        success(@"插入成功！");
    }else{
        failure(@"插入失败！");
    }
}


//查询数据
-(NSArray *)findDataTableName:(NSString *)tableName SQL:(NSString * )SQL limit:(NSInteger)limit{

    FMResultSet * rs = [[DataBaseMag getDabaBaseManage].FMDB executeQuery:SQL];
    NSMutableArray * tempArray = [[NSMutableArray alloc] initWithCapacity:5];
    while ([rs next]) {
        [tempArray addObject:[rs stringForColumn:@"name"]];
        [tempArray addObject:[rs stringForColumn:@"phone"]];
        [tempArray addObject:[rs stringForColumn:@"description"]];
    }
    NSLog(@"AAA == %@",[tempArray objectAtIndex:1]);
    return tempArray;
}

@end

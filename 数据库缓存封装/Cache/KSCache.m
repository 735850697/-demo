//
//  KSCache.m
//  KSNetRequestDemo
//
//  Created by KS on 15/11/27.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import "KSCache.h"
#import "KSDataBaseManager.h"

#define CACHETABLE @"cacheTable"
#define PRIMARYKEY @"primaryKey"
#define OTHERKEY @"otherKey"

@interface KSCache ()

@end

static KSDataBaseManager* dataBase;

@implementation KSCache

+ (BOOL)cleanCache
{
    return [dataBase dropTable:CACHETABLE];
}

/**
 *  更新、插入缓存
 */
+ (void)updateObject:(nonnull id)object withURL:(nonnull NSString*)primary parameter:(nullable id)parameter
{
    [self createDataBase];
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    FMResultSet* set = [dataBase select:nil fromTable:CACHETABLE where:@{PRIMARYKEY:[self stringWithURLString:primary parameter:parameter]}];
    
    BOOL isRet = [set next];
    
    if (isRet) {
        [dataBase updateTable:CACHETABLE records:@{PRIMARYKEY:[self stringWithURLString:primary parameter:parameter],OTHERKEY:data} where:@{PRIMARYKEY:[self stringWithURLString:primary parameter:parameter]}];
    }else{
        
        [dataBase insertRecordIntoTable:CACHETABLE withColumsAndValues:@{PRIMARYKEY:[self stringWithURLString:primary parameter:parameter],OTHERKEY:data}];
    }
}

/**
 *  读取缓存
 */
+ (nullable id)selectObjectWithURL:(nonnull NSString*)primary parameter:(nullable id)parameter
{
    [self createDataBase];
    
    FMResultSet* set = [dataBase select:nil fromTable:CACHETABLE where:@{PRIMARYKEY:[self stringWithURLString:primary parameter:parameter]}];
   
    
    NSData* data = nil;
    while ([set next]) {
        
        data = [set dataForColumn:OTHERKEY];
        
        if (data) {
            break;
        }
        
    }
    
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

+ (nonnull NSString*)stringWithURLString:(nonnull NSString*)string parameter:(nullable id)dictionary
{
    if (!dictionary) {
        return string;
    }
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string = [string stringByAppendingString:str];
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}
/**
 *  初始化
 */
+ (void)createDataBase
{
    NSString* filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/jsonCache.sqlite"];
    dataBase = [[KSDataBaseManager alloc] initWithDataBasePath:filePath];
    
    [dataBase createTable:CACHETABLE primaryKey:PRIMARYKEY primaryType:@"nvarchar(2048)" otherColums:@{OTHERKEY:@"blob"}];
}
@end

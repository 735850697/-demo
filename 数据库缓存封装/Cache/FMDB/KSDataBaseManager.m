//
//  KSDataBaseManager.m
//  数据库访问
//
//  Created by KS on 15/3/4.
//  Copyright (c) 2015年 KS. All rights reserved.
//

#import "KSDataBaseManager.h"

#define PERROR(ret, str) if(!ret)perror(str)

@implementation KSDataBaseManager
{
    FMDatabase * _database;
    NSLock * _lock; //线程锁，线程保护，原子操作
}

- (instancetype)initWithDataBasePath:(NSString *)path
{
    if (self = [super init]) {
        _database = [[FMDatabase alloc] initWithPath:path];
        //创建线程锁
        _lock = [[NSLock alloc] init];
        BOOL ret = [_database open];
        PERROR(ret, "open");
    }
    return self;
}
- (void)dealloc
{
    [_database close];
}
/**创建表单，传入表单名，主键列和其他健列*/
- (void)createTable:(NSString *)tableName primaryKey:(NSString *)keyName primaryType:(NSString *)colType otherColums:(NSDictionary *)colums
{
    [_lock lock];   //加锁
    
    NSMutableString * sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ %@ PRIMARY KEY", tableName, keyName, colType];
    for (NSString * key in colums) {
        //key是列名
        [sql appendFormat:@", %@ %@", key, colums[key]];
    }
    [sql appendString:@");"];
    //FMDB会自动添加分号
    
    BOOL ret = [_database executeUpdate:sql];
    PERROR(ret, "create table");
    
    [_lock unlock]; //解锁
}

/**删除表单，根据表单名*/
- (BOOL)dropTable:(NSString *)tableName
{
    [_lock lock];
    
    NSString * sql = [NSString stringWithFormat:@"DROP TABLE %@;", tableName];
    BOOL ret = [_database executeUpdate:sql];
    PERROR(ret, "drop table");
    
    [_lock unlock];
    return ret;
}


/**插入记录，参数是字典，键是列名，值是列值*/
- (BOOL)insertRecordIntoTable:(NSString *)tableName withColumsAndValues:(NSDictionary *)dict;
{
    [_lock lock];
    
    //拼接列名
    NSMutableString * colStr = [NSMutableString string];
    //拼接value
    NSMutableString * valuesStr = [NSMutableString string];
    
    colStr.string = [dict.allKeys componentsJoinedByString:@","];
    NSMutableArray * xArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < dict.count; i++) {
        [xArray addObject:@"?"];
    }
    valuesStr.string = [xArray componentsJoinedByString:@","];
    
    //创建SQL
    NSMutableString * sql = [NSMutableString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@);", tableName, colStr, valuesStr];
    //@"INSERT INTO XX(姓名,国籍) VALUES(?,?);"
    
    BOOL ret = [_database executeUpdate:sql withArgumentsInArray:dict.allValues];
    PERROR(ret, "insert record");
    
    [_lock unlock];
    return ret;
}

//拼接筛选的字符串
- (NSString *)whereStringFromWhereDictionary:(NSDictionary *)dict
{
    //拼接删选的字符串
    NSMutableArray * whereArray = [NSMutableArray array];
    for (NSString * key in dict) {
        [whereArray addObject:[NSString stringWithFormat:@"%@ = ?", key]];
    }
    NSString * whereStr = [whereArray componentsJoinedByString:@" AND "];
    return whereStr;
}

/**删除记录，参数是字典，是筛选的条件*/
- (void)deleteRecordFromTable:(NSString *)tableName where:(NSDictionary *)whereDict
{
    [_lock lock];
    
    NSString * sql = nil;
    if (whereDict == nil) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        BOOL ret = [_database executeUpdate:sql];
        PERROR(ret, "delete whereDict");
        [_lock unlock];
        return;
    }
    
    //拼接筛选字符串
    NSString * whereStr = [self whereStringFromWhereDictionary:whereDict];
    
    //拼接SQL
    sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", tableName, whereStr];
    BOOL ret = [_database executeUpdate:sql withArgumentsInArray:whereDict.allValues];
    PERROR(ret, "delete whereDict");
    
    [_database close];
    [_lock unlock];
}

/**删除记录，参数是字符串，允许用户，自定义删选条件*/
- (void)deleteRecordFromTable:(NSString *)tableName whereString:(NSString *)whereStr
{
    [_lock lock];
    [_database open];
    
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", tableName, whereStr];
    BOOL ret = [_database executeUpdate:sql];
    PERROR(ret, "delete whereStr");
    
    [_lock unlock];
}

/**查看记录，参数是数组和字典，是筛选条件*/
- (FMResultSet *)select:(NSArray *)columNames fromTable:(NSString *)tableName where:(NSDictionary *)whereDict
{
    [_lock lock];
    
    //首先是列的字符串
    NSString * colStr = nil;
    if (columNames == nil) {
        colStr = @"*";
    } else {
        colStr = [columNames componentsJoinedByString:@","];
    }
    
    NSString * sql = nil;
    if (whereDict == nil) {
        sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", colStr, tableName];
        FMResultSet * set = [_database executeQuery:sql];
        [_lock unlock];
        return set;
    }
    //拼接删选字符串
    NSString * whereStr = [self whereStringFromWhereDictionary:whereDict];
    //拼接SQL
    sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@", colStr, tableName, whereStr];
    
    FMResultSet * set = [_database executeQuery:sql withArgumentsInArray:whereDict.allValues];
    
    [_lock unlock];
    return set;
}

//拼接更新的字符串
- (NSString *)updateStringFromUpdateDictionary:(NSDictionary *)dict
{
    //拼接删选的字符串
    NSMutableArray * whereArray = [NSMutableArray array];
    for (NSString * key in dict) {
        [whereArray addObject:[NSString stringWithFormat:@"%@ = ?", key]];
    }
    NSString * whereStr = [whereArray componentsJoinedByString:@","];
    return whereStr;
}

/**更新记录，参数是两个字典，更新的记录，和筛选条件*/
- (void)updateTable:(NSString *)tableName records:(NSDictionary *)updateDict where:(NSDictionary *)whereDict
{
    [_lock lock];
    
    //拼接更新的字符串
    NSString * updateStr = [self updateStringFromUpdateDictionary:updateDict];
    
    //拼接筛选条件
    NSString * sql = nil;
    if (whereDict == nil) {
        sql = [NSString stringWithFormat:@"UPDATE %@ SET %@;", tableName, updateStr];
        BOOL ret = [_database executeUpdate:sql];
        PERROR(ret, "update");
        [_lock unlock];
        return;
    }
    
    //拼接whereStr
    NSString * whereStr = [self whereStringFromWhereDictionary:whereDict];
    sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@;", tableName, updateStr, whereStr];
    //合体的数组
    NSArray * compArray = [updateDict.allValues arrayByAddingObjectsFromArray:whereDict.allValues];
    BOOL ret = [_database executeUpdate:sql withArgumentsInArray:compArray];
    PERROR(ret, "update");
    
    [_lock unlock];
}


+ (void)test
{
    KSDataBaseManager * dbm = [[KSDataBaseManager alloc] initWithDataBasePath:@"/Users/pansongbiao/Desktop/GP03/day18/DataBase/XX.sqlite"];
    [dbm dropTable:@"男演员"];
    
    NSDictionary * colums = @{
                              @"姓名":@"varchar(128)",
                              @"国籍":@"varchar(128)"
                              };
    [dbm createTable:@"男演员" primaryKey:@"ID" primaryType:@"integer" otherColums:colums];
    
    [dbm insertRecordIntoTable:@"男演员" withColumsAndValues:@{@"姓名":@"刘德华", @"国籍":@"中国"}];
    [dbm insertRecordIntoTable:@"男演员" withColumsAndValues:@{@"姓名":@"郭富城", @"国籍":@"中国"}];
    [dbm insertRecordIntoTable:@"男演员" withColumsAndValues:@{@"姓名":@"威尔 史密斯", @"国籍":@"美国"}];
    
    [dbm deleteRecordFromTable:@"男演员" where:@{@"姓名":@"郭富城"}];
    
    [dbm updateTable:@"男演员" records:@{@"姓名":@"周杰伦", @"国籍":@"中国台湾", @"ID":@"2"} where:@{@"姓名":@"威尔 史密斯"}];
    
    FMResultSet * set = [dbm select:nil fromTable:@"男演员" where:nil];
    while ([set next]) {
        //依次循环一条记录
        //取出记录中的属性
        int ID = [set intForColumn:@"ID"];
        NSString * name = [set stringForColumn:@"姓名"];
        NSString * contry = [set stringForColumn:@"国籍"];
        
        NSLog(@"%d %@ %@", ID, name, contry);
    }
    
}


@end









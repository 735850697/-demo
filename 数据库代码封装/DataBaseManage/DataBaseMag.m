//
//  DataBaseMag.m
//  databaseTest
//
//  Created by dbjyz on 15/11/23.
//  Copyright © 2015年 dbjyz. All rights reserved.
//

#import "DataBaseMag.h"
#import <UIKit/UIKit.h>

@implementation DataBaseMag
static DataBaseMag * DataBaseManager = nil;

+(instancetype)getDabaBaseManage{
    if (!DataBaseManager) {
        DataBaseManager = [[DataBaseMag alloc] init];
    }
    return DataBaseManager;
}



//创建数据库
-(void)createDataBase:(NSString *)dataName success:(SuccessBlock)success failure:(FailureBlock)failure{
    //获取沙盒路径
    NSString * DucPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    _dataPath = [DucPath stringByAppendingString:[NSString stringWithFormat:@"/%@",dataName]];
    NSLog(@"DataPath == %@",_dataPath);
    
    NSFileManager * fileManage = [NSFileManager defaultManager];
    BOOL isExit = [fileManage fileExistsAtPath:_dataPath];
    if (isExit) {
        failure(@"创建数据库失败！");
    }else{
        _FMDB = [[FMDatabase alloc] initWithPath:_dataPath];
        if (!_FMDB.open){
            failure(@"创建数据库失败！");
        }else{
            success(@"数据库打开成功！");
        }
    }
}


-(void)closeDataBase{
    [_FMDB close];
}

@end


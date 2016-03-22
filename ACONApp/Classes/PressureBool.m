//
//  PressureBool.m
//  ACONApp
//
//  Created by Ken on 16/1/29.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "PressureBool.h"

@implementation PressureBool




//初始化  database
+ (FMDatabase *)createFMDBWith:(NSString *)path
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    return db;
    
    
}




//创建 数据库  表
+ (BOOL)createTableOnDB:(FMDatabase *)db withTableName:(NSString *)tableName
{
    
      NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer primary key autoincrement,%@ text,%@ text,%@ text,%@ text,%@ text);",tableName,PressureDate,PressureTime,SystolicPressure,DiastolicPressure,HeartRate];
    
    BOOL result = [db executeUpdate:sqlString];
    return result;
    
    
    
    
    
}

//  插入数据
+ (BOOL)insertOnDB:(FMDatabase *)db withTableName:(NSString *)tableName withDate:(NSString *)pressureDate withTime:(NSString *)pressureTime withSystolic:(NSString *)systolicPText withDiatolic:(NSString *)diastolicPText andWithHeartRate:(NSString *)heartRateText
{
    
   
    
     NSString *sqlString  = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@) VALUES ('%@','%@','%@','%@','%@');",tableName,PressureDate,PressureTime,SystolicPressure,DiastolicPressure,HeartRate,pressureDate,pressureTime,systolicPText,diastolicPText,heartRateText];
    
    BOOL result = [db executeUpdate:sqlString];
    return result;
    
    
    
}


// 获取数据
+ (FMResultSet*)queryOnDB:(FMDatabase *)db withTableName:(NSString *)tableName
{
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ ",tableName];
    //1.查询数据
    FMResultSet *rs = [db executeQuery:sqlString];
    return rs;
    
    
    
    
}
@end

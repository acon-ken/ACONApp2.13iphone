//
//  FatBool.m
//  ACONApp
//
//  Created by Ken on 16/1/29.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "FatBool.h"

@implementation FatBool


//初始化  database
+ (FMDatabase *)createFMDBWith:(NSString *)path{
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    return db;
    
    
}


//创建 数据库  表
+ (BOOL)createTableOnDB:(FMDatabase *)db withTableName:(NSString *)tableName{
    
    NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer primary key autoincrement,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ float(9,7));",tableName,FatDate,FatTime,FatCholesterol,FatTriglyceride,FatHighdensityLipoprotein,FatLowdensityLipoprotein,FatSpeclificValue];
    
      //   float类型
     //  float列类型默认长度查不到结果，必须指定精度
    
     //BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
    
    BOOL result = [db executeUpdate:sqlString];
    return result;
    

    
}

#define FatDate @"fatDate"
#define FatTime @"fatTime"
#define FatCholesterol @"fatCholesterol"
#define FatTriglyceride @"fatTriglyceride"
#define FatHighdensityLipoprotein @"fatHighdensityLipoprotein"
#define FatLowdensityLipoprotein @"fatLowdensityLipoprotein"
#define FatSpeclificValue  @"fatSpeclificValue"
//  插入数据
+ (BOOL)insertOnDB:(FMDatabase *)db withTableName:(NSString *)tableName withFatDate:(NSString *)fatdate withFatTime:(NSString *)fatTime withCholesterol:(NSString *)cholesterol withTriglyceride:(NSString *)triglyceride withHighdensityLipoprotein:(NSString *)highdensityLipoprotein withLowdensityLipoprotein:(NSString *)lowdensityLipoprotein  withSpeclificValue:(float)speclificValue
{
    
    
    
    NSString *sqlString  = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@) VALUES ('%@','%@','%@','%@','%@','%@','%@');",tableName,FatDate,FatTime,FatCholesterol,FatTriglyceride,FatHighdensityLipoprotein,FatLowdensityLipoprotein,FatSpeclificValue,fatdate,fatTime,cholesterol,triglyceride,highdensityLipoprotein,lowdensityLipoprotein,[NSString stringWithFormat:@"%f",speclificValue]];
    
    BOOL result = [db executeUpdate:sqlString];
    return result;
    
    
    
    
}





+ (FMResultSet*)queryOnDB:(FMDatabase *)db withTableName:(NSString *)tableName
{
    
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@ ",tableName];
        //1.查询数据
        FMResultSet *rs = [db executeQuery:sqlString];
        return rs;

    
}
    

    
    

@end

//
//  PressureBool.h
//  ACONApp
//
//  Created by Ken on 16/1/29.
//  Copyright © 2016年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface PressureBool : NSObject




//初始化  database
+ (FMDatabase *)createFMDBWith:(NSString *)path;


//创建 数据库  表
+ (BOOL)createTableOnDB:(FMDatabase *)db withTableName:(NSString *)tableName;

//  插入数据
+ (BOOL)insertOnDB:(FMDatabase *)db withTableName:(NSString *)tableName withDate:(NSString *)pressureDate withTime:(NSString *)pressureTime withSystolic:(NSString *)systolicPText withDiatolic:(NSString *)diastolicPText andWithHeartRate:(NSString *)heartRateText;


// 获取数据
+ (FMResultSet*)queryOnDB:(FMDatabase *)db withTableName:(NSString *)tableName ;


@end

//
//  FatBool.h
//  ACONApp
//
//  Created by Ken on 16/1/29.
//  Copyright © 2016年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FatBool : NSObject



//初始化  database
+ (FMDatabase *)createFMDBWith:(NSString *)path;

//创建 数据库  表
+ (BOOL)createTableOnDB:(FMDatabase *)db withTableName:(NSString *)tableName;

//  插入数据
+ (BOOL)insertOnDB:(FMDatabase *)db withTableName:(NSString *)tableName withFatDate:(NSString *)fatdate withFatTime:(NSString *)fatTime withCholesterol:(NSString *)cholesterol withTriglyceride:(NSString *)triglyceride withHighdensityLipoprotein:(NSString *)highdensityLipoprotein withLowdensityLipoprotein:(NSString *)lowdensityLipoprotein  withSpeclificValue:(float)speclificValue;




// 获取数据
+ (FMResultSet*)queryOnDB:(FMDatabase *)db withTableName:(NSString *)tableName ;


@end

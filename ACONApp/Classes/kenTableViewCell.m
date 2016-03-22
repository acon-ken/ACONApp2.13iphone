//
//  kenTableViewCell.m
//  ACONApp
//
//  Created by Ken on 16/1/12.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "kenTableViewCell.h"
#import "UUChart.h"

#import "PressureBool.h" // 本地数据  操作
@interface kenTableViewCell()<UUChartDataSource>

{
    
    NSIndexPath *path;
    UUChart *chartView;
    
    
    FMDatabase *_db;
    
}

@end
@implementation kenTableViewCell

- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10*XiShu_Height, 10*XiShu_Height, ([UIScreen mainScreen].bounds.size.width-20)*XiShu_Height, 180*XiShu_Height)
                                              withSource:self
                                               withStyle: UUChartStyleLine];
    [chartView showInView:self.contentView];
    
    
}

- (NSArray *)getXTitles:(int)num
{
    
    // 获取值得 数组
    
    NSMutableArray *pressureDateArray =[NSMutableArray array];
    // 先把  对应得的数据库文件打开
    _db=[PressureBool createFMDBWith:Pressuredatabase_path];
    
       if ([_db open])
    {
        ZWLog(@"数据库打开成功");
    }
    else
    {
        ZWLog(@"数据库打开失败");
    }
    //1.查询数据
    FMResultSet *rs =[PressureBool queryOnDB:_db withTableName:PRESSURETABLENAME];
    //2.遍历结构集
    while(rs.next){
        
        NSString *pressureDate = [rs stringForColumn:PressureDate];
        
        
        [pressureDateArray addObject:pressureDate];
        
    }
    // 日期  处理 日期
//    if (path.section==0) {
//        // 日期   处理成 日期格式
//        NSMutableArray *xTitles = [NSMutableArray array];
//        for (int i=0; i<num; i++) {
//            NSString * str = [NSString stringWithFormat:@"1R-%d",i];
//            [xTitles addObject:str];
//        }
//        return xTitles;
//        
//        
//    }
//   
   

    
    
    return pressureDateArray;
    
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    
//    if (path.section==0) {
//        switch (path.row) {
//            case 0:
//                return [self getXTitles:5];
//            case 1:
//                return [self getXTitles:11];
//            case 2:
//                return [self getXTitles:7];
//            case 3:
//                return [self getXTitles:7];
//            default:
//                break;
//        }
    // 获取值得 数组
    
    NSMutableArray *pressureDateArray =[NSMutableArray array];
    // 先把  对应得的数据库文件打开
    _db=[PressureBool createFMDBWith:Pressuredatabase_path];
    
    if ([_db open])
    {
        ZWLog(@"数据库打开成功");
    }
    else
    {
        ZWLog(@"数据库打开失败");
    }
    //1.查询数据
    FMResultSet *rs =[PressureBool queryOnDB:_db withTableName:PRESSURETABLENAME];
    //2.遍历结构集
    while(rs.next){
        
        NSString *pressureDate = [rs stringForColumn:PressureDate];
        
        
        [pressureDateArray addObject:pressureDate];
        
    }

    return [self getXTitles:(int)pressureDateArray.count];//获取 多少 日期数据
}
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
  
    //获得的数据  数组；
    
    NSMutableArray *systolicArray=[NSMutableArray array];
    NSMutableArray *diastolicArray=[NSMutableArray array];
    NSMutableArray *heartRateArray=[NSMutableArray array];
    
    // 先把  对应得的数据库文件打开
    _db=[PressureBool createFMDBWith:Pressuredatabase_path];
    
    ZWLog(@"数据库文件地址 %@",Pressuredatabase_path);
    
    if ([_db open])
    {
        ZWLog(@"数据库打开成功");
        
        
    }
    else
    {
        ZWLog(@"数据库打开失败");
    }
    
    
    //1.查询数据
    FMResultSet *rs =[PressureBool queryOnDB:_db withTableName:PRESSURETABLENAME];
    
    //2.遍历结构集
    while(rs.next){
        
        NSString *systolic=[rs stringForColumn:SystolicPressure];
        NSString *diastolic=[rs stringForColumn:DiastolicPressure];
        NSString *heartRate=[rs stringForColumn:HeartRate];
        
        
        [systolicArray addObject:systolic];
        [diastolicArray addObject:diastolic];
        [heartRateArray addObject:heartRate];
        
        // ZWLog(@"888888%d- %@- %@-%@-%@-%@", ID, pressureDate,pressureTime, systolic,diastolic,heartRate);
    }
    
    
   // ZWLog(@" \n systolic-%@\n diastolic-%@\n heartrate-%@",systolicArray,diastolicArray,heartRateArray);
    
 
    if (path.section==0)
    {
        return @[systolicArray];
    }
    if (path.section==1) {
       return  @[diastolicArray];
    }
    if (path.section==2)
    {
        return  @[heartRateArray];
    }
    return nil;

}

#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    //return @[[UUColor green],[UUColor red],[UUColor brown],[UIColor yellowColor]];
    
    
    return @[[UIColor greenColor]];// 显示折线的 颜色
    
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
    
    // 纵坐标  数值 范围  不表明 根据范围 确定（最大值，最小值）
    
//    if (path.section==0 && (path.row==0 | path.row==1)) {
//        return CGRangeMake(60, 10);
//    }
//    if (path.section==1 && path.row==0) {
//        return CGRangeMake(60, 10);
//    }
//    if (path.row == 2) {
//        return CGRangeMake(100, 0);
//    }
//    return CGRangeZero;
    
    //不同的折线图显示  不同的  取值范围
    
    //取值范围
    if (path.section==0) {
        return CGRangeMake(160, 80);
        

    }
    
    if (path.section==1) {
        return CGRangeMake(100, 40);
        
        
    }
    
    if (path.section==2) {
        return CGRangeMake(150, 50);
        
        
    }
    return CGRangeZero;
    
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{


//显示标记数值区域

    
 // 标记的正常值的 范围
   if (path.section ==0)
    {
           return CGRangeMake(90, 140);
    }
    
    
    if (path.section ==1)
    {
        return CGRangeMake(60, 90);
    }
    
    if (path.section ==2)
    {
        return CGRangeMake(60, 100);
    }
    

   return CGRangeZero;
    
    
}

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    //是否显示最大值  最小值
    //return path.row ==2;
    return YES;
    
}


@end

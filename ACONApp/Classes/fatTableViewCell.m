//
//  fatTableViewCell.m
//  ACONApp
//
//  Created by Ken on 16/1/12.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "fatTableViewCell.h"
#import "UUChart.h"

#import "FatBool.h"
@interface fatTableViewCell ()<UUChartDataSource>{
    
    NSIndexPath *path;
    UUChart *chartView;
    FMDatabase *_db;
    
}
@end

@implementation fatTableViewCell



- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10*XiShu_Height, 10*XiShu_Height, ([UIScreen mainScreen].bounds.size.width-20)*XiShu_Height, 150*XiShu_Height)
                                              withSource:self
                                               withStyle:UUChartStyleLine];
    [chartView showInView:self.contentView];
}

- (NSArray *)getXTitles:(int)num
{
    // 日期
    
    NSMutableArray *fatDateArray=[NSMutableArray array];
    // 先把  对应得的数据库文件打开
    _db=[FatBool createFMDBWith:Fatdatabase_path];
    
    ZWLog(@"数据库文件地址 %@",Fatdatabase_path);
    
    if ([_db open])
    {
        ZWLog(@"数据库打开成功");
        
        
    }
    else
    {
        ZWLog(@"数据库打开失败");
    }
    
    //1.查询数据
    FMResultSet *rs =[FatBool queryOnDB:_db withTableName:FATTABLENAME];
    
    //2.遍历结构集
    while(rs.next){
        NSString *fatDate = [rs stringForColumn:FatDate];
 
        [fatDateArray addObject:fatDate];
        
    }
    
    
    return fatDateArray;;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    NSMutableArray *fatDateArray=[NSMutableArray array];
    // 先把  对应得的数据库文件打开
    _db=[FatBool createFMDBWith:Fatdatabase_path];
    
    ZWLog(@"数据库文件地址 %@",Fatdatabase_path);
    
    if ([_db open])
    {
        ZWLog(@"数据库打开成功");
        
        
    }
    else
    {
        ZWLog(@"数据库打开失败");
    }
    
    //1.查询数据
    FMResultSet *rs =[FatBool queryOnDB:_db withTableName:FATTABLENAME];
    
    //2.遍历结构集
    while(rs.next){
        NSString *fatDate = [rs stringForColumn:FatDate];
        
        [fatDateArray addObject:fatDate];
        
    }
    

   
    // 处理返回 多少 日期数
    return [self getXTitles:(int)fatDateArray.count];
}
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    //获取 数组  初始化
    
    
    NSMutableArray * cholesterolArray=[NSMutableArray array];
    NSMutableArray * triglycerideArray=[NSMutableArray array];
    
    NSMutableArray * highArray=[NSMutableArray array];
   NSMutableArray  *lowArray=[NSMutableArray array];
    
    // 先把  对应得的数据库文件打开
    _db=[FatBool createFMDBWith:Fatdatabase_path];
    
    ZWLog(@"数据库文件地址 %@",Fatdatabase_path);
    
    if ([_db open])
    {
        ZWLog(@"数据库打开成功");
        
        
    }
    else
    {
        ZWLog(@"数据库打开失败");
    }
    
    
    //1.查询数据
    FMResultSet *rs =[FatBool queryOnDB:_db withTableName:FATTABLENAME];
    
    //2.遍历结构集
    while(rs.next){
        
       
        
      
        NSString *cholesterol=[rs stringForColumn:FatCholesterol];
        NSString *triglyceride=[rs stringForColumn:FatTriglyceride];
        NSString *high=[rs stringForColumn:FatHighdensityLipoprotein];
        NSString *low=[rs stringForColumn:FatLowdensityLipoprotein];
        
        [cholesterolArray addObject:cholesterol];
        [triglycerideArray addObject:triglyceride];
        [highArray addObject:high];
        [lowArray addObject:low];
        
      
       
    }
    
    
    
    
    
    
    if (path.section==0) {
        return @[cholesterolArray];
    }
    
    if (path.section==1) {
        return @[triglycerideArray];
    }
    if (path.section==2) {
        return @[highArray];
    }
    if (path.section==3) {
        return @[lowArray];
    }
    
    return nil;
    
}

#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    //return @[[UUColor green],[UUColor red],[UUColor brown]];
    
    return @[[UIColor greenColor]]; //折线图的 折线 颜色
    
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
    
    // 纵坐标  数值 范围  不表明 根据范围 确定（最大值，最小值）
    
    
    if (path.section==0) {
        return CGRangeMake(10.0, 0);
    }
    if (path.section==1) {
        return CGRangeMake(4.0, 0);
    }
    if (path.section==2) {
        return CGRangeMake(4.0, 0);
    }
    if (path.section==3) {
        return CGRangeMake(5.0, 0);
    }
    
    return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{
    
    //显示正常的值得 范围  阴影
    if (path.section == 0) {
        return CGRangeMake(2.8, 5.17);
    }
    if (path.section == 1) {
        return CGRangeMake(0.56, 1.75);
    }
    if (path.section == 2) {
        return CGRangeMake(0.90, 1.55);
    }
    if (path.section == 3) {
        return CGRangeMake(0, 3.1);
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
    
    return YES;
    
}
@end

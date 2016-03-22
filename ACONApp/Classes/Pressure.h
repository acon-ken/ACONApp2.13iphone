//
//  Pressure.h
//  ACONApp
//
//  Created by Ken on 16/1/28.
//  Copyright © 2016年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pressure : NSObject//重新定义了一个类，专门用于存储数据
{
    
    NSString *pressureDate;
    
    NSString *pressureTime;
    
    NSString *systolicPText;
    
    NSString *diastolicPText;
    
    NSString *heartRateText;
    
    
    
    
}



//收缩压
@property(nonatomic,copy)NSString *systolicPText;

//舒张压
@property(nonatomic ,copy)NSString *diastolicPText;

//心率
@property(nonatomic,copy)NSString *heartRateText;

//date
@property(nonatomic,copy)NSString *pressureDate;

//time
@property(nonatomic ,copy)NSString *pressureTime;

@end


//
//  Fat.h
//  ACONApp
//
//  Created by Ken on 16/1/28.
//  Copyright © 2016年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fat : NSObject

{
    
    NSString *fatDate;// 记录 日期
   NSString *fatTime;// 记录时间
    
    NSString *cholesterol;//总胆固醇
   NSString *triglyceride; //甘油三酯
    
    NSString *highdensityLipoprotein;//高密度脂蛋白
    NSString *lowdensityLipoprotein;//低密度脂蛋白
    float speclificValue; //总胆固醇与高密度脂蛋白比值
    
}

// 记录 日期
@property(nonatomic,copy)NSString *fatDate;
// 记录时间

@property(nonatomic,copy)NSString *fatTime;
//总胆固醇
@property(nonatomic,copy)NSString *cholesterol;


//甘油三酯
@property(nonatomic,copy)NSString *triglyceride;

//高密度脂蛋白
@property(nonatomic,copy)NSString *highdensityLipoprotein;

//低密度脂蛋白
@property(nonatomic,copy)NSString *lowdensityLipoprotein;

//总胆固醇与高密度脂蛋白比值

@property   float speclificValue;




@end

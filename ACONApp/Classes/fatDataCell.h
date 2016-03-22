//
//  fatDataCell.h
//  ACONApp
//
//  Created by Ken on 16/1/12.
//  Copyright © 2016年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fatDataCell : UITableViewCell


//日期选择
@property (nonatomic,retain)  UILabel *fatdateLabel;

// 日期 时间 选择
@property (nonatomic,retain)  UILabel *fatTimeLabel;


//总胆固醇
@property (nonatomic,retain)  UILabel *cholesterolLabel;



//甘油三酯
@property (nonatomic,retain)  UILabel *triglycerideLabel;


//高密度脂蛋白
@property (nonatomic,retain)  UILabel *highdensityLipoproteinLabel;


//低密度脂蛋白
@property (nonatomic,retain)  UILabel *lowdensityLipoproteinLabel;




+ (NSString *)ID;
+ (id)createFatDataCell;

@end

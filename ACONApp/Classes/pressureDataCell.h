//
//  pressureDataCell.h
//  ACONApp
//
//  Created by Ken on 16/1/12.
//  Copyright © 2016年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pressureDataCell : UITableViewCell

//date
@property ( nonatomic,retain)  UILabel *pressureDate;
//time
@property (nonatomic,retain)  UILabel *pressureTime;
//收缩压
@property (nonatomic,retain)  UILabel *systolicPressure;
//舒张压
@property (nonatomic,retain)  UILabel *diastolicPressure;

//心率
@property (nonatomic,retain)  UILabel *heartRate;
//标示  是手动输入还是 蓝牙数据导入


@property (nonatomic,retain)  UILabel *markLB;


+ (NSString *)ID;
+ (id)createPressureDataCell;
@end

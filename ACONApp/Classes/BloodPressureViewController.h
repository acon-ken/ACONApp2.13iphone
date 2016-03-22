//
//  BloodPressureViewController.h
//  ACONApp
//
//  Created by Ken on 15/12/28.
//  Copyright © 2015年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPressureViewController : UIViewController<UITextFieldDelegate>


//日期选择
@property(nonatomic,retain)UIDatePicker *pressuredatePicker;
// 日期 时间 选择
@property(nonatomic,retain)UIDatePicker *pressuredataTimePicker;

//收缩压
@property(nonatomic,copy)UITextField *systolicPText;

//舒张压
@property(nonatomic ,copy)UITextField *diastolicPText;

//心率
@property(nonatomic,copy)UITextField *heartRateText;

//date
@property(nonatomic,copy)NSString *pressureDate;

//time
@property(nonatomic ,copy)NSString *pressureTime;



@end

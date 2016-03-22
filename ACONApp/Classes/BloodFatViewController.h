//
//  BloodFatViewController.h
//  ACONApp
//
//  Created by Ken on 15/12/28.
//  Copyright © 2015年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodFatViewController : UIViewController<UITextFieldDelegate>



{
  //  <UIGestureRecognizerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

    //,WebServiceDelegate
    //WebServices *helper;
    
    
    
    
    
    
    
}

//日期选择
@property(nonatomic,retain)UIDatePicker *fatdatePicker;
// 日期 时间 选择
@property(nonatomic,retain)UIDatePicker *fatdataTimePicker;

//总胆固醇
@property(nonatomic,copy)UITextField *cholesterolText;


//甘油三酯
@property(nonatomic,copy)UITextField *triglycerideText;

//高密度脂蛋白
@property(nonatomic,copy)UITextField *highdensityLipoproteinText;

//低密度脂蛋白
@property(nonatomic,copy)UITextField *lowdensityLipoproteinText;

//总胆固醇与高密度脂蛋白比值

@property   float speclificValue;

// 记录 日期
@property(nonatomic,copy)NSString *fatDate;
// 记录时间

@property(nonatomic,copy)NSString *fatTime;



@end

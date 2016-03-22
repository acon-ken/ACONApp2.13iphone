//
//  ChooseViewController.m
//  ACONApp
//
//  Created by Ken on 15/12/28.
//  Copyright © 2015年 zw. All rights reserved.
//

#import "ChooseViewController.h"

#import "BloodGlucosemeasurementController.h"
#import "BloodFatViewController.h"
#import "BloodPressureViewController.h"
#import "BloodGlucoseManageController.h"

@interface ChooseViewController ()

@end

//获取屏幕的宽高
#define Screen_Width ([UIScreen mainScreen].bounds.size.width)

#define Screen_Height ([UIScreen mainScreen].bounds.size.height)


@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.title = @"选择输入数据类型";
    self.view.backgroundColor = KBackgroundColor;
    
    self.navigationController.navigationBarHidden = NO;
    self.edgesForExtendedLayout = NO;
    
    // 导航栏  返回按钮
    [self backview];
    
    //添加 的三种数据 类型 按钮
    [ self  addChooseButton];
    
    
    
}

//添加 的三种数据 类型 按钮
-(void)addChooseButton{
    
    
    //血糖数据  按钮
    _glucoseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _glucoseButton.frame=CGRectMake(0, 10*XiShu_Height,Screen_Width, 60*XiShu_Height);
    _glucoseButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"lanse"]];
    
    //[_glucoseButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateNormal];
   // [_glucoseButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateSelected];
  [ _glucoseButton setTitle:@"血糖数据" forState:UIControlStateNormal];
   [ _glucoseButton setTitleColor:[UIColor whiteColor] forState:0];
    [_glucoseButton addTarget:self action:@selector(chooseGlucose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
  
    [self.view addSubview:_glucoseButton];
    
    
    // 血脂数据 按钮
   _fatButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _fatButton.frame=CGRectMake(0,80*XiShu_Height,Screen_Width,60*XiShu_Height );
  //  [_fatButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateNormal];
   // [_fatButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateSelected];

    _fatButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"lanse"]];
    
    [ _fatButton setTitle:@"血脂数据" forState:UIControlStateNormal];
    [ _fatButton setTitleColor:[UIColor whiteColor] forState:0];
    [ _fatButton addTarget:self action:@selector(chooseFat:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview: _fatButton];
    
    
    
    // 血压数据 按钮
    
   _pressureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _pressureButton.frame=CGRectMake(0, 150*XiShu_Height, Screen_Width, 60*XiShu_Height);
   
   // [_pressureButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateNormal];
    //[_pressureButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateSelected];
    
    _pressureButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"lanse"]];
    [_pressureButton setTitle:@"血压数据" forState:UIControlStateNormal];
    [_pressureButton setTitleColor:[UIColor whiteColor] forState:0];
    
    [_pressureButton addTarget:self action:@selector(choosePressure:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:_pressureButton];

    
    
    
}

//  跳转到 血糖 数据输入 页面
-(void)chooseGlucose:(UIButton *)sender{
    
    
    BloodGlucosemeasurementController *dataChangeVC = [[BloodGlucosemeasurementController alloc] init];
    [self.navigationController pushViewController:dataChangeVC animated:YES];
    
    
    
}

//  跳转到 血脂 数据输入 页面
-(void)chooseFat:(UIButton *)sender{
    
    BloodFatViewController *fatVC=[[BloodFatViewController alloc]init];
    [self.navigationController pushViewController:fatVC animated:YES];
    
    
}

//  跳转到 血压 数据输入 页面
-(void)choosePressure:(UIButton *)sender{
    
    BloodPressureViewController *pressureVC=[[BloodPressureViewController alloc]init];
    
    [self.navigationController pushViewController:pressureVC animated:YES];
    
    
    
    
    
}


// 导航栏  返回按钮
-(void)backview{
    
    
    
    
    //给导航栏加一个返回按钮
    UIButton *leftbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftbackBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftbackBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateSelected];
    [leftbackBtn  addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    leftbackBtn.selected = YES;
    
    
    UIBarButtonItem *leftButtonitem  = [[UIBarButtonItem alloc] initWithCustomView:leftbackBtn];
    self.navigationItem.leftBarButtonItem=leftButtonitem;
    
    
    
    
}



// 导航栏  返回按钮 事件

-(void)backClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ChooseLineVC.m
//  ACONApp
//
//  Created by Ken on 16/1/19.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "ChooseLineVC.h"
#import "FatLineVC.h"
#import "PressureLineVC.h"
#import "PieChartViewController.h"
@interface ChooseLineVC ()

@end

@implementation ChooseLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择展示图类型";
    self.view.backgroundColor = KBackgroundColor;
    
    self.navigationController.navigationBarHidden = NO;
    self.edgesForExtendedLayout = NO;
    
    // 导航栏  返回按钮
    [self backview];
    
    //添加 的三种数据 类型 按钮
    [ self  addChooseLineButton];
    
    
    
    
    
}
-(void)addChooseLineButton{
    
    //血糖数据图表  按钮
    _glucoseLineButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _glucoseLineButton.frame=CGRectMake(0, 10*XiShu_Height,Screen_Width, 60*XiShu_Height);
    _glucoseLineButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"lanse"]];
    
    //[_glucoseLineButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateNormal];
    // [_glucoseLineButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateSelected];
    [ _glucoseLineButton setTitle:@"血糖数据图表" forState:UIControlStateNormal];
    [_glucoseLineButton setTitleColor:[UIColor whiteColor] forState:0];
    [_glucoseLineButton addTarget:self action:@selector(chooseGlucoseLine:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self.view addSubview:_glucoseLineButton];
    
    
    // 血脂数据图表 按钮
    _fatLineButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _fatLineButton.frame=CGRectMake(0,80*XiShu_Height,Screen_Width,60*XiShu_Height );
    //  [ _fatLineButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateNormal];
    // [ _fatLineButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateSelected];
    
     _fatLineButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"lanse"]];
    
    [ _fatLineButton setTitle:@"血脂数据图表" forState:UIControlStateNormal];
    [  _fatLineButton setTitleColor:[UIColor whiteColor] forState:0];
    [  _fatLineButton addTarget:self action:@selector(chooseFatLine:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:  _fatLineButton];
    
    
    
    // 血压数据图表 按钮
    
    _pressureLineButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _pressureLineButton.frame=CGRectMake(0, 150*XiShu_Height, Screen_Width, 60*XiShu_Height);
    
    // [_pressureLineButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateNormal];
    //[_pressureLineButton setImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateSelected];
    
    _pressureLineButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"lanse"]];
    [_pressureLineButton setTitle:@"血压数据图表" forState:UIControlStateNormal];
    [_pressureLineButton setTitleColor:[UIColor whiteColor] forState:0];
    
    [_pressureLineButton addTarget:self action:@selector(choosePressureLine:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_pressureLineButton];
    
    
}

//跳转到对应的 图标 控制器
-(void)chooseGlucoseLine:(UIButton *)sender{
    //跳转到 血糖 数据 图表展示 页面
    PieChartViewController *pieVC=[[PieChartViewController alloc]init];
    
    pieVC.isme=YES;
    
    
    [self.navigationController pushViewController:pieVC animated:YES];
    
    
    
}




-(void)chooseFatLine:(UIButton *)sender{
    //跳转到 血脂 数据 图表展示 页面
    
    
    FatLineVC *fatVC=[[FatLineVC alloc]init];
    
    
    [self.navigationController pushViewController:fatVC animated:YES];
    
}
-(void)choosePressureLine:(UIButton *)sender{
    
    //跳转到 血压 数据 图表展示 页面
    
    
    PressureLineVC *preVC=[[PressureLineVC alloc]init];
    
    [self.navigationController pushViewController:preVC animated:YES];
    
    
    
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

//添加 的三种数据 类型 按钮
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

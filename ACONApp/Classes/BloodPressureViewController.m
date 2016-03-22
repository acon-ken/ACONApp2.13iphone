//
//  BloodPressureViewController.m
//  ACONApp
//
//  Created by Ken on 15/12/28.
//  Copyright © 2015年 zw. All rights reserved.
//

#import "BloodPressureViewController.h"

#import "BloodPressureMangerController.h"


#import "myAlertViewController.h"

//本地数据  处理
#import "PressureBool.h"


@interface BloodPressureViewController ()
{
    UILabel *dateLeftLabel;//日期Label
    UILabel *dateRightLabel;//显示 日期
    UIButton *dateButton;// 日期处理 button
    UILabel *dateTimeLeftLabel;//时间 label
    UILabel *dateTimeRightLabel;//显示时间
    UIButton *timeButton;// 时间处理 button
    UILabel *systolicLabel;//收缩压
    UITextField *systolicTextField;// 显示 收缩压 值

    UILabel *diastolicLabel;//舒张压
    UITextField *diastolicTextField;//显示 舒张压 值
    UILabel *heartRateLabel;//心率
    UITextField *heartRateTextField;// 显示心率 值
    
    UIButton *pressureControlBtn;//血压控制 按钮
    
    UIButton *remindPressureBtn;// 吃药 提请按钮
    UIDatePicker *datePic;//选择器
   
  
    UIView *view;//自定义  view
    
    
    
      FMDatabase *_db; //数据本地
    
   
    
    
}
@end



@implementation BloodPressureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"血压测量";
    self.view.backgroundColor = KBackgroundColor;
    
    self.navigationController.navigationBarHidden = NO;
    self.edgesForExtendedLayout = NO;
    
    
    
    _diastolicPText=[[UITextField alloc]init];
    _systolicPText=[[UITextField alloc]init];
    _heartRateText=[[UITextField alloc]init];
    _pressureDate=[[NSString alloc]init];
    _pressureTime=[[NSString alloc]init];
    
    // 数据 本地 处理
    
    
    //0.获得沙盒中的数据库文件名
   
    //1.创建数据库实例对象
    
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
    
    
    //2.创建 表格
    
    BOOL  p = [PressureBool createTableOnDB:_db withTableName:PRESSURETABLENAME];
    
    ZWLog(@"表格是否创建好 %d",p);
    
    
    
    
    // 添加主页 面
    
    [self creatPressureData];
    
    // 导航栏 加 返回和 保存按钮
    
    [self addBackAndSaveButton];
    
    // 添加 控制按钮
    [self creatPressureControlAndRemin];
    
   
}




-(void)addBackAndSaveButton{
    
    //给导航栏加一个返回按钮
    UIButton *leftbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftbackBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftbackBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateSelected];
    [leftbackBtn  addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    leftbackBtn.selected = YES;
    
    //给导航栏加右侧按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 40, 40);
    rightBtn.selected=YES;
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonitem  = [[UIBarButtonItem alloc] initWithCustomView:leftbackBtn];
    self.navigationItem.leftBarButtonItem=leftButtonitem;
    UIBarButtonItem *righButtonitemt  = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=righButtonitemt;
    
    
    
    
}



// 创建 主页 面
-(void)creatPressureData
{
  
   
    //测量日期
    dateLeftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width,0*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
    dateLeftLabel.text=@"测试日期:";
    dateLeftLabel.textAlignment= NSTextAlignmentLeft;
    
    
    [self.view addSubview:dateLeftLabel];
    
    dateRightLabel=[[UILabel alloc]initWithFrame:CGRectMake(210*XiShu_Width, 0*XiShu_Height , 100*XiShu_Width, 40*XiShu_Height)];
    dateRightLabel.textAlignment=NSTextAlignmentRight;
    
    //这个数据需要 选择器 选择的
    
   NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    dateRightLabel.text=locationString;
    
    [self.view addSubview:dateRightLabel];
    
    //日期选择器  button 处理
    dateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame=CGRectMake(200*XiShu_Width, 0*XiShu_Height, 120*XiShu_Width, 40*XiShu_Height);
    dateButton.backgroundColor=[UIColor clearColor];
    dateButton.alpha=1;
    
    [dateButton addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dateButton];
    
    
    
    
    
    //添加分割线1
    UIImageView *Lineimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40*XiShu_Height, KScreenWidth,1 )];
    Lineimage1.highlighted = YES;// flag
    Lineimage1.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage1];
    
    
    dateTimeLeftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width,41*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
    dateTimeLeftLabel.text=@"测试时间:";
    dateTimeLeftLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:dateTimeLeftLabel];
    
    dateTimeRightLabel=[[UILabel alloc]initWithFrame:CGRectMake(210*XiShu_Width, 41*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
    
    //这个数据需要 选择器 选择的
    NSDate *  time=[NSDate date];
    
    NSDateFormatter  *timeformatter=[[NSDateFormatter alloc] init];
    
    [timeformatter setDateFormat:@"HH:mm"];
    
    NSString *  locationtime=[timeformatter stringFromDate:time];
    
    dateTimeRightLabel.text=locationtime;
    
    dateTimeRightLabel.textAlignment=NSTextAlignmentRight ;
    
    
    [self.view addSubview:dateTimeRightLabel];
    
    
    // 时间选择器  button 处理
    
   timeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame=CGRectMake(200*XiShu_Width, 41*XiShu_Height, 120*XiShu_Width, 40*XiShu_Height);
    timeButton.backgroundColor=[UIColor clearColor];
    timeButton.alpha=1;
    
    [timeButton addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeButton];
    
    
    
    
    //添加分割线2
    UIImageView *Lineimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 81*XiShu_Height , KScreenWidth,1 )];
    Lineimage2.highlighted = YES;// flag
    Lineimage2.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage2];
    
    
    //收缩压
   systolicLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width, 82*XiShu_Height, 100*XiShu_Width , 40*XiShu_Height)];
    systolicLabel.text=@"收缩压:";
    systolicLabel.textAlignment=0;
    [self.view addSubview:systolicLabel];
    
   
    systolicTextField=[[UITextField alloc]initWithFrame:CGRectMake(110*XiShu_Width,82*XiShu_Height,100*XiShu_Width,40*XiShu_Height)];
    systolicTextField.allowsEditingTextAttributes=YES;
    
    systolicTextField.textAlignment=1;
    
    systolicTextField.placeholder=@"80~160";
    systolicTextField.delegate=self;
    
    systolicTextField.keyboardType= UIKeyboardTypeDecimalPad;
    
    [self.view addSubview:systolicTextField];
    
    
    UILabel *systolicRightLabel=[[UILabel alloc]initWithFrame:CGRectMake(210*XiShu_Width, 82*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
    systolicRightLabel.textAlignment=2;
    systolicRightLabel.text=@"mmHg";
    
    
    [self.view addSubview:systolicRightLabel];
    
    
    //添加分割线3
    UIImageView *Lineimage3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 122*XiShu_Height , KScreenWidth,1 )];
    Lineimage3.highlighted = YES;// flag
    Lineimage3.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage3];
    
    
    
    
    
    //舒张压
   diastolicLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width, 123*XiShu_Height, 100*XiShu_Width , 40*XiShu_Height)];
    diastolicLabel.text=@"舒张压:";
    diastolicLabel.textAlignment=0;
    [self.view addSubview:diastolicLabel];
    
    
    diastolicTextField=[[UITextField alloc]initWithFrame:CGRectMake(110*XiShu_Width,123*XiShu_Height,100*XiShu_Width,40*XiShu_Height)];
    diastolicTextField.allowsEditingTextAttributes=YES;
    diastolicTextField.delegate=self;
    
    diastolicTextField.textAlignment=1;
    
    diastolicTextField.placeholder=@"40~100";
   diastolicTextField.keyboardType= UIKeyboardTypeDecimalPad;
    
    [self.view addSubview:diastolicTextField];
    
    
    UILabel *diastolicRightLabel=[[UILabel alloc]initWithFrame:CGRectMake(210*XiShu_Width, 123*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
    diastolicRightLabel.textAlignment=2;
    diastolicRightLabel.text=@"mmHg";
    
    
    [self.view addSubview:diastolicRightLabel];
    
    
    //添加分割线4
    UIImageView *Lineimage4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 163*XiShu_Height , KScreenWidth,1 )];
    Lineimage4.highlighted = YES;// flag
    Lineimage4.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage4];
    
    
    //心率
   heartRateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width, 164*XiShu_Height, 100*XiShu_Width , 40*XiShu_Height)];
    heartRateLabel.text=@"心 率:";
    
    heartRateLabel.textAlignment=0;
    [self.view addSubview:heartRateLabel];
    
    
   heartRateTextField=[[UITextField alloc]initWithFrame:CGRectMake(110*XiShu_Width,164*XiShu_Height,100*XiShu_Width,40*XiShu_Height)];
    heartRateTextField.allowsEditingTextAttributes=YES;
    heartRateTextField.placeholder=@"70~150";
    heartRateTextField.delegate=self;
    
    heartRateTextField.textAlignment=1;
    heartRateTextField.keyboardType= UIKeyboardTypeDecimalPad;
    
    [self.view addSubview:heartRateTextField];
    
    
    UILabel *heartRateRightLabel=[[UILabel alloc]initWithFrame:CGRectMake(210*XiShu_Width, 164*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
    heartRateRightLabel.textAlignment=2;
    heartRateRightLabel.text=@"/Min";
    
    
    [self.view addSubview:heartRateRightLabel];
    
    //添加分割线5
    UIImageView *Lineimage5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 204*XiShu_Height , KScreenWidth,1 )];
    Lineimage5.highlighted = YES;// flag
    Lineimage5.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage5];
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    //调用系统时间
    NSDateFormatter *formatterDate=[[NSDateFormatter alloc]init];
    
    [formatterDate setDateFormat:@"HH:mm:ss"];//后台接口数据 使用值
    
    [formatterDate stringFromDate:[NSDate date]];//当前时间 默认值
    
    
    // 页面显示  使用值
    NSDateFormatter *formatterDate1=[[NSDateFormatter alloc]init];
    
    [formatterDate1 setDateFormat:@"HH:mm"];
    
    [formatterDate1 stringFromDate:[NSDate date]];
    
    
    
    
}


// 导航栏 按钮事件
-(void)backButtonClick:(id)sender{
    
     // 前期  处理
    pressureControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    [datePic removeFromSuperview];
    [view removeFromSuperview];

    //  清空 键入值
    [self clearWriter];
    
    
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)rightButton:(id)sender{
    
     // 前期  处理
    pressureControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
    // 字符串 转数据
    float systoValue=   [systolicTextField.text floatValue ];
  float diastoValue=  [diastolicTextField.text floatValue];
   float  heartValue=[heartRateTextField .text floatValue];
    
   
    
    if ((systoValue<80||systoValue>160)||(diastoValue<40||diastoValue>100)||(heartValue<70||heartValue>150)||(systolicTextField.text.length==0)||(diastolicTextField.text.length==0)||(heartRateTextField.text.length==0)) {
        
        ZWLog(@"进入 判断  ");
        
        if (systolicTextField.text.length==0) {
            
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"收缩压数值不能为空" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
            
        }
        
        if (diastolicTextField.text.length==0) {
            
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"舒张压数值不能为空" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
            
        }
        
        if (heartRateTextField.text.length==0) {
            
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"心率数值不能为空" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
            
        }
        
        if (systoValue<80||systoValue>160)
        {
            
            
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"收缩压数值有误请重新输入" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
            
            
            
        }
        
        
        
        
        
        if (diastoValue<40||diastoValue>100)
        {
            
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"舒张压数值有误请重新输入" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];

        }
        
        
        
        if (heartValue<70||heartValue>150)
        {
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"心率数值有误请重新输入" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];

    
            
        }
        
        
        
        
        
    }
    

    
    
    else{
    
        //数据 写入 服务器 或本地
        
        
        [PressureBool insertOnDB:_db withTableName:PRESSURETABLENAME withDate:dateRightLabel.text withTime:dateTimeRightLabel.text withSystolic:systolicTextField.text withDiatolic:diastolicTextField.text andWithHeartRate:heartRateTextField.text];
        
        
        // 后期数据 读取 前期 测试
        
        UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"提醒" message:@"血压数据已存储" preferredStyle:1];
        
        [AlertC addAction:[UIAlertAction actionWithTitle:@"继续输入" style:0 handler:^(UIAlertAction * _Nonnull action)
        {
            ZWLog(@"继续输入");
            // 清空键入 值
            
            [self clearWriter];
         
            
            
        } ]];
        
        
        [AlertC addAction:[UIAlertAction actionWithTitle:@"返回上页面" style:0 handler:^(UIAlertAction * _Nonnull action){
            ZWLog(@"返回上页");
            
              [self.navigationController popViewControllerAnimated:YES];
            
            
        } ]];
                           
       
        
        
        
        
      
        
        [self presentViewController:AlertC animated:YES completion:nil];
        
        
        
    }
    
    
   
    

    
    // 取消 响应
    [systolicTextField resignFirstResponder];
    [diastolicTextField resignFirstResponder];
    [heartRateTextField resignFirstResponder];
    
    

    
    
}
// 清空  键入值
-(void)clearWriter{
    
    
    
    NSDate *  date=[NSDate date];
    
    NSDateFormatter  *timeformatter=[[NSDateFormatter alloc] init];
    
    [timeformatter setDateFormat:@"HH:mm"];
    
    NSString *  locationtime=[timeformatter stringFromDate:date];
    
    dateTimeRightLabel.text=locationtime;
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:date];
    
    dateRightLabel.text=locationString;
    
    systolicTextField.text=nil;
    
    heartRateTextField.text=nil;
    
    diastolicTextField.text=nil;
    
    
    
    
    
}


// 创建 控制按钮
-(void)creatPressureControlAndRemin
{
    
    pressureControlBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    pressureControlBtn.frame=CGRectMake(50*XiShu_Width, 288*XiShu_Height, 100*XiShu_Width, 40);
    
    [pressureControlBtn setTitle:@"血压数据" forState:UIControlStateNormal ];
    [pressureControlBtn setBackgroundImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
    pressureControlBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [pressureControlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pressureControlBtn.selected=YES;
    
    [pressureControlBtn addTarget:self action:@selector(goMangerView:) forControlEvents:  UIControlEventTouchUpInside];
    
    [self.view addSubview:pressureControlBtn];
    
    
    remindPressureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    remindPressureBtn.frame=CGRectMake(170*XiShu_Width, 288*XiShu_Height, 100*XiShu_Width, 40);
    [remindPressureBtn setTitle:@"吃药提醒" forState:UIControlStateNormal];
    [remindPressureBtn setBackgroundImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
    remindPressureBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    
    [remindPressureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    remindPressureBtn.selected=YES;
    [remindPressureBtn addTarget:self action:@selector(toMangerView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:remindPressureBtn];
    
    
    
    
}
//  按钮 跳转到 血压数据 页面
-(void)goMangerView:(UIButton *)sender
{
    BloodPressureMangerController *bPMVC=[[BloodPressureMangerController alloc]init];
    
    
    [self.navigationController pushViewController:bPMVC animated:YES];
    
    
    
    
    
    
}

//  按钮 跳转到 提醒 页面
-(void)toMangerView:(UIButton *)sender
{
    
    
    
    myAlertViewController *alertVC=[[myAlertViewController alloc]init];
    
    [self.navigationController pushViewController:alertVC animated:YES];
    
    
    
    
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    //[pressuredatePicker removeFromSuperview];
    
    [self.view endEditing:YES];
    pressureControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    
    [view removeFromSuperview];
    [datePic removeFromSuperview];
    
}



//键盘 回收 效果
#pragma mark -UITextFieldDelegate 代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==systolicTextField) {
        [diastolicTextField becomeFirstResponder];
        return YES;
    }
    if (textField==diastolicTextField) {
        [heartRateTextField becomeFirstResponder];
        return YES;
    }
    if (textField==heartRateTextField) {
        [heartRateTextField resignFirstResponder];
        return YES;
    }
    
    
    [view removeFromSuperview];
    [datePic removeFromSuperview];
   
    
    
    return NO;
}


- (void)textFieldDidChange:(UITextField *)textField{
    
    
    //  添加 判断 条件
    
 
    
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
    textField.inputAccessoryView = view1;
    view1.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(Screen_Width - 40, 0, 40, 30);
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState: UIControlStateNormal];
    [btn addTarget:self action:@selector(checkButton) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];
    [textField reloadInputViews];
    
   // NSLog(@"*********");
   
    pressureControlBtn.hidden=YES;
    remindPressureBtn.hidden=YES;
    
    
    
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
   
    return YES;
    
}


//限定输入内容的范围
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
        
    {
        
        return YES;
        
    }
    
    
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    
    
    if (heartRateTextField == textField)  //判断是否时我们想要限定的那个输入框
        
    {
        
        if ([toBeString length] > 3) { //如果输入框内容大于3则弹出警告  位数  大小转为Valus
            
            textField.text = [toBeString substringToIndex:3];
            
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"请输入正确的数值" preferredStyle:1];
            
          
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:^(UIAlertAction * _Nonnull action){
                //NSLog(@"ok");
            
                
            } ]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
            

            return NO; 
            
        } 
        
    } 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    return YES;
}

- (void)checkButton {
    [self.view endEditing:YES];
    
    pressureControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    
    
}

//日期选择器 事件
-(void)selectDate:(UIButton *)sender
{
    datePic=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 360*XiShu_Height, Screen_Width, 168*XiShu_Height)];
    datePic.datePickerMode=UIDatePickerModeDate;
    datePic.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:datePic];
    
    
    view=[[UIView alloc]initWithFrame:CGRectMake(0,360*XiShu_Height,Screen_Width,40*XiShu_Height)];
    
    view.backgroundColor=IWColor(76, 193, 210);
    
    [self.view addSubview:view];
    
    
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10*XiShu_Width,5*XiShu_Height, 40*XiShu_Width,30*XiShu_Height);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal ];
    leftBtn.backgroundColor=[UIColor clearColor];
    [leftBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];

    
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(270*XiShu_Width,5*XiShu_Height, 40*XiShu_Width,30*XiShu_Height);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal ];
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    

    
    
    //NSLog(@"show   date pickerview");
    
    
    pressureControlBtn.hidden=YES;
    remindPressureBtn.hidden=YES;
    [self.view endEditing:YES];

    
}
// 日期 自定义 按钮
-(void)cancel:(UIButton *)sender
{

    pressureControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    [datePic removeFromSuperview];
    
    [view removeFromSuperview];
    
}
// 日期 自定义 按钮

-(void)finish:(UIButton *)sender{
    
    pressureControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    
    
    NSDate *senddate=datePic.date;
    
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    //[dateformatter setDateFormat:@"HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    
    
    dateRightLabel.text=locationString;
    
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
    
    
}


//时间选择器 事件
-(void)selectTime:(UIButton *)sender{
    
    
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
    
    datePic=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 400*XiShu_Height, Screen_Width, 118*XiShu_Height)];
    datePic.datePickerMode=UIDatePickerModeTime;
    datePic.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:datePic];
    
    
    view=[[UIView alloc]initWithFrame:CGRectMake(0,360*XiShu_Height,Screen_Width,40*XiShu_Height)];
    
    view.backgroundColor=IWColor(76, 193, 210);
    
    [self.view addSubview:view];
    
    
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(10*XiShu_Width,10*XiShu_Height, 40*XiShu_Width,30*XiShu_Height);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal ];
    leftBtn.backgroundColor=[UIColor clearColor];
    [leftBtn addTarget:self action:@selector(timecancel:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    
    
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(270*XiShu_Width,10*XiShu_Height, 40*XiShu_Width,30*XiShu_Height);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal ];
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(timefinish:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    
    
    
    
    
    
    pressureControlBtn.hidden=YES;
    remindPressureBtn.hidden=YES;

    
    [self.view endEditing:YES];
    
    
    // NSLog(@"show  time  pickerview");
    
 
    
}
// 时间 自定义 按钮
-(void)timecancel:(UIButton *)sender
{
    
    pressureControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
}


// 时间 自定义 按钮

-(void)timefinish:(UIButton *)sender{
    
    pressureControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    
    
    NSDate *senddate=datePic.date;
    
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HH:mm"];
    
   
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    
    
    dateTimeRightLabel.text=locationString;
    
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
    
    
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

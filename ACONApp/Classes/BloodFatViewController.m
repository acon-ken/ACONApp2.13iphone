//
//  BloodFatViewController.m
//  ACONApp
//
//  Created by Ken on 15/12/28.
//  Copyright © 2015年 zw. All rights reserved.
//

#import "BloodFatViewController.h"

#import "BloodFatMangerController.h"


#import "myAlertViewController.h"

//本地数据 处理
#import "FatBool.h"


@interface BloodFatViewController ()
{
    UILabel *dateLeftLabel;//日期label
    UILabel *dateRightLabel;// 日期 显示 值
    UIButton *dateButton;//日期 处理button
    UILabel *dateTimeLeftLabel;// 时间 label
    UILabel *dateTimeRightLabel;//时间 显示值
    UIButton *timeButton;//时间处理button
    UILabel *cholesterolLabel;//总胆固醇 label
    UITextField *cholesterolTextField;//总胆固醇 显示值
    UILabel *triglycerideLabel;//甘油三酯 label
    UITextField *triglycerideTextField;//甘油三酯 显示 值
    UILabel *highdensityLipoproteinLabel;//高密度脂蛋白 label
    UITextField *highdensityLipoproteinField;//高密度脂蛋白 显示 值
    UILabel *lowdensityLipoproteinLabel;//低密度脂蛋白、 label
    UITextField *lowdensityLipoproteinField;//低密度脂蛋白 显示值
    
    UILabel *speclificValueLabel;// 总胆固醇与高密度脂蛋白比值 label
    UITextField *speclificValueField;//总胆固醇与高密度脂蛋白比值 显示 值
    
    UIButton *fatControlBtn;//血脂 控制 按钮
    
    UIButton *remindPressureBtn;//吃药提醒 按钮
    
    UIDatePicker *datePic;//选择器
    
    
    UIView *view;//自定义  view
    
    
   FMDatabase *_db; //数据本地
    
}

@end



@implementation BloodFatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"血脂测量(空腹值)";
    
    self.view.backgroundColor = KBackgroundColor;
    
    self.navigationController.navigationBarHidden = NO;
    self.edgesForExtendedLayout = NO;
    
    // 初始化
    _cholesterolText=[[UITextField alloc]init];
    _triglycerideText=[[UITextField alloc]init];
    _highdensityLipoproteinText=[[UITextField alloc]init];
    _lowdensityLipoproteinText=[[UITextField alloc]init];
    _speclificValue=0;
    
    
    
    // 数据 本地 处理
    
    
    //0.获得沙盒中的数据库文件名
    
    //1.创建数据库实例对象
    
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
    
    //2.创建 表格
    
    BOOL  p = [FatBool createTableOnDB:_db withTableName:FATTABLENAME];
    
    ZWLog(@"表格是否创建好 %d",p);
    
    
    
    
    
    // 导航栏 加 返回和 保存按钮
    
    [self addBackAndSaveButton];
    
    //  页面 中部数据 键入
    
    [self creatMiddleView];
    
    // 页面下部按钮 事件
    [self creatControlAndRemind];
    
    
    
    
    
}


// 导航栏 加 返回和 保存按钮
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


// 导航栏 按钮事件
 //导航栏 返回按钮事件
-(void)backButtonClick:(id)sender
{
     // 前期  处理
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
    fatControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    
    
    // 清空 键入
    [self clearWriter];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//导航栏  Save按钮事件
-(void)rightButton:(id)sender
{
    
    // 前期  处理
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
    fatControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    
    // 字符串转  数据
   float  cholesValue= [cholesterolTextField.text floatValue];
    float trigValue=[triglycerideTextField.text floatValue];
   float highValue= [highdensityLipoproteinField.text floatValue];
  float lowValue=  [lowdensityLipoproteinField.text floatValue];
    
    
    if ((cholesValue<2.0||cholesValue>6.0)||(trigValue<0||trigValue>2.0)||(highValue<0.5||highValue>2.0)||(lowValue<0||lowValue>3.5)||(cholesterolTextField.text.length==0)||(triglycerideTextField.text.length==0)||(highdensityLipoproteinField.text.length==0)||(lowdensityLipoproteinField.text.length==0)) {
        
        if (cholesterolTextField.text.length==0) {
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"总胆固醇数值不能为空" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
            
        }
        
        if (triglycerideTextField.text.length==0) {
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"甘油三酯数值不能为空" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
        }
        
        if (highdensityLipoproteinField.text.length==0) {
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"高密度脂蛋白数值不能为空" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
        }
        if (lowdensityLipoproteinField.text.length==0) {
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"低密度脂蛋白数值不能为空" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
            
        }
        if (cholesValue<2.0||cholesValue>6.0)
        {
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"总胆固醇数值有误请重新输入" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];

        }
        if (trigValue<0||trigValue>2.0)
        {
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"甘油三酯数值有误请重新输入" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
        }
        if (highValue<0.5||highValue>2.0)
        {
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"高密度脂蛋白数值有误请重新输入" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
        }
        
        
        if (lowValue<0||lowValue>3.5)
        {
            UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"警告" message:@"低密度脂蛋白数值有误请重新输入" preferredStyle:1];
            
            [AlertC addAction:[UIAlertAction actionWithTitle:@"ok" style:1 handler:nil]];
            
            [self presentViewController:AlertC animated:YES completion:nil];
        }
        
        
        
        
        
    }
    
    else{
        //数据写入 本地 数据库文件
        
        
        
        
        //数据  写入 服务器
        
        
        [FatBool insertOnDB:_db withTableName:FATTABLENAME withFatDate:dateRightLabel.text withFatTime:dateTimeRightLabel.text withCholesterol:cholesterolTextField.text withTriglyceride:triglycerideTextField.text withHighdensityLipoprotein:highdensityLipoproteinField.text withLowdensityLipoprotein:lowdensityLipoproteinField.text withSpeclificValue:[speclificValueField.text floatValue]];
        
        
        
        
        // 后期数据 读取 前期 测试
        UIAlertController *AlertC=[UIAlertController alertControllerWithTitle:@"提醒" message:@"血脂数据已存储" preferredStyle:1];
        
        [AlertC addAction:[UIAlertAction actionWithTitle:@"继续输入" style:0 handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"继续输入");
            
            // 清空 键入
            [self clearWriter];
            
            
        } ]];
        
        
        
        [AlertC addAction:[UIAlertAction actionWithTitle:@"返回上页面" style:0 handler:^(UIAlertAction * _Nonnull action){
            ZWLog(@"返回上页");
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        } ]];
        
        [self presentViewController:AlertC animated:YES completion:nil];
        
      
        
    }
    

    
    // 取消 响应
    [cholesterolTextField resignFirstResponder];
    [triglycerideTextField resignFirstResponder];
    [highdensityLipoproteinField resignFirstResponder];
    [lowdensityLipoproteinField resignFirstResponder];
    [speclificValueField resignFirstResponder];
    
    
    
    
}

// 清空 输入值

-(void)clearWriter{
    
    
    
    
    
    NSDate *  time=[NSDate date];
    
    NSDateFormatter  *timeformatter=[[NSDateFormatter alloc] init];
    
    [timeformatter setDateFormat:@"HH:mm"];
    
    NSString *  locationtime=[timeformatter stringFromDate:time];
    dateTimeRightLabel.text=locationtime;
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:time];
    dateRightLabel.text=locationString;
    
    
    
    cholesterolTextField.text=nil;
    triglycerideTextField.text=nil;
    highdensityLipoproteinField.text=nil;
    lowdensityLipoproteinField.text=nil;
    speclificValueField.text=nil;
    
    
    
    
}

// 数据键入  中部页面创建
-(void)creatMiddleView{
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
    
    //总胆固醇
   cholesterolLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width, 82*XiShu_Height, 100*XiShu_Width , 40*XiShu_Height)];
    cholesterolLabel.text=@"总胆固醇:";
    cholesterolTextField.clearsOnBeginEditing=YES;
    cholesterolLabel.textAlignment=0;
    [self.view addSubview:cholesterolLabel];
    
    
   cholesterolTextField=[[UITextField alloc]initWithFrame:CGRectMake(110*XiShu_Width,82*XiShu_Height,100*XiShu_Width,40*XiShu_Height)];
    cholesterolTextField.allowsEditingTextAttributes=YES;
    
    cholesterolTextField.delegate=self;
    cholesterolTextField.placeholder=@"2.0~6.0";
    
    
    cholesterolTextField.textAlignment=1;
    cholesterolTextField.keyboardType= UIKeyboardTypeDecimalPad;  //UIKeyboardTypeDecimalPad
    
    [self.view addSubview:cholesterolTextField];
    
    
   UILabel *cholesterolRightLabel=[[UILabel alloc]initWithFrame:CGRectMake(210*XiShu_Width, 82*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
    cholesterolRightLabel.textAlignment=2;
    cholesterolRightLabel.text=@"mmol/L";

    
    [self.view addSubview:cholesterolRightLabel];
    
    //添加分割线3
    UIImageView *Lineimage3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 122*XiShu_Height , KScreenWidth,1 )];
    Lineimage3.highlighted = YES;// flag
    Lineimage3.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage3];

    
    //甘油三酯
 triglycerideLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width, 123*XiShu_Height, 100*XiShu_Width , 40*XiShu_Height)];
    triglycerideLabel.text=@"甘油三酯:";
    triglycerideLabel.textAlignment=0;
    [self.view addSubview:triglycerideLabel];
    
    
    triglycerideTextField=[[UITextField alloc]initWithFrame:CGRectMake(110*XiShu_Width,123*XiShu_Height,100*XiShu_Width,40*XiShu_Height)];
    triglycerideTextField.allowsEditingTextAttributes=YES;
    
    triglycerideTextField.delegate=self;
    triglycerideTextField.placeholder=@"0~2.0";
    
    
    triglycerideTextField.textAlignment=1;
    triglycerideTextField.keyboardType= UIKeyboardTypeDecimalPad;
    
    [self.view addSubview:triglycerideTextField];
    
    
    UILabel *triglycerideRightLabel=[[UILabel alloc]initWithFrame:CGRectMake(210*XiShu_Width, 123*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
   triglycerideRightLabel.textAlignment=2;
   triglycerideRightLabel.text=@"mmol/L";
    
    
    [self.view addSubview:triglycerideRightLabel];

    
    //添加分割线4
    UIImageView *Lineimage4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 163*XiShu_Height , KScreenWidth,1 )];
    Lineimage4.highlighted = YES;// flag
    Lineimage4.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage4];

    
    //高密度脂蛋白
   highdensityLipoproteinLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width, 164*XiShu_Height, 120*XiShu_Width , 40*XiShu_Height)];
    highdensityLipoproteinLabel.text=@"高密度脂蛋白:";
    highdensityLipoproteinField.clearsOnBeginEditing = YES;
    highdensityLipoproteinLabel.textAlignment=0;
    [self.view addSubview:highdensityLipoproteinLabel];
    
    
    highdensityLipoproteinField=[[UITextField alloc]initWithFrame:CGRectMake(110*XiShu_Width,164*XiShu_Height,100*XiShu_Width,40*XiShu_Height)];
    highdensityLipoproteinField.allowsEditingTextAttributes=YES;
    
    highdensityLipoproteinField.delegate=self;
    highdensityLipoproteinField.placeholder=@"0.5~2.0";
    
   highdensityLipoproteinField.textAlignment=1;
    highdensityLipoproteinField.keyboardType=UIKeyboardTypeDecimalPad ;
    
    [self.view addSubview:highdensityLipoproteinField];
    
    
    UILabel *highdensityLipoproteinRightLabel=[[UILabel alloc]initWithFrame:CGRectMake(210*XiShu_Width, 164*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
   highdensityLipoproteinRightLabel.textAlignment=2;
   highdensityLipoproteinRightLabel.text=@"mmol/L";
    
    
    [self.view addSubview:highdensityLipoproteinRightLabel];
    
    
    //添加分割线5
    UIImageView *Lineimage5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 204*XiShu_Height , KScreenWidth,1 )];
    Lineimage5.highlighted = YES;// flag
    Lineimage5.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage5];

    
    //低密度脂蛋白
   lowdensityLipoproteinLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width, 205*XiShu_Height, 120*XiShu_Width , 40*XiShu_Height)];
    lowdensityLipoproteinLabel.text=@"低密度脂蛋白:";
    lowdensityLipoproteinLabel.textAlignment=0;
    [self.view addSubview:lowdensityLipoproteinLabel];
    
    
    lowdensityLipoproteinField=[[UITextField alloc]initWithFrame:CGRectMake(110*XiShu_Width,205*XiShu_Height,100*XiShu_Width,40*XiShu_Height)];
    lowdensityLipoproteinField.allowsEditingTextAttributes=YES;
    
    lowdensityLipoproteinField.delegate=self;
    lowdensityLipoproteinField.placeholder=@"0~3.5";
    lowdensityLipoproteinField.textAlignment=1;
    lowdensityLipoproteinField.keyboardType= UIKeyboardTypeDecimalPad;
    
    [self.view addSubview:lowdensityLipoproteinField];
    
    
    UILabel *lowdensityLipoproteinRightLabel=[[UILabel alloc]initWithFrame:CGRectMake(210*XiShu_Width, 205*XiShu_Height, 100*XiShu_Width, 40*XiShu_Height)];
    lowdensityLipoproteinRightLabel.textAlignment=2;
    lowdensityLipoproteinRightLabel.text=@"mmol/L";
    
    
    [self.view addSubview:lowdensityLipoproteinRightLabel];
    
    
    //添加分割线6
    UIImageView *Lineimage6 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 245*XiShu_Height , KScreenWidth,1 )];
    Lineimage6.highlighted = YES;// flag
    Lineimage6.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage6];

    
    
    //总胆固醇与高密度脂蛋白比值
    speclificValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*XiShu_Width,246*XiShu_Height, 120*XiShu_Width , 60*XiShu_Height)];
    speclificValueLabel.text=@"总胆固醇与高密度脂蛋白比值:";//label 2 line
    speclificValueLabel.numberOfLines=2;//两行 限制
   speclificValueLabel.textAlignment=0;
    [self.view addSubview:speclificValueLabel];
    
    
    speclificValueField=[[UITextField alloc]initWithFrame:CGRectMake(110*XiShu_Width,246*XiShu_Height,100*XiShu_Width,40*XiShu_Height)];
    speclificValueField.allowsEditingTextAttributes=YES;
    
    speclificValueField.delegate=self;
    speclificValueField.userInteractionEnabled=NO; // 不可输入
    //speclificValueField.isEditing=NO;
    speclificValueField.delegate=self;
    speclificValueField.textAlignment=1;
    speclificValueField.keyboardType= UIKeyboardTypeDecimalPad;
    
    [self.view addSubview:speclificValueField];
    
    
    
    //添加分割线7
    UIImageView *Lineimage7 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 306*XiShu_Height , KScreenWidth,1 )];
    Lineimage7.highlighted = YES;// flag
    Lineimage7.image = [UIImage imageNamed:@"xian"];
    [self.view addSubview:Lineimage7];
    
    
    
    
    
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




// 页面下部按钮 事件
-(void)creatControlAndRemind{
    fatControlBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fatControlBtn.frame=CGRectMake(50*XiShu_Width, 370*XiShu_Height, 100*XiShu_Width, 40);
    
    [fatControlBtn setTitle:@"血脂数据" forState:UIControlStateNormal ];
    [fatControlBtn setBackgroundImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
    fatControlBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [fatControlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    fatControlBtn.selected=YES;
    
    [fatControlBtn addTarget:self action:@selector(goFatMangerViewC:) forControlEvents:  UIControlEventTouchUpInside];
    
    [self.view addSubview:fatControlBtn];
    
    
    remindPressureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    remindPressureBtn.frame=CGRectMake(170*XiShu_Width, 370*XiShu_Height, 100*XiShu_Width, 40);
    [remindPressureBtn setTitle:@"吃药提醒" forState:UIControlStateNormal];
    [remindPressureBtn setBackgroundImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
    remindPressureBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    
    [remindPressureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    remindPressureBtn.selected=YES;
    [remindPressureBtn addTarget:self action:@selector(toFatMangerViewR:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:remindPressureBtn];

    
    
    
    
    
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
   

    
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    fatControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    
}



//键盘 回收 效果
#pragma mark -UITextFieldDelegate 代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
   //弹出键盘   视图 上移
        self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-50*XiShu_Height, self.view.frame.size.width, self.view.frame.size.height);
     [UIView setAnimationDuration:0.1];
    
     //self.navigationController.navigationBarHidden = YES;
    
    
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
    
    //NSLog(@"*********");
    
    fatControlBtn.hidden=YES;
    remindPressureBtn.hidden=YES;
    
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
    
    
    
    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    if (textField==cholesterolTextField) {
        [triglycerideTextField becomeFirstResponder];
        return YES;
    }
    if (textField==triglycerideTextField) {
        [highdensityLipoproteinField  becomeFirstResponder];
        return YES;
    }
    if (textField==lowdensityLipoproteinField) {
        [speclificValueField becomeFirstResponder];
        return YES;
    }
    if (textField==speclificValueField) {
        [speclificValueField resignFirstResponder];
        return YES;
    }
    
    return NO;
}
- (void)textFieldDidChange:(UITextField *)textField{
    
    
    //  添加 判断 条件
    
    
    
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    
    
    
    
  float a= [cholesterolTextField.text floatValue];
  float b= [highdensityLipoproteinField.text floatValue];
    if (b!=0&&a!=0&&triglycerideTextField.text.length!=0&&lowdensityLipoproteinField.text.length!=0) {//确保信息 当俩个都有值时 才显示
        float c =(float)a/(float)b;
        speclificValueField.text=[NSString stringWithFormat:@"%0.4f",c];
    }
    
    
    
    
   
    
    //键盘消失   视图 上移效果消失
     self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+50*XiShu_Height, self.view.frame.size.width, self.view.frame.size.height);
    

     //self.navigationController.navigationBarHidden = NO;
    
    [UIView setAnimationDuration:0.3];
    
    return YES;
}



- (void)checkButton {
    [self.view endEditing:YES];
    
    
    fatControlBtn.hidden=NO;
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
    leftBtn.frame=CGRectMake(10*XiShu_Width,10*XiShu_Height, 40*XiShu_Width,30*XiShu_Height);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal ];
    leftBtn.backgroundColor=[UIColor clearColor];
    [leftBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    
    
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(270*XiShu_Width,10*XiShu_Height, 40*XiShu_Width,30*XiShu_Height);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal ];
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    
    
    
    //NSLog(@"show   date pickerview");
    
    
   fatControlBtn.hidden=YES;
    remindPressureBtn.hidden=YES;
    [self.view endEditing:YES];
    

    
    
    
    
    
}

// 日期 自定义 按钮
-(void)cancel:(UIButton *)sender
{
    
   fatControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
}
// 日期 自定义 按钮

-(void)finish:(UIButton *)sender{
    
    fatControlBtn.hidden=NO;
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
    
    
    datePic=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 360*XiShu_Height, Screen_Width, 168*XiShu_Height)];
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
    
    
    
    
    
    
    
    fatControlBtn.hidden=YES;
    remindPressureBtn.hidden=YES;
    
    
    [self.view endEditing:YES];
    
    
    
    
    
    
}

// 时间 自定义 按钮
-(void)timecancel:(UIButton *)sender
{
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
    fatControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
   
}


// 时间 自定义 按钮

-(void)timefinish:(UIButton *)sender{
    
   fatControlBtn.hidden=NO;
    remindPressureBtn.hidden=NO;
    
    
    NSDate *senddate=datePic.date;
    
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HH:mm"];
    
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    
    
    dateTimeRightLabel.text=locationString;
    
    [datePic removeFromSuperview];
    [view removeFromSuperview];
    
    
    
}



    
  //页面 转换到 提醒 页面
-(void)toFatMangerViewR:(UIButton *)sender{
    
    
    
    myAlertViewController *alertVC=[[myAlertViewController alloc]init];
    
    [self.navigationController pushViewController:alertVC
                                         animated:YES];
    
    
    
    
    
    
    
}




//页面 转换到  血脂数据 页面
-(void)goFatMangerViewC:(UIButton *)sender{
    
    BloodFatMangerController *fatMangerVC=[[BloodFatMangerController alloc]init];
    
    
    [self.navigationController pushViewController:fatMangerVC
                                         animated:YES];
    
    
    
    
    
    
    
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

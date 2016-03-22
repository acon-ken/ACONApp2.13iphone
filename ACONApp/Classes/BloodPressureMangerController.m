//
//  BloodPressureMangerController.m
//  ACONApp
//
//  Created by Ken on 15/12/28.
//  Copyright © 2015年 zw. All rights reserved.
//

#import "BloodPressureMangerController.h"

#import "DVSwitch.h"
#import "SelectDataViewController.h"




#import "DataChangeControllerView.h"
#import "DataListModel.h"

#import "pressureDataCell.h"// 自定义  cell


#import <MessageUI/MFMailComposeViewController.h>//邮件
#import "MFMailComposeViewController+EndEditing.h"

//本地化数据的 处理
#import "PressureBool.h"

@interface BloodPressureMangerController()<MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    
    
     MFMailComposeViewController *picker;
    
    NSString *begindate;
    NSString *enddate;
    
    NSMutableArray *_dataListArr;
    
    NSString *  timerString;
    
    LoginInfoModel *userinfo;
    

    int  pageindex;
    
    NSString *GetmaxStr; //通过接口获取来的最大值
    NSString *GetminStr;  //通过接口获取来的最小值
    
    NSString *HTMLStr;
    
    NSString *secondSwitchStatusstr; //饼状图选择天数控件的状态
    
    NSString * currenttimerstr;// 用来暂时存放自定义时间的字符串
    
    
    // 本地化数据处理  获取数据的 数组
    NSMutableArray *pressureDateArray;
    
    NSMutableArray *pressureTimeArray;
    NSMutableArray *systolicArray;
    NSMutableArray *diastolicArray;
    NSMutableArray *heartRateArray;
    
    NSMutableArray *markArray;
    
    FMDatabase *_db; //数据本地
    
}

@property (nonatomic,strong)UITableView *tableView;
@end




@implementation BloodPressureMangerController
static int dateCount;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.title=@"血压数据列表";
    self.view.backgroundColor = KBackgroundColor;
    
    self.navigationController.navigationBarHidden = NO;
    self.edgesForExtendedLayout = NO;
    
    //初始化 数据
    pressureDateArray=[NSMutableArray array];
    pressureTimeArray=[NSMutableArray array];
    systolicArray=[NSMutableArray array];
    diastolicArray=[NSMutableArray array];
    heartRateArray=[NSMutableArray array];
    markArray=[NSMutableArray array];
    
    
    // 从数据库中 获取数据
    
    [self getDataFromSqlite];
    
    
    
    // 导航栏 按钮
    
    [self createNavigation];
    
    ////  日期  选择 栏
    
    [self createHeaderView];
    //显示数据 用表 直观的 显示数据数值
    
   [self createTableView];
    
    
}

// 从数据库中 获取数据
-(void)getDataFromSqlite
{
    
    // 先把  对应得的数据库文件打开
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
    
    
    //1.查询数据
    FMResultSet *rs =[PressureBool queryOnDB:_db withTableName:PRESSURETABLENAME];
    
    //2.遍历结构集
    while(rs.next){
        
        //ZWLog(@"执行了这段代码2");
        int ID = [rs intForColumn:@"id"];
        NSString *pressureDate = [rs stringForColumn:PressureDate];
        NSString *pressureTime = [rs stringForColumn:PressureTime];
        NSString *systolic=[rs stringForColumn:SystolicPressure];
        NSString *diastolic=[rs stringForColumn:DiastolicPressure];
        NSString *heartRate=[rs stringForColumn:HeartRate];
        
        [markArray addObject:[NSString stringWithFormat:@"%d",ID]];
        [pressureDateArray addObject:pressureDate];
        [pressureTimeArray addObject:pressureTime];
        [systolicArray addObject:systolic];
        [diastolicArray addObject:diastolic];
        [heartRateArray addObject:heartRate];
    
    }
    
    
    //ZWLog(@"\n mark- %@\ndate-%@ \n time-%@ \n systolic-%@\n diastolic-%@\n heartrate-%@",markArray,pressureDateArray,pressureTimeArray,systolicArray,diastolicArray,heartRateArray);
    
    
    
}



// 导航栏 按钮 事件

-(void)createNavigation{
    
    
    //给导航栏加一个返回按钮
    UIButton *leftbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftbackBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftbackBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateSelected];
    [leftbackBtn  addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    leftbackBtn.selected = YES;
    
    
    UIBarButtonItem *leftButtonitem  = [[UIBarButtonItem alloc] initWithCustomView:leftbackBtn];
    self.navigationItem.leftBarButtonItem=leftButtonitem;
    
    //给导航栏加右侧按钮
    UIButton *exportBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [exportBtn setTitle:@"导出" forState:UIControlStateNormal];
    [exportBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [exportBtn  addTarget:self action:@selector(exportBtn) forControlEvents:UIControlEventTouchUpInside];
    exportBtn.selected = YES;
    
    
    UIBarButtonItem *righButtonitemt  = [[UIBarButtonItem alloc] initWithCustomView:exportBtn];
    self.navigationItem.rightBarButtonItem=righButtonitemt;

    
    
    
    
    
    
    
}
//  日期  选择 栏

- (void)createHeaderView
{
    
  //  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveIdexx:) name:@"senderData" object:Nil];
    /*****/
    NSArray *dataArr;
    if (timerString == nil) {
        dataArr = @[@"7", @"14", @"30", @"60", @"90",@"自定义"];
    }
    else
    {
        dataArr = @[@"7", @"14", @"30", @"60", @"90",timerString,@"自定义"];
    }
    DVSwitch *secondSwitch ;
    
    //timerString = @"自定义";
    secondSwitch = [DVSwitch switchWithStringsArray:dataArr];
    secondSwitch.frame = CGRectMake(0, 0, KScreenWidth, 40);
    secondSwitch.backgroundColor = [UIColor whiteColor];
    secondSwitch.sliderColor = KCommonColor;
    secondSwitch.labelTextColorInsideSlider = [UIColor whiteColor];
    secondSwitch.labelTextColorOutsideSlider = KCommonColor;
    secondSwitch.cornerRadius = 0;
    
    if (currenttimerstr !=nil) {
        
        
        [secondSwitch forceSelectedIndex:5 animated:YES];
    }else{
        
        if (secondSwitchStatusstr==nil) {
            
            [secondSwitch forceSelectedIndex:0 animated:YES];
            
        }else{
            
            [secondSwitch forceSelectedIndex:[secondSwitchStatusstr integerValue] animated:YES];
        }
        
    }
    
    [secondSwitch setPressedHandler:^(NSUInteger index) {
        
        
        switch (index) {
            case 0:
            {
                secondSwitchStatusstr = @"0";
                currenttimerstr = nil;
                
                NSDate *senddate=[NSDate date];
                
                NSDate *begindateCST = [senddate dateByAddingTimeInterval:-60*60*24*7];
                
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                
                begindate =[dateformatter stringFromDate:begindateCST];
                dateCount=7;
                [self.tableView  reloadData];
                // [self getDataList:1];
            }
                break;
            case 1:
            {
                secondSwitchStatusstr = @"1";
                currenttimerstr = nil;
                
                NSDate *senddate=[NSDate date];
                
                NSDate *begindateCST = [senddate dateByAddingTimeInterval:-60*60*24*14];
                
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                
                begindate =[dateformatter stringFromDate:begindateCST];
                
                dateCount=14;
                [self.tableView  reloadData];
                
                // [self getDataList:1];
            }
                break;
            case 2:
            {
                secondSwitchStatusstr = @"2";
                currenttimerstr = nil;
                
                NSDate *senddate=[NSDate date];
                
                NSDate *begindateCST = [senddate dateByAddingTimeInterval:-60*60*24*30];
                
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                
                begindate =[dateformatter stringFromDate:begindateCST];
             
                dateCount=30;
                [self.tableView  reloadData];
                
                // [self getDataList:1];
            }
                break;
            case 3:
            {
                secondSwitchStatusstr = @"3";
                currenttimerstr = nil;
                
                
                
                NSDate *senddate=[NSDate date];
                
                NSDate *begindateCST = [senddate dateByAddingTimeInterval:-60*60*24*60];
                
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                
                begindate =[dateformatter stringFromDate:begindateCST];
                dateCount=60;
                [self.tableView  reloadData];
                
                // [self getDataList:1];
            }
                break;
                
            case 4:
            {
                secondSwitchStatusstr = @"4";
                currenttimerstr = nil;
                
                NSDate *senddate=[NSDate date];
                
                NSDate *begindateCST = [senddate dateByAddingTimeInterval:-60*60*24*90];
                
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                
                begindate =[dateformatter stringFromDate:begindateCST];
                dateCount=90;
                [self.tableView  reloadData];
                
                // [self getDataList:1];
            }
                break;
            case 5:
            {
                
                if (timerString ==nil) {
                    
                    SelectDataViewController *vc = [[SelectDataViewController alloc] init];
                    [self.navigationController pushViewController: vc animated:YES];
                }else{
                    
                    currenttimerstr =[NSString stringWithFormat:@"%@",timerString];
                    int times = (int)[timerString integerValue];
                    NSDate *senddate=[NSDate date];
                    NSDate *begindateCST = [senddate dateByAddingTimeInterval:-60*60*24*times];
                    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                    
                    [dateformatter setDateFormat:@"yyyy-MM-dd"];
                    
                    begindate =[dateformatter stringFromDate:begindateCST];
                    
                    //[self getDataList:1];
                }
                
            }
                break;
            case 6:
            {
                
                
                SelectDataViewController *vc = [[SelectDataViewController alloc] init];
                [self.navigationController pushViewController: vc animated:YES];
                
            }
            default:
                break;
        }
        /******************* 将currenttimerstr、secondSwitchStatusstr、timerString保存到本地************************/
        NSUserDefaults *defaults11 = [NSUserDefaults standardUserDefaults];
        [defaults11 setObject:currenttimerstr forKey:@"currenttimerstr"];
        [defaults11 synchronize];
        
        NSUserDefaults *defaults22= [NSUserDefaults standardUserDefaults];
        [defaults22 setObject:secondSwitchStatusstr forKey:@"secondSwitchStatusstr"];
        [defaults22 synchronize];
        
        NSUserDefaults *defaults33= [NSUserDefaults standardUserDefaults];
        [defaults33 setObject:timerString forKey:@"timerString"];
        [defaults33 synchronize];
        
        
    }];
    [self.view addSubview:secondSwitch];
    
}
//-(void)receiveIdexx:(NSNotification *)not{
//    self.timerString = not.object;
//    if ([self.timerString isEqualToString:@"0"]){
//        self.timerString=nil;
//    }
//
//    if (self.timerString !=nil) {
//        self.currenttimerstr =self.timerString;
//    }
//}


/*****/

//创建tableview
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,40*XiShu_Height, KScreenWidth, (KScreenHeight - 64 - 30)*XiShu_Height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor lightTextColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
}



#pragma mark TableView

//显示多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//显示多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return markArray.count;
}

//每行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    pressureDataCell *dataCell = [tableView dequeueReusableCellWithIdentifier:[pressureDataCell ID]];
    if (dataCell == nil) {
        dataCell = [pressureDataCell createPressureDataCell];
    }
    
    
    
    
    if (IS_IPHONE_6) {
        dataCell.pressureDate.font = [UIFont systemFontOfSize:10];
        dataCell.pressureTime.font = [UIFont systemFontOfSize:13];
        dataCell.systolicPressure.font = [UIFont systemFontOfSize:13];
        dataCell.diastolicPressure.font = [UIFont systemFontOfSize:13];
         dataCell.heartRate.font = [UIFont systemFontOfSize:13];
        dataCell.markLB.font = [UIFont systemFontOfSize:13];
    }
    
    
    //设置 cell 上的布局
    dataCell.frame=CGRectMake(0, 0, Screen_Width, 30*XiShu_Height);
    //dataCell.backgroundColor=[UIColor grayColor];
    
    dataCell.pressureDate=[[UILabel alloc]init];
    dataCell.pressureDate.frame=CGRectMake(0, 0, Screen_Width/6, 30*XiShu_Height);
    dataCell.pressureDate.textAlignment=0;
     dataCell.pressureDate.font = [UIFont systemFontOfSize:8];
    
    dataCell.pressureTime=[[UILabel alloc]init];
    dataCell.pressureTime.frame=CGRectMake(Screen_Width/6, 0, Screen_Width/6, 30*XiShu_Height);
    dataCell.pressureTime.textAlignment=1;
    dataCell.pressureTime.font=[UIFont systemFontOfSize:12];
    
    dataCell.systolicPressure=[[UILabel alloc]init];
    dataCell.systolicPressure.frame=CGRectMake(Screen_Width/3, 0, Screen_Width/6, 30*XiShu_Height);
    dataCell.systolicPressure.textAlignment=1;
    dataCell.systolicPressure.font=[UIFont systemFontOfSize:12];
    
    dataCell.diastolicPressure=[[UILabel alloc]init];
    dataCell.diastolicPressure.frame=CGRectMake(Screen_Width/2, 0, Screen_Width/6, 30*XiShu_Height);
    dataCell.diastolicPressure.textAlignment=1;
    dataCell.diastolicPressure.font=[UIFont systemFontOfSize:12];
    
    dataCell.heartRate=[[UILabel alloc]init];
    dataCell.heartRate.frame=CGRectMake(4*(Screen_Width/6), 0, Screen_Width/6, 30*XiShu_Height);
    dataCell.heartRate.textAlignment=1;
    dataCell.heartRate.font=[UIFont systemFontOfSize:12];
    
    dataCell.markLB=[[UILabel alloc]init];
    dataCell.markLB.frame=CGRectMake(5*(Screen_Width/6), 0, Screen_Width/6, 30*XiShu_Height);
    dataCell.markLB.textAlignment=1;
    dataCell.markLB.font=[UIFont systemFontOfSize:12];
    
    [dataCell.contentView addSubview:dataCell.pressureDate];
    [dataCell.contentView addSubview:dataCell.pressureTime];
    [dataCell.contentView addSubview:dataCell.systolicPressure];
    [dataCell.contentView addSubview:dataCell.diastolicPressure];
    [dataCell.contentView addSubview:dataCell.heartRate];
    [dataCell.contentView addSubview:dataCell.markLB];
   
    
       //真实数据赋值
    dataCell.pressureDate.text=pressureDateArray[indexPath.row];
    dataCell.pressureTime.text =pressureTimeArray[indexPath.row];
    dataCell.systolicPressure.text =systolicArray[indexPath.row];
    dataCell.diastolicPressure.text =diastolicArray[indexPath.row];
    dataCell.heartRate.text =heartRateArray[indexPath.row] ;
    dataCell.markLB.text =markArray[indexPath.row];

    
    
    /**
     *  真实数据赋值
     */
    //DataListModel *model = _dataListArr[indexPath.row];
    
   // dataCell.DateLB.text = model.measureTimeFormat;
    //dataCell.TimeLB.text = model.measureTimeT;
   // dataCell.ValueLB.text = [NSString stringWithFormat:@"%.1f",model.measureValue];
    /*
     NSOrderedAscending = -1,    // < 升序
     NSOrderedSame,              // = 等于
     NSOrderedDescending   // > 降序
     
     */
    
//    //当GetminStr<血糖值<GetmaxStr时给它赋绿色
//    if ([dataCell.ValueLB.text compare:GetminStr options:NSNumericSearch] == NSOrderedDescending && [dataCell.ValueLB.text compare:GetmaxStr options:NSNumericSearch] == NSOrderedAscending)
//    {
//        dataCell.ValueLB.textColor = KGreenColor;//[UIColor greenColor];
//    }
//    //当血糖值<GetminStr时给它赋蓝色
//    else if ([dataCell.ValueLB.text compare:GetminStr options:NSNumericSearch] == NSOrderedAscending )
//    {
//        dataCell.ValueLB.textColor = KBlueColor;//[UIColor blueColor];
//    }
//    //当血糖值>GetmaxStr时给它赋红色
//    else if ([dataCell.ValueLB.text compare:GetmaxStr options:NSNumericSearch] == NSOrderedDescending)
//    {
//        dataCell.ValueLB.textColor = [UIColor redColor];
//    }
//    //当血糖值=GetminStr或者血糖值=GetmaxStr时给它赋绿色
//    else if ([dataCell.ValueLB.text compare:GetminStr options:NSNumericSearch]==NSOrderedSame || [dataCell.ValueLB.text compare:GetmaxStr options:NSNumericSearch]==NSOrderedSame)
//    {
//        dataCell.ValueLB.textColor = KGreenColor;//[UIColor greenColor];
//    }
//    
//    dataCell.UnitLB.text = model.unit;
    
//    }
    
//    //如果inputType＝1,则为手工输入；如果inputType=2,则为蓝牙录入
//    if ([model.inputType isEqualToString:@"1"]) {
//        dataCell.markLB.text = @"手工输入";
//    }else if ([model.inputType isEqualToString:@"2"]){
//        dataCell.markLB.text = @"蓝牙输入";
//    }
//    
    cell = dataCell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20*XiShu_Height)];
    headerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    
    NSMutableArray * itemArr =[NSMutableArray arrayWithObjects:@"日期",@"时间 ",@"收缩压",@"舒张压",@"心率" ,@"标示",nil];
    for (int i=0; i < 6; i++)
    {
        UILabel *item= [[UILabel alloc] init];
        item.frame=CGRectMake(KScreenWidth/6 * i, 0, KScreenWidth/6, 30*XiShu_Height);
        item.text = itemArr[i];
        item.textColor = [UIColor lightGrayColor];
        item.font = [UIFont systemFontOfSize:14];
        item.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:item];
    }
    
    return headerView;
}


//选中 跳入 数据修改页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    DataListModel *model = _dataListArr[indexPath.row];
//    
//    DataChangeControllerView *datachangeVC = [[DataChangeControllerView alloc] init];
//    datachangeVC.dataModel = model;
//    
//    if ([model.inputType integerValue]==1) {
//        [self.navigationController  pushViewController:datachangeVC animated:YES];
//    }
//    
    
    
}








-(void)backClick:(UIButton *)sender{
    
   ZWLog(@"chick");
   
    [self.navigationController  popViewControllerAnimated:YES];
    
    
  
    
    
    
    
    
    
}

- (void)exportBtn
{
    //[self appendingHtml];
    ZWLog(@"导出");
 
    
    [self postEmail];
    
    
}


/**********发邮件************/
- (void)postEmail
{
    // You must check that the current device can send email messages before you
    // attempt to create an instance of MFMailComposeViewController.  If the
    // device can not send email messages,
    // [[MFMailComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        [self displayMailComposerSheet];
        ZWLog(@"post email");
    }
    else
        // The device can not send email.
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此设备未配置邮件功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Compose Mail/SMS

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet
{
    picker = [[MFMailComposeViewController alloc] init];
    picker.navigationBarHidden = YES;
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"艾检"];
    
    // Set up recipients
//        NSArray *toRecipients = [NSArray arrayWithObject:@"765508285@qq.com"];
//        NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//        NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
//    
//        [picker setToRecipients:toRecipients];
//        [picker setCcRecipients:ccRecipients];
//        [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"sms.png"]];   // 保存文件的名称
    
    //    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    //    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy.png"];
    
    // Fill out the email body text
    
    
    //  用户信息 
    
    
//    NSString *sexstr;
//    if (userinfo.data.sex == 0) {
//        sexstr = @"女";
//    }
//    else
//    {
//        sexstr = @"男";
//    }
//    
//    NSString *emailBody = [NSString stringWithFormat:@"<h3 align = 'center'>用户信息</h3><p>姓名:  %@<br />性别:  %@<br />出生日期:  %@<br />%@<p/>",userinfo.data.userName,sexstr,userinfo.data.birthday,HTMLStr] ;
//    [picker setMessageBody:emailBody isHTML:YES];
    
    [self presentViewController:picker animated:YES completion:NULL];
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

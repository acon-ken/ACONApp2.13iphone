//
//  BloodFatMangerController.m
//  ACONApp
//
//  Created by Ken on 15/12/28.
//  Copyright © 2015年 zw. All rights reserved.
//

#import "BloodFatMangerController.h"


#import "DVSwitch.h"
#import "SelectDataViewController.h"

#import "fatDataCell.h"

#import <MessageUI/MFMailComposeViewController.h>//邮件
#import "MFMailComposeViewController+EndEditing.h"

// 本地化 数据的 处理

#import "FatBool.h"


@interface BloodFatMangerController ()<MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
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
    
   
    
    NSMutableArray *dateCountArray; // 显示天数的数组
    
     // 本地化数据处理  获取数据的 数组
    NSMutableArray *fatDateArray;
    NSMutableArray *fatTimeArray;
    NSMutableArray *cholesterolArray;
    NSMutableArray *triglycerideArray;
    NSMutableArray *highdensityLipoproteinArray;
    NSMutableArray *lowdensityLipoproteinArray;
    NSMutableArray *speclificValueArray;

    
    FMDatabase *_db;//本地数据
    
    
    
}

@property(nonatomic,retain)UITableView *fatDataTableView;
@end

@implementation BloodFatMangerController

static int  datecount;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title=@"血脂数据列表";
    self.view.backgroundColor = KBackgroundColor;
    
    self.navigationController.navigationBarHidden = NO;
    
    self.edgesForExtendedLayout = NO;
    
    
    //初始化  数组
    
    fatDateArray=[NSMutableArray array];
    fatTimeArray=[NSMutableArray array];
    cholesterolArray=[NSMutableArray array];
    triglycerideArray=[NSMutableArray array];
   highdensityLipoproteinArray=[NSMutableArray array];
    lowdensityLipoproteinArray=[NSMutableArray array];
   speclificValueArray=[NSMutableArray array];
    
    
    
    
    
    // 创建 导航栏 按钮事件

    [self createNavigation];
    
    // 日期  选择 栏
    
     [self createHeaderView];
    
    //创建 表格显示 数据  直观的显示数据
    
    [self createFatTableView];
    
    
    dateCountArray=[NSMutableArray array]; // 显示天数的数组   导航栏上的时间 选择器
    
    
    
//  获得本地的 数据
    
    
    [self getFatDataFromSqlite];
    
    
}


//  获得本地的 数据
-(void)getFatDataFromSqlite{
    
    
    // 先把  对应得的数据库文件打开
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
    
    
    //1.查询数据
    FMResultSet *rs =[FatBool queryOnDB:_db withTableName:FATTABLENAME];
    
    //2.遍历结构集
    while(rs.next){
        
        //ZWLog(@"执行了这段代码2");
        
        NSString *fatDate = [rs stringForColumn:FatDate];
        NSString *fatTime = [rs stringForColumn:FatTime];
        NSString  *cholesterol=[rs stringForColumn:FatCholesterol];
        NSString *triglyceride=[rs stringForColumn:FatTriglyceride ];
        NSString *highdensityLipoprotein=[rs stringForColumn:FatHighdensityLipoprotein];
        NSString *lowdensityLipoprotein=[rs stringForColumn:FatLowdensityLipoprotein];
        NSString *speclificValue=[rs stringForColumn:FatSpeclificValue] ;
        
        [fatDateArray addObject:fatDate];
        [fatTimeArray addObject:fatTime];
        [cholesterolArray addObject:cholesterol];
        [triglycerideArray addObject:triglyceride];
        [highdensityLipoproteinArray addObject:highdensityLipoprotein];
        [lowdensityLipoproteinArray addObject:lowdensityLipoprotein];
        [speclificValueArray addObject:speclificValue];
        
        
       
    }

    

    
}





// 创建 导航栏 按钮事件

-(void)createNavigation
{
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
               
                datecount=7;
                [self.fatDataTableView reloadData];
                
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
                
                datecount=14;
                [self.fatDataTableView reloadData];
                
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
                datecount=30;
                
                [self.fatDataTableView  reloadData];
                
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
                
                datecount=60;
                [self.fatDataTableView reloadData];
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
                
                datecount=90;
                [self.fatDataTableView reloadData];
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
                    int times =(int) [timerString integerValue];
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









//创建 表格显示 数据  直观的显示数据

-(void) createFatTableView
{
    
    self.fatDataTableView = [[UITableView alloc] init];
    self.fatDataTableView.frame = CGRectMake(0,40*XiShu_Height, KScreenWidth, (KScreenHeight - 64 - 30)*XiShu_Height);
    self.fatDataTableView.delegate = self;
    self.fatDataTableView.dataSource = self;
    self.fatDataTableView.backgroundColor = [UIColor lightTextColor];
    [self.fatDataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.fatDataTableView];
    
    
    
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
    // 显示数据的  组数
    return fatDateArray.count;
}

//每行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
   fatDataCell *dataCell = [tableView dequeueReusableCellWithIdentifier:[fatDataCell ID]];
    if (dataCell == nil) {
        dataCell = [fatDataCell createFatDataCell];
    }
    
   
    
    if (IS_IPHONE_6) {
        dataCell.fatdateLabel.font = [UIFont systemFontOfSize:11];
        dataCell.fatTimeLabel.font = [UIFont systemFontOfSize:13];
        dataCell.cholesterolLabel.font = [UIFont systemFontOfSize:13];
        dataCell.triglycerideLabel.font = [UIFont systemFontOfSize:13];
        dataCell.highdensityLipoproteinLabel.font = [UIFont systemFontOfSize:13];
        dataCell.lowdensityLipoproteinLabel.font = [UIFont systemFontOfSize:13];
    }
    
    // 代码 布局
    dataCell.frame=CGRectMake(0, 0, Screen_Width, 30*XiShu_Height);
    
    dataCell.fatdateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50*XiShu_Width, 30*XiShu_Height)];
    dataCell.fatdateLabel.textAlignment=0;
    dataCell.fatdateLabel.font=[UIFont systemFontOfSize:8];
    
    
    dataCell.fatTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(50*XiShu_Width, 0, 50*XiShu_Width, 30*XiShu_Height)];
    dataCell.fatTimeLabel.textAlignment=1;
    dataCell.fatTimeLabel.font=[UIFont systemFontOfSize:12];
    
    dataCell.cholesterolLabel=[[UILabel alloc]initWithFrame:CGRectMake(100*XiShu_Width, 0, 50*XiShu_Width, 30*XiShu_Height)];
    dataCell.cholesterolLabel.textAlignment=1;
    dataCell.cholesterolLabel.font=[UIFont systemFontOfSize:12];
    
    
    dataCell.triglycerideLabel=[[UILabel alloc]initWithFrame:CGRectMake(150*XiShu_Width, 0, 50*XiShu_Width, 30*XiShu_Height)];
    dataCell.triglycerideLabel.textAlignment=1;
    dataCell.triglycerideLabel.font=[UIFont systemFontOfSize:12];
    
    
    
    dataCell.highdensityLipoproteinLabel=[[UILabel alloc]initWithFrame:CGRectMake(200*XiShu_Width, 0, 60*XiShu_Width, 30*XiShu_Height)];
    dataCell.highdensityLipoproteinLabel.textAlignment=1;
    dataCell.highdensityLipoproteinLabel.font=[UIFont systemFontOfSize:12];
    
    
    dataCell.lowdensityLipoproteinLabel=[[UILabel alloc]initWithFrame:CGRectMake(260*XiShu_Width, 0, 60*XiShu_Width, 30*XiShu_Height)];
    dataCell.lowdensityLipoproteinLabel.textAlignment=1;
    dataCell.lowdensityLipoproteinLabel.font=[UIFont systemFontOfSize:12];
    
    
    [dataCell.contentView addSubview:dataCell.fatdateLabel];
    [dataCell.contentView addSubview:dataCell.fatTimeLabel];
     [dataCell.contentView addSubview:dataCell.cholesterolLabel];
     [dataCell.contentView addSubview:dataCell.triglycerideLabel];
     [dataCell.contentView addSubview:dataCell.highdensityLipoproteinLabel];
     [dataCell.contentView addSubview:dataCell.lowdensityLipoproteinLabel];
    
    
    //真实数据赋值
    
    dataCell.fatdateLabel.text=fatDateArray[indexPath.row];
    dataCell.fatTimeLabel.text=fatTimeArray[indexPath.row];
    dataCell.cholesterolLabel.text=cholesterolArray[indexPath.row];
   dataCell.triglycerideLabel.text=triglycerideArray[indexPath.row];
    dataCell.highdensityLipoproteinLabel.text=highdensityLipoproteinArray[indexPath.row];
    dataCell.lowdensityLipoproteinLabel.text=lowdensityLipoproteinArray[indexPath.row];
    
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
    
    
    
    NSMutableArray * itemArr =[NSMutableArray arrayWithObjects:@"日期",@"时间 ",@"总胆固醇",@"甘油三酯",@"高密度脂蛋白" ,@"低密度脂蛋白",nil];
    for (int i=0; i < 4; i++)
    {
        UILabel *item= [[UILabel alloc] init];
        item.frame=CGRectMake((200*XiShu_Width/4) * i, 0, (200*XiShu_Width)/4, 30*XiShu_Height);
        item.text = itemArr[i];
        item.textColor = [UIColor lightGrayColor];
            
            item.font = [UIFont systemFontOfSize:10];
        
        
        item.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:item];
    }
    
    UILabel *item5= [[UILabel alloc] init];
    item5.frame=CGRectMake(200*XiShu_Width, 0, 60*XiShu_Width, 30*XiShu_Height);
    item5.text = itemArr[4];
    item5.textColor = [UIColor lightGrayColor];
    
    item5.font = [UIFont systemFontOfSize:10];
    
    
    item5.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:item5];
    
    UILabel *item6= [[UILabel alloc] init];
    item6.frame=CGRectMake(260*XiShu_Width, 0, 60*XiShu_Width, 30*XiShu_Height);
    item6.text = itemArr[5];
    item6.textColor = [UIColor lightGrayColor];
    
    item6.font = [UIFont systemFontOfSize:10];
    
    
    item6.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:item6];
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

















//返回按钮  事件
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
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"765508285@qq.com"];
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    //    [picker setToRecipients:toRecipients];
    //    [picker setCcRecipients:ccRecipients];
    //    [picker setBccRecipients:bccRecipients];
    
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

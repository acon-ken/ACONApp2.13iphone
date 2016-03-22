//
//  PressureLineVC.m
//  ACONApp
//
//  Created by Ken on 16/1/19.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "PressureLineVC.h"

#import "DVSwitch.h"
#import "SelectDataViewController.h"

#import "kenTableViewCell.h" //自定义 cell

@interface PressureLineVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
    
    NSString *begindate;
    NSString *enddate;
    NSString *  timerString;
    
    NSString * currenttimerstr;// 用来暂时存放自定义时间的字符串
 NSString *secondSwitchStatusstr; //饼状图选择天数控件的状态
}
@property(nonatomic,retain)UITableView *preChartTableView;

@end

@implementation PressureLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"血压数据展示图";
    self.view.backgroundColor = KBackgroundColor;
    
    self.navigationController.navigationBarHidden = NO;
    self.edgesForExtendedLayout = NO;
    
    // 导航栏  返回按钮
    [self backview];
    
    
    ////  日期  选择 栏
    
    [self createHeaderView];
    
    //  创建 表示图 用来显示折线图
    [self  createTableview];
    
}

-(void)createTableview{
    
    
    
    
    self.preChartTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40*XiShu_Height, Screen_Width, Screen_Height-(40*XiShu_Height)) style:UITableViewStyleGrouped];
    
     self.preChartTableView.backgroundColor=KBackgroundColor;
    
    self.preChartTableView.delegate=self;
    self.preChartTableView.dataSource=self;
    
   
    NSString *cellName = NSStringFromClass([kenTableViewCell class]);
    
   
    [self.preChartTableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
    
    [self.view addSubview:self.preChartTableView];
    
    
    
    
    
    
    
    
    
    
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return section?2:4;
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    kenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([kenTableViewCell class])];
    
    
   // cell.backgroundColor=[UIColor purpleColor];
    [cell configUI:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200*XiShu_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40*XiShu_Height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    

    if (section==0) {
        //表头 提示  设置
        CGRect frame = CGRectMake(0, 5*XiShu_Height, [UIScreen mainScreen].bounds.size.width , 30*XiShu_Height);
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.font = [UIFont systemFontOfSize:20];
        label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        label.text = @"收缩压数据";
        
        
        label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
        
        
    }
    
    if (section==1) {
        //表头 提示  设置
        CGRect frame = CGRectMake(0, 5*XiShu_Height, [UIScreen mainScreen].bounds.size.width , 30*XiShu_Height);
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.font = [UIFont systemFontOfSize:20];
        label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        label.text = @"舒张压数据";
        
        
        label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
        
        
    }
    if (section==2) {
        //表头 提示  设置
        CGRect frame = CGRectMake(0, 5*XiShu_Height, [UIScreen mainScreen].bounds.size.width , 30*XiShu_Height);
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.font = [UIFont systemFontOfSize:20];
        label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        label.text = @"心率数据";
        
        
        label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
        
        
    }
    
    return nil;
}


//选中 跳入 数据修改页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    

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

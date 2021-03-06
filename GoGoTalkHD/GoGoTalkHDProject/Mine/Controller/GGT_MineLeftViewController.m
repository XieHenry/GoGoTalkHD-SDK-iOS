//
//  GGT_MineLeftViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineLeftViewController.h"
#import "GGT_SelfInfoViewController.h"
#import "GGT_MineClassViewController.h"
#import "GGT_FeedbackViewController.h"
#import "GGT_TestReportViewController.h"
#import "GGT_SettingViewController.h"
#import "GGT_MineHeaderView.h"
#import "GGT_MineLeftTableViewCell.h"
#import "GGT_MineLeftModel.h"

static BOOL isShowTestReportVc; //是否选中测评报告（这个是推送进来的，和平常的要区分开）
static BOOL isRefreshMyClassVc;   //是否刷新我的课时cell

@interface GGT_MineLeftViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, strong) GGT_MineHeaderView *headerView;
@property (nonatomic, strong) GGT_MineLeftModel *model;
@end

@implementation GGT_MineLeftViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushTestReportWithNotification:) name:@"testReport2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChangeNameWithNotification:) name:@"changeNameStatus" object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"testReport2" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeNameStatus" object:nil];
}

#pragma mark - pushMessageAction
- (void)pushTestReportWithNotification:(NSNotification *)noti {
    isShowTestReportVc = YES;
    
    //推送过来消息，进行切换cell的控制器
    [self getLeftName];
}

//在个人信息页面修改中文名称之后，会发送通知刷新数据。
- (void)pushChangeNameWithNotification:(NSNotification *)noti {
    
    if ([[noti.userInfo objectForKey:@"isRefresh"] isEqualToString:@"YES"]) {
        isRefreshMyClassVc = YES;
    } else {
        isRefreshMyClassVc = NO;
    }
    
    
    [self getLoadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isShowTestReportVc = NO;
    //自定义宽度，设置为350
    self.splitViewController.maximumPrimaryColumnWidth = LineW(350); //可以修改屏幕的宽度
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.48;
    
    [self initUI];
    [self getLeftName]; //本地数据
    
    //获取网络数据
    [self getLoadData];
}

#pragma mark 没网络，重新数据请求
-(void)refreshLodaData {
    [self getLeftName];
    //获取网络数据
    [self getLoadData];
}

#pragma mark 获取左边的名称和icon
- (void)getLeftName {
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    self.dataArray = [NSMutableArray array];
    self.iconArray = [NSMutableArray array];
    
    if (sin.isAuditStatus == YES) {
        self.dataArray = [NSMutableArray arrayWithObjects:@"个人信息",@"测评报告",@"意见反馈",@"设置", nil];
        self.iconArray = [NSMutableArray arrayWithObjects:@"Personal_information",@"Test_report",@"feedback",@"Set_up_the", nil];
    } else {
        self.dataArray = [NSMutableArray arrayWithObjects:@"个人信息",@"我的课时",@"测评报告",@"意见反馈",@"设置", nil];
        self.iconArray = [NSMutableArray arrayWithObjects:@"Personal_information",@"class",@"Test_report",@"feedback",@"Set_up_the", nil];
    }
    
    [self.tableView reloadData];
    
    //先刷新数据，再选中cell
    if (sin.isAuditStatus == YES ) {
        if (isShowTestReportVc == YES) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
        } else {
            //每次请求数据后，都默认选中第一行
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
        }
    } else {
        if (isShowTestReportVc == YES) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
        } else {
            //每次请求数据后，都默认选中第一行
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
        }
    }
    
    
    if (self.refreshLoadData) {
        self.refreshLoadData(YES);
    }
}


#pragma mark 获取网络请求，添加到view上
- (void)getLoadData {
    [[BaseService share] sendGetRequestWithPath:URL_GetLessonStatistics token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        self.model = [GGT_MineLeftModel yy_modelWithDictionary:responseObject[@"data"]];
        
        GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
        sin.leftTotalCount = [NSString stringWithFormat:@"%@",self.model.totalCount];
        
        
        if (sin.isAuditStatus == NO) {
            if (isRefreshMyClassVc == YES) {
                //刷新我的课时cell数据，更改课时的显示，并选中这一个cell
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
            }
            
            GGT_MineLeftTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.leftSubTitleLabel.text = [NSString stringWithFormat:@"剩余%@课时",self.model.totalCount];
        }
        
        if (self.refreshLoadData) {
            self.refreshLoadData(YES);
        }
        
        
    } failure:^(NSError *error) {
        GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
        if (sin.netStatus == NO) {
            if (self.refreshLoadData) {
                self.refreshLoadData(NO);
            }
        } else {
            [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        }
    }];
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStr = @"Cell";
    GGT_MineLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[GGT_MineLeftTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellStr];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        
    }
    
    
    cell.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    cell.leftTitleLabel.text = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.iconName = [self.iconArray safe_objectAtIndex:indexPath.row];
    
    
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    if (sin.isAuditStatus == YES) {
        if (isShowTestReportVc == YES) {
            if (indexPath.row == 1) {
                GGT_TestReportViewController *vc = [[GGT_TestReportViewController alloc]init];
                BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
                [self.splitViewController showDetailViewController:nav sender:self];
            }
            
            
        } else {
            if (indexPath.row == 0) {
                GGT_SelfInfoViewController *vc = [[GGT_SelfInfoViewController alloc]init];
                BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
                [self.splitViewController showDetailViewController:nav sender:self];
            }
        }
        
        
    }else {
        if (isShowTestReportVc == YES) {
            if (indexPath.row == 2) {
                GGT_TestReportViewController *vc = [[GGT_TestReportViewController alloc]init];
                BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
                [self.splitViewController showDetailViewController:nav sender:self];
            }
            
        } else {
            if (indexPath.row == 0) {
                GGT_SelfInfoViewController *vc = [[GGT_SelfInfoViewController alloc]init];
                BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
                [self.splitViewController showDetailViewController:nav sender:self];
            }
        }
    }
    
    
    if (sin.isAuditStatus == NO) {
        if(indexPath.row == 1){
            cell.leftSubTitleLabel.text = [NSString stringWithFormat:@"剩余%@课时",_model.totalCount];
        }
    }
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(60);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GGT_MineHeaderView *headerView = [[GGT_MineHeaderView alloc]init];
    headerView.frame = CGRectMake(0, 0, LineW(350), LineH(275));
    [headerView getResultModel:self.model];
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LineH(275);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    
    
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    if (sin.isAuditStatus == YES) {
        switch (indexPath.row) {
            case 0:
                //个人信息
                vc = [[GGT_SelfInfoViewController alloc]init];
                
                break;
            case 1:
                //测评报告
                vc = [[GGT_TestReportViewController alloc]init];
                
                break;
            case 2:
                //意见反馈
                vc = [[GGT_FeedbackViewController alloc]init];
                
                break;
            case 3:
                //设置
                vc = [[GGT_SettingViewController alloc]init];
                
                break;
                
            default:
                vc = [[UIViewController alloc]init];
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                //个人信息
                vc = [[GGT_SelfInfoViewController alloc]init];
                
                break;
            case 1:
                //我的课时
                vc = [[GGT_MineClassViewController alloc]init];
                
                break;
            case 2:
                //测评报告
                vc = [[GGT_TestReportViewController alloc]init];
                
                break;
            case 3:
                //意见反馈
                vc = [[GGT_FeedbackViewController alloc]init];
                
                break;
            case 4:
                //设置
                vc = [[GGT_SettingViewController alloc]init];
                
                break;
                
            default:
                vc = [[UIViewController alloc]init];
                break;
        }
    }
    
    
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self.splitViewController showDetailViewController:nav sender:self];
    
}

//MARK:UI加载
-(void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-0);;
    }];
}

-(UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    }
    return _tableView;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


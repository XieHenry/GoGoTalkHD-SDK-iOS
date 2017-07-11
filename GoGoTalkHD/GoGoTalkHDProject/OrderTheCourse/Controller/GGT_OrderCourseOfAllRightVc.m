//
//  GGT_OrderCourseOfAllRightVc.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderCourseOfAllRightVc.h"
#import "GGT_DetailsOfTeacherViewController.h"
#import "GGT_OrderForeignListCell.h"
#import "GGT_ConfirmBookingAlertView.h"
#import "GGT_SelectCoursewareViewController.h"
#import "GGT_AllWithNoDateView.h"


@interface GGT_OrderCourseOfAllRightVc () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) GGT_AllWithNoDateView *allWithNoDateView;


@end

@implementation GGT_OrderCourseOfAllRightVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_RANDOM_COLOR();
    
    
    
    
    //新建tap手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    
    [self initTableView];
    
    
    @weakify(self);
    _tableView.mj_header = [XCNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.dataArray = [NSMutableArray array];
        
        [self getLoadData];
        [self.tableView.mj_header endRefreshing];
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    _tableView.mj_footer = [XCNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self.tableView.mj_footer endRefreshing];
        
        
        
    }];
    
    
}

- (void)getLoadData {
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    [self.tableView reloadData];
}


- (void)initTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(LineX(5), LineY(5),marginMineRight-LineW(10), SCREEN_HEIGHT()-LineH(10)-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:self.tableView];
    
    
    _allWithNoDateView = [[GGT_AllWithNoDateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT()-49-64-LineH(54))];
    [_tableView addSubview:_allWithNoDateView];
    _allWithNoDateView.hidden = YES;
    
}

#pragma mark tableview的代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    GGT_OrderForeignListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell= [[GGT_OrderForeignListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    /****预约***/
    [cell.orderButton addTarget:self action:@selector(orderButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    /****关注***/
    [cell.focusButton addTarget:self action:@selector(focusButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    return cell;
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
    //    return 1;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(70);
    //如果没有数据，就展示这个高度
    //    return self.tableView.height;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGT_DetailsOfTeacherViewController *vc = [[GGT_DetailsOfTeacherViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark   预约
- (void)orderButtonClick {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT())];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self.view.window addSubview:bgView];
    
    GGT_ConfirmBookingAlertView *alertView = [[GGT_ConfirmBookingAlertView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH()-LineW(277))/2, (SCREEN_HEIGHT()-LineH(327))/2, LineW(277), LineH(327))];
    
    __weak GGT_ConfirmBookingAlertView *weakview = alertView;
    alertView.buttonBlock = ^(UIButton *button) {
        switch (button.tag) {
            case 800:
                //关闭
                [bgView removeFromSuperview];
                [weakview removeFromSuperview];
                break;
            case 801:
            {
                
                //更换课件
//                GGT_SelectCoursewareViewController *vc = [[GGT_SelectCoursewareViewController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                vc.changeBlock = ^(NSString *str) {
//                    
//                    weakview.hidden = NO;
//                    bgView.hidden = NO;
//                    
//                    weakview.kejianField.text = str;
//                    
//                };
//                weakview.hidden = YES;
//                bgView.hidden = YES;
//                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 802:
                //确认
                [bgView removeFromSuperview];
                [weakview removeFromSuperview];
                break;
                
            default:
                break;
        }
        
        
        
    };
    
    [self.view.window addSubview:alertView];
    
    
}


#pragma mark   关注
- (void)focusButtonClick {
    NSLog(@"关注");
    
    
}








- (void)initDataSource:(NSString *)dayStr timeStr:(NSString *)timeStr {
    //    pageIndex string  第几页
    //    pageSize string 每页条数
    //    date string 日期
    //    time string 时间
    
    
    
    //     NSString *urlStr = [NSString stringWithFormat:@"%@?pageIndex=%@&pageSize=%@&date=%@&time=%@",URL_GetPageTeacherLesson,@"1",@"20",dayStr,timeStr];
    //     [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
    //
    //     } failure:^(NSError *error) {
    //
    //     }];
    
    //    NSDictionary *postDic = @{@"pageIndex":@"1",@"pageSize":@"20",@"date":dayStr,@"time":timeStr};
    //    [[BaseService share] sendPostRequestWithPath:URL_GetPageTeacherLesson parameters:postDic token:YES viewController:self success:^(id responseObject) {
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    
    
}


//轻击手势触发方法----点击空白处，消除弹出框
-(void)tapGesture {
    UIView *view1 = [self.view viewWithTag:888];
    [view1 removeFromSuperview];
}

//解决手势和按钮冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

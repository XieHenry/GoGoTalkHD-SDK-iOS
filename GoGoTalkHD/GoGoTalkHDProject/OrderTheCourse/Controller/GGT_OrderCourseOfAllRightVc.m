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

static CGFloat const xc_cellHeight = 208.0f/2 + 7;


@interface GGT_OrderCourseOfAllRightVc () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *xc_tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) GGT_AllWithNoDateView *allWithNoDateView;


@end

@implementation GGT_OrderCourseOfAllRightVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    //新建tap手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    
    [self initTableView];
    
}

- (void)getLoadData {
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    [self.xc_tableView reloadData];
}


- (void)initTableView {
    
    self.xc_tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView;
    });
    [self.view addSubview:self.xc_tableView];
    
    [self.xc_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(@7);
        make.right.equalTo(@(-7));
    }];
    
    _allWithNoDateView = [[GGT_AllWithNoDateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT()-49-64-LineH(54))];
    [self.xc_tableView addSubview:_allWithNoDateView];
    _allWithNoDateView.hidden = YES;
    
    
    [self.xc_tableView registerClass:[GGT_OrderForeignListCell class] forCellReuseIdentifier:NSStringFromClass([GGT_OrderForeignListCell class])];
    
    
    
    @weakify(self);
    self.xc_tableView.mj_header = [XCNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.dataArray = [NSMutableArray array];
        [self getLoadData];
        [self.xc_tableView.mj_header endRefreshing];
    }];
    [self.xc_tableView.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.xc_tableView.mj_footer = [XCNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self.xc_tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark tableview的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_OrderForeignListCell *cell = [GGT_OrderForeignListCell cellWithTableView:tableView forIndexPath:indexPath];
    
    /****预约***/
//    [cell.orderButton addTarget:self action:@selector(orderButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    /****关注***/
//    [cell.focusButton addTarget:self action:@selector(focusButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LineH(xc_cellHeight);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGT_DetailsOfTeacherViewController *vc = [[GGT_DetailsOfTeacherViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
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



@end

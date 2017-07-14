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

#import "GGT_OrderPlaceholderView.h"
#import "GGT_OrderClassPopVC.h"

static CGFloat const xc_cellHeight = 208.0f/2 + 7;
static CGFloat const xc_tableViewMargin = 7.0f;

typedef enum : NSUInteger {
    XCLoadNewData,
    XCLoadMoreData,
} XCLoadType;


@interface GGT_OrderCourseOfAllRightVc () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) GGT_OrderPlaceholderView *xc_placeholderView;
@property (nonatomic, strong) UITableView *xc_tableView;
@property (nonatomic, strong) NSMutableArray *xc_dataMuArray;
@property (nonatomic, assign) NSInteger xc_pageSize;
@property (nonatomic, assign) NSInteger xc_pageIndex;
@property (nonatomic, strong) NSString *xc_date;
@property (nonatomic, strong) NSString *xc_time;

@property (nonatomic, assign) NSInteger xc_total;

@property (nonatomic, assign) XCLoadType xc_loadType;

@end

@implementation GGT_OrderCourseOfAllRightVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    self.xc_loadType = XCLoadNewData;
    
    
    [self buildUI];
    [self initData];
}

- (void)initData
{
    self.xc_pageSize = 1;
    self.xc_pageIndex = 1;
    self.xc_dataMuArray = [NSMutableArray array];
}

- (void)buildUI
{
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
        make.left.equalTo(@(xc_tableViewMargin));
        make.right.equalTo(@(-xc_tableViewMargin));
    }];
    
    
    [self.xc_tableView registerClass:[GGT_OrderForeignListCell class] forCellReuseIdentifier:NSStringFromClass([GGT_OrderForeignListCell class])];
    
    
    
#pragma mark - 添加xc_placeholderView
    self.xc_placeholderView = [[GGT_OrderPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-350-home_leftView_width, self.view.height)];
    self.xc_tableView.enablePlaceHolderView = YES;
    self.xc_tableView.xc_PlaceHolderView = self.xc_placeholderView;
    
    [self.view layoutIfNeeded];
    
    @weakify(self);
    self.xc_tableView.mj_header = [XCNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        
        self.xc_pageIndex = 1;
        self.xc_loadType = XCLoadNewData;
        [self xc_loadDataWithDate:self.xc_date timge:self.xc_time pageIndex:self.xc_pageIndex pageSize:self.xc_pageSize];
        
        [self.xc_tableView.mj_header endRefreshing];
    }];
    [self.xc_tableView.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    //    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.xc_tableView.mj_footer = [XCNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        if (self.xc_dataMuArray.count < self.xc_total) {
            self.xc_pageIndex++;
            self.xc_loadType = XCLoadMoreData;
            [self xc_loadDataWithDate:self.xc_date timge:self.xc_time pageIndex:self.xc_pageIndex pageSize:self.xc_pageSize];
        }
        
        [self.xc_tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.xc_dataMuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGT_OrderForeignListCell *cell = [GGT_OrderForeignListCell cellWithTableView:tableView forIndexPath:indexPath];
    
    /****预约***/
    [cell.xc_orderButton addTarget:self action:@selector(orderButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    /****关注***/
    [cell.xc_focusButton addTarget:self action:@selector(focusButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    cell.xc_model = self.xc_dataMuArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LineH(xc_cellHeight);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GGT_DetailsOfTeacherViewController *vc = [[GGT_DetailsOfTeacherViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark   预约
- (void)orderButtonClick
{
    GGT_OrderClassPopVC *vc = [GGT_OrderClassPopVC new];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.popoverPresentationController.delegate = self;
    //    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // 修改弹出视图的size 在控制器内部修改更好
    //    vc.preferredContentSize = CGSizeMake(100, 100);
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - GGT_OrderCourseOfAllLeftVcDelegate
- (void)leftSendToRightDate:(NSString *)date time:(NSString *)time
{
    // 进行网络请求
    self.xc_date = date;
    self.xc_time = time;
    
    [self xc_loadDataWithDate:self.xc_date timge:self.xc_time pageIndex:self.xc_pageIndex pageSize:self.xc_pageSize];
}

- (void)xc_loadDataWithDate:(NSString *)date timge:(NSString *)time pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?date=%@&time=%@&pageIndex=%ld&pageSize=%ld", URL_GetPageTeacherLessonApp, self.xc_date, self.xc_time, self.xc_pageIndex, self.xc_pageSize];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        if (self.xc_loadType == XCLoadNewData) {
            [self.xc_dataMuArray removeAllObjects];
        }
        
        NSArray *dataArray = responseObject[@"data"];
        if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0) {
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_HomeTeachModel *model = [GGT_HomeTeachModel yy_modelWithDictionary:obj];
                [self.xc_dataMuArray addObject:model];
            }];
        }
        
        self.xc_total = [responseObject[@"total"] integerValue];
        [self.xc_tableView reloadData];
        
        GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:responseObject];
        self.xc_placeholderView.xc_model = model;
        
    } failure:^(NSError *error) {
        
        [self.xc_dataMuArray removeAllObjects];
        [self.xc_tableView reloadData];
        
        NSDictionary *dic = error.userInfo;
        GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:dic];
        self.xc_placeholderView.xc_model = model;
       
    }];
}


@end

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
#import "GGT_OrderPlaceholderView.h"
#import "GGT_OrderClassPopVC.h"

static CGFloat const xc_cellHeight = 208.0f/2 + 7;
static CGFloat const xc_tableViewMargin = 7.0f;
static NSInteger const xc_pageSizeNum = 10;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderListCellNotification:) name:@"changeOrderListCell" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeOrderListCell" object:nil];
}

- (void)changeOrderListCellNotification:(NSNotification *)noti {
    self.xc_pageIndex = 1;
    self.xc_loadType = XCLoadNewData;
    [self xc_loadDataWithDate:self.xc_date timge:self.xc_time pageIndex:self.xc_pageIndex pageSize:self.xc_pageSize];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    self.xc_loadType = XCLoadNewData;
    
    
    [self buildUI];
    [self initData];
}

- (void)initData
{
    self.xc_pageSize = xc_pageSizeNum;
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
    
    cell.xc_orderButton.tag = 100+indexPath.row;
    cell.xc_focusButton.tag = 1000+indexPath.row;
    cell.xc_iconButton.tag = 10000 + indexPath.row;
    
    /****预约***/
    [cell.xc_orderButton addTarget:self action:@selector(xc_orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    /****关注***/
    [cell.xc_focusButton addTarget:self action:@selector(xc_focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    /****头像***/
    [cell.xc_iconButton addTarget:self action:@selector(xc_iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.xc_model = self.xc_dataMuArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LineH(xc_cellHeight);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_HomeTeachModel *model = [self.xc_dataMuArray safe_objectAtIndex:indexPath.row];
    GGT_DetailsOfTeacherViewController *vc = [[GGT_DetailsOfTeacherViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pushModel = model;
    vc.refreshCellBlick = ^(NSString *statusStr) {
        
        GGT_OrderForeignListCell *cell = [self.xc_tableView cellForRowAtIndexPath:indexPath];
        if ([model.IsFollow isEqualToString:@"0"]) {
            model.IsFollow = @"1";
        } else {
            model.IsFollow = @"0";
        }
        
        cell.xc_model = model;
        
    };
    
    //刷新整个数据
    vc.refreshLoadDataBlock = ^(BOOL isYes) {
        self.xc_pageIndex = 1;
        self.xc_loadType = XCLoadNewData;
        [self xc_loadDataWithDate:self.xc_date timge:self.xc_time pageIndex:self.xc_pageIndex pageSize:self.xc_pageSize];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 头像按钮
- (void)xc_iconButtonClick:(UIButton *)button
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag-10000 inSection:0];

    [self tableView:_xc_tableView didSelectRowAtIndexPath:indexPath];
    
}


#pragma mark   预约
- (void)xc_orderButtonClick:(UIButton *)button
{
    GGT_HomeTeachModel *model = self.xc_dataMuArray[button.tag - 100];
    
    // 进行网络请求判断
    NSString *urlStr = [NSString stringWithFormat:@"%@?teacherId=%@&dateTime=%@", URL_GetIsSureClass, model.TeacherId, model.ReturnTime];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        GGT_OrderClassPopVC *vc = [GGT_OrderClassPopVC new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = self;
        
        //重写model数据，详情和关注中会修改数据，返回后会造成错误
        vc.ImageUrl = model.ImageUrl;
        vc.TeacherName = model.TeacherName;
        vc.StartTime = model.StartTime;
        vc.LessonId = model.LessonId;
        
        
        // 修改弹出视图的size 在控制器内部修改更好
        //    vc.preferredContentSize = CGSizeMake(100, 100);
        [self presentViewController:nav animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
        NSDictionary *dic = error.userInfo;
        if ([dic[@"msg"] isKindOfClass:[NSString class]]) {
            [MBProgressHUD showMessage:dic[@"msg"] toView:self.view];
        }
        
    }];
    
}

#pragma mark - 关注
- (void)xc_focusButtonClick:(UIButton *)button
{
    GGT_HomeTeachModel *model = self.xc_dataMuArray[button.tag-1000];
    
    //（是否关注 0：未关注 1：已关注）
    if ([model.IsFollow isEqualToString:@"0"]) {
       
        [self sendFocusNetworkWithHomeTeachModel:model button:button];
//         model.IsFollow = @"1";
        
    } else {
        
//        model.IsFollow = @"0";
        
        // 在可以取消约课的情况下 弹框
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认要取消关注吗" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"暂不取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self sendFocusNetworkWithHomeTeachModel:model button:button];
        }];
        
        cancleAction.textColor = UICOLOR_FROM_HEX(Color777777);
        sureAction.textColor = UICOLOR_FROM_HEX(kThemeColor);
        [alertController addAction:cancleAction];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

}



#pragma mark - 关注网络请求
- (void)sendFocusNetworkWithHomeTeachModel:(GGT_HomeTeachModel *)model button:(UIButton *)button
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?teacherId=%@&state=%@", URL_Attention_Home, model.TeacherId, model.IsFollow];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        //对关注界面进行数据刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFocus" object:nil];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(button.tag-1000) inSection:0];
        GGT_OrderForeignListCell *cell = [self.xc_tableView cellForRowAtIndexPath:indexPath];
        
        //（是否关注 0：未关注 1：已关注）
        if ([model.IsFollow isEqualToString:@"0"]) {
            model.IsFollow = @"1";
            [MBProgressHUD showMessage:@"已关注" toView:self.view];
        } else {
            model.IsFollow = @"0";
            [MBProgressHUD showMessage:@"已取消关注" toView:self.view];
        }
        
        cell.xc_model = model;
        
        

    } failure:^(NSError *error) {
        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(button.tag-1000) inSection:0];
//        GGT_OrderForeignListCell *cell = [self.xc_tableView cellForRowAtIndexPath:indexPath];
//        cell.xc_model = model;
        
    }];
}


#pragma mark - GGT_OrderCourseOfAllLeftVcDelegate
- (void)leftSendToRightDate:(NSString *)date time:(NSString *)time
{
    // 进行网络请求
    self.xc_date = date;
    self.xc_time = time;
    
    self.xc_pageIndex = 1;
    self.xc_loadType = XCLoadNewData;
    
    [self xc_loadDataWithDate:self.xc_date timge:self.xc_time pageIndex:self.xc_pageIndex pageSize:self.xc_pageSize];
}

- (void)xc_loadDataWithDate:(NSString *)date timge:(NSString *)time pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?date=%@&time=%@&pageIndex=%ld&pageSize=%ld", URL_GetPageTeacherLessonApp, self.xc_date, self.xc_time, (long)self.xc_pageIndex, (long)self.xc_pageSize];
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
        
        
        if (self.xc_loadType == XCLoadNewData) {
            [self.xc_tableView setContentOffset:CGPointZero animated:YES];
        }
        
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

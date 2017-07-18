//
//  GGT_DetailsOfTeacherViewController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_DetailsOfTeacherViewController.h"
#import "GGT_DetailsOfTeacherView.h"
#import "GGT_OrderClassPopVC.h"

@interface GGT_DetailsOfTeacherViewController () <UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) GGT_DetailsOfTeacherView *detailsOfTeacherView;
@property (nonatomic, strong)  GGT_OrderTimeTableView *orderTimeView;
@property (nonatomic, strong) NSMutableArray *timeDataArray;
@end

@implementation GGT_DetailsOfTeacherViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimeTableColor:) name:@"changeTimeTableColor" object:nil];
}


- (void)changeTimeTableColor:(NSNotification *)noti {
    
    NSDictionary *dic = noti.userInfo;
    if ([[dic objectForKey:@"statusColor"] isEqualToString:@"order"]) {
        [self.orderTimeView  orderCourse];

    } else {
        
        [self.orderTimeView  ClernColor];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"外教详情";
    
    [self setLeftBackButton];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    self.navigationController.navigationBar.translucent = NO;
    

    //外教详情
    [self initHeaderView];

    
    //布局时间列表
    [self initOrderTimeView];

    
    //获取时间列表数据
    [self getOrderTimeTableViewLoadData];
}



#pragma mark 外教详情
- (void)initHeaderView {
    
    self.detailsOfTeacherView = [[GGT_DetailsOfTeacherView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH() - home_leftView_width, LineH(124))];
    self.detailsOfTeacherView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.detailsOfTeacherView getModel:self.pushModel];
    
    __weak GGT_DetailsOfTeacherViewController *weakSelf = self;
    self.detailsOfTeacherView.focusButtonBlock = ^(UIButton *btn) {
        
        if ([btn.titleLabel.text isEqualToString:@"已关注"]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要取消关注吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf focusOnBtnClick:@"1"];
                
            }];
            cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
            sureAction.textColor = UICOLOR_FROM_HEX(kThemeColor);
            [alert addAction:cancelAction];
            [alert addAction:sureAction];
            [weakSelf presentViewController:alert animated:YES completion:nil];
            
        } else if ([btn.titleLabel.text isEqualToString:@"未关注"]) {
            [weakSelf focusOnBtnClick:@"0"];
        }
        
    };
    [self.view addSubview:self.detailsOfTeacherView];
    
}

#pragma mark 关注按钮 (long)self.pushModel.TeacherId
- (void)focusOnBtnClick:(NSString *)statusStr {
    
    NSString *url = [NSString stringWithFormat:@"%@?teacherId=%@&state=%@",URL_GetAttention,self.pushModel.TeacherId,statusStr];
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        //对关注界面进行数据刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFocus" object:nil];
        
        if ([statusStr isEqualToString:@"0"]) {
     
            [self.detailsOfTeacherView.focusButton setTitle:@"已关注" forState:(UIControlStateNormal)];
            [self.detailsOfTeacherView.focusButton setImage:UIIMAGE_FROM_NAME(@"yiguanzhu_yueke") forState:UIControlStateNormal];
            [self.detailsOfTeacherView.focusButton setImage:UIIMAGE_FROM_NAME(@"yiguanzhu_yueke") forState:UIControlStateHighlighted];

            [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
            
            if (self.refreshCellBlick) {
                self.refreshCellBlick(@"1");
            }
            
           
        } else {
            
            [self.detailsOfTeacherView.focusButton setTitle:@"未关注" forState:(UIControlStateNormal)];
            [self.detailsOfTeacherView.focusButton setImage:UIIMAGE_FROM_NAME(@"jiaguanzhu_yueke") forState:UIControlStateNormal];
            [self.detailsOfTeacherView.focusButton setImage:UIIMAGE_FROM_NAME(@"jiaguanzhu_yueke") forState:UIControlStateHighlighted];

            [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];

            if (self.refreshCellBlick) {
                self.refreshCellBlick(@"0");
            }

        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];

    }];
}


#pragma mark 时间列表
- (void)initOrderTimeView {
    self.orderTimeView = [[GGT_OrderTimeTableView alloc]initWithFrame:CGRectMake(0, LineH(129), marginFocusOn, SCREEN_HEIGHT()-LineH(129)-64)];
    self.orderTimeView.backgroundColor = [UIColor clearColor];
    
    __weak GGT_DetailsOfTeacherViewController *weakSelf = self;
    
    self.orderTimeView.orderBlick = ^(GGT_TimeCollectionModel *timeCollectionModel,GGT_HomeDateModel *homeDateModel) {
        
        
        //点击之后判断是否可以预约
        [weakSelf isCanOrderTheCourseData:timeCollectionModel homeDateModel:homeDateModel];
        
    };
    [self.view addSubview:self.orderTimeView];
}

#pragma mark   是否可以预约
- (void)isCanOrderTheCourseData:(GGT_TimeCollectionModel *)timeCollectionModel homeDateModel:(GGT_HomeDateModel *)homeDateModel {
    
    // 进行网络请求判断
    NSString *urlStr = [NSString stringWithFormat:@"%@?teacherId=%@&dateTime=%@", URL_GetIsSureClass, self.pushModel.TeacherId, timeCollectionModel.date];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        GGT_OrderClassPopVC *vc = [GGT_OrderClassPopVC new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = self;
        vc.xc_model = self.pushModel;
        
        //改变预约时间值
        vc.xc_model.StartTime = timeCollectionModel.date;
        
        //预约了课程的回调
        vc.orderCourse = ^(BOOL yes) {
            if (self.refreshLoadDataBlock) {
                self.refreshLoadDataBlock(YES);
            }
            
        };
        [self presentViewController:nav animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
        NSDictionary *dic = error.userInfo;
        if ([dic[@"msg"] isKindOfClass:[NSString class]]) {
            [MBProgressHUD showMessage:dic[@"msg"] toView:self.view];
        }
        
        [self.orderTimeView  ClernColor];
    }];
    
}

#pragma mark ---以下为数据表格的数据操作---
- (void)getOrderTimeTableViewLoadData {
    
    NSString *url = [NSString stringWithFormat:@"%@?teacherId=%@",URL_GetTimeByTeacherId,self.pushModel.TeacherId];

    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        /*代码啰嗦，待改进*/
        NSDictionary *dataDic = responseObject[@"data"];
        self.timeDataArray = [NSMutableArray array];
        NSMutableArray *classListAArr = [NSMutableArray array];
        NSMutableArray *classListBArr = [NSMutableArray array];
        NSMutableArray *classListCArr = [NSMutableArray array];
        NSMutableArray *classListDArr = [NSMutableArray array];
        NSMutableArray *classListEArr = [NSMutableArray array];
        NSMutableArray *classListFArr = [NSMutableArray array];
        NSMutableArray *classListGArr = [NSMutableArray array];
        
        
        
        for (NSDictionary *dic in dataDic[@"classListA"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListAArr addObject:model];
        }
        [self.timeDataArray addObject:classListAArr];
        
        
        for (NSDictionary *dic in dataDic[@"classListB"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListBArr addObject:model];
        }
        [self.timeDataArray addObject:classListBArr];
        
        for (NSDictionary *dic in dataDic[@"classListC"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListCArr addObject:model];
        }
        [self.timeDataArray addObject:classListCArr];
        
        for (NSDictionary *dic in dataDic[@"classListD"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListDArr addObject:model];
        }
        [self.timeDataArray addObject:classListDArr];
        
        for (NSDictionary *dic in dataDic[@"classListE"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListEArr addObject:model];
        }
        [self.timeDataArray addObject:classListEArr];
        
        for (NSDictionary *dic in dataDic[@"classListF"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListFArr addObject:model];
        }
        [self.timeDataArray addObject:classListFArr];
        
        for (NSDictionary *dic in dataDic[@"classListG"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListGArr addObject:model];
        }
        
        [self.timeDataArray addObject:classListGArr];
        
        //cell获得数据
        [self.orderTimeView getCellArr:self.timeDataArray];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];

    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTimeTableColor" object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

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
    
    [self initUI];
    
    //布局时间列表
    [self initOrderTimeView];

    //获取时间列表数据
    [self getOrderTimeTableViewLoadData];
}

-(void)initUI {
    self.navigationItem.title = @"老师详情";
    [self setLeftBackButton];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.navigationController.navigationBar.translucent = NO;
    
    
    //外教详情
    [self.view addSubview:self.detailsOfTeacherView];
    [self.detailsOfTeacherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(marginFocusOn, 124));
    }];
}

#pragma mark 外教详情
-(GGT_DetailsOfTeacherView *)detailsOfTeacherView {
    if (!_detailsOfTeacherView) {
        self.detailsOfTeacherView = [[GGT_DetailsOfTeacherView alloc]initWithFrame:CGRectZero];
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
    }
    return _detailsOfTeacherView;
}



#pragma mark 关注按钮 (long)self.pushModel.TeacherId
- (void)focusOnBtnClick:(NSString *)statusStr {
    
    NSString *url = [NSString stringWithFormat:@"%@?teacherId=%@&state=%@",URL_Attention_Home,self.pushModel.TeacherId,statusStr];
    
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
    self.orderTimeView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
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

        vc.ImageUrl = self.pushModel.ImageUrl;
        vc.TeacherName = self.pushModel.TeacherName;
        vc.StartTime = [NSString stringWithFormat:@"%@ (%@)  %@", homeDateModel.date, homeDateModel.week, timeCollectionModel.time];
        vc.LessonId = [NSString stringWithFormat:@"%ld",(long)timeCollectionModel.TLId];

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
        
//        NSDictionary *dataDic = responseObject[@"data"];
//        //获取所有的key
//        NSArray *keyArray = [dataDic allKeys];
//        //对所有的key进行排序
//        NSArray *newKeyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
//
//
//
//        //处理数据，对每一个section数据添加到大数组中
//        for (int i=0; i<newKeyArray.count; i++) {
//            NSMutableArray *section = [NSMutableArray array];
//            for (NSDictionary *dic in dataDic[newKeyArray[i]]) {
//                GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
//                [section addObject:model];
//            }
//            [tempArray addObject:section];
//        }
            NSMutableArray *tempArray = [NSMutableArray array];

        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] > 0) {
            NSArray *dataArr = responseObject[@"data"];
            for (NSArray *arr in dataArr) {
                NSMutableArray *section = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
                    [section addObject:model];
                }
                [tempArray addObject:section];
            }
        }
        
        
        //cell获得数据
        [self.orderTimeView getCellArr:tempArray];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];

    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTimeTableColor" object:nil];
    NSLog(@"控制器--%@--销毁了", [self class]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

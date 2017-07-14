//
//  GGT_DetailsOfTeacherViewController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_DetailsOfTeacherViewController.h"
#import "GGT_DetailsOfTeacherView.h"
#import "GGT_FocusImgModel.h"

@interface GGT_DetailsOfTeacherViewController ()

@property (nonatomic, strong) GGT_DetailsOfTeacherView *detailsOfTeacherView;
@property (nonatomic, strong)  GGT_OrderTimeTableView *orderTimeView;
@property (nonatomic, strong) NSMutableArray *timeDataArray;

@end

@implementation GGT_DetailsOfTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"老师详情";
    
    [self setLeftBackButton];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self getOrderTimeTableViewLoadData];

    
    
    GGT_DetailsOfTeacherView *View = [[GGT_DetailsOfTeacherView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH() - home_leftView_width, 124)];
    View.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [View getModel:self.pushModel];
    View.focusButtonBlock = ^(UIButton *btn) {
        NSLog(@"关注按钮的状态---%@",btn.titleLabel.text);
        
        if ([btn.titleLabel.text isEqualToString:@"已关注"]) {

            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要取消关注吗？" preferredStyle:UIAlertControllerStyleAlert];
            alert.titleColor = UICOLOR_FROM_HEX(0x000000);
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不取消" style:UIAlertActionStyleCancel handler:nil];
            cancelAction.textColor = UICOLOR_FROM_HEX(ColorC40016);
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self focusOnBtnClick:@"1"];

            }];
            sureAction.textColor = UICOLOR_FROM_HEX(Color777777);

            [alert addAction:cancelAction];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if ([btn.titleLabel.text isEqualToString:@"未关注"]) {
            [self focusOnBtnClick:@"0"];
        }
    
    };
    [self.view addSubview:View];
    
    
    
    self.orderTimeView = [[GGT_OrderTimeTableView alloc]initWithFrame:CGRectMake(0, 129, marginFocusOn, SCREEN_HEIGHT()-129)];
    self.orderTimeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.orderTimeView];
    
    
}

#pragma mark 关注按钮
- (void)focusOnBtnClick:(NSString *)statusStr {
    
    NSString *url = [NSString stringWithFormat:@"%@?teacherId=%@&state=%@",URL_GetAttention,[NSString stringWithFormat:@"%ld",(long)self.pushModel.TeacherId],statusStr];
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([statusStr isEqualToString:@"0"]) {
            
        } else {
            [self performSelector:@selector(backClick) withObject:nil afterDelay:1.0f];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ---以下为数据表格的数据操作---
- (void)getOrderTimeTableViewLoadData {
    
    NSString *url = [NSString stringWithFormat:@"%@?teacherId=%@",URL_GetTimeByTeacherId,[NSString stringWithFormat:@"%ld",(long)self.pushModel.TeacherId]];

    
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
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

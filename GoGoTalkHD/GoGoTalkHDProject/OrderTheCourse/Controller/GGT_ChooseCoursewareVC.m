//
//  GGT_ChooseCoursewareVC.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ChooseCoursewareVC.h"
#import "GGT_ChooseCoursewareCell.h"

@interface GGT_ChooseCoursewareVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *xc_tableView;
@property (nonatomic, strong) UIButton *xc_leftItemButton;
@property (nonatomic, strong) UIButton *xc_rightItemButton;
@property (nonatomic, strong) NSMutableArray *xc_dataMuArray;
@property (nonatomic, strong) GGT_CoursewareModel *xc_coursewareModel;
@property (nonatomic, strong) UILabel *xc_placeholderLabel;
@end

@implementation GGT_ChooseCoursewareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.xc_dataMuArray = [NSMutableArray array];
    
    [self buildUI];
    
    [self buildAction];
    
    [self xc_loadData];
}

- (void)xc_loadData
{
    [[BaseService share] sendGetRequestWithPath:URL_GetBookList token:YES viewController:self success:^(id responseObject) {
        
        NSArray *dataArray = responseObject[@"data"];
        if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0) {
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_CoursewareModel *model = [GGT_CoursewareModel yy_modelWithDictionary:obj];
                if (idx == 0) {
                    model.xc_isSelected = YES;
                } else {
                    model.xc_isSelected = NO;
                }
                [self.xc_dataMuArray addObject:model];
            }];
        }
        [self.xc_tableView reloadData];
        
        self.xc_placeholderLabel.text = responseObject[@"msg"];
        
        
    } failure:^(NSError *error) {
        
        NSDictionary *dic = error.userInfo;
        self.xc_placeholderLabel.text = dic[@"msg"];
        
    }];
}

- (void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"选择重上课程";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(17),NSFontAttributeName,UICOLOR_FROM_HEX(ColorFFFFFF),NSForegroundColorAttributeName, nil]];
    
    self.navigationController.navigationBar.hidden = NO;
    
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
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [self.xc_tableView registerClass:[GGT_ChooseCoursewareCell class] forCellReuseIdentifier:NSStringFromClass([GGT_ChooseCoursewareCell class])];
    
    //左侧取消按钮
    self.xc_leftItemButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = Font(15);
        [button sizeToFit];
        button;
    });
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.xc_leftItemButton];
    
    self.xc_rightItemButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"预约" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = Font(15);
        [button sizeToFit];
        button;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.xc_rightItemButton];
    
    
#pragma mark - 添加xc_placeholderView
    self.xc_placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 462, 368)];
    self.xc_placeholderLabel.textAlignment = NSTextAlignmentCenter;
    self.xc_tableView.enablePlaceHolderView = YES;
    self.xc_tableView.xc_PlaceHolderView = self.xc_placeholderLabel;
    
}

- (void)buildAction
{
    @weakify(self);
    [[self.xc_leftItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.xc_rightItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        // 发送网络请求
        [self sendNetwork];
        
    }];
}

- (void)sendNetwork
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"lessonId"] = self.xc_model.LessonId;
    dic[@"bId"] = self.xc_coursewareModel.BookingId;
    dic[@"beId"] = self.xc_coursewareModel.BDEId;

    [[BaseService share] sendPostRequestWithPath:URL_AgainLesson parameters:dic token:YES viewController:self success:^(id responseObject) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([responseObject[@"msg"] isKindOfClass:[NSString class]]) {
            [MBProgressHUD showMessage:responseObject[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTimeTableColor" object:nil userInfo:@{@"statusColor":@"order"}];

    } failure:^(NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTimeTableColor" object:nil userInfo:@{@"statusColor":@"cancle"}];

        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        NSDictionary *dic = error.userInfo;
        if ([dic[@"msg"] isKindOfClass:[NSString class]]) {
            [MBProgressHUD showMessage:dic[@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.xc_dataMuArray.count == 0) {
        self.xc_rightItemButton.hidden = YES;
    } else {
        self.xc_rightItemButton.hidden = NO;
    }
    return self.xc_dataMuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGT_ChooseCoursewareCell *cell = [GGT_ChooseCoursewareCell cellWithTableView:tableView forIndexPath:indexPath];
    cell.xc_model = self.xc_dataMuArray[indexPath.row];
    GGT_CoursewareModel *model = self.xc_dataMuArray[indexPath.row];
    if (model.xc_isSelected == YES) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGT_ChooseCoursewareCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GGT_CoursewareModel *model = self.xc_dataMuArray[indexPath.row];
    model.xc_isSelected = YES;
    cell.xc_model = model;
    self.xc_coursewareModel = model;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GGT_ChooseCoursewareCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GGT_CoursewareModel *model = self.xc_dataMuArray[indexPath.row];
    model.xc_isSelected = NO;
    cell.xc_model = model;
}


@end

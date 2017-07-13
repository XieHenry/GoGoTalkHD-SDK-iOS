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
@end

@implementation GGT_ChooseCoursewareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
    [self buildAction];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGT_ChooseCoursewareCell *cell = [GGT_ChooseCoursewareCell cellWithTableView:tableView forIndexPath:indexPath];
    return cell;
}



@end

//
//  GGT_OrderClassPopVC.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderClassPopVC.h"
#import "GGT_ChooseCoursewareVC.h"

@interface GGT_OrderClassPopVC ()

// 取消按钮
@property (nonatomic, strong) UIButton *xc_cancleButton;

// 顶部title
@property (nonatomic, strong) UILabel *xc_topTitleLabel;

// 教师头像
@property (nonatomic, strong) UIImageView *xc_teachImgView;

// 教师名字
@property (nonatomic, strong) UILabel *xc_teachNameLabel;

// 时间
@property (nonatomic, strong) UILabel *xc_timeLabel;

// 选择课程按钮
@property (nonatomic, strong) UIButton *xc_chooseCourseButton;

// 确定按钮
@property (nonatomic, strong) UIButton *xc_sureButton;

@end

@implementation GGT_OrderClassPopVC

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 462;
        tempSize.height = 368;
        return tempSize;
    }else {
        return [super preferredContentSize];
    }
}
- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
    [self buildAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)buildUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 取消按钮
    self.xc_cancleButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIIMAGE_FROM_NAME(@"Shut_down") forState:UIControlStateNormal];
        button;
    });
    [self.view addSubview:self.xc_cancleButton];
    
    [self.xc_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.view);
        make.height.width.equalTo(@(67.0f/2));
    }];
    
    // 顶部title
    self.xc_topTitleLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(17);
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.text = @"确认预约";
        label;
    });
    [self.view addSubview:self.xc_topTitleLabel];
    
    [self.xc_topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(46.0f/2);
        make.centerX.equalTo(self.view);
    }];
    
    // 教师头像
    self.xc_teachImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.backgroundColor = [UIColor orangeColor];
        imgView;
    });
    [self.view addSubview:self.xc_teachImgView];
    
    [self.xc_teachImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topTitleLabel.mas_bottom).offset(53.0f/2);
        make.centerX.equalTo(self.xc_topTitleLabel);
        make.width.height.equalTo(@(144.0f/2));
    }];
    
    // 教师名字
    self.xc_teachNameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.font = Font(15);
        label;
    });
    [self.view addSubview:self.xc_teachNameLabel];
    
    [self.xc_teachNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_teachImgView.mas_bottom).offset(25.0f/2);
        make.centerX.equalTo(self.xc_teachImgView);
    }];
    
    // 上课时间
    self.xc_timeLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.font = Font(15);
        label;
    });
    [self.view addSubview:self.xc_timeLabel];
    
    [self.xc_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_teachNameLabel.mas_bottom).offset(57.0f/2);
        make.centerX.equalTo(self.xc_teachNameLabel);
    }];
    
    // 选择课程按钮
    self.xc_chooseCourseButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UICOLOR_FROM_HEX(kThemeColor) forState:UIControlStateNormal];
        button.titleLabel.font = Font(14);
        button;
    });
    [self.view addSubview:self.xc_chooseCourseButton];
    
    [self.xc_chooseCourseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_timeLabel.mas_bottom).offset(71.0f/2);
        make.centerX.equalTo(self.xc_timeLabel);
    }];
    
    // 确定按钮
    self.xc_sureButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:UICOLOR_FROM_HEX(kThemeColor)];
        [button setTitle:@"预约" forState:UIControlStateNormal];
        button.titleLabel.font = Font(17);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button;
    });
    [self.view addSubview:self.xc_sureButton];
    
    [self.xc_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-45.0f/2);
        make.width.equalTo(@(641.0f/2));
        make.height.equalTo(@(91.0f/2));
        make.centerX.equalTo(self.view);
    }];
    
    
    
    self.xc_teachNameLabel.text = @"123";
    self.xc_timeLabel.text = @"123";
    [self.xc_chooseCourseButton setTitle:@"123" forState:UIControlStateNormal];
    
}

- (void)buildAction
{
    // 取消事件
    @weakify(self);
    [[self.xc_cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // 选择课件
    [[self.xc_chooseCourseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        GGT_ChooseCoursewareVC *vc = [GGT_ChooseCoursewareVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // 确认预约事件
    [[self.xc_sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
}


@end

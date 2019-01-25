//
//  GGT_FeedbackViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/15.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_FeedbackViewController.h"
#import "PlaceholderTextView.h"
#import "GGT_ShareAndFeedBackViewController.h"

@interface GGT_FeedbackViewController () <UIPopoverPresentationControllerDelegate,UITextViewDelegate>
//文字输入框
@property (nonatomic, strong) UITextView *contentTextView;

//提交按钮
@property (nonatomic, strong) UIButton *submitBtn;

//0/200
@property (nonatomic, strong) UILabel *alertLabel;

//提醒文字
@property (nonatomic, strong) UILabel *alertContentLabel;

@end

@implementation GGT_FeedbackViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.navigationItem.title = @"意见反馈";
    
    //设置提交按钮
    [self setRightButton];
    
    //创建内容
    [self initContentView];
    
}

- (void)initContentView {
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = LineW(6);
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_offset(180);
    }];
    
    
    
    self.contentTextView = [[PlaceholderTextView alloc]init];
    self.contentTextView.delegate = self;
    self.contentTextView.font = Font(18);
    self.contentTextView.tintColor = UICOLOR_FROM_HEX(ColorC40016);
    [bgView addSubview:self.contentTextView];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(0);
        make.left.equalTo(bgView.mas_left).offset(20);
        make.right.equalTo(bgView.mas_right).offset(-20);
        make.bottom.equalTo(bgView.mas_bottom).offset(-0);
    }];
    
    
    self.alertContentLabel = [[UILabel alloc]init];
    self.alertContentLabel.text = @" 请输入您要反馈的问题或建议（200字以内）";
    self.alertContentLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    self.alertContentLabel.font = Font(18);
    [self.contentTextView addSubview:self.alertContentLabel];
    
    [self.alertContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_top).offset(8);
        make.left.equalTo(self.contentTextView.mas_left).offset(0);
        make.height.equalTo(@(25));
    }];
    
    
    
    
    self.alertLabel = [[UILabel alloc]init];
    self.alertLabel.text = @"0/200";
    self.alertLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    self.alertLabel.font = Font(10);
    [self.view addSubview:self.alertLabel];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(10);
        make.right.equalTo(bgView.mas_right);
        make.height.equalTo(@(14));
    }];
    
}


- (void)setRightButton {
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:UICOLOR_FROM_HEX(ColorD8D8D8) forState:UIControlStateNormal];
    self.submitBtn.frame = CGRectMake(0, 0, LineW(44), LineH(44));
    self.submitBtn.titleLabel.font = Font(16);
    self.submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.submitBtn];
    [self.submitBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = - LineX(5);
    self.navigationItem.rightBarButtonItems = @[spacer,rightItem];
    //先设置为灰色不可点击状态，如果添加了数据，才可以点击。
    self.submitBtn.userInteractionEnabled = NO;
}



- (void)textViewDidChange:(UITextView *)textView {
    if (IsStrEmpty(textView.text)) {
        self.submitBtn.userInteractionEnabled = NO;
        [self.submitBtn setTitleColor:UICOLOR_FROM_HEX(ColorD8D8D8) forState:UIControlStateNormal];
        self.alertLabel.text = @"0/200";
        self.alertContentLabel.text = @" 请输入您要反馈的问题或建议（200字以内）";

    } else {
        //如果超过200字，就限制，并放弃第一响应者
        if (textView.text.length > 200) {
            textView.text = [textView.text substringToIndex:200];
            [self.contentTextView resignFirstResponder];
        }
        self.submitBtn.userInteractionEnabled = YES;
        [self.submitBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
        self.alertLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        self.alertContentLabel.text = @"";
    }
}




- (void)rightAction {

    NSDictionary *postDic = @{@"remark":self.contentTextView.text};
    
    [[BaseService share] requestWithPath:URL_OpinionFeedback method:XCHttpRequestGet parameters:postDic token:YES viewController:self success:^(id responseObject) {
        
        //内容清空，按钮不在可以点击
        self.contentTextView.text = @"";
        self.alertLabel.text = @"0/200";
        self.alertContentLabel.text = @" 请输入您要反馈的问题或建议（200字以内）";
        self.contentTextView.tintColor = UICOLOR_FROM_HEX(ColorC40016);
        self.submitBtn.userInteractionEnabled = NO;
        [self.submitBtn setTitleColor:UICOLOR_FROM_HEX(ColorD8D8D8) forState:UIControlStateNormal];
        [self.contentTextView resignFirstResponder];

        
        GGT_ShareAndFeedBackViewController *vc = [GGT_ShareAndFeedBackViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        vc.isShareController = NO;
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = self;
        [self presentViewController:nav animated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  GGT_ChangePassWordViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/15.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ChangePassWordViewController.h"
#import "GGT_ChangePasswordView.h"

@interface GGT_ChangePassWordViewController ()
//保存按钮
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) GGT_ChangePasswordView *changePasswordView;
@end

@implementation GGT_ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self setLeftItem:@"fanhui_top" title:@"个人信息"];
    self.navigationItem.title = @"修改密码";
    
    //设置提交按钮
    [self setSaveButton];
    
    [self.view addSubview:self.changePasswordView];
}

-(GGT_ChangePasswordView *)changePasswordView {
    if (!_changePasswordView) {
        __weak typeof(self) weakSelf = self;
        self.changePasswordView = [[GGT_ChangePasswordView alloc]init];
        self.changePasswordView.frame = CGRectMake(LineX(20), LineY(20), marginMineRight-LineW(40),LineH(96));
        [self.changePasswordView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineW(6)];
        self.changePasswordView.FieldBlock = ^(BOOL isCanSave) {
            if (isCanSave == YES) {
                //符合要求
                weakSelf.saveBtn.userInteractionEnabled = YES;
                [weakSelf.saveBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
            } else {
                weakSelf.saveBtn.userInteractionEnabled = NO;
                [weakSelf.saveBtn setTitleColor:UICOLOR_FROM_HEX(ColorD8D8D8) forState:UIControlStateNormal];
            }
        };
    }
    return _changePasswordView;
}


- (void)setSaveButton {
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:UICOLOR_FROM_HEX(ColorD8D8D8) forState:UIControlStateNormal];
    self.saveBtn.frame = CGRectMake(0, 0, LineW(44), LineH(44));
    self.saveBtn.titleLabel.font = Font(16);
    self.saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    [self.saveBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = - LineX(5);
    self.navigationItem.rightBarButtonItems = @[spacer,rightItem];
    //先设置为灰色不可点击状态，如果添加了数据，才可以点击。
    self.saveBtn.userInteractionEnabled = NO;
}




- (void)rightAction {
    
    NSDictionary *postDic = @{@"OldPwd":self.changePasswordView.currentField.text,@"NewPwd":self.changePasswordView.changeField.text};
    
    [[BaseService share] requestWithPath:URL_ChangePwdByOldPwd method:XCHttpRequestPost parameters:postDic token:YES viewController:self success:^(id responseObject) {
        
        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
        [UserDefaults() setObject:self.changePasswordView.changeField.text forKey:K_password];
        [UserDefaults() synchronize];
        
        [self performSelector:@selector(turnBackClick) withObject:nil afterDelay:0.0f];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
    
}


- (void)turnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

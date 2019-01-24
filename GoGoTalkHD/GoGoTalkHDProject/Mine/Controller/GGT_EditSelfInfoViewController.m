//
//  GGT_EditSelfInfoViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/23.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_EditSelfInfoViewController.h"

@interface GGT_EditSelfInfoViewController ()
//保存按钮
@property (nonatomic, strong) UIButton *saveBtn;
//输入框
@property (nonatomic, strong) UITextField *contentField;
//0/20
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation GGT_EditSelfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置提交按钮
    [self setSaveButton];
    
    //设置内容
    [self initContentView];
    
}

- (void)initContentView {
    //背景view
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    bgView.layer.cornerRadius = LineH(6);
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(LineY(20));
        make.left.equalTo(self.view.mas_left).offset(LineX(20));
        make.right.equalTo(self.view.mas_right).offset(-LineW(20));
        make.height.mas_offset(LineH(48));
    }];
    
    
    //输入框
    self.contentField = [[UITextField alloc]init];
    self.contentField.font = Font(18);
    self.contentField.textColor = UICOLOR_FROM_HEX(Color3D3D3D);
    self.contentField.tintColor = UICOLOR_FROM_HEX(ColorC40016);
    self.contentField.clearButtonMode = YES;
    [self.contentField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:self.contentField];
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(LineX(20));
        make.right.equalTo(bgView.mas_right).offset(-LineX(10));
        make.top.equalTo(bgView.mas_top).offset(LineY(10));
        make.height.mas_equalTo(LineH(25));
    }];
    
    
    self.alertLabel = [[UILabel alloc]init];
    self.alertLabel.text = @"0/20";
    self.alertLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    self.alertLabel.font = Font(10);
    [self.view addSubview:self.alertLabel];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(LineY(10));
        make.right.equalTo(bgView.mas_right);
        make.height.equalTo(@(LineH(14)));
    }];
    
    
    NSString *contentStr;
    if ([self.titleStr isEqualToString:@"英文名"]) {
        
        if (IsStrEmpty(self.getModel.NameEn)) {
            contentStr = @"";
        } else {
            contentStr = self.getModel.NameEn;
        }
        
    }else if ([self.titleStr isEqualToString:@"中文名"]) {
        
        if (IsStrEmpty(self.getModel.Name)) {
            contentStr = @"";
        } else {
            contentStr = self.getModel.Name;
        }
        
    } else if ([self.titleStr isEqualToString:@"父母称呼"]) {
        
        if (IsStrEmpty(self.getModel.FatherName)) {
            contentStr = @"";
        } else {
            contentStr = self.getModel.FatherName;
        }
        
    }
    
    self.contentField.text = contentStr;
    //>=4,才显示高亮
    if (self.contentField.text.length >= 1) {
        self.saveBtn.userInteractionEnabled = YES;
        [self.saveBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
    }
    self.alertLabel.text = [NSString stringWithFormat:@"%lu/20",(unsigned long)contentStr.length];
    
    
}


- (void)textFieldDidChange:(UITextField *)textField {
    if (IsStrEmpty(textField.text)) {
        self.saveBtn.userInteractionEnabled = NO;
        [self.saveBtn setTitleColor:UICOLOR_FROM_HEX(ColorD8D8D8) forState:UIControlStateNormal];
        self.alertLabel.text = @"0/20";
        
    } else {
        //如果超过200字，就限制，并放弃第一响应者
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
            [self.contentField resignFirstResponder];
        }
        
        //>=4,才显示高亮
        if (textField.text.length >= 1) {
            self.saveBtn.userInteractionEnabled = YES;
            [self.saveBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
        } else {
            self.saveBtn.userInteractionEnabled = NO;
            [self.saveBtn setTitleColor:UICOLOR_FROM_HEX(ColorD8D8D8) forState:UIControlStateNormal];
        }
        self.alertLabel.text = [NSString stringWithFormat:@"%lu/20",(unsigned long)textField.text.length];
        
    }
    
}

- (void)setSaveButton {
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self setLeftItem:@"fanhui_top" title:@"个人信息"];
    self.navigationItem.title = self.titleStr;
    
    
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


#pragma mark 目前接口还有问题，等待修改
- (void)rightAction {
    //如果没网络的情况下，提交信息会造成数据为空，造成崩溃，因此，判断一下
    if (IsStrEmpty(self.getModel.Mobile)) {
        [MBProgressHUD showMessage:xc_alert_message toView:self.view];
        return;
    }
    
    NSDictionary *postDic;
    
    //1:男   0:女   未完善是随便一个数字
    int sexInt;
    if ([self.getModel.Gender isEqualToString:@"男"]) {
        sexInt = 1;
    } else if ([self.getModel.Gender isEqualToString:@"女"]) {
        sexInt = 0;

    } else {
        sexInt = 2;
    }
    
    if ([self.titleStr isEqualToString:@"英文名"]) {
        
        postDic = @{@"NameEn":self.contentField.text,@"Name":self.getModel.Name,@"Age":[NSString stringWithFormat:@"%ld",(long)self.getModel.Age],@"Gender":@(sexInt),@"FatherName":self.getModel.FatherName,@"DateOfBirth":self.getModel.Birthday,@"Province":@0,@"City":@0,@"Area":@0};
        
        
    }else if ([self.titleStr isEqualToString:@"中文名"]) {
        
        postDic = @{@"NameEn":self.getModel.NameEn,@"Name":self.contentField.text,@"Age":[NSString stringWithFormat:@"%ld",(long)self.getModel.Age],@"Gender":@(sexInt),@"FatherName":self.getModel.FatherName,@"DateOfBirth":self.getModel.Birthday,@"Province":@0,@"City":@0,@"Area":@0};
        
        
        
        
    } else if ([self.titleStr isEqualToString:@"父母称呼"]) {
        
        postDic = @{@"NameEn":self.getModel.NameEn,@"Name":self.getModel.Name,@"Age":[NSString stringWithFormat:@"%ld",(long)self.getModel.Age],@"Gender":@(sexInt),@"FatherName":self.contentField.text,@"DateOfBirth":self.getModel.Birthday,@"Province":@0,@"City":@0,@"Area":@0};
    }
    
    
    [[BaseService share] sendPostRequestWithPath:URL_UpdateStudentInfo parameters:postDic token:YES viewController:self success:^(id responseObject) {
        
        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
        
        if (self.buttonClickBlock) {
            self.buttonClickBlock(self.contentField.text);
        }
        
        if ([self.titleStr isEqualToString:@"英文名"]) {
            //如果中文名修改之后，需要刷新头像下面的信息，即名字，使用通知来做
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNameStatus" object:nil userInfo:@{@"isRefresh":@"NO"}];
        }
        
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

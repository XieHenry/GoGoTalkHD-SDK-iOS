//
//  GGT_RegisterView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_RegisterView.h"

@implementation GGT_RegisterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpContentView];
    }
    return self;
}


- (void)setUpContentView {
    UIImageView *backImgView = [[UIImageView alloc]init];
    backImgView.image = UIIMAGE_FROM_NAME(@"return_red");
    [self addSubview:backImgView];
    
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(21);
        make.top.equalTo(self.mas_top).offset(33);
        make.size.mas_offset(CGSizeMake(11, 18));
    }];
    
    
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.backButton];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(30);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    
    //icon
    UIImageView *iconImageView = [[UIImageView alloc]init];
    iconImageView.image = UIIMAGE_FROM_NAME(@"logo");
    [self addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(60);
        make.size.mas_offset(CGSizeMake(175, 52));
    }];
    
    
    //手机号码
    self.phoneAccountView = [[UIView alloc]init];
    self.phoneAccountView.layer.masksToBounds = YES;
    self.phoneAccountView.layer.cornerRadius = LineW(6);
    self.phoneAccountView.layer.borderWidth = LineW(1);
    self.phoneAccountView.layer.borderColor = UICOLOR_FROM_HEX(ColorD5D5D5).CGColor;
    [self addSubview:self.phoneAccountView];
    
    [self.phoneAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(iconImageView.mas_bottom).offset(40);
        make.size.mas_offset(CGSizeMake(336, 44));
    }];
    
    
    //手机icon
    self.phoneImageView = [[UIImageView alloc]init];
    self.phoneImageView.image = UIIMAGE_FROM_NAME(@"iPone_not");
    [self.phoneAccountView addSubview:self.phoneImageView];
    
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneAccountView.mas_left).offset(15);
        make.centerY.equalTo(self.phoneAccountView.mas_centerY);
        make.size.mas_offset(CGSizeMake(14, 20));
    }];
    
    //手机号的分割线
    self.phonelineView = [[UIView alloc]init];
    self.phonelineView.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    [self.phoneAccountView addSubview:self.phonelineView];
    
    [self.phonelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneAccountView.mas_left).offset(44);
        make.top.equalTo(self.phoneAccountView.mas_top).offset(0);
        make.size.mas_offset(CGSizeMake(1, 44));
    }];
    
    
    //手机号码输入框
    self.phoneAccountField = [[UITextField alloc]init];
    self.phoneAccountField.font = Font(18);
    self.phoneAccountField.textColor = UICOLOR_FROM_HEX(Color202020);
    self.phoneAccountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"请输入手机号码"] attributes:@{NSForegroundColorAttributeName: UICOLOR_FROM_HEX(ColorD5D5D5)}];
    self.phoneAccountField.tintColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    self.phoneAccountField.delegate = self;
    self.phoneAccountField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneAccountField.clearButtonMode = YES;
    [self.phoneAccountField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneAccountView addSubview:self.phoneAccountField];
    
    [self.phoneAccountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneAccountView.mas_left).offset(68);
        make.right.equalTo(self.phoneAccountView.mas_right).offset(-15);
        make.centerY.equalTo(self.phoneAccountView.mas_centerY);
        make.height.mas_offset(25);
    }];
    
    
    
    /****************************************************/
    //密码view
    self.passwordView = [[UIView alloc]init];
    self.passwordView.layer.masksToBounds = YES;
    self.passwordView.layer.cornerRadius = LineW(6);
    self.passwordView.layer.borderWidth = LineW(1);
    self.passwordView.layer.borderColor = UICOLOR_FROM_HEX(ColorD5D5D5).CGColor;
    [self addSubview:self.passwordView];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.phoneAccountView.mas_bottom).offset(30);
        make.size.mas_offset(CGSizeMake(336, 44));
    }];
    
    
    //密码icon
    self.passwordImageView = [[UIImageView alloc]init];
    self.passwordImageView.image = UIIMAGE_FROM_NAME(@"Password_not");
    [self.passwordView addSubview:self.passwordImageView];
    
    [self.passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordView.mas_left).offset(15);
        make.centerY.equalTo(self.passwordView.mas_centerY);
        make.size.mas_offset(CGSizeMake(14, 20));
    }];
    
    //密码的分割线
    self.passwordlineView = [[UIView alloc]init];
    self.passwordlineView.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    [self.passwordView addSubview:self.passwordlineView];
    
    [self.passwordlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordView.mas_left).offset(44);
        make.top.equalTo(self.passwordView.mas_top).offset(0);
        make.size.mas_offset(CGSizeMake(1, 44));
    }];
    
    
    
    
    //密码
    self.passwordField = [[UITextField alloc]init];
    self.passwordField.font = Font(18);
    self.passwordField.textColor = UICOLOR_FROM_HEX(Color202020);
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"请输入密码"] attributes:@{NSForegroundColorAttributeName: UICOLOR_FROM_HEX(ColorD5D5D5)}];
    self.passwordField.tintColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    self.passwordField.delegate = self;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.clearButtonMode = YES;
    [self.passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordView addSubview:self.passwordField];
    
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordView.mas_left).offset(68);
        make.right.equalTo(self.passwordView.mas_right).offset(-15);
        make.centerY.equalTo(self.passwordView.mas_centerY);
        make.height.mas_offset(25);
    }];

    
    
    

    //注册
    self.registerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.registerButton setTitle:@"注 册" forState:(UIControlStateNormal)];
    [self.registerButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
    self.registerButton.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
    self.registerButton.titleLabel.font = Font(18);
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.cornerRadius = LineW(22);
    [self addSubview:self.registerButton];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.passwordView.mas_bottom).offset(40);
        make.size.mas_offset(CGSizeMake(324, 44));
    }];


    //背景图
    UIImageView *footerImageView = [[UIImageView alloc]init];
    footerImageView.image = UIIMAGE_FROM_NAME(@"tob_background_copy");
    [self addSubview:footerImageView];
    
    [footerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.size.mas_offset(CGSizeMake(1024, 327));
    }];
    
}

#pragma mark 开始点击输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.phoneAccountField) {
        self.phoneAccountView.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
        self.phoneAccountField.tintColor = UICOLOR_FROM_HEX(ColorC40016);
        self.phoneImageView.image = UIIMAGE_FROM_NAME(@"iPone_have");
        self.phonelineView.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
    } else {
        self.passwordView.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
        self.passwordField.tintColor = UICOLOR_FROM_HEX(ColorC40016);
        self.passwordImageView.image = UIIMAGE_FROM_NAME(@"Password_have");
        self.passwordlineView.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
    }
}


#pragma mark 结束点击输入框
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //手机号
    self.phoneAccountView.layer.borderColor = UICOLOR_FROM_HEX(ColorD5D5D5).CGColor;
    self.phoneAccountField.tintColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    self.phoneImageView.image = UIIMAGE_FROM_NAME(@"iPone_not");
    self.phonelineView.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    
    
    //密码
    self.passwordView.layer.borderColor = UICOLOR_FROM_HEX(ColorD5D5D5).CGColor;
    self.passwordField.tintColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    self.passwordImageView.image = UIIMAGE_FROM_NAME(@"Password_not");
    self.passwordlineView.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);

    
}

#pragma mark 检测输入框的字数限制
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.phoneAccountField) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    } else {
        
        if (textField.text.length > 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    }
}



@end

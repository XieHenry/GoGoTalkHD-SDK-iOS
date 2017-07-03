//
//  GGT_ForgotPasswordView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ForgotPasswordView.h"

@implementation GGT_ForgotPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpContentView];
    }
    return self;
}


- (void)setUpContentView {
    //手机号码
    self.phoneAccountView = [[UIView alloc]init];
    self.phoneAccountView.layer.masksToBounds = YES;
    self.phoneAccountView.layer.cornerRadius = LineW(6);
    self.phoneAccountView.layer.borderWidth = LineW(1);
    self.phoneAccountView.layer.borderColor = UICOLOR_FROM_HEX(ColorD5D5D5).CGColor;
    [self addSubview:self.phoneAccountView];
    
    [self.phoneAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(LineY(60));
        make.size.mas_offset(CGSizeMake(LineW(336), LineH(44)));
    }];
    
    
    //手机icon
    self.phoneImageView = [[UIImageView alloc]init];
    self.phoneImageView.image = UIIMAGE_FROM_NAME(@"iPone_not");
    [self.phoneAccountView addSubview:self.phoneImageView];
    
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneAccountView.mas_left).with.offset(LineX(15));
        make.centerY.mas_equalTo(self.phoneAccountView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(14), LineH(20)));
    }];
    
    //手机号的分割线
    self.phonelineView = [[UIView alloc]init];
    self.phonelineView.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    [self.phoneAccountView addSubview:self.phonelineView];
    
    [self.phonelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_right).with.offset(LineX(15));
        make.top.equalTo(self.phoneAccountView.mas_top).with.offset(LineY(0));
        make.size.mas_offset(CGSizeMake(LineW(1), LineH(44)));
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
        make.left.equalTo(self.phonelineView.mas_right).with.offset(LineX(23));
        make.right.equalTo(self.phoneAccountView.mas_right).with.offset(-LineW(15));
        make.centerY.mas_equalTo(self.phoneAccountView.mas_centerY);
        make.height.mas_offset(LineH(25));
    }];
    
    
    /****************************************************/
    
    //验证码view
    self.verificationCodeView = [[UIView alloc]init];
    self.verificationCodeView.layer.masksToBounds = YES;
    self.verificationCodeView.layer.cornerRadius = LineW(6);
    self.verificationCodeView.layer.borderWidth = LineW(1);
    self.verificationCodeView.layer.borderColor = UICOLOR_FROM_HEX(ColorD5D5D5).CGColor;
    [self addSubview:self.verificationCodeView];
    
    [self.verificationCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(self.phoneAccountView.mas_bottom).with.offset(LineY(30));
        make.size.mas_offset(CGSizeMake(LineW(336), LineH(44)));
    }];

    
    //验证码icon
    self.verificationCodeImageView = [[UIImageView alloc]init];
    self.verificationCodeImageView.image = UIIMAGE_FROM_NAME(@"validation_not");
    [self.verificationCodeView addSubview:self.verificationCodeImageView];
    
    [self.verificationCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationCodeView.mas_left).with.offset(LineX(13));
        make.centerY.mas_equalTo(self.verificationCodeView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(18), LineH(20)));
    }];

    
    //验证码的分割线
    self.verificationCodelineView1 = [[UIView alloc]init];
    self.verificationCodelineView1.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    [self.verificationCodeView addSubview:self.verificationCodelineView1];
    
    [self.verificationCodelineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationCodeImageView.mas_right).with.offset(LineX(13));
        make.top.equalTo(self.verificationCodeView.mas_top).with.offset(LineY(0));
        make.size.mas_offset(CGSizeMake(LineW(1), LineH(44)));
    }];

    //验证码的分割线
    self.verificationCodelineView2 = [[UIView alloc]init];
    self.verificationCodelineView2.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    [self.verificationCodeView addSubview:self.verificationCodelineView2];
    
    [self.verificationCodelineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.verificationCodeView.mas_right).with.offset(-LineX(87));
        make.top.equalTo(self.verificationCodeView.mas_top).with.offset(LineY(0));
        make.size.mas_offset(CGSizeMake(LineW(1), LineH(44)));
    }];

    
    //验证码
    self.verificationCodeField = [[UITextField alloc]init];
    self.verificationCodeField.font = Font(18);
    self.verificationCodeField.textColor = UICOLOR_FROM_HEX(Color202020);
    self.verificationCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"请输入验证码"] attributes:@{NSForegroundColorAttributeName: UICOLOR_FROM_HEX(ColorD5D5D5)}];
    self.verificationCodeField.tintColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    self.verificationCodeField.delegate = self;
    self.verificationCodeField.clearButtonMode = YES;
    self.verificationCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.verificationCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verificationCodeView addSubview:self.verificationCodeField];
    
    [self.verificationCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationCodelineView1.mas_right).with.offset(LineX(23));
        make.right.equalTo(self.verificationCodelineView2.mas_left).with.offset(-LineX(15));
        make.centerY.mas_equalTo(self.verificationCodeView.mas_centerY);
        make.height.mas_offset(LineH(25));
    }];
    

    //获取验证码
    self.getCodeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.getCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.getCodeButton setTitleColor:UICOLOR_FROM_HEX(ColorC40016) forState:(UIControlStateNormal)];
    self.getCodeButton.titleLabel.font = Font(14);
    [self.verificationCodeView addSubview:self.getCodeButton];
    
    
    [self.getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationCodelineView2.mas_right).with.offset(0);
        make.right.equalTo(self.verificationCodeView.mas_right).with.offset(-0);
        make.top.equalTo(self.verificationCodeView.mas_top).with.offset(0);
        make.height.mas_offset(LineH(44));
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
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(self.verificationCodeView.mas_bottom).with.offset(LineY(30));
        make.size.mas_offset(CGSizeMake(LineW(336), LineH(44)));
    }];
    
    
    //密码icon
    self.passwordImageView = [[UIImageView alloc]init];
    self.passwordImageView.image = UIIMAGE_FROM_NAME(@"Password_not");
    [self.passwordView addSubview:self.passwordImageView];
    
    [self.passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordView.mas_left).with.offset(LineX(15));
        make.centerY.mas_equalTo(self.passwordView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(14), LineH(20)));
    }];
    
    //密码的分割线
    self.passwordlineView = [[UIView alloc]init];
    self.passwordlineView.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    [self.passwordView addSubview:self.passwordlineView];
    
    [self.passwordlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordImageView.mas_right).with.offset(LineX(15));
        make.top.equalTo(self.passwordView.mas_top).with.offset(LineY(0));
        make.size.mas_offset(CGSizeMake(LineW(1), LineH(44)));
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
        make.left.equalTo(self.passwordlineView.mas_right).with.offset(LineX(23));
        make.right.equalTo(self.passwordView.mas_right).with.offset(-LineW(15));
        make.centerY.mas_equalTo(self.passwordView.mas_centerY);
        make.height.mas_offset(LineH(25));
    }];
    
    
    
    
    self.confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.confirmButton setTitle:@"确 认" forState:(UIControlStateNormal)];
    [self.confirmButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
    self.confirmButton.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
    self.confirmButton.titleLabel.font = Font(18);
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.cornerRadius = LineW(22);
    [self addSubview:self.confirmButton];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(self.passwordView.mas_bottom).with.offset(LineY(40));
        make.size.mas_offset(CGSizeMake(LineW(324), LineH(44)));
    }];

}

#pragma mark 开始点击输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.phoneAccountField) {
        
        self.phoneAccountView.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
        self.phoneAccountField.tintColor = UICOLOR_FROM_HEX(ColorC40016);
        self.phoneImageView.image = UIIMAGE_FROM_NAME(@"iPone_have");
        self.phonelineView.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
        
    } else if(textField == self.verificationCodeField) {
        
        self.verificationCodeView.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
        self.verificationCodeField.tintColor = UICOLOR_FROM_HEX(ColorC40016);
        self.verificationCodeImageView.image = UIIMAGE_FROM_NAME(@"validation_have");
        self.verificationCodelineView1.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
        self.verificationCodelineView2.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);

    } else if (textField == self.passwordField) {
        
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
    
    //验证码
    self.verificationCodeView.layer.borderColor = UICOLOR_FROM_HEX(ColorD5D5D5).CGColor;
    self.verificationCodeField.tintColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    self.verificationCodeImageView.image = UIIMAGE_FROM_NAME(@"validation_not");
    self.verificationCodelineView1.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);
    self.verificationCodelineView2.backgroundColor = UICOLOR_FROM_HEX(ColorD5D5D5);


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
    } else if(textField == self.verificationCodeField) {
        
        if (textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
        }
    } else if (textField == self.passwordField) {
        if (textField.text.length > 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    }
}



@end

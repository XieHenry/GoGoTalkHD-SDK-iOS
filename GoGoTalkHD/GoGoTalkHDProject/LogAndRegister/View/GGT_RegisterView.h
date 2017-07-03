//
//  GGT_RegisterView.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_RegisterView : UIView <UITextFieldDelegate>

//手机账号view
@property (nonatomic, strong) UIView *phoneAccountView;
//手机icom
@property (nonatomic, strong) UIImageView *phoneImageView;
//手机输入框
@property (nonatomic, strong) UITextField *phoneAccountField;
//手机号的分割线
@property (nonatomic, strong) UIView *phonelineView;



//密码view
@property (nonatomic, strong) UIView *passwordView;
//密码icom
@property (nonatomic, strong) UIImageView *passwordImageView;
//密码输入框
@property (nonatomic, strong) UITextField *passwordField;
//密码的分割线
@property (nonatomic, strong) UIView *passwordlineView;



//注册
@property (nonatomic, strong) UIButton *registerButton;
//返回按钮
@property (nonatomic, strong) UIButton *backButton;



@end

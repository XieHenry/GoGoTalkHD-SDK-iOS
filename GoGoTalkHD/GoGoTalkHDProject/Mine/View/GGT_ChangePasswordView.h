//
//  GGT_ChangePasswordView.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/17.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_ChangePasswordView : UIView <UITextFieldDelegate>

//当前密码
@property (nonatomic, strong) UITextField *currentField;
//新的密码
@property (nonatomic, strong) UITextField *changeField;

//block回调
@property (nonatomic, copy) void(^FieldBlock) (BOOL isCanSave);

@end

//
//  MBProgressHUD+Extension.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extension)
//自定义--图片带文字
+ (void)showSuccessWithImage:(NSString *)success toView:(UIView *)view;
+ (void)showErrorWithImage:(NSString *)error toView:(UIView *)view;


//自定义--只有文字，用于提醒状态
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


//设置菊花 带有文字提醒
+ (MBProgressHUD *)showLoading:(UIView *)view title:(NSString *)title;
//设置菊花 不带文字提醒
+ (MBProgressHUD *)showLoading:(UIView *)view;


//隐藏提醒框
+ (void)hideHUDForView:(UIView *)view;
@end

//
//  MBProgressHUD+Extension.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

#pragma mark 设置带图片的提醒框
+ (void)showSuccessWithImage:(NSString *)success toView:(UIView *)view {
    [self showTextWithImage:success icon:@"success" view:view];
}

+ (void)showErrorWithImage:(NSString *)error toView:(UIView *)view {
    [self showTextWithImage:error icon:@"error" view:view];
}

+ (void)showTextWithImage:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置自定义模式
    hud.mode = MBProgressHUDModeCustomView;
    //    UIImage *image = [[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@",icon]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //设置图片
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@",icon]];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    //设置提醒文字
    hud.detailsLabel.text = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 设置提醒框背景色
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [hud hideAnimated:YES afterDelay:1.5f];
}


#pragma mark 只设置文字提醒框
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //可以改变文字提醒框的大小
    //    hud.minSize = CGSizeMake(120, 50);
    hud.mode = MBProgressHUDModeText;
    hud.label.text = IsStrEmpty(message) ? @"" : message;
    hud.label.textColor = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 设置提醒框背景色
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [hud hideAnimated:YES afterDelay:1.5f];

    return hud;
}


#pragma mark 设置菊花
+ (MBProgressHUD *)showLoading:(UIView *)view {
    return  [MBProgressHUD showLoading:view title:nil];
}


+(MBProgressHUD *)showLoading:(UIView *)view title:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view==nil?[[UIApplication sharedApplication].windows lastObject]:view animated:YES];
    hud.label.text = title;
    hud.label.textColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeIndeterminate;
    //    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //可以改变菊花框的大小
    hud.minSize = CGSizeMake(100, 100);
    hud.layer.cornerRadius = 7;
    // 设置提醒框背景色
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //设置菊花颜色
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}


#pragma mark 隐藏提醒框
+ (void)hideHUDForView:(UIView *)view {
    [self hideHUDForView:view==nil?[[UIApplication sharedApplication].windows lastObject]:view animated:YES];
}


@end

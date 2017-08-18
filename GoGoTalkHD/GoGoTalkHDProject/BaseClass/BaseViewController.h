//
//  BaseViewController.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_LoadingView.h"

@interface BaseViewController : UIViewController
@property (nonatomic, strong) GGT_LoadingView *loadingView;

//左侧返回按钮
- (void)setLeftBackButton;

//导航左侧图片
- (void)setLeftItem:(NSString *)imageName;

//导航左侧,图片带文字
- (void)setLeftItem:(NSString *)imageName title:(NSString *)title;

//导航右侧文字
- (void)setRightBarButtonItemTitle:(NSString *)title;

//导航右侧图片
- (void)setRightButtonWithImg:(NSString *)imageName;

//左侧按钮点击事件
- (void)leftAction;

//右侧按钮的点击事件
- (void)rightAction;

//网络请求失败后，重新点击按钮加载数据
- (void)showLoadingView;

- (void)hideLoadingView;

@end

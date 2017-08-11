//
//  UIControl+XCNoRepeatClick.h
//  XCHelper
//
//  Created by 辰 on 2017/4/21.
//  Copyright © 2017年 Chn. All rights reserved.
//  防止按钮多次点击
//  设置custom_acceptEventInterval的点击时间间隔来实现在多就的时间后可以再次点击

#import <UIKit/UIKit.h>

@interface UIControl (XCNoRepeatClick)
@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;// 可以用这个给重复点击加间
@end

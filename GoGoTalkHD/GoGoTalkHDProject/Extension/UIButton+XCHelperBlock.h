//
//  UIButton+XCHelperBlock.h
//  XCHelper
//
//  Created by 辰 on 2017/4/21.
//  Copyright © 2017年 Chn. All rights reserved.
//  UIButton的事件采用Block的形式来书写 但要注意循环引用的问题
/*  采用weakSelf的形式来书写
 __weak typeof(self) weakSelf = self;
 [button xc_addClickBlock:^(UIButton *button) {
     __strong typeof(weakSelf) strongSelf = weakSelf;
     NSLog(@"点击了button, %@", strongSelf.view);
 }];
 */

#import <UIKit/UIKit.h>

typedef void (^XCUIButtonClickBlock)(UIButton *button);

@interface UIButton (XCHelperBlock)

/**
 *  block添加点击事件
 */
- (void)xc_addClickBlock: (XCUIButtonClickBlock) block;

@end

//
//  GGT_PreviewCourseAlertView.h
//  GoGoTalk
//
//  Created by 辰 on 2017/5/8.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , XCShowAnimationStyle) {
    XCAnimationDefault    = 0,
    XCAnimationLeftShake  ,
    XCAnimationTopShake   ,
    XCAnimationNO         ,
};

typedef void(^XCAlertCancleBlock)();
typedef void(^XCAlertEnterBlock)();

@interface GGT_PreviewCourseAlertView : UIView

@property (nonatomic, copy) XCAlertCancleBlock cancleBlock;
@property (nonatomic, copy) XCAlertEnterBlock  enterBlock;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock;

+ (instancetype)viewWithTitle:(NSString *)title message:(NSString *)message cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock;

@end

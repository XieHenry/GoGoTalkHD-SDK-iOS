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

typedef enum : NSUInteger {
    XCPopTypeEnterRoom,
    XCPopTypeHumanService,
} XCPopType;

typedef void(^XCAlertCancleBlock)(void);
typedef void(^XCAlertEnterBlock)(void);

@interface GGT_PreviewCourseAlertView : UIView

@property (nonatomic, copy) XCAlertCancleBlock cancleBlock;
@property (nonatomic, copy) XCAlertEnterBlock  enterBlock;

//- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock;
//
//+ (instancetype)viewWithTitle:(NSString *)title message:(NSString *)message cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock;

+ (instancetype)viewWithTitle:(NSString *)title message:(NSString *)message bottomButtonTitle:(NSString *)buttonTitle bgImg:(NSString *)bgImgName type:(XCPopType)type cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock;

@end

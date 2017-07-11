//
//  GGT_ConfirmBookingAlertView.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/10.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonBlock)(UIButton *button);

@interface GGT_ConfirmBookingAlertView : UIView

//按钮
@property (nonatomic, copy) ButtonBlock  buttonBlock;
//姓名
@property (nonatomic, strong) UITextField *nameField;
//课件
@property (nonatomic, strong) UITextField *kejianField;
//时间
@property (nonatomic, strong) UITextField *dateField;

@end

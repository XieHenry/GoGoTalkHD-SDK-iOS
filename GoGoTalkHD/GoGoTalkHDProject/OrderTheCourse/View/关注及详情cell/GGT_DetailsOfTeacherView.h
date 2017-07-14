//
//  GGT_DetailsOfTeacherView.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/11.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_OrderTimeTableView.h"


typedef void(^FocusButtonBlock)(UIButton *btn);

@interface GGT_DetailsOfTeacherView : UIView
//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//姓名
@property (nonatomic, strong) UILabel *nameLabel;
//性别
@property (nonatomic, strong) UILabel *sexLabel;
//次数
@property (nonatomic, strong) UILabel *orderNumLabel;
//年龄
@property (nonatomic, strong) UILabel *ageLabel;
//关注
@property (nonatomic, strong) UIButton *focusButton;

@property (nonatomic, copy) FocusButtonBlock focusButtonBlock;

- (void)getModel:(GGT_HomeTeachModel *)model;

@end

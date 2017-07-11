//
//  GGT_OrderForeignListCell.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
//暂无数据的提醒
#import "GGT_NoMoreDateAlertView.h"


@interface GGT_OrderForeignListCell : UITableViewCell

//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//姓名
@property (nonatomic, strong) UILabel *nameLabel;
//关注
@property (nonatomic, strong) UIButton *focusButton;
//次数img
@property (nonatomic, strong) UIImageView *orderNumImageView;
//次数
@property (nonatomic, strong) UILabel *orderNumLabel;
//预约按钮
@property (nonatomic, strong) UIButton *orderButton;

@end

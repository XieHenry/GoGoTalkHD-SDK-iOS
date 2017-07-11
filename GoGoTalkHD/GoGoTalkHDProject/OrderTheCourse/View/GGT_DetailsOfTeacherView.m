//
//  GGT_DetailsOfTeacherView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/11.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_DetailsOfTeacherView.h"

@implementation GGT_DetailsOfTeacherView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpContentView];
    }
    return self;
}


- (void)setUpContentView {
    //教师的基本信息
    self.teacherInfoView = [[UIImageView alloc]init];
    self.teacherInfoView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self addSubview:self.teacherInfoView];
    
    [self.teacherInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.height.mas_offset(LineH(70));
    }];
    
    
    //头像
    self.iconImageView = [[UIImageView alloc]init];
    //    self.iconImageView.image = [UIImage imageNamed:@""];
    //    self.iconImageView.backgroundColor = UICOLOR_RANDOM_COLOR();
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = LineW(25);
    self.iconImageView.layer.borderWidth = LineW(0.5);
    self.iconImageView.layer.borderColor = UICOLOR_FROM_HEX(ColorF2F2F2).CGColor;
    [self.teacherInfoView addSubview:self.iconImageView];
    
   
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.teacherInfoView.mas_left).with.offset(LineX(15));
        make.centerY.equalTo(self.teacherInfoView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(50), LineW(50)));
    }];
    
    
    //姓名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"bo";
    self.nameLabel.font = Font(16);
    self.nameLabel.textColor = UICOLOR_FROM_HEX(Color333333);
    [self.teacherInfoView addSubview:self.nameLabel];
    
    
    //性别
    self.sexLabel = [[UILabel alloc]init];
    self.sexLabel.text = @"男";
    self.sexLabel.font = Font(10);
    self.sexLabel.textColor = UICOLOR_FROM_HEX(Color999999);
    [self.teacherInfoView addSubview:self.sexLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(LineX(10));
        make.right.equalTo(self.sexLabel.mas_left).with.offset(-LineX(10));
        make.top.equalTo(self.iconImageView.mas_top).with.offset(LineY(10));
        make.height.mas_offset(LineW(18));
    }];
    
    
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(LineX(10));
        make.bottom.equalTo(self.nameLabel.mas_bottom);
        make.height.mas_offset(LineW(12));
    }];
    
    //次数img
    self.orderNumImageView = [[UIImageView alloc]init];
    self.orderNumImageView.image = UIIMAGE_FROM_NAME(@"shangkecishu_laoshixiangqing");
    [self.teacherInfoView addSubview:self.orderNumImageView];
    
    
    //次数
    self.orderNumLabel = [[UILabel alloc]init];
    self.orderNumLabel.text = @"236次";
    self.orderNumLabel.font = Font(10);
    self.orderNumLabel.textColor = UICOLOR_FROM_HEX(Color999999);
    [self.teacherInfoView addSubview:self.orderNumLabel];


    //年龄
    self.ageImageView = [[UIImageView alloc]init];
    self.ageImageView.image = UIIMAGE_FROM_NAME(@"nianling_laoshixiangqing");
    [self.teacherInfoView addSubview:self.ageImageView];
    
 
    //年龄
    self.ageLabel = [[UILabel alloc]init];
    self.ageLabel.text = @"25岁";
    self.ageLabel.font = Font(10);
    self.ageLabel.textColor = UICOLOR_FROM_HEX(Color999999);
    [self.teacherInfoView addSubview:self.ageLabel];
    

    
    [self.orderNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(LineX(10));
        make.right.equalTo(self.orderNumLabel.mas_left).with.offset(-LineX(5));
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
        make.size.mas_offset(CGSizeMake(LineW(10), LineW(10)));
    }];
    
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNumImageView.mas_right).with.offset(LineX(5));
        make.right.equalTo(self.ageImageView.mas_left).with.offset(-LineX(15));
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
        make.height.mas_offset(LineW(12));
    }];
    
    [self.ageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNumLabel.mas_right).with.offset(LineX(15));
        make.right.equalTo(self.ageLabel.mas_left).with.offset(-LineX(5));
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
        make.size.mas_offset(CGSizeMake(LineW(12), LineW(10.5)));
    }];
    
    
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageImageView.mas_right).with.offset(LineX(5));
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
        make.height.mas_offset(LineW(12));
    }];
    
    
    //关注
    self.focusButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.focusButton setImage:UIIMAGE_FROM_NAME(@"jiaguanzhu_laoshixiangqing") forState:UIControlStateNormal];
    [self.teacherInfoView addSubview:self.focusButton];

    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.teacherInfoView.mas_right).with.offset(-LineW(15));
        make.centerY.equalTo(self.teacherInfoView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(48), LineH(24)));
    }];

    
    
    self.orderTimeView = [[GGT_OrderTimeTableView alloc]init];
    [self addSubview:self.orderTimeView];
    
    [self.orderTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teacherInfoView.mas_bottom).with.offset(LineY(10));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0);
    }];
    
    
}

@end

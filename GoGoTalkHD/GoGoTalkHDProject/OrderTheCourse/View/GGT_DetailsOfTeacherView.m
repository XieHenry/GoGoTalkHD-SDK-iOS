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
    
    //头像
    self.iconImageView = [[UIImageView alloc]init];
    //    self.iconImageView.image = [UIImage imageNamed:@""];
    //    self.iconImageView.backgroundColor = UICOLOR_RANDOM_COLOR();
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = LineW(36);
    self.iconImageView.layer.borderWidth = LineW(1);
    self.iconImageView.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
    [self addSubview:self.iconImageView];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(LineX(359));
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(72), LineW(72)));
    }];
    
    
    
    //姓名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"Runsun";
    self.nameLabel.font = Font(15);
    self.nameLabel.textColor = UICOLOR_FROM_HEX(Color333333);
    [self addSubview:self.nameLabel];
    
    //关注
    self.focusButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.focusButton setTitle:@"已关注" forState:(UIControlStateNormal)];
    self.focusButton.titleLabel.font = Font(10);
    [self.focusButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
    self.focusButton.backgroundColor = UICOLOR_FROM_HEX(ColorCCCCCC);
    [self.focusButton addTarget:self action:@selector(focusOnBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.focusButton];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(LineX(9));
        make.right.equalTo(self.focusButton.mas_left).with.offset(-LineX(9));
        make.top.equalTo(self.mas_top).with.offset(LineY(42));
        make.height.mas_offset(LineW(18));
    }];
    
    
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(LineX(9));
        make.top.equalTo(self.mas_top).with.offset(LineY(42));
        make.height.mas_offset(LineH(19));
    }];
    
    
    
    //
    //    //性别
    //    self.sexLabel = [[UILabel alloc]init];
    //    self.sexLabel.text = @"男";
    //    self.sexLabel.font = Font(10);
    //    self.sexLabel.textColor = UICOLOR_FROM_HEX(Color999999);
    //    [self.teacherInfoView addSubview:self.sexLabel];
    //
    //
    //
    //    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.nameLabel.mas_right).with.offset(LineX(10));
    //        make.bottom.equalTo(self.nameLabel.mas_bottom);
    //        make.height.mas_offset(LineW(12));
    //    }];
    //
    //    //次数img
    //    self.orderNumImageView = [[UIImageView alloc]init];
    //    self.orderNumImageView.image = UIIMAGE_FROM_NAME(@"shangkecishu_laoshixiangqing");
    //    [self.teacherInfoView addSubview:self.orderNumImageView];
    //
    //
    //    //次数
    //    self.orderNumLabel = [[UILabel alloc]init];
    //    self.orderNumLabel.text = @"236次";
    //    self.orderNumLabel.font = Font(10);
    //    self.orderNumLabel.textColor = UICOLOR_FROM_HEX(Color999999);
    //    [self.teacherInfoView addSubview:self.orderNumLabel];
    //
    //
    //    //年龄
    //    self.ageImageView = [[UIImageView alloc]init];
    //    self.ageImageView.image = UIIMAGE_FROM_NAME(@"nianling_laoshixiangqing");
    //    [self.teacherInfoView addSubview:self.ageImageView];
    //
    //
    //    //年龄
    //    self.ageLabel = [[UILabel alloc]init];
    //    self.ageLabel.text = @"25岁";
    //    self.ageLabel.font = Font(10);
    //    self.ageLabel.textColor = UICOLOR_FROM_HEX(Color999999);
    //    [self.teacherInfoView addSubview:self.ageLabel];
    //
    //
    //
    //    [self.orderNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.iconImageView.mas_right).with.offset(LineX(10));
    //        make.right.equalTo(self.orderNumLabel.mas_left).with.offset(-LineX(5));
    //        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
    //        make.size.mas_offset(CGSizeMake(LineW(10), LineW(10)));
    //    }];
    //
    //    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.orderNumImageView.mas_right).with.offset(LineX(5));
    //        make.right.equalTo(self.ageImageView.mas_left).with.offset(-LineX(15));
    //        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
    //        make.height.mas_offset(LineW(12));
    //    }];
    //
    //    [self.ageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.orderNumLabel.mas_right).with.offset(LineX(15));
    //        make.right.equalTo(self.ageLabel.mas_left).with.offset(-LineX(5));
    //        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
    //        make.size.mas_offset(CGSizeMake(LineW(12), LineW(10.5)));
    //    }];
    //
    //
    //
    //    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.ageImageView.mas_right).with.offset(LineX(5));
    //        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
    //        make.height.mas_offset(LineW(12));
    //    }];
    //
    //
    //
    //
    //
    //    self.orderTimeView = [[GGT_OrderTimeTableView alloc]init];
    //    [self addSubview:self.orderTimeView];
    //
    //    [self.orderTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.teacherInfoView.mas_bottom).with.offset(LineY(10));
    //        make.left.equalTo(self.mas_left).with.offset(0);
    //        make.right.equalTo(self.mas_right).with.offset(-0);
    //        make.bottom.equalTo(self.mas_bottom).with.offset(-0);
    //    }];
    
    
}

- (void)focusOnBtnClick {
    
}
@end

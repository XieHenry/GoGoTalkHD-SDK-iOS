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
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = LineW(36);
    self.iconImageView.layer.borderWidth = LineW(1);
    self.iconImageView.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
    [self addSubview:self.iconImageView];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(LineX(359));
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(72), LineH(72)));
    }];
    
    
    
    //姓名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = Font(15);
    self.nameLabel.textColor = UICOLOR_FROM_HEX(Color333333);
    [self addSubview:self.nameLabel];
    
    //关注
    self.focusButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.focusButton.titleLabel.font = Font(10);
    [self.focusButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
    self.focusButton.backgroundColor = UICOLOR_FROM_HEX(ColorCCCCCC);
    [self.focusButton addTarget:self action:@selector(focusOnBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.focusButton];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(LineX(9));
        make.right.equalTo(self.focusButton.mas_left).with.offset(-LineX(9));
        make.top.equalTo(self.mas_top).with.offset(LineY(42));
        make.height.mas_offset(LineH(18));
    }];
    
    
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(LineX(9));
        make.top.equalTo(self.mas_top).with.offset(LineY(42));
        make.size.mas_offset(CGSizeMake(LineW(36), LineH(19)));
    }];
    
    
    
    
    //性别
    self.sexLabel = [[UILabel alloc]init];
    self.sexLabel.font = Font(12);
    self.sexLabel.textColor = UICOLOR_FROM_HEX(Color666666);
    [self addSubview:self.sexLabel];
    
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(LineX(8));
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(14));
        make.height.mas_offset(LineH(14));
    }];
    
    
    
    //年龄
    self.ageLabel = [[UILabel alloc]init];
    self.ageLabel.font = Font(12);
    self.ageLabel.textColor = UICOLOR_FROM_HEX(Color666666);
    [self addSubview:self.ageLabel];
    
    
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexLabel.mas_right).with.offset(LineX(11));
        make.top.equalTo(self.sexLabel.mas_top);
        make.height.mas_offset(LineH(14));
    }];
    
    
    
    //次数
    self.orderNumLabel = [[UILabel alloc]init];
    self.orderNumLabel.font = Font(12);
    self.orderNumLabel.textColor = UICOLOR_FROM_HEX(Color666666);
    [self addSubview:self.orderNumLabel];
    
    
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageLabel.mas_right).with.offset(LineX(12));
        make.top.equalTo(self.sexLabel.mas_top);
        make.height.mas_offset(LineH(14));
    }];
    

}

- (void)focusOnBtnClick:(UIButton *)btn {
    if (self.focusButtonBlock) {
        self.focusButtonBlock(btn);
    }
}



- (void)getModel:(GGT_HomeTeachModel *)model {
    //头像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.ImageUrl] placeholderImage:UIIMAGE_FROM_NAME(@"headPortrait_default_avatar")];
    
    
    self.nameLabel.text = model.TeacherName;
    
    //是否关注 0：未关注 1：已关注)
    if ([model.IsFollow isEqual:@0]) {
        [self.focusButton setTitle:@"未关注" forState:(UIControlStateNormal)];
    } else {
        [self.focusButton setTitle:@"已关注" forState:(UIControlStateNormal)];
    }
    
    self.sexLabel.text = model.Sex;


    self.ageLabel.text = [NSString stringWithFormat:@"%ld岁",(long)model.Age];
    
    self.orderNumLabel.text = [NSString stringWithFormat:@"上课: %ld",(long)model.LessonCount];

}



@end

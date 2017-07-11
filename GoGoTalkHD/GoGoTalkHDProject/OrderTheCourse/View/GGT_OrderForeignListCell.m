//
//  GGT_OrderForeignListCell.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderForeignListCell.h"

@implementation GGT_OrderForeignListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);

        

        [self initCellView];
        
    }
    return self;
}

- (void)initCellView {
    
    //头像
    self.iconImageView = [[UIImageView alloc]init];
//    self.iconImageView.image = [UIImage imageNamed:@""];
//    self.iconImageView.backgroundColor = UICOLOR_RANDOM_COLOR();
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = LineW(25);
    self.iconImageView.layer.borderWidth = LineW(0.5);
    self.iconImageView.layer.borderColor = UICOLOR_FROM_HEX(ColorF2F2F2).CGColor;
    [self.contentView addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(LineX(15));
        make.top.equalTo(self.contentView.mas_top).with.offset(LineY(10));
        make.size.mas_offset(CGSizeMake(LineW(50), LineW(50)));
    }];
    
    
    
    //姓名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"bo";
    self.nameLabel.font = Font(16);
    self.nameLabel.textColor = UICOLOR_FROM_HEX(Color333333);
    [self.contentView addSubview:self.nameLabel];
    
    
    //关注
    self.focusButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self.focusButton setImage:UIIMAGE_FROM_NAME(@"jiaguanzhu_yueke") forState:(UIControlStateNormal)];
    self.focusButton.backgroundColor = UICOLOR_RANDOM_COLOR();
    [self.contentView addSubview:self.focusButton];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(LineX(10));
        make.right.equalTo(self.focusButton.mas_left).with.offset(-LineX(15));
        make.top.equalTo(self.contentView.mas_top).with.offset(LineY(20));
        make.height.mas_offset(LineW(18));
    }];
    
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(LineX(15));
        make.bottom.equalTo(self.nameLabel.mas_bottom);
        make.size.mas_offset(CGSizeMake(LineW(30), LineW(15)));
    }];
    
    
    
    //次数img
    self.orderNumImageView = [[UIImageView alloc]init];
    self.orderNumImageView.image = [UIImage imageNamed:@"shangkecishu_yueke_liebiao"];
    [self.contentView addSubview:self.orderNumImageView];
    

    //次数
    self.orderNumLabel = [[UILabel alloc]init];
    self.orderNumLabel.text = @"236次";
    self.orderNumLabel.font = Font(10);
    self.orderNumLabel.textColor = UICOLOR_FROM_HEX(Color999999);
    [self.contentView addSubview:self.orderNumLabel];
    
    [self.orderNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(LineX(10));
        make.right.equalTo(self.orderNumLabel.mas_left).with.offset(-LineX(5));
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
        make.size.mas_offset(CGSizeMake(LineW(10), LineW(10)));
    }];
    
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNumImageView.mas_right).with.offset(LineX(5));
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineY(10));
        make.height.mas_offset(LineW(12));
    }];
    
    
  
    
  
   //预约按钮
    self.orderButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.orderButton setTitle:@"预约" forState:(UIControlStateNormal)];
    [self.orderButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
    self.orderButton.titleLabel.font = Font(12);
    self.orderButton.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
    self.orderButton.layer.masksToBounds = YES;
    self.orderButton.layer.cornerRadius = LineH(12);
    [self.contentView addSubview:self.orderButton];
    
    
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-LineX(15));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(54), LineW(24)));
    }];
    
    
    //底部的分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(LineX(10));
        make.right.equalTo(self.contentView.mas_right).with.offset(-0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-0);;
        make.height.mas_offset(LineW(0.5));
    }];
    
    
    
}




@end

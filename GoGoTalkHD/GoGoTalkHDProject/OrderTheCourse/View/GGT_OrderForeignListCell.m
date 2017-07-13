//
//  GGT_OrderForeignListCell.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderForeignListCell.h"

@interface GGT_OrderForeignListCell ()

//头像
@property (nonatomic, strong) UIImageView *xc_iconImageView;
//姓名
@property (nonatomic, strong) UILabel *xc_nameLabel;
//次数
@property (nonatomic, strong) UILabel *xc_orderNumLabel;
// 年龄
@property (nonatomic, strong) UILabel *xc_teachAgeLabel;


@end

@implementation GGT_OrderForeignListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_OrderForeignListCellID = NSStringFromClass([self class]);
    GGT_OrderForeignListCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_OrderForeignListCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_OrderForeignListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_OrderForeignListCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellView];
    }
    return self;
}

- (void)initCellView {
    
    //头像
    self.xc_iconImageView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.backgroundColor = [UIColor orangeColor];
        imgView;
    });
    [self.contentView addSubview:self.xc_iconImageView];
    
    //姓名
    self.xc_nameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.font = Font(15);
        label;
    });
    [self.contentView addSubview:self.xc_nameLabel];
    
    // 次数
    self.xc_orderNumLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color666666);
        label.font = Font(12);
        label;
    });
    [self.contentView addSubview:self.xc_orderNumLabel];
    
    // 年龄
    self.xc_teachAgeLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color666666);
        label.font = Font(12);
        label;
    });
    [self.contentView addSubview:self.xc_teachAgeLabel];
    
    // 关注按钮
    self.xc_focusButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIIMAGE_FROM_NAME(@"jiaguanzhu_yueke") forState:UIControlStateNormal];
//        [button setImage:UIIMAGE_FROM_NAME(@"yiguanzhu_yueke") forState:UIControlStateNormal];
        button;
    });
    [self.contentView addSubview:self.xc_focusButton];
    
    // 预约按钮
    self.xc_orderButton= ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"预约" forState:(UIControlStateNormal)];
        [button setTitleColor:UICOLOR_FROM_HEX(kThemeColor) forState:UIControlStateNormal];
        button.titleLabel.font = Font(20);
        button.backgroundColor = [UIColor whiteColor];
        button;
    });
    [self.contentView addSubview:self.xc_orderButton];
    
    
    // 布局
    // 头像
    [self.xc_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(LineX(15));
        make.top.equalTo(self.contentView.mas_top).with.offset(margin15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-margin15);
        make.width.equalTo(self.xc_iconImageView.mas_height);
    }];
    
    // 姓名
    [self.xc_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_iconImageView.mas_right).with.offset(LineX(14));
        make.top.equalTo(self.contentView.mas_top).with.offset(LineY(27));
    }];
    
    // 次数
    [self.xc_orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_nameLabel.mas_left);
        make.centerY.equalTo(self.xc_iconImageView);
    }];
    
    // 年龄
    [self.xc_teachAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_orderNumLabel.mas_right).offset(margin10);
        make.centerY.equalTo(self.xc_orderNumLabel);
    }];
    
    // 关注
    [self.xc_focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_nameLabel);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-LineY(27));
        make.size.mas_offset(CGSizeMake(LineW(30), LineW(15)));
    }];
    
    // 预约按钮
    [self.xc_orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-LineX(15));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(232.0f/2), LineW(76.0f/2)));
    }];
    
    
    self.xc_nameLabel.text = @"123";
    self.xc_orderNumLabel.text = @"123";
    self.xc_teachAgeLabel.text = @"123";
    
}

- (void)drawRect:(CGRect)rect
{
    [self.xc_iconImageView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:self.xc_iconImageView.height/2];
    [self.xc_orderButton addBorderForViewWithBorderWidth:1.0 BorderColor:UICOLOR_FROM_HEX(kThemeColor) CornerRadius:self.xc_orderButton.height/2];
}




@end

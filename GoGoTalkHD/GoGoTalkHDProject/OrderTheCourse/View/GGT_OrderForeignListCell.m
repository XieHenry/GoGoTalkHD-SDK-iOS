//
//  GGT_OrderForeignListCell.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderForeignListCell.h"

@interface GGT_OrderForeignListCell ()

// 父view
@property (nonatomic, strong) UIView *xc_contentView;
//头像
@property (nonatomic, strong) UIImageView *xc_iconImageView;
//姓名
@property (nonatomic, strong) UILabel *xc_nameLabel;
//次数
@property (nonatomic, strong) UILabel *xc_orderNumLabel;
// 年龄
@property (nonatomic, strong) UILabel *xc_teachAgeLabel;
// 灰线
@property (nonatomic, strong) UIView *xc_lineView;

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellView];
    }
    return self;
}

- (void)initCellView
{
    
    // 线
    self.xc_lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        view;
    });
    [self addSubview:self.xc_lineView];
    
    [self.xc_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(7));
    }];
    
    // 父view
    self.xc_contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self addSubview:self.xc_contentView];
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.xc_lineView.mas_bottom);
    }];
    

    
    //头像
    self.xc_iconImageView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.image = UIIMAGE_FROM_NAME(@"headPortrait_default_avatar");
        imgView;
    });
    [self.xc_contentView addSubview:self.xc_iconImageView];
    
    //姓名
    self.xc_nameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.font = Font(15);
        label;
    });
    [self.xc_contentView addSubview:self.xc_nameLabel];
    
    // 次数
    self.xc_orderNumLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color666666);
        label.font = Font(12);
        label;
    });
    [self.xc_contentView addSubview:self.xc_orderNumLabel];
    
    // 年龄
    self.xc_teachAgeLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color666666);
        label.font = Font(12);
        label;
    });
    [self.xc_contentView addSubview:self.xc_teachAgeLabel];
    
    // 关注按钮
    self.xc_focusButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIIMAGE_FROM_NAME(@"jiaguanzhu_yueke") forState:UIControlStateNormal];
//        [button setImage:UIIMAGE_FROM_NAME(@"yiguanzhu_yueke") forState:UIControlStateNormal];
        button;
    });
    [self.xc_contentView addSubview:self.xc_focusButton];
    
    // 预约按钮
    self.xc_orderButton= ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"预约" forState:(UIControlStateNormal)];
        [button setTitleColor:UICOLOR_FROM_HEX(kThemeColor) forState:UIControlStateNormal];
        button.titleLabel.font = Font(20);
        button.backgroundColor = [UIColor whiteColor];
        button;
    });
    [self.xc_contentView addSubview:self.xc_orderButton];
    
    
    // 布局
    // 头像
    [self.xc_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_contentView.mas_left).with.offset(LineX(15));
        make.top.equalTo(self.xc_contentView.mas_top).with.offset(margin15);
        make.bottom.equalTo(self.xc_contentView.mas_bottom).offset(-margin15);
        make.width.equalTo(self.xc_iconImageView.mas_height);
    }];
    
    // 姓名
    [self.xc_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_iconImageView.mas_right).with.offset(LineX(14));
        make.top.equalTo(self.xc_contentView.mas_top).with.offset(LineY(27));
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
        make.bottom.equalTo(self.xc_contentView.mas_bottom).offset(-LineY(27));
        make.size.mas_offset(CGSizeMake(LineW(30), LineW(15)));
    }];
    
    // 预约按钮
    [self.xc_orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_contentView.mas_right).with.offset(-LineX(15));
        make.centerY.equalTo(self.xc_contentView.mas_centerY);
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

- (void)setXc_model:(GGT_HomeTeachModel *)xc_model
{
    _xc_model = xc_model;
    
    if ([xc_model.TeacherName isKindOfClass:[NSString class]]) {
        self.xc_nameLabel.text = xc_model.TeacherName;
    } else {
        self.xc_nameLabel.text = @"";
    }
    
    //IsFollow":1, （是否关注 0：未关注 1：已关注）
    if ([xc_model.IsFollow isEqualToString:@"0"]) {
        [self.xc_focusButton setImage:UIIMAGE_FROM_NAME(@"jiaguanzhu_yueke") forState:UIControlStateNormal];
        [self.xc_focusButton setImage:UIIMAGE_FROM_NAME(@"jiaguanzhu_yueke") forState:UIControlStateHighlighted];
    } else {
        [self.xc_focusButton setImage:UIIMAGE_FROM_NAME(@"yiguanzhu_yueke") forState:UIControlStateNormal];
        [self.xc_focusButton setImage:UIIMAGE_FROM_NAME(@"yiguanzhu_yueke") forState:UIControlStateHighlighted];
    }
    
    
    self.xc_orderNumLabel.text = [NSString stringWithFormat:@"%ld次", xc_model.LessonCount];
    
    self.xc_teachAgeLabel.text = [NSString stringWithFormat:@"%ld岁", xc_model.Age];
    
    if ([self.xc_model.ImageUrl isKindOfClass:[NSString class]]) {
         NSString *urlStr = [self.xc_model.ImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        [self.xc_iconImageView sd_setImageWithURL:url placeholderImage:UIIMAGE_FROM_NAME(@"headPortrait_default_avatar")];
    }
    
}




@end

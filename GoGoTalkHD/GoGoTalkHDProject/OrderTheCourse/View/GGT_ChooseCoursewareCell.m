//
//  GGT_ChooseCoursewareCell.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ChooseCoursewareCell.h"

@interface GGT_ChooseCoursewareCell ()

// 课件名称
@property (nonatomic, strong) UILabel *xc_nameLabel;

// 选择按钮
@property (nonatomic, strong) UIButton *xc_chooseButton;

// 分割线
@property (nonatomic, strong) UIView *xc_lineView;

@end

@implementation GGT_ChooseCoursewareCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_ChooseCoursewareCellID = NSStringFromClass([self class]);
    GGT_ChooseCoursewareCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_ChooseCoursewareCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_ChooseCoursewareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_ChooseCoursewareCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    // 课件名称
    self.xc_nameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.font = Font(14);
        label;
    });
    [self addSubview:self.xc_nameLabel];
    
    [self.xc_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin15);
        make.centerY.equalTo(self);
    }];
    
    // 选择按钮
    self.xc_chooseButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = UIIMAGE_FROM_NAME(@"bat-weixuanzhong");
        [button setImage:UIIMAGE_FROM_NAME(@"bat-weixuanzhong") forState:UIControlStateNormal];
        [button setImage:UIIMAGE_FROM_NAME(@"bat-xuanzhong") forState:UIControlStateSelected];
        [button setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
        button;
    });
    [self addSubview:self.xc_chooseButton];
    
    [self.xc_chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-margin15);
        make.centerY.equalTo(self);
        make.width.equalTo(@(self.xc_chooseButton.width));
        make.height.equalTo(@(self.xc_chooseButton.height));
    }];
    
    // 分割线
    self.xc_lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        view;
    });
    [self addSubview:self.xc_lineView];
    
    [self.xc_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.equalTo(@(1.0f));
    }];
    
    
    self.xc_nameLabel.text = @"122";
    
}

//- (void)setXc_model:(GGT_TestModel *)xc_model
//{
//    _xc_model = xc_model;
//    if (xc_model.type == 1) {
//        self.xc_chooseButton.selected = YES;
//    } else {
//        self.xc_chooseButton.selected = NO;
//    }
//}

@end

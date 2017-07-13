//
//  GGT_DateCollectionCell.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_DateCollectionCell.h"

@interface GGT_DateCollectionCell ()
@property (nonatomic, strong) UILabel *xc_dayLabel;
@property (nonatomic, strong) UILabel *xc_weekLabel;
@end

@implementation GGT_DateCollectionCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_DateCollectionCellID = NSStringFromClass([self class]);
    GGT_DateCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGT_DateCollectionCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

// 必须得在init方法中config 否则会有重用问题
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configViewWithIndexPath:nil];
    }
    return self;
}

- (void)configViewWithIndexPath:(NSIndexPath *)indexPath
{
    self.xc_dayLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.font = Font(15);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.xc_dayLabel];
    
    
    self.xc_weekLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.font = Font(12);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.xc_weekLabel];
    
    [self.xc_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(27/2.0);
        make.height.equalTo(@(27/2.0));
    }];
    
    [self.xc_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.xc_dayLabel.mas_bottom).equalTo(@(12/2.0));
        make.height.equalTo(@(23/2.0));
    }];
}

- (void)setXc_model:(GGT_HomeDateModel *)xc_model
{
    _xc_model = xc_model;
    
    if ([xc_model.date isKindOfClass:[NSString class]]) {
        self.xc_dayLabel.text = xc_model.date;
    }
    if ([self.xc_model.week isKindOfClass:[NSString class]]) {
        self.xc_weekLabel.text = xc_model.week;
    }
    
    // 0：不可以预约 1：可以预约  2：最近一个可以预约的外教
    switch (xc_model.isHaveClass) {
        case 0:     // 不可以预约
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.xc_weekLabel.textColor = UICOLOR_FROM_HEX(Color999999);
            self.xc_dayLabel.textColor = UICOLOR_FROM_HEX(Color999999);
        }
            break;
        case 1:     // 可以预约
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.xc_weekLabel.textColor = UICOLOR_FROM_HEX(Color333333);
            self.xc_dayLabel.textColor = UICOLOR_FROM_HEX(Color333333);
        }
            break;
        case 2:     // 最近一个可以预约的外教
        {
            self.contentView.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
            self.xc_dayLabel.textColor = [UIColor whiteColor];
            self.xc_weekLabel.textColor = [UIColor whiteColor];
        }
            break;
            
        default:
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.xc_weekLabel.textColor = UICOLOR_FROM_HEX(Color333333);
            self.xc_dayLabel.textColor = UICOLOR_FROM_HEX(Color333333);
        }
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    [self xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:10.0f];
}



@end

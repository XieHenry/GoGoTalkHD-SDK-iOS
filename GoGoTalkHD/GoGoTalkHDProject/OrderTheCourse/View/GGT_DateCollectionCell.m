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
    
    
    self.xc_dayLabel.text = @"12月19日";
    self.xc_weekLabel.text = @"星期五";
}

- (void)setXc_model:(GGT_TestModel *)xc_model
{
    _xc_model = xc_model;
    
    switch (xc_model.type) {
        case 0:     // 不可选中
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.xc_weekLabel.textColor = UICOLOR_FROM_HEX(Color999999);
            self.xc_dayLabel.textColor = UICOLOR_FROM_HEX(Color999999);
        }
            break;
        case 1:     // 当前选中
        {
            self.contentView.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
            self.xc_dayLabel.textColor = [UIColor whiteColor];
            self.xc_weekLabel.textColor = [UIColor whiteColor];
        }
            break;
        case 2:     // 未选中状态
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.xc_weekLabel.textColor = UICOLOR_FROM_HEX(Color333333);
            self.xc_dayLabel.textColor = UICOLOR_FROM_HEX(Color333333);
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

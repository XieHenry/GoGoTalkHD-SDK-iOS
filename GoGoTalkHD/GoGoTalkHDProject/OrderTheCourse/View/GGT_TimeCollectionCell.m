//
//  GGT_TimeCollectionCell.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_TimeCollectionCell.h"

@interface GGT_TimeCollectionCell ()
@property (nonatomic, strong) UILabel *xc_timeLabel;
@end

@implementation GGT_TimeCollectionCell


+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_TimeCollectionCellID = NSStringFromClass([self class]);
    GGT_TimeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGT_TimeCollectionCellID forIndexPath:indexPath];
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
    self.xc_timeLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.font = Font(15);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.xc_timeLabel];
    
    
    [self.xc_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    self.xc_timeLabel.text = @"08:00";
}

- (void)setXc_model:(GGT_TestModel *)xc_model
{
    _xc_model = xc_model;
    switch (xc_model.type) {
        case 0:     // 不可选中
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.xc_timeLabel.textColor = UICOLOR_FROM_HEX(Color999999);
        }
            break;
        case 1:     // 当前选中
        {
            self.contentView.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
            self.xc_timeLabel.textColor = [UIColor whiteColor];
        }
            break;
        case 2:     // 未选中状态
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.xc_timeLabel.textColor = UICOLOR_FROM_HEX(Color333333);
        }
            break;
            
        default:
        {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.xc_timeLabel.textColor = UICOLOR_FROM_HEX(Color333333);
        }
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    [self xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:5.0f];
}

@end

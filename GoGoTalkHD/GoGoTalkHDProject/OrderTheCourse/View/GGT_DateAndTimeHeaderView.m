//
//  GGT_DateAndTimeHeaderView.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_DateAndTimeHeaderView.h"

@interface GGT_DateAndTimeHeaderView ()
@property (nonatomic, strong) UILabel *xc_titleLabel;
@property (nonatomic, strong) NSIndexPath *xc_indexPath;
@end

@implementation GGT_DateAndTimeHeaderView

+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_DateAndTimeHeaderViewID = NSStringFromClass([self class]);
    GGT_DateAndTimeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                         withReuseIdentifier:GGT_DateAndTimeHeaderViewID
                                                                                forIndexPath:indexPath];
    
    headerView.xc_indexPath = indexPath;
    return headerView;
}

// 必须得在init方法中config 否则会有重用问题
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configView];
    }
    return self;
}

- (void)configView
{
    self.xc_titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(kThemeColor);
        label.font = Font(17);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self addSubview:self.xc_titleLabel];
    
    [self.xc_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)setXc_indexPath:(NSIndexPath *)xc_indexPath
{
    _xc_indexPath = xc_indexPath;
    if (xc_indexPath.section == 0) {
        self.xc_titleLabel.text = @"日期";
    } else {
        self.xc_titleLabel.text = @"时间";
    }
}

@end

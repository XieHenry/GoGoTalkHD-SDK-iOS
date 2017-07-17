//
//  GGT_DateAndTimeHeaderView.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_DateAndTimeHeaderView.h"

@interface GGT_DateAndTimeHeaderView ()

@end

@implementation GGT_DateAndTimeHeaderView

+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_DateAndTimeHeaderViewID = NSStringFromClass([self class]);
    GGT_DateAndTimeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                         withReuseIdentifier:GGT_DateAndTimeHeaderViewID
                                                                                forIndexPath:indexPath];
    
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


@end

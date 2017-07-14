//
//  GGT_TimeCollectionCell.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_TimeCollectionCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) GGT_HomeTimeModel *xc_model;

@end

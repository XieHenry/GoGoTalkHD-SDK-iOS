//
//  GGT_PreviewTeachEvaCell.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/8.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGT_PreviewTeachEvaCellDelegate <NSObject>

- (void)previewTeachEvaCellHeightWithHeight:(CGFloat)height;

@end

@interface GGT_PreviewTeachEvaCell : UITableViewCell

@property (nonatomic, strong) GGT_CourseCellModel *xc_model;

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id <GGT_PreviewTeachEvaCellDelegate> delegate;

@end

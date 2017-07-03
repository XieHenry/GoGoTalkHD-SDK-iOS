//
//  GGT_CourseDetailCell.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/22.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_CourseDetailCell : UITableViewCell

// 课程上面的button
@property (nonatomic, strong) UIButton *xc_courseButton;

// 倒计时的时间
@property (nonatomic, strong) NSString *xc_timeCount;

/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)();


+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

// 模型
@property (nonatomic, strong) GGT_CourseCellModel *xc_cellModel;
@end

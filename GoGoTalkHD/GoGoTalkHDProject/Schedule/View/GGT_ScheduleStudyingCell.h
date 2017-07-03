//
//  GGT_ScheduleStudyingCell.h
//  GoGoTalk
//
//  Created by 辰 on 2017/5/3.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_ScheduleStudyingCell : UITableViewCell

// 课程上面的button
@property (nonatomic, strong) UIButton *xc_courseButton;

/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)();

// 倒计时的时间
@property (nonatomic, strong) NSString *xc_timeCount;


+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

// 模型
@property (nonatomic, strong) GGT_CourseCellModel *xc_cellModel;

@end

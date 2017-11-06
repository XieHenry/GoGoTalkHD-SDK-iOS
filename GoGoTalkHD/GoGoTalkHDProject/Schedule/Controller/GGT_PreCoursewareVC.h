//
//  GGT_PreCoursewareVC.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XCDeleteCourseBlock)(void);
typedef void(^XCChangeStatusBlock)(GGT_CourseCellModel *xc_model);

@interface GGT_PreCoursewareVC : BaseViewController

@property (nonatomic, strong) GGT_CourseCellModel *xc_model;

@property (nonatomic, copy) XCDeleteCourseBlock xc_deleteBlock;

@property (nonatomic, copy) XCChangeStatusBlock xc_changeStatusBlock;

@end

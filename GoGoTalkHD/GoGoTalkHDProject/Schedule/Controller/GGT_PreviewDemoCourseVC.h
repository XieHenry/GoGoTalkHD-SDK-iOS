//
//  GGT_PreviewDemoCourseVC.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/9.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XCChangeStatusBlock)(GGT_CourseCellModel *xc_model);

@interface GGT_PreviewDemoCourseVC : BaseViewController

@property (nonatomic, strong) GGT_CourseCellModel *xc_model;

@property (nonatomic, copy) XCChangeStatusBlock xc_changeStatusBlock;

@end

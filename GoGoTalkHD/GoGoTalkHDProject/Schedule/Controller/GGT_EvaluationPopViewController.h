//
//  GGT_EvaluationPopViewController.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/18.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^XCReloadCellBlock)(GGT_CourseCellModel *model);

@interface GGT_EvaluationPopViewController : BaseViewController

@property (nonatomic, strong) GGT_CourseCellModel *xc_model;

@property (nonatomic, copy) XCReloadCellBlock xc_reloadBlock;

@end

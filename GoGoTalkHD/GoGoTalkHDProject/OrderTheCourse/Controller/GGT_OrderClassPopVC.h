//
//  GGT_OrderClassPopVC.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isOrderCourse)(BOOL  yes);
@interface GGT_OrderClassPopVC : BaseViewController

@property (nonatomic, strong) GGT_HomeTeachModel *xc_model;

@property (nonatomic, copy) isOrderCourse orderCourse;
@end

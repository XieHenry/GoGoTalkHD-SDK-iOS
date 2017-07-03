//
//  GGT_ScheduleTableView.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/23.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XCRefreshHeader,
    XCRefreshFooter,
} XCRefreshType;

@interface GGT_ScheduleTableView : UITableView

@property (nonatomic, assign) XCRefreshType xc_refreshType;

@end

//
//  GGT_ScheduleTableView.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/23.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ScheduleTableView.h"

@implementation GGT_ScheduleTableView

- (void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
        if (self.xc_refreshType == XCRefreshHeader) {       // 下拉刷新
            if (contentSize.height > self.contentSize.height)
            {
                CGPoint offset = self.contentOffset;
//                offset.y += (contentSize.height - self.contentSize.height - 40);
                offset.y = (contentSize.height - self.contentSize.height);
                self.contentOffset = offset;
            }
        } else {        // 上拉加载
            
        }
    }
    [super setContentSize:contentSize];
}

@end

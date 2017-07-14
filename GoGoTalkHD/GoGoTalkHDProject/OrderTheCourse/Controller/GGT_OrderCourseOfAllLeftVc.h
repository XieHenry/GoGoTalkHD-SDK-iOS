//
//  GGT_OrderCourseOfAllLeftVc.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGT_OrderCourseOfAllLeftVcDelegate <NSObject>
- (void)leftSendToRightDate:(NSString *)date time:(NSString *)time;
@end

@interface GGT_OrderCourseOfAllLeftVc : BaseViewController
@property (nonatomic, weak) id <GGT_OrderCourseOfAllLeftVcDelegate> delegate;
@end

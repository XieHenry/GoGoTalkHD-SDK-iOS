//
//  GGT_HomeDateModel.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XCDateDoNotOrder,   // 0
    XCDateCanOrder,     // 1
    XCDateSelectOrder,  // 2
} XCDateOrder;

@interface GGT_HomeDateModel : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *week;
@property (nonatomic, assign) NSInteger isHaveClass;

@end


// 0：不可以预约 1：可以预约  2：最近一个可以预约的外教
/*
 date = "7月13日";
 isHaveClass = 1;
 week = "星期四";
 */

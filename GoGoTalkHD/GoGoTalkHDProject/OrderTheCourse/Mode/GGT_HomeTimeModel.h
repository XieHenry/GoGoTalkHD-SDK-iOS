//
//  GGT_HomeTimeModel.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/14.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XCTimeDoNotOrder,   // 0
    XCTimeCanOrder,     // 1
    XCTimeSelectOrder,  // 2
} XCTimeOrder;

@interface GGT_HomeTimeModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) NSInteger pic;

@end

//0：不能预约 1:可以预约 2：默认选中
/*
 name = "17:30";
 pic = 0;
 */

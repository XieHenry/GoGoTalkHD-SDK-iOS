//
//  GGT_TestModel.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_TestModel : NSObject

// NSDictionary *dic = @{@"date":@"08月09日", @"time":@"09:56", @"type":@(i)};

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger type;

@end

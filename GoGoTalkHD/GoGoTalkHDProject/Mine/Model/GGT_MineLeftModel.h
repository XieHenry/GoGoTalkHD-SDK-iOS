//
//  GGT_MineLeftModel.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/26.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_MineLeftModel : NSObject

//迟到
@property (nonatomic, assign) NSInteger chi;

//已说
@property (nonatomic, assign) NSInteger que;

//缺席
@property (nonatomic, assign) NSInteger shuo;

//lv
@property (nonatomic, copy) NSString *lv;

//isVIP
@property (nonatomic, assign) NSInteger isVip;

//剩余课程
@property (nonatomic, assign) NSInteger totalCount;

//姓名
@property (nonatomic, copy) NSString *Name;

//头像
@property (nonatomic, copy) NSString *ImageUrl;

/*
 {
 data =     {
 ImageUrl = "http://117.107.153.228:801";
 Name = "未填写";
 chi = 0;
 isVip = 1;
 lv = L7;
 que = 25;
 shuo = 175;
 totalCount = 619;
 };
 msg = "成功";
 result = 1;
 }
 */


@end

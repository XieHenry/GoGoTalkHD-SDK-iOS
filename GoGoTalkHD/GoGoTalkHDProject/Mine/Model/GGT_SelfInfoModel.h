//
//  GGT_SelfInfoModel.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/24.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_SelfInfoModel : NSObject

//父母称呼
@property (nonatomic, copy) NSString *FatherName;

//中文名
@property (nonatomic, copy) NSString *Name;

//英文名
@property (nonatomic, copy) NSString *NameEn;

//性别
@property (nonatomic, copy) NSString *Gender;

//年龄
@property (nonatomic, assign) NSInteger Age;

//账号信息
@property (nonatomic, copy) NSString *Mobile;

//真实姓名
@property (nonatomic, copy) NSString *RealName;

//生日
@property (nonatomic, copy) NSString *Birthday;

//创建时间
@property (nonatomic, copy) NSString *CreateTime;

//地区
@property (nonatomic, copy) NSString *Address;

@end


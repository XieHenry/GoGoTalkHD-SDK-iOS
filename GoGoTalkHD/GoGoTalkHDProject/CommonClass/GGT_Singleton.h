//
//  GGT_Singleton.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_Singleton : NSObject

+ (GGT_Singleton *)sharedSingleton;

//网络状态
@property (nonatomic) BOOL netStatus;

//照相机权限
@property (nonatomic) BOOL cameraStatus;

//麦克风权限
@property (nonatomic) BOOL micStatus;

//我的-我的课时课程数量
@property (nonatomic, copy) NSString *leftTotalCount;

/**
 @abstract 是否在审核状态,YES是审核状态，NO为正式地址
 **/
@property (nonatomic) BOOL isAuditStatus;

// 学生是否在教室
@property (nonatomic) BOOL isInRoom;

//获取7天的上课时间
@property (nonatomic, strong) NSArray *orderCourse_dateMuArray;

//BASE_URL
@property (nonatomic, strong) NSString *base_url;

//我的界面，点击切换不同的视图，YES是审核状态，NO为正式地址
@property (nonatomic) BOOL isShowAuditStatus;
@end

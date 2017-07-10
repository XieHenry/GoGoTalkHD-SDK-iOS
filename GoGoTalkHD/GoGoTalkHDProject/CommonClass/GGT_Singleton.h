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
 @abstract 是否在审核状态,YES是审核状态
 **/
@property (nonatomic) BOOL isAuditStatus;

// 学生是否在教室
@property (nonatomic) BOOL isInRoom;



@end

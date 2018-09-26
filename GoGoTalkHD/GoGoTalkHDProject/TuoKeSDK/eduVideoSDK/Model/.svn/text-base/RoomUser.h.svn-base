//
//  ClassRoomUser.h
//  classroomsdk
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RoomUser : NSObject

/**
 用户Id
 */
@property (nonatomic, copy) NSString *peerID;

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
  用户身份，0：老师；1：助教；2：学生；3：旁听；4：巡课
 */
@property (nonatomic) int role;

/**
 该用户是否有麦克风
 */
@property (nonatomic) BOOL hasAudio;

/**
 该用户是否有摄像头
 */
@property (nonatomic) BOOL hasVideo;

/**
 该用户是否有权在白板和文档上进行绘制
 */
@property (nonatomic) BOOL canDraw;

/**
 发布状态，0：未发布，1：发布音频；2：发布视频；3：发布音视频
 */
@property (nonatomic) int publishState;

/**
  用户属性。Sdk调用者设置的自定义属性会在这里被找到
 */
@property (nonatomic, strong) NSMutableDictionary *properties;

/**
 该用户是否禁用自己的视频
 */
@property (nonatomic, assign) BOOL disableVideo;

/**
 该用户是否禁用自己的音频
 */
@property (nonatomic, assign) BOOL disableAudio;


/**
 初始化一个用户

 @param peerID 用户id
 @return 用户对象
 */
- (instancetype)initWithId:(NSString *)peerID;

/**
 初始化一个用户

 @param peerID  用户id
 @param properties 用户属性
 @return 用户对象
 */
- (instancetype)initWithId:(NSString *)peerID AndProperties:(NSDictionary*)properties;
@end

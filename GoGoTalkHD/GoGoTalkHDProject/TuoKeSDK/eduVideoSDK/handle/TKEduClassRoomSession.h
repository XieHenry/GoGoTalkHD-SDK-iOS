//
//  TKEduClassRoomSession.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomManager.h"
#import "TKEduClassRoom.h"
/*
 //sMuteAudio->ChangeUserPublish
 //sUpdateTime
 //sClassBegin
 //sWBPageCount sShowPage sSharpsChange->GLOBAL.phone.receivePhoneByTriggerEvent
 //sShowPage->sVideo_MediaFilePage_ShowPage、sAudio_MediaFilePage_ShowPage
 //sMediaProgress->PubMsg
 //sendBoardData deleteBoardData-> PubMsg、DelMsg
 //setDrawable setPagePermission->GLOBAL.phone.drawPermission、GLOBAL.phone.pageTurningPermission
 
 
 */
@protocol TKEduClassRoomSessionDelegate <NSObject>

//自己进入课堂
- (void)eduClassRoomSessionManagerRoomJoined:(NSError *)error ;
//自己离开课堂
- (void)eduClassRoomSessionManagerRoomLeft ;
//自己被踢
-(void) eduClassRoomSessionManagerSelfEvicted;
//观看视频
- (void)eduClassRoomSessionManagerUserPublished:(RoomUser *)user ;
//取消视频
- (void)eduClassRoomSessionManagerUserUnpublished:(RoomUser *)user ;
//用户进入
- (void)eduClassRoomSessionManagerUserJoined:(RoomUser *)user InList:(BOOL)inList ;
//用户离开
- (void)eduClassRoomSessionManagerUserLeft:(RoomUser *)user ;
//用户信息变化 sGiftNumber sCandraw sRaisehand sPublishstate
- (void)eduClassRoomSessionManagerUserChanged:(RoomUser *)user Properties:(NSDictionary*)properties;
//聊天信息
- (void)eduClassRoomSessionManagerMessageReceived:(NSString *)message ofUser:(RoomUser *)user ;
//进入会议失败
- (void)eduClassRoomSessionManagerDidFailWithError:(NSError *)error ;
//白板等相关信令
- (void)eduClassRoomSessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data;



@end
@interface TKEduClassRoomSession : NSObject
@property (nonatomic, strong) RoomManager *roomMgr;

@property (nonatomic, weak) id<TKEduEnterClassRoomDelegate> iEduEnterClassRoomDelegate;
@property (nonatomic, weak) id<TKEduClassRoomSessionDelegate> iEduClassRoomSessionDelegate;
@property (nonatomic, strong, readonly) RoomUser *localUser;
@property (nonatomic, strong, readonly) NSSet *remoteUsers;
@property (nonatomic, assign, readonly) BOOL useFrontCamera;

@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, assign, readonly, getter=isJoined) BOOL joined;

@property (nonatomic, copy, readonly) NSString     *roomName;
@property (nonatomic, assign, readonly) int          roomType;
@property (nonatomic, copy, readonly) NSDictionary *roomProperties;
#pragma mark 自定义



//带白板
-(instancetype)initEduClassRoomSessionParamDic:(NSDictionary *)ParamDic aMeetingHandleDelegate:(id<TKEduEnterClassRoomDelegate>)delegate aRoomWhiteBoardDelegate:(id<RoomWhiteBoard>)aRoomWhiteBoardDelegate aEduClassRoomSessionDelegate:(id<TKEduClassRoomSessionDelegate>)aEduClassRoomSessionDelegate;

//不带白板
-(instancetype)initEduClassRoomSessionParamDic:(NSDictionary *)ParamDic aMeetingHandleDelegate:(id<TKEduEnterClassRoomDelegate>)delegate aEduClassRoomSessionDelegate:(id<TKEduClassRoomSessionDelegate>)aEduClassRoomSessionDelegate;

//进入会议
-(void)joinEduClassRoomForSessionWithHost:(NSString *)aHost aPort:(NSString *)aPort aNickName:(NSString *)aNickName aDomain:(NSString *)aDomain aRoomId:(NSString *)aRoomId aPassword:(NSString *)aPassword  aUserID:(NSString *)aUserID Properties:(NSDictionary*)properties;

//离开会议
- (void)sessionLeaveRoom:(void (^)(NSError *error))block;
//看视频
- (void)sessionPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error, NSObject *view))block;
//不看
- (void)sessionUnPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error))block;
//用户属性
- (void)sessionChangeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom Key:(NSString*)key Value:(NSObject*)value completion:(void (^)(NSError *error))block;
//发布音视频
- (void)sessionChangeUserPublish:(NSString*)peerID Publish:(int)publish completion:(void (^)(NSError *error))block;

- (void)sessionSendMessage:(NSString*)message completion:(void (^)(NSError *error))block;

- (void)sessionPubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block;

- (void)sessionDelMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data completion:(void (^)(NSError *error))block;

- (void)sessionEvictUser:(NSString*)peerID completion:(void (^)(NSError *error))block;


//WebRTC & Media

- (void)sessionSelectCameraPosition:(BOOL)isFront;

- (BOOL)sessionIsVideoEnabled;

- (void)sessionEnableVideo:(BOOL)enable;

- (BOOL)sessionIsAudioEnabled;

- (void)sessionEnableAudio:(BOOL)enable;
- (void)sessionUseLoudSpeaker:(BOOL)use;





@end

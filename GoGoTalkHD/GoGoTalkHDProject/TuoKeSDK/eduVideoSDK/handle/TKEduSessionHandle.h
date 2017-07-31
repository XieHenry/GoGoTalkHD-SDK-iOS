
//
//  TKEduSessionHandle.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKEduClassRoom.h"
#import "TKMacro.h"
#import "TKVideoPlayerHandle.h"
#import "TKEduBoardHandle.h"

@class TKChatMessageModel,TKEduRoomProperty,TKMediaDocModel,TKDocmentDocModel,RoomUser,RoomManager,TKDocumentListView;


#pragma mark 1 TKEduSessionDelegate
@protocol TKEduSessionDelegate <NSObject>
//自己进入课堂
- (void)sessionManagerRoomJoined:(NSError *)error ;
//自己离开课堂
- (void)sessionManagerRoomLeft ;
//自己被踢
-(void) sessionManagerSelfEvicted;
//观看视频
- (void)sessionManagerUserPublished:(RoomUser *)user ;
//取消视频
- (void)sessionManagerUserUnpublished:(RoomUser *)user ;
//用户进入
- (void)sessionManagerUserJoined:(RoomUser *)user InList:(BOOL)inList ;
//用户离开
- (void)sessionManagerUserLeft:(RoomUser *)user ;
//用户信息变化 sGiftNumber sCandraw sRaisehand sPublishstate
- (void)sessionManagerUserChanged:(RoomUser *)user Properties:(NSDictionary*)properties;
//聊天信息
- (void)sessionManagerMessageReceived:(NSString *)message ofUser:(RoomUser *)user ;
//进入会议失败
- (void)sessionManagerDidFailWithError:(NSError *)error ;
//白板等相关信令
- (void)sessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist;

@end

@protocol TKEduBoardDelegate <NSObject>
@optional

- (void)boardOnFileList:(NSArray*)fileList;
- (BOOL)boardOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data InList:(BOOL)inlist;
- (void)boardOnRemoteMsgList:(NSArray*)list;

@end

#pragma mark 2 TKEduSessionHandle

@interface TKEduSessionHandle : NSObject
@property (nonatomic, weak) id<TKEduRoomDelegate>    iRoomDelegate;
@property (nonatomic, weak) id<TKEduSessionDelegate> iSessionDelegate;
@property (nonatomic, weak) id<TKEduBoardDelegate>   iBoardDelegate;
@property (nonatomic, strong) RoomManager *roomMgr;
@property (nonatomic, strong, readonly) RoomUser *localUser;
@property (nonatomic, strong, readonly) NSSet *remoteUsers;
@property (nonatomic, assign, readonly) BOOL useFrontCamera;
@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, assign, readonly, getter=isJoined) BOOL joined;
@property (nonatomic, copy, readonly) NSString *roomName;
@property (nonatomic, assign, readonly) int      roomType;
@property (nonatomic, copy, readonly) NSDictionary *roomProperties;

#pragma mark 自定义
@property (nonatomic, strong) TKEduRoomProperty *iRoomProperties;
@property (nonatomic, strong) RoomUser *iTeacherUser;
@property (nonatomic, assign) BOOL isClassBegin;
@property (nonatomic, assign) BOOL isMuteAudio;
@property (nonatomic, assign) BOOL iIsCanOffertoDraw;//yes 可以 no 不可以
@property (nonatomic, assign) BOOL isHeadphones;//是否是耳机
@property (nonatomic, assign) BOOL iIsClassEnd;
#pragma mark 白板
@property (nonatomic,strong) TKMediaDocModel   *iCurrentMediaDocModel;
@property (nonatomic,strong) TKMediaDocModel   *iPreMediaDocModel;
@property (nonatomic,strong) TKDocmentDocModel *iCurrentDocmentModel;
@property (nonatomic,strong) TKDocmentDocModel *iPreDocmentModel;
@property(nonatomic,strong)  TKDocumentListView *iDocumentListView;
@property(nonatomic,strong)  TKDocumentListView *iMediaListView;
@property (nonatomic,strong) TKDocmentDocModel *iDefaultDocment;
@property (nonatomic,strong) NSMutableArray *iDocmentMutableArray;
@property (nonatomic,strong) NSMutableArray *iMediaMutableArray;
@property (nonatomic,strong) TKEduBoardHandle *iBoardHandle;
@property (nonatomic,strong) TKVideoPlayerHandle *iVideoPlayerHandle;
@property (nonatomic,assign)BOOL iIsPlay;

+(instancetype)shareInstance;

- (void)configureSession:(NSDictionary*)paramDic
            aRoomDelegate:(id<TKEduRoomDelegate>) aRoomDelegate
        aSessionDelegate:(id<TKEduSessionDelegate>) aSessionDelegate
          aBoardDelegate:(id<TKEduBoardDelegate>)aBoardDelegate
         aRoomProperties:(TKEduRoomProperty*)aRoomProperties;

-(void)joinEduClassRoomForWithHost:(NSString *)aHost aPort:(NSString *)aPort aNickName:(NSString *)aNickName aDomain:(NSString *)aDomain aRoomId:(NSString *)aRoomId aPassword:(NSString *)aPassword aUserID:(NSString *)aUserID Properties:(NSDictionary*)properties aUserType:(UserType)aUserType;


- (void)sessionHandleLeaveRoom:(void (^)(NSError *error))block;

-(void) sessionHandleLeaveRoom:(BOOL)force Completion:(void (^)(NSError *))block;

- (void)sessionHandlePlayVideo:(NSString*)peerID completion:(void (^)(NSError *error, NSObject *view))block;

- (void)sessionHandleUnPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error))block;

- (void)sessionHandleChangeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom Key:(NSString*)key Value:(NSObject*)value completion:(void (^)(NSError *error))block;

- (void)sessionHandleChangeUserPublish:(NSString*)peerID Publish:(int)publish completion:(void (^)(NSError *error))block;

- (void)sessionHandleSendMessage:(NSString*)message completion:(void (^)(NSError *error))block;

- (void)sessionHandlePubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block;

- (void)sessionHandleDelMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data completion:(void (^)(NSError *error))block;

- (void)sessionHandleEvictUser:(NSString*)peerID completion:(void (^)(NSError *error))block;


//WebRTC & Media

- (void)sessionHandleSelectCameraPosition:(BOOL)isFront;

- (BOOL)sessionHandleIsVideoEnabled;

- (void)sessionHandleEnableVideo:(BOOL)enable;

- (BOOL)sessionHandleIsAudioEnabled;

- (void)sessionHandleEnableAllAudio:(BOOL)enable;

- (void)sessionHandleEnableAudio:(BOOL)enable;

- (void)sessionHandleEnableOtherAudio:(BOOL)enable;

- (void)sessionHandleUseLoudSpeaker:(BOOL)use;

#pragma 其他
-(void)clearAllClassData;
- (NSArray *)messageList;
- (void)addOrReplaceMessage:(TKChatMessageModel *)aMessageModel;
- (NSSet *)userPlayAudioArray;
- (void)addOrReplaceUserPlayAudioArray:(RoomUser *)aRoomUser ;
- (void)delUserPlayAudioArray:(RoomUser *)aRoomUser ;
- (NSArray *)userListArray;
- (void)addOrReplaceUserArray:(RoomUser *)aRoomUser;
- (void)delUserArray:(RoomUser *)aRoomUser;
-(NSDictionary *)pendingButtonDic;
-(void)delePendingButton:(RoomUser*)aRoomUser;
-(bool)addPendingButton:(RoomUser *)aRoomUser;
#pragma mark 影音播放
-(void)publishtMediaDocModel:(TKMediaDocModel*)aMediaDocModel add:(BOOL)add To:(NSString *)to;
-(void)publishtProgressMediaDocModel:(TKMediaDocModel*)aMediaDocModel To:(NSString *)to isPlay:(BOOL)isPlay;
-(void)publishtPlayOrPauseMediaDocModel:(TKMediaDocModel*)aMediaDocModel To:(NSString *)to isPlay:(BOOL)isPlay;
-(void)publishtNeedProgressMediaDocModel:(TKMediaDocModel*)aMediaDocModel ;

-(void)deleteaMediaDocModel:(TKMediaDocModel*)aMediaDocModel To:(NSString *)to;
#pragma mark 文档
-(void)publishtDocMentDocModel:(TKDocmentDocModel*)tDocmentDocModel To:(NSString *)to;
//删除文档
-(void)deleteDocMentDocModel:(TKDocmentDocModel*)aDocmentDocModel To:(NSString *)to;

#pragma mark 白板
//文档
- (NSArray *)docmentArray;
- (bool)addOrReplaceDocmentArray:(TKDocmentDocModel *)aDocmentDocModel;
- (void)delDocmentArray:(TKDocmentDocModel *)aDocmentDocModel;
-(TKDocmentDocModel *)getNextDocment:(TKDocmentDocModel *)aCurrentDocmentModel;
//音视频
- (NSArray *)mediaArray;
- (void)addOrReplaceMediaArray:(TKMediaDocModel *)aMediaDocModel;
- (void)delMediaArray:(TKMediaDocModel *)aMediaDocModel;
-(TKMediaDocModel*)getNextMedia:(TKMediaDocModel *)aCurrentMediaDocModel;

-(void)docmentDefault:(TKDocmentDocModel*)aDefaultDocment;

#pragma mark 设置声道
-(void)configurePlayerRoute:(BOOL)aIsPlay;

@end

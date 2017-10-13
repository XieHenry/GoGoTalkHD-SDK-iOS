
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
#import "TKEduBoardHandle.h"

@class TKChatMessageModel,TKEduRoomProperty,TKMediaDocModel,TKDocmentDocModel,RoomUser,RoomManager,TKDocumentListView,TKProgressHUD;


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
//回放的聊天信息
- (void)sessionManagerPlaybackMessageReceived:(NSString *)message ofUser:(RoomUser *)user ts:(NSTimeInterval)ts;
//进入会议失败
- (void)sessionManagerDidFailWithError:(NSError *)error ;
//白板等相关信令
- (void)sessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist;

//获取礼物数
- (void)sessionManagerGetGiftNumber:(void(^)())completion;
#pragma mark media
//发布媒体流
- (void)sessionManagerMediaPublish:(MediaStream *)mediaStream roomUser:(RoomUser*)user ;
//取消媒体流
- (void)sessionManagerMediaUnPublish:(MediaStream *)mediaStream roomUser:(RoomUser*)user;
//媒体流进度
- (void)sessionManagerUpdateMediaStream:(MediaStream *)mediaStream pos:(NSTimeInterval)pos isPlay:(BOOL)isPlay;

#pragma mark Playback
- (void)sessionManagerReceivePlaybackDuration:(NSTimeInterval)duration;
- (void)sessionManagerPlaybackUpdateTime:(NSTimeInterval)time;
- (void)sessionManagerPlaybackClearAll;
- (void)sessionManagerPlaybackEnd;
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
@property (nonatomic, copy) NSDictionary *iParamDic;
@property (nonatomic,strong) NSMutableDictionary *iPublishDic;
#pragma mark 自定义
@property (nonatomic, strong) TKEduRoomProperty *iRoomProperties;
@property (nonatomic, strong) RoomUser *iTeacherUser;
@property (nonatomic, assign) BOOL isClassBegin;
@property (nonatomic, assign) BOOL isMuteAudio;
@property (nonatomic, assign) BOOL iIsCanOffertoDraw;//yes 可以 no 不可以
@property (nonatomic, assign) BOOL isHeadphones;//是否是耳机
@property (nonatomic, assign) BOOL iIsClassEnd;
@property (nonatomic, assign) BOOL iHasPublishStd;//是否有发布的学生
@property (nonatomic, assign) BOOL iStdOutBottom;//是否有拖出去的视频
@property (nonatomic, assign) BOOL iIsFullState;//是否全屏状态
#pragma mark 白板
@property (nonatomic,strong) TKMediaDocModel    *iCurrentMediaDocModel;
@property (nonatomic,strong) TKMediaDocModel    *iPreMediaDocModel;
@property (nonatomic,strong) TKDocmentDocModel  *iCurrentDocmentModel;
@property (nonatomic,strong) TKDocmentDocModel  *iPreDocmentModel;
@property(nonatomic,strong)  TKDocumentListView *iDocumentListView;
@property(nonatomic,strong)  TKDocumentListView *iMediaListView;
@property (nonatomic,strong) TKDocmentDocModel  *iDefaultDocment;
@property (nonatomic,strong) NSMutableArray     *iDocmentMutableArray;
@property (nonatomic,strong) NSMutableDictionary*iDocmentMutableDic;
@property (nonatomic,strong) NSMutableArray     *iMediaMutableArray;
@property (nonatomic,strong) NSMutableDictionary*iMediaMutableDic;
@property (nonatomic,strong) TKEduBoardHandle   *iBoardHandle;


@property (nonatomic,assign)BOOL iIsPlaying;//是否播放中
@property (nonatomic,assign)BOOL isPlayMedia;//是否有音频
@property (nonatomic,assign)BOOL isChangeMedia;//是否是切换
@property (nonatomic, assign) CGFloat iVolume;//音量 默认最大，耳机一半
@property (nonatomic,assign)BOOL isLocal;
@property (nonatomic,assign)BOOL isPlayback;  // 是否是回放
+(instancetype)shareInstance;

- (void)configureSession:(NSDictionary*)paramDic
            aRoomDelegate:(id<TKEduRoomDelegate>) aRoomDelegate
        aSessionDelegate:(id<TKEduSessionDelegate>) aSessionDelegate
          aBoardDelegate:(id<TKEduBoardDelegate>)aBoardDelegate
         aRoomProperties:(TKEduRoomProperty*)aRoomProperties;

// 回放进入接口
- (void)configurePlaybackSession:(NSDictionary*)paramDic
                   aRoomDelegate:(id<TKEduRoomDelegate>) aRoomDelegate
                aSessionDelegate:(id<TKEduSessionDelegate>) aSessionDelegate
                  aBoardDelegate:(id<TKEduBoardDelegate>)aBoardDelegate
                 aRoomProperties:(TKEduRoomProperty*)aRoomProperties;

-(void)joinEduClassRoomWithParam:(NSDictionary *)aParamDic aProperties:(NSDictionary *)aProperties;
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

-(void)publishVideoDragWithDic:(NSDictionary * )aVideoDic To:(NSString *)to;
//WebRTC & Media

- (void)sessionHandleSelectCameraPosition:(BOOL)isFront;

- (BOOL)sessionHandleIsVideoEnabled;

- (void)sessionHandleEnableVideo:(BOOL)enable;

- (BOOL)sessionHandleIsAudioEnabled;

- (void)sessionHandleEnableAllAudio:(BOOL)enable;

- (void)sessionHandleEnableAudio:(BOOL)enable;

- (void)sessionHandleEnableOtherAudio:(BOOL)enable;

- (void)sessionHandleUseLoudSpeaker:(BOOL)use;
#pragma mark media
//发布媒体流
- (void)sessionHandlePublishMedia:(NSString *)fileurl hasVideo:(BOOL)hasVideo fileid:(NSString *)fileid  filename:(NSString *)filename toID:(NSString*)toID block:(void (^)(NSError *))block;
//关闭媒体流
- (void)sessionHandleUnpublishMedia:(void (^)(NSError *))block;
//播放媒体流
- (void)sessionHandlePlayMedia:(NSString*)fileId completion:(void (^)(NSError *error, NSObject *view))block;
//媒体流暂停
-(void)sessionHandleMediaPause:(BOOL)pause;
//媒体流进度
-(void)sessionHandleMediaSeektoPos:(NSTimeInterval)pos;
//媒体流音量
-(void)sessionHandleMediaVolum:(CGFloat)volum;

#pragma 其他
-(void)clearAllClassData;
//message
- (NSArray *)messageList;
- (void)addOrReplaceMessage:(TKChatMessageModel *)aMessageModel;
//audio
- (NSSet *)userPlayAudioArray;
- (void)addOrReplaceUserPlayAudioArray:(RoomUser *)aRoomUser ;
- (void)delUserPlayAudioArray:(RoomUser *)aRoomUser ;
//user
- (NSArray *)userArray;
- (void)addUser:(RoomUser *)aRoomUser;
- (void)delUser:(RoomUser *)aRoomUser;
//user 老师和学生
- (NSArray *)userStdntAndTchrArray;
- (void)addUserStdntAndTchr:(RoomUser *)aRoomUser;
- (void)delUserStdntAndTchr:(RoomUser *)aRoomUser;
-(RoomUser *)userInUserList:(NSString*)peerId ;
//除了老师teacher和巡课Patrol
- (NSArray *)userListExpecPtrlAndTchr;
//特殊身份 助教等
-(void)addSecialUser:(RoomUser *)aRoomUser;
-(void)delSecialUser:(RoomUser*)aRoomUser;
-(NSDictionary *)secialUserDic;
//pending
-(NSDictionary *)pendingUserDic;
-(void)delePendingUser:(RoomUser*)aRoomUser;
-(bool)addPendingUser:(RoomUser *)aRoomUser;
//publish
-(void)addPublishUser:(RoomUser *)aRoomUser;
-(void)delePublishUser:(RoomUser*)aRoomUser;
-(NSDictionary *)publishUserDic;
//unpublish
-(void)addUnPublishUser:(RoomUser *)aRoomUser;
-(void)deleUnPublishUser:(RoomUser*)aRoomUser;
-(NSDictionary *)unpublishUserDic;
#pragma mark 影音
-(void)deleteaMediaDocModel:(TKMediaDocModel*)aMediaDocModel To:(NSString *)to;
#pragma mark 文档
-(void)publishtDocMentDocModel:(TKDocmentDocModel*)tDocmentDocModel To:(NSString *)to aTellLocal:(BOOL)aTellLocal;
//删除文档
-(void)deleteDocMentDocModel:(TKDocmentDocModel*)aDocmentDocModel To:(NSString *)to;

#pragma mark 白板
//文档
-(NSDictionary *)docmentDic;
-(TKDocmentDocModel*)getDocmentFromFiledId:(NSString *)aFiledId;

- (NSArray *)docmentArray;
- (bool)addOrReplaceDocmentArray:(TKDocmentDocModel *)aDocmentDocModel;
- (void)delDocmentArray:(TKDocmentDocModel *)aDocmentDocModel;
-(TKDocmentDocModel *)getNextDocment:(TKDocmentDocModel *)aCurrentDocmentModel;
//音视频
-(NSDictionary *)meidaDic;
-(TKMediaDocModel*)getMediaFromFiledId:(NSString *)aFiledId;
- (NSArray *)mediaArray;
- (void)addOrReplaceMediaArray:(TKMediaDocModel *)aMediaDocModel;
- (void)delMediaArray:(TKMediaDocModel *)aMediaDocModel;
-(TKMediaDocModel*)getNextMedia:(TKMediaDocModel *)aCurrentMediaDocModel;

-(void)docmentDefault:(TKDocmentDocModel*)aDefaultDocment;

-(BOOL)isEqualFileId:(id)aModel  aSecondModel:(id)aSecondModel;
#pragma mark 设置声道
-(void)configurePlayerRoute:(BOOL)aIsPlay isCancle:(BOOL)isCancle;

#pragma mark 用户自己打开关闭音视频
- (void)disableMyVideo:(BOOL)disable;
- (void)disableMyAudio:(BOOL)disable;
#pragma mark 设置HUD
-(void)configureHUD:(NSString *)aString  aIsShow:(BOOL)aIsShow;

#pragma mark 回放相关
- (void)playback;
- (void)pausePlayback;
- (void)seekPlayback:(NSTimeInterval)positionTime;
@end

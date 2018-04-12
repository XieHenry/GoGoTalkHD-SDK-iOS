//
//  RoomManager.h
//  ECILicode
//
//  Created by MAC-MiNi on 2017/7/29.
//  Copyright © 2017年 MAC-MiNi. All rights reserved.
//  Version: 2.1.0
//


#import <Foundation/Foundation.h>
#import "RoomUser.h"
#import "MediaStream.h"
@class RoomManager;

@protocol RoomManagerDelegate<NSObject>



/**
 成功连接
 
 @param completion 回调
 */
- (void)roomManagerConnected:(void(^)())completion;

/**
 成功进入房间
 
 @param error 错误信息
 */
- (void)roomManagerRoomJoined:(NSError *)error;

/**
 已经离开房间
 */
- (void)roomManagerRoomLeft;

/**
 自己被踢出房间
 
 @param reason 被踢原因
 */
- (void)roomManagerSelfEvicted:(NSDictionary *)reason;

/**
 有用户开始发布视频
 @param user 用户对象
 */
- (void)roomManagerUserPublished:(RoomUser *)user;

/**
 有用户停止发布视频
 @param user 用户对象
 */
- (void)roomManagerUserUnpublished:(RoomUser *)user;
/**
 有用户进入房间
 
 @param user 用户对象
 @param inList true：在自己之前进入；false：在自己之后进入
 */
- (void)roomManagerUserJoined:(RoomUser *)user InList:(BOOL)inList;

/**
 有用户离开房间
 
 @param user 用户对象
 */
- (void)roomManagerUserLeft:(RoomUser *)user;

/**
 有用户的属性发生了变化
 
 @param user 用户对象
 @param properties 发生变化的属性
 */
//- (void)roomManagerUserChanged:(RoomUser *)user Properties:(NSDictionary*)properties;

/**
 有用户的属性发生了变化
 
 @param user 用户对象
 @param properties 发生变化的属性
 @param fromId 修改用户属性消息的发送方的id
 */
- (void)roomManagerUserChanged:(RoomUser *)user Properties:(NSDictionary*)properties fromId:(NSString *)fromId;

/**
 收到聊天消息
 
 @param message 聊天消息内容
 @param user 发送者用户对象
 */
- (void)roomManagerMessageReceived:(NSString *)message ofUser:(RoomUser *)user;

/**
 回放时收到聊天消息
 
 @param message 聊天消息内容
 @param user 发送者用户对象
 @param ts 发送消息的时间戳
 */
- (void)roomManagerPlaybackMessageReceived:(NSString *)message ofUser:(RoomUser *)user ts:(NSTimeInterval)ts;

/**
 进入房间错误
 
 @param error 错误码，详见错误码定义
 */
- (void)roomManagerDidFailWithError:(NSError *)error;

/**
 在没有发布或订阅成功之前，发布3次失败或订阅3次失败通知上层有网路问题。
 */
- (void)roomManagerReportNetworkProblem;

/**
 网络环境发生变化，进行提示
 */
- (void)roomManagerReportNetworkChanged;

/**
 收到自定义信令消息
 
 @param add true：新增消息；false：删除消息
 @param msgID 消息id
 @param msgName 消息名字
 @param ts 消息时间戳
 @param data 消息数据，可以是Number、String、NSDictionary或NSArray
 @param inlist 是否是inlist中的信息
 */
- (void)roomManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist;

#pragma mark meidia

/**
 发布媒体流后的回调
 
 @param mediaStream 媒体流
 @param user 发布媒体流的用户
 */
- (void)roomManagerMediaPublish:(MediaStream *)mediaStream roomUser:(RoomUser*)user ;

/**
 取消媒体流后的回调
 
 @param mediaStream 媒体流
 @param user 发布媒体流的用户
 */
- (void)roomManagerMediaUnPublish:(MediaStream *)mediaStream roomUser:(RoomUser*)user;

/**
 更新媒体流的信息回调
 
 @param mediaStream 媒体流
 @param pos 媒体流当前的进度
 @param isPlay 播放（YES）暂停（NO）
 */
- (void)roomManagerUpdateMediaStream:(MediaStream *)mediaStream pos:(NSTimeInterval)pos isPlay:(BOOL)isPlay;

/**
 媒体流加载出画面回调
 */
- (void)roomManagerMediaLoaded;
#pragma mark screen

/**
 有用户发布桌面共享
 
 @param user 发布桌面共享的用户
 */
- (void)roomManagerScreenPublished:(RoomUser *)user;

/**
 用户取消桌面发布
 
 @param user 取消发布桌面共享的用户
 */
- (void)roomManagerScreenUnPublished:(RoomUser *)user;

#pragma mark file
/**
 有用户发布电影
 
 @param user 发布电影的用户
 */
- (void)roomManagerFilePublished:(RoomUser *)user;

/**
 用户取消电影
 
 @param user 取消发布电影的用户
 */
- (void)roomManagerFileUnPublished:(RoomUser *)user;

#pragma mark playback

/**
 获取到回放总时长的回调
 
 @param duration 回放的总时长
 */
- (void)roomManagerReceivePlaybackDuration:(NSTimeInterval)duration;

/**
 回放时接收到从服务器发来的回放进度变化
 
 @param time 变化的时间进度
 */
- (void)roomManagerPlaybackUpdateTime:(NSTimeInterval)time;

/**
 回放时清理
 */
- (void)roomManagerPlaybackClearAll;

/**
 回放播放完毕
 */
- (void)roomManagerPlaybackEnd;

@end

@protocol RoomWhiteBoard <NSObject>

/**
 文件列表回调
 
 @param fileList 文件列表 是一个NSArray类型的数据
 */
- (void)onFileList:(NSArray*)fileList;

/**
 收到自定义信令消息，与音视频相类似。
 
 @param add true：新增消息；false：删除消息
 @param msgID 消息id
 @param msgName 消息名字
 @param ts 消息时间戳
 @param data 消息数据，可以是Number、String、NSDictionary或NSArray
 @return YES ，代表白板处理 不用RoomManagerDelegate去处理了；  NO ，代表白板不处理，传给RoomManagerDelegate
 */
//- (BOOL)onRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data InList:(BOOL)inlist;

/**
 收到自定义信令消息，与音视频相类似。
 
 @param add true：新增消息；false：删除消息
 @param msgID 消息id
 @param msgName 消息名字
 @param ts 消息时间戳
 @param data 消息数据，可以是Number、String、NSDictionary或NSArray
 @param fromId 用户id
 @return YES ，代表白板处理 不用RoomManagerDelegate去处理了；  NO ，代表白板不处理，传给RoomManagerDelegate
 */
- (BOOL)onRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data InList:(BOOL)inlist fromID:(NSString*)fromId AssociatedMsgID:(NSString*)associatedMsgID;


/**
 白板接收到的所有信令
 
 @param add true：新增消息；false：删除消息
 @param params 消息
 */
- (void)onRemoteMsgList:(BOOL)add Params:(id)params;

//******************************************内容已弃用**************************************
/**
 白板接收到用户发布
 
 @param user 发布的用户
 */
- (void)onUserPublished:(RoomUser *)user;

/**
 白板接收到用户取消发布
 
 @param user 取消发布的用户
 */
- (void)onUserUnpublished:(RoomUser *)user;

/**
 白板接收到用户离开
 
 @param user 离开的用户
 */
- (void)onUserLeft:(RoomUser *)user;
//***************************************************************************************

//2017-11-10
/**
 课堂连接成功
 @param userList 用户列表
 @param msgList 消息列表
 @param myself 自己的用户信息
 @param roomProperties  课堂属性 内容为{roomtype:roomtype , companyid:companyid ,chairmancontrol:chairmancontrol , roomname:roomname , starttime:starttime , endtime:endtime ,serial:serial }
 */
- (void)onRoomConnectedUserlist:(NSArray *)userList MsgList:(NSArray*)msgList Myself:(RoomUser *)myself roomProperties:(NSDictionary *)roomProperties;
/**
 更改用户
 @param userid 用户id
 @param properties 服务端传递的属性
 @param fromID 谁发的信令
 */
- (void)onRoomUserpropertyChangedUserid:(NSString *)userid properties:(NSDictionary *)properties fromID:(NSString *)fromID;
/**
 白板接收到用户离开
 
 @param user 离开的用户
 */
- (void)onRoomParticipantLeave:(RoomUser *)user;
/**
 白板接收到用户加入
 
 @param user 加入的用户
 */
- (void)onRoomParticipantJoin:(RoomUser *)user;

@end



@interface RoomManager : NSObject

/**
 加入房间后获取的信息
 */
@property NSDictionary *roomMetadata;

/**
 实现了RoomManagerDelegate回调接口的对象
 */
@property (nonatomic, weak) id<RoomManagerDelegate> delegate;

/**
 实现了RoomWhiteBoard回调接口的白板对象
 */
@property (nonatomic, weak) id<RoomWhiteBoard> wb;


@property (nonatomic, strong) NSString *ClassDocServerAddr;
/**
 本地用户对象
 */
@property (nonatomic, strong, readonly) RoomUser *localUser;

/**
 所有用户的Set
 */
@property (nonatomic, strong, readonly) NSSet *remoteUsers;

/**
 是否用前置摄像头
 */
@property (nonatomic, assign, readonly) BOOL useFrontCamera;

/**
 是否连接
 */
@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;

/**
 是否进入
 */
@property (nonatomic, assign, readonly, getter=isJoined) BOOL joined;

/**
 房间名称
 */
@property (nonatomic, copy, readonly) NSString *roomName;

/**
 房间类型 0 - 小班 1-大班
 */
@property (nonatomic, assign, readonly) int roomType;

/**
 房间属性
 */
@property (nonatomic, copy, readonly) NSDictionary *roomProperties;

/**
 进入教室自动上课
 */
@property (nonatomic, assign, readonly) BOOL autoStartClassFlag;

/**
 上课前是否发布音视频
 */
@property (nonatomic, assign, readonly) BOOL beforeClassPubVideoFlag;

/**
 下课后不离开教室
 */
@property (nonatomic, assign, readonly) BOOL forbidLeaveClassFlag;

/**
 上课后自动开启音视频
 */
@property (nonatomic, assign, readonly) BOOL autoOpenAudioAndVideoFlag;

/**
 课堂到期自动退出
 */
@property (nonatomic, assign, readonly) BOOL autoQuitClassWhenClassOverFlag;

/**
 视频标注
 */
@property (nonatomic, assign, readonly) BOOL videoWhiteboardFlag;

/**
 文档分类
 */
@property (nonatomic, assign, readonly) BOOL documentCategoryFlag;

/**
 按下课时间结束课堂
 */
@property (nonatomic, assign, readonly) BOOL endClassTimeFlag;

/**
 公司ID
 */
@property (nonatomic, copy, readonly) NSString *companyId;

/**
 允许学生自己关闭音视频
 */
@property (nonatomic, assign, readonly) BOOL allowStudentCloseAV;

/**
 是否自动隐藏上下课按钮
 */
@property (nonatomic, assign, readonly) BOOL hideClassBeginEndButton;

/**
 助教是否可以上下台
 */
@property (nonatomic, assign, readonly) BOOL assistantCanPublish;

/**
 当前的流媒体
 */
@property (nonatomic, strong, readonly) MediaStream *currentMediaStream;

/**
 是否低消耗状态
 */
@property (nonatomic, assign, readonly) BOOL lowConsume;

/**
 是否在后台
 */
@property (nonatomic, assign) BOOL inBackground;

/**
 单例
 
 @return 单例
 */
+ (instancetype)instance;

+ (void)destory;
- (void)clear;
- (void)changeCurrentServer:(NSString *)serverName;

- (instancetype)configureWithDelegate:(id<RoomManagerDelegate>)delegate;

- (instancetype)configurePlaybackWithDelegate:(id<RoomManagerDelegate>)delegate
                                        AndWB:(id<RoomWhiteBoard>)wb;

- (instancetype)configureWithDelegate:(id<RoomManagerDelegate>)delegate
                                AndWB:(id<RoomWhiteBoard>)wb;

///**
// 初始化方法，如果不需要白板用此方法
//
// @param delegate 实现了RoomManagerDelegate回调接口的对象
// @return RoomManager实例方法
// */
//- (instancetype)initWithDelegate:(id<RoomManagerDelegate>)delegate;
//
///**
// 初始化方法，需要白板和音视频用此方法
//
// @param delegate 实现了RoomManagerDelegate回调接口的对象
// @param wb 实现了RoomWhiteBoard回调接口的白板对象
// @return RoomManager实例方法
// */
//- (instancetype)initWithDelegate:(id<RoomManagerDelegate>)delegate AndWB:(id<RoomWhiteBoard>)wb;
//
//
///**
// 进入回放教室的初始化方法，需要白板和音频用此方法
//
// @param delegate 实现了RoomManagerDelegate回调接口的对象
// @param wb 实现了RoomWhiteBoard回调接口的白板对象
// @return RoomManager实例方法
// */
//- (instancetype)initPlaybackWithDelegate:(id<RoomManagerDelegate>)delegate AndWB:(id<RoomWhiteBoard>)wb;


#pragma mark jion

/**
 进入房间
 
 @param host 服务器地址，通常是global.talk-cloud.net
 @param port 服务器https端口，通常是443
 @param nickname 本地用户的昵称
 @param params Dic格式，内含进入房间所需的基本参数，比如：NSDictionary类型，键值需要传递serial（房间号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）,uiserid(用户ID，可选),type（房间类型，需要去管理系统查看回放链接，截取type参数）, path (录制件地址，需要去管理系统查看回放链接，截取path参数)
 @param properties  Dic格式，内含进入房间时用户的初始化的信息。比如 giftNumber（礼物数）
 @param lowConsume  BOOL格式 是否低功率模式
 */
- (void)joinRoomWithHost:(NSString *)host Port:(int)port NickName:(NSString*)nickname Params:(NSDictionary*)params Properties:(NSDictionary*)properties lowConsume:(BOOL)lowConsume;
/**
 进入回放房间
 
 @param host 服务器地址，通常是global.talk-cloud.com
 @param port 服务器https端口，通常是443
 @param nickname 本地用户的昵称
 @param params Dic格式，内含进入房间所需的基本参数，比如：NSDictionary类型，键值需要传递serial（房间号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）,uiserid(用户ID，可选),type（房间类型，需要去管理系统查看回放链接，截取type参数）, path (录制件地址，需要去管理系统查看回放链接，截取path参数)
 @param properties  Dic格式，内含进入房间时用户的初始化的信息。比如 giftNumber（礼物数）
 @param lowConsume  BOOL格式 是否低功率模式
 */
- (void)joinPlaybackRoomWithHost:(NSString *)host Port:(int)port NickName:(NSString*)nickname Params:(NSDictionary*)params Properties:(NSDictionary*)properties lowConsume:(BOOL)lowConsume;
/**
 进入房间
 
 @param host 服务器地址，通常是global.talk-cloud.net
 @param port 服务器https端口，通常是443
 @param nickname 本地用户的昵称
 @param params Dic格式，内含进入房间所需的基本参数，比如：NSDictionary类型，键值需要传递serial（房间号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）,uiserid(用户ID，可选),type（房间类型，需要去管理系统查看回放链接，截取type参数）, path (录制件地址，需要去管理系统查看回放链接，截取path参数)
 @param properties  Dic格式，内含进入房间时用户的初始化的信息。比如 giftNumber（礼物数）
 */
- (void)joinRoomWithHost:(NSString *)host Port:(int)port NickName:(NSString*)nickname Params:(NSDictionary*)params Properties:(NSDictionary*)properties;

/**
 进入回放房间
 
 @param host 服务器地址，通常是global.talk-cloud.com
 @param port 服务器https端口，通常是443
 @param nickname 本地用户的昵称
 @param params Dic格式，内含进入房间所需的基本参数，比如：NSDictionary类型，键值需要传递serial（房间号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）,uiserid(用户ID，可选),type（房间类型，需要去管理系统查看回放链接，截取type参数）, path (录制件地址，需要去管理系统查看回放链接，截取path参数)
 @param properties  Dic格式，内含进入房间时用户的初始化的信息。比如 giftNumber（礼物数）
 */
- (void)joinPlaybackRoomWithHost:(NSString *)host
                            Port:(int)port
                        NickName:(NSString*)nickname
                          Params:(NSDictionary*)params
                      Properties:(NSDictionary*)properties;

/**
 离开房间
 
 @param block 离开房间后的回调
 */
- (void)leaveRoom:(void (^)(NSError *error))block;


/**
 强行离开房间
 
 @param force YES:强行退出 NO:不强行退出
 @param block 离开房间后的回调
 */
- (void)leaveRoom:(BOOL)force Completion:(void (^)(NSError *))block;

/**
 对同一个用户，可以调用多次此函数。当传入的view和上次传入的一致时，函数不执行任何操作，直接返回成功；当传入的view和上次传入的不一致时，换用新的view播放该用户的视频
 
 @param peerID 用户Peerid
 @param block 设置用于播放视频的view的block
 */
- (void)playVideo:(NSString*)peerID completion:(void (^)(NSError *error, NSObject *view))block;

/**
 停止播放某个用户的视频
 
 @param peerID 用户Peerid
 @param block 取消播放某个视频后的block
 */
- (void)unPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error))block;


/**
 修改某个用户的一个属性
 
 @param peerID 要修改的用户ID
 @param tellWhom 要将此修改通知给谁。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param key 要修改的用户属性名字，可以是您自定义的名字
 @param value 要修改的用户属性，可以是Number、String、NSDictionary或NSArray
 @param block 完成的回调
 */
- (void)changeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom Key:(NSString*)key Value:(NSObject*)value completion:(void (^)(NSError *error))block;

/**
 修改某个用户的音视频发布状态
 
 @param peerID 该用户的peerID，可以是自己的，也可以是其他人的
 @param publish 0：不发布；1：只发布音频；2：只发布视频；3：发布音视
 @param block 完成的回调
 */
- (void)changeUserPublish:(NSString*)peerID Publish:(int)publish completion:(void (^)(NSError *error))block;

/**
 发送聊天消息
 
 @param message 聊天内容
 @param block 完成的回调
 */
- (void)sendMessage:(NSString*)message completion:(void (^)(NSError *error))block;

/**
 发布自定义消息
 
 @param msgName 消息名字
 @param msgID ：消息id
 @param toID 要通知给哪些用户。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param data 消息数据，可以是Number、String、NSDictionary或NSArray
 @param save ：是否保存，详见3.5：自定义信令
 @param block 完成的回调
 */
- (void)pubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block;
//expires ：这个消息，多长时间结束，以秒为单位，是相对时间。一般用于classbegin，给定一个相对时间
- (void)pubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save AssociatedMsgID:(NSString*)associatedMsgID AssociatedUserID:(NSString*)associatedUserID
       expires:(NSTimeInterval)expires
    completion:(void (^)(NSError *error))block;
//expendData:拓展数据，与msgName同级
- (void)pubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save expendData:(NSDictionary*)expendData completion:(void (^)(NSError *error))block;

/**
 删除自定义消息
 @param msgName 消息名字
 @param msgID ：消息id
 @param toID 要通知给哪些用户。“__all”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param data 消息数据，可以是Number、String、NSDictionary或NSArray
 @param block 完成的回调
 */
- (void)delMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data completion:(void (^)(NSError *error))block;

/**
 将一个用户踢出房间
 
 @param peerID 该用户的id
 @param block 完成的回调
 */
- (void)evictUser:(NSString*)peerID completion:(void (^)(NSError *error))block;


//WebRTC & Media

/**
 切换本地摄像头
 
 @param isFront  true：使用前置摄像头；false：使用后置摄像头
 */
- (void)selectCameraPosition:(BOOL)isFront;

/**
 当前本地摄像头是否被启用
 
 @return true：摄像头可用；false：摄像头被禁用
 */
- (BOOL)isVideoEnabled;

/**
 设置启用/禁用摄像头
 
 @param enable ：true：启用摄像头；false：禁用摄像头
 */
- (void)enableVideo:(BOOL)enable;

/**
 当前本地麦克风是否被启用
 
 @return ：true：麦克风可用；false：麦克风被静音
 */
- (BOOL)isAudioEnabled;

/**
 自己音频的开启关闭
 
 @param enable YES:开启 NO:关闭
 */
- (void)enableAudio:(BOOL)enable;

/**
 其他人音频的开启关闭
 
 @param enable YES:开启 NO:关闭
 */
- (void)enableOtherAudio:(BOOL)enable;

/**
 是否外放
 
 @param use YES:外放 NO:关闭
 */
- (void)useLoudSpeaker:(BOOL)use;

/**
 禁用本地音频
 
 @param disable 是否禁用
 */
- (void)disableMyAudio:(BOOL)disable;

/**
 禁用本地视频
 
 @param disable 是否禁用
 */
- (void)disableMyVideo:(BOOL)disable;

/**
 发布媒体流
 static  NSString *const sTellAll             = @"__all";
 static  NSString *const sTellNone            = @"__none";
 static  NSString *const sTellAllExpectSender = @"__allExceptSender";
 @param fileurl 文件的url
 @param hasVideo YES:视频 NO:音频
 @param fileid 媒体的文件id
 @param filename  媒体的文件名称
 @param toID 发布媒体流给谁 @"__all":所有人 @"__none":谁都不发 @"__allExceptSender":除了自己 其他：某个特用户
 @param pauseWhenOver  流媒体播放完毕后是否自动暂停，不移除流。
 @param block  发布媒体流后的回调
 */
-(void)publishMedia:(NSString *)fileurl hasVideo:(BOOL)hasVideo fileid:(NSString *)fileid filename:(NSString *)filename toID:(NSString*)toID block:(void (^)(NSError *))block;

/**
 发布媒体流给所有人
 static  NSString *const sTellAll             = @"__all";
 static  NSString *const sTellNone            = @"__none";
 static  NSString *const sTellAllExpectSender = @"__allExceptSender";
 @param fileurl 文件的url
 @param hasVideo YES:视频 NO:音频
 @param fileid 文件id
 @param filename 文件名称
 @param block  发布媒体流后的回调
 */
-(void)publishMedia:(NSString *)fileurl hasVideo:(BOOL)hasVideo fileid:(NSString *)fileid  filename:(NSString *)filename  block:(void (^)(NSError *))block;

/**
 播放媒体流
 
 @param fileId 播放媒体的文件id
 @param block 播放后的回调
 */
-(void)playMedia:(NSString*)fileId completion:(void (^)(NSError *error, NSObject *view))block;
/**
 取消媒体流
 
 @param block  取消媒体流后的回调
 */
-(void)unpublishMedia:(void (^)(NSError *))block;

/**
 暂停媒体流
 
 @param pause 暂停
 */
-(void)mediaPause:(BOOL)pause;

/**
 设置进度
 
 @param pos 媒体流的位置
 */
-(void)mediaSeektoPos:(NSTimeInterval)pos;

/**
 设置声音
 
 @param volum 音量 1-10
 */
-(void)mediaVolum:(double)volum;

/**
 回放拖动播放滑块
 
 @param positionTime 回放的时间
 */
- (void)seekPlayback:(NSTimeInterval)positionTime;

/**
 停止回放
 */
- (void)pausePlayback;

/**
 开始回放
 */
- (void)playback;

/**
 播放桌面共享
 
 @param peerID 共享桌面的用户id
 @param block 播放共享桌面后的回调
 */
- (void)playScreen:(NSString *)peerID completion:(void (^)(NSError *, NSObject *))block;


/**
 关闭共享桌面
 
 @param peerID 共享桌面的用户id
 @param block 关闭共享桌面的回调
 */
- (void)unPlayScreen:(NSString *)peerID completion:(void (^)(NSError *error))block;

/**
 播放电影
 
 @param peerID 共享桌面的用户id
 @param block 播放共享桌面后的回调
 */
- (void)playFile:(NSString *)peerID completion:(void (^)(NSError *, NSObject *))block;


/**
 关闭电影
 
 @param peerID 共享桌面的用户id
 @param block 关闭共享桌面的回调
 */
- (void)unPlayFile:(NSString *)peerID completion:(void (^)(NSError *error))block;

/**
 录制用户的视频流
 
 @param peerId 用户id
 @param convert 0 不转换, 1 webm, 2 mp4
 @param completion 回调block，第一个参数为0时，表示成功，非0表示失败；第二个参数为视频路径。
 */
- (void)startRecordUser:(NSString *)peerId convert:(NSInteger)convert completion:(void (^)(NSInteger ret, NSString *path))completion;


/**
 结束用户的视频流录制
 
 @param peerId 用户id
 @param completion 回调block，参数为0，表示成功；非0表示失败。
 */
- (void)stopRecordUser:(NSString *)peerId completion:(void (^)(NSInteger))completion;

- (int)startPlayingAudioFile:(NSString *)fileName loop:(BOOL)loop fileFormat:(int)format;
- (void)stopPlayingAudioFile:(int)channel;
@end


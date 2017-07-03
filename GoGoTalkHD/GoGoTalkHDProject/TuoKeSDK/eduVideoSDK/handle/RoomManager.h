// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#import <Foundation/Foundation.h>
#import "RoomUser.h"

@class RoomManager;

// Provides information about connected streams, errors and final disconnections.
@protocol RoomManagerDelegate<NSObject>

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
 */
- (void)roomManagerSelfEvicted;

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
- (void)roomManagerUserChanged:(RoomUser *)user Properties:(NSDictionary*)properties;

/**
 收到聊天消息

 @param message 聊天消息内容
 @param user 发送者用户对象
 */
- (void)roomManagerMessageReceived:(NSString *)message ofUser:(RoomUser *)user;

/**
 进入房间错误

 @param error 错误码，详见错误码定义
 */
- (void)roomManagerDidFailWithError:(NSError *)error;

/**
  收到自定义信令消息

 @param add true：新增消息；false：删除消息
 @param msgID 消息id
 @param msgName 消息名字
 @param ts 消息时间戳
 @param data 消息数据，可以是Number、String、NSDictionary或NSArray
 */
- (void)roomManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data;

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
- (BOOL)onRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data;

/**
 白板接收到的所有信令

 @param list 信令数组
 */
- (void)onRemoteMsgList:(NSArray*)list;

@end


@interface RoomManager : NSObject

/**
 实现了RoomManagerDelegate回调接口的对象
 */
@property (nonatomic, weak) id<RoomManagerDelegate> delegate;

/**
 实现了RoomWhiteBoard回调接口的白板对象
 */
@property (nonatomic, weak) id<RoomWhiteBoard> wb;

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
 初始化方法，如果不需要白板用此方法

 @param delegate 实现了RoomManagerDelegate回调接口的对象
 @return RoomManager实例方法
 */
- (instancetype)initWithDelegate:(id<RoomManagerDelegate>)delegate;

/**
  初始化方法，需要白板和音视频用此方法

 @param delegate 实现了RoomManagerDelegate回调接口的对象
 @param wb 实现了RoomWhiteBoard回调接口的白板对象
 @return RoomManager实例方法
 */
- (instancetype)initWithDelegate:(id<RoomManagerDelegate>)delegate AndWB:(id<RoomWhiteBoard>)wb;

/**
 进入房间

 @param host 服务器地址，通常是global.talk-cloud.com
 @param port 服务器https端口，通常是443
 @param nickname 本地用户的昵称
 @param params Dic格式，内含进入房间所需的基本参数，比如：NSDictionary类型，键值需要传递serial（房间号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）,uiserid(用户ID，可选)
 @param properties  Dic格式，内含进入房间时用户的初始化的信息。比如 giftNumber（礼物数）
 */
- (void)joinRoomWithHost:(NSString *)host Port:(int)port NickName:(NSString*)nickname Params:(NSDictionary*)params Properties:(NSDictionary*)properties;

/**
 离开房间

 @param block 离开房间后的回调
 */
- (void)leaveRoom:(void (^)(NSError *error))block;

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
 @param tellWhom 要将此修改通知给谁。“__All”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
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
 @param toID 要通知给哪些用户。“__All”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
 @param data 消息数据，可以是Number、String、NSDictionary或NSArray
 @param save ：是否保存，详见3.5：自定义信令
 @param block 完成的回调
 */
- (void)pubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block;

/**
 删除自定义消息
 @param msgName 消息名字
 @param msgID ：消息id
 @param toID 要通知给哪些用户。“__All”：所有人；“__allExceptSender”：除自己以外的所有人；“__allExceptAuditor”：除旁听用户以外的所有人；“__None”：不通知任何人；某用户的peerID：只发给该用户
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
 设置启用/禁用麦克风

 @param enable ：true：启用麦克风；false：禁用麦克风
 */
- (void)enableAudio:(BOOL)enable;
/**
 设置外放
 
 @param use YES：外放 NO：听筒
 */
-(void)useLoudSpeaker:(BOOL)use;
@end

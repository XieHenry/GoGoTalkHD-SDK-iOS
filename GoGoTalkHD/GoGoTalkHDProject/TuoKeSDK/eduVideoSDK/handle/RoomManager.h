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

- (void)roomManagerRoomJoined:(NSError *)error;

- (void)roomManagerRoomLeft;

- (void)roomManagerSelfEvicted;

- (void)roomManagerUserPublished:(RoomUser *)user;

- (void)roomManagerUserUnpublished:(RoomUser *)user;

- (void)roomManagerUserJoined:(RoomUser *)user InList:(BOOL)inList;

- (void)roomManagerUserLeft:(RoomUser *)user;

- (void)roomManagerUserChanged:(RoomUser *)user Properties:(NSDictionary*)properties;

- (void)roomManagerMessageReceived:(NSString *)message ofUser:(RoomUser *)user;

- (void)roomManagerDidFailWithError:(NSError *)error;

- (void)roomManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist;

@end

@protocol RoomWhiteBoard <NSObject>

- (void)onFileList:(NSArray*)fileList;

- (BOOL)onRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data InList:(BOOL)inlist;

- (void)onRemoteMsgList:(NSArray*)list;

@end


@interface RoomManager : NSObject

@property (nonatomic, weak) id<RoomManagerDelegate> delegate;
@property (nonatomic, weak) id<RoomWhiteBoard> wb;
@property (nonatomic, strong, readonly) RoomUser *localUser;
@property (nonatomic, strong, readonly) NSSet *remoteUsers;
@property (nonatomic, assign, readonly) BOOL useFrontCamera;

@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, assign, readonly, getter=isJoined) BOOL joined;

@property (nonatomic, copy, readonly) NSString *roomName;
@property (nonatomic, assign, readonly) int roomType;
@property (nonatomic, copy, readonly) NSDictionary *roomProperties;


- (instancetype)initWithDelegate:(id<RoomManagerDelegate>)delegate;

- (instancetype)initWithDelegate:(id<RoomManagerDelegate>)delegate AndWB:(id<RoomWhiteBoard>)wb;

- (void)joinRoomWithHost:(NSString *)host Port:(int)port NickName:(NSString*)nickname Params:(NSDictionary*)params Properties:(NSDictionary*)properties;

- (void)leaveRoom:(void (^)(NSError *error))block;

- (void)leaveRoom:(BOOL)force Completion:(void (^)(NSError *))block;

- (void)playVideo:(NSString*)peerID completion:(void (^)(NSError *error, NSObject *view))block;

- (void)unPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error))block;

- (void)changeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom Key:(NSString*)key Value:(NSObject*)value completion:(void (^)(NSError *error))block;

- (void)changeUserPublish:(NSString*)peerID Publish:(int)publish completion:(void (^)(NSError *error))block;

- (void)sendMessage:(NSString*)message completion:(void (^)(NSError *error))block;

- (void)pubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block;

- (void)delMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data completion:(void (^)(NSError *error))block;

- (void)evictUser:(NSString*)peerID completion:(void (^)(NSError *error))block;


//WebRTC & Media

- (void)selectCameraPosition:(BOOL)isFront;

- (BOOL)isVideoEnabled;

- (void)enableVideo:(BOOL)enable;

- (BOOL)isAudioEnabled;

- (void)enableAudio:(BOOL)enable;

- (void)enableOtherAudio:(BOOL)enable;

- (void)useLoudSpeaker:(BOOL)use;
@end


//
//  TKEduClassRoomSessionHandle.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKEduClassRoomSession.h"
@class TKChatMessageModel;
@interface TKEduClassRoomSessionHandle : NSObject


@property(nonatomic,retain)TKEduClassRoomSession *session;
@property (nonatomic, strong, readonly) RoomUser *localUser;

@property (nonatomic, strong, readonly) NSSet *remoteUsers;
@property (nonatomic, assign, readonly) BOOL useFrontCamera;

@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, assign, readonly, getter=isJoined) BOOL joined;
@property (nonatomic, copy, readonly) NSString *roomName;
@property (nonatomic, assign, readonly) int      roomType;
@property (nonatomic, copy, readonly) NSDictionary *roomProperties;


@property (nonatomic, strong, readonly) RoomUser *iTeacherUser;

- (id)initWithMeetingWithParamDic:(NSDictionary*)paramDic
     aTKEduEnterClassRoomDelegate:(id<TKEduEnterClassRoomDelegate>)   aTKEduEnterClassRoomDelegate
   aTKEduClassRoomSessionDelegate:(id<TKEduClassRoomSessionDelegate>) aTKEduClassRoomSessionDelegate
          aRoomWhiteBoardDelegate:(id<RoomWhiteBoard>)aRoomWhiteBoardDelegate;

-(void)joinEduClassRoomForWithHost:(NSString *)aHost aPort:(NSString *)aPort aNickName:(NSString *)aNickName aDomain:(NSString *)aDomain aRoomId:(NSString *)aRoomId aPassword:(NSString *)aPassword aUserID:(NSString *)aUserID Properties:(NSDictionary*)properties;


- (void)sessionHandleLeaveRoom:(void (^)(NSError *error))block;



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

- (void)sessionHandleEnableAudio:(BOOL)enable;

- (void)sessionHandleUseLoudSpeaker:(BOOL)use;
-(void)clearAllClassData;
#pragma 其他
- (NSArray *)messageList;
- (void)addOrReplaceMessage:(TKChatMessageModel *)aMessageModel ;
//- (NSDictionary *)userDicAll;
-(NSDictionary*)userDicStudent;
//- (void)addOrReplaceUserPlayVideoDic:(RoomUser *)aRoomUser ;
//
//- (void)delUserForAll:(RoomUser *)aRoomUser ;

//- (NSArray *)userArrayAll;
- (NSArray *)userArrayStudentExpectMe;
- (NSArray *)userArrayStudent;
- (NSArray *)userArrayMeAndTearcher;
- (NSArray *)userPlayVideoArray;
- (void)addOrReplaceUserPlayVideoArray:(RoomUser *)aRoomUser ;
- (void)delUserPlayVideoArray:(RoomUser *)aRoomUser ;


- (NSArray *)userListArray;
- (void)addOrReplaceUserArray:(RoomUser *)aRoomUser ;
- (void)delUserArray:(RoomUser *)aRoomUser ;


@end

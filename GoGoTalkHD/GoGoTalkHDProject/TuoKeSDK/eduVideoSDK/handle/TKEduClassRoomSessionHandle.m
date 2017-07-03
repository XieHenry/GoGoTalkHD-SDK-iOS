//
//  TKEduClassRoomSessionHandle.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduClassRoomSessionHandle.h"
#import "TKMacro.h"
#import "TKDocmentDocModel.h"
#import "TKChatMessageModel.h"
@interface TKEduClassRoomSessionHandle ()
@property (nonatomic,strong) NSMutableArray *iMessageList;
@property (nonatomic,strong) NSMutableArray *iUserList;
@property (nonatomic,strong) NSMutableArray *iDocmentList;
@property (nonatomic,strong) NSMutableArray *iVideoAndAudioList;
//@property (nonatomic,strong) NSMutableDictionary *iUserDicAll;
//@property (nonatomic,strong) NSMutableArray *iUserArrayAll;
@property (nonatomic,strong) NSMutableArray *iUserPlayVideoArray;
@property (nonatomic,strong) NSMutableArray *iUserArrayStudentExpectMe;
@property (nonatomic,strong) NSMutableArray *iUserArrayStudent;
@property (nonatomic,strong) NSMutableArray *iUserArrayMeAndTeacher;
@property (nonatomic,strong) NSMutableDictionary *iUserDicStudentExpectMe;

@end

@implementation TKEduClassRoomSessionHandle

-(instancetype )shareTKEduClassRoomSessionHandleInstance{
    
    static TKEduClassRoomSessionHandle *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      singleton = [[TKEduClassRoomSessionHandle alloc] init];
                  });
    
    return singleton;
}


- (instancetype)initWithMeetingWithParamDic:(NSDictionary*)paramDic
           aTKEduEnterClassRoomDelegate:(id<TKEduEnterClassRoomDelegate>) aTKEduEnterClassRoomDelegate
 aTKEduClassRoomSessionDelegate:(id<TKEduClassRoomSessionDelegate>) aTKEduClassRoomSessionDelegate
         aRoomWhiteBoardDelegate:(id<RoomWhiteBoard>)aRoomWhiteBoardDelegate
{
    if (self = [self init]) {
        //        _videoIDForSip = -1;
        //        _sipUser = nil;
#if TARGET_OS_IPHONE
        _session = [[TKEduClassRoomSession alloc]initEduClassRoomSessionParamDic:paramDic aMeetingHandleDelegate:aTKEduEnterClassRoomDelegate aRoomWhiteBoardDelegate:aRoomWhiteBoardDelegate aEduClassRoomSessionDelegate:aTKEduClassRoomSessionDelegate];
//        _iEduClassRoomSessionDelegate = aTKEduClassRoomSessionDelegate;
        

#endif
        _iMessageList                = [[NSMutableArray alloc] init];
        _iUserList                   = [[NSMutableArray alloc] init];
        _iUserArrayStudentExpectMe   = [[NSMutableArray alloc]init];
        _iUserArrayStudent           = [[NSMutableArray alloc]init];
        _iUserArrayMeAndTeacher      = [[NSMutableArray alloc]init];
        _iUserPlayVideoArray         = [[NSMutableArray alloc]init];
        _iUserDicStudentExpectMe     = [[NSMutableDictionary alloc]init];
      

    }
    return self;
}


-(void)joinEduClassRoomForWithHost:(NSString *)aHost aPort:(NSString *)aPort aNickName:(NSString *)aNickName aDomain:(NSString *)aDomain aRoomId:(NSString *)aRoomId aPassword:(NSString *)aPassword aUserID:(NSString *)aUserID Properties:(NSDictionary*)properties{
    if (_session) {
        
        [_session joinEduClassRoomForSessionWithHost:aHost aPort:aPort aNickName:aNickName aDomain:aDomain aRoomId:aRoomId aPassword:aPassword aUserID:aUserID Properties:properties];
        
    }
}


- (void)sessionHandleLeaveRoom:(void (^)(NSError *error))block {
   
    return [_session sessionLeaveRoom:block];
}


//看视频
- (void)sessionHandlePlayVideo:(NSString*)peerID completion:(void (^)(NSError *error, NSObject *view))block{
    return [_session sessionPlayVideo:peerID completion:block];
}
//不看
- (void)sessionHandleUnPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error))block{
    return [_session sessionUnPlayVideo:peerID completion:block];
}
//状态变化
- (void)sessionHandleChangeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom Key:(NSString*)key Value:(NSObject*)value completion:(void (^)(NSError *error))block{
    
    return [_session sessionChangeUserProperty:peerID TellWhom:tellWhom Key:key Value:value completion:block];
    
}
//
- (void)sessionHandleChangeUserPublish:(NSString*)peerID Publish:(int)publish completion:(void (^)(NSError *error))block{
    return [_session sessionChangeUserPublish:peerID Publish:publish completion:block];
    
}

- (void)sessionHandleSendMessage:(NSString*)message completion:(void (^)(NSError *error))block{
    return [_session sessionSendMessage:message completion:block];
}

- (void)sessionHandlePubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block{
    return [_session sessionPubMsg:msgName ID:msgID To:toID Data:data Save:save completion:block];
}

- (void)sessionHandleDelMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data completion:(void (^)(NSError *error))block{
    return [_session sessionDelMsg:msgName ID:msgID To:toID Data:data completion:block];
}

- (void)sessionHandleEvictUser:(NSString*)peerID completion:(void (^)(NSError *error))block{
    return [_session sessionEvictUser:peerID completion:block];
}


//WebRTC & Media

- (void)sessionHandleSelectCameraPosition:(BOOL)isFront{
    return [_session sessionSelectCameraPosition:isFront];
}

- (BOOL)sessionHandleIsVideoEnabled{
    return [_session sessionIsVideoEnabled];
}

- (void)sessionHandleEnableVideo:(BOOL)enable{
    return [_session sessionEnableVideo:enable];
}

- (BOOL)sessionHandleIsAudioEnabled{
    return [_session sessionIsAudioEnabled];
}

- (void)sessionHandleEnableAudio:(BOOL)enable{
    return [_session sessionEnableAudio:enable];
}
-(void)sessionHandleUseLoudSpeaker:(BOOL)use{
    return [_session sessionUseLoudSpeaker:use];
}

- (NSArray *)messageList {
    return [_iMessageList copy];
}
- (void)addOrReplaceMessage:(TKChatMessageModel *)aMessageModel {
    NSArray *tArray  = [_iMessageList copy];
    
    BOOL tIsHave = NO;
    NSInteger tIndex = 0;
    for (TKChatMessageModel *tCHatMessageModel in tArray) {
        if ([tCHatMessageModel.iMessage isEqualToString:aMessageModel.iMessage]) {
            tIsHave = YES;
            [_iMessageList replaceObjectAtIndex:tIndex withObject:aMessageModel];
            
        }
        tIndex ++;
    }
    if (!tIsHave) {
         [_iMessageList addObject:aMessageModel];
    }
   

}


#pragma mark 视频

- (NSArray *)userListArray{
     return [_iUserList copy];
}
- (void)addOrReplaceUserArray:(RoomUser *)aRoomUser {
    NSArray *tArray  = [_iUserList copy];
    
    BOOL tIsHave                              = NO;
    NSInteger tRoomUserIndex = 0;
    for (RoomUser *tRoomUser in tArray) {
        
        if ([tRoomUser.peerID isEqualToString:aRoomUser.peerID]) {
            
            tIsHave = YES;
            break;
            
        }
        tRoomUserIndex++;
        
    }
    if (!tIsHave) {
        
        if (aRoomUser.role == UserType_Teacher) {
            _iTeacherUser = aRoomUser;
            [_iUserList insertObject:aRoomUser atIndex:0];
        }else{
            [_iUserList addObject:aRoomUser];
        }
        
    }else{
        
        [_iUserList replaceObjectAtIndex:tRoomUserIndex withObject:aRoomUser];
        
    }
}
- (void)delUserArray:(RoomUser *)aRoomUser {
    //删除所有
    NSArray *tArrayAll = [_iUserList copy];
    NSInteger tRoomUserIndex = 0;
    for (RoomUser *tRoomUser in tArrayAll) {
        
        if ([tRoomUser.peerID isEqualToString:aRoomUser.peerID]) {
            [_iUserList removeObjectAtIndex:tRoomUserIndex];
            break;
        }
        tRoomUserIndex ++;
        
    }

}
- (NSArray *)userArrayStudentExpectMe{
    
    return [_iUserArrayStudentExpectMe copy];
}
- (NSArray *)userArrayStudent{
    
    
    return [_iUserArrayStudent copy];
    
}
- (NSArray *)userArrayMeAndTearcher{
    
    
    return [_iUserArrayMeAndTeacher copy];
    
}
- (NSArray *)userPlayVideoArray{
    
    
    return [_iUserPlayVideoArray copy];
    
}
- (void)addOrReplaceUserPlayVideoArray:(RoomUser *)aRoomUser {
     TKLog(@"---------add:%@",aRoomUser.nickName);
    NSArray *tArray  = [_iUserPlayVideoArray copy];
  
    BOOL tIsHave                              = NO;
    BOOL tIsHaveTeacher                      = NO;
    for (RoomUser *tRoomUser in tArray) {
        
        if ([tRoomUser.peerID isEqualToString:aRoomUser.peerID]) {
            tIsHave = YES;
          
        }
        if (tRoomUser.role == UserType_Teacher) {
            tIsHaveTeacher = YES;
        }
       
    }
    if (!tIsHave) {
        
        if (aRoomUser.role == UserType_Student && ![aRoomUser.peerID isEqualToString:self.localUser.peerID]) {
            
            [_iUserArrayStudentExpectMe addObject:aRoomUser];
            [_iUserDicStudentExpectMe setObject:aRoomUser forKey:aRoomUser.peerID];
            
        }
        if (aRoomUser.role == UserType_Student){
            if ([aRoomUser.peerID isEqualToString:self.localUser.peerID]) {
                if (tIsHaveTeacher) {
                     [_iUserPlayVideoArray insertObject:aRoomUser atIndex:1];
                }else{
                     [_iUserPlayVideoArray insertObject:aRoomUser atIndex:0];
                }
                 [_iUserArrayMeAndTeacher addObject:aRoomUser];
                 [_iUserArrayStudent insertObject:aRoomUser atIndex:0];
                
            }else{
                 [_iUserArrayStudent addObject:aRoomUser];
                 [_iUserPlayVideoArray addObject:aRoomUser];
            }
            
        }
        if (aRoomUser.role == UserType_Teacher) {
            _iTeacherUser = aRoomUser;
            [_iUserArrayMeAndTeacher insertObject:aRoomUser atIndex:0];
            [_iUserPlayVideoArray insertObject:aRoomUser atIndex:0];
        }
      
    }

  
    
    
    
}
- (void)delUserPlayVideoArray:(RoomUser *)aRoomUser {
    
    TKLog(@"---------del:%@",aRoomUser.nickName);
    
    //删除所有
    NSArray *tArrayAll = [_iUserPlayVideoArray copy];
    NSInteger tRoomUserIndex = 0;
    for (RoomUser *tRoomUser in tArrayAll) {
        
        if ([tRoomUser.peerID isEqualToString:aRoomUser.peerID]) {
            [_iUserPlayVideoArray removeObjectAtIndex:tRoomUserIndex];
            break;
        }
        tRoomUserIndex ++;
        
    }
    
    //删除部分
    NSArray *tUserArrayStudentExpectMe = [_iUserArrayStudentExpectMe copy];
    NSInteger tRoomUserStudentExpectMeIndex = 0;
    for (RoomUser *tRoomUser in tUserArrayStudentExpectMe) {
        
        if ([tRoomUser.peerID isEqualToString:aRoomUser.peerID]) {
            [_iUserArrayStudentExpectMe removeObjectAtIndex:tRoomUserStudentExpectMeIndex];
            [_iUserDicStudentExpectMe removeObjectForKey:aRoomUser.peerID];
            break;
        }
        tRoomUserStudentExpectMeIndex ++;
        
    }
    //删除包含自己的部分
    NSArray *tUserArrayStudent = [_iUserArrayStudent copy];
    NSInteger tRoomUserStudentIndex = 0;
    for (RoomUser *tRoomUser in tUserArrayStudent) {
        
        if ([tRoomUser.peerID isEqualToString:aRoomUser.peerID]) {
            [_iUserArrayStudent removeObjectAtIndex:tRoomUserStudentIndex];
            break;
        }
        tRoomUserStudentIndex ++;
        
    }
    //删除包含自己的部分
    NSArray *tUserArrayMeAndTeacher      = [_iUserArrayMeAndTeacher copy];
    NSInteger tRoomUserMeAndTeacherIndex = 0;
    for (RoomUser *tRoomUser in tUserArrayMeAndTeacher) {
        
        if ([tRoomUser.peerID isEqualToString:aRoomUser.peerID]) {
            [_iUserArrayMeAndTeacher removeObjectAtIndex:tRoomUserMeAndTeacherIndex];
            break;
        }
        tRoomUserMeAndTeacherIndex ++;
        
    }
   
    
}
//- (NSDictionary *)userDicAll{
//    
//     return [_iUserDicAll copy];
//}
-(NSDictionary*)userDicStudent{
    return [_iUserDicStudentExpectMe copy];
    
}
//- (void)addOrReplaceUserPlayVideoDic:(RoomUser *)aRoomUser {
//    
//    [_iUserDicAll setObject:aRoomUser forKey:aRoomUser.peerID];
//    if (aRoomUser.role == UserType_Student && ![aRoomUser.peerID isEqualToString:self.localUser.peerID]) {
//        
//         [_iUserDicStudentExpectMe setObject:aRoomUser forKey:aRoomUser.peerID];
//    }
//    if (aRoomUser.role == UserType_Teacher) {
//        _iTeacherUser = aRoomUser;
//    }
//    
//    
//}
//- (void)delUserForAll:(RoomUser *)aRoomUser {
//    [_iUserDicAll removeObjectForKey:aRoomUser.peerID];
//    
//    if (aRoomUser.role == UserType_Student && ![aRoomUser.peerID isEqualToString:self.localUser.peerID]) {
//        [_iUserDicStudentExpectMe removeObjectForKey:aRoomUser.peerID];
//    }
//   
//    
//}

-(void)clearAllClassData{
     //修复重连时，会有问题！
    [_iMessageList removeAllObjects];
    [_iUserList removeAllObjects];
   // [_iUserDicAll removeAllObjects];
//    [_iUserArrayAll removeAllObjects];
    [_iUserArrayStudentExpectMe removeAllObjects];
    [_iUserArrayStudent removeAllObjects];
    [_iUserDicStudentExpectMe removeAllObjects];
    [_iUserPlayVideoArray removeAllObjects];
  
}

#pragma mark set and get

-(RoomUser*)localUser{
    return [_session localUser];
}
-(NSSet *)remoteUsers{
    return [_session remoteUsers];
}

-(BOOL)useFrontCamera{
    return [_session useFrontCamera];
}

-(BOOL)isConnected{
    return [_session isConnected];
}
-(BOOL)isJoined{
    return [_session isJoined];
}
-(NSString *)roomName{
    return [_session roomName];
}

-(int)roomType{
    return [_session roomType];
}
-(NSDictionary *)roomProperties{
    return [_session roomProperties];
}




@end

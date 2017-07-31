//
//  TKEduSessionHandle.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduSessionHandle.h"
#import "TKMacro.h"
#import "TKDocmentDocModel.h"
#import "TKMediaDocModel.h"
#import "TKChatMessageModel.h"
#import "TKEduRoomProperty.h"
#import "TKEduBoardHandle.h"
#import "TKUtil.h"
#import "RoomUser.h"
#import "TKDocumentListView.h"

@import AVFoundation;
@interface RoomManager(test)
- (void)setTestServer:(NSString*)ip Port:(NSString*)port;
@end
@interface TKEduSessionHandle ()<RoomManagerDelegate,RoomWhiteBoard>

@property (nonatomic,strong) NSMutableArray *iMessageList;
@property (nonatomic,strong) NSMutableArray *iUserList;
@property (nonatomic,strong) NSMutableSet   *iUserPlayAudioArray;
@property (nonatomic,strong) NSMutableDictionary *iPendingButtonDic;
@property (strong, nonatomic)  UISlider *iAudioslider2;
@end

@implementation TKEduSessionHandle

+(instancetype )shareInstance{
    
    static TKEduSessionHandle *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      singleton = [[TKEduSessionHandle alloc] init];
                  });
    
    return singleton;
}
-(void)initClassRoomManager{
    _roomMgr = [[RoomManager alloc] initWithDelegate:self];
}
-(void)initClassRoomManager:(id<RoomWhiteBoard>)aRoomWhiteBoardDelegate{
    _roomMgr = [[RoomManager alloc] initWithDelegate:self AndWB:aRoomWhiteBoardDelegate];
}

- (void)configureSession:(NSDictionary*)paramDic
           aRoomDelegate:(id<TKEduRoomDelegate>) aRoomDelegate
        aSessionDelegate:(id<TKEduSessionDelegate>) aSessionDelegate
          aBoardDelegate:(id<TKEduBoardDelegate>)aBoardDelegate
         aRoomProperties:(TKEduRoomProperty*)aRoomProperties
{

#if TARGET_OS_IPHONE
    _iRoomDelegate     = aRoomDelegate;
    _iSessionDelegate  = aSessionDelegate;
    _iBoardDelegate    = aBoardDelegate;
    aBoardDelegate ?[self initClassRoomManager:self] : [self initClassRoomManager];

#endif
    _iBoardHandle                = [[TKEduBoardHandle alloc]init];
    _iMessageList                = [[NSMutableArray alloc] init];
    _iUserList                   = [[NSMutableArray alloc] init];
    _iUserPlayAudioArray         = [[NSMutableSet alloc] init];
    _iRoomProperties             = aRoomProperties;
    _iPendingButtonDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iDocmentMutableArray =[[NSMutableArray alloc] init];
    _iMediaMutableArray = [[NSMutableArray alloc]init];
    _iVideoPlayerHandle = [[TKVideoPlayerHandle alloc]init];
    _iIsPlay = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}


-(void)joinEduClassRoomForWithHost:(NSString *)aHost aPort:(NSString *)aPort aNickName:(NSString *)aNickName aDomain:(NSString *)aDomain aRoomId:(NSString *)aRoomId aPassword:(NSString *)aPassword aUserID:(NSString *)aUserID Properties:(NSDictionary*)properties aUserType:(UserType)aUserType{
    if (_roomMgr) {
        
#ifdef Debug
        //192.168.1.24
        [_roomMgr setTestServer:@"192.168.1.36" Port:@"8443"];
#endif
        
        
        if (!aDomain || [aDomain isEqualToString:@""]) {
            aDomain = @"www";
        }
        TKLog(@"%@",aDomain);
        if (!aRoomId || [aRoomId isEqualToString:@""]) {
            aRoomId = @"449542978";
        }
        if (!aHost || [aHost isEqualToString:@""]) {
            aHost = @"192.168.0.66";
        }
        if (!aPort || [aPort isEqualToString:@""]) {
            aPort = @"443";
        }
        if (!aUserID || [aUserID isEqualToString:@""]) {
            aUserID = @"0";
        }
        
        NSDictionary *tParams = @{
                                  @"serial":aRoomId,
                                  @"userid":aUserID,
                                  @"userrole":@(aUserType)
                                  };
        
        if (aPassword && ![aPassword isEqualToString:@""]) {
            tParams = @{
                        @"serial":aRoomId?aRoomId:@"",
                        @"password":aPassword?aPassword:@"",
                        @"userid":aUserID,
                        @"userrole":@(aUserType)
                        };
        }
        
        
        //摄像头
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (authStatus == AVAuthorizationStatusRestricted|| authStatus == AVAuthorizationStatusDenied) {
            // 获取摄像头失败
            [self callCameroError];
            
        }else if(authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusAuthorized){
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    // 获取摄像头成功
                    
                } else {
                    
                    // 获取摄像头失败
                    [self callCameroError];
                }
            }];
            
        }else{
            // 获取摄像头成功
            
        }
        
        // + (void)requestAccessForMediaType:(NSString *)mediaType completionHandler:(void (^)(BOOL granted))handler NS_AVAILABLE_IOS(7_0)
        
        AVAuthorizationStatus authAudioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        
        if (authAudioStatus == AVAuthorizationStatusRestricted|| authAudioStatus == AVAuthorizationStatusDenied) {
            
            // 获取摄像头失败
            [self callCameroError];
            
        }else if(authAudioStatus == AVAuthorizationStatusNotDetermined || authAudioStatus == AVAuthorizationStatusAuthorized){
            
            
            //麦克风
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    // 获取摄像头成功
                    [_roomMgr joinRoomWithHost:aHost Port:(int)[aPort integerValue] NickName:aNickName Params:tParams Properties:properties];
                } else {
                    
                    // 获取摄像头失败
                    [self callCameroError];
                }
                
            }];
            
        }
        
    }
}

#pragma mark session方法
- (void)sessionHandleLeaveRoom:(void (^)(NSError *error))block {
   
    return [_roomMgr leaveRoom:block];
}
-(void)sessionHandleLeaveRoom:(BOOL)force Completion:(void (^)(NSError *))block{
    return[_roomMgr leaveRoom:force Completion:block];
}

//看视频
- (void)sessionHandlePlayVideo:(NSString*)peerID completion:(void (^)(NSError *error, NSObject *view))block{
     return [_roomMgr playVideo:peerID completion:block];
}
//不看
- (void)sessionHandleUnPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error))block{
    return [_roomMgr unPlayVideo:peerID completion:block];
}
//状态变化
- (void)sessionHandleChangeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom Key:(NSString*)key Value:(NSObject*)value completion:(void (^)(NSError *error))block{
    
    return [_roomMgr changeUserProperty:peerID TellWhom:tellWhom Key:key Value:value completion:block];
    
}
//
- (void)sessionHandleChangeUserPublish:(NSString*)peerID Publish:(int)publish completion:(void (^)(NSError *error))block{
     return [_roomMgr changeUserPublish:peerID Publish:publish completion:block];
    
}

- (void)sessionHandleSendMessage:(NSString*)message completion:(void (^)(NSError *error))block{
     return [_roomMgr sendMessage:message completion:block];
}

- (void)sessionHandlePubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block{
   return [_roomMgr pubMsg:msgName ID:msgID To:toID Data:data Save:save completion:block];
}

- (void)sessionHandleDelMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data completion:(void (^)(NSError *error))block{
    return [_roomMgr delMsg:msgName ID:msgID To:toID Data:data completion:block];
}

- (void)sessionHandleEvictUser:(NSString*)peerID completion:(void (^)(NSError *error))block{
    return [_roomMgr evictUser:peerID completion:block];
}


//WebRTC & Media

- (void)sessionHandleSelectCameraPosition:(BOOL)isFront{
     return [_roomMgr selectCameraPosition:isFront];
}

- (BOOL)sessionHandleIsVideoEnabled{
    return [_roomMgr isVideoEnabled];
}

- (void)sessionHandleEnableVideo:(BOOL)enable{
     return [_roomMgr enableVideo:enable];
}

- (BOOL)sessionHandleIsAudioEnabled{
   return [_roomMgr isAudioEnabled];
}
- (void)sessionHandleEnableAllAudio:(BOOL)enable{
    
    [_roomMgr enableOtherAudio:enable];
    [self sessionHandleEnableAudio:enable];
}
- (void)sessionHandleEnableAudio:(BOOL)enable{
     return [_roomMgr enableAudio:enable];
}
- (void)sessionHandleEnableOtherAudio:(BOOL)enable{
     [_roomMgr enableOtherAudio:enable];
}

-(void)sessionHandleUseLoudSpeaker:(BOOL)use{
    return [self sessionUseLoudSpeaker:use];
}
-(void)sessionUseLoudSpeaker:(BOOL)use{
    if (_isHeadphones) {
        return;
    }
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    BOOL success;
    
    NSError* error;
    
  //  [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionAllowBluetooth  error:&error];
    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    [session overrideOutputAudioPort:use?AVAudioSessionPortOverrideSpeaker:AVAudioSessionPortOverrideNone error:&error];
    //[_session sessionUseLoudSpeaker:use];
}
#pragma mark room manager delegate
//1自己进入课堂
- (void)roomManagerRoomJoined:(NSError *)error {
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerRoomJoined:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerRoomJoined:error];
        
    }
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(joinRoomComplete)]) {
        [(id<TKEduRoomDelegate>)_iRoomDelegate  joinRoomComplete];
        
    }
    TKLog(@"jin roomManagerRoomJoined %@", error);
    
}
//2自己离开课堂
- (void)roomManagerRoomLeft {
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerRoomLeft)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerRoomLeft];
        
    }
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(leftRoomComplete)]) {
        [(id<TKEduRoomDelegate>)_iRoomDelegate  leftRoomComplete];
        
    }
     TKLog(@"jin roomManagerRoomLeft");
}
// 被踢
- (void)roomManagerSelfEvicted{
    //classbegin
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerSelfEvicted)]) {
       
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerSelfEvicted];
        
    }
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onKitout:)]) {
        
        [(id<TKEduRoomDelegate>)_iRoomDelegate onKitout:EKickOutReason_Repeat];
        
    }
     TKLog(@"jin roomManagerSelfEvicted");
    
}
//3观看视频
- (void)roomManagerUserPublished:(RoomUser *)user {
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerUserPublished:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerUserPublished:user];
        
    }
     TKLog(@"jin roomManagerUserPublished");
}
//4取消视频
- (void)roomManagerUserUnpublished:(RoomUser *)user {
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerUserUnpublished:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerUserUnpublished:user];
        
    }
     TKLog(@"jin roomManagerUserUnpublished");
}

//5用户进入
- (void)roomManagerUserJoined:(RoomUser *)user InList:(BOOL)inList {
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerUserJoined:InList:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerUserJoined:user InList:inList];
        
    }
     TKLog(@"jin roomManagerUserJoined");
}

//6用户离开
- (void)roomManagerUserLeft:(RoomUser *)user {
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerUserLeft:)]) {
        
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerUserLeft:user];
        
    }
     TKLog(@"jin roomManagerUserLeft");
}
//7用户信息变化
- (void)roomManagerUserChanged:(RoomUser *)user Properties:(NSDictionary*)properties{
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerUserChanged:Properties:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerUserChanged:user Properties:properties];
        
    }
      TKLog(@"jin roomManagerUserChanged");
}

//8聊天信息
- (void)roomManagerMessageReceived:(NSString *)message ofUser:(RoomUser *)user {
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerMessageReceived:ofUser:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerMessageReceived:message ofUser:user];
        
    }
    
    
}

//9进入会议失败
- (void)roomManagerDidFailWithError:(NSError *)error {
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerDidFailWithError:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerDidFailWithError:error];
        
    }
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onEnterRoomFailed:Description:)]) {
        
        [(id<TKEduRoomDelegate>)_iRoomDelegate onEnterRoomFailed:(int)error.code Description:error.description];
        
        
    }
    TKLog(@"jin roomManagerDidFailWithError %@", error);
}
//10白板等相关信令
- (void)roomManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    //classbegin
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerOnRemoteMsg:ID:Name:TS:Data:InList:)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerOnRemoteMsg:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
    }
    //会议开始或者结束
    if ([msgName isEqualToString:sClassBegin]) {
        if (add) {
            
            if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onClassBegin)]) {
                
                [(id<TKEduRoomDelegate>)_iRoomDelegate onClassBegin];
                
            }
        }else{
            
            if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onClassDismiss)]) {
                [(id<TKEduRoomDelegate>)_iRoomDelegate onClassDismiss];
                
            }
        }
        
        
    }
     TKLog(@"jin roomManagerOnRemoteMsg");
    
    
}

#pragma mark roomWhiteBoard Delegate
- (void)onFileList:(NSArray*)fileList{
  
    TKLog(@"jin onFileList");
    NSDictionary *tDic = @{
                           @"active" :@(1),
                           @"downloadpath":@"",
                           @"dynamicppt" :@(0),
                           @"fileid" :@"0",
                           @"filename":@"白板",
                           @"filepath":@"",
                           @"fileserverid":@(0),
                           @"filetype" :@"",
                           @"isconvert" :@(1),
                           @"newfilename":@"白板",
                           @"pagenum" :@(1),
                           @"pdfpath":@"",
                           @"swfpath" :@"",
                           @"currpage":@(1)
                           };
    
    NSMutableArray *tMutableFileList = [NSMutableArray arrayWithArray:fileList];
    [tMutableFileList insertObject:tDic atIndex:0];
    
    if (_iBoardDelegate && [_iBoardDelegate respondsToSelector:@selector(boardOnFileList:)]) {
        [_iBoardDelegate boardOnFileList:tMutableFileList];
        
    }
    int i = 0;
    
    for (NSDictionary *tFileDic in tMutableFileList) {
        //如果是媒体文档，则跳过
        if ([TKUtil getIsMedia:[tFileDic objectForKey:@"filetype"]]) {
            TKMediaDocModel *tMediaDocModel = [[TKMediaDocModel alloc]init];
            [tMediaDocModel setValuesForKeysWithDictionary:tFileDic];
            
            tMediaDocModel.isPlay = @(NO);
            [self addOrReplaceMediaArray:tMediaDocModel];
            
        }else{
            
            TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc]init];
            [tDocmentDocModel setValuesForKeysWithDictionary:tFileDic];
            [tDocmentDocModel dynamicpptUpdate];
            [self addOrReplaceDocmentArray:tDocmentDocModel];
            if ([tDocmentDocModel.dynamicppt integerValue]==1) {
                continue;
            }
            if (i == 1 || i==0) {
                _iDefaultDocment = tDocmentDocModel;
                _iCurrentDocmentModel= _iDefaultDocment;
            }
            i++;
        }
        
    }
    
}
- (void)onRemoteMsgList:(NSArray*)list{
    TKLog(@"jin onRemoteMsgList");
    NSMutableDictionary *tParamDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL tIsHavePageList = NO;
    BOOL tIsCanPage      = NO;
    for (NSDictionary *tParamDictemp in list) {
        NSString *tID = [tParamDictemp objectForKey:@"id"];
        [tParamDic setObject:tParamDictemp forKey:tID];
        
        if ([[tParamDictemp objectForKey:@"name"] isEqualToString:sShowPage]) {
            tIsHavePageList = YES;
        }
        if ([[tParamDictemp objectForKey:@"name"] isEqualToString:sClassBegin]) {
            tIsCanPage = YES;
        }
        
    }
    NSData *tJsonData = [NSJSONSerialization dataWithJSONObject:tParamDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *tJsonString = [[NSString alloc]initWithData:tJsonData encoding:NSUTF8StringEncoding];
    NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"GLOBAL.phone.receivePhoneByTriggerEvent('message-list-received', %@)",tJsonString];
    [_iBoardHandle.iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
        NSLog(@"----GLOBAL.phone.receivePhoneByTriggerEvent");
    }];
    if (!tIsHavePageList) {
        
        [self docmentDefault:_iDefaultDocment];
        
    }else{
        
        NSData *tJsonData = [NSJSONSerialization dataWithJSONObject:tParamDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *tJsonString = [[NSString alloc]initWithData:tJsonData encoding:NSUTF8StringEncoding];
        NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"GLOBAL.phone.receivePhoneByTriggerEvent('message-list-received', %@)",tJsonString];
        [_iBoardHandle.iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
            NSLog(@"----GLOBAL.phone.receivePhoneByTriggerEvent");
        }];
    }
    if (!tIsCanPage) {
        [_iBoardHandle setPagePermission:true];
    }
    
    if (_iBoardDelegate && [_iBoardDelegate respondsToSelector:@selector(boardOnRemoteMsgList:)]) {
        [_iBoardDelegate boardOnRemoteMsgList:list];
        
    }
    
    
}


//YES ，代表白板处理 不传给会议；  NO ，代表白板不处理，传给会议
- (BOOL)onRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    TKLog(@"jin onRemoteMsg");
    BOOL tIsWhiteBoardDealWith = false;
    NSDictionary *tDataDic = @{};
    bool tIsStudent =  [TKEduSessionHandle shareInstance].localUser.role == UserType_Student;
    //TKLog(@"-----%@", [NSString stringWithFormat:@"msgName:%@,msgID:%@",msgName,msgID]);
    if ([data isKindOfClass:[NSString class]]) {
        NSString *tDataString = [NSString stringWithFormat:@"%@",data];
        NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
        tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        tDataDic = (NSDictionary *)data;
    }
    
  
    if ([msgName isEqualToString:sDocumentChange] && ![TKEduSessionHandle shareInstance].isClassBegin)
    {
        
        BOOL tIsDelete = [[tDataDic objectForKey:@"isdel"]boolValue];
        if (tIsDelete && [tDataDic objectForKey:@"isdel"]) {
            bool tIsMedia = [tDataDic objectForKey:@"isMedia"];
            if (tIsMedia) {
                
                TKMediaDocModel *tMediaDocModel = [[TKMediaDocModel alloc]init];
                [tMediaDocModel setValuesForKeysWithDictionary:tDataDic];
                if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student) {
                    [self delMediaArray:tMediaDocModel];
                }
            }else{
                TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc]init];
                [tDocmentDocModel setValuesForKeysWithDictionary:tDataDic];
                
                if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student) {
                    
                    [self delDocmentArray:tDocmentDocModel];
                    if (![TKEduSessionHandle shareInstance].isClassBegin) {
                        [self docmentDefault:[self docmentArray].firstObject];
                    }
                    
                }
            }
            
            
            
        }else{
            //bool tIsMedia = [tDocumentChangeDic objectForKey:@"isMedia"];
            
        }
        
    }
    
    
    if([msgName isEqualToString:sWBPageCount]|| [msgName isEqualToString:sShowPage] ||[msgName isEqualToString:sSharpsChange] )
    {
        
        if ([msgID isEqualToString:sDocumentFilePage_ShowPage]) {
            
            NSDictionary *tFileData = [tDataDic objectForKey:@"filedata"];
            NSNumber *tAynamicPPT = [tDataDic objectForKey:@"aynamicPPT"];
            
           
            TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc]init];
            [tDocmentDocModel setValuesForKeysWithDictionary:tFileData];
            tDocmentDocModel.dynamicppt =tAynamicPPT;
            
            [tDocmentDocModel dynamicpptUpdate];
            [self addOrReplaceDocmentArray:tDocmentDocModel];
            _iCurrentDocmentModel = tDocmentDocModel;
            
        }
        //showPage 子信令
        //学生
        if (([msgID isEqualToString:sVideo_MediaFilePage_ShowPage] || [msgID isEqualToString:sAudio_MediaFilePage_ShowPage])&&(tIsStudent )) {
            NSString *tTypeString = [msgID isEqualToString:sVideo_MediaFilePage_ShowPage]?@"video":@"audio";
            TKMediaDocModel *tMediaDocModel = [[TKMediaDocModel alloc]init];
            NSDictionary *tDic = [tDataDic objectForKey:@"filedata"];
            [tMediaDocModel setValuesForKeysWithDictionary:tDic];
            
            //add ? [self addDocmentDic:tMediaDocModel] :[self delDocmentDic:tMediaDocModel];
            add ? [self addOrReplaceMediaArray:tMediaDocModel] :[self delMediaArray:tMediaDocModel];
            add ? (_iCurrentMediaDocModel = tMediaDocModel) : (_iPreMediaDocModel=tMediaDocModel);
#ifdef Debug
            //NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",@"http",_iEduClassRoomProperty.sWebIp,@"80",_iCurrentMediaDocModel.swfpath];
            NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",@"http",_iRoomProperties.sWebIp,@"80",_iCurrentMediaDocModel.swfpath];
#else
            NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",sHttp,_iRoomProperties.sWebIp,_iRoomProperties.sWebPort,_iCurrentMediaDocModel.swfpath];
#endif
            [_iVideoPlayerHandle playerInitialize:tUrl aMediaDocModel:_iCurrentMediaDocModel withView:_iBoardHandle.iRootView aType:tTypeString add:add aRoomUser:self.localUser];
            
        }
        //老师
        if (([msgID isEqualToString:sVideo_MediaFilePage_ShowPage] || [msgID isEqualToString:sAudio_MediaFilePage_ShowPage])&&( [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher )){
            TKMediaDocModel *tMediaDocModel = [[TKMediaDocModel alloc]init];
            NSDictionary *tDic = [tDataDic objectForKey:@"filedata"];
            [tMediaDocModel setValuesForKeysWithDictionary:tDic];
            add ? [self addOrReplaceMediaArray:tMediaDocModel] :[self delMediaArray:tMediaDocModel];
            add ? (_iCurrentMediaDocModel = tMediaDocModel)    : (_iPreMediaDocModel=tMediaDocModel);
            
            [_iMediaListView  prepareVideoOrAudio:_iCurrentMediaDocModel SendToOther:NO];
            TKLog(@"-----%@", [NSString stringWithFormat:@"msgName:%@,msgID:%@ add:%@\n",msgName,msgID,@(add)]);
            
        }
        
        tIsWhiteBoardDealWith = true;
    }
    if ([msgName isEqualToString:sMediaProgress]){
        if (!_iCurrentMediaDocModel) {
            return  NO;
        }
        //  NSDictionary *tDataDic = (NSDictionary *)data;
        MediaProgressAction action = (MediaProgressAction)[[tDataDic objectForKey:@"action"] longValue];
        NSString * mediaType = [tDataDic objectForKey:@"mediaType"];
        NSNumber * tCurrentTime = [tDataDic objectForKey:@"currentTime"];
        /*
         {
         action = 1;
         currentTime = 0;
         fileid = 4638;
         mediaType = video;
         }
         msgID:MediaProgress_video_1
         msgName:MediaProgress
         
         */
        switch (action) {
                //告诉别人进度
            case MediaProgressAction_OtherNeedProgress:
            {
                NSString *tSendParticipantId = [tDataDic objectForKey:@"sendParticipantId"];
                NSNumber* fileid = _iCurrentMediaDocModel.fileid;
                
                NSDictionary *tMediaDate = @{
                                             @"action":@(MediaProgressAction_ChangeProgress),
                                             @"mediaType":mediaType?mediaType:@"",
                                             @"fileid":fileid?fileid:@(0),
                                             @"currentTime":_iCurrentMediaDocModel.currentTime?_iCurrentMediaDocModel.currentTime:@(0),
                                             
                                             };
                TKLog(@"-----%@", [NSString stringWithFormat:@"msgName:%@,msgID:%@ add:%@,action:MediaProgressAction_OtherNeedProgress\n",msgName,msgID,@(add)]);
                !add?:[self sessionHandlePubMsg:sMediaProgress ID:sMediaProgress_video_1 To:tSendParticipantId Data:tMediaDate Save:false completion:nil];
                
                break;
            }
                //暂停或者play
            case MediaProgressAction_PlayOrPause:
                //进度变化
            case MediaProgressAction_ChangeProgress:
            {
                if (tCurrentTime) {
                    TKLog(@"-----%@", [NSString stringWithFormat:@"msgName:%@, msgID:%@ play:%@,action:%@,currentTime:%@",msgName,msgID,([tDataDic objectForKey:@"play"]),action==MediaProgressAction_PlayOrPause?@"MediaProgressAction_PlayOrPause":@"MediaProgressAction_ChangeProgress\n",tCurrentTime ]);
                    _iCurrentMediaDocModel.currentTime = tCurrentTime;
                    //先设置时间，在播放。否则有个播放时的切换。
                    if ([tCurrentTime doubleValue]) {
                        [_iVideoPlayerHandle setCurrentTime:[tCurrentTime doubleValue]];
                    }
                    
                    if ([tDataDic objectForKey:@"play"]) {
                        
                        BOOL tPlay = [[tDataDic objectForKey:@"play"]boolValue] ;
                        if (( [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher )) {
                            
                            [_iMediaListView playOrPauseVideoOrAudio:!inlist];
                            [_iMediaListView setCurrentTime:[tCurrentTime doubleValue] SendToOther:NO];
                            break;
                        }
                        [_iVideoPlayerHandle playeOrPause:tPlay];
                        
                    }
                    
                }
                break;
            }
                
        }
    }
    
    // to wb
    NSDictionary *tParamDic = @{
                                @"id":msgID,//DocumentFilePage_ShowPage
                                @"ts":@(ts),
                                @"data":tDataDic?tDataDic:[NSNull null],
                                @"name":msgName//ShowPage
                                };
    
    NSString *tMessageString = add ?@"publish-message-received" :@"delete-message-received";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tParamDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"GLOBAL.phone.receivePhoneByTriggerEvent('%@',%@)",tMessageString,jsonString];
    [_iBoardHandle.iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
        
        NSLog(@"----GLOBAL.phone.receivePhoneByTriggerEvent");
    }];
   
    
    if (_iBoardDelegate && [_iBoardDelegate respondsToSelector:@selector(boardOnRemoteMsg:ID:Name:TS:Data:InList:)]) {
        
        tIsWhiteBoardDealWith = [_iBoardDelegate boardOnRemoteMsg:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
    }
    
    return tIsWhiteBoardDealWith;
}



#pragma mark 其他
//聊天信息
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

//用户
- (NSArray *)userListArray{
     return [_iUserList copy];
}
- (void)addOrReplaceUserArray:(RoomUser *)aRoomUser {
    NSArray *tArray  = [_iUserList copy];
    
    BOOL tIsHave                              = NO;
    BOOL tIsHaveTeacher                       = NO;
    NSInteger tRoomUserIndex = 0;
  
    for (RoomUser *tRoomUser in tArray) {
        if (tRoomUser.role == UserType_Teacher) {
            tIsHaveTeacher = YES;
            break;
            
        }
    }

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
        }else if ([aRoomUser.peerID isEqualToString: self.localUser.peerID]){
            
             [_iUserList insertObject:aRoomUser atIndex:tIsHaveTeacher];
           
        }else{
            [_iUserList addObject:aRoomUser];
        }
        
    }else{
        
        [_iUserList replaceObjectAtIndex:tRoomUserIndex withObject:aRoomUser];
        
    }
}
- (void)delUserArray:(RoomUser *)aRoomUser {
   
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
//视频用户
- (NSSet *)userPlayAudioArray{
    
    return [_iUserPlayAudioArray copy];
    
}
- (void)addOrReplaceUserPlayAudioArray:(RoomUser *)aRoomUser {

    [_iUserPlayAudioArray addObject:aRoomUser.peerID];
}
- (void)delUserPlayAudioArray:(RoomUser *)aRoomUser {
    [_iUserPlayAudioArray removeObject:aRoomUser.peerID];
}

#pragma mark 白板数据
- (NSArray *)docmentArray{
    
    return [_iDocmentMutableArray copy];
    
}

- (bool )addOrReplaceDocmentArray:(TKDocmentDocModel *)aDocmentDocModel {
    TKLog(@"---------add:%@",aDocmentDocModel.filename);
    if (!aDocmentDocModel) {
        return false;
    }
    
    if ([aDocmentDocModel.dynamicppt integerValue]==1)
        return false;
    
    NSArray *tArray  = [_iDocmentMutableArray copy];
    BOOL tIsHave     = NO;
    NSInteger tIndex = 0;
    for (TKDocmentDocModel *tDocmentDocModel in tArray) {
        
        if ([tDocmentDocModel.fileid integerValue] == [aDocmentDocModel.fileid integerValue]) {
            
            
            //active
            if ([aDocmentDocModel.active intValue]!= [tDocmentDocModel.active intValue] && aDocmentDocModel.active) {
                tDocmentDocModel.active = aDocmentDocModel.active;
            }
            //animation
            if ([aDocmentDocModel.animation intValue]!= [tDocmentDocModel.animation intValue] && aDocmentDocModel.animation) {
                tDocmentDocModel.animation = aDocmentDocModel.animation;
            }
            //companyid
            if ([aDocmentDocModel.companyid intValue]!= [tDocmentDocModel.companyid intValue] && aDocmentDocModel.companyid) {
                tDocmentDocModel.companyid = aDocmentDocModel.companyid;
            }
            
            //downloadpath
            if (![aDocmentDocModel.downloadpath isEqualToString:tDocmentDocModel.downloadpath] && aDocmentDocModel.downloadpath) {
                tDocmentDocModel.downloadpath = aDocmentDocModel.downloadpath;
            }
            //filename
            if (![aDocmentDocModel.filename isEqualToString:tDocmentDocModel.filename] && aDocmentDocModel.filename) {
                tDocmentDocModel.filename = aDocmentDocModel.filename;
            }
            //fileid
            if ([aDocmentDocModel.fileid intValue]!= [tDocmentDocModel.fileid intValue] && aDocmentDocModel.fileid) {
                tDocmentDocModel.fileid = aDocmentDocModel.fileid;
            }
            
            //filepath
            if (![aDocmentDocModel.filepath isEqualToString:tDocmentDocModel.filepath] && aDocmentDocModel.filepath) {
                tDocmentDocModel.filepath = aDocmentDocModel.filepath;
            }
            //fileserverid
            if ([aDocmentDocModel.fileserverid intValue]!= [tDocmentDocModel.fileserverid intValue] && aDocmentDocModel.fileserverid) {
                tDocmentDocModel.fileserverid = aDocmentDocModel.fileserverid;
            }
            //filetype
            if (![aDocmentDocModel.filetype isEqualToString:tDocmentDocModel.filetype] && aDocmentDocModel.filetype) {
                tDocmentDocModel.filetype = aDocmentDocModel.filetype;
            }
            //isconvert
            if ([aDocmentDocModel.isconvert intValue]!= [tDocmentDocModel.isconvert intValue] && aDocmentDocModel.isconvert) {
                tDocmentDocModel.isconvert = aDocmentDocModel.isconvert;
            }
            
            
            //newfilename
            if (![aDocmentDocModel.newfilename isEqualToString:tDocmentDocModel.newfilename] && aDocmentDocModel.newfilename) {
                tDocmentDocModel.newfilename = aDocmentDocModel.newfilename;
            }
            
            //pagenum
            if ([aDocmentDocModel.pagenum intValue]!= [tDocmentDocModel.pagenum intValue] && aDocmentDocModel.pagenum) {
                tDocmentDocModel.pagenum = aDocmentDocModel.pagenum;
            }
            //pdfpath
            if (![aDocmentDocModel.pdfpath isEqualToString:tDocmentDocModel.pdfpath] && aDocmentDocModel.pdfpath) {
                tDocmentDocModel.pdfpath = aDocmentDocModel.pdfpath;
            }
            
            //size
            if ([aDocmentDocModel.size intValue]!= [tDocmentDocModel.size intValue] && aDocmentDocModel.size) {
                tDocmentDocModel.size = aDocmentDocModel.size;
            }
            //status
            if ([aDocmentDocModel.status intValue]!= [tDocmentDocModel.status intValue] && aDocmentDocModel.status) {
                tDocmentDocModel.status = aDocmentDocModel.status;
            }
            //swfpath
            if (![aDocmentDocModel.swfpath isEqualToString:tDocmentDocModel.swfpath] && aDocmentDocModel.swfpath) {
                tDocmentDocModel.swfpath = aDocmentDocModel.swfpath;
            }
            //type
            if (![aDocmentDocModel.type isEqualToString:tDocmentDocModel.type] && aDocmentDocModel.type) {
                tDocmentDocModel.type = aDocmentDocModel.type;
            }
            //uploadtime
            if (![aDocmentDocModel.uploadtime isEqualToString:tDocmentDocModel.uploadtime] && aDocmentDocModel.uploadtime) {
                tDocmentDocModel.uploadtime = aDocmentDocModel.uploadtime;
            }
            
            //status
            if ([aDocmentDocModel.uploaduserid intValue]!= [tDocmentDocModel.uploaduserid intValue] && aDocmentDocModel.uploaduserid) {
                tDocmentDocModel.uploaduserid = aDocmentDocModel.uploaduserid;
            }
            //uploadtime
            if (![aDocmentDocModel.uploadusername isEqualToString:tDocmentDocModel.uploadusername] && aDocmentDocModel.uploadusername) {
                tDocmentDocModel.uploadusername = aDocmentDocModel.uploadusername;
            }
            //currpage
            if ([aDocmentDocModel.currpage intValue]!= [tDocmentDocModel.currpage intValue] && aDocmentDocModel.currpage) {
                tDocmentDocModel.currpage = aDocmentDocModel.currpage;
            }
            
            //dynamicppt
            if ([aDocmentDocModel.dynamicppt intValue]!= [tDocmentDocModel.dynamicppt intValue] && aDocmentDocModel.dynamicppt) {
                tDocmentDocModel.dynamicppt = aDocmentDocModel.dynamicppt;
            }
            
            //pptslide
            if ([aDocmentDocModel.pptslide intValue]!= [tDocmentDocModel.pptslide intValue] && aDocmentDocModel.pptslide) {
                tDocmentDocModel.pptslide = aDocmentDocModel.pptslide;
            }
            
            //pptstep
            if ([aDocmentDocModel.pptstep intValue]!= [tDocmentDocModel.pptstep intValue] && aDocmentDocModel.pptstep) {
                tDocmentDocModel.pptstep = aDocmentDocModel.pptstep;
            }
            
            //action
            if (![aDocmentDocModel.action isEqualToString:tDocmentDocModel.action] && aDocmentDocModel.action) {
                tDocmentDocModel.action = aDocmentDocModel.action;
            }
            //isShow
            if ([aDocmentDocModel.isShow intValue]!= [tDocmentDocModel.isShow intValue] && aDocmentDocModel.isShow) {
                tDocmentDocModel.isShow = aDocmentDocModel.isShow;
            }
            aDocmentDocModel = tDocmentDocModel;
            tIsHave = YES;
            
            break;
        }
        tIndex++;
        
        
    }
    if (!tIsHave) {
        [_iDocmentMutableArray addObject:aDocmentDocModel];
        
    }else{
        [_iDocmentMutableArray replaceObjectAtIndex:tIndex withObject:aDocmentDocModel];
    }
    
    
    return YES;
    
    
}
- (void)delDocmentArray:(TKDocmentDocModel *)aDocmentDocModel {
    if (!aDocmentDocModel) {
        return;
    }
    TKLog(@"---------del:%@",aDocmentDocModel.filename);
    
    NSArray *tArrayAll = [_iDocmentMutableArray copy];
    NSInteger tIndex = 0;
    for (TKDocmentDocModel *tDocmentDocModel in tArrayAll) {
        
        if ([tDocmentDocModel.fileid integerValue] == [aDocmentDocModel.fileid integerValue]) {
            [_iDocmentMutableArray removeObjectAtIndex:tIndex];
            
            break;
        }
        tIndex++;
        
    }
    
}


- (NSArray *)mediaArray{
    
    
    return [_iMediaMutableArray copy];
    
}
- (void)addOrReplaceMediaArray:(TKMediaDocModel *)aMediaDocModel {
    if (!aMediaDocModel) {
        return ;
    }
    TKLog(@"---------add:%@",aMediaDocModel.filename);
    NSArray *tArray  = [_iMediaMutableArray copy];
    
    BOOL tIsHave                              = NO;
    NSInteger tIndex = 0;
    for (TKMediaDocModel *tMediaDocModel in tArray) {
        
        if ([tMediaDocModel.fileid integerValue] == [aMediaDocModel.fileid integerValue]) {
            //page
            if ([aMediaDocModel.page intValue]!= [tMediaDocModel.page intValue] && aMediaDocModel.page) {
                tMediaDocModel .page = aMediaDocModel.page ;
            }
            //ismedia
            if ([aMediaDocModel.ismedia intValue]!= [tMediaDocModel.ismedia intValue] && aMediaDocModel.ismedia) {
                tMediaDocModel .ismedia = aMediaDocModel.ismedia ;
            }
            //isconvert
            if ([aMediaDocModel.isconvert intValue]!= [tMediaDocModel.isconvert intValue] && aMediaDocModel.isconvert) {
                tMediaDocModel .isconvert = aMediaDocModel.isconvert ;
            }
            
            //pagenum
            if ([aMediaDocModel.pagenum intValue]!= [tMediaDocModel.pagenum intValue] && aMediaDocModel.pagenum) {
                tMediaDocModel .pagenum = aMediaDocModel.pagenum ;
            }
            //filetype
            if (![aMediaDocModel.filetype isEqualToString:tMediaDocModel.filetype] && aMediaDocModel.filetype) {
                
                tMediaDocModel.filetype = aMediaDocModel.filetype;
                
            }
            
            //filename
            if (![aMediaDocModel.filename isEqualToString:tMediaDocModel.filename] && aMediaDocModel.filename) {
                
                tMediaDocModel.filename = aMediaDocModel.filename;
                
            }
            //filename
            if (![aMediaDocModel.swfpath isEqualToString:tMediaDocModel.swfpath] && aMediaDocModel.swfpath) {
                
                tMediaDocModel.swfpath = aMediaDocModel.swfpath;
                
            }
            //currentTime
            if ([aMediaDocModel.currentTime intValue]!= [tMediaDocModel.currentTime intValue] && aMediaDocModel.currentTime) {
                tMediaDocModel.currentTime = aMediaDocModel.currentTime ;
            }
            //isPlay
            if ([aMediaDocModel.isPlay intValue]!= [tMediaDocModel.isPlay intValue] && aMediaDocModel.isPlay) {
                tMediaDocModel.isPlay = aMediaDocModel.isPlay ;
            }
            
            aMediaDocModel = tMediaDocModel;
            tIsHave = YES;
            
            break;
        }
        tIndex++;
        
        
    }
    if (!tIsHave) {
        [_iMediaMutableArray addObject:aMediaDocModel];
        
    }else{
        [_iMediaMutableArray replaceObjectAtIndex:tIndex withObject:aMediaDocModel];
    }
    
    
    
    
    
}
- (void)delMediaArray:(TKMediaDocModel *)aMediaDocModel {
    if (!aMediaDocModel) {
        return ;
    }
    TKLog(@"---------del:%@",aMediaDocModel.filename);
    
    //删除所有
    NSArray *tArrayAll = [_iMediaMutableArray copy];
    NSInteger tIndex = 0;
    for (TKMediaDocModel *tMediaDocModel in tArrayAll) {
        
        if ([tMediaDocModel.fileid integerValue] == [aMediaDocModel.fileid integerValue]) {
            [_iMediaMutableArray removeObjectAtIndex:tIndex];
            break;
        }
        tIndex++;
        
    }
    
}
-(TKDocmentDocModel *)getNextDocment:(TKDocmentDocModel *)aCurrentDocmentModel{
    NSArray *tArray = [self docmentArray];
    int i = 0;
    for (TKDocmentDocModel *tDoc in tArray)
    {
        if([tDoc.fileid integerValue]==[aCurrentDocmentModel.fileid integerValue])
            
        {
            NSInteger tIndex = (i == [tArray count]-1)?0:i+1;
            return [tArray objectAtIndex:tIndex];
            
        }
        i++;
    }
    return [tArray objectAtIndex:0];
    
}
-(TKMediaDocModel*)getNextMedia:(TKMediaDocModel *)aCurrentMediaDocModel{
    NSArray *tArray = [self mediaArray];
    int i = 0;
    for (TKMediaDocModel *tDoc in tArray)
    {
        if([tDoc.fileid integerValue]==[aCurrentMediaDocModel.fileid integerValue])
            
        {
            return [tArray objectAtIndex:(i == [tArray count])?0:i+1];
            
        }
        i++;
    }
    return [tArray objectAtIndex:0];
}
#pragma mark 加按钮
-(bool)addPendingButton:(RoomUser *)aRoomUser{
    
    
    int  tMaxVideo = [self.iRoomProperties.iMaxVideo intValue];
    if (tMaxVideo > [_iPendingButtonDic count]) {
         [_iPendingButtonDic setObject:aRoomUser forKey:aRoomUser.peerID];
        return  true;
    }
    return false;
   
}
-(void)delePendingButton:(RoomUser*)aRoomUser{
    [_iPendingButtonDic removeObjectForKey:aRoomUser.peerID];
}

-(NSDictionary *)pendingButtonDic{
    return [_iPendingButtonDic copy];
}
-(void)clearAllClassData{
    
     //修复重连时，会有问题！
    [_iMessageList removeAllObjects];
    [_iUserList removeAllObjects];
    [_iUserPlayAudioArray removeAllObjects];
    _isClassBegin = NO;
    _isMuteAudio  = NO;
    _iTeacherUser = nil;
    _iRoomProperties = nil;
    [_iPendingButtonDic removeAllObjects];
    _iVideoPlayerHandle = nil;
    _iIsPlay = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark set and get

-(RoomUser*)localUser{
    return [_roomMgr localUser];
}
-(NSSet *)remoteUsers{
    return [_roomMgr remoteUsers];
}

-(BOOL)useFrontCamera{
    return [_roomMgr useFrontCamera];
}

-(BOOL)isConnected{
    return [_roomMgr isConnected];
}
-(BOOL)isJoined{
    return [_roomMgr isJoined];
}
-(NSString *)roomName{
    return [_roomMgr roomName];
}
-(int)roomType{
    return [_roomMgr roomType];
}
-(NSDictionary *)roomProperties{
    return  [_roomMgr roomProperties];
}


#pragma mark 发布影音
-(void)publishtMediaDocModel:(TKMediaDocModel*)aMediaDocModel add:(BOOL)add To:(NSString *)to{
  //mediaType\":\"video\"
     BOOL tIsVideo = [TKUtil isVideo:aMediaDocModel.filetype];
    NSString *tIdString = tIsVideo?sVideo_MediaFilePage_ShowPage:sAudio_MediaFilePage_ShowPage ;
    NSString *tMediaType = tIsVideo?@"video":@"audio" ;
    NSDictionary *tMediaDocModelDic = @{
                                        @"fileid":aMediaDocModel.fileid,
                                        @"page":aMediaDocModel.page?aMediaDocModel.page:@(1),
                                        @"ismedia":@(true),
                                        @"mediaType":tMediaType,
                                        @"filedata":@{
                                                @"fileid":aMediaDocModel.fileid,
                                                @"currpage":@(1),
                                                @"pagenum":aMediaDocModel.pagenum?aMediaDocModel.pagenum:@(1),
                                                @"filetype":aMediaDocModel.filetype,
                                                @"filename":aMediaDocModel.filename,
                                                @"swfpath":aMediaDocModel.swfpath
                                                }
                                        };
   
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tMediaDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //to = sTellAllExpectSender;
    if (add) {
        [self sessionHandlePubMsg:sShowPage ID:tIdString To:to Data:jsonString Save:true completion:nil];
    }else{
        [self sessionHandleDelMsg:sShowPage ID:tIdString To:to Data:jsonString completion:nil];
    }
}


//todo
-(void)publishtProgressMediaDocModel:(TKMediaDocModel*)aMediaDocModel To:(NSString *)to isPlay:(BOOL)isPlay{
    
    /*
     {
     action = 1;
     currentTime = 0;
     fileid = 4638;
     mediaType = video;
     }
     msgID:MediaProgress_video_1
     msgName:MediaProgress
     
     */

    NSNumber* fileid = aMediaDocModel.fileid;
    BOOL tIsVideo = [TKUtil isVideo:aMediaDocModel.filetype];
    NSString *tMediaType = tIsVideo?@"video":@"audio";
    NSString *tMsgName = sMediaProgress;
    NSString *tMsId=   tIsVideo?sMediaProgress_video_1:sMediaProgress_audio_1;
    NSDictionary *tMediaDate = @{
                                 @"action":@(MediaProgressAction_ChangeProgress),
                                 @"mediaType":tMediaType,
                                 @"play":@(isPlay),
                                 @"fileid":fileid,
                                 @"currentTime":aMediaDocModel.currentTime
                                 };
   // [self sessionHandlePubMsg:tMsgName ID:tMsId To:to Data:tMediaDate Save:true completion:nil];
    //改成字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tMediaDate options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sessionHandlePubMsg:tMsgName ID:tMsId To:to Data:jsonString Save:true completion:nil];
    
    
}
//todo
-(void)publishtPlayOrPauseMediaDocModel:(TKMediaDocModel*)aMediaDocModel To:(NSString *)to isPlay:(BOOL)isPlay{
    
    /*
     
     {
     action = 0;
     currentTime = "16.306196";
     fileid = 4638;
     mediaType = video;
     play = 0;
     }
     
     */
    
    NSNumber* fileid = aMediaDocModel.fileid;
    BOOL tIsVideo = [TKUtil isVideo:aMediaDocModel.filetype];
    NSString *tMediaType = tIsVideo?@"video":@"audio";
    NSString *tMsgName = sMediaProgress;
    NSString *tMsId=   tIsVideo?sMediaProgress_video_1:sMediaProgress_audio_1;
    NSDictionary *tMediaDate = @{
                                 @"action":@(MediaProgressAction_PlayOrPause),
                                 @"mediaType":tMediaType,
                                 @"fileid":fileid,
                                 @"currentTime":aMediaDocModel.currentTime?aMediaDocModel.currentTime:@(0),
                                 @"play":@(isPlay)
                                 };
    //[self sessionHandlePubMsg:tMsgName ID:tMsId To:to Data:tMediaDate Save:true completion:nil];
    //改成字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tMediaDate options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sessionHandlePubMsg:tMsgName ID:tMsId To:to Data:jsonString Save:true completion:nil];
    
}
/*
 
 //发送要进度请求，因为android的播放进度会受是否home影响
 HashMap<String,Object> data = new HashMap<String,Object>();
 data.put("action",-1);
 data.put("sendParticipantId",RoomManager.getInstance().getMySelf().peerId);
 data.put("fileid",currentDoc.getFileid());
 if(isMp4(currentDoc.getFiletype())){
 data.put("mediaType","video");
 }else{
 data.put("mediaType","audio");
 }
 String towho = "";
 for (RoomUser u:RoomManager.getInstance().getUsers().values()) {
 if(u.role == 0&&!u.peerId.equals(RoomManager.getInstance().getMySelf().peerId)){
 towho = u.peerId;
 break;
 }
 }
 if(towho.isEmpty()){
 for (RoomUser u:RoomManager.getInstance().getUsers().values()) {
 if(!u.peerId.equals(RoomManager.getInstance().getMySelf().peerId)){
 towho = u.peerId;
 break;
 }
 }
 }
 if(!towho.isEmpty()&&RoomActivity.isClassBegin){
 RoomManager.getInstance().pubMsg("MediaProgress","MediaProgress",towho,data,false);
 }
 
 */
//todo
//发送要进度请求，因为android的播放进度会受是否home影响
-(void)publishtNeedProgressMediaDocModel:(TKMediaDocModel*)aMediaDocModel {
    /*
     {
     action = -1;
     sendParticipantId = 1110;
     fileid = 4638;
     mediaType = video;
     }
     msgID:MediaProgress_video_1
     msgName:MediaProgress
     
     */
    
    NSNumber* fileid = aMediaDocModel.fileid;
    BOOL tIsVideo = [TKUtil isVideo:aMediaDocModel.filetype];
    NSString *tMediaType = tIsVideo?@"video":@"audio";
    NSString *tMsgName = sMediaProgress;
    NSString *tMsId=   tIsVideo?sMediaProgress_video_1:sMediaProgress_audio_1;
    NSDictionary *tMediaDate = @{
                                 @"action"           :@(MediaProgressAction_OtherNeedProgress),
                                 @"mediaType"        :tMediaType,
                                 @"fileid"           :fileid,
                                 @"sendParticipantId":self.localUser.peerID
                                 };
    NSString *tTo = sTellAllExpectSender;
    
    for (RoomUser *tRoomUser in self.userListArray) {
        if (tRoomUser.role == UserType_Teacher && ![tRoomUser.peerID isEqualToString:self.localUser.peerID]) {
            tTo = tRoomUser.peerID;
            break;
        }
        tTo = tRoomUser.peerID;
    }
    
   // [self sessionHandlePubMsg:tMsgName ID:tMsId To:tTo Data:tMediaDate Save:false completion:nil];
    //改成字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tMediaDate options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sessionHandlePubMsg:tMsgName ID:tMsId To:tTo Data:jsonString Save:false completion:nil];
}
#pragma mark 发布文档
-(void)publishtDocMentDocModel:(TKDocmentDocModel*)tDocmentDocModel To:(NSString *)to {
     [self docmentDefault:tDocmentDocModel];
   
    /*
     
     
     {"toID":"__allExceptSender","id":"DocumentFilePage_ShowPage","data":"{\"fileid\":249,\"page\":1,\"ismedia\":false,\"filedata\":{\"fileid\":249,\"currpage\":1,\"pagenum\":27,\"filetype\":\"xlsx\",\"filename\":\"bug list for 微议_20161201.xlsx\",\"swfpath\":\"/upload/20170603_111239_vvcqewpw.jpg\"}}","name":"ShowPage"}
     */
    NSDictionary *tDocmentDocModelDic = @{
                                          @"fileid":tDocmentDocModel.fileid,
                                          @"page":tDocmentDocModel.currpage?tDocmentDocModel.currpage:@(1),
                                          @"ismedia":@(false),
                                          @"filedata":@{
                                                  @"fileid":tDocmentDocModel.fileid,
                                                  @"currpage":tDocmentDocModel.currpage?tDocmentDocModel.currpage:@(1),
                                                  @"pagenum":tDocmentDocModel.pagenum?tDocmentDocModel.pagenum:@(1),
                                                  @"filetype":tDocmentDocModel.filetype,
                                                  @"filename":tDocmentDocModel.filename,
                                                  @"swfpath":tDocmentDocModel.swfpath
                                                  }
                                          };
    
    if ([tDocmentDocModel.dynamicppt boolValue]) {
       
        bool tIsAynamicPPT = true;
        TKLog(@"jin msgName3:%@msgID:%@tcurrpage:%@pptStep:%@pptslide:%@",sShowPage,sDocumentFilePage_ShowPage,tDocmentDocModel.currpage,tDocmentDocModel.pptstep,tDocmentDocModel.pptslide);
        tDocmentDocModelDic = @{
                                @"action":sActionShow,
                                @"aynamicPPT":@(tIsAynamicPPT),
                                @"ismedia":@(false),
                                @"filedata":@{
                                        @"fileid":tDocmentDocModel.fileid,
                                        @"currpage":tDocmentDocModel.currpage?tDocmentDocModel.currpage:@(1),
                                        @"pagenum":tDocmentDocModel.pagenum?tDocmentDocModel.pagenum:@(0),
                                        @"filetype":tDocmentDocModel.filetype,
                                        @"pptslide":tDocmentDocModel.pptslide?tDocmentDocModel.pptslide:@(1),
                                        @"pptstep":tDocmentDocModel.pptstep?tDocmentDocModel.pptstep:@(0),
                                        @"filename":tDocmentDocModel.filename,
                                        @"swfpath":tDocmentDocModel.swfpath
                                        }
                                };
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDocmentDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    [self sessionHandlePubMsg:sShowPage ID:sDocumentFilePage_ShowPage To:to Data:jsonString Save:true completion:nil];
    
}
#pragma mark 删除文档
//todo
-(void)deleteDocMentDocModel:(TKDocmentDocModel*)aDocmentDocModel To:(NSString *)to{

    NSDictionary *tDocmentDocModelDic = @{
                                          @"fileid":aDocmentDocModel.fileid,
                                          @"isdel":@(true),
                                          @"serial":self.iRoomProperties.iRoomId,
                                          @"ismedia":@(false)
                                          };
    
    
    // [self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:tDocmentDocModelDic Save:YES completion:nil];
    //改成字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDocmentDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:jsonString Save:true completion:nil];
    
    
}
-(void)deleteaMediaDocModel:(TKMediaDocModel*)aMediaDocModel To:(NSString *)to{
    
    NSDictionary *tMediaDocModelDic = @{
                                          @"fileid":aMediaDocModel.fileid,
                                          @"isdel":@(true),
                                          @"serial":self.iRoomProperties.iRoomId,
                                          @"ismedia":@(true)
                                          };

    //[self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:tMediaDocModelDic Save:YES completion:nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tMediaDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:jsonString Save:true completion:nil];
    
    
}

#pragma mark 设置白板
-(void)docmentDefault:(TKDocmentDocModel*)aDefaultDocment{
    _iCurrentDocmentModel = aDefaultDocment;
    NSDictionary *tDataDic = @{
                               @"filedata":@{
                                       @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@"",
                                       @"filename":aDefaultDocment.filename?aDefaultDocment.filename:@"",
                                       @"filetype": aDefaultDocment.filetype?aDefaultDocment.filetype:@"",
                                       @"isconvert": aDefaultDocment.isconvert?aDefaultDocment.isconvert:@"",
                                       @"currpage": aDefaultDocment.currpage?aDefaultDocment.currpage:@(1),
                                       @"pagenum"  : aDefaultDocment.pagenum?aDefaultDocment.pagenum:@"",
                                       @"swfpath"  :  aDefaultDocment.swfpath?aDefaultDocment.swfpath:@""
                                       
                                       },
                               @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@"",
                               @"ismedia":@(0)
                               
                               };
    if ([aDefaultDocment.dynamicppt intValue] && aDefaultDocment.dynamicppt) {
        bool bool_true = true;
        bool bool_false = false;
        tDataDic = @{
                     @"filedata":@{
                             @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@"",
                             @"filename":aDefaultDocment.filename?aDefaultDocment.filename:@"",
                             @"filetype": aDefaultDocment.filetype?aDefaultDocment.filetype:@"",
                             @"isconvert": aDefaultDocment.isconvert?aDefaultDocment.isconvert:@"",
                             @"currpage": aDefaultDocment.currpage?aDefaultDocment.currpage:@(1),
                             @"pagenum"  : aDefaultDocment.pagenum?aDefaultDocment.pagenum:@(1),
                             @"swfpath"  :  aDefaultDocment.swfpath?aDefaultDocment.swfpath:@"",
                             @"pptslide": aDefaultDocment.pptslide?aDefaultDocment.pptslide:@(1),
                             @"pptstep":aDefaultDocment.pptstep?aDefaultDocment.pptstep:@(0)
                             },
                     @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@"",
                     @"ismedia":@(bool_false),
                     @"action":sActionShow,
                     @"page": aDefaultDocment.currpage?aDefaultDocment.currpage:@(1),
                     @"aynamicPPT":aDefaultDocment.dynamicppt?@(bool_true):@(bool_false)
                     };
        TKLog(@"jin msgName2:%@msgID:%@tcurrpage:%@pptStep:%@pptslide:%@",sShowPage,sDocumentFilePage_ShowPage,aDefaultDocment.currpage,aDefaultDocment.pptstep,aDefaultDocment.pptslide);
    }
    
    NSDictionary *tParamDicDefault = @{
                                       @"id":sDocumentFilePage_ShowPage,//DocumentFilePage_ShowPage
                                       @"ts":@(0),
                                       @"data":tDataDic?tDataDic:[NSNull null],
                                       @"name":sShowPage
                                       };
    
    NSString *tMessageString = @"publish-message-received";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tParamDicDefault options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *jsReceivePhoneByTriggerEventForDefault = [NSString stringWithFormat:@"GLOBAL.phone.receivePhoneByTriggerEvent('%@',%@)",tMessageString,jsonString];
    [_iBoardHandle.iWebView evaluateJavaScript:jsReceivePhoneByTriggerEventForDefault completionHandler:^(id _Nullable id, NSError * _Nullable error) {
        NSLog(@"----GLOBAL.phone.receivePhoneByTriggerEvent");
    }];
}
-(void)clearAllWhiteBoardData{
    
    [_iDocmentMutableArray removeAllObjects];
    [_iMediaMutableArray removeAllObjects];
    [_iVideoPlayerHandle releaseAVPlayer];
    _iDefaultDocment      = nil;
    _iIsPlay              = NO;
    _iCurrentDocmentModel = nil;
    _iPreDocmentModel = nil;
    _iPreMediaDocModel = nil;
    _iCurrentMediaDocModel = nil;

}

-(void)configurePlayerRoute:(BOOL)aIsPlay{
//    if ([TKEduSessionHandle shareInstance].isHeadphones) {
//        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
//        return;
//    }
    if (!aIsPlay) {
        [self sessionHandleEnableAllAudio:YES];
        [self sessionHandleUseLoudSpeaker:YES];
        
        
    } else {
        [self sessionHandleEnableAllAudio:NO];
        [self sessionHandleUseLoudSpeaker:YES];
    }
   
}
//Selecting audio inputs
-(void)selectingAudioInputs{
    //private var inputs = [AVAudioSessionPortDescription]()
    AVAudioSession *tSession = [AVAudioSession sharedInstance];

    //Built-in microphone-内置麦克风
    //Microphone on a wired headset-耳机上麦克风
    //Headphone or headset - 耳机
    //The speaker - 扬声器
    //Built-in speaker - 内置扬声器
   //InReceiver - 听筒
    NSMutableArray<AVAudioSessionPortDescription *> * inputs = [NSMutableArray arrayWithCapacity:10];
    
    NSArray<AVAudioSessionPortDescription *> *availableInputs=   tSession.availableInputs;
    for (AVAudioSessionPortDescription* input in availableInputs) {
        if (input.portType == AVAudioSessionPortBuiltInMic || input.portType == AVAudioSessionPortHeadsetMic) {
            [inputs addObject:input];
        }
    }
    [tSession setPreferredInput:[inputs firstObject]  error:nil];

}

#pragma mark 获取摄像头失败
-(void)callCameroError{
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onCameraDidOpenError)]) {
        
        [(id<TKEduRoomDelegate>) _iRoomDelegate onCameraDidOpenError];
        
    }
}
#pragma mark 进入前后台

-(void)enterForeground:(NSNotification *)aNotification{
    TKLog(@"----sessionHandle2  %@",@(_iIsPlay));
    if (_iCurrentMediaDocModel &&  _iIsPlay && (self.localUser.role == UserType_Student)) {
        [_iVideoPlayerHandle playeOrPause:YES];
    }
}
-(void)enterBackground:(NSNotification *)aNotification{
     //TKLog(@"----sessionHandle");
    _iIsPlay =  _iVideoPlayerHandle.iIsPlayState ;
     TKLog(@"----sessionHandle  %@",@(_iIsPlay));
    if (_iCurrentMediaDocModel&&_iIsPlay && (self.localUser.role == UserType_Student)) {
        [_iVideoPlayerHandle playeOrPause:NO];
    }
}
#pragma mark 
-(void)dealloc{
    TKLog(@"----sessionHandle");
}

@end

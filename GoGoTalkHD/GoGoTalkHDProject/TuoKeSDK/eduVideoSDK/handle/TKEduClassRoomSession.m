//
//  TKEduClassRoomSession.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduClassRoomSession.h"
#import "TKMacro.h"
@import AVFoundation;
@interface RoomManager(test)
- (void)setTestServer:(NSString*)ip Port:(NSString*)port;
@end

@interface TKEduClassRoomSession ()<RoomManagerDelegate>



@end

@implementation TKEduClassRoomSession
-(instancetype)initEduClassRoomSessionParamDic:(NSDictionary *)ParamDic aMeetingHandleDelegate:(id<TKEduEnterClassRoomDelegate>)delegate aEduClassRoomSessionDelegate:(id<TKEduClassRoomSessionDelegate>)aEduClassRoomSessionDelegate{
   return  [self initEduClassRoomSessionParamDic:ParamDic aMeetingHandleDelegate:delegate aRoomWhiteBoardDelegate:nil aEduClassRoomSessionDelegate:aEduClassRoomSessionDelegate];
    
}
-(instancetype)initEduClassRoomSessionParamDic:(NSDictionary *)ParamDic aMeetingHandleDelegate:(id<TKEduEnterClassRoomDelegate>)delegate aRoomWhiteBoardDelegate:(id<RoomWhiteBoard>)aRoomWhiteBoardDelegate aEduClassRoomSessionDelegate:(id<TKEduClassRoomSessionDelegate>)aEduClassRoomSessionDelegate{
    
    if (self = [super init]) {
        
        _iEduEnterClassRoomDelegate = delegate;
        _iEduClassRoomSessionDelegate = aEduClassRoomSessionDelegate;
        aRoomWhiteBoardDelegate ?[self initClassRoomManager:aRoomWhiteBoardDelegate] : [self initClassRoomManager];

    }
    return self;
}

-(void)initClassRoomManager{
       _roomMgr = [[RoomManager alloc] initWithDelegate:self];
}
-(void)initClassRoomManager:(id<RoomWhiteBoard>)aRoomWhiteBoardDelegate{
    _roomMgr = [[RoomManager alloc] initWithDelegate:self AndWB:aRoomWhiteBoardDelegate];
}
-(void)joinEduClassRoomForSessionWithHost:(NSString *)aHost aPort:(NSString *)aPort aNickName:(NSString *)aNickName aDomain:(NSString *)aDomain aRoomId:(NSString *)aRoomId aPassword:(NSString *)aPassword aUserID:(NSString *)aUserID Properties:(NSDictionary*)properties{
    
    if (_roomMgr) {
        
#ifdef Debug
    //192.168.1.24
      [_roomMgr setTestServer:@"192.168.1.24" Port:@"8443"];
#else
//    [_roomMgr joinRoomWithHost:@"192.168.0.66"
//                          Port:443
//                      NickName:@"ios"
//                        Params:@{@"domain":@"www", @"serial":@"449542978"}];
//
//     [_roomMgr joinRoomWithHost:@"m1.talk-cloud.com" Port:443 NickName:@"ios" Params:@{@"domain":@"www", @"param":@"otsI-xauxQWtogrQylbXeIGPPwFhQagiHkK3zpQcrCpl54n3OgpWAsn8YrVo-e-g2RhOMp1xYosVnqjMs3F3D71wXp64FPHy5lw37kBMVwW4scYeQrte8mWE77qY5BXy"}];
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
                                  @"userid":aUserID
                                  };
        
        if (aPassword && ![aPassword isEqualToString:@""]) {
            tParams = @{
                        @"serial":aRoomId?aRoomId:@"",
                        @"password":aPassword?aPassword:@"",
                        @"userid":aUserID
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
- (void)sessionLeaveRoom:(void (^)(NSError *error))block {
    return [_roomMgr leaveRoom:block];
}


//看视频
- (void)sessionPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error, NSObject *view))block{
    return [_roomMgr playVideo:peerID completion:block];
}
//不看
- (void)sessionUnPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error))block{
    return [_roomMgr unPlayVideo:peerID completion:block];
}
//状态变化
- (void)sessionChangeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom Key:(NSString*)key Value:(NSObject*)value completion:(void (^)(NSError *error))block{
    
    return [_roomMgr changeUserProperty:peerID TellWhom:tellWhom Key:key Value:value completion:block];
    
}
//
- (void)sessionChangeUserPublish:(NSString*)peerID Publish:(int)publish completion:(void (^)(NSError *error))block{
    return [_roomMgr changeUserPublish:peerID Publish:publish completion:block];
    
}

- (void)sessionSendMessage:(NSString*)message completion:(void (^)(NSError *error))block{
    return [_roomMgr sendMessage:message completion:block];
}

- (void)sessionPubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block{
    return [_roomMgr pubMsg:msgName ID:msgID To:toID Data:data Save:save completion:block];
}

- (void)sessionDelMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data completion:(void (^)(NSError *error))block{
    return [_roomMgr delMsg:msgName ID:msgID To:toID Data:data completion:block];
}

- (void)sessionEvictUser:(NSString*)peerID completion:(void (^)(NSError *error))block{
    return [_roomMgr evictUser:peerID completion:block];
}


//WebRTC & Media

- (void)sessionSelectCameraPosition:(BOOL)isFront{
    return [_roomMgr selectCameraPosition:isFront];
}

- (BOOL)sessionIsVideoEnabled{
    return [_roomMgr isVideoEnabled];
}

- (void)sessionEnableVideo:(BOOL)enable{
    return [_roomMgr enableVideo:enable];
}

- (BOOL)sessionIsAudioEnabled{
    return [_roomMgr isAudioEnabled];
}

- (void)sessionEnableAudio:(BOOL)enable{
    return [_roomMgr enableAudio:enable];
}

-(void)sessionUseLoudSpeaker:(BOOL)use{
    return [_roomMgr useLoudSpeaker:use];
}
#pragma mark room manager delegate

//1自己进入课堂
- (void)roomManagerRoomJoined:(NSError *)error {
  
    
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerRoomJoined:)]) {
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerRoomJoined:error];
        
    }
    if (_iEduEnterClassRoomDelegate && [_iEduEnterClassRoomDelegate respondsToSelector:@selector(joinRoomComplete)]) {
        [(id<TKEduEnterClassRoomDelegate>)_iEduEnterClassRoomDelegate  joinRoomComplete];
        
    }
    
    NSLog(@"roomManagerRoomJoined %@", error);
        
 
    
   
}
//2自己离开课堂
- (void)roomManagerRoomLeft {
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerRoomLeft)]) {
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerRoomLeft];
        
    }
    if (_iEduEnterClassRoomDelegate && [_iEduEnterClassRoomDelegate respondsToSelector:@selector(leftRoomComplete)]) {
        [(id<TKEduEnterClassRoomDelegate>)_iEduEnterClassRoomDelegate  leftRoomComplete];
        
    }
   // NSLog(@"roomManagerRoomLeft");
}
// 被踢
- (void)roomManagerSelfEvicted{
    //classbegin
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerSelfEvicted)]) {
        //[_iEduClassRoomSessionDelegate eduClassRoomSessionManagerOnRemoteMsg:add ID:msgID Name:msgName TS:ts Data:data];
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerSelfEvicted];
        
    }
    if (_iEduEnterClassRoomDelegate && [_iEduEnterClassRoomDelegate respondsToSelector:@selector(onKitout:)]) {
        
        [(id<TKEduEnterClassRoomDelegate>)_iEduEnterClassRoomDelegate onKitout:EKickOutReason_Repeat];
        
    }
    
    
}
//3观看视频
- (void)roomManagerUserPublished:(RoomUser *)user {
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerUserPublished:)]) {
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerUserPublished:user];
        
    }
   
}
//4取消视频
- (void)roomManagerUserUnpublished:(RoomUser *)user {
    
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerUserUnpublished:)]) {
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerUserUnpublished:user];
        
    }
    
}

//5用户进入
- (void)roomManagerUserJoined:(RoomUser *)user InList:(BOOL)inList {
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerUserJoined:InList:)]) {
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerUserJoined:user InList:inList];
        
    }
    
}

//6用户离开
- (void)roomManagerUserLeft:(RoomUser *)user {
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerUserLeft:)]) {
        
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerUserLeft:user];
        
    }
   
}
//7用户信息变化
- (void)roomManagerUserChanged:(RoomUser *)user Properties:(NSDictionary*)properties{
    
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerUserChanged:Properties:)]) {
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerUserChanged:user Properties:properties];
        
    }
    
}

//8聊天信息
- (void)roomManagerMessageReceived:(NSString *)message ofUser:(RoomUser *)user {
    
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerMessageReceived:ofUser:)]) {
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerMessageReceived:message ofUser:user];
        
    }
   
    
}

//9进入会议失败
- (void)roomManagerDidFailWithError:(NSError *)error {
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerDidFailWithError:)]) {
        [(id<TKEduClassRoomSessionDelegate>)_iEduClassRoomSessionDelegate eduClassRoomSessionManagerDidFailWithError:error];
        
    }
    if (_iEduEnterClassRoomDelegate && [_iEduEnterClassRoomDelegate respondsToSelector:@selector(onEnterRoomFailed:Description:)]) {
        
        [(id<TKEduEnterClassRoomDelegate>)_iEduEnterClassRoomDelegate onEnterRoomFailed:(int)error.code Description:error.description];
        
        
    }
    NSLog(@"roomManagerDidFailWithError %@", error);
}
//10白板等相关信令
- (void)roomManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data {
    //classbegin
    if (_iEduClassRoomSessionDelegate && [_iEduClassRoomSessionDelegate respondsToSelector:@selector(eduClassRoomSessionManagerOnRemoteMsg:ID:Name:TS:Data:)]) {
        [(id<TKEduClassRoomSessionDelegate>) _iEduClassRoomSessionDelegate eduClassRoomSessionManagerOnRemoteMsg:add ID:msgID Name:msgName TS:ts Data:data];
        
    }
    //会议开始或者结束
    if ([msgName isEqualToString:sClassBegin]) {
          if (add) {
              
              if (_iEduEnterClassRoomDelegate && [_iEduEnterClassRoomDelegate respondsToSelector:@selector(onClassBegin)]) {
                  
                  [(id<TKEduEnterClassRoomDelegate>)_iEduEnterClassRoomDelegate onClassBegin];
                  
              }
          }else{
              
              if (_iEduEnterClassRoomDelegate && [_iEduEnterClassRoomDelegate respondsToSelector:@selector(onClassDismiss)]) {
                  [(id<TKEduEnterClassRoomDelegate>)_iEduEnterClassRoomDelegate onClassDismiss];
                  
              }
          }
       
       
    }
  


}
/*
-(void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition,
                            NSURLCredential * _Nullable))completionHandler {
    
    // 如果使用默认的处置方式，那么 credential 就会被忽略
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:
         NSURLAuthenticationMethodServerTrust]) {
        
        //调用自定义的验证过程
        if (self.test_server) {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            if (credential) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            }
        } else {
             无效的话，取消
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}
 
 
 
 
 http://www.jianshu.com/p/69f64a3ae1d7 Error Domain=NSURLErrorDomain Code=-999 "cancelled"
 https://segmentfault.com/a/1190000007717594 iOS Error Domain=NSURLErrorDomain Code=-999 "cancelled" 解决办法
 
 
 
 
 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 // https ssl 验证。
 [manager setSecurityPolicy:[self customSecurityPolicy]];
 
  // https ssl 验证函数
 + (AFSecurityPolicy *)customSecurityPolicy {
 // 先导入证书 证书由服务端生成，具体由服务端人员操作
 NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"cer"];//证书的路径
 NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
 
 // AFSSLPinningModeCertificate 使用证书验证模式
 AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
 // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
 // 如果是需要验证自建证书，需要设置为YES
 securityPolicy.allowInvalidCertificates = YES;
 
 //validatesDomainName 是否需要验证域名，默认为YES;
 //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
 //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
 //如置为NO，建议自己添加对应域名的校验逻辑。
 securityPolicy.validatesDomainName = NO;
 
 securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
 
 return securityPolicy;
 }
 
 其中https.cer制作方法如下：
 向服务器要配置服务器https时生成的server.crt 文件
 然后在命令行输入命令 ：
 openssl x509 -in server.crt -out client.cer -outform der
 将生成 的.cer 文件导入你的工程（直接拖入即可）
 
 
 
 
 
 - (void)testATS {
 //先导入证书，找到证书的路径
 NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"cer"];
 NSData *certData = [NSData dataWithContentsOfFile:cerPath];
 
 //AFSSLPinningModeNone 这个模式表示不做 SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书，这里是不会通过的。
 //AFSSLPinningModeCertificate 这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名/有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
 //AFSSLPinningModePublicKey 这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝，只是验证时只验证证书里的公钥，不验证证书的有效期等信息。只要公钥是正确的，就能保证通信不会被窃听，因为中间人没有私钥，无法解开通过公钥加密的数据。
 
 AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
 if (certData) {
 securityPolicy.pinnedCertificates = @[certData];
 }
 AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
 [sessionManager setSecurityPolicy:securityPolicy];
 sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
 sessionManager.responseSerializer.acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
 
 NSString *urlStr = @"https://huifang.tech/info.php";
 [sessionManager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
 DDLog(@"responseObject = %@", responseObject);
 } failure:^(NSURLSessionDataTask *task, NSError *error) {
 DDLog(@"error = %@", error);
 }];
 }
 
 因为之前使用了 AFSSLPinningModeCertificate 模式
 AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
 改成现在的 AFSSLPinningModeNone 模式，解决问题。
 因为我的证书是 Symantec 的 DV SSL 证书，所以 securityPolicy 的 allowInvalidCertificates 和 validatesDomainName 属性都是默认值😁。自签的还没试过。
 
*/

#pragma mark 其他
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
#pragma mark 获取摄像头失败
-(void)callCameroError{
    if (_iEduEnterClassRoomDelegate && [_iEduEnterClassRoomDelegate respondsToSelector:@selector(onCameraDidOpenError)]) {
        
        [(id<TKEduEnterClassRoomDelegate>) _iEduEnterClassRoomDelegate onCameraDidOpenError];
        
        
        
    }
}
@end

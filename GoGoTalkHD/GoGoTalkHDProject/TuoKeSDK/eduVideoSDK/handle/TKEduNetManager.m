//
//  TKEduClassRoomNetWorkManager.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduNetManager.h"
#import "TKAFNetworking.h"
#import "TKMacro.h"
#import "TKGTMBase64.h"
#import "TKUtil.h"
#import "TKEduSessionHandle.h"
#import "TKEduRoomProperty.h"
#import "RoomUser.h"
//192.168.0.66:81/379057693
#define INTERFACE @"/ClientAPI/"
#define HTTP_SERVER     @"192.168.0.66"
#define MEETING_PORT     81
#define TEST_HTTP       @"http://" HTTP_SERVER INTERFACE
static int req = 1000;
static NSString * const FORM_FLE_INPUT = @"filedata";

extern int expireSeconds;

@interface TKEduNetManager ()<NSURLSessionDataDelegate>
@property (nonatomic ,copy)bCheckRoomdidComplete aCheckMeetingDidComplete;
@property (nonatomic ,copy)bCheckRoomError aCheckMeetingError;
@property (nonatomic, weak) id<TKEduNetWorkDelegate> iRequestDelegate;
@end

@implementation TKEduNetManager
+(instancetype )shareInstance{
    
    static TKEduNetManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      singleton = [[TKEduNetManager alloc] init];
                  });
    
    return singleton;
}
#pragma mark checkRoom
+(void)checkRoom:(NSDictionary *_Nonnull)aParam  aDidComplete:(bCheckRoomdidComplete _Nullable )aDidComplete aNetError:(bCheckRoomError _Nullable) aNetError {
    [[self shareInstance]checkRoom:aParam aDidComplete:aDidComplete aNetError:aNetError];
    
}

-(void)checkRoom:(NSDictionary *_Nonnull)aParam  aDidComplete:(bCheckRoomdidComplete _Nullable )aDidComplete aNetError:(bCheckRoomError _Nullable) aNetError{
    //1。创建管理者对象
    TKAFHTTPSessionManager *manager = [TKAFHTTPSessionManager manager];
    manager.responseSerializer = [TKAFHTTPResponseSerializer serializer];
    //    manager.baseURL.scheme = @"https";
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",@"image/jpeg",
                                                                              @"image/*"]];
    
    manager.requestSerializer = [TKAFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    // https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 60;
    
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    __block NSURLSessionDataTask *session = nil;
    _aCheckMeetingDidComplete  = aDidComplete;
    _aCheckMeetingError       = aNetError;
    NSString *tPassword = @"";
    NSString *tHost = [aParam objectForKey:@"host"]?[aParam objectForKey:@"host"]:sHost;
    NSString *tPort= [aParam objectForKey:@"port"]?[aParam objectForKey:@"port"]:sPort;
    session =   [manager POST:[NSString stringWithFormat:@"%@://%@:%@/ClientAPI/checkroom",sHttp,tHost ,tPort] parameters: aParam progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        do
        {
            if (responseObject == nil)
                break;
            if ([responseObject isKindOfClass:[NSData class]]){
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if (aDidComplete) {
                    aDidComplete(json,tPassword);
                }
            }
            
            
        }while(0);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (aNetError) {
            aNetError(error);
        }
        NSLog(@"-----------%@",error.description);
    }];
    [session resume];
}



#pragma mark 礼物数量
+(void)getGiftinfo:(NSString *_Nonnull)aRoomId aParticipantId:(NSString *_Nonnull)aParticipantId aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aGetGifInfoComplete:(bGetGifInfoComplete _Nullable )aGetGifInfoComplete aGetGifInfoError:(bGetGifInfoError _Nullable)aGetGifInfoError{
    
     [[self shareInstance]getGiftLinfo:aRoomId aParticipantId:aParticipantId aHost:aHost aPort:aPort aGetGifInfoComplete:aGetGifInfoComplete aGetGifInfoError:aGetGifInfoError];
    
}
-(void)getGiftLinfo:(NSString *_Nonnull)aRoomId aParticipantId:(NSString *_Nonnull)aParticipantId aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aGetGifInfoComplete:(bGetGifInfoComplete _Nullable )aGetGifInfoComplete aGetGifInfoError:(bGetGifInfoError _Nullable)aGetGifInfoError{
    
   
   // NSDictionary *tParamDic = @{@"serial":aRoomId,@"receiveid":aParticipantId};
    NSDictionary *tParamDic = @{@"serial":aRoomId};
    //1。创建管理者对象
    TKAFHTTPSessionManager *manager = [TKAFHTTPSessionManager manager];
    manager.responseSerializer = [TKAFHTTPResponseSerializer serializer];
    //    manager.baseURL.scheme = @"https";
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",@"image/jpeg",
                                                                              @"image/*"]];
    
    manager.requestSerializer = [TKAFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    // https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 60;
    
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    __block NSURLSessionDataTask *session = nil;

    session = [manager GET:[NSString stringWithFormat:@"%@://%@:%@/ClientAPI/getgiftinfo",sHttp,aHost ,aPort] parameters:tParamDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        do
        {
            if (responseObject == nil)
                break;
            if ([responseObject isKindOfClass:[NSData class]]){
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if (aGetGifInfoComplete) {
                    aGetGifInfoComplete(json);
                    
                }
            }
            
            
        }while(0);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (aGetGifInfoError) {
            aGetGifInfoError(error);
        }
    }];
    
    [session resume];
    
    
}
#pragma mark 请求礼物

+(void)sendGifForRoomUser:(NSArray *)aRoomUserArray  roomID:(NSString * _Nonnull )roomID   aMySelf:(RoomUser *_Nonnull)aMySelf aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aSendComplete:(bSendGifInfoComplete _Nonnull )aSendComplete aNetError:(bError _Nullable) aNetError{
    
    [[self shareInstance] sendGifForRoomUser:aRoomUserArray roomID:roomID aMySelf:aMySelf aHost:aHost aPort:aPort aSendComplete:aSendComplete aNetError:aNetError];
    
}

-(void)sendGifForRoomUser:(NSArray *)aRoomUserArray  roomID:(NSString * _Nonnull )roomID   aMySelf:(RoomUser *_Nonnull)aMySelf aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aSendComplete:(bSendGifInfoComplete _Nonnull )aSendComplete aNetError:(bError _Nullable) aNetError{
    
    NSMutableDictionary *tParamDic = @{@"serial":roomID,@"sendid":aMySelf.peerID,@"sendname":aMySelf.nickName}.mutableCopy;
    NSMutableDictionary *tJS = [[NSMutableDictionary alloc]initWithCapacity:10];
    for (RoomUser *aRoomUser in aRoomUserArray) {
        [tJS setObject:aRoomUser.nickName forKey:aRoomUser.peerID];
        
    }
    [tParamDic setObject:tJS forKey:@"receivearr"];
    
    //1。创建管理者对象
    TKAFHTTPSessionManager *manager = [TKAFHTTPSessionManager manager];
    manager.responseSerializer = [TKAFHTTPResponseSerializer serializer];
    //    manager.baseURL.scheme = @"https";
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",@"image/jpeg",
                                                                              @"image/*"]];
    
    manager.requestSerializer = [TKAFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    // https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 60;
    
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    __block NSURLSessionDataTask *session = nil;
    
    session =   [manager GET:[NSString stringWithFormat:@"%@://%@:%@/ClientAPI/sendgift",sHttp,aHost ,aPort] parameters: tParamDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        do
        {
            if (responseObject == nil)
                break;
            if ([responseObject isKindOfClass:[NSData class]]){
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                int result = [[json objectForKey:@"result"]intValue];
                
                if (!result ) {
                    if (aSendComplete) {
                        aSendComplete(json);
                        
                    }
                }
                
            }
            
            
        }while(0);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (aNetError) {
            aNetError(error);
        }
        NSLog(@"-----------%@",error.description);
    }];
    [session resume];
}


#pragma mark 翻译
+(void)translation:(NSString * _Nonnull )aTranslationString aTranslationComplete:(bTranslationComplete _Nonnull )aTranslationComplete{
    
    [[self shareInstance]translation:aTranslationString aTranslationComplete:aTranslationComplete];
}
-(void)translation:(NSString * _Nonnull )aTranslationString aTranslationComplete:(bTranslationComplete _Nonnull )aTranslationComplete{
   
   unichar ch = [aTranslationString characterAtIndex:0];
    NSString *tTo = @"zh";
    NSString *tFrom = @"en";
    
    if (IS_CH_SYMBOL(ch)) {
        tFrom = @"zh";
        tTo = @"en";
    }
    
    NSNumber *tSaltNumber = @(arc4random());
    // APP_ID + query + salt + SECURITY_KEY;
     NSString *tSign =[TKUtil md5HexDigest:[NSString stringWithFormat:@"%@%@%@%@",sAPP_ID,aTranslationString,tSaltNumber,sSECURITY_KEY]];
    NSDictionary *tParamDic = @{@"appid":sAPP_ID,@"q":aTranslationString,@"from":tFrom,@"to":tTo,@"salt":tSaltNumber,@"sign":tSign};
    
    
    //1。创建管理者对象
    TKAFHTTPSessionManager *manager = [TKAFHTTPSessionManager manager];
    manager.responseSerializer = [TKAFHTTPResponseSerializer serializer];
    //    manager.baseURL.scheme = @"https";
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",@"image/jpeg",
                                                                              @"image/*"]];
    
    manager.requestSerializer = [TKAFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    // https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 60;
    
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    __block NSURLSessionDataTask *session = nil;
 
    session =   [manager GET:sTRANS_API_HOST parameters: tParamDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        do
        {
            if (responseObject == nil)
                break;
            if ([responseObject isKindOfClass:[NSData class]]){
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
                int result = [[json objectForKey:@"result"]intValue];
                
                if (!result ) {
                    NSArray *tRanslationArray = [json objectForKey:@"trans_result"];
                    NSDictionary *tRanslationDic = [tRanslationArray firstObject];
                    if (aTranslationComplete) {
                        aTranslationComplete(json,[tRanslationDic objectForKey:@"dst"]);
                    }
                }
               
            }
            
            
        }while(0);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_aCheckMeetingError) {
            _aCheckMeetingError(error);
        }
        NSLog(@"-----------%@",error.description);
    }];
    [session resume];
}


#pragma mark doc

+(void)delRoomFile:(NSString * _Nonnull )roomID docid:(NSString *)docid isMedia:(bool)isMedia    aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aDelComplete:(bComplete _Nonnull )aDelComplete aNetError:(bError _Nullable) aNetError{
    
    [[self shareInstance]delRoomFile:roomID docid:docid isMedia:isMedia   aHost:aHost aPort:aPort aDelComplete:aDelComplete aNetError:aNetError];
}




-(void)delRoomFile:(NSString * _Nonnull )roomID docid:(NSString *)docid isMedia:(bool)isMedia   aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aDelComplete:(bComplete _Nonnull )aDelComplete aNetError:(bError _Nullable) aNetError
{


    NSDictionary *tParamDic = @{@"serial":roomID,@"fileid":docid};
    //1。创建管理者对象
    TKAFHTTPSessionManager *manager = [TKAFHTTPSessionManager manager];
    manager.responseSerializer = [TKAFHTTPResponseSerializer serializer];
    //    manager.baseURL.scheme = @"https";
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",@"image/jpeg",
                                                                              @"image/*"]];
    
    manager.requestSerializer = [TKAFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    // https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 60;
    
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    __block NSURLSessionDataTask *session = nil;

    session =   [manager GET:[NSString stringWithFormat:@"%@://%@:%@/ClientAPI/delroomfile",sHttp,aHost ,aPort] parameters: tParamDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        do
        {
            if (responseObject == nil)
                break;
            if ([responseObject isKindOfClass:[NSData class]]){
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
               
                int result = [[json objectForKey:@"result"]intValue];
                
                if (!result ) {
                    if (aDelComplete) {
                        aDelComplete(json);
                    }
                }
                
            }
            
            
        }while(0);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (aNetError) {
            aNetError(error);
        }
        NSLog(@"-----------%@",error.description);
    }];
    [session resume];
}
#pragma mark 下课
+(void)classBeginEnd:(NSString * _Nonnull )roomID companyid:(NSString *)companyid  aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aComplete:(bComplete _Nonnull )aComplete aNetError:(bError _Nullable) aNetError{
    
    [[self shareInstance]classBeginEnd:roomID companyid:companyid  aHost:aHost aPort:aPort aComplete:aComplete aNetError:aNetError];
}




-(void)classBeginEnd:(NSString * _Nonnull )roomID companyid:(NSString *)companyid aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aComplete:(bComplete _Nonnull )aComplete aNetError:(bError _Nullable) aNetError
{
    NSDictionary *tParamDic;
    if ([TKEduSessionHandle shareInstance].roomMgr.autoQuitClassWhenClassOverFlag == YES) {
        tParamDic = @{@"serial":roomID,@"act":@(3),@"companyid":companyid,@"endsign":@(1)};         // 英练帮需要结束课堂
    } else {
        tParamDic = @{@"serial":roomID,@"act":@(3),@"companyid":companyid};
    }
    
    //1。创建管理者对象
    TKAFHTTPSessionManager *manager = [TKAFHTTPSessionManager manager];
    manager.responseSerializer = [TKAFHTTPResponseSerializer serializer];
    //    manager.baseURL.scheme = @"https";
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",@"image/jpeg",
                                                                              @"image/*"]];
    
    manager.requestSerializer = [TKAFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    // https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 60;
    
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    __block NSURLSessionDataTask *session = nil;
    
    session =   [manager GET:[NSString stringWithFormat:@"%@://%@:%@/ClientAPI/roomover",sHttp,aHost ,aPort] parameters: tParamDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        do
        {
            if (responseObject == nil)
                break;
            if ([responseObject isKindOfClass:[NSData class]]){
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                int result = [[json objectForKey:@"result"]intValue];
                
//                if (!result ) {
//                    if (aComplete) {
//                        aComplete(json);
//                    }
//                }
                
                aComplete(nil);         // 无需关心返回值，直接下课
            }
            
            
        }while(0);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (aNetError) {
            aNetError(error);
        }
        NSLog(@"-----------%@",error.description);
    }];
    [session resume];
}



#pragma mark 上课
+(void)classBeginStar:(NSString * _Nonnull )roomID companyid:(NSString *)companyid  aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aComplete:(bComplete _Nonnull )aComplete  aNetError:(bError _Nullable) aNetError{
    
    [[self shareInstance]classBeginStar:roomID companyid:companyid  aHost:aHost aPort:aPort aComplete:aComplete aNetError:aNetError];
}




-(void)classBeginStar:(NSString * _Nonnull )roomID companyid:(NSString *)companyid aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aComplete:(bComplete _Nonnull )aComplete aNetError:(bError _Nullable) aNetError
{
    NSDictionary *tParamDic;
    
    if ([[TKEduSessionHandle shareInstance].roomMgr.companyId isEqualToString:YLB_COMPANYID]) {
        tParamDic = @{@"serial":roomID,@"companyid":companyid};
    } else {
        //tParamDic = @{@"serial":roomID,@"companyid":companyid, @"expiresabs":@(expireSeconds)};
        tParamDic = @{@"serial":roomID,@"companyid":companyid};
    }
    
    //1。创建管理者对象
    TKAFHTTPSessionManager *manager = [TKAFHTTPSessionManager manager];
    manager.responseSerializer = [TKAFHTTPResponseSerializer serializer];
    //    manager.baseURL.scheme = @"https";
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",@"image/jpeg",
                                                                              @"image/*"]];
    
    manager.requestSerializer = [TKAFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    // https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 60;
    
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    __block NSURLSessionDataTask *session = nil;

    session =   [manager GET:[NSString stringWithFormat:@"%@://%@:%@/ClientAPI/roomstart",sHttp,aHost ,aPort] parameters: tParamDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        do
        {
            if (responseObject == nil)
                break;
            if ([responseObject isKindOfClass:[NSData class]]){
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                int result = [[json objectForKey:@"result"]intValue];
                
//                if (!result ) {
//                    if (aComplete) {
//                        aComplete(json);
//                    }
//                }
                
                aComplete(nil);         // 无需关心返回值是什么，直接上课
                
            }
            
            
        }while(0);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (aNetError) {
            aNetError(error);
        }
        NSLog(@"-----------%@",error.description);
    }];
    [session resume];
}


#pragma mark 其他
- (int)uploadWithRequestURL:(NSString*)requestURL meetingID:(int)meetingid fileData:(NSData *)fileData fileName:(NSString *)fileName userName:(NSString *)userName
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    NSMutableData *myRequestData=[NSMutableData data];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSMutableString *body=[[NSMutableString alloc]init];
    NSDictionary *dataDic = @{@"serial" : @(meetingid),
                              @"sender" : userName,
                              @"conversion" : @1,
                              @"alluser" : @1};
    for (NSString *key in dataDic.allKeys)
    {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",dataDic[key]];
    }
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", FORM_FLE_INPUT,fileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpge, image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if (fileData) {
        [myRequestData appendData:fileData];
    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc] initWithFormat:@"\r\n%@",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_iRequestDelegate && [_iRequestDelegate respondsToSelector:@selector(uploadFileResponse:req:)]) {
                    NSDictionary *tResponseDic = @{@"result":@(-1)};
                    [_iRequestDelegate uploadFileResponse:tResponseDic req:req];
                }
            });
        }else{
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (json) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_iRequestDelegate && [_iRequestDelegate respondsToSelector:@selector(uploadFileResponse:req:)]) {
                        [_iRequestDelegate uploadFileResponse:json req:req];
                    }
                });
            }
        }
        
    }];
    req++;
    [dataTask resume];
    return req;
}

- (void)getmeetingfile:(int)meetingid requestURL:(NSString *)requestURL
{
    NSURL *url = [NSURL URLWithString:requestURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSDictionary *post = @{@"serial" : @(meetingid)};
    
    NSMutableString * postString = [[NSMutableString alloc] init];
    if (post && [post isKindOfClass:[NSDictionary class]])
    {
        for (id key in [post allKeys])
        {
            [postString appendFormat:@"%@=%@&", key, [post objectForKey:key]];
        }
        [postString deleteCharactersInRange:NSMakeRange([postString length] - 1, 1)];
    }
    //将请求参数字符串转成NSData类型
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id json = nil;
        if (data) {
            json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
        if (json) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_iRequestDelegate && [_iRequestDelegate respondsToSelector:@selector(getMeetingFileResponse:)]) {
                    [_iRequestDelegate getMeetingFileResponse:json];
                }
            });
        }
    }];
    //req++;
    [dataTask resume];
}




// https ssl 验证函数
- (TKAFSecurityPolicy *)customSecurityPolicy {
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"cer"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    TKAFSecurityPolicy *securityPolicy = [TKAFSecurityPolicy policyWithPinningMode:TKAFSSLPinningModeNone];
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


#pragma mark NSURLSessionDataDelegate
// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // NSURLSession在接收到响应的时候要先对响应做允许处理:completionHandler(NSURLSessionResponseAllow);,才会继续接收服务器返回的数据,进入后面的代理方法.值得一提的是,如果在接收响应的时候需要对返回的参数进行处理(如获取响应头信息等),那么这些处理应该放在前面允许操作的前面.
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
    
    
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    
    
    
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if (_iRequestDelegate && [_iRequestDelegate respondsToSelector:@selector(uploadProgress:totalBytesSent:bytesTotal:)]) {
        [_iRequestDelegate uploadProgress:req totalBytesSent:totalBytesSent bytesTotal:totalBytesExpectedToSend];
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
@end

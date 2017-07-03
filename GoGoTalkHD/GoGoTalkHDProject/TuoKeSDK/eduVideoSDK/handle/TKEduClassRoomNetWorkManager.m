//
//  TKEduClassRoomNetWorkManager.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduClassRoomNetWorkManager.h"
#import "TKAFNetworking.h"
#import "TKMacro.h"
#import "TKGTMBase64.h"
#import "TKUtil.h"
//192.168.0.66:81/379057693
#define INTERFACE @"/ClientAPI/"
#define HTTP_SERVER     @"192.168.0.66"
#define MEETING_PORT     81
//#define HTTP_SERVER     @"www.weiyicloud.net"
//#define MEETING_PORT     443
#define TEST_HTTP       @"http://" HTTP_SERVER INTERFACE


@interface TKEduClassRoomNetWorkManager ()<NSURLSessionDataDelegate>
@property (nonatomic ,copy)bCheckRoomdidComplete aCheckMeetingDidComplete;
@property (nonatomic ,copy)bCheckRoomError aCheckMeetingError;
@end

@implementation TKEduClassRoomNetWorkManager
+(instancetype )shareTKEduClassRoomNetWorkManagerInstance{
    
    static TKEduClassRoomNetWorkManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      singleton = [[TKEduClassRoomNetWorkManager alloc] init];
                  });
    
    return singleton;
}
+(void)checkRoom:(NSString *_Nonnull)aRoomId aPwd:(NSString *_Nonnull)aPwd aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aUserID:(NSString *_Nonnull)aUserID aDidComplete:(bCheckRoomdidComplete _Nullable )aDidComplete aNetError:(bCheckRoomError _Nullable) aNetError {
    [[self shareTKEduClassRoomNetWorkManagerInstance]checkRoom:aRoomId aPwd:aPwd aHost:aHost aPort:aPort aUserID:aUserID aDidComplete:aDidComplete aNetError:aNetError];
    
}



-(void)checkRoom:(NSString *_Nonnull)aRoomId aPwd:(NSString *_Nonnull)aPwd aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aUserID:(NSString *_Nonnull)aUserID aDidComplete:(bCheckRoomdidComplete _Nullable  )aDidComplete aNetError:(bCheckRoomError _Nullable) aNetError{

    if (!aPwd || [aPwd isEqualToString:@""]) {
        aPwd = @"0";
    }
    if (!aUserID || [aPwd isEqualToString:@""]) {
        aUserID = @"0";
    }
    
//    NSDictionary *tParamDic = @{@"serial":aRoomId,@"password":aPwd,@"userid":aUserID};
//    NSDictionary *tParamDic = @{@"serial":aRoomId,@"password":aPwd,@"userid":aUserID};
    NSDictionary *tParamDic = @{@"serial":aRoomId,@"password":aPwd};
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
    _aCheckMeetingDidComplete = aDidComplete;
    _aCheckMeetingError = aNetError;
    session =   [manager POST:[NSString stringWithFormat:@"%@://%@:%@/ClientAPI/checkroom",sHttp,aHost ,aPort] parameters: tParamDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      
        do
        {
            if (responseObject == nil)
                break;
            if ([responseObject isKindOfClass:[NSData class]]){
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
               
                if (_aCheckMeetingDidComplete) {
                    _aCheckMeetingDidComplete(json,aPwd);
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
#pragma mark 礼物数量
+(void)getGiftinfo:(NSString *_Nonnull)aRoomId aParticipantId:(NSString *_Nonnull)aParticipantId aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aGetGifInfoComplete:(bGetGifInfoComplete _Nullable )aGetGifInfoComplete aGetGifInfoError:(bGetGifInfoError _Nullable)aGetGifInfoError{
    
     [[self shareTKEduClassRoomNetWorkManagerInstance]getGiftLinfo:aRoomId aParticipantId:aParticipantId aHost:aHost aPort:aPort aGetGifInfoComplete:aGetGifInfoComplete aGetGifInfoError:aGetGifInfoError];
    
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
#pragma mark 翻译
+(void)translation:(NSString * _Nonnull )aTranslationString aTranslationComplete:(bTranslationComplete _Nonnull )aTranslationComplete{
    
    [[self shareTKEduClassRoomNetWorkManagerInstance]translation:aTranslationString aTranslationComplete:aTranslationComplete];
}
-(void)translation:(NSString * _Nonnull )aTranslationString aTranslationComplete:(bTranslationComplete _Nonnull )aTranslationComplete{
   
   unichar ch = [aTranslationString characterAtIndex:0];
    NSString *tTo = @"zh";
    NSString *tFrom = @"en";
    
    if (!IS_CH_SYMBOL(ch)) {
        tFrom = @"auto";
        tTo = @"zh";
    }
    
    NSNumber *tSaltNumber = @(arc4random());
    // APP_ID + query + salt + SECURITY_KEY;
     NSString *tSign =[TKUtil md5HexDigest:[NSString stringWithFormat:@"%@%@%@%@",sAPP_ID,aTranslationString,tSaltNumber,sSECURITY_KEY]];
    //NSString *tSign =[ TKGTMBase64 TK_md5_base64:[NSString stringWithFormat:@"%@%@%@%@",sAPP_ID,aTranslationString,tSaltNumber,sSECURITY_KEY]];
    
    
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
                /*
                 //                    int nRet = response.getInt("result");
                 JSONArray arr = response.optJSONArray("trans_result");
                 JSONObject resultObj = arr.optJSONObject(0);
                 String src = resultObj.optString("src");
                 String result = resultObj.optString("dst");
                 
                 */
                int result = [[json objectForKey:@"result"]intValue];
                
                if (!result ) {
//                    NSDictionary *tRanslationDic = [json objectForKey:@"trans_result"];
                    NSArray *tRanslationDic = [json objectForKey:@"trans_result"];
                    if (aTranslationComplete) {
//                        aTranslationComplete(json,[tRanslationDic objectForKey:@"dst"]);
                        aTranslationComplete(json,[tRanslationDic[0] objectForKey:@"dst"]);
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
@end

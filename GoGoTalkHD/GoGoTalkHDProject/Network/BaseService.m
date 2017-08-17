//
//  BaseService.m
//  GoGoTalkHD
//
//  Created by 辰 on 16/7/29.
//  Copyright © 2016年 Chn. All rights reserved.
//

#import "BaseService.h"

// 自定义的code
//static NSInteger const kErrorCode_1001 = 1001;
//static NSInteger const kErrorCode_1002 = 1002;


@interface BaseService()
@property (nonatomic, assign) BOOL isShowMBP;
@end

@implementation BaseService

+ (instancetype)share {
    static BaseService *shareInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

+ (AFHTTPSessionManager *)sharedHTTPSession {
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10.f;
        
    });
    return manager;
}


- (instancetype)init
{
    if (self = [super init]) {
        
        GGT_Singleton *singleton = [GGT_Singleton sharedSingleton];
        
        // 1. 获得网络监控管理者
        AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
        
        // 2. 设置网络状态改变后的处理
        [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            // 当网络状态改变了, 就会调用这个block
            switch (status) {
                case AFNetworkReachabilityStatusUnknown: // 未知网络
                    self.netWorkStaus = AFNetworkReachabilityStatusUnknown;
                    singleton.netStatus = NO;
                    
                    [self xc_reloadBaseURL];
#ifdef DEBUG
                    [self showExceptionDialog:@"未知网络"];
#endif
                    
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                {
                    self.netWorkStaus = AFNetworkReachabilityStatusNotReachable;
                    singleton.netStatus = NO;
                    [self showExceptionDialog:@"没有网络(断网)"];
                    
                    
                    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"没有网络" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertV show];
                    
                }
                    
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                    self.netWorkStaus = AFNetworkReachabilityStatusReachableViaWWAN;
                    singleton.netStatus = YES;
                    
                    [self xc_reloadBaseURL];
                    
#ifdef DEBUG
                    [self showExceptionDialog:@"手机自带网络"];
#endif
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                    self.netWorkStaus = AFNetworkReachabilityStatusReachableViaWiFi;
                    singleton.netStatus = YES;
                    
                    [self xc_reloadBaseURL];
                    
#ifdef DEBUG
                    [self showExceptionDialog:@"WIFI"];
#endif
                    break;
            }
        }];
        
        // 3.开始监控
        [mgr startMonitoring];
        
    }
    return self;
}

// 当当断网的时候 再次重新打开WIFI时  重新获取BaseURL
- (void)xc_reloadBaseURL
{
    GGT_Singleton *single = [GGT_Singleton sharedSingleton];
    NSString *url = [NSString stringWithFormat:@"%@?Version=v%@", URL_GetUrl, APP_VERSION()];
    [[BaseService share] sendGetRequestWithPath:url token:NO viewController:nil showMBProgress:NO success:^(id responseObject) {
        
        single.base_url = responseObject[@"data"];
        if ([single.base_url isEqualToString:BASE_REQUEST_URL]) {
            single.isAuditStatus = YES;
        }
        
    } failure:^(NSError *error) {
//        single.base_url = BASE_REQUEST_URL;
        // 暂时开启测试地址
        NSString *url = [NSString stringWithFormat:@"%@:9332", BASE_REQUEST_URL];
        single.base_url = url;
        single.isAuditStatus = NO;
    }];
}

#pragma mark - public method
#pragma mark 不带 参数加密
- (void)requestWithPath:(NSString *)urlStr
                 method:(NSInteger)method
             parameters:(id)parameters
                  token:(BOOL)isLoadToken
         viewController:(UIViewController *)viewController
                success:(AFNSuccessResponse)success
                failure:(AFNFailureResponse)failure
{
    
    self.manager = [BaseService sharedHTTPSession];
    
    NSString *pinjieUrlStr = urlStr;
    
    
    GGT_Singleton *single = [GGT_Singleton sharedSingleton];
    
    urlStr = [single.base_url stringByAppendingPathComponent:urlStr];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //        NSLog(@"打印token----%@",[UserDefaults() objectForKey:K_userToken]);
    
    
    [MBProgressHUD hideHUDForView:viewController.view];
    
    
    if (self.isShowMBP) {
        [MBProgressHUD showLoading:viewController.view];
    }
    
    
    switch (method) {
        case XCHttpRequestGet:
        {
            
            self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"charset=utf-8", nil];
            
            if (isLoadToken == YES) {
                //可不写，但是不能写在判断外，否则会出错
                //self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                //在设置header头
                [self.manager.requestSerializer setValue:[UserDefaults() objectForKey:K_userToken] forHTTPHeaderField:@"Authorization"];
            }
            
            
            [self.manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [MBProgressHUD hideHUDForView:viewController.view];
                
                NSDictionary *dic = responseObject;
                if ([[dic objectForKey:xc_returnCode]integerValue] == 1)
                {
                    success(responseObject);
                    NSLog(@"%@-Get请求地址:\n%@---success日志:\n%@",[viewController class],urlStr,responseObject);
                    
                }
                else if ([[dic objectForKey:xc_returnCode]integerValue] == 1000) {
                    NSLog(@"%@-Get请求地址:\n%@---登陆过期日志:\n%@",[viewController class],urlStr,responseObject);
                    [self refreshToken:pinjieUrlStr method:method parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
                    
                    return ;
                    
                }
                else {
                    NSError *error;
                    if ([dic objectForKey:xc_returnMsg] && [dic objectForKey:xc_returnCode]) {
                        error = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:[dic objectForKey:xc_returnMsg], xc_returnCode:[dic objectForKey:xc_returnCode]}];
                    } else {
                        error = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1002 userInfo:@{xc_message:xc_alert_message}];
                    }
                    failure(error);
                    
                    NSLog(@"%@-Get请求地址:\n%@---success日志:\n%@",[viewController class],urlStr,error);
                    //                    NSDictionary *userInfoDic = error.userInfo;
                    //                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];

                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:viewController.view];
                failure(error);
                NSLog(@"%@-Get请求地址:\n%@---error日志:\n%@",[viewController class],urlStr,error);
                
#ifdef DEBUG
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1002 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                if (viewController) {
                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
                }
#else
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                if (viewController) {
                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
                }
#endif
                
            }];
        }
            break;
        case XCHttpRequestPost:
        {
            
            self.manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            
            if (isLoadToken == YES) {
                //在设置header头
                [self.manager.requestSerializer setValue:[UserDefaults() objectForKey:K_userToken] forHTTPHeaderField:@"Authorization"];
            }
            
            [self.manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [MBProgressHUD hideHUDForView:viewController.view];
                
                
                NSDictionary *dic = responseObject;
                if ([[dic objectForKey:xc_returnCode]integerValue] == 1)
                {
                    success(responseObject);
                    NSLog(@"%@-Post请求地址:\n%@---success日志:\n%@",[viewController class],urlStr,responseObject);
                    
                }
                else if ([[dic objectForKey:xc_returnCode]integerValue] == 1000) {
                    NSLog(@"%@-Post请求地址:\n%@---登陆过期日志:\n%@",[viewController class],urlStr,responseObject);
                    
                    [self refreshToken:pinjieUrlStr method:method parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
                    
                    return ;
                    
                }
                else {
                    NSError *error;
                    if ([dic objectForKey:xc_returnMsg] && [dic objectForKey:xc_returnCode]) {
                        error = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:[dic objectForKey:xc_returnMsg], xc_returnCode:[dic objectForKey:xc_returnCode]}];
                    } else {
                        error = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1002 userInfo:@{xc_message:xc_alert_message}];
                    }
                    
                    failure(error);
                    NSLog(@"%@-Post请求地址:\n%@---success日志:\n%@",[viewController class],urlStr,error);
                    
                    //                    NSDictionary *userInfoDic = error.userInfo;
                    //                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:viewController.view];
                
                failure(error);
                NSLog(@"%@-Post请求地址:\n%@---error日志:\n%@",[viewController class],urlStr,error);
                
                
#ifdef DEBUG
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1002 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                if (viewController) {
                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
                }
#else
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                if (viewController) {
                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
                }
#endif
                
            }];
        }
            break;
        case XCHttpRequestDelete:
        {
            [self.manager DELETE:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBProgressHUD hideHUDForView:viewController.view];
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:viewController.view];
                failure(error);
#ifdef DEBUG
                NSDictionary *userInfoDic = error.userInfo;
                [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
#else
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
#endif
            }];
        }
            break;
        case XCHttpRequestPut:
        {
            [self.manager PUT:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBProgressHUD hideHUDForView:viewController.view];
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:viewController.view];
                failure(error);
#ifdef DEBUG
                NSDictionary *userInfoDic = error.userInfo;
                [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
#else
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
#endif
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - POST 带MBP
- (void)sendPostRequestWithPath:(NSString *)url
                     parameters:(NSDictionary *)parameters
                          token:(BOOL)isLoadToken
                 viewController:(UIViewController *)viewController
                        success:(AFNSuccessResponse)success
                        failure:(AFNFailureResponse)failure
{
    self.isShowMBP = YES;
    [self requestWithPath:url method:XCHttpRequestPost parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
}

#pragma mark - GET 带MBP
- (void)sendGetRequestWithPath:(NSString *)url
                         token:(BOOL)isLoadToken
                viewController:(UIViewController *)viewController
                       success:(AFNSuccessResponse)success
                       failure:(AFNFailureResponse)failure
{
    self.isShowMBP = YES;
    [self requestWithPath:url method:XCHttpRequestGet parameters:nil token:isLoadToken viewController:viewController success:success failure:failure];
}

#pragma mark - POST 判断是否带MBP带MBP
- (void)sendPostRequestWithPath:(NSString *)url
                     parameters:(NSDictionary *)parameters
                          token:(BOOL)isLoadToken
                 viewController:(UIViewController *)viewController
                 showMBProgress:(BOOL)isShow
                        success:(AFNSuccessResponse)success
                        failure:(AFNFailureResponse)failure
{
    self.isShowMBP = isShow;
    [self requestWithPath:url method:XCHttpRequestPost parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
}

#pragma mark - GET 判断是否带MBP带MBP
- (void)sendGetRequestWithPath:(NSString *)url
                         token:(BOOL)isLoadToken
                viewController:(UIViewController *)viewController
                showMBProgress:(BOOL)isShow
                       success:(AFNSuccessResponse)success
                       failure:(AFNFailureResponse)failure
{
    self.isShowMBP = isShow;
    [self requestWithPath:url method:XCHttpRequestGet parameters:nil token:isLoadToken viewController:viewController success:success failure:failure];
}



#pragma mark - private method
#pragma mark 弹出网络错误提示框
- (void)showExceptionDialog:(NSString *)message
{
    NSLog(@"%@", message);
}

#pragma mark 弹出网络错误提示框2----暂时不用，替换成了MBProgressHUD
- (void)alertErrorMessage:(NSError *)error
{
    NSDictionary *userInfoDic = error.userInfo;
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:userInfoDic[xc_message] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertV show];
    
}

- (void)refreshToken:(NSString *)url method:(NSInteger)method parameters:(id)parameters token:(BOOL)isLoadToken viewController:(UIViewController *)viewController success:(AFNSuccessResponse)success
             failure:(AFNFailureResponse)failure{

    
    NSString *userName = [UserDefaults() objectForKey:@"phoneNumber"];
    
    NSString *password = [UserDefaults() objectForKey:@"password"];
    
    //如果都为空，退出到登录页
    if (IsStrEmpty(userName) || IsStrEmpty(password)) {
        [MBProgressHUD showMessage:@"登陆过期，请重新登录" toView:viewController.view];
        
        GGT_LoginViewController *loginVc = [[GGT_LoginViewController alloc]init];
        [UserDefaults() setObject:@"no" forKey:@"login"];
        [UserDefaults() setObject:@"" forKey:K_userToken];
        [UserDefaults() synchronize];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVc];
        viewController.view.window.rootViewController = nav;
        
        return;
    }
    
    
    NSDictionary *postDic = @{@"UserName":userName,@"PassWord":password,@"OrgLink":IsStrEmpty([UserDefaults() objectForKey:K_registerID])?@"":[UserDefaults() objectForKey:K_registerID]};
    
    //使用af原生请求，防止弹出MBProgressHUD动画。
    self.manager = [BaseService sharedHTTPSession];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    GGT_Singleton *single = [GGT_Singleton sharedSingleton];
    
    
    NSString *urlStr = [single.base_url stringByAppendingPathComponent:URL_Login];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [self.manager POST:urlStr parameters:postDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"result"] isEqual:@1]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UserDefaults() setObject:responseObject[@"data"][@"dicRes"][@"userToken"] forKey:K_userToken];
                [UserDefaults() setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"dicRes"][@"studentName"]] forKey:K_studentName];
                [UserDefaults() synchronize];
                
                //重新请求
                [self requestWithPath:url method:method parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


@end

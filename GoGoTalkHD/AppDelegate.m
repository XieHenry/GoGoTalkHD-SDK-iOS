//
//  AppDelegate.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/10.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import <Bugly/Bugly.h>
#import "GGT_LoginViewController.h"
#import "BaseNavigationController.h"
#import <AVFoundation/AVFoundation.h>
#import "GGT_HomeViewController.h"
#import <UMSocialCore/UMSocialCore.h>


#define kBuglyAppId      @"ab92f40c75"


//极光推送--GoGoHD
//测试版
static NSString *appKey = @"a78ae3e4b5af959cf01b2240";
static NSString *channel = @"Publish channel";
static BOOL isProduction = false;

//商店版
//static NSString *appKey = @"a78ae3e4b5af959cf01b2240";
//static NSString *channel = @"Publish channel";
//static BOOL isProduction = true;


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [self initKeyWindow];
    
    [self getBaseURLWithOptions:launchOptions];
    
    return YES;
}

/// 获取BaseURL
- (void)getBaseURLWithOptions:(NSDictionary *)launchOptions
{
    
    GGT_Singleton *single = [GGT_Singleton sharedSingleton];
    single.base_url = BASE_REQUEST_URL;
    
    [[BaseService share] sendGetRequestWithPath:URL_GetUrl token:NO viewController:nil showMBProgress:NO success:^(id responseObject) {
        
        single.base_url = responseObject[@"data"];
        [self configWithOptions:launchOptions];
        
    } failure:^(NSError *error) {

        single.base_url = BASE_REQUEST_URL;
        [self configWithOptions:launchOptions];
        
    }];
}

- (void)configWithOptions:(NSDictionary *)launchOptions
{
    [self initKeyWindow];
    
    [self initIQKeyboardManager];
    
    //友盟分享
    [self initUmSocialCore];
    
    //极光推送
    [self initJpush:launchOptions];
    
    [self initVideo];
    
    //对照相机和麦克风进行授权
    [self initCameraAndMic];
    
    
    //提前获取日期数据，3个地方需要用到
    [self getDayAndWeekLoadData];
}

- (void)initVideo
{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    UIApplication *app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

#pragma mark 初始化UIWindow
- (void)initKeyWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    GGT_LoginViewController *loginVc = [[GGT_LoginViewController alloc]init];
    GGT_HomeViewController *homeVc = [[GGT_HomeViewController alloc]init];
    
    
    //对usertoken赋值,如果为空，就跳转到登录页
    if (IsStrEmpty([UserDefaults() objectForKey:K_userToken])) {
        [UserDefaults() setObject:@"no" forKey:@"login"];
        [UserDefaults() synchronize];
    }
    
    

    if ([[UserDefaults() objectForKey:@"login"] isEqualToString:@"yes"]) {
        
        self.window.rootViewController = homeVc;
        
    } else {
        BaseNavigationController *mainVc = [[BaseNavigationController alloc]initWithRootViewController:loginVc];
        
        self.window.rootViewController = mainVc;
    }
    
    
    //启动图没有状态栏，之后都加载状态栏---并修改为白色--个别页面需要单独设置，包括登录注册（已完成）和视频直播界面
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self.window makeKeyAndVisible];
}

#pragma mark 初始化IQKeyboardManager
- (void)initIQKeyboardManager
{
    IQKeyboardManager * manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark 对照相机和麦克风进行授权
- (void)initCameraAndMic {
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    
    //照相机检测
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ( authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied ) {
        //APP未被授权访问照相机 用户显式地拒绝了为APP支持照相机访问
        sin.cameraStatus = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) { //用户尚未对APP是否访问硬件作出选择。
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if (granted) {
                //第一次用户接受
                sin.cameraStatus = YES;
            }else{
                //用户拒绝
                sin.cameraStatus = NO;
            }
        }];
        
    } else if (authStatus == AVAuthorizationStatusAuthorized) { //客户端被授权访问照相机。
        sin.cameraStatus = YES;
        
    }
    
 
    
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) { //第一次调用，是否允许麦克风弹框
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                sin.micStatus = YES;
            } else {
                sin.micStatus = NO;
            }
        }];
        
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) { //已经拒绝麦克风弹框
        sin.micStatus = NO;
    } else if (permissionStatus == AVAudioSessionRecordPermissionGranted) { //已经允许麦克风弹框
        sin.micStatus = YES;
        
    }
 
}


#pragma mark 配置友盟分享
- (void)initUmSocialCore {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    // 打开图片水印
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;

    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"59291db4c62dca0f43001c71"];
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxf4f5e464e94b9956" appSecret:@"7b6c16881766b8e43bb0f6d8e5064f26" redirectURL:@"http://mobile.umeng.com/social"];
 
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106211590"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"221400771"  appSecret:@"16f0baf24de41eae8b1b3bbbc8de06d9" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}

// 支持所有iOS系统---友盟
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark 以下为极光推送
- (void)initJpush:(NSDictionary *)Options {

    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
//         NSSet<UNNotificationCategory *> *categories for iOS10 or later
//         NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:Options appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [UserDefaults() setObject:registrationID forKey:K_registerID];
            [UserDefaults() synchronize];
            
            //方法更新了，seq（请求时传入的序列号，会在回调时原样返回）是随便设置的，待测试
            [JPUSHService setAlias:registrationID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"rescode: %ld, \n iAlias: %@, \n alias: %ld\n", (long)iResCode, iAlias , (long)seq);

            } seq:0];
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    

}



//注册APNs成功并上报DeviceToken （向苹果服务器注册该设备，注册成功过后会回调）
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString *registerID = [JPUSHService registrationID];
    NSLog(@"jpush注册的registerID:%@",registerID);
    
}



//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// ios 10 support 处于前台时接收到通知  如果处于前台时需要自定义弹框或者弹出alert，可以看一下http://www.jianshu.com/p/d2a42072fad9 这篇文章
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {

    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self pushInfoMationWithUserInfo:userInfo];
    }
    completionHandler((UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert)); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置

    
    /*
     UNNotificationRequest *request = notification.request; // 收到推送的请求
     UNNotificationContent *content = request.content; // 收到推送的消息内容
     
     NSNumber *badge = content.badge;  // 推送消息的角标
     NSString *body = content.body;    // 推送消息体
     UNNotificationSound *sound = content.sound;  // 推送消息的声音
     NSString *subtitle = content.subtitle;  // 推送消息的副标题
     NSString *title = content.title;  // 推送消息的标题
     
     if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
     [JPUSHService handleRemoteNotification:userInfo];
     NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
     
     
     }
     else {
     // 判断为本地通知
     NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
     }
     completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
     */
    


}

// iOS 10 Support  点击处理事件
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        [self pushInfoMationWithUserInfo:userInfo];
        
    }
    
    completionHandler();  // 系统要求执行这个方法

}

// iOS7 及以上接收到通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self pushInfoMationWithUserInfo:userInfo];

}

//最低适配iOS 8，可以不管
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
//    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    [self pushInfoMationWithUserInfo:userInfo];

}

- (void)pushInfoMationWithUserInfo:(NSDictionary *)userInfo  {

    NSLog(@"获取推送接收到的信息---%@",userInfo);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) { //程序当前正处于前台
        NSLog(@"/***************程序处于前台状态，无法显示在通知栏内。不需要做处理***************/");
        
    } else {//程序处于后台
        
        //程序已经关闭或者在后台运行
        [self pushToViewControllerWhenClickPushMessageWith:userInfo];
        
        
        
    }
    


}


-(void)pushToViewControllerWhenClickPushMessageWith:(NSDictionary*)msgDic{
    //点击之后，分三种状态，1：跳转到首页 2：跳转到我的  3：跳转到测评报告 ---先使用测试数据，分别为首页  我的  测评报告
   /*
    {
        "_j_business" = 1;
        "_j_msgid" = 2319162321;
        "_j_uid" = 9653851332;
        aps =     {
            alert = "呵呵";
            badge = 1;
            sound = default;
        };
    }
   
    NSDictionary *apsDic = msgDic[@"aps"];
    NSString *titleStr = apsDic[@"alert"];
    
    if ([titleStr isEqualToString:@"首页"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kebiao" object:self userInfo:msgDic];
    } else if ([titleStr isEqualToString:@"我的"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mine" object:self userInfo:msgDic];
        
    } else if ([titleStr isEqualToString:@"测评报告"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"testReport1" object:self userInfo:msgDic];
    }
     */
    
    
    /*
      {"data":{"Key":"","Type":"1","title":"","Apns":{"content":{"platform":"all","audience":{"alias":["191e35f7e07278860e4"]},"notification":{"alert":"您预约的外教在线一对一体验课定于今日11:00-11:25，请提前安排好时间准时上课，祝您体验愉快！"},"options":{"apns_production":false}}}}}
    */
    
    
    //数据给的比较模糊-------待测试
    NSDictionary *apsDic = msgDic[@"data"];
    NSString *titleStr = apsDic[@"Type"];
    
    if ([titleStr isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kebiao" object:self userInfo:msgDic];
    } else if ([titleStr isEqualToString:@"2"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mine" object:self userInfo:msgDic];

    } else if ([titleStr isEqualToString:@"3"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"testReport1" object:self userInfo:msgDic];
    }


}



- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    
    return str;
}


#pragma mark 提前获取日期数据，3个地方需要用到
- (void)getDayAndWeekLoadData {
    
    [[BaseService share] sendGetRequestWithPath:URL_GetDate token:YES viewController:nil showMBProgress:NO success:^(id responseObject) {
        
        NSArray *dataArray = responseObject[@"data"];
        GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (NSDictionary *dic in dataArray) {
            GGT_HomeDateModel *model = [GGT_HomeDateModel yy_modelWithDictionary:dic];
            [tempArr addObject:model];
        }
        
        sin.orderCourse_dateMuArray = tempArr;
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEnterForeground object:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}




- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

//
//  TKEduClassRoom.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduClassRoom.h"
#import "TKNavigationController.h"
#import "TKEduNetManager.h"
#import "TKEduRoomProperty.h"
#import "RoomController.h"
#import "ClassRoomController.h"
#import "TKProgressHUD.h"
#import "TKMacro.h"
#import "TKUtil.h"
// change openurl
#import "TKOpenUrlViewController.h"
typedef NS_ENUM(NSInteger, EClassStatus) {
    EClassStatus_IDLE = 0,
    EClassStatus_CHECKING,
    EClassStatus_CONNECTING,
};




TKNavigationController* _iEduNavigationController = nil;
@interface TKEduClassRoom ()

@property (atomic) EClassStatus iStatus;
@property (nonatomic, weak ) UIViewController *iController;
@property (nonatomic, strong) RoomController *iRoomController;
@property (nonatomic, strong) ClassRoomController *iClassRoomController;//更改布局后的页面
@property (nonatomic, weak) id<TKEduRoomDelegate> iRoomDelegate;
@property (nonatomic, strong) TKEduRoomProperty * iRoomProperty;
@property (nonatomic, strong) NSDictionary * iParam;
@property (nonatomic, assign) BOOL  isFromWeb;
@property (nonatomic, strong) TKProgressHUD *HUD;
@property (nonatomic, readwrite) BOOL enterClassRoomAgain;
// change openurl
@property (nonatomic, readwrite) NSString* url;
@property (nonatomic, strong) TKOpenUrlViewController* openUrlViewController;

@end

@implementation TKEduClassRoom
+(instancetype )shareInstance{
    
    static TKEduClassRoom *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      singleton = [[TKEduClassRoom alloc] init];
                  });
    
    return singleton;
}

+ (int)joinPlaybackRoomWithParamDic:(NSDictionary *)paramDic
                    ViewController:(UIViewController*)controller
                          Delegate:(id<TKEduRoomDelegate>)delegate
                         isFromWeb:(BOOL)isFromWeb
{
    return [[TKEduClassRoom shareInstance] enterPlaybackClassRoomWithParamDic:paramDic ViewController:controller Delegate:delegate isFromWeb:isFromWeb];
}

- (int)enterPlaybackClassRoomWithParamDic:(NSDictionary*)paramDic
                           ViewController:(UIViewController*)controller
                                 Delegate:(id<TKEduRoomDelegate>)delegate
                               isFromWeb:(BOOL)isFromWeb {
    TKLog(@"tlm----- 进入房间之前的时间: %@", [TKUtil currentTimeToSeconds]);
    
    if (_iStatus != EClassStatus_IDLE)
    {
        // change openurl
//        self.enterClassRoomAgain = YES;
//        if ([_iRoomProperty.iPadLayout isEqualToString:SHARKTOP_COMPANY]) {
//
//             [_iClassRoomController prepareForLeave:YES];
//
//        }else{
//
//            [_iRoomController prepareForLeave:YES];
//
//        }
        return -1;//正在开会
    }
    
    _iController = controller;
    _iRoomDelegate = delegate;
    _iStatus = EClassStatus_CHECKING;
    _iParam = paramDic;
    _isFromWeb = isFromWeb;
    _iRoomProperty = [[TKEduRoomProperty alloc]init];
    [_iRoomProperty parseMeetingInfo:paramDic];
    _iRoomProperty.iRoomType = (RoomType)[[paramDic objectForKey:@"type"] integerValue];
    bool isConform = [TKUtil deviceisConform];
//     isConform      = true;  // 注释掉开启低功耗模式
    if (!isConform) {
        _iRoomProperty.iMaxVideo = @(2);
    }else{
        _iRoomProperty.iMaxVideo = @(6);
    }

    
    _HUD = [[TKProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD show:YES];
    
    if ((_iRoomProperty.sCmdUserRole ==UserType_Teacher && [_iRoomProperty.sCmdPassWord isEqualToString:@""]&&_iRoomProperty.sCmdPassWord) && !isFromWeb) {
        [self reportFail:TKErrorCode_CheckRoom_NeedPassword aDescript:@""];
        [_HUD hide:YES];
        return -1;
    }
    
    [TKEduNetManager getRoomJsonWithPath:paramDic[@"path"] Complete:^int(id  _Nullable response) {
      
        if (response) {
            _iStatus = EClassStatus_CONNECTING;
            int ret = 0;
            TKLog(@"tlm-----checkRoom 进入房间之前的时间: %@", [TKUtil currentTimeToSeconds]);
            ret = [[response objectForKey:@"result"] intValue];
            if (ret == 0) {
                
                NSDictionary *tRoom = [response objectForKey:@"room"];
                if (tRoom) {
                    //0 xiaoban 1daban
                    _iRoomProperty.iRoomType = [tRoom objectForKey:@"roomtype"]?(RoomType)[[tRoom objectForKey:@"roomtype"]intValue]:RoomType_OneToOne;
                    _iRoomProperty.iRoomId = [tRoom objectForKey:@"serial"]?[tRoom objectForKey:@"serial"]:@"";
                    _iRoomProperty.iRoomName = [tRoom objectForKey:@"roomname"]?[tRoom objectForKey:@"roomname"]:@"";
                    _iRoomProperty.iCompanyID = [tRoom objectForKey:@"companyid"]?[tRoom objectForKey:@"companyid"]:@"";
                    int  tMaxVideo = [[tRoom objectForKey:@"maxvideo"]intValue];
                    _iRoomProperty.iMaxVideo = @(tMaxVideo);
                    _iRoomProperty.whiteboardcolor = @([[tRoom objectForKey:@"whiteboardcolor"]intValue]);
                    
                    bool isConform = [TKUtil deviceisConform];
                    //                    isConform      = true;     // 注释掉开启低功耗模式
                    if (!isConform) {
                        _iRoomProperty.iMaxVideo = @(2);
                    }
                    
                    
                }
                
                //roomrole
                UserType tUserRole = [response objectForKey:@"roomrole"]?(UserType)[[response objectForKey:@"roomrole"]intValue ]:UserType_Teacher;
                _iRoomProperty.iUserType = tUserRole;
                
                //padlayout
                NSString *tPadLayout = [NSString stringWithFormat:@"%@",[response objectForKey:@"padlayout"]];
                
                _iRoomProperty.iPadLayout = tPadLayout;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _enterClassRoomAgain = NO;
                    
                    UIViewController *viewController;
                    
                    if ([_iRoomProperty.iPadLayout isEqualToString:SHARKTOP_COMPANY]) {
                        //            _iClassRoomController = [[ClassRoomController alloc]initWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                        
                        _iClassRoomController = [[ClassRoomController alloc]initPlaybackWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                        viewController = _iClassRoomController;
                        
                    }else{
                        //            _iRoomController = [[RoomController alloc]initWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                        _iRoomController = [[RoomController alloc]initPlaybackWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                        viewController = _iRoomController;
                    }
                    
                    _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:viewController];
                    [controller presentViewController:_iEduNavigationController animated:YES completion:^{
                        [_HUD hide:YES];
                    }];
                    
                    
                    
                    
                });
            }
        }
        return 0;
    } aNetError:^int(id  _Nullable response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _enterClassRoomAgain = NO;
            
            UIViewController *viewController;
            
            if ([_iRoomProperty.iPadLayout isEqualToString:SHARKTOP_COMPANY]) {
                //            _iClassRoomController = [[ClassRoomController alloc]initWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                
                _iClassRoomController = [[ClassRoomController alloc]initPlaybackWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                viewController = _iClassRoomController;
                
            }else{
                //            _iRoomController = [[RoomController alloc]initWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                _iRoomController = [[RoomController alloc]initPlaybackWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                viewController = _iRoomController;
            }
            
            _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:viewController];
            [controller presentViewController:_iEduNavigationController animated:YES completion:^{
                [_HUD hide:YES];
            }];
            
        });
        return -1;
    }];
    
    //默认返回0
    return  0;
}

+(int)joinRoomWithParamDic:(NSDictionary*)paramDic
                  ViewController:(UIViewController*)controller
                        Delegate:(id<TKEduRoomDelegate>)delegate
                       isFromWeb:(BOOL)isFromWeb
{
    return  [[TKEduClassRoom shareInstance] enterClassRoomWithParamDic:paramDic ViewController:controller Delegate:delegate isFromWeb:isFromWeb];
   
}
-(int)enterClassRoomWithParamDic:(NSDictionary*)paramDic
                  ViewController:(UIViewController*)controller
                        Delegate:(id<TKEduRoomDelegate>)delegate
                       isFromWeb:(BOOL)isFromWeb
{
    TKLog(@"tlm----- 进入房间之前的时间: %@", [TKUtil currentTimeToSeconds]);
    if (_iStatus != EClassStatus_IDLE)
    {
        return -1;//正在开会
    }


    _iController = controller;
    _iRoomDelegate = delegate;
    _iStatus = EClassStatus_CHECKING;
    _iParam = paramDic;
    _isFromWeb = isFromWeb;
    _iRoomProperty = [[TKEduRoomProperty alloc]init];
    [_iRoomProperty parseMeetingInfo:paramDic];
    
    __weak typeof(self)weekSelf = self;
    _HUD = [[TKProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD show:YES];
    //除了学生可以没有密码，其他身份都需要密码
    if ((_iRoomProperty.sCmdUserRole !=UserType_Student && [_iRoomProperty.sCmdPassWord isEqualToString:@""]&&_iRoomProperty.sCmdPassWord) && !isFromWeb) {
        [self reportFail:TKErrorCode_CheckRoom_NeedPassword aDescript:@""];
        [_HUD hide:YES];
        return -1;
    } 
    [TKEduNetManager checkRoom:paramDic aDidComplete:^int(id  _Nullable response, NSString * _Nullable aPassWord) {
        __strong typeof(self)strongSelf = weekSelf;
        _iRoomProperty.sCmdPassWord = aPassWord;
        
        if (response) {
            _iStatus = EClassStatus_CONNECTING;
            int ret = 0;
            TKLog(@"tlm-----checkRoom 进入房间之前的时间: %@", [TKUtil currentTimeToSeconds]);
            ret = [[response objectForKey:@"result"] intValue];
            if (ret == 0) {
                
                NSDictionary *tRoom = [response objectForKey:@"room"];
                if (tRoom) {
                    //0 xiaoban 1daban
                    _iRoomProperty.iRoomType = [tRoom objectForKey:@"roomtype"]?(RoomType)[[tRoom objectForKey:@"roomtype"]intValue]:RoomType_OneToOne;
                    _iRoomProperty.iRoomId = [tRoom objectForKey:@"serial"]?[tRoom objectForKey:@"serial"]:@"";
                    _iRoomProperty.iRoomName = [tRoom objectForKey:@"roomname"]?[tRoom objectForKey:@"roomname"]:@"";
                    _iRoomProperty.iCompanyID = [tRoom objectForKey:@"companyid"]?[tRoom objectForKey:@"companyid"]:@"";
                    int  tMaxVideo = [[tRoom objectForKey:@"maxvideo"]intValue];
                    _iRoomProperty.iMaxVideo = @(tMaxVideo);
                    _iRoomProperty.whiteboardcolor = @([TKUtil getIntegerValueFromDic:tRoom Key:@"whiteboardcolor"]);
                    _iRoomProperty.sNickName = [TKUtil optString:response Key:@"nickname"];
                    bool isConform = [TKUtil deviceisConform];
//                    isConform      = true;     // 注释掉开启低功耗模式
                    if (!isConform) {
                        _iRoomProperty.iMaxVideo = @(2);
                    }
                    
                    // 下载发奖杯 音频
//                    NSString *url = [TKUtil optString:tRoom Key:@"voicefile"];
//                    if (url && url.length > 0) {
//                        NSString *voiceFileURL = [NSString stringWithFormat:@"http://%@:%@%@",[TKUtil optString:_iParam Key:@"host"], [TKUtil optString:_iParam Key:@"port"],url];
//                        if (voiceFileURL && voiceFileURL.length > 0) {
//                            [TKEduNetManager downLoadMp3File:voiceFileURL Complete:^int(id  _Nullable response) {
//                                return 0;
//                            } aNetError:^int(id  _Nullable response) {
//                                return 0;
//                            }];
//                        }
//                    }
                    
                }
                
                //roomrole
                UserType tUserRole = [response objectForKey:@"roomrole"]?(UserType)[[response objectForKey:@"roomrole"]intValue ]:UserType_Teacher;
                _iRoomProperty.iUserType = tUserRole;
                
                //padlayout
                NSString *tPadLayout = [NSString stringWithFormat:@"%@",[response objectForKey:@"padlayout"]];
                
                _iRoomProperty.iPadLayout = tPadLayout;
//                _iRoomProperty.iPadLayout = SHARKTOP_COMPANY;
                
                if ((tUserRole != _iRoomProperty.sCmdUserRole) &&  !isFromWeb) {
                    [strongSelf reportFail:TKErrorCode_CheckRoom_NeedPassword aDescript:@""];
                    [_HUD hide:YES];
                    return -1;
                    
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:paramDic];
                
                if(![[paramDic allKeys]  containsObject: @"nickname"]){
                    [dict setObject:_iRoomProperty.sNickName forKey:@"nickname"];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // change openurl
                    _enterClassRoomAgain = NO;
                    UIViewController *viewController;
                    if (_iRoomProperty.iPadLayout && [_iRoomProperty.iPadLayout isEqualToString:SHARKTOP_COMPANY]) {
                        _iClassRoomController = [[ClassRoomController alloc]initWithDelegate:delegate aParamDic:dict aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                        viewController = _iClassRoomController;
                        
                    }else{
                        _iRoomController = [[RoomController alloc]initWithDelegate:delegate aParamDic:dict aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                        viewController = _iRoomController;
                    }
                    
                    _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:viewController];
                   
                    [controller presentViewController:_iEduNavigationController animated:YES completion:^{
                         [_HUD hide:YES];
                    }];
                    
                    
                });
                
                
            }else{
                
                [strongSelf reportFail:[[response objectForKey:@"result"]intValue] aDescript:@""];
                [_HUD hide:YES];
                
            }
        }else{
            [strongSelf reportFail:-2 aDescript:@""];
            [_HUD hide:YES];
        }
         return 0;
            
    } aNetError:^int(NSError * _Nullable aError) {
        NSLog(@"----------------aError %@",aError.description);
        __strong typeof(self)strongSelf = weekSelf;
        [strongSelf reportFail:(int)aError.code aDescript:aError.description];
        [_HUD hide:YES];
        return -1;
    }];
    
    //默认返回0
    return  0;
}

+(UIViewController *)currentViewController{
     return _iEduNavigationController;
}
+(UIViewController *)currentRoomViewController{
    return [TKEduClassRoom shareInstance].iRoomController ;
}
+(void)leftRoom{
//    [[TKEduClassRoom shareInstance].iRoomController prepareForLeave:YES];
    [[TKEduClassRoom shareInstance].iClassRoomController prepareForLeave:YES];
}

- (void)onRoomControllerDisappear:(NSNotification*)__unused notif
{
    _iEduNavigationController = nil;
    _iRoomController = nil;
    _iClassRoomController = nil;
    _iStatus = EClassStatus_IDLE;
    _iRoomDelegate = nil;
    _iController = nil;
    // change openurl
    //如果是因为再次进入而产生的退出，则需要重新进入
    if ( self.enterClassRoomAgain) {
        [self joinRoomFromWebUrl:self.url];
    }
}

#pragma mark 加入会议
- (void)reportFail:(TKRoomErrorCode)ret  aDescript:(NSString *)aDescript
{
    [_HUD hide:YES];
    if(_iRoomDelegate)
    {
        bool report            = true;
        NSString *alertMessage = nil;
        switch (ret) {
            case TKErrorCode_CheckRoom_ServerOverdue: {//3001  服务器过期
                alertMessage = MTLocalized(@"Error.ServerExpired");
                //alertMessage = @"服务器过期";
            }
                break;
            case TKErrorCode_CheckRoom_RoomFreeze: {//3002  公司被冻结
                alertMessage = MTLocalized(@"Error.CompanyFreeze");
                //alertMessage = @"公司被冻结";
            }
                break;
            case TKErrorCode_CheckRoom_RoomDeleteOrOrverdue: //3003  房间被删除或过期
            case TKErrorCode_CheckRoom_RoomNonExistent: {//4007 房间不存在 房间被删除或者过期
                alertMessage = MTLocalized(@"Error.RoomDeletedOrExpired");
               // alertMessage = @"房间被删除或者过期";
            }
                break;
            case TKErrorCode_CheckRoom_RequestFailed:
                alertMessage = MTLocalized(@"Error.WaitingForNetwork");
                break;
            case TKErrorCode_CheckRoom_PasswordError: {//4008  房间密码错误
                alertMessage = MTLocalized(@"Error.PwdError");
//                 alertMessage = @"房间密码错误";
            }
                break;
        
            case TKErrorCode_CheckRoom_WrongPasswordForRole: {//4012  密码与角色不符
                alertMessage = MTLocalized(@"Error.PwdError");
                //alertMessage = @"房间密码错误";
            }
                break;
                
            case TKErrorCode_CheckRoom_RoomNumberOverRun: {//4103  房间人数超限
                alertMessage = MTLocalized(@"Error.MemberOverRoomLimit");
                //alertMessage = @"房间人数超限";
            }
                break;
                
            case TKErrorCode_CheckRoom_NeedPassword: {//4110  该房间需要密码，请输入密码
                alertMessage = MTLocalized(@"Error.NeedPwd");
//                 alertMessage = @"该房间需要密码，请输入密码";
            }
                break;
                
            case TKErrorCode_CheckRoom_RoomPointOverrun: {//4112  企业点数超限
                alertMessage = MTLocalized(@"Error.pointOverRun");
                //                 alertMessage = @" 企业点数超限";
            }
                break;
            case TKErrorCode_CheckRoom_RoomAuthenError: {
                alertMessage = MTLocalized(@"Error.AuthIncorrect");
//                 alertMessage = @"认证错误";
            }
                break;
           
            default:{
                report = YES;
                 //alertMessage = aDescript;
                alertMessage = [NSString stringWithFormat:@"%@(%ld)",MTLocalized(@"Error.WaitingForNetwork"),(long)ret];
                break;
            }
                
        }
       
        if (ret == TKErrorCode_CheckRoom_NeedPassword || ret == TKErrorCode_CheckRoom_PasswordError ||  ret ==  TKErrorCode_CheckRoom_WrongPasswordForRole)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:MTLocalized(@"Prompt.prompt") message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = MTLocalized(@"Prompt.inputPwd");// @"请输入密码";
            }];
            
            NSDictionary *tDict = _iParam;
            BOOL tIsFromWeb = _isFromWeb;
            UIAlertAction *tAction = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *login = alertController.textFields.firstObject;

                _iRoomProperty.sCmdPassWord = login.text;
                NSMutableDictionary *tHavePasswordDic = [NSMutableDictionary dictionaryWithDictionary:tDict];
                [tHavePasswordDic setObject:login.text forKey:@"password"];
                [TKEduClassRoom joinRoomWithParamDic:tHavePasswordDic ViewController:_iController Delegate:_iRoomDelegate isFromWeb:tIsFromWeb];
                
            }];
            UIAlertAction *tAction2 = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // change openurl
                if (_isFromWeb && _openUrlViewController) {
                    [_openUrlViewController dismissViewControllerAnimated:NO completion:nil];
                }
            }];
            [alertController addAction:tAction];
            [alertController addAction:tAction2];
            [_iController presentViewController:alertController animated:YES completion:nil];
            
        }else{
           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:MTLocalized(@"Prompt.prompt") message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *tAction2 = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Know") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // change openurl
                if (_isFromWeb && _openUrlViewController) {
                    [_openUrlViewController dismissViewControllerAnimated:NO completion:nil];
                }
            }];
       
            [alertController addAction:tAction2];
            [_iController presentViewController:alertController animated:YES completion:nil];

            
        }
        if (report)
        {
            if ([_iRoomDelegate respondsToSelector:@selector(onEnterRoomFailed:Description:)]) {
                  [(id<TKEduRoomDelegate>)_iRoomDelegate onEnterRoomFailed:ret Description:alertMessage];
            }
//            _iEduNavigationController = nil;
//            _iTKEduEnterClassRoomDelegate = nil;
//            _iController = nil;
            _iStatus = EClassStatus_IDLE;

        }
    }
}

#pragma mark joinRoom
// change openurl
+(void)joinRoomFromWebUrl:(NSString*)url{
    [[TKEduClassRoom shareInstance]joinRoomFromWebUrl:url];
}
-(void)joinRoomFromWebUrl:(NSString*)url{
    self.url = url;
    //此时正在课堂中,需要退出
    if (self.iStatus != EClassStatus_IDLE) {
        self.enterClassRoomAgain = YES;
        self.openUrlViewController.url = url;
        if ([_iRoomProperty.iPadLayout isEqualToString:SHARKTOP_COMPANY]) {
            [_iClassRoomController prepareForLeave:YES];
        }else{
            [_iRoomController prepareForLeave:YES];
        }
        
    }else{
        if (!self.openUrlViewController) {
             self.openUrlViewController = [[TKOpenUrlViewController alloc]init];
             self.openUrlViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            self.openUrlViewController.url = url;
            UIViewController *tRoomRoot = (UIViewController*) [UIApplication sharedApplication].keyWindow.rootViewController;
            [tRoomRoot presentViewController:self.openUrlViewController animated:NO completion:^{
                
                [self.openUrlViewController openUrl:self.url];
            }];
        }else{
             [self.openUrlViewController openUrl:self.url];
        }
    }
}

+(void)clearWebUrlData{
    [TKEduClassRoom shareInstance].openUrlViewController = nil;
}


#pragma mark - private
- (id)init
{
    if (self = [super init]) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRoomControllerDisappear:) name:sTKRoomViewControllerDisappear object:nil];
    }
    return self;
}
@end

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
#import "TKProgressHUD.h"
#import "TKMacro.h"
#import "TKUtil.h"

typedef NS_ENUM(NSInteger, EClassStatus) {
    EClassStatus_IDLE = 0,
    EClassStatus_CHECKING,
    EClassStatus_CONNECTING,
};


typedef NS_ENUM(NSInteger, CONNECT_RESULE)
{
  
    CONNECT_RESULE_PasswordError = 4008,//房间密码错误
    CONNECT_RESULE_NeedPassword = 4110,//该房间需要密码，请输入密码
    CONNECT_RESULE_RoomNonExistent = 4007,//房间不存在
    CONNECT_RESULE_ServerOverdue = 3001,//服务器过期
    CONNECT_RESULE_RoomFreeze = 3002,// 公司被冻结
    CONNECT_RESULE_RoomDeleteOrOrverdue = 3003,//房间被删除或过期
    CONNECT_RESULE_RoomAuthenError = 4109,//认证错误
    CONNECT_RESULE_RoomPointOverrun = 4112,//企业点数超限
    CONNECT_RESULE_RoomNumberOverRun = 4103//房间人数超限
   
};

TKNavigationController* _iEduNavigationController = nil;
@interface TKEduClassRoom ()

@property (atomic) EClassStatus iStatus;
@property (nonatomic, strong) UIViewController *iController;
@property (nonatomic, strong) RoomController *iRoomController;
@property (nonatomic, weak) id<TKEduRoomDelegate> iRoomDelegate;
@property (nonatomic, strong) TKEduRoomProperty * iRoomProperty;
@property (nonatomic, strong) NSDictionary * iParam;
@property (nonatomic, assign) BOOL  isFromWeb;
@property (nonatomic, strong) TKProgressHUD *HUD;
@property (nonatomic, readwrite) BOOL enterClassRoomAgain;
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
//        NSArray *array = [UIApplication sharedApplication].windows;
//        int count = (int)array.count;
//        [TKRCGlobalConfig HUDShowMessage:MTLocalized(@"Prompt.leaveRoom") addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:2];
        self.enterClassRoomAgain = YES;
        [_iRoomController prepareForLeave:YES];
        return -1;//正在开会
    }
    
    _iController = controller;
    _iRoomDelegate = delegate;
    _iStatus = EClassStatus_CHECKING;
    _iParam = paramDic;
    _isFromWeb = isFromWeb;
    _iRoomProperty = [[TKEduRoomProperty alloc]init];
    [_iRoomProperty parseMeetingInfo:paramDic];
    _iRoomProperty.iRoomType = [[paramDic objectForKey:@"type"] integerValue];
    bool isConform = [TKUtil deviceisConform];
    // isConform      = true;  // 注释掉开启低功耗模式
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
        [self reportFail:CONNECT_RESULE_NeedPassword aDescript:@""];
        [_HUD hide:YES];
        return -1;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //_iRoomController = [[RoomController alloc]initWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
        _enterClassRoomAgain = NO;
        _iRoomController = [[RoomController alloc] initPlaybackWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
        _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:_iRoomController];
        [controller presentViewController:_iEduNavigationController animated:YES completion:^{
            [_HUD hide:YES];
        }];
        
    });
    
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
        [self reportFail:CONNECT_RESULE_NeedPassword aDescript:@""];
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
                    _iRoomProperty.iRoomType = [tRoom objectForKey:@"roomtype"]?[[tRoom objectForKey:@"roomtype"]intValue]:RoomType_OneToOne;
                    _iRoomProperty.iRoomId = [tRoom objectForKey:@"serial"]?[tRoom objectForKey:@"serial"]:@"";
                    _iRoomProperty.iRoomName = [tRoom objectForKey:@"roomname"]?[tRoom objectForKey:@"roomname"]:@"";
                    _iRoomProperty.iCompanyID = [tRoom objectForKey:@"companyid"]?[tRoom objectForKey:@"companyid"]:@"";
                    int  tMaxVideo = [[tRoom objectForKey:@"maxvideo"]intValue];
                    _iRoomProperty.iMaxVideo = @(tMaxVideo);
                    bool isConform = [TKUtil deviceisConform];
                    //isConform      = true;     // 注释掉开启低功耗模式
                    if (!isConform) {
                        _iRoomProperty.iMaxVideo = @(2);
                    }
                    
                }
                
                //roomrole
                UserType tUserRole = [response objectForKey:@"roomrole"]?[[response objectForKey:@"roomrole"]intValue ]:UserType_Teacher;
                _iRoomProperty.iUserType = tUserRole;
                
                if ((tUserRole != _iRoomProperty.sCmdUserRole) &&  !isFromWeb) {
                    [strongSelf reportFail:CONNECT_RESULE_PasswordError aDescript:@""];
                    [_HUD hide:YES];
                    return -1;
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    _iRoomController = [[RoomController alloc]initWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                    _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:_iRoomController];
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
    [[TKEduClassRoom shareInstance].iRoomController prepareForLeave:YES];
}

- (void)onRoomControllerDisappear:(NSNotification*)__unused notif
{
    _iEduNavigationController = nil;
    _iRoomController = nil;
    _iStatus = EClassStatus_IDLE;
    _iRoomDelegate = nil;
    _iController = nil;
}

#pragma mark 加入会议
- (void)reportFail:(int)ret  aDescript:(NSString *)aDescript
{
    [_HUD hide:YES];
    if(_iRoomDelegate)
    {
        bool report            = true;
        NSString *alertMessage = nil;
        switch (ret) {
            case CONNECT_RESULE_ServerOverdue: {//3001  服务器过期
                alertMessage = MTLocalized(@"Error.ServerExpired");
                //alertMessage = @"服务器过期";
            }
                break;
            case CONNECT_RESULE_RoomFreeze: {//3002  公司被冻结
                alertMessage = MTLocalized(@"Error.CompanyFreeze");
                //alertMessage = @"公司被冻结";
            }
                break;
            case CONNECT_RESULE_RoomDeleteOrOrverdue: //3003  房间被删除或过期
            case CONNECT_RESULE_RoomNonExistent: {//4007 房间不存在 房间被删除或者过期
                alertMessage = MTLocalized(@"Error.RoomDeletedOrExpired");
               // alertMessage = @"房间被删除或者过期";
            }
                break;
            case CONNECT_RESULE_PasswordError: {//4008  房间密码错误
                alertMessage = MTLocalized(@"Error.PwdError");
//                 alertMessage = @"房间密码错误";
            }
                break;
        
            case CONNECT_RESULE_RoomNumberOverRun: {//4103  房间人数超限
                alertMessage = MTLocalized(@"Error.MemberOverRoomLimit");
                 //alertMessage = @"房间人数超限";
            }
                break;
            case CONNECT_RESULE_NeedPassword: {//4110  该房间需要密码，请输入密码
                alertMessage = MTLocalized(@"Error.NeedPwd");
//                 alertMessage = @"该房间需要密码，请输入密码";
            }
                break;
                
            case CONNECT_RESULE_RoomPointOverrun: {//4112  企业点数超限
                alertMessage = MTLocalized(@"Error.pointOverRun");
                //                 alertMessage = @" 企业点数超限";
            }
                break;
            case CONNECT_RESULE_RoomAuthenError: {
                alertMessage = MTLocalized(@"Error.AuthIncorrect");
//                 alertMessage = @"认证错误";
            }
                break;
           
            default:{
                report = YES;
                 //alertMessage = aDescript;
                 alertMessage = MTLocalized(@"Error.WaitingForNetwork");
               
                break;
            }
                
        }
       
        if (ret == CONNECT_RESULE_PasswordError || ret == CONNECT_RESULE_NeedPassword)
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
                
            }];
            [alertController addAction:tAction];
            [alertController addAction:tAction2];
            [_iController presentViewController:alertController animated:YES completion:nil];
            
        }else{
           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:MTLocalized(@"Prompt.prompt") message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *tAction2 = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Know") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
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
#pragma mark - private
- (id)init
{
    if (self = [super init]) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRoomControllerDisappear:) name:sTKRoomViewControllerDisappear object:nil];
    }
    return self;
}
@end

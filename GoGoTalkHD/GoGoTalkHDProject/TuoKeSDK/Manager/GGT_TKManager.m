//
//  GGT_TKManager.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/9/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_TKManager.h"
#import "TKEduClassRoom.h"
#import "TKMacro.h"

@interface GGT_TKManager ()<TKEduRoomDelegate>
@property (nonatomic, strong) GGT_CourseCellModel *xc_model;
@property (nonatomic, copy) TKLeftClassroomBlock xc_leftRoomBlock;
@end

@implementation GGT_TKManager

+ (instancetype)share
{
    static GGT_TKManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

+ (void)tk_enterClassroomWithViewController:(UIViewController *)viewController courseModel:(GGT_CourseCellModel *)model leftRoomBlock:(TKLeftClassroomBlock)leftRoomBlock
{
    GGT_TKManager *manager = [GGT_TKManager share];
    manager.xc_model = model;
    [manager enterTKClassroomWithCourseModel:model viewController:viewController];
    manager.xc_leftRoomBlock = leftRoomBlock;
}

- (void)enterTKClassroomWithCourseModel:(GGT_CourseCellModel *)model viewController:(UIViewController *)viewController
{
    NSDictionary *tDict = @{
                            @"serial"   :model.serial,
                            @"host"    :model.host,
                            // @"userid"  : @"1111",
                            @"port"    :model.port,
                            @"nickname":model.nickname,    // 学生密码567
                            @"userrole":model.userrole    //用户身份，0：老师；1：助教；2：学生；3：旁听；4：隐身用户
                            };
    TKEduClassRoom *shareRoom = [TKEduClassRoom shareInstance];
    shareRoom.xc_roomPassword = model.stuPwd;
    shareRoom.xc_roomName = model.LessonName;
    [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:viewController Delegate:self];
    
    // 记录日志
    [XCLogManager xc_redirectNSlogToDocumentFolder];
}

//error.code  Description:error.description
- (void) onEnterRoomFailed:(int)result Description:(NSString*)desc{
    if ([desc isEqualToString:MTLocalized(@"Error.NeedPwd")]) {     // 需要密码错误日志不发送
        
    } else {
        TKLog(@"-----onEnterRoomFailed");
        [XCLogManager xc_readDataFromeFile];
    }
}
- (void) onKitout:(EKickOutReason)reason{
    TKLog(@"-----onKitout");
}
- (void) joinRoomComplete{
    TKLog(@"-----joinRoomComplete");
    [XCLogManager xc_readDataFromeFile];
    
    // 发送进入教室的网络请求
    [self postNetworkModifyLessonStatusWithCourseModel:self.xc_model];
}
- (void) leftRoomComplete{
    TKLog(@"-----leftRoomComplete");
    [XCLogManager xc_deleteLogData];
    
    if (self.xc_leftRoomBlock) {
        self.xc_leftRoomBlock();
    }
}
- (void) onClassBegin{
    TKLog(@"-----onClassBegin");
}
- (void) onClassDismiss{
    NSLog(@"-----onClassDismiss");
    [TKEduClassRoom leftRoom];
}
- (void) onCameraDidOpenError{
    TKLog(@"-----onCameraDidOpenError");
}

// 进入教室调用接口
- (void)postNetworkModifyLessonStatusWithCourseModel:(GGT_CourseCellModel *)model
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"LessonId"] = model.LessonId;
    
    NSString *url = [NSString stringWithFormat:@"%@?LessonId=%@", URL_ModifyLessonStatus, model.LessonId];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:nil showMBProgress:NO success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end

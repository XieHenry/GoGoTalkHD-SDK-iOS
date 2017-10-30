//
//  GGT_ClassroomManager.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/9/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ClassroomManager.h"

// 拓课
#import "TKEduClassRoom.h"
#import "TKMacro.h"

// 百家云
//#import "BJRoomViewController.h"

@interface GGT_ClassroomManager ()<TKEduRoomDelegate>
@property (nonatomic, strong) GGT_CourseCellModel *xc_model;
@property (nonatomic, copy) TKLeftClassroomBlock xc_leftRoomBlock;
@end

@implementation GGT_ClassroomManager

+ (instancetype)share
{
    static GGT_ClassroomManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}


#pragma mark - 进入拓课的方法
+ (void)tk_enterClassroomWithViewController:(UIViewController *)viewController courseModel:(GGT_CourseCellModel *)model leftRoomBlock:(TKLeftClassroomBlock)leftRoomBlock
{
    GGT_ClassroomManager *manager = [GGT_ClassroomManager share];
    manager.xc_model = model;
    [manager enterTKClassroomWithCourseModel:model viewController:viewController];
    manager.xc_leftRoomBlock = leftRoomBlock;
}

- (void)enterTKClassroomWithCourseModel:(GGT_CourseCellModel *)model viewController:(UIViewController *)viewController
{

//    model.serial = @"755158726";
//    model.nickname = @"teacher";

    NSDictionary *tDict = @{
                            @"serial"   :model.serial,
                            @"host"    :model.host,
                            // @"userid"  : @"1111",
                            @"port"    :model.port,
                            @"nickname":model.nickname,    // 学生密码567
                            @"userrole":model.userrole    //用户身份，0：老师；1：助教；2：学生；3：旁听；4：隐身用户
                            };

    [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:viewController Delegate:self isFromWeb:NO];
    
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
    
    // 在倒计时弹窗的地方有用 判断是否弹出进入教室的alter
    GGT_Singleton *single = [GGT_Singleton sharedSingleton];
    single.isInRoom = YES;
}
- (void) leftRoomComplete{
    TKLog(@"-----leftRoomComplete");
    [XCLogManager xc_deleteLogData];
    
    if (self.xc_leftRoomBlock) {
        self.xc_leftRoomBlock();
    }
    
    GGT_Singleton *single = [GGT_Singleton sharedSingleton];
    single.isInRoom = NO;
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

#pragma mark - 进入教室调用接口 更新接口
- (void)postNetworkModifyLessonStatusWithCourseModel:(GGT_CourseCellModel *)model
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"LessonId"] = model.LessonId;
    
    NSString *url = [NSString stringWithFormat:@"%@?LessonId=%@", URL_ModifyLessonStatus, model.LessonId];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:nil showMBProgress:NO success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 进入百家云的接口
+ (void)bjy_enterClassroomWithViewController:(UIViewController *)viewController courseModel:(GGT_CourseCellModel *)model
{

//    GGT_ClassroomManager *manager = [GGT_ClassroomManager share];
//    manager.xc_model = model;
//
//    BJRoomViewController *roomViewController = [BJRoomViewController new];
//    [viewController presentViewController:roomViewController
//                       animated:YES
//                     completion:^{
//                         [roomViewController enterRoomWithSecret:@"2mnuv7" userName:@"Student"];
//                     }];
}

// 调用接口 区别进入那个教室
+ (void)chooseClassroomWithViewController:(UIViewController *)viewController courseModel:(GGT_CourseCellModel *)model leftRoomBlock:(TKLeftClassroomBlock)leftRoomBlock
{
    
    NSString *url = [NSString stringWithFormat:@"%@?lessonId=%@", URL_GetLessonByLessonId, model.LessonId];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:viewController showMBProgress:YES success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *data = responseObject[@"data"];
            GGT_CourseCellModel *currentModel = nil;
            if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
                currentModel = [GGT_CourseCellModel yy_modelWithDictionary:[data firstObject]];
            } else {
                currentModel = model;
            }
            
            // 教室类型:1: 拓课电子教室 2：QQ教室 3:飞博教室 4：百家云教室
            if (currentModel.ClassRoomType == 1) {  // 拓课
                [self tk_enterClassroomWithViewController:viewController courseModel:currentModel leftRoomBlock:leftRoomBlock];
            }
            
            if (currentModel.ClassRoomType == 4) {  // 百家云
//                [self bjy_enterClassroomWithViewController:viewController courseModel:currentModel];
                
                // 进入百家云的APP
                // 教室是拓课的  需要唤醒另一个APP 进行上课
                NSURL *schemes = [NSURL URLWithString:@"GoGoTalkBJY://"];
                // 如果已经安装了这个应用,就跳转
                if ([[UIApplication sharedApplication] canOpenURL:schemes]) {
                    
                    // 拼接URL
                    NSMutableDictionary *dictionary = [NSMutableDictionary new];
                    dictionary[@"nickname"] = model.nickname;
                    dictionary[@"serial"] = model.serial;
                    dictionary[@"lessonId"] = model.LessonId;
                    
                    NSError *parseError = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
                    NSString *urlStr = [NSString stringWithFormat:@"%@data=%@", schemes, [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
                    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    NSURL *url = [NSURL URLWithString:urlStr];
                    [[UIApplication sharedApplication] openURL:url];
                } else {
                    // 下载
                }
            }
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end

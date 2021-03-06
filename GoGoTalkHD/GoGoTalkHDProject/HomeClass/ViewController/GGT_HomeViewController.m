//
//  GGT_HomeViewController.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_HomeViewController.h"
#import "GGT_HomeLeftView.h"
#import "GGT_ScheduleViewController.h"
#import "GGT_MineSplitViewController.h"
#import "GGT_OrderCourseViewController.h"
#import "BaseNavigationController.h"
//检查设备
#import "GGT_CheckDevicePopViewController.h"
#import "GGT_PopAlertView.h"


@interface GGT_HomeViewController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) GGT_HomeLeftView *xc_leftView;
@property (nonatomic, strong) GGT_ScheduleViewController *scheduleVC;
@property (nonatomic, strong) GGT_OrderCourseViewController *orderCourseVc;
@property (nonatomic, strong) GGT_MineSplitViewController *mineVc;


@property (nonatomic, strong) BaseNavigationController *xc_nav;
@property (nonatomic, strong) BaseNavigationController *xc_nav1;

@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) GGT_CourseCellModel *xc_course_model;

@end

@implementation GGT_HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushKebiaoWithNotification:) name:@"kebiao" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMineWithNotification:) name:@"mine" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushTestReportWithNotification:) name:@"testReport1" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kebiao" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mine" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"testReport1" object:nil];
    
}



#pragma mark - pushMessageAction
- (void)pushKebiaoWithNotification:(NSNotification *)noti {
    NSLog(@"--%@",noti.userInfo);
    
    
    UIButton *button1 = [self.xc_leftView viewWithTag:100];
    button1.selected = YES;
    
    UIButton *button = [self.xc_leftView viewWithTag:102];
    button.selected = NO;
    
    //  点击处于当前页面的按钮,直接跳出
    if (self.currentVC == self.xc_nav) {
        return;
    } else {
        [self replaceController:self.currentVC newController:self.xc_nav];
    }
}

- (void)pushMineWithNotification:(NSNotification *)noti {
    UIButton *button = [self.xc_leftView viewWithTag:102];
    button.selected = YES;
    
    UIButton *button1 = [self.xc_leftView viewWithTag:100];
    button1.selected = NO;
    
    if (self.currentVC == self.mineVc) {
        
        return;
    } else {
        
        [self replaceController:self.currentVC newController:self.mineVc];
    }
    
    
}

- (void)pushTestReportWithNotification:(NSNotification *)noti {
    UIButton *button = [self.xc_leftView viewWithTag:102];
    button.selected = YES;
    
    UIButton *button1 = [self.xc_leftView viewWithTag:100];
    button1.selected = NO;
    
    if (self.currentVC == self.mineVc) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"testReport2" object:self userInfo:noti.userInfo];
        
        return;
    } else {
        [self replaceController:self.currentVC newController:self.mineVc];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"testReport2" object:self userInfo:noti.userInfo];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self setUpNewController];
    
    // 添加通知  进入教室的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popView:) name:kPopoverCourseAlterViewNotification object:nil];
    
    [self updateNewVersion];
    
    [self getCacheSize];
}

// 添加通知  进入教室的通知
- (void)popView:(NSNotification *)noit {
    NSDictionary *userInfo = noit.userInfo;
    NSLog(@"--%@--", userInfo);
    
    GGT_CourseCellModel *model = userInfo[xc_message];
    
    self.xc_course_model = model;
    
    if (![model isKindOfClass:[GGT_CourseCellModel class]]) {
        return;
    }
    
    NSString *timeStr = @"";
    if ([model.StartTime isKindOfClass:[NSString class]]) {
        timeStr = [model.StartTime componentsSeparatedByString:@" "].lastObject;
    }
    
    NSString *titleString = [NSString stringWithFormat:@"%@的课程即将开始", timeStr];
    
    @weakify(self);
    [GGT_PopAlertView viewWithTitle:titleString message:@"" bottomButtonTitle:@"进入教室" bgImg:@"jijiangkaike_background" type:XCPopTypeEnterRoom cancleBlock:^{
        @strongify(self);
        NSLog(@"---点的是叉号---%@", self);
    } enterBlock:^{
        
//        @weakify(self);
        [GGT_ClassroomManager chooseClassroomWithViewController:self courseModel:model leftRoomBlock:^{
            @strongify(self);
            NSLog(@"%@", self);
        }];
        
    }];
}

// 进入教室调用接口
- (void)postNetworkModifyLessonStatusWithCourseModel:(GGT_CourseCellModel *)model {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"LessonId"] = model.LessonId;
    
    NSString *url = [NSString stringWithFormat:@"%@?LessonId=%@", URL_ModifyLessonStatus, model.LessonId];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setUpNewController {
    self.scheduleVC = [GGT_ScheduleViewController new];
    self.xc_nav = [[BaseNavigationController alloc] initWithRootViewController:self.scheduleVC];
    [self.xc_nav.view setFrame:CGRectMake(self.xc_leftView.width, 0, SCREEN_WIDTH()-self.xc_leftView.width, SCREEN_HEIGHT())];
    [self addChildViewController:self.xc_nav];
    
    
    self.orderCourseVc = [GGT_OrderCourseViewController new];
    self.xc_nav1 = [[BaseNavigationController alloc] initWithRootViewController:self.orderCourseVc];
    [self.xc_nav1.view setFrame:CGRectMake(self.xc_leftView.width, 0, SCREEN_WIDTH()-self.xc_leftView.width, SCREEN_HEIGHT())];
    
    self.mineVc = [[GGT_MineSplitViewController alloc] init];
    [self.mineVc.view setFrame:CGRectMake(self.xc_leftView.width, 0, SCREEN_WIDTH()-self.xc_leftView.width, SCREEN_HEIGHT())];
    
    //  默认,第一个视图(你会发现,全程就这一个用了addSubview)
    [self.view addSubview:self.xc_nav.view];
    self.currentVC = self.xc_nav;
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController {
    /*
     transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.3f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        } else {
            self.currentVC = oldController;
        }
    }];
}

- (void)initView {
    @weakify(self);
    self.xc_leftView = [[GGT_HomeLeftView alloc]init];
    self.xc_leftView = [[GGT_HomeLeftView alloc]initWithFrame:CGRectMake(0, 0, LineW(home_leftView_width), SCREEN_HEIGHT())];
    [self.view addSubview:self.xc_leftView];
    
    self.xc_leftView.buttonClickBlock = ^(UIButton *button) {
        @strongify(self);
        switch (button.tag) {
            case 100:
            {
                //点击处于当前页面的按钮,直接跳出
                if (self.currentVC == self.xc_nav) {
                    return;
                } else {
                    [self replaceController:self.currentVC newController:self.xc_nav];
                }
            }
                break;
            case 101:
            {
                if (self.currentVC == self.xc_nav1) {
                    return;
                } else {
                    [self replaceController:self.currentVC newController:self.xc_nav1];
                }
            }
                break;
            case 102:
            {
                if (self.currentVC == self.mineVc) {
                    return;
                } else {
                    [self replaceController:self.currentVC newController:self.mineVc];
                }
            }
                break;
            case 103:
            {
                GGT_CheckDevicePopViewController *vc = [GGT_CheckDevicePopViewController new];
                BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
                
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                nav.popoverPresentationController.delegate = self;
                //    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                // 修改弹出视图的size 在控制器内部修改更好
                //    vc.preferredContentSize = CGSizeMake(100, 100);
                [self presentViewController:nav animated:YES completion:nil];
                
            }
                break;
            case 104:
            {
                @weakify(self);
                [GGT_PopAlertView viewWithTitle:xc_servicePhoneNum message:xc_serviceTime bottomButtonTitle:xc_humanCheckTitle bgImg:@"rengongzaixianzhichi_background" type:XCPopTypeHumanService cancleBlock:^{
                    @strongify(self);
                    NSLog(@"---点的是叉号---%@", self);
                } enterBlock:^{
                    @strongify(self);
                    NSLog(@"---点按钮---%@", self);
                    
                    [self getHumanCheckClassroomInfo];
                    
                }];
                
            }
                break;
                
            default:
                break;
        }
    };
}

// 获取人工检测设备房间的信息
- (void)getHumanCheckClassroomInfo {
    [[BaseService share] sendGetRequestWithPath:URL_GetOnlineInfns token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        // 进入教室
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            GGT_CourseCellModel *model = [GGT_CourseCellModel yy_modelWithDictionary:responseObject[@"data"]];
            if (![model.nickname isKindOfClass:[NSString class]] || model.nickname.length == 0) {
                model.nickname = @"Student";
            }
            [GGT_ClassroomManager tk_enterClassroomWithViewController:self courseModel:model leftRoomBlock:^{
                
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}





- (void)updateNewVersion {
    
    // 版本号
    NSString *version = [APP_VERSION() stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?Version=%@", URL_VersionUpdateNew,version];
    
    [[BaseService share] sendGetRequestWithPath:urlStr token:NO viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            GGT_UpdateModel *model = [GGT_UpdateModel yy_modelWithDictionary:responseObject[@"data"]];
            [self popAlertVCWithModel:model];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)popAlertVCWithModel:(GGT_UpdateModel *)model {
    //Type类型：0 非强制性更新  1 强制性更新  2 已是最新版本，不用更新
    if ([model.Title isKindOfClass:[NSString class]] && [model.Contents isKindOfClass:[NSString class]]) {
        
        UIAlertController *alterC = [UIAlertController alertControllerWithTitle:model.Title message:model.Contents preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *firstAction = nil;
        UIAlertAction *secondAction = nil;
        
        if ([model.FirstButton isKindOfClass:[NSString class]]) {
            firstAction = [UIAlertAction actionWithTitle:model.FirstButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
        }
        
        if ([model.LastButton isKindOfClass:[NSString class]]) {
            secondAction = [UIAlertAction actionWithTitle:model.LastButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([model.Url isKindOfClass:[NSString class]]) {
                    //对中文地址进行编码处理，否则会跳转失败
                    NSString *urlStr = [model.Url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
                
                if ([model.Type isKindOfClass:[NSString class]] && [model.Type isEqualToString:@"1"]) {
                    [self updateNewVersion];
                }
                
            }];
        }
        
        firstAction.textColor = UICOLOR_FROM_HEX(Color777777);
        secondAction.textColor = UICOLOR_FROM_HEX(kThemeColor);
        
        if ([model.Type isEqualToString:@"0"]) {
            [alterC addAction:firstAction];
        }
        
        [alterC addAction:secondAction];
        
        
        
        if (![model.Type isEqualToString:@"2"]) {
            [self presentViewController:alterC animated:YES completion:nil];
        }
        
    }
    
}


#pragma mark 计算缓存大小
-(void)getCacheSize {
    // 执⾏耗时的异步操作...
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求数据
        NSString *folderSize = [NSString stringWithFormat:@"%.2fMB",[self folderSize]];
        // 回到主线程,执⾏UI刷新操作
        dispatch_async(dispatch_get_main_queue(), ^{
            //对图片或别的操作进行赋值等，回到主线程
            GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
            sin.cacheSize = folderSize;
        });
    });
}

// 缓存大小
- (CGFloat)folderSize{
    CGFloat folderSize = 0.0;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    NSLog(@"文件地址：%@---%@",cachePath,[self class]);
    
    for(NSString *path in files) {
        
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0 /1024.0;
    
    return sizeM;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


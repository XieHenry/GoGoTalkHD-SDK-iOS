//
//  BJRoomViewController.m
//  BJLiveCore
//
//  Created by MingLQ on 2016-12-18.
//  Copyright © 2016 Baijia Cloud. All rights reserved.
//

#import <BJLiveCore/BJLiveCore.h>
//#import <Masonry/Masonry.h>

#import "UIViewController+BJUtil.h"

#import "BJRoomViewController.h"
#import "BJRoomViewController+media.h"
#import "BJRoomViewController+users.h"

#import "BJAppearance.h"
#import "BJAppConfig.h"

#import "GGT_PopoverController.h"

//#import <YYModel/YYModel.h>

static CGFloat const margin = 10.0;

//static CGFloat const xc_videoWidth = 286;
static CGFloat const xc_videoWidth = 235;
//static CGFloat const xc_videoHeight = 215;
static CGFloat const xc_chatBarHeight = 44.0f;
static CGFloat const xc_drawBarHeight = 68.0f;

@interface BJRoomViewController ()<UIPopoverPresentationControllerDelegate>

@property (nonatomic) UIView *topBarGroupView;
@property (nonatomic) UIButton *xc_commonButton;
@property (nonatomic) UITextField *textField;

//@property (nonatomic) UIView *dashboardGroupView;

// 顶部导航栏
@property (nonatomic) UIView *xc_topNavigationView;
@property (nonatomic) UILabel *xc_titleLabel;
@property (nonatomic) UIButton *xc_backButton;

// 右侧视频聊天区域
@property (nonatomic) UIView *xc_rightParentView;

// 视频下面的分割线
@property (nonatomic, strong) UIView *xc_recordingViewLineView;
@property (nonatomic, strong) UIView *xc_playingViewLineView;

// 左侧白板区域
@property (nonatomic) UIView *xc_leftParentView;

// 左侧画笔区域
@property (nonatomic) UIView *xc_drawParentView;

// 常用语
@property (nonatomic, strong) NSMutableArray *xc_phraseMuArray;

@end

@implementation BJRoomViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark 加载常用语
    [self xc_loadPhraseData];
    
    // 顶部导航栏
    [self makeTopBar];
    
    // 右侧视频聊天区域
    [self makeRightView];
    
    // 左侧区域
    [self makeLeftView];

    
    [self makeEvents];
    
    // 配置UI
    [self configUI];
}

// 设置颜色值
- (void)configUI
{
    
    self.xc_rightParentView.backgroundColor = UICOLOR_FROM_HEX(0x3e3e3e);
    self.xc_leftParentView.backgroundColor = UICOLOR_FROM_HEX(0x1c1c1c);
    self.console.view.backgroundColor = UICOLOR_FROM_HEX(0x3e3e3e);
    
    self.recordingView.backgroundColor = UICOLOR_FROM_HEX(0x2f2f2f);
    [self.recordingView setTitle:@"" forState:UIControlStateNormal];
    [self.recordingView setBackgroundImage:UIIMAGE_FROM_NAME(@"icon_teacher_big") forState:UIControlStateNormal];
    [self.recordingView setBackgroundImage:UIIMAGE_FROM_NAME(@"icon_teacher_big") forState:UIControlStateHighlighted];
    
    self.playingView.backgroundColor = UICOLOR_FROM_HEX(0x2f2f2f);
    [self.playingView setTitle:@"" forState:UIControlStateNormal];
    [self.playingView setBackgroundImage:UIIMAGE_FROM_NAME(@"icon_user_big") forState:UIControlStateNormal];
    [self.playingView setBackgroundImage:UIIMAGE_FROM_NAME(@"icon_user_big") forState:UIControlStateHighlighted];

}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (NSString *)creatAPISign:(GGT_CourseCellModel *)model userName:(NSString *)userName
{
    /*
     room_id        // 房间号
     user_avatar    // 学生头像
     user_name      // 用户登录名（手机号）
     user_number    // 后台用户id
     user_role      // 登录类型 老师还是学生
     partner_key    // 唯一key
     */
    NSString *apiSign = [NSString stringWithFormat:@"room_id=%@&user_avatar=%@&user_name=%@&user_number=%@&user_role=%@&partner_key=%@", model.serial, model.user_avatar,userName, model.user_number, @"0", model.partner_key];
    return [apiSign xc_toMD5];
}

- (void)enterRoomWithSecret:(NSString *)roomSecret
                   userName:(NSString *)userName
            courseCellModel:(GGT_CourseCellModel *)model {
    self.room = [BJLRoom roomWithSecret:roomSecret
                               userName:userName
                             userAvatar:nil];
    // BJLRoom.deployType = [BJAppConfig sharedInstance].deployType;
    
    BJLUser *user = [BJLUser userWithNumber:model.user_number
                                       name:userName
                                     avatar:model.user_avatar
                                       role:BJLUserRole_student];
    self.room = [BJLRoom roomWithID:model.serial
                            apiSign:[self creatAPISign:model userName:userName]
                               user:user];
    
#warning test
    /**
     参加码方式
     @param roomSecret   教室参加码
     */
//    roomSecret = @"n4ka2d";
//    self.room = [BJLRoom roomWithSecret:roomSecret
//                               userName:userName
//                             userAvatar:nil];
#warning test

    
    
    
    
    self.xc_titleLabel.text = model.LessonName;
    
    @weakify(self);
    
    [self bjl_observe:BJLMakeMethod(self.room, enterRoomSuccess)
             observer:^BOOL() {
                 @strongify(self);
                 if (self.room.loginUser.isTeacher) {
                     [self.room.roomVM sendLiveStarted:YES]; // 上课
                 }
                 [self didEnterRoom];
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(self.room, roomWillExitWithError:)
             observer:^BOOL(BJLError *error) {
                 @strongify(self);
                 if (self.room.loginUser.isTeacher) {
                     [self.room.roomVM sendLiveStarted:NO]; // 下课
                 }
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(self.room, roomDidExitWithError:)
             observer:^BOOL(BJLError *error) {
                 @strongify(self);
                 
                 return YES;
                 /*
                 if (!error) {
                     [self goBack];
                     return YES;
                 }
                 
                 NSString *message = error ? [NSString stringWithFormat:@"%@ - %@",
                                              error.localizedDescription,
                                              error.localizedFailureReason] : @"错误";
                 UIAlertController *alert = [UIAlertController
                                             alertControllerWithTitle:@"错误"
                                             message:message
                                             preferredStyle:UIAlertControllerStyleAlert];
                 [alert addAction:[UIAlertAction
                                   actionWithTitle:@"退出"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       [self goBack];
                                   }]];
                 [alert addAction:[UIAlertAction
                                   actionWithTitle:@"知道了"
                                   style:UIAlertActionStyleCancel
                                   handler:nil]];
                 [self presentViewController:alert animated:YES completion:nil];
                 
                 return YES;
                 */
             }];
    
    [self bjl_kvo:BJLMakeProperty(self.room, loadingVM)
           filter:^BOOL(id old, id now) {
               // @strongify(self);
               return !!now;
           }
         observer:^BOOL(id old, BJLLoadingVM *now) {
             @strongify(self);
             [self makeEventsForLoadingVM:now];
             return YES;
         }];
    
    [self.room setReloadingBlock:^(BJLLoadingVM * _Nonnull reloadingVM, void (^ _Nonnull callback)(BOOL)) {
        @strongify(self);
        [self.console printLine:@"网络连接断开"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络连接断开"
                                                                       message:@"重连 或 退出？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"重连"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * _Nonnull action) {
                              [self.console printLine:@"网络连接断开，正在重连 ..."];
                              [self makeEventsForLoadingVM:reloadingVM];
                              [self.console printLine:@"网络连接断开：重连"];
                              callback(YES);
                          }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"退出"
                          style:UIAlertActionStyleDestructive
                          handler:^(UIAlertAction * _Nonnull action) {
                              [self.console printLine:@"网络连接断开：退出"];
                              callback(NO);
                          }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [self.room enter];
}

#pragma mark - subviews

// 顶部导航栏
- (void)makeTopBar {
    
    // 顶部导航条
    self.xc_topNavigationView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(0x29292a);
        view;
    });
    [self.view addSubview:self.xc_topNavigationView];
    
    [self.xc_topNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(64));
    }];
    
    // 返回按钮
    self.xc_backButton = ({
        UIImage *backImage = [UIImage imageNamed:@"fanhui_top"];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
//        button.tintColor = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil].tintColor;
        [button setImage:backImage forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, button.width-backImage.size.width)];//
        button;
    });
    [self.xc_topNavigationView addSubview:self.xc_backButton];
    
    [self.xc_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_topNavigationView).offset(margin20);
        make.bottom.equalTo(self.xc_topNavigationView.mas_bottom);
        make.width.equalTo(@(self.xc_backButton.width));
        make.height.equalTo(@(self.xc_backButton.height));
    }];

    
    // title文字
    self.xc_titleLabel = ({
        UILabel *xc_titleLabel = [UILabel new];
        xc_titleLabel.textColor = [UIColor whiteColor];
        xc_titleLabel.text = @"hello world";
        xc_titleLabel;
    });
    [self.xc_topNavigationView addSubview:self.xc_titleLabel];
    [self.xc_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_backButton.mas_right);
        make.centerY.equalTo(self.xc_backButton);
    }];
}

// 右侧区域
- (void)makeRightView {
    
    // 右侧父view
    self.xc_rightParentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor purpleColor];
        view;
    });
    [self.view addSubview:self.xc_rightParentView];
    
    [self.xc_rightParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.width.equalTo(@(xc_videoWidth));
        make.top.equalTo(self.xc_topNavigationView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    
    // 播放老师的视频
    self.playingView = ({
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor redColor];
        button.clipsToBounds = YES;
        button;
    });
    [self.playingView setTitle:@"老师" forState:UIControlStateNormal];
    [self.xc_rightParentView addSubview:self.playingView];
    [self.playingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_rightParentView.mas_top).mas_offset(margin10);
        make.left.equalTo(self.xc_rightParentView.mas_left).mas_offset(margin10);
        make.right.equalTo(self.xc_rightParentView.mas_right).mas_offset(-margin10);
        make.height.equalTo(self.playingView.mas_width).multipliedBy(3.0 / 4.0);
    }];
    
    // 老师视频底部的黑线
    self.xc_playingViewLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(0x212121);
        view;
    });
    [self.xc_rightParentView addSubview:self.xc_playingViewLineView];
    [self.xc_playingViewLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playingView.mas_bottom);
        make.left.right.equalTo(self.playingView);
        make.height.equalTo(@(margin20));
    }];
    
    
    // 采集自己的视频
    self.recordingView = ({
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor orangeColor];
        button.clipsToBounds = YES;
        button;
    });
    [self.recordingView setTitle:@"学生" forState:UIControlStateNormal];
    [self.xc_rightParentView addSubview:self.recordingView];
    [self.recordingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_playingViewLineView.mas_bottom);
        make.left.right.height.equalTo(self.playingView);
    }];
    
    // 自己视频底部的黑线
    self.xc_recordingViewLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(0x212121);
        view;
    });
    [self.xc_rightParentView addSubview:self.xc_recordingViewLineView];
    [self.xc_recordingViewLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.recordingView);
        make.top.equalTo(self.recordingView.mas_bottom);
        make.height.equalTo(@(margin20));
    }];
    
    
    
    // 聊天面板区域
    self.console = [BJConsoleViewController new];
    [self addChildViewController:self.console superview:self.xc_rightParentView];
    [self.console.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_recordingViewLineView.mas_bottom);
        make.left.right.equalTo(self.playingView);
        make.bottom.equalTo(self.xc_rightParentView.mas_bottom).offset(-xc_chatBarHeight);
    }];
    
    // 聊天输入框
    [self makeChatTextField];
    
}


// 聊天输入框
- (void)makeChatTextField
{
    self.topBarGroupView = ({
        UIView *view = [UIView new];
        view.clipsToBounds = YES;
        view;
    });
    [self.xc_rightParentView addSubview:self.topBarGroupView];
    [self.topBarGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.xc_rightParentView);
        make.top.equalTo(self.console.view.mas_bottom);
    }];
    
    
    // 分割线
    UIView *xc_lineView = [UIView new];
    xc_lineView.backgroundColor = UICOLOR_FROM_HEX(0x2f2f2f);
    [self.topBarGroupView addSubview:xc_lineView];
    [xc_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarGroupView);
        make.left.right.equalTo(self.topBarGroupView);
        make.height.equalTo(@(0.5));
    }];
    
    
    self.textField = ({
        UITextField *textField = [UITextField new];
        textField.placeholder = @"说点什么吧";
        textField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName : UICOLOR_FROM_HEX(0xf4f4f4), NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        textField.backgroundColor = UICOLOR_FROM_HEX(0x3e3e3e);
        textField.layer.cornerRadius = 2.0;
        textField.layer.masksToBounds = YES;
        textField.returnKeyType = UIReturnKeySend;
        textField.delegate = self;
        textField.textColor = UICOLOR_FROM_HEX(0xf4f4f4);
        textField;
    });
    [self.topBarGroupView addSubview:self.textField];
    
    self.xc_commonButton = ({
        UIButton *button = [UIButton new];
        button.layer.cornerRadius = 2.0;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateDisabled];
//        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setImage:UIIMAGE_FROM_NAME(@"changyongyu_wei") forState:UIControlStateNormal];
        [button setImage:UIIMAGE_FROM_NAME(@"chongyongyu_yi") forState:UIControlStateSelected];
        button;
    });
    [self.topBarGroupView addSubview:self.xc_commonButton];
    
    [self.xc_commonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topBarGroupView).offset(- margin);
        make.width.equalTo(@64);
        make.top.bottom.equalTo(self.topBarGroupView).mas_offset(0.5);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarGroupView.mas_left).offset(margin);
        make.right.equalTo(self.xc_commonButton.mas_left).offset(- margin);
        make.top.bottom.equalTo(self.topBarGroupView).mas_offset(0.5);
    }];

}

// 左侧区域
- (void)makeLeftView
{
    
    // 左侧父view
    self.xc_leftParentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor purpleColor];
        view;
    });
    [self.view addSubview:self.xc_leftParentView];
    
    [self.xc_leftParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topNavigationView.mas_bottom);
        make.left.bottom.equalTo(self.view);
        make.right.equalTo(self.xc_rightParentView.mas_left);
    }];
    
    
    // 白板
    self.slideshowAndWhiteboardView = ({
        UIView *view = [UIView new];
        view.clipsToBounds = YES;
        UILabel *label = [UILabel new];
//        label.text = @"白板";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        view;
    });
    [self.xc_leftParentView addSubview:self.slideshowAndWhiteboardView];
    [self.slideshowAndWhiteboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.xc_leftParentView);
        make.bottom.equalTo(self.xc_leftParentView.mas_bottom).offset(-xc_drawBarHeight);
    }];
    
    [self makeDrawParentView];
}

/// 底部xc_bottomParentView
- (void)makeDrawParentView
{
    // 父view
    self.xc_drawParentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        view;
    });
    [self.xc_leftParentView addSubview:self.xc_drawParentView];
    
    [self.xc_drawParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slideshowAndWhiteboardView.mas_bottom);
        make.bottom.left.right.equalTo(self.xc_leftParentView);
    }];
    
    // 分割线
    UIView *xc_lineView = [UIView new];
    xc_lineView.backgroundColor = [UIColor whiteColor];
    [self.xc_drawParentView addSubview:xc_lineView];
    [xc_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.xc_drawParentView);
        make.width.equalTo(@(1));
        make.center.equalTo(self.xc_drawParentView);
    }];
    
    // 子xc_cleanButton
    self.xc_cleanButton = ({
        UIButton *xc_cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xc_cleanButton setImage:UIIMAGE_FROM_NAME(@"cexiao_wei") forState:UIControlStateNormal];
        [xc_cleanButton setImage:UIIMAGE_FROM_NAME(@"cexiao_wei_copy") forState:UIControlStateHighlighted];
        [xc_cleanButton setBackgroundColor:UICOLOR_FROM_HEX(ColorF2F2F2)];
        [xc_cleanButton sizeToFit];
        xc_cleanButton;
    });
    [self.xc_drawParentView addSubview:self.xc_cleanButton];
    
    [self.xc_cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xc_drawParentView.mas_centerX).multipliedBy(1.0/2.0);
        make.centerY.equalTo(self.xc_drawParentView);
    }];
    
    // 子xc_drawButton
    self.xc_drawButton = ({
        UIButton *xc_drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xc_drawButton setImage:UIIMAGE_FROM_NAME(@"huabi_wei") forState:UIControlStateNormal];
        [xc_drawButton setImage:UIIMAGE_FROM_NAME(@"huabi_wei_copy") forState:UIControlStateSelected];
        [xc_drawButton setFrame:CGRectMake(0, 0, self.xc_drawParentView.width/2.0, self.xc_drawParentView.height)];
        [xc_drawButton setBackgroundColor:UICOLOR_FROM_HEX(ColorF2F2F2)];
        [xc_drawButton sizeToFit];
        xc_drawButton;
    });
    [self.xc_drawParentView addSubview:self.xc_drawButton];
    
    [self.xc_drawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xc_drawParentView.mas_centerX).multipliedBy(3.0/2.0);
        make.centerY.equalTo(self.xc_drawParentView);
    }];
    
    
    self.pageNumLabel = ({
        UILabel *xc_titleLabel = [UILabel new];
        xc_titleLabel.textColor = [UIColor blackColor];
        xc_titleLabel.font = [UIFont systemFontOfSize:18];
        xc_titleLabel;
    });
    [self.slideshowAndWhiteboardView.superview addSubview:self.pageNumLabel];
    
    [self.pageNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.slideshowAndWhiteboardView.mas_centerX);
        make.bottom.equalTo(self.slideshowAndWhiteboardView.mas_bottom).offset(-margin10);
        make.height.mas_equalTo(50);
    }];
    
}


#pragma mark - VM

- (void)didEnterRoom {
    
    [self bjl_kvo:BJLMakeProperty(self.room.roomVM, liveStarted)
                       filter:^BOOL(NSNumber *old, NSNumber *now) {
                           return old.integerValue != now.integerValue;
                       }
                     observer:^BOOL(id old, id now) {
                         return YES;
                     }];
    [self makeUserEvents];
    [self makeMediaEvents];
    [self makeChatEvents];
    
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    sin.isInRoom = YES;
}

- (void)makeEventsForLoadingVM:(BJLLoadingVM *)loadingVM {
    @weakify(self/* , loadingVM */);
    
    loadingVM.suspendBlock = ^(BJLLoadingStep step,
                               BJLLoadingSuspendReason reason,
                               BJLError *error,
                               void (^continueCallback)(BOOL isContinue)) {
        @strongify(self/* , loadingVM */);
        
        if (reason == BJLLoadingSuspendReason_stepOver) {
//            [self.console printFormat:@"loading step over: %td", step];
            continueCallback(YES);
            return;
        }
//        [self.console printFormat:@"loading step suspend: %td", step];
        
        NSString *message = nil;
        if (reason == BJLLoadingSuspendReason_errorOccurred) {
            message = error ? [NSString stringWithFormat:@"%@ - %@",
                               error.localizedDescription,
                               error.localizedFailureReason] : @"错误";
        }
        if (message) {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:reason != BJLLoadingSuspendReason_errorOccurred ? @"提示" : @"错误"
                                        message:message
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction
                              actionWithTitle:reason != BJLLoadingSuspendReason_errorOccurred ? @"继续" : @"重试"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * _Nonnull action) {
                                  continueCallback(YES);
                              }]];
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"取消"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * _Nonnull action) {
                                  continueCallback(NO);
                              }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    };
    
    [self bjl_observe:BJLMakeMethod(loadingVM, loadingUpdateProgress:)
             observer:(BJLMethodObserver)^BOOL(CGFloat progress) {
                 @strongify(self/* , loadingVM */);
//                 [self.console printFormat:@"loading progress: %f", progress];
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(loadingVM, loadingSuccess)
             observer:^BOOL() {
                 @strongify(self/* , loadingVM */);
//                 [self.console printLine:@"loading success"];
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(loadingVM, loadingFailureWithError:)
             observer:^BOOL(BJLError *error) {
                 @strongify(self/* , loadingVM */);
//                 [self.console printLine:@"loading failure"];
                 return YES;
             }];
}

- (void)makeChatEvents {
    @weakify(self);
    
    [self bjl_observe:BJLMakeMethod(self.room.chatVM, didReceiveMessage:)
             observer:^BOOL(BJLMessage *message) {
                 @strongify(self);
                 [self.console printFormat:@"%@: %@", message.fromUser.name, message.text];
                 return YES;
             }];
}

- (void)startPrintAVDebugInfo {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
    
//    [self.console printFormat:@"---- av - %f ----", [NSDate timeIntervalSinceReferenceDate]];
    for (NSString *info in [self.room.mediaVM avDebugInfo]) {
        [self.console printLine:info];
    }
    
    [self performSelector:_cmd withObject:nil afterDelay:1.0];
}

- (void)stopPrintAVDebugInfo {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startPrintAVDebugInfo) object:nil];
}

#pragma mark - 按钮事件 常用语按钮和退出教室按钮
- (void)makeEvents {
    @weakify(self);
    
    [[self.textField.rac_textSignal
      map:^id(NSString *text) {
          return @(!!text.length);
      }]
     subscribeNext:^(NSNumber *enabled) {
//         @strongify(self);
//         self.xc_commonButton.enabled = enabled.boolValue;
     }];
    
    [[self.xc_backButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self goBack];
     }];
    
    [[self.xc_commonButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
//         [self sendMessage];
         self.xc_commonButton.selected = YES;
         [self.view endEditing:YES];
         [self showPopView:self.xc_commonButton];
         
     }];
}

#pragma mark - 退出教室
- (void)goBack {
    
    UIAlertController *alterC = [UIAlertController alertControllerWithTitle:@"确定要退出教室" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 退出教室
        [self.room exit];
        [self dismissViewControllerAnimated:YES completion:^{
            self.room = nil;
        }];
        GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
        sin.isInRoom = NO;
    }];
    
    firstAction.textColor = UICOLOR_FROM_HEX(Color777777);
    secondAction.textColor = UICOLOR_FROM_HEX(kThemeColor);
    
    [alterC addAction:firstAction];
    [alterC addAction:secondAction];
    
    [self presentViewController:alterC animated:YES completion:nil];
    
}

/// 发送消息
- (void)sendMessage {
    [self.view endEditing:YES];
    if (!self.textField.text.length) {
        return;
    }
    if ([self.textField.text isEqualToString:@"-av"]) {
        self.textField.text = nil;
        [self startPrintAVDebugInfo];
        return;
    }
    if (!self.room.chatVM.forbidAll && !self.room.chatVM.forbidMe) {
        [self.room.chatVM sendMessage:self.textField.text];
    }
    else {
        [self.console printLine:@"禁言状态不能发送消息"];
    }
    self.textField.text = nil;
}

#pragma mark - <UITextFieldDelegate> 发送聊天消息
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage];
    return NO;
}


#pragma mark - 获取聊天界面 常用语数据
- (void)xc_loadPhraseData
{
    self.xc_phraseMuArray = [NSMutableArray array];
    
    [[BaseService share] sendGetRequestWithPath:URL_GetContrastInfo token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        NSArray *data = responseObject[@"data"];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGT_CoursePhraseModel *model = [GGT_CoursePhraseModel yy_modelWithDictionary:obj];
            [self.xc_phraseMuArray addObject:model];
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)showPopView:(UIButton *)button
{
    //showPopView
    GGT_PopoverController *vc = [GGT_PopoverController new];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.popoverPresentationController.sourceView = self.xc_commonButton;
    vc.popoverPresentationController.sourceRect = button.bounds;
    vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    vc.popoverPresentationController.delegate = self;
    
    vc.xc_phraseMuArray = self.xc_phraseMuArray;
    
    // 修改弹出视图的size 在控制器内部修改更好
    //    vc.preferredContentSize = CGSizeMake(100, 100);
    [self presentViewController:vc animated:YES completion:nil];
    
    @weakify(self)
    vc.dismissBlock = ^(NSString *selectString) {
        @strongify(self);
        NSLog(@"点击了---%@", selectString);
        button.selected = NO;
        if ([selectString isKindOfClass:[NSString class]]) {
            if (selectString.length>0) {
                self.textField.text = selectString;
                [self sendMessage];
                self.textField.text = @"";
            }
        }
    };
}

#pragma mark - UIPopoverPresentationControllerDelegate
//默认返回的是覆盖整个屏幕，需设置成UIModalPresentationNone。
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

//点击蒙版是否消失，默认为yes；
-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    self.xc_commonButton.selected = NO;
    return YES;
}

//弹框消失时调用的方法
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    NSLog(@"弹框已经消失");
}


@end

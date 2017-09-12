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

//#import <YYModel/YYModel.h>

static CGFloat const margin = 10.0;

static CGFloat const xc_videoWidth = 286;
static CGFloat const xc_videoHeight = 215;
static CGFloat const xc_chatBarHeight = 44.0f;
static CGFloat const xc_drawBarHeight = 68.0f;

@interface BJRoomViewController ()

@property (nonatomic) UIView *topBarGroupView;
@property (nonatomic) UIButton *doneButton;
@property (nonatomic) UITextField *textField;

//@property (nonatomic) UIView *dashboardGroupView;

// 顶部导航栏
@property (nonatomic) UIView *xc_topNavigationView;
@property (nonatomic) UILabel *xc_titleLabel;
@property (nonatomic) UIButton *xc_backButton;

// 右侧视频聊天区域
@property (nonatomic) UIView *xc_rightParentView;

// 左侧白板区域
@property (nonatomic) UIView *xc_leftParentView;

// 左侧画笔区域
@property (nonatomic) UIView *xc_drawParentView;

@end

@implementation BJRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 顶部导航栏
    [self makeTopBar];
    
    
    
    // 右侧视频聊天区域
    [self makeRightView];
    
    // 左侧区域
    [self makeLeftView];

    
    [self makeEvents];
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)enterRoomWithSecret:(NSString *)roomSecret
                   userName:(NSString *)userName {
    self.room = [BJLRoom roomWithSecret:roomSecret
                               userName:userName
                             userAvatar:nil];
    // BJLRoom.deployType = [BJAppConfig sharedInstance].deployType;
    
    /*
    self.room = [BJLRoom roomWithID:@"17042853877073"
                            apiSign:@"c017b76c976568f96ef7208e43b3eea7"
                            user:[BJLUser userWithNumber:@"1602910"
                                                    name:@"尚德111"
                                                  avatar:@"http://static.sunlands.com/user_center_test/newUserImagePath/1602910/1602910.jpg"
                                                    role:BJLUserRole_student]]; */
    
    @weakify(self);
    
    [self bjl_observe:BJLMakeMethod(self.room, enterRoomSuccess)
             observer:^BOOL(id data) {
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
        view.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
        view;
    });
    [self.view addSubview:self.xc_topNavigationView];
    
    [self.xc_topNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(64));
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
        make.centerX.equalTo(self.xc_topNavigationView);
        make.bottom.equalTo(@(-10));
    }];
    
    // 返回按钮
    self.xc_backButton = ({
        UIImage *backImage = [UIImage imageNamed:@"fanhui_top"];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
        button.tintColor = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil].tintColor;
        [button setImage:backImage forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, button.width-backImage.size.width)];//
        button;
    });
    [self.xc_topNavigationView addSubview:self.xc_backButton];
    
    [self.xc_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_topNavigationView).offset(margin20);
        make.centerY.equalTo(self.xc_titleLabel);
        make.width.equalTo(@(self.xc_backButton.width));
        make.height.equalTo(@(self.xc_backButton.height));
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
    
    
    
    // 学生视频
    self.recordingView = ({
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor orangeColor];
        button.clipsToBounds = YES;
        button;
    });
    [self.recordingView setTitle:@"采集" forState:UIControlStateNormal];
    [self.view addSubview:self.recordingView];
    [self.recordingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topNavigationView.mas_bottom);
        make.left.equalTo(self.xc_rightParentView);
        make.width.equalTo(@(xc_videoWidth));
        make.height.equalTo(self.recordingView.mas_width).multipliedBy(3.0 / 4.0);
    }];
    
    
    // 老师视频
    self.playingView = ({
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor redColor];
        button.clipsToBounds = YES;
        button;
    });
    [self.playingView setTitle:@"播放" forState:UIControlStateNormal];
    [self.view addSubview:self.playingView];
    [self.playingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordingView.mas_bottom);
        make.left.right.height.equalTo(self.recordingView);
    }];
    
    
    // 聊天面板区域
    self.console = [BJConsoleViewController new];
    [self addChildViewController:self.console superview:self.xc_rightParentView];
    [self.console.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playingView.mas_bottom);
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
    
    self.textField = ({
        UITextField *textField = [UITextField new];
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.cornerRadius = 2.0;
        textField.layer.masksToBounds = YES;
        textField.returnKeyType = UIReturnKeySend;
        textField.delegate = self;
        textField;
    });
    [self.topBarGroupView addSubview:self.textField];
    
    self.doneButton = ({
        UIButton *button = [UIButton new];
        button.layer.cornerRadius = 2.0;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateDisabled];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        button;
    });
    [self.topBarGroupView addSubview:self.doneButton];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topBarGroupView).offset(- margin);
        make.width.equalTo(@64);
        make.top.bottom.equalTo(self.topBarGroupView);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBarGroupView.mas_left).offset(margin);
        make.right.equalTo(self.doneButton.mas_left).offset(- margin);
        make.top.bottom.equalTo(self.topBarGroupView);
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
        label.text = @"白板";
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
}


#pragma mark - VM

- (void)didEnterRoom {
    
    // 注销进度日志
//    [self.console printFormat:@"roomInfo ID: %@, title: %@",
//     self.room.roomInfo.ID,
//     self.room.roomInfo.title];
    
//    [self.console printFormat:@"loginUser ID: %@, number: %@, name: %@",
//     self.room.loginUser.ID,
//     self.room.loginUser.number,
//     self.room.loginUser.name];
    
    // if (!self.room.loginUser.isTeacher) {
    @weakify(self);
    [self bjl_kvo:BJLMakeProperty(self.room.roomVM, liveStarted)
                       filter:^BOOL(NSNumber *old, NSNumber *now) {
                           // @strongify(self);
                           return old.integerValue != now.integerValue;
                       }
                     observer:^BOOL(id old, id now) {
                         @strongify(self);
                         
                         // 注销进度日志
//                         [self.console printFormat:@"liveStarted: %@", self.room.roomVM.liveStarted ? @"YES" : @"NO"];
                         return YES;
                     }];
    // }
    
    [self makeUserEvents];
    [self makeMediaEvents];
    [self makeChatEvents];
}

- (void)makeEventsForLoadingVM:(BJLLoadingVM *)loadingVM {
    @weakify(self/* , loadingVM */);
    
    loadingVM.suspendBlock = ^(BJLLoadingStep step,
                               BJLLoadingSuspendReason reason,
                               BJLError *error,
                               void (^continueCallback)(BOOL isContinue)) {
        @strongify(self/* , loadingVM */);
        
        if (reason == BJLLoadingSuspendReason_stepOver) {
            
            // 注销进度日志
//            [self.console printFormat:@"loading step over: %td", step];
            continueCallback(YES);
            return;
        }
        
        // 注销进度日志
//        [self.console printFormat:@"loading step suspend: %td", step];
        
        NSString *message = nil;
        if (reason == BJLLoadingSuspendReason_askForWWANNetwork) {
            message = @"WWAN 网络";
        }
        else if (reason == BJLLoadingSuspendReason_errorOccurred) {
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
                 
                 
                 // 注销进度日志
//                 [self.console printFormat:@"loading progress: %f", progress];
                 
                 if (progress == 0) {
                     [MBProgressHUD showLoading:self.view];
                 }
                 
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(loadingVM, loadingSuccess)
             observer:^BOOL(id data) {
                 @strongify(self/* , loadingVM */);
                 
                 // 注销进度日志
//                 [self.console printLine:@"loading success"];
                 
                 [MBProgressHUD hideHUDForView:self.view];
                 
                 return YES;
             }];
    
    [self bjl_observe:BJLMakeMethod(loadingVM, loadingFailureWithError:)
             observer:^BOOL(BJLError *error) {
                 @strongify(self/* , loadingVM */);
                 
                 // 注销进度日志
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
    
    [self.console printFormat:@"---- av - %f ----", [NSDate timeIntervalSinceReferenceDate]];
    for (NSString *info in [self.room.mediaVM avDebugInfo]) {
        [self.console printLine:info];
    }
    
    [self performSelector:_cmd withObject:nil afterDelay:1.0];
}

- (void)stopPrintAVDebugInfo {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startPrintAVDebugInfo) object:nil];
}

#pragma mark - events

- (void)makeEvents {
    @weakify(self);
    
    [[self.textField.rac_textSignal
      map:^id(NSString *text) {
          return @(!!text.length);
      }]
     subscribeNext:^(NSNumber *enabled) {
         @strongify(self);
         self.doneButton.enabled = enabled.boolValue;
     }];
    
    [[self.xc_backButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self goBack];
     }];
    
    [[self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self sendMessage];
     }];
}

- (void)goBack {
    
#pragma mark - 需要弹框
    
    [self.room exit];
    [self dismissViewControllerAnimated:YES completion:^{
        self.room = nil;
    }];
}

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

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage];
    return NO;
}

@end

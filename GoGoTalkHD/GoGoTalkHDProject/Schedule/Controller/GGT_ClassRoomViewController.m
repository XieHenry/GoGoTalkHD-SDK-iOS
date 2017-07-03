//
//  GGT_ClassRoomViewController.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/8.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ClassRoomViewController.h"
#import "IQKeyboardManager.h"
#import "GGT_PopoverController.h"

static CGFloat const barHeight = 44.0;
static CGFloat const xc_bottomToolBarHeight = 68.0f;
static CGFloat const xc_videoWidth = 286.0f;

@interface GGT_ClassRoomViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPopoverPresentationControllerDelegate>

@property (nonatomic) UIView *room;

@property (nonatomic) UIButton *xc_recordingView, *xc_playingView;    // 录屏、播放
@property (nonatomic) UIView *xc_slideshowAndWhiteboardView;       // 白板

@property (nonatomic) UIViewController *console;         // 聊天界面

@property (nonatomic) UIButton *xc_cleanButton;
@property (nonatomic) UIButton *xc_drawButton;





// 设置状态栏的显示
@property (nonatomic) BOOL hidenStatus;

// 进入房间时的友好图片
@property (nonatomic) UIImageView *xc_friendlyImgView;

// 顶部view
@property (nonatomic) UIView *xc_topParentView;
@property (nonatomic) UIButton *xc_backButton;
@property (nonatomic) UILabel *xc_titleLabel;

// 下部所有view的父view
@property (nonatomic) UIView *xc_dashboardGroupView;

// 聊天的父view
@property (nonatomic) UIView *xc_consoleParentView;

// 聊天输入框view
@property (nonatomic) UIView *xc_chatBarParentView;
@property (nonatomic) UIButton *xc_chatCommonStrButton;
@property (nonatomic) UITextField *xc_chatTextField;

// 底部view
@property (nonatomic) UIView *xc_bottomToolBarParentView;
@end

@implementation GGT_ClassRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(0xF2F4F5);
    
    // 设置采集、播放、白板的区域
    [self initView];
    
    // 顶部view中发送消息和返回的事件
    [self makeEvents];
    
    _hidenStatus = NO;
    [self prefersStatusBarHidden];
    
    //    [self initFriendlyImgView];
    
    // 禁用IQKeyboard
    [self initKeyBoard];
}

// 添加进入房间时等待的友好图
- (void)initFriendlyImgView
{
    self.xc_friendlyImgView = ({
        UIImageView *xc_friendlyImgView = [UIImageView new];
        xc_friendlyImgView.image = UIIMAGE_FROM_NAME(@"引导页2");
        xc_friendlyImgView.transform = CGAffineTransformMakeRotation(M_PI/2.0);
        xc_friendlyImgView;
    });
    [self.view addSubview:self.xc_friendlyImgView];
    
    self.xc_friendlyImgView.frame = CGRectMake(0, 0, SCREEN_HEIGHT(), SCREEN_WIDTH());
}

#pragma mark - subviews
// 初始化所有view
- (void)initView {
    
    // 顶部导航栏
    [self init_mas_topParentView];
    
    // 下面所有视图
    [self init_mas_dashboard];
    
}

// dashboard
- (void)init_mas_dashboard
{
    // 初始化
    [self initDashboard];
    
    // 布局
    [self mas_dashboard];
    
    // 底部
    [self init_mas_bottomToolBarParentView];
}

// 顶部导航栏
- (void)init_mas_topParentView
{
    // 顶部栏
    self.xc_topParentView = ({
        UIView *xc_topParentView = [UIView new];
        xc_topParentView.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
        xc_topParentView;
    });
    [self.view addSubview:self.xc_topParentView];
    
    [self.xc_topParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(64));
    }];
    
    
    // title文字
    self.xc_titleLabel = ({
        UILabel *xc_titleLabel = [UILabel new];
        xc_titleLabel.textColor = [UIColor whiteColor];
        
        if ([self.xc_model.LessonName isKindOfClass:[NSString class]] && self.xc_model.LessonName.length > 0) {
            xc_titleLabel.text = self.xc_model.LessonName;
        } else {
            xc_titleLabel.text = @"";
        }
        
        xc_titleLabel;
    });
    [self.xc_topParentView addSubview:self.xc_titleLabel];
    [self.xc_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xc_topParentView);
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
    [self.xc_topParentView addSubview:self.xc_backButton];
    
    [self.xc_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_topParentView).offset(margin20);
        make.centerY.equalTo(self.xc_titleLabel);
        make.width.equalTo(@(self.xc_backButton.width));
        make.height.equalTo(@(self.xc_backButton.height));
    }];
    
}

// 初始化
- (void)initDashboard
{
    // 设置知识区的父view (包括采集、播放、白板) 初始化所有子控件的父view
    self.xc_dashboardGroupView = ({
        UIView *view = [UIView new];
        view.clipsToBounds = YES;
        view;
    });
    [self.view addSubview:self.xc_dashboardGroupView];
    
    
    // 初始化playingView
    self.xc_playingView = ({
        UIButton *button = [UIButton new];
        button.clipsToBounds = YES;
        button;
    });
    [self.xc_playingView setTitle:@"外教视频" forState:UIControlStateNormal];
    self.xc_playingView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
    [self.xc_dashboardGroupView addSubview:self.xc_playingView];
    
    
    // 采集
    self.xc_recordingView = ({
        UIButton *button = [UIButton new];
        button.clipsToBounds = YES;
        button;
    });
    [self.xc_recordingView setTitle:@"学员视频" forState:UIControlStateNormal];
    self.xc_recordingView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    [self.xc_dashboardGroupView addSubview:self.xc_recordingView];
    
    // 白板
    self.xc_slideshowAndWhiteboardView = ({
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
    self.xc_slideshowAndWhiteboardView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    [self.xc_dashboardGroupView addSubview:self.xc_slideshowAndWhiteboardView];
    
}

// 布局
- (void)mas_dashboard
{
    // 父view
    [self.xc_dashboardGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        //        make.top.equalTo(self.mas_topLayoutGuide).offset(64);
        make.top.equalTo(self.xc_topParentView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    // 布局 playingView (老师)
    [self.xc_playingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.xc_dashboardGroupView);
        make.width.equalTo(@(xc_videoWidth));
        make.height.equalTo(self.xc_playingView.mas_width).multipliedBy(3.0 / 4.0);
    }];
    
    
    // 布局recordingView (学生录屏)
    [self.xc_recordingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_playingView.mas_bottom);
        make.height.width.equalTo(self.xc_playingView);
        make.right.equalTo(self.xc_dashboardGroupView);
    }];
    
    // 布局白板
    [self.xc_slideshowAndWhiteboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.xc_dashboardGroupView);
        make.right.equalTo(self.xc_playingView.mas_left);
        //        make.width.equalTo(self.xc_slideshowAndWhiteboardView.mas_height).multipliedBy(4.0 / 3.0);
        make.bottom.equalTo(self.xc_dashboardGroupView).offset(-xc_bottomToolBarHeight);
    }];
    
    [self makeConsoleParentView];
    
    [self.view layoutIfNeeded];
    
}

// 配置底部ConsoleParentView(发送消息)
- (void)makeConsoleParentView
{
    self.xc_consoleParentView = ({
        UIView *xc_consoleParentView = [UIView new];
        xc_consoleParentView.backgroundColor = UICOLOR_FROM_RGB_ALPHA(0, 0, 0, 0.1);
        xc_consoleParentView;
    });
    [self.xc_dashboardGroupView addSubview:self.xc_consoleParentView];
    
    // 聊天板
    self.console = [UIViewController new];
//    [self addChildViewController:self.console superview:self.xc_dashboardGroupView];
    [self.view addSubview:self.console.view];
    
    // 聊天块的父view
    [self.xc_consoleParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_recordingView.mas_bottom);
        make.right.left.equalTo(self.xc_recordingView);
        make.bottom.equalTo(self.xc_dashboardGroupView);
    }];
    
    // 聊天输入框父view
    self.xc_chatBarParentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_RGB_ALPHA(0, 0, 0, 0.1);
        view.clipsToBounds = YES;
        view;
    });
    [self.xc_consoleParentView addSubview:self.xc_chatBarParentView];
    [self.xc_chatBarParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.xc_consoleParentView);
        make.height.equalTo(@(barHeight));
    }];
    
    // 聊天textField
    self.xc_chatTextField = ({
        UITextField *textField = [UITextField new];
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.cornerRadius = 2.0;
        textField.layer.masksToBounds = YES;
        textField.returnKeyType = UIReturnKeySend;
        textField.delegate = self;
        //        textField.placeholder = @"请输入消息..";
        textField;
    });
    [self.xc_chatBarParentView addSubview:self.xc_chatTextField];
    
    // 常用语按钮
    self.xc_chatCommonStrButton = ({
        UIButton *button = [UIButton new];
        [button setImage:UIIMAGE_FROM_NAME(@"changyongyu_wei") forState:UIControlStateNormal];
        [button setImage:UIIMAGE_FROM_NAME(@"chongyongyu_yi") forState:UIControlStateSelected];
        [button sizeToFit];
        button;
    });
    [self.xc_chatBarParentView addSubview:self.xc_chatCommonStrButton];
    
    [self.xc_chatCommonStrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_chatBarParentView).offset(-margin20);
        make.width.equalTo(@(self.xc_chatCommonStrButton.width));
        make.centerY.equalTo(self.xc_chatBarParentView.mas_centerY);
    }];
    
    [self.xc_chatTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_chatBarParentView.mas_left).offset(margin10);
        make.right.equalTo(self.xc_chatCommonStrButton.mas_left).offset(- margin10);
        make.top.bottom.equalTo(self.xc_chatBarParentView);
    }];
    
    
    // 布局 聊天板 （必须放在makeChatBar后面）
    [self.console.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_consoleParentView);
        make.left.width.equalTo(self.xc_recordingView);
        make.bottom.equalTo(self.xc_chatBarParentView.mas_top);
    }];
}

/// 底部xc_bottomParentView
- (void)init_mas_bottomToolBarParentView
{
    // 父view
    self.xc_bottomToolBarParentView = ({
        UIView *xc_bottomToolBarParentView = [UIView new];
        xc_bottomToolBarParentView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        xc_bottomToolBarParentView;
    });
    [self.xc_dashboardGroupView addSubview:self.xc_bottomToolBarParentView];
    
    [self.xc_bottomToolBarParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_slideshowAndWhiteboardView.mas_bottom);
        make.bottom.left.equalTo(self.xc_dashboardGroupView);
        make.right.equalTo(self.xc_slideshowAndWhiteboardView.mas_right);
    }];
    
    // 分割线
    UIView *xc_lineView = [UIView new];
    xc_lineView.backgroundColor = [UIColor whiteColor];
    [self.xc_bottomToolBarParentView addSubview:xc_lineView];
    [xc_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.xc_bottomToolBarParentView);
        make.width.equalTo(@(1));
        make.center.equalTo(self.xc_bottomToolBarParentView);
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
    [self.xc_bottomToolBarParentView addSubview:self.xc_cleanButton];
    
    [self.xc_cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xc_bottomToolBarParentView.mas_centerX).multipliedBy(1.0/2.0);
        make.centerY.equalTo(self.xc_bottomToolBarParentView);
    }];
    
    // 子xc_drawButton
    self.xc_drawButton = ({
        UIButton *xc_drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xc_drawButton setImage:UIIMAGE_FROM_NAME(@"huabi_wei") forState:UIControlStateNormal];
        [xc_drawButton setImage:UIIMAGE_FROM_NAME(@"huabi_wei_copy") forState:UIControlStateSelected];
        [xc_drawButton setFrame:CGRectMake(0, 0, self.xc_bottomToolBarParentView.width/2.0, self.xc_bottomToolBarParentView.height)];
        [xc_drawButton setBackgroundColor:UICOLOR_FROM_HEX(ColorF2F2F2)];
        [xc_drawButton sizeToFit];
        xc_drawButton;
    });
    [self.xc_bottomToolBarParentView addSubview:self.xc_drawButton];
    
    [self.xc_drawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xc_bottomToolBarParentView.mas_centerX).multipliedBy(3.0/2.0);
        make.centerY.equalTo(self.xc_bottomToolBarParentView);
    }];
}

- (void)startPrintAVDebugInfo {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
    
//    [self.console printFormat:@"---- av - %f ----", [NSDate timeIntervalSinceReferenceDate]];
//    for (NSString *info in [self.room.mediaVM avDebugInfo]) {
//        [self.console printLine:info];
//    }
    
    [self performSelector:_cmd withObject:nil afterDelay:1.0];
}

- (void)stopPrintAVDebugInfo {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startPrintAVDebugInfo) object:nil];
}

#pragma mark - events
// 顶部view中发送消息和返回的事件
- (void)makeEvents {
    
    
    @weakify(self);
    
    
    [[self.xc_playingView rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"点击了老师头像---%@", self.xc_playingView);
         
     }];
    
    // textField事件
    [[self.xc_chatTextField.rac_textSignal
      map:^id(NSString *text) {
          return @(!!text.length);
      }]
     subscribeNext:^(NSNumber *enabled) {
         @strongify(self);
         self.xc_chatTextField.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
         //         self.xc_commonButton.enabled = enabled.boolValue;
     }];
    
    // 返回按钮事件
    [[self.xc_backButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self goBack];
     }];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[self.xc_chatCommonStrButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"hello world");
         self.xc_chatCommonStrButton.selected = YES;
         [self.view endEditing:YES];
         [self showPopView];
     }];
}

- (void)showPopView
{
    //showPopView
    GGT_PopoverController *vc = [GGT_PopoverController new];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.popoverPresentationController.sourceView = self.xc_chatCommonStrButton;
    vc.popoverPresentationController.sourceRect = self.xc_chatCommonStrButton.bounds;
    vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    vc.popoverPresentationController.delegate = self;
    
    // 修改弹出视图的size 在控制器内部修改更好
    //    vc.preferredContentSize = CGSizeMake(100, 100);
    [self presentViewController:vc animated:YES completion:nil];
    
    @weakify(self)
    vc.dismissBlock = ^(NSString *selectString) {
        @strongify(self);
        NSLog(@"点击了---%@", selectString);
        self.xc_chatCommonStrButton.selected = NO;
        if ([selectString isKindOfClass:[NSString class]]) {
            if (selectString.length>0) {
//                [self.room.chatVM sendMessage:selectString];
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
    return NO;
}

//弹框消失时调用的方法
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    NSLog(@"弹框已经消失");
}


#pragma mark - 监听键盘高度
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    NSLog(@"%@", aNotification);
    NSString *timeValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[timeValue floatValue] animations:^{
        [self.xc_consoleParentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.xc_consoleParentView.height));
            make.right.left.equalTo(self.xc_recordingView);
            make.bottom.equalTo(self.xc_dashboardGroupView).offset(-height);
        }];
    }];
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSString *timeValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[timeValue floatValue] animations:^{
        [self.xc_consoleParentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.xc_recordingView.mas_bottom);
            make.right.left.equalTo(self.xc_recordingView);
            make.bottom.equalTo(self.xc_dashboardGroupView);
        }];
    }];
}


#pragma mark - 进入和退出房间的事件
// 返回
- (void)goBack {
    // 返回之前要先退出房间 且需要将房间置为nil
//    [self.room exit];
    [self dismissViewControllerAnimated:YES completion:^{
        self.room = nil;
    }];
}

// 发送消息
- (void)sendMessage {
    //    [self.view endEditing:YES];
    if (!self.xc_chatTextField.text.length) {
        return;
    }
    
#pragma mark - 暂时开启
    if ([self.xc_chatTextField.text isEqualToString:@"-av"]) {
        self.xc_chatTextField.text = nil;
        [self startPrintAVDebugInfo];
        return;
    }
//    if (!self.room.chatVM.forbidAll && !self.room.chatVM.forbidMe) {
//        [self.room.chatVM sendMessage:self.xc_chatTextField.text];
//    }
//    else {
//        [self.console printLine:@"禁言状态不能发送消息"];
//    }
    self.xc_chatTextField.text = nil;
    
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage];
    return NO;
}

- (void)dealloc {
    // 控制器销毁时，取消所有的延迟操作，不然可能会造成内厝泄漏
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSLog(@"销毁了--%@", self);
}

// 设置屏幕选装  需要在xcode中开启支持屏幕旋转
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

// self.view旋转后状态栏还在显示 不好看
- (BOOL)prefersStatusBarHidden
{
    if (_hidenStatus) {
        return YES;
    } else {
        return NO;
    }
}

// 禁用IQKeyboard
- (void)initKeyBoard
{
    IQKeyboardManager * manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}


@end

//
//  RoomController.m
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//

#import "RoomController.h"
#import "RoomManager.h"
#import "TKEduWhiteBoardHandle.h"
#import "TKEduClassRoomProperty.h"
#import "TKEduClassRoomSessionHandle.h"
#import <WebKit/WebKit.h>
#import "TKVideoSmallView.h"
#import "TKUtil.h"
#import "TKMacro.h"
//reconnection
#import "TKNONetWorkView.h"
#import "TKTimer.h"
#import "TKAFNetworkReachabilityManager.h"
#import "TKProgressHUD.h"
#import "TKRCGlobalConfig.h"
//chatView
#import "TKLiveViewChatTableViewCell.h"
#import "TKGrowingTextView.h"
#import "TKChatMessageModel.h"
//getGifNum
#import "TKEduClassRoomNetWorkManager.h"
#import "TKClassTimeView.h"


#pragma pad
#import "TKMessageTableViewCell.h"
#import "TKTeacherMessageTableViewCell.h"
#import "TKStudentMessageTableViewCell.h"
#import "TKDocumentListView.h"

#import "GGT_PopoverController.h"

@import AVFoundation;
//214 *142

#define VideoSmallViewMargins 6
#define VideoSmallViewHeigh (([UIScreen mainScreen].bounds.size.height -3*VideoSmallViewMargins-40)/ 4.0)
#define VideoSmallViewWidth VideoSmallViewHeigh * 4.0/3.0



#define VideoSmallViewBigWidth  (([UIScreen mainScreen].bounds.size.width -3*VideoSmallViewMargins)/ 2.0)
#define VideoSmallViewBigHeigh (VideoSmallViewBigWidth * 3.0/4.0)

#define VideoSmallViewLittleWidth  (([UIScreen mainScreen].bounds.size.width -6*VideoSmallViewMargins)/ 5.0)
#define VideoSmallViewLittleHeigh (VideoSmallViewLittleWidth * 3.0/4.0)



@interface TGInputToolBarView : UIView
@end
@implementation TGInputToolBarView
- (void)drawRect:(CGRect) rect
{
    [super drawRect:rect];
    
    [RGBCOLOR(76,76,76) set];
    
    CGRect frame = self.bounds;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext,1.0f);
    CGContextMoveToPoint(currentContext, frame.origin.x, frame.origin.y);
    CGContextAddLineToPoint(currentContext, frame.origin.x + frame.size.width, frame.origin.y);
    CGContextStrokePath(currentContext);
}

@end


static const CGFloat sChatBarHeight = 47;
static const CGFloat sChatTableViewWidth = 338;
static const CGFloat sChatTableViewHeigh = 87;
static const CGFloat sRaiseHandWidth = 50;
static const CGFloat sRaiseHandHeigh = 35;


#pragma mark nav
static const CGFloat sDocumentButtonWidth = 55;
//static const CGFloat sRightWidth          = 234;
static const CGFloat sRightWidth          = 286;

static const CGFloat sClassTimeViewHeigh  = 57.5;
static const CGFloat sViewCap             = 10;
static const CGFloat sBottomViewHeigh     = 132;
//static const CGFloat sTeacherVideoViewHeigh     = 182;
static const CGFloat sTeacherVideoViewHeigh     = 214;

static const CGFloat sStudentVideoViewHeigh     = 112;
static const CGFloat sStudentVideoViewWidth     = 120;
//static const CGFloat sRightViewChatBarHeight    = 50;
static const CGFloat sRightViewChatBarHeight    = 44;

static const CGFloat sSendButtonWidth           = 64;

static CGFloat const kBottomDrawHeight = 68;       // 画笔高度




static NSString *const sMessageCellIdentifier           = @"messageCellIdentifier";
static NSString *const sStudentCellIdentifier           = @"studentCellIdentifier";
static NSString *const sTeacherCellIdentifier           = @"teacherCellIdentifier";



//https://imtx.me/archives/1933.html 黑色背景
@interface RoomController() <TKEduWhiteBoardDelegate,TKEduClassRoomSessionDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TKGrowingTextViewDelegate,CAAnimationDelegate,UIPopoverPresentationControllerDelegate,VideolistProtocol>



//其他
@property(nonatomic,retain)UIScrollView *iScroll;
@property (nonatomic, assign) BOOL isClassBegin;//yes 开始 no 结束
@property (nonatomic, assign) BOOL isMuteAudio;//yes 静音 no 非静音
@property (nonatomic, assign) BOOL iIsRaiseHandUp;//举手
@property (nonatomic, assign) NSDictionary* iParamDic;//加入会议paraDic
@property (nonatomic, assign) UserType iUserType;//当前身份
@property (nonatomic, assign) RoomType iRoomType;//当前会议室
//导航
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *iClassTimeButton;
@property (nonatomic, strong) UIButton *iDocumentButton;
@property (nonatomic, strong) UIButton *iMediaButton;
@property (nonatomic, strong) UIButton *iUserButton;
@property (nonatomic, strong) UIButton *iOutButton;
@property (nonatomic, strong) TKClassTimeView *iClassTimeView;

@property (nonatomic, assign) NSTimeInterval iLocalTime;
@property (nonatomic, assign) NSTimeInterval iClassStartTime;
@property (nonatomic, assign) NSTimeInterval iServiceTime;
@property(nonatomic,copy)     NSString * iRoomName;
@property (nonatomic, strong) NSTimer *iNavHideControltimer;
@property (nonatomic, strong) NSTimer *iClassTimetimer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

#pragma mark pad
@property(nonatomic,retain)UIView   *iRightView;
@property(nonatomic,retain)UIView   *iBottomView;
@property(nonatomic,retain)UIButton *iClassBeginAndRaiseHandButton;
@property(nonatomic,retain)UIView   *iMuteAudioAndRewardView;
@property(nonatomic,retain)UIButton *iMuteAudioButton;
@property(nonatomic,retain)UIButton *iRewardButton;
@property(nonatomic,retain)TKDocumentListView *iDocumentListView;
@property(nonatomic,retain)TKDocumentListView *iUsertListView;
@property(nonatomic,retain)TKDocumentListView *iMediaListView;
//白板
@property (nonatomic, strong) TKEduWhiteBoardHandle *iTKEduWhiteBoardHandle;
//@property (nonatomic, strong) UIView *iTKEduWhiteBoardView;
@property (nonatomic, assign) BOOL iCandraw;//yes 能画 no 不能


//视频
@property (nonatomic, strong) TKEduClassRoomProperty *iTKEduClassRoomProperty;
@property (nonatomic, strong) TKEduClassRoomSessionHandle *iTKEduClassRoomSessionHandle;
@property (nonatomic, weak)  id<TKEduEnterClassRoomDelegate> iTKEduEnterClassRoomDelegate;
@property (nonatomic, strong) TKVideoSmallView *iTeacherVideoViewRight;
@property (nonatomic, strong) TKVideoSmallView *iOurVideoViewRight;

@property (nonatomic, strong) TKVideoSmallView *iTeacherVideoView;
@property (nonatomic, strong) TKVideoSmallView *iOurVideoView;
@property (nonatomic, strong) TKVideoSmallView *iOurVideoBottomView;
@property (nonatomic, strong) TKVideoSmallView *iStudent1VideoView;
@property (nonatomic, strong) TKVideoSmallView *iStudent2VideoView;
@property (nonatomic, strong) TKVideoSmallView *iStudent3VideoView;
@property (nonatomic, strong) TKVideoSmallView *iStudent4VideoView;
@property (nonatomic, strong) TKVideoSmallView *iStudent5VideoView;
@property (nonatomic, strong) NSMutableArray  *iStudentAndTeacherVideoViewArray;
@property (nonatomic, strong) NSMutableArray  *iMeAndTeacherVideoViewArray;
@property (nonatomic, strong) NSMutableDictionary  *iVideoViewMutableDic;
@property (nonatomic, strong) TKTimer          *iCheckPlayVideotimer;
//@property (nonatomic, strong) NSDictionary   *iUserPlayVideoDicPre;
//@property (nonatomic, strong) NSDictionary   *iUserPlayVideoDic;
@property (nonatomic, strong) NSArray   *iUserPlayVideoArrayPre;
@property (nonatomic, strong) NSArray   *iUserPlayVideoArrayDic;
@property (nonatomic, assign) CGFloat iPreScrollConoffset;//yes 能画 no 不能

//断线重连
@property (nonatomic, strong) TKNONetWorkView *iNoNetView;
@property (nonatomic, strong) TKAFNetworkReachabilityManager *iAFNetworkReachablitityManager;
@property (nonatomic, assign) BOOL iNetStatus;//yes 有网 no 无网
@property (nonatomic, assign) BOOL iNetConnectionStatus;//yes 重连状态 no 非重连状态
@property (nonatomic, assign) BOOL iIsTellClassBegin;//yes 有网 no 无网
@property (nonatomic, strong) TKTimer *iReconnectTimeOutTimer;//重连超时
@property (nonatomic, strong) NSTimer *connectTimer;
@property (nonatomic, strong) TKProgressHUD *connectHUD;
@property (nonatomic, assign) NSInteger iReconnectCount;

//聊天
@property (nonatomic, strong) UITableView *iChatTableView; // 聊天tableView
@property (nonatomic, strong) TGInputToolBarView *inputContainer;
@property (nonatomic, strong) TGInputToolBarView *inputInerContainer;
@property (nonatomic, strong) TKGrowingTextView *inputField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *iRaiseHandButton;
@property (nonatomic, assign) CGFloat  iIsRaiseWidth;
@property (nonatomic, assign) CGFloat  iIsNORaiseWidth;


@property (nonatomic, strong) UILabel *replyText;
@property (nonatomic,assign) CGRect inputContainerFrame;
@property (nonatomic,assign) CGFloat knownKeyboardHeight;
@property (nonatomic,strong ) NSArray  *iMessageList;

//toolbar
@property (nonatomic, strong) UIButton *iSendGiftButton;
@property (nonatomic, strong) UIButton *iShowNavButton;
@property (nonatomic, strong) UIButton *iUserListButton;

//gift
@property (nonatomic, strong) UIImageView *iGiftAnimationView;
@property (nonatomic, assign) NSInteger iGiftCount;

// 底部画笔
@property (nonatomic) UIView *xc_bottomToolBarParentView;
@property (nonatomic) UIButton *xc_cleanButton;
@property (nonatomic) UIButton *xc_drawButton;


@end

@implementation RoomController
- (instancetype)initWithDelegate:(id<TKEduEnterClassRoomDelegate>)aTKEduEnterClassRoomdelegate aParamDic:(NSDictionary *)aParamDic aRoomName:(NSString *)aRoomName aClassRoomProperty:(TKEduClassRoomProperty *)aClassRoomProperty{
    if (self = [self init]) {
        
        _iTKEduClassRoomProperty      = aClassRoomProperty;
        _iRoomName                    = aRoomName;
        _iTKEduWhiteBoardHandle       = [[TKEduWhiteBoardHandle alloc]init];
        _iTKEduEnterClassRoomDelegate = aTKEduEnterClassRoomdelegate;
        _iTKEduClassRoomSessionHandle = [[TKEduClassRoomSessionHandle alloc]initWithMeetingWithParamDic:aParamDic aTKEduEnterClassRoomDelegate:aTKEduEnterClassRoomdelegate aTKEduClassRoomSessionDelegate:self aRoomWhiteBoardDelegate:_iTKEduWhiteBoardHandle];
        
        
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self invalidateTimer];
#pragma mark - 设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Do any additional setup after loading the view, typically from a nib.
    CGRect tFrame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    _iNetConnectionStatus = NO;
    _iCandraw = NO;
    _iIsRaiseHandUp = NO;
    _iUserType = _iTKEduClassRoomProperty.iUserType;
    _iRoomType = _iTKEduClassRoomProperty.iRoomType;
    
    
    _iPreScrollConoffset = 0;
    _iScroll = ({
    
        UIScrollView *tScrollView = [[UIScrollView alloc]initWithFrame:tFrame];
    
        tScrollView.userInteractionEnabled = YES;
        tScrollView.delegate = self;
        tScrollView.contentSize = CGSizeMake(CGRectGetWidth(tFrame), CGRectGetHeight(tFrame));
        tScrollView.backgroundColor =  RGBCOLOR(62,62,62);
        
        tScrollView.backgroundColor = [UIColor whiteColor];
        
        tScrollView;
    
    
    });
    
    [self.view addSubview:_iScroll];
//    [self initVideoView];
//    [self initAutoReconection];
//    [self initToolBar];
//    [self initChatView];
    [self initNavigation:tFrame];
    [self initRightView];
    [self initBottomView];
    [self initWhiteBoardView];
    
    [self initTapGesTureRecognizer];
    [self initAutoReconection];
    [self createTimer];
    [_iScroll bringSubviewToFront:_iClassTimeView];
    [_iScroll bringSubviewToFront:_iTKEduWhiteBoardView];
    
#pragma mark - 添加画笔功能
    _iOurVideoView.iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(_iOurVideoView.frame), CGRectGetMinY(_iOurVideoView.frame)+70, 295, 70) withType:1 aVideoRole:EVideoRoleOur];
    _iOurVideoView.iFunctionView.iDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_iOurVideoView.iFunctionView];
    _iOurVideoView.iFunctionView.hidden = YES;
    
    
    @weakify(self);
    [[_xc_drawButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        _xc_drawButton.selected = !_xc_drawButton.selected;
        @strongify(self);
        NSLog(@"hello world");
        
        
        if (_iOurVideoView.iFunctionView.iDelegate && [_iOurVideoView.iFunctionView.iDelegate respondsToSelector:@selector(videoSmallbutton1:aVideoRole:)]) {
            [(id<VideolistProtocol>)_iOurVideoView.iFunctionView.iDelegate videoSmallbutton1:_xc_drawButton aVideoRole:EVideoRoleOur];
        }
        
    }];
   
}

-(void)videoSmallbutton1:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    
    if (!_iOurVideoView.iPeerId || ![_iOurVideoView.iPeerId isEqualToString:@""]) {
        _iOurVideoView.iCurrentPeerId = _iOurVideoView.iPeerId;
    }
    if (aVideoRole == EVideoRoleTeacher) {
        TKLog(@"关闭视频");
        
        if (!aButton.selected) {
            [_iOurVideoView.iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iOurVideoView.iCurrentPeerId Publish:PublishState_NONE completion:nil];
        }else{
            [_iOurVideoView.iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iOurVideoView.iCurrentPeerId Publish:PublishState_BOTH completion:nil];
        }
        
        //        [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iPeerId TellWhom:sTellAll Key:sPublishstate Value:@(aButton.selected) completion:nil];
        
    }else{
        TKLog(@"授权涂鸦");
        _iOurVideoView.iDrawImageView.hidden = !aButton.selected;
        [_iOurVideoView.iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iOurVideoView.iCurrentPeerId TellWhom:sTellAll Key:sCandraw Value:@(aButton.selected) completion:nil];
        
    }
    //_iEduClassRoomSessionHandle
    
}


-(void)initAutoReconection{
    _iAFNetworkReachablitityManager = [TKAFNetworkReachabilityManager sharedManager];

    __weak typeof(self)weekSelf = self;
    // 2.设置网络状态改变后的处理
    [_iAFNetworkReachablitityManager setReachabilityStatusChangeBlock:^(TKAFNetworkReachabilityStatus status) {
        __strong typeof(self)strongSelf = weekSelf;
        
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case TKAFNetworkReachabilityStatusUnknown: // 未知网络
            case TKAFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                TKLog(@"没有网络(断网)");
                [strongSelf leftRoomAbnormal];
               
                
                break;
            }
                
            case TKAFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            case TKAFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                
                //[strongSelf joinRoomReconnected];
                TKLog(@"手机自带网络或者Wifi");
                break;
            }
                
        }
    }];
    [_iAFNetworkReachablitityManager startMonitoring];
}
-(void)joinRoomReconnected{
    
    //如果是无网状态，则进行重连
    if (!self.iNetStatus) {
        
        if (self.connectTimer) {
            [self.connectTimer invalidate];
            self.connectTimer = nil;
        }
        
        self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                   target:self
                                                                 selector:@selector(joinRoomReconnectedRealy)
                                                                 userInfo:nil
                                                                  repeats:YES];
        [self.connectTimer fire];
    }
}
-(void)joinRoomReconnectedRealy{
    //如果不是正在退出，则重连。
    if (!self.iTKEduClassRoomSessionHandle) {
        
        [self reconnectMeeting];
        
    }
   
}

-(void)leftRoomAbnormal{
    if (self.iTKEduClassRoomSessionHandle) {
        TKLog(@"没有网络-------------------调用离开教室，设置断网超时");
        [self showConnectHUD];
        [self.iTKEduClassRoomSessionHandle sessionHandleLeaveRoom:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//           
//        });
        
    }
    //断网超过60 退出会议
    _iReconnectTimeOutTimer = [[TKTimer alloc]initWithTimeout:60 repeat:NO completion:^{
        if (_connectHUD) {
            [_connectHUD hide:YES];
            _connectHUD = nil;
        }
        [self prepareForLeave:NO];
        
        
    } queue:dispatch_get_main_queue()];
    [self.iReconnectTimeOutTimer start];
}
#pragma mark Pad 初始化
-(void)initNavigation:(CGRect)aFrame{
    self.navigationController.navigationBar.hidden = YES;
    //导航栏
    _titleView = ({
        
        UIView *tTitleView = [[UIView alloc] initWithFrame: CGRectMake(0, 20, CGRectGetWidth(aFrame), sDocumentButtonWidth*Proportion)];
        tTitleView.backgroundColor =  RGBCOLOR(41, 41, 41) ;
        tTitleView.backgroundColor = [UIColor whiteColor];
        tTitleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tTitleView;
    });
    
  
    
    _leftButton =({
        
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tLeftButton.frame = CGRectMake(0, 0, sDocumentButtonWidth*Proportion, sDocumentButtonWidth*Proportion);
//        tLeftButton.center = CGPointMake(25+8, _titleView.center.y);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [tLeftButton setImage: UIIMAGE_FROM_NAME(@"fanhui_red") forState:UIControlStateNormal];
        [tLeftButton setImage: UIIMAGE_FROM_NAME(@"fanhui_red") forState:UIControlStateHighlighted];
        [tLeftButton addTarget:self action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchUpInside];
        tLeftButton;
        
        
    });
    
    [_titleView addSubview:_leftButton];
    
    
    _titleLable = ({
        
        //        UILabel *tTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, self.view.frame.size.width-65-sDocumentButtonWidth*4- 8* 4, sDocumentButtonWidth*Proportion)];
        
        UILabel *tTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, self.view.frame.size.width-65*2, sDocumentButtonWidth*Proportion)];
        tTitleLabel.text = _iTKEduClassRoomProperty.iRoomName ;
        tTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tTitleLabel.backgroundColor = [UIColor clearColor];
        tTitleLabel.textAlignment = NSTextAlignmentCenter;
        tTitleLabel.font = Font(18);
        tTitleLabel.textColor = RGBCOLOR(255, 255, 255);
        tTitleLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
        
        TKEduClassRoom *shareRoom = [TKEduClassRoom shareTKEduClassRoomInstance];
        tTitleLabel.text = shareRoom.xc_roomName;
        
        tTitleLabel;
        
    });
    [_titleView addSubview:_titleLable];
    
    
//   _iOutButton = ({
//    
//        UIButton *tOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        tOutButton.frame = CGRectMake(ScreenW-sDocumentButtonWidth*Proportion-8, 0, sDocumentButtonWidth*Proportion, sDocumentButtonWidth*Proportion);
//       
//        tOutButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//       [tOutButton addTarget:self action:@selector(outButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//       
//        [tOutButton setImage: LOADIMAGE(@"btn_out_normal") forState:UIControlStateNormal];
//        [tOutButton setImage: LOADIMAGE(@"btn_out_pressed") forState:UIControlStateSelected];
//        tOutButton;
//    
//    });
//    _iOutButton.hidden = !_isClassBegin;
   
    _iUserButton = ({
        
        UIButton *tUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tUserButton.frame = CGRectMake(ScreenW-sDocumentButtonWidth*Proportion-8, 0, sDocumentButtonWidth*Proportion, sDocumentButtonWidth*Proportion);
        
        tUserButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tUserButton addTarget:self action:@selector(userButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tUserButton setImage: LOADIMAGE(@"btn_user_normal") forState:UIControlStateNormal];
        [tUserButton setImage: LOADIMAGE(@"btn_user_pressed") forState:UIControlStateSelected];
        tUserButton;
        
    });
   
    
    _iMediaButton = ({
        
        UIButton *tMediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tMediaButton.frame = CGRectMake(ScreenW-sDocumentButtonWidth*Proportion*((2))-8*(2), 0, sDocumentButtonWidth, sDocumentButtonWidth);
        
        tMediaButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tMediaButton addTarget:self action:@selector(mediaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tMediaButton setImage: LOADIMAGE(@"btn_media_normal") forState:UIControlStateNormal];
        [tMediaButton setImage: LOADIMAGE(@"btn_media_pressed") forState:UIControlStateSelected];
        tMediaButton;
        
    });
   
    _iDocumentButton = ({
        
        UIButton *tDocumentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tDocumentButton.frame = CGRectMake(ScreenW-sDocumentButtonWidth*Proportion*(3)-8*((3)), 0, sDocumentButtonWidth, sDocumentButtonWidth);
        
        tDocumentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tDocumentButton addTarget:self action:@selector(documentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tDocumentButton setImage: LOADIMAGE(@"btn_document_normal") forState:UIControlStateNormal];
        [tDocumentButton setImage: LOADIMAGE(@"btn_document_pressed") forState:UIControlStateSelected];
        tDocumentButton;
        
    });

    [_titleView addSubview:_iDocumentButton];
    [_titleView addSubview:_iMediaButton];
    [_titleView addSubview:_iUserButton];
    [_titleView addSubview:_iOutButton];
    [_iScroll addSubview:_titleView];
    
    _iClassTimeView = ({
    
        TKClassTimeView *tClassTimeView = [[TKClassTimeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), ScreenW-sRightWidth*Proportion,sClassTimeViewHeigh*Proportion)];
        tClassTimeView.backgroundColor = [UIColor clearColor];
        //tClassTimeView.backgroundColor = [UIColor yellowColor];
        [tClassTimeView setClassTime:0];
        tClassTimeView;
    
    });
    
    [_iScroll addSubview:_iClassTimeView];
    
    
#pragma mark - 隐藏顶部导航栏上面的button
    _iMediaButton.hidden = YES;
    _iUserButton.hidden = YES;
    _iDocumentButton.hidden = YES;
    
}

-(void)classBeginAndRaiseHandButtonClicked:(UIButton *)aButton{
    UserType tMyRole = _iTKEduClassRoomSessionHandle.localUser.role;
    aButton.selected = !aButton.selected;
    if (tMyRole == UserType_Teacher) {
        
        if (aButton.selected) {
            
            if (!_isClassBegin){
                TKLog(@"开始上课");
                [_iTKEduClassRoomSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{@"type":@"pad"} Save:NO completion:nil];
            }
            
        }else{
             TKLog(@"下课");
            if (_isClassBegin) {
                [_iTKEduClassRoomSessionHandle sessionHandleDelMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{@"type":@"pad"} completion:nil];
                TKLog(@"下课");
            }
        }
            
      
       
    }else{
         TKLog(@"举手");
         //[_iTKEduClassRoomSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{@"type":@"pad"} Save:NO completion:nil];
        
        [_iTKEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iTKEduClassRoomSessionHandle.localUser.peerID TellWhom:sTellAllExpectSender Key:sRaisehand Value:@(true) completion:nil];
    }
   
    
}
-(void)muteAduoButtonClicked:(UIButton *)aButton{
    TKLog(@"全体静音");
    if (!_isMuteAudio) {
          [_iTKEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iTKEduClassRoomSessionHandle.localUser.peerID TellWhom:sTellAllExpectSender Key:sMuteAudio Value:@(true) completion:nil];
    }
    
   
}
-(void)rewardButtonClicked:(UIButton *)aButton{
    TKLog(@"全员奖励");
}
-(void)refreshUI{
    
    //RoomType tRoomType = _iTKEduClassRoomSessionHandle.roomType;
    //right
    CGFloat tViewCap = sViewCap*Proportion;
    //老师
    CGFloat tViewWidth = (sRightWidth-2*sViewCap)*Proportion;
    {
        
//        _iTeacherVideoView.frame = CGRectMake(tViewCap, tViewCap, tViewWidth, sTeacherVideoViewHeigh*Proportion);
        _iTeacherVideoView.frame = CGRectMake(0, 0, sRightWidth, sTeacherVideoViewHeigh*Proportion);
    }
    //我
    {
        
        CGFloat tOurVideoViewHeight = (_iRoomType == RoomType_OneToOne)?sTeacherVideoViewHeigh*Proportion:0;
//        _iOurVideoView.frame = CGRectMake(tViewCap,CGRectGetMaxY(_iTeacherVideoView.frame)+tViewCap, tViewWidth, tOurVideoViewHeight);
        
        _iOurVideoView.frame = CGRectMake(0,CGRectGetMaxY(_iTeacherVideoView.frame), sRightWidth, tOurVideoViewHeight);
         _iOurVideoView.hidden = !tOurVideoViewHeight;
       
        
    }
    
    //静音与奖励
    {
        //非老师
        BOOL tIsHide = (_iUserType != UserType_Teacher) || (!_isClassBegin);
        CGFloat tMuteAudioAndRewardViewHeight = !tIsHide?(40*Proportion):0;
        _iMuteAudioAndRewardView.hidden = tIsHide;
        _iMuteAudioAndRewardView.frame = CGRectMake(tViewCap, CGRectGetMaxY(_iOurVideoView.frame), tViewWidth, tMuteAudioAndRewardViewHeight);
       
        
        _iMuteAudioButton.frame = CGRectMake(tViewCap, 0, (tViewWidth-3*tViewCap)/2, tMuteAudioAndRewardViewHeight);
        _iMuteAudioButton.hidden = tIsHide;
        _iRewardButton.frame = CGRectMake(CGRectGetWidth(_iMuteAudioButton.frame)+tViewCap*2, 0, (tViewWidth-tViewCap*3)/2, tMuteAudioAndRewardViewHeight);
     
        _iMuteAudioButton.hidden = tIsHide;
      

    }
    //举手按钮
    {
     
        CGFloat tMuteAudioAndRewardViewHeight = (40*Proportion);
       
        _iClassBeginAndRaiseHandButton.frame = CGRectMake(tViewCap, CGRectGetMaxY(_iMuteAudioAndRewardView.frame)+tViewCap, tViewWidth, tMuteAudioAndRewardViewHeight);
        
    }
    //聊天
    {
        CGFloat tChatHeight       = sRightViewChatBarHeight*Proportion;
//        CGFloat tChatTableHeight  = CGRectGetHeight(_iRightView.frame)-CGRectGetMaxY(_iClassBeginAndRaiseHandButton.frame)-tChatHeight-tViewCap;
//        _iChatTableView.frame = CGRectMake(0, CGRectGetMaxY(_iClassBeginAndRaiseHandButton.frame)+tViewCap, CGRectGetWidth(_iRightView.frame), tChatTableHeight);
        
        CGFloat tChatTableHeight  = CGRectGetHeight(_iRightView.frame)-CGRectGetMaxY(_iOurVideoView.frame)-tChatHeight;
        _iChatTableView.frame = CGRectMake(0, CGRectGetMaxY(_iOurVideoView.frame), CGRectGetWidth(_iRightView.frame), tChatTableHeight);
        
        _inputContainerFrame      = CGRectMake(0, CGRectGetMaxY(_iChatTableView.frame), sRightWidth*Proportion, tChatHeight);
        _inputContainer.frame     = _inputContainerFrame;
        _inputInerContainer.frame =  CGRectMake(0, 0, CGRectGetWidth(_inputContainer.frame), CGRectGetHeight(_inputContainer.frame));
        
        {
            CGFloat tInPutInerContainerWidth = CGRectGetWidth(_inputInerContainer.frame);
            CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
//            CGRect rectInputFieldFrame = CGRectMake(0, 0, tInPutInerContainerWidth-sSendButtonWidth, tInPutInerContainerHeigh);
            
            CGRect rectInputFieldFrame = CGRectMake(8, 8, tInPutInerContainerWidth-sSendButtonWidth-8*2, tInPutInerContainerHeigh-8*2);

            _inputField.frame = rectInputFieldFrame;
        
        }
        {
            CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
//            CGRect tReplyTextFrame = CGRectMake(0, 0, 100, tInPutInerContainerHeigh);
            
            CGRect tReplyTextFrame = CGRectMake(8, 8, 100, tInPutInerContainerHeigh-8*2);

            _replyText.frame = tReplyTextFrame;
        
        }
        {
            
            CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
            CGFloat tSendButtonX = (sRightWidth-sSendButtonWidth-4)*Proportion;
            _sendButton.frame = CGRectMake(tSendButtonX, 4, sSendButtonWidth*Proportion, tInPutInerContainerHeigh-4*2);
            
        }

    }
    //导航栏
    {
        if (_iUserType == UserType_Teacher) {
//            _iOutButton.hidden = !_isClassBegin;
            _iUserButton.frame =  CGRectMake(ScreenW-sDocumentButtonWidth*Proportion*(1)-8*(1), 0, sDocumentButtonWidth, sDocumentButtonWidth);
            _iMediaButton.frame =  CGRectMake(ScreenW-sDocumentButtonWidth*Proportion*((2))-8*(2), 0, sDocumentButtonWidth, sDocumentButtonWidth);
            _iDocumentButton.frame = CGRectMake(ScreenW-sDocumentButtonWidth*Proportion*(3)-8*((3)), 0, sDocumentButtonWidth, sDocumentButtonWidth);
        }
       
    
    
    }
}

-(void)initRightView{

    {
        CGFloat tRightY = CGRectGetMaxY(_titleView.frame);
        CGRect tRithtFrame = CGRectMake(ScreenW-sRightWidth*Proportion, tRightY, sRightWidth*Proportion, ScreenH-tRightY);

#pragma mark -  右侧老师、学生、聊天界面的父view
        _iRightView = ({
            
            UIView *tRightView = [[UIView alloc] initWithFrame: tRithtFrame];
//            tRightView.backgroundColor =  RGBCOLOR(62, 62, 62) ;
            tRightView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
            tRightView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            tRightView;
        });
        [_iScroll addSubview:_iRightView];
    
    }
    CGFloat tViewCap = sViewCap*Proportion;
    //老师
    CGFloat tViewWidth = (sRightWidth-2*sViewCap)*Proportion;
    {
    
        _iTeacherVideoView= ({
            
//            TKVideoSmallView *tTeacherVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tViewCap, tViewCap, tViewWidth, sTeacherVideoViewHeigh*Proportion) iRootView:nil aVideoRole:EVideoRoleTeacher];
            
            TKVideoSmallView *tTeacherVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(0, 0, _iRightView.width, sTeacherVideoViewHeigh*Proportion) iRootView:nil aVideoRole:EVideoRoleTeacher];
            tTeacherVideoView.iPeerId = @"";
            tTeacherVideoView.iVideoViewTag = VideoViewTag_TeacherVideoView;
            tTeacherVideoView.iEduClassRoomSessionHandle = _iTKEduClassRoomSessionHandle;
            tTeacherVideoView;
            
        });
          [_iRightView addSubview:_iTeacherVideoView];
    
    }
    //我
    {
    
        CGFloat tOurVideoViewHeight = (_iRoomType == RoomType_OneToOne)?sTeacherVideoViewHeigh*Proportion:0;
        _iOurVideoView= ({
            
//            TKVideoSmallView *tOurVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tViewCap,CGRectGetMaxY(_iTeacherVideoView.frame)+tViewCap, tViewWidth, tOurVideoViewHeight) iRootView:nil aVideoRole:EVideoRoleOur];
            
            TKVideoSmallView *tOurVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_iTeacherVideoView.frame), _iRightView.width, tOurVideoViewHeight) iRootView:nil aVideoRole:EVideoRoleOur];
            tOurVideoView.iPeerId = @"";
             tOurVideoView.iEduClassRoomSessionHandle = _iTKEduClassRoomSessionHandle;
            tOurVideoView.iVideoViewTag = VideoViewTag_OurVideoView;
           
            tOurVideoView;
            
        });
        [_iRightView addSubview:_iOurVideoView];
        _iOurVideoView.hidden = !tOurVideoViewHeight;
        
        
    }
   
    //静音与奖励
    {
        //不是老师，或没上课，隐藏 有1为1
        BOOL tIsHide = (_iUserType != UserType_Teacher) || (!_isClassBegin);
        CGFloat tMuteAudioAndRewardViewHeight = !tIsHide?(40*Proportion):0;
       // CGFloat tMuteAudioAndRewardViewHeight = (40*Proportion);
        _iMuteAudioAndRewardView = ({
            
            UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(tViewCap, CGRectGetMaxY(_iOurVideoView.frame), tViewWidth, tMuteAudioAndRewardViewHeight)];
            //tView.backgroundColor = [UIColor yellowColor];
            tView;
            
            
        });
        _iMuteAudioAndRewardView.hidden = tIsHide;
       
        _iMuteAudioButton = ({
            UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(tViewCap, 0, (tViewWidth-3*tViewCap)/2, (40*Proportion))];
            [tButton addTarget:self action:@selector(muteAduoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tButton setTitle:MTLocalized(@"Button.MuteAudio") forState:UIControlStateNormal];
            tButton.backgroundColor = RGBCOLOR(207,65, 21);
            [TKUtil setCornerForView:tButton];
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton;
        
        });
        
        [_iMuteAudioAndRewardView addSubview:_iMuteAudioButton];
        
        _iRewardButton = ({
            UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_iMuteAudioButton.frame)+tViewCap*2, 0, (tViewWidth-tViewCap*3)/2, (40*Proportion))];
             [tButton addTarget:self action:@selector(rewardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tButton setTitle:MTLocalized(@"Button.Reward") forState:UIControlStateNormal];
            tButton.backgroundColor = RGBCOLOR(81,104, 204);
            [TKUtil setCornerForView:tButton];
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton;
            
        });
        [_iMuteAudioAndRewardView addSubview:_iRewardButton];
        [_iRightView addSubview:_iMuteAudioAndRewardView];
    }
    //举手按钮
    {
        //老师且是上课状态 则隐藏。否则显示
      
        CGFloat tMuteAudioAndRewardViewHeight = (40*Proportion);
        
        
        _iClassBeginAndRaiseHandButton = ({
            
            UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(tViewCap, CGRectGetMaxY(_iMuteAudioAndRewardView.frame)+tViewCap, tViewWidth, tMuteAudioAndRewardViewHeight)];
            if (_iUserType == UserType_Student) {
                 [tButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
               
                
            }else{
                [tButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateSelected];
                
            }
            [tButton addTarget:self action:@selector(classBeginAndRaiseHandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            [tButton setBackgroundColor:RGBCOLOR(207, 65, 21)];
            tButton;
            
        
        });
        
        [_iRightView addSubview:_iClassBeginAndRaiseHandButton];
        
#pragma mark - 隐藏举手按钮
        _iClassBeginAndRaiseHandButton.hidden = YES;
    
    }
    //聊天
    {
         CGFloat tChatHeight       = sRightViewChatBarHeight*Proportion;
//         CGFloat tChatTableHeight  = CGRectGetHeight(_iRightView.frame)-CGRectGetMaxY(_iClassBeginAndRaiseHandButton.frame)-tChatHeight-tViewCap;
        
        CGFloat tChatTableHeight  = CGRectGetHeight(_iRightView.frame)-CGRectGetMaxY(_iOurVideoView.frame)-tChatHeight;
        
//        _iChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iClassBeginAndRaiseHandButton.frame)+tViewCap, CGRectGetWidth(_iRightView.frame), tChatTableHeight) style:UITableViewStylePlain];
        
        
        _iChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iOurVideoView.frame), CGRectGetWidth(_iRightView.frame), tChatTableHeight) style:UITableViewStylePlain];

        _iChatTableView.backgroundColor = [UIColor clearColor];

        _iChatTableView.separatorColor  = [UIColor clearColor];
        _iChatTableView.showsHorizontalScrollIndicator = NO;
        _iChatTableView.delegate   = self;
        _iChatTableView.dataSource = self;
        _iChatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
       
        [_iChatTableView registerClass:[TKMessageTableViewCell class] forCellReuseIdentifier:sMessageCellIdentifier];
        [_iChatTableView registerClass:[TKStudentMessageTableViewCell class] forCellReuseIdentifier:sStudentCellIdentifier];
        [_iChatTableView registerClass:[TKTeacherMessageTableViewCell class] forCellReuseIdentifier:sTeacherCellIdentifier];
        [_iRightView addSubview:_iChatTableView];
        
       
        _inputContainerFrame = CGRectMake(0, CGRectGetMaxY(_iChatTableView.frame), sRightWidth*Proportion, tChatHeight);
        _inputContainer  = ({
            
            TGInputToolBarView *tTollBarView =  [[TGInputToolBarView alloc] initWithFrame:_inputContainerFrame];
            tTollBarView.backgroundColor = UICOLOR_FROM_HEX(ColorC8C8CE);
            //tTollBarView.layer.backgroundColor = RGBCOLOR(247,247,247).CGColor;
            tTollBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
            tTollBarView;
            
        });
        
        [_iRightView addSubview:_inputContainer];

        
        
        _inputInerContainer = ({
            
            
            CGRect tInPutInerContainerRect = CGRectMake(0, 0, CGRectGetWidth(_inputContainer.frame), CGRectGetHeight(_inputContainer.frame));
            
            TGInputToolBarView *tInputInerContainer  = [[TGInputToolBarView alloc] initWithFrame:tInPutInerContainerRect];
            tInputInerContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            tInputInerContainer.backgroundColor = UICOLOR_FROM_HEX(ColorC8C8CE);
            tInputInerContainer;
            
            
        });
        [_inputContainer addSubview:_inputInerContainer];
        //[TKUtil setWidth:_inputInerContainer To:CGRectGetWidth(_inputInerContainer.frame)+CGRectGetWidth(_iRaiseHandButton.frame)];
        

        
        
        
        _inputField =({
            
            CGFloat tInPutInerContainerWidth = CGRectGetWidth(_inputInerContainer.frame);
            CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
//            CGRect rectInputFieldFrame = CGRectMake(0, 0, tInPutInerContainerWidth-sSendButtonWidth, tInPutInerContainerHeigh);
            
            CGRect rectInputFieldFrame = CGRectMake(8, 8, tInPutInerContainerWidth-sSendButtonWidth-8*2, tInPutInerContainerHeigh-8*2);
            
            
            TKGrowingTextView *tInputField =  [[TKGrowingTextView alloc] initWithFrame:rectInputFieldFrame];
//            tInputField.internalTextView.backgroundColor = RGBCOLOR(62,62,62);
            tInputField.internalTextView.backgroundColor = [UIColor whiteColor];
            
            tInputField.layer.masksToBounds = YES;
            tInputField.layer.cornerRadius = 4;

            
            //tInputField.internalTextView.backgroundColor = [UIColor magentaColor];
            [tInputField.internalTextView setTextColor:RGBACOLOR(168, 168, 168, 1)];
            [tInputField.internalTextView setTintColor:RGBACOLOR(255, 255, 255, 1)];
            //    _inputField.layer.borderColor = RGBCOLOR(60,61,64).CGColor;
            //    _inputField.layer.borderWidth = 1;
            //tInputField.font = [UIFont systemFontOfSize:15];
            tInputField.delegate         = self;
            tInputField.maxNumberOfLines = 5;
            tInputField.internalTextView.returnKeyType = UIReturnKeySend;
            tInputField.internalTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            
            tInputField;
            
        });
        
        [_inputInerContainer addSubview:_inputField];
        
        
        _replyText                 = ({
            CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
//            CGRect tReplyTextFrame = CGRectMake(0, 0, 100, tInPutInerContainerHeigh);
            
            CGRect tReplyTextFrame = CGRectMake(8, 8, 100, tInPutInerContainerHeigh-8*2);

            UILabel *tReplyText                 = [[UILabel alloc] initWithFrame:tReplyTextFrame];
            //tReplyText.backgroundColor = [UIColor redColor];
            tReplyText.textColor       = RGBCOLOR(99, 99, 99);
            tReplyText.text            = MTLocalized(@"Say.say");//@"说点什么吧";
            tReplyText.textAlignment   = NSTextAlignmentLeft;
            tReplyText.numberOfLines   = 1;
            tReplyText.font            = [UIFont systemFontOfSize:15];
            tReplyText;
            
        });
        
        [_inputInerContainer addSubview:_replyText];
        
        _sendButton = ({
            
            CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
            CGFloat tSendButtonX = (sRightWidth-sSendButtonWidth-4)*Proportion;
            UIButton *tSendButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            tSendButton.frame = CGRectMake(tSendButtonX, 4*Proportion, sSendButtonWidth*Proportion, tInPutInerContainerHeigh-4*2*Proportion);
            
//            [tSendButton setTitle:MTLocalized(@"Button.send") forState:UIControlStateNormal];
            
            [tSendButton setImage:UIIMAGE_FROM_NAME(@"changyongyu_wei") forState:UIControlStateNormal];
            [tSendButton setImage:UIIMAGE_FROM_NAME(@"chongyongyu_yi") forState:UIControlStateSelected];
            
            
            tSendButton.titleLabel.font = TKFont(10);

#pragma mark - 注销  不然button会移动
//            tSendButton.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
            
            [tSendButton addTarget:self action:@selector(replyAction2:) forControlEvents:UIControlEventTouchUpInside];
//            tSendButton.backgroundColor       = RGBCOLOR(62,62,62);
            
//            tSendButton.layer.borderColor     = RGBCOLOR(89,89,89).CGColor;
//            tSendButton.layer.borderWidth     = 1;
//            tSendButton.layer.masksToBounds = YES;
//            tSendButton.layer.cornerRadius = 4;
            tSendButton;
        });
        [_inputInerContainer addSubview:_sendButton];
        
        _inputContainer.userInteractionEnabled     = YES;
        _inputInerContainer.userInteractionEnabled = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    }
    {
      
        _iDocumentListView = [[TKDocumentListView alloc]initWithFrame:CGRectMake(ScreenW, 0, 382, ScreenH) withWhiteBoardHandel:_iTKEduWhiteBoardHandle withClassRoomSessionHandle:_iTKEduClassRoomSessionHandle withClassRoomProperty:_iTKEduClassRoomProperty];
         _iMediaListView = [[TKDocumentListView alloc]initWithFrame:CGRectMake(ScreenW, 0, 382, ScreenH) withWhiteBoardHandel:_iTKEduWhiteBoardHandle withClassRoomSessionHandle:_iTKEduClassRoomSessionHandle withClassRoomProperty:_iTKEduClassRoomProperty];
        _iMediaListView.delegate = self;
         _iUsertListView = [[TKDocumentListView alloc]initWithFrame:CGRectMake(ScreenW, 0, 382, ScreenH) withWhiteBoardHandel:_iTKEduWhiteBoardHandle withClassRoomSessionHandle:_iTKEduClassRoomSessionHandle withClassRoomProperty:_iTKEduClassRoomProperty];
    
    }
    
    
}
-(void)initWhiteBoardView{
   
    CGRect tFrame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), CGRectGetWidth(_iClassTimeView.frame), (CGRectGetHeight(_iRightView.frame)-sBottomViewHeigh)*Proportion);
    if (_iRoomType == RoomType_OneToOne) {
//        tFrame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), CGRectGetWidth(_iClassTimeView.frame), (CGRectGetHeight(_iRightView.frame))*Proportion);
        
        tFrame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), CGRectGetWidth(_iClassTimeView.frame), (CGRectGetHeight(_iRightView.frame))*Proportion - kBottomDrawHeight);

    }
    TKEduClassRoomProperty      *tClassRoomProperty  = _iTKEduClassRoomProperty;
    TKEduClassRoomSessionHandle *tSessonHandle = _iTKEduClassRoomSessionHandle;
    
    _iTKEduWhiteBoardView =  [_iTKEduWhiteBoardHandle createWhiteBoard:self Frame:tFrame UserName:@"whiteBoard" aClassRoomProperty:_iTKEduClassRoomProperty  aClassRoomSessionHandle:tSessonHandle aBloadFinishedBlock:^{
        [TKEduClassRoomNetWorkManager getGiftinfo:_iTKEduClassRoomProperty.iRoomId aParticipantId: _iTKEduClassRoomProperty.iUserId  aHost:_iTKEduClassRoomProperty.sWebIp aPort:_iTKEduClassRoomProperty.sWebPort aGetGifInfoComplete:^(id  _Nullable response) {
            dispatch_async(dispatch_get_main_queue(), ^{
#if TARGET_IPHONE_SIMULATOR
                
#else
                int result = 0;
                result = [[response objectForKey:@"result"]intValue];
                if (!result || result == -1) {
                    
                    NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                    
                    for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                        if (![_iTKEduClassRoomProperty.iUserId isEqualToString:@"0"] && _iTKEduClassRoomProperty.iUserId) {
                            NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                            if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:_iTKEduClassRoomProperty.iUserId]) {
                                
                                _iGiftCount = [[tDicInfo objectForKey:@"giftnumber"]intValue];
                                
                                [_iSendGiftButton setTitle:[NSString stringWithFormat:@"%@",@(_iGiftCount)] forState:UIControlStateNormal];
                                [tSessonHandle joinEduClassRoomForWithHost:tClassRoomProperty.sWebIp aPort:tClassRoomProperty.sWebPort aNickName:_iTKEduClassRoomProperty.sNickName aDomain:tClassRoomProperty.sDomain aRoomId:tClassRoomProperty.iRoomId aPassword:tClassRoomProperty.sCmdPassWord aUserID:tClassRoomProperty.iUserId Properties:@{sGiftNumber:@(_iGiftCount)}];
                                return ;
                                
                            }
                        }
                        
                        
                    }
                    [tSessonHandle joinEduClassRoomForWithHost:tClassRoomProperty.sWebIp aPort:tClassRoomProperty.sWebPort aNickName:_iTKEduClassRoomProperty.sNickName aDomain:tClassRoomProperty.sDomain aRoomId:tClassRoomProperty.iRoomId aPassword:tClassRoomProperty.sCmdPassWord aUserID:tClassRoomProperty.iUserId Properties:nil];
                    
                }
#endif
            });
            
        } aGetGifInfoError:^int(NSError * _Nullable aError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tSessonHandle joinEduClassRoomForWithHost:tClassRoomProperty.sWebIp aPort:tClassRoomProperty.sWebPort aNickName:_iTKEduClassRoomProperty.sNickName aDomain:tClassRoomProperty.sDomain aRoomId:tClassRoomProperty.iRoomId aPassword:tClassRoomProperty.sCmdPassWord aUserID:tClassRoomProperty.iUserId Properties:nil];
            });
            
            return 1;
        }];
        
        
        
    } aRootView:self.view];
    [_iScroll addSubview:_iTKEduWhiteBoardView];

#pragma mark -  底部xc_bottomParentView
    [self init_mas_bottomToolBarParentView];

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
    [_iScroll addSubview:self.xc_bottomToolBarParentView];
    
    self.xc_bottomToolBarParentView.frame = CGRectMake(0, _iTKEduWhiteBoardView.bottom, _iTKEduWhiteBoardView.width, (CGRectGetHeight(_iRightView.frame))*Proportion - _iTKEduWhiteBoardView.height);
    
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


-(void)initBottomView{
    _iBottomView = ({
    
        UIView *tBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH - sBottomViewHeigh*Proportion, CGRectGetWidth(_iClassTimeView.frame), sBottomViewHeigh *Proportion)];
        tBottomView;
        
    });
    _iBottomView.backgroundColor = RGBCOLOR(48, 48, 48);
    
    [_iScroll addSubview:_iBottomView];
    
    
    CGFloat tWidth = sStudentVideoViewWidth*Proportion;
    CGFloat tHeight = sStudentVideoViewHeigh*Proportion;
    CGFloat tCap = sViewCap *Proportion;
    _iOurVideoBottomView = ({
        
        TKVideoSmallView *tOurVideoBottomView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tCap, tCap,tWidth , tHeight) iRootView:nil aVideoRole:EVideoRoleOther];
        tOurVideoBottomView.iPeerId         = @"";
        tOurVideoBottomView.iVideoViewTag   = VideoViewTag_OurVideoBottomView;
        tOurVideoBottomView.iEduClassRoomSessionHandle = _iTKEduClassRoomSessionHandle;
        tOurVideoBottomView;
        
    });
    [_iBottomView addSubview:_iOurVideoBottomView];
    _iStudent1VideoView = ({
        
        TKVideoSmallView *tOurVideoBottomView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tCap*2 + tWidth,tCap, tWidth, tHeight) iRootView:nil aVideoRole:EVideoRoleOther];
        tOurVideoBottomView.iPeerId         = @"";
        tOurVideoBottomView.iVideoViewTag   = VideoViewTag_Student1VideoView;
         tOurVideoBottomView.iEduClassRoomSessionHandle = _iTKEduClassRoomSessionHandle;
        tOurVideoBottomView;
        
    });
    [_iBottomView addSubview:_iStudent1VideoView];
    _iStudent2VideoView = ({
        
        TKVideoSmallView *tOurVideoBottomView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tCap*3 + tWidth*2,tCap, tWidth, tHeight) iRootView:nil aVideoRole:EVideoRoleOther];
        tOurVideoBottomView.iPeerId         = @"";
        tOurVideoBottomView.iVideoViewTag   = VideoViewTag_Student2VideoView;
         tOurVideoBottomView.iEduClassRoomSessionHandle = _iTKEduClassRoomSessionHandle;
        tOurVideoBottomView;
        
    });
    [_iBottomView addSubview:_iStudent2VideoView];
    _iStudent3VideoView = ({
        
        TKVideoSmallView *tOurVideoBottomView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tCap*4 + tWidth*3,tCap, tWidth, tHeight) iRootView:nil aVideoRole:EVideoRoleOther];
        tOurVideoBottomView.iPeerId         = @"";
        tOurVideoBottomView.iVideoViewTag   = VideoViewTag_Student3VideoView;
         tOurVideoBottomView.iEduClassRoomSessionHandle = _iTKEduClassRoomSessionHandle;
        tOurVideoBottomView;
        
    });
    [_iBottomView addSubview:_iStudent3VideoView];
    _iStudent4VideoView = ({
        
        TKVideoSmallView *tOurVideoBottomView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tCap*5 + tWidth*4,tCap, tWidth, tHeight) iRootView:nil aVideoRole:EVideoRoleOther];
        tOurVideoBottomView.iPeerId         = @"";
        tOurVideoBottomView.iVideoViewTag   = VideoViewTag_Student4VideoView;
        tOurVideoBottomView.iEduClassRoomSessionHandle = _iTKEduClassRoomSessionHandle;
        tOurVideoBottomView;
        
    });
    [_iBottomView addSubview:_iStudent4VideoView];
    _iStudent5VideoView = ({
        
        TKVideoSmallView *tOurVideoBottomView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tCap*6 + tWidth*5,tCap, tWidth, tHeight) iRootView:nil aVideoRole:EVideoRoleOther];
        tOurVideoBottomView.iPeerId         = @"";
        tOurVideoBottomView.iVideoViewTag   = VideoViewTag_Student5VideoView;
         tOurVideoBottomView.iEduClassRoomSessionHandle = _iTKEduClassRoomSessionHandle;
        tOurVideoBottomView;
        
    });
    [_iBottomView addSubview:_iStudent5VideoView];
    if (!(_iStudentAndTeacherVideoViewArray)) {
        _iStudentAndTeacherVideoViewArray = [NSMutableArray arrayWithCapacity:10];
        
    }
    [_iStudentAndTeacherVideoViewArray addObject:_iTeacherVideoView];
    if (_iRoomType == RoomType_OneToOne) {
        
        [_iStudentAndTeacherVideoViewArray addObject:_iOurVideoView];
        _iBottomView.hidden = YES;
        
    }else{
        [_iStudentAndTeacherVideoViewArray addObject:_iOurVideoBottomView];
        [_iStudentAndTeacherVideoViewArray addObject:_iStudent1VideoView];
        [_iStudentAndTeacherVideoViewArray addObject:_iStudent2VideoView];
        [_iStudentAndTeacherVideoViewArray addObject:_iStudent3VideoView];
        [_iStudentAndTeacherVideoViewArray addObject:_iStudent4VideoView];
        [_iStudentAndTeacherVideoViewArray addObject:_iStudent5VideoView];
    }

}





- (void)createTimer {
    
    if (!_iCheckPlayVideotimer) {
//        _iNavHideControltimer = [NSTimer scheduledTimerWithTimeInterval:5
//                                                                 target:self
//                                                               selector:@selector(moveNaviBar)
//                                                               userInfo:nil
//                                                                repeats:YES];
        
//        _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                                 target:self
//                                                               selector:@selector(classBegin)
//                                                               userInfo:nil
//                                                                repeats:YES];
//        [_iClassTimetimer setFireDate:[NSDate distantFuture]];
         __weak typeof(self)weekSelf = self;
        _iCheckPlayVideotimer = [[TKTimer alloc]initWithTimeout:0.5 repeat:YES completion:^{
            __strong typeof(self)strongSelf = weekSelf;
            
            [strongSelf checkPlayVideo];
            
            
        } queue:dispatch_get_main_queue()];
        
        [_iCheckPlayVideotimer start];
       
        
    }
    
}
- (void)invalidateTimer {
    if (_iCheckPlayVideotimer) {
//        [_iNavHideControltimer invalidate];
//        _iNavHideControltimer = nil;
//        [_iClassTimetimer invalidate];
//        _iClassTimetimer = nil;
        [_iCheckPlayVideotimer invalidate];
        _iCheckPlayVideotimer = nil;
    }
}
- (void)resetTimer {
    
    [_iNavHideControltimer setFireDate:[NSDate distantFuture]];
    [_iNavHideControltimer setFireDate:[NSDate dateWithTimeInterval:5 sinceDate:[NSDate date]]];
   
}


- (void)moveNaviBar {
    
    if (_titleView.hidden) {
        [_iNavHideControltimer setFireDate:[NSDate dateWithTimeInterval:5 sinceDate:[NSDate date]]];
        
    } else {
        [_iNavHideControltimer setFireDate:[NSDate distantFuture]];
    }
  
    [self reSetTitleView:!_titleView.hidden aInputContainerIsHide:!_inputContainer.hidden aStatusIsHide:!_titleView.hidden];
    [self.view bringSubviewToFront:_inputContainer];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)classBegin{
    _iLocalTime +=1;
    [self setClassTime:_iClassTimeButton];
}
-(void)checkPlayVideo{
    

    NSArray *tPlayVideoArray         = [[_iTKEduClassRoomSessionHandle userPlayVideoArray]copy];
    if ([tPlayVideoArray count] == [_iUserPlayVideoArrayPre count]) {
        return;
    }
    
    //右边的打开
    NSArray *tStudentAndTeacherArray = [[_iTKEduClassRoomSessionHandle userPlayVideoArray]copy];
    
    for (int i = 0; i< [tStudentAndTeacherArray count]; i++) {
        
        RoomUser *tRoomUser = [tStudentAndTeacherArray objectAtIndex:i];
        if (i<[_iStudentAndTeacherVideoViewArray count]) {
            TKVideoSmallView *tStudentVideoView =  [_iStudentAndTeacherVideoViewArray objectAtIndex:i];
            
            
            
            if (![tStudentVideoView.iPeerId isEqualToString:@""]) {
                [self myUnPlayVideo:tRoomUser aVideoView:tStudentVideoView completion:^(NSError *error) {
                    [self myPlayVideo:tRoomUser aVideoView:tStudentVideoView completion:^(NSError *error) {
                        
                    }];
                }];
            }else{
                [self myPlayVideo:tRoomUser aVideoView:tStudentVideoView completion:^(NSError *error) {
                    
                }];
            }
        }
        
        
    }

    _iUserPlayVideoArrayPre = [_iTKEduClassRoomSessionHandle userPlayVideoArray].copy;
    _iPreScrollConoffset = _iScroll.contentOffset.x;
   
   
    
}

-(void)unPlayVideo:(RoomUser*)aRoomUser withIndex:(NSInteger)aIndex{
    
 
    if (_iScroll.contentOffset.x < ScreenW) {
        NSArray *tStudentArray = [[_iTKEduClassRoomSessionHandle userPlayVideoArray]copy];
        int  isRemoveIndex = (int)tStudentArray.count;
        for (int i = 0; i<tStudentArray.count; i++)
        {
            
            RoomUser *tRoomUser = [tStudentArray objectAtIndex:i];
            TKVideoSmallView *tStudentVideoView =  [_iStudentAndTeacherVideoViewArray objectAtIndex:i];
            
            if ([aRoomUser.peerID isEqualToString:tRoomUser.peerID])
            {
                if (![tStudentVideoView.iPeerId isEqualToString:@""]) {
                    isRemoveIndex  = i;
                    [self myUnPlayVideo:tRoomUser aVideoView:tStudentVideoView completion:^(NSError *error) {
                        
                    }];
                }
               
            }
            
            //删除后边的
            if (isRemoveIndex < tStudentArray.count) {
                [self myUnPlayVideo:aRoomUser aVideoView:tStudentVideoView completion:^(NSError *error) {
                    
                }];
            }
            
        }
      
    }

  
}
-(void)myUnPlayVideo:(RoomUser*)aRoomUser aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    [_iTKEduClassRoomSessionHandle sessionHandleUnPlayVideo:aRoomUser.peerID completion:^(NSError *error) {
        //更新uiview
        aVideoView.iPeerId = @"";
        [aVideoView.iRealVideoView removeFromSuperview];
        [aVideoView changeName:@""];
         TKLog(@"----unplay:%@ aVideoView.iPeerId:%@ frame:%@ VideoView:%@",aRoomUser.nickName,aRoomUser.peerID,@(aVideoView.frame.size.width),@(aVideoView.iVideoViewTag));
        [_iVideoViewMutableDic setObject:@(0) forKey:[NSString stringWithFormat:@"%@",@(aVideoView.iVideoViewTag)]];
        completion(error);
        
    }];
}
-(void)myPlayVideo:(RoomUser*)aRoomUser aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
   
        [_iTKEduClassRoomSessionHandle sessionHandlePlayVideo:aRoomUser.peerID completion:^(NSError *error, NSObject *view) {
            
            UIView *tView             = (UIView *)view;
            aVideoView.iPeerId        = aRoomUser.peerID;
            aVideoView.iMessageType   = aRoomUser.role;
            aVideoView.iRealVideoView = tView;
            tView.frame = CGRectMake(0, 0, CGRectGetWidth(aVideoView.iVideoFrame), CGRectGetHeight(aVideoView.iVideoFrame));
            
            [aVideoView addSubview:tView];
            if ([aRoomUser.peerID isEqualToString:_iTKEduClassRoomSessionHandle.localUser.peerID]) {
                [aVideoView changeName:[NSString stringWithFormat:@"%@(%@)",aRoomUser.nickName,MTLocalized(@"Role.Me")]];
            }else if (aRoomUser.role == UserType_Teacher){
                [aVideoView changeName:[NSString stringWithFormat:@"%@(%@)",aRoomUser.nickName,MTLocalized(@"Role.Teacher")]];
            }else{
                [aVideoView changeName:aRoomUser.nickName];
            }

            TKLog(@"----play:%@  playerID:%@ frame:%@ VideoView:%@",aRoomUser.nickName, aVideoView.iPeerId,@(tView.frame.size.width),@(aVideoView.iVideoViewTag));
            [_iVideoViewMutableDic setObject:@(1) forKey:[NSString stringWithFormat:@"%@",@(aVideoView.iVideoViewTag)]];
            
            completion(error);
        
    }];

}

-(void)initTapGesTureRecognizer{
    UITapGestureRecognizer* tapTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTable:)];
    tapTableGesture.delegate = self;
    [_iScroll addGestureRecognizer:tapTableGesture];
}
-(void)initChatView{
   
    
    _iChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, (ScreenH-sChatTableViewHeigh)-8, sChatTableViewWidth, sChatTableViewHeigh) style:UITableViewStylePlain];
    _iChatTableView.backgroundColor = [UIColor clearColor];
    _iChatTableView.separatorColor  = [UIColor clearColor];
    _iChatTableView.showsHorizontalScrollIndicator = NO;
    _iChatTableView.delegate   = self;
    _iChatTableView.dataSource = self;
     _iChatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_iChatTableView registerClass:[TKLiveViewChatTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_iScroll addSubview:_iChatTableView];
   
    
    
     _inputContainerFrame = CGRectMake(0, ScreenH-sChatBarHeight, ScreenW, sChatBarHeight);
    _inputContainer                       = ({
    
        TGInputToolBarView *tTollBarView =  [[TGInputToolBarView alloc] initWithFrame:_inputContainerFrame];
        tTollBarView.backgroundColor       = RGBCOLOR(48,48,48);
        //tTollBarView.layer.backgroundColor = RGBCOLOR(247,247,247).CGColor;
        tTollBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        tTollBarView;
    
    });
   
    [_iScroll addSubview:_inputContainer];
    
    _inputInerContainer = ({
        

        CGRect tInPutInerContainerRect = CGRectMake(6, 6, ScreenW-6*3-sRaiseHandWidth, sChatBarHeight-6*2);
        TGInputToolBarView *tInputInerContainer  = [[TGInputToolBarView alloc] initWithFrame:tInPutInerContainerRect];
        tInputInerContainer.backgroundColor       = RGBCOLOR(70,70,70);
        tInputInerContainer.layer.borderColor     = RGBCOLOR(70,70,70).CGColor;
        tInputInerContainer.layer.borderWidth     = 1;
        tInputInerContainer.layer.masksToBounds = YES;
        tInputInerContainer.layer.cornerRadius = 4;
        tInputInerContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        tInputInerContainer;
        
        
    });
     [_inputContainer addSubview:_inputInerContainer];
    //[TKUtil setWidth:_inputInerContainer To:CGRectGetWidth(_inputInerContainer.frame)+CGRectGetWidth(_iRaiseHandButton.frame)];
    
    _iRaiseHandButton =({
    
        UIButton * tRaiseHandButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        tRaiseHandButton.frame = CGRectMake(0, 6, sRaiseHandWidth, sRaiseHandHeigh);
        [TKUtil setRight:tRaiseHandButton To:_inputContainer.frame.size.width-6];
        tRaiseHandButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tRaiseHandButton setBackgroundImage:LOADIMAGE(@"btn_hand_normal") forState:UIControlStateNormal];
        [tRaiseHandButton setBackgroundImage:LOADIMAGE(@"btn_hand_pressed") forState:UIControlStateSelected];
        [tRaiseHandButton addTarget:self action:@selector(raiseHandAction:) forControlEvents:UIControlEventTouchUpInside];
        tRaiseHandButton;
    
    });
    
    [_inputContainer addSubview:_iRaiseHandButton];
   
    
    
    _inputField =({
        
       CGFloat tInPutInerContainerWidth = CGRectGetWidth(_inputInerContainer.frame);
       CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
       CGRect rectInputFieldFrame = CGRectMake(0, 0, tInPutInerContainerWidth-sSendButtonWidth, tInPutInerContainerHeigh);
       TKGrowingTextView *tInputField =  [[TKGrowingTextView alloc] initWithFrame:rectInputFieldFrame];
        tInputField.internalTextView.backgroundColor = RGBCOLOR(70,70,70);
        [tInputField.internalTextView setTextColor:RGBACOLOR(168, 168, 168, 1)];
        [tInputField.internalTextView setTintColor:RGBACOLOR(255, 255, 255, 1)];
        //    _inputField.layer.borderColor = RGBCOLOR(60,61,64).CGColor;
        //    _inputField.layer.borderWidth = 1;
        tInputField.font = [UIFont systemFontOfSize:15];
        tInputField.delegate = self;
        tInputField.maxNumberOfLines = 5;
        tInputField.internalTextView.returnKeyType = UIReturnKeySend;
        tInputField.internalTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        tInputField;
    
    });
   
    [_inputInerContainer addSubview:_inputField];
    
   
    _replyText                 = ({
        CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
        CGRect tReplyTextFrame = CGRectMake(8, 0, 100, tInPutInerContainerHeigh);
        UILabel *tReplyText                 = [[UILabel alloc] initWithFrame:tReplyTextFrame];
        //tReplyText.backgroundColor = [UIColor redColor];
        tReplyText.textColor       = RGBCOLOR(99, 99, 99);
        tReplyText.text            = MTLocalized(@"Say.say");//@"说点什么吧";
        tReplyText.textAlignment   = NSTextAlignmentLeft;
        tReplyText.numberOfLines   = 1;
        tReplyText.font            = [UIFont systemFontOfSize:15];
        tReplyText;
    
    });
    
    [_inputInerContainer addSubview:_replyText];
    
    _sendButton = ({
        
        CGFloat tInPutInerContainerHeigh = CGRectGetHeight(_inputInerContainer.frame);
        UIButton *tSendButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        tSendButton.frame = CGRectMake(0, 0, sSendButtonWidth, tInPutInerContainerHeigh);
        [TKUtil setRight:tSendButton To: _inputInerContainer.frame.size.width];
        [tSendButton setTitle:MTLocalized(@"Button.send") forState:UIControlStateNormal];
        //tButton.backgroundColor = [UIColor yellowColor];
        tSendButton.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [tSendButton addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    
        tSendButton;
    });
    [_inputInerContainer addSubview:_sendButton];
    
    _inputContainer.userInteractionEnabled = YES;
    _inputInerContainer.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    _iIsRaiseWidth = CGRectGetWidth(_inputInerContainer.frame)+CGRectGetWidth(_iRaiseHandButton.frame);
    _iIsNORaiseWidth = CGRectGetWidth(_inputInerContainer.frame);
    //默认是举手状态
    _iIsRaiseHandUp                = YES;
    _iRaiseHandButton.hidden       = _iIsRaiseHandUp;
    _iRaiseHandButton.enabled      = NO;
    _iRaiseHandButton.selected     = YES;
    [TKUtil setWidth:_inputInerContainer To:_iIsRaiseWidth];
    
}



-(void)initToolBar{
     _iSendGiftButton = ({
         UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
          tButton.frame = CGRectMake(ScreenW-38*3-8*3, ScreenH-38-8, 38, 38);
       
        tButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [tButton setBackgroundImage:LOADIMAGE(@"icon_gift") forState:UIControlStateNormal];
         _iGiftCount = 0;
        //[tButton addTarget:self action:@selector(sendGif:) forControlEvents:UIControlEventTouchUpInside];
        [tButton setTitle:[NSString stringWithFormat:@"%@",@(_iGiftCount)] forState:UIControlStateNormal];
         
        [tButton setTitleColor:RGBCOLOR(240,207,46)forState:UIControlStateNormal];
        tButton.titleLabel.font = TKFont(11);
        tButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        tButton;
    
         
    });
    _iShowNavButton = ({
        UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tButton.frame = CGRectMake(ScreenW-38*2-8*2, ScreenH-38-8, 38, 38);
        
        tButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [tButton setBackgroundImage:LOADIMAGE(@"btn_more_normal") forState:UIControlStateNormal];
        [tButton setBackgroundImage:LOADIMAGE(@"btn_more_pressed") forState:UIControlStateHighlighted];

        [tButton addTarget:self action:@selector(showNavButton:) forControlEvents:UIControlEventTouchUpInside];
        //[tButton setTitle:[NSString stringWithFormat:@"%@",@(_iGiftCount)] forState:UIControlStateNormal];
        
        [tButton setTitleColor:RGBCOLOR(240,207,46)forState:UIControlStateNormal];
        tButton.titleLabel.font = TKFont(11);
       // tButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        
       // [_inputContainer addSubview:_sendButton];
        tButton;
        
        
    });
    _iUserListButton = ({
        UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tButton.frame = CGRectMake(ScreenW-38-8, ScreenH-38-8, 38, 38);
        tButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [tButton setBackgroundImage:LOADIMAGE(@"btn_user_normal") forState:UIControlStateNormal];
        [tButton setBackgroundImage:LOADIMAGE(@"btn_user_pressed") forState:UIControlStateHighlighted];
        [tButton addTarget:self action:@selector(sendUserList) forControlEvents:UIControlEventTouchUpInside];

        tButton;
        
        
    });
    [_iScroll addSubview:_iSendGiftButton];
    [_iScroll addSubview:_iShowNavButton];
    [_iScroll addSubview:_iUserListButton];
    
}

-(void)leftButtonPress{
    

    
 
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:MTLocalized(@"Prompt.prompt") message:MTLocalized(@"Prompt.Quite") preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self prepareForLeave:YES];
    }];
    UIAlertAction *tActionCancel = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    [alter addAction:tActionSure];
     [alter addAction:tActionCancel];
    
    [self presentViewController:alter animated:YES completion:nil];
    
   
   
}

//如果是自己退出，则先掉leftroom。否则，直接退出。
-(void)prepareForLeave:(BOOL)aQuityourself
 {
     
     if (_connectTimer) {
         [_connectTimer invalidate];
         _connectTimer = nil;
     }
    if (_connectHUD) {
        [_connectHUD hide:YES];
        _connectHUD = nil;
    }
     [_iTKEduWhiteBoardHandle clearAllWhiteBoardData];
    [[UIDevice currentDevice] setProximityMonitoringEnabled: NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self invalidateTimer];
    [_iAFNetworkReachablitityManager stopMonitoring];
   
    if ([UIApplication sharedApplication].statusBarHidden) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication]
         setStatusBarHidden:NO
         withAnimation:UIStatusBarAnimationNone];
        
#pragma clang diagnostic pop
        
    }
     _iNetStatus = aQuityourself;
     if (aQuityourself) {
         [_iTKEduClassRoomSessionHandle sessionHandleLeaveRoom:nil];
        
     }else{
         
         _iTKEduClassRoomSessionHandle.session.roomMgr = nil;
         _iTKEduClassRoomSessionHandle.session = nil;
         _iTKEduClassRoomSessionHandle = nil;
         dispatch_block_t blk = ^
         {
             
             [self dismissViewControllerAnimated:YES completion:nil];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:sTKRoomViewControllerDisappear object:nil];
         };
         blk();
     }
    
    
    
    
}

#pragma mark TKEduClassRoomSessionDelegate

//自己进入课堂
- (void)eduClassRoomSessionManagerRoomJoined:(NSError *)error {
      TKLog(@"-----myjoined:error:%@",error);
    _iNetConnectionStatus = NO;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    //  [[NSNotificationCenter defaultCenter] addObserver:self
    //  selector:@selector(proximityStateDidChange:)
    //  name:UIDeviceProximityStateDidChangeNotification object:nil];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    _iTKEduWhiteBoardView.hidden = NO;
    _iNetStatus      = NO;
    _iReconnectCount = 0;
    _iUserType       = _iTKEduClassRoomSessionHandle.localUser.role;
    _iTKEduClassRoomProperty.iUserType = _iUserType;
    _iTKEduClassRoomProperty.iRoomName =_iTKEduClassRoomSessionHandle.roomName;
    _iTKEduClassRoomProperty.iRoomId = [_iTKEduClassRoomSessionHandle.roomProperties objectForKey:@"serial"];
    _iTKEduClassRoomProperty.iUserId = _iTKEduClassRoomSessionHandle.localUser.peerID;
    
//    _titleLable.text =  _iTKEduClassRoomSessionHandle.roomName;
    TKEduClassRoom *shareRoom = [TKEduClassRoom shareTKEduClassRoomInstance];
    _titleLable.text = shareRoom.xc_roomName;
    
    _iGiftCount = [[_iTKEduClassRoomSessionHandle.localUser.properties objectForKey:sGiftNumber]integerValue];
    BOOL meHasVideo = _iTKEduClassRoomSessionHandle.localUser.hasVideo;
    BOOL meHasAudio = _iTKEduClassRoomSessionHandle.localUser.hasAudio;
     [_iTKEduClassRoomSessionHandle sessionHandleUseLoudSpeaker:YES];
    if (_connectHUD) {
        [_connectHUD hide:YES];
        _connectHUD = nil;
    }
    if (self.iReconnectTimeOutTimer) {
        [self.iReconnectTimeOutTimer invalidate];
    }
    //断线重连的timer
    if (_connectTimer) {
        [_connectTimer invalidate];
        _connectTimer = nil;
    }
    if(!meHasVideo){
//        RoomClient.getInstance().warning(1);
        TKLog(@"没有视频");
    }
    if(!meHasAudio){
//        RoomClient.getInstance().warning(2);
         TKLog(@"没有音频");
    }
    
    TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0 iMessageType:MessageType_Message aMessage:[NSString stringWithFormat:@"%@ 进入教室",_iTKEduClassRoomSessionHandle.localUser.nickName] aUserName:_iTKEduClassRoomSessionHandle.localUser.nickName aTime:[TKUtil currentTime]];
    
    
    [_iTKEduClassRoomSessionHandle addOrReplaceMessage:tModel];
    
    [_iTKEduClassRoomSessionHandle addOrReplaceUserArray:_iTKEduClassRoomSessionHandle.localUser];
    
    [self refreshData];
    
    
   
}
//自己离开课堂
- (void)eduClassRoomSessionManagerRoomLeft {
    TKLog(@"-----roomManagerRoomLeft");
     [_iTKEduClassRoomSessionHandle sessionHandleUseLoudSpeaker:NO];
     [_iTKEduClassRoomSessionHandle delUserArray:_iTKEduClassRoomSessionHandle.localUser];
  //无网络的状态自动重连
    if (!_iNetStatus) {
        _iTKEduClassRoomSessionHandle.session.roomMgr = nil;
        _iTKEduClassRoomSessionHandle.session         = nil;
        _iTKEduClassRoomSessionHandle                  = nil;
          [self joinRoomReconnected];
        
    }else{
         [self prepareForLeave:NO];
    }

    
    
   
    
}
-(void) eduClassRoomSessionManagerSelfEvicted{
    //
    
    [self showMessage:MTLocalized(@"KickOut.Repeat")];
    //[self prepareForLeave:NO];
    TKLog(@"-----SelfEvicted");
    
}

//观看视频
- (void)eduClassRoomSessionManagerUserPublished:(RoomUser *)user {
    
//    BOOL tHiden = (_iTKEduClassRoomSessionHandle.roomType) ? NO : YES;
//    _iStudent1VideoView.hidden = tHiden;
//    _iStudent2VideoView.hidden = tHiden;
//    _iStudent3VideoView.hidden = tHiden;
//    _iStudent4VideoView.hidden = tHiden;
//    _iStudent5VideoView.hidden = tHiden;
//
//    !tHiden?: [TKUtil setWidth:_iTeacherVideoViewRight To:(([UIScreen mainScreen].bounds.size.width -3*VideoSmallViewMargins)/ 2.0)];
//    !tHiden?:[TKUtil setHeight:_iTeacherVideoViewRight To:CGRectGetWidth(_iTeacherVideoViewRight.frame)*3.0/4.0];
//    !tHiden?: [TKUtil setWidth:_iOurVideoViewRight To:(([UIScreen mainScreen].bounds.size.width -3*VideoSmallViewMargins)/ 2.0)];
//    !tHiden?:[TKUtil setHeight:_iOurVideoViewRight To:CGRectGetWidth(_iOurVideoViewRight.frame)*3.0/4.0];

    [_iTKEduClassRoomSessionHandle addOrReplaceUserPlayVideoArray:user];
     TKLog(@"------publish:%@",user.nickName);
    [self checkPlayVideo];
    
    
}
//取消视频
- (void)eduClassRoomSessionManagerUserUnpublished:(RoomUser *)user {
    TKLog(@"------unpublish:%@",user.nickName);
    int i = 0;
    [self unPlayVideo:user withIndex:i];
    
    [_iTKEduClassRoomSessionHandle delUserPlayVideoArray:user];
}

//用户进入
- (void)eduClassRoomSessionManagerUserJoined:(RoomUser *)user InList:(BOOL)inList {
   
   TKLog(@"------otherJoined:%@ peerID:%@",user.nickName,user.peerID);
    UserType tMyRole = _iTKEduClassRoomSessionHandle.localUser.role;
    RoomType tRoomType = _iTKEduClassRoomSessionHandle.roomType;
    if (inList) {
        //1 大班课 //0 小班课
        if ((user.role == UserType_Teacher && tMyRole == UserType_Teacher) || (tRoomType == RoomType_OneToOne && user.role == UserType_Student &&![user.peerID isEqualToString:_iTKEduClassRoomSessionHandle.localUser.peerID])) {
            [_iTKEduClassRoomSessionHandle sessionHandleEvictUser:user.peerID completion:nil];
        }
        
    }
    
    
    if (tMyRole == UserType_Teacher) {
        NSString* tChairmancontrol = [_iTKEduClassRoomSessionHandle.roomProperties objectForKey:sChairmancontrol];
        NSRange range5 = NSMakeRange(23, 1);
        NSString *str = [tChairmancontrol substringWithRange:range5];;
        
        // 自动打开音视频时，并且当前会议室是静音状态，则需要改变会议室的状态
        if (([str intValue]  == 1 ) && _isMuteAudio) {
            [_iTKEduClassRoomSessionHandle sessionHandleDelMsg:sMuteAudio ID:sMuteAudio To:sTellAll Data:nil completion:nil];
            
            
        }
    }
    TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0 iMessageType:MessageType_Message aMessage:[NSString stringWithFormat:@"%@ 进入教室",user.nickName] aUserName:nil aTime:[TKUtil currentTime]];
    [_iTKEduClassRoomSessionHandle addOrReplaceMessage:tModel];
    [_iTKEduClassRoomSessionHandle addOrReplaceUserArray:user];
    
    [self refreshData];
    
    
}
//用户离开
- (void)eduClassRoomSessionManagerUserLeft:(RoomUser *)user {
    //[_iTKEduClassRoomSessionHandle delUserForAll:user];
     TKLog(@"------otherleft:%@",user.nickName);
    TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0 iMessageType:MessageType_Message aMessage:[NSString stringWithFormat:@"%@ 离开教室",user.nickName] aUserName:nil aTime:[TKUtil currentTime]];
    [_iTKEduClassRoomSessionHandle addOrReplaceMessage:tModel];
    [_iTKEduClassRoomSessionHandle delUserArray:user];
    [self refreshData];
}
//用户信息变化 
- (void)eduClassRoomSessionManagerUserChanged:(RoomUser *)user Properties:(NSDictionary*)properties{
    
     TKLog(@"------UserChanged:%@ properties:(%@)",user.nickName,properties);
    
    NSString *tMyPeerId = _iTKEduClassRoomSessionHandle.localUser.peerID;
    if ([user.peerID isEqualToString:tMyPeerId]) {
       
        if ([properties objectForKey:sGiftNumber]) {
            NSInteger tGiftNumber = [[properties objectForKey:sGiftNumber]integerValue];
            [self sendGif:tGiftNumber];
        }
        
        if ([properties objectForKey:sCandraw]) {
            _iCandraw         = [[properties objectForKey:sCandraw]boolValue];
            [_iTKEduWhiteBoardHandle setDrawable:_iCandraw];
          
           
            _iScroll.scrollEnabled = !_iCandraw;
        }
        if ([properties objectForKey:sRaisehand]) {
            //如果没做改变的话，就不变化
            NSLog(@"------raiseHand%@",[properties objectForKey:sRaisehand]);
            
           
//            _iIsRaiseHandUp = [[properties objectForKey:sRaisehand]boolValue];
//       
//            _iRaiseHandButton.hidden       = _iIsRaiseHandUp;
//           
//            _iIsRaiseHandUp?[TKUtil setWidth:_inputInerContainer To:_iIsRaiseWidth]:[TKUtil setWidth:_inputInerContainer To:_iIsNORaiseWidth];
//            
            // [_iRaiseHandButton setBackgroundImage:tImage forState:tControlState];
            
        }
        
        if ([properties objectForKey:sPublishstate]) {
              NSLog(@"------sPublishstate%@",[properties objectForKey:sPublishstate]);
            if ([[properties objectForKey:sPublishstate] intValue] == PublishState_NONE || ([[properties objectForKey:sPublishstate] intValue]== PublishState_VIDEOONLY)) {
                //如果是非举手状态则跳过，否则设置成非举手状态
//                if (!_iRaiseHandButton.hidden && !_iIsRaiseHandUp) {
//                    return;
//                }
                _iIsRaiseHandUp                = NO;
                _iRaiseHandButton.hidden       = _iIsRaiseHandUp;
                _iRaiseHandButton.enabled      = YES;
                _iRaiseHandButton.selected     = NO;
                //[TKUtil setWidth:_inputInerContainer To:_iIsNORaiseWidth];
                
            }else if([[properties objectForKey:sPublishstate] intValue] == PublishState_BOTH){
                //如果是举手状态则跳过，否则变成举手状态
//                if (_iRaiseHandButton.hidden && _iIsRaiseHandUp) {
//                    return;
//                }
                _iIsRaiseHandUp                = YES;
                _iRaiseHandButton.hidden       = _iIsRaiseHandUp;
                _iRaiseHandButton.enabled      = NO;
                _iRaiseHandButton.selected     = YES;
                //[TKUtil setWidth:_inputInerContainer To:_iIsRaiseWidth];
                
            }
            
        }
        
       
        
    }
    
}
//聊天信息
- (void)eduClassRoomSessionManagerMessageReceived:(NSString *)message ofUser:(RoomUser *)user {

     TKLog(@"------MessageReceived:%@ userName:(%@)",message,user.nickName);
    NSString *tMyPeerId = _iTKEduClassRoomSessionHandle.localUser.peerID;
    //自己发送的收不到
    if (!user) {
        user = _iTKEduClassRoomSessionHandle.localUser;
    }
    MessageType tMessageType = ([user.peerID isEqualToString:tMyPeerId])?MessageType_Me:MessageType_OtherUer;
    TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:user.peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:message aUserName:user.nickName aTime:[TKUtil currentTime]];
    [_iTKEduClassRoomSessionHandle addOrReplaceMessage:tChatMessageModel];
    [self refreshData];
    
    
}
//进入会议失败
- (void)eduClassRoomSessionManagerDidFailWithError:(NSError *)error {
 
    TKLog(@"------didFailWithError:%@",error);
    NSString *tErrorString = error.description;
    NSArray *tErrorArray = [[tErrorString lowercaseString]componentsSeparatedByString:@"socket"];
    if ([tErrorArray count]>1) {
         [self leftRoomAbnormal];
    }
   
}

//相关信令
- (void)eduClassRoomSessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data {
     TKLog(@"------remoteMsg:%@ msgID:%@",msgName,msgID);
   
    //添加
    if ([msgName isEqualToString:sClassBegin]) {
       
        NSString* tChairmancontrol = [_iTKEduClassRoomSessionHandle.roomProperties objectForKey:sChairmancontrol];
       // NSString *str = [NSString stringWithFormat:@"%@",[tChairmancontrol characterAtIndex:23]];
        NSRange range5 = NSMakeRange(23, 1);
        NSString *str = [tChairmancontrol substringWithRange:range5];;
        NSString *tPeerId = _iTKEduClassRoomSessionHandle.localUser.peerID;
       
         //上课
        if (add) {
            
            _isClassBegin = YES;
            _iTKEduWhiteBoardHandle.isClassBegin = YES;
             [self showMessage:MTLocalized(@"Class.Begin")];
            
            if ([str intValue]  == 1) {

                [_iTKEduClassRoomSessionHandle sessionHandleChangeUserPublish:tPeerId Publish:(_isMuteAudio ? PublishState_VIDEOONLY:PublishState_BOTH) completion:^(NSError *error) {
                    
                }];
               
            }
            _iClassStartTime = ts;
            [_iTKEduWhiteBoardHandle setPagePermission:false];
            [_iTKEduClassRoomSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:tPeerId  Data:data Save:false completion:^(NSError *error) {
                
            }];
            
            //[_iClassTimeView setClassTime:_iClassStartTime];
            [_iClassTimeView startClassBeginTimer];
            [self refreshUI];
            
            
        }else{
            //下课
             _isClassBegin = NO;
             _iTKEduWhiteBoardHandle.isClassBegin = NO;
            
            [self showMessage:MTLocalized(@"Class.Over")];
            if ([str intValue]  == 1) {

                [_iTKEduClassRoomSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:PublishState_NONE completion:^(NSError *error) {
                    
                }];
            }
            [_iTKEduWhiteBoardHandle setPagePermission:YES];
            //_iLocalTime = 0;
            //[_iClassTimetimer invalidate];
             [self refreshUI];
             [_iClassTimeView invalidateClassBeginTime];

        }
    }else if ([msgName isEqualToString:sUpdateTime]){
        
        if (add) {
           
            if (_isClassBegin) {
                _iServiceTime = ts;
                _iLocalTime   = _iServiceTime - _iClassStartTime;
                [self setClassTime:_iClassTimeButton];
               // [_iClassTimetimer setFireDate:[NSDate date]];

            }
            
        }
        
    }else if ([msgName isEqualToString:sMuteAudio]){
        
        int tPublishState = _iTKEduClassRoomSessionHandle.localUser.publishState;
        NSString *tPeerId = _iTKEduClassRoomSessionHandle.localUser.peerID;
        _isMuteAudio = add ?true:false;
        if (tPublishState != PublishState_VIDEOONLY) {
            [_iTKEduClassRoomSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:(tPublishState)+(_isMuteAudio ?(-PublishState_AUDIOONLY):(PublishState_AUDIOONLY)) completion:^(NSError *error) {
                
            }];
        }else{
            [_iTKEduClassRoomSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:(_isMuteAudio ?(PublishState_NONE):(PublishState_AUDIOONLY)) completion:^(NSError *error) {
                
            }];
        }
      

    }
    
}


- (void)eduClassRoomSessionManagerIceStatusChanged:(NSString*)state ofUser:(RoomUser *)user {
    TKLog(@"------IceStatusChanged:%@ nickName:%@",state,user.nickName);
}


#pragma mark TKEduWhiteBoardDelegate

- (void)eduWhiteBoardOnFileList:(NSArray*)fileList{
     TKLog(@"------OnFileList:%@ ",fileList);
}
- (BOOL)eduWhiteBoardOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data{
    TKLog(@"------WhiteBoardOnRemoteMsg:%@ msgID:%@ ",msgName,msgID);
    return NO;
    
}
- (void)eduWhiteBoardOnRemoteMsgList:(NSArray*)list{
    
}
#pragma mark scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    
#pragma clang diagnostic pop
    
    
}

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return 2;
    return _iMessageList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tHeight = 0;
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.row];

    switch (tMessageModel.iMessageType) {
        case MessageType_Message:
        {
            
            CGSize titlesize = [TKMessageTableViewCell sizeFromText:tMessageModel.iMessage withLimitHeight:28 Font:TEXT_FONT];
            tHeight = titlesize.height;
            
        }
            break;
       
        case MessageType_Me:
        {
            CGSize titlesize = [TKTeacherMessageTableViewCell sizeFromText:tMessageModel.iMessage withLimitWidth:tableView.width-22*Proportion-10*2*Proportion Font:TKFont(15)];
            CGSize tTranslationSize = [TKTeacherMessageTableViewCell sizeFromText:tMessageModel.iTranslationMessage withLimitWidth:tableView.width-22*Proportion-10*2*Proportion Font:TKFont(15)];

            tHeight = titlesize.height+tTranslationSize.height+5+5;
            
        }
            break;
        case MessageType_OtherUer:
        {
            CGSize titlesize = [TKStudentMessageTableViewCell sizeFromText:tMessageModel.iMessage withLimitWidth:tableView.width-22*Proportion-10*2*Proportion Font:TKFont(15)];
            CGSize tTranslationSize = [TKStudentMessageTableViewCell sizeFromText:tMessageModel.iTranslationMessage withLimitWidth:tableView.width-22*Proportion-10*2*Proportion Font:TKFont(15)];

            tHeight = titlesize.height+tTranslationSize.height + 5;
        }
            break;
        default:
            break;
    }
    
    
    return tHeight + 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
 
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.row];
//    TKMessageTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:sMessageCellIdentifier forIndexPath:indexPath];

    __weak typeof(self)weakSelf = self;
    
    switch (tMessageModel.iMessageType) {
        case MessageType_Message:
        {
            TKMessageTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:sMessageCellIdentifier forIndexPath:indexPath];
            tCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tCell.text = tMessageModel.iMessage;
            [tCell resetView];
            return tCell;
        }
            break;
        case MessageType_Me:
        {
            TKTeacherMessageTableViewCell *tCell = ( TKTeacherMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:sStudentCellIdentifier forIndexPath:indexPath];
             tCell.iText = tMessageModel.iMessage;
            [tCell resetView];
            return tCell;
            
        }
            break;
        case MessageType_OtherUer:
        {
             TKStudentMessageTableViewCell* tCell = ( TKStudentMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:sTeacherCellIdentifier forIndexPath:indexPath];

#pragma mark - 注释掉昵称和时间
//            tCell.iTimeLabel.text = tMessageModel.iTime;
//            tCell.iNickNameLabel.text = tMessageModel.iUserName;
            
            tCell.iText = tMessageModel.iMessage;
            [tCell resetView];
            
            tCell.iTranslationButtonClicked = ^(NSString *aTranslationString){
                __strong typeof(weakSelf) strongSelf = weakSelf;
              
                [TKEduClassRoomNetWorkManager translation:tMessageModel.iMessage aTranslationComplete:^int(id  _Nullable response, NSString * _Nullable aTranslationString) {
                    
                    tMessageModel.iTranslationMessage = aTranslationString;
                    [_iTKEduClassRoomSessionHandle addOrReplaceMessage:tMessageModel];
                    [strongSelf refreshData];
                    return 0;
                }];
            
            };
            
            return tCell;

        }
            break;
        
        default:
            
            break;
    }
    
   
    return nil;
    
    
    
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark Event

-(void)outButtonClicked:(UIButton*)aButton{
   
    if (_isClassBegin) {
        [_iTKEduClassRoomSessionHandle sessionHandleDelMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{@"type":@"pad"} completion:nil];
         TKLog(@"下课");
    }else{
         TKLog(@"还没上课");
    }
 
    
}
-(void)userButtonClicked:(UIButton*)aButton{
    TKLog(@"用户列表");
    [_iUsertListView show:FileListTypeUserList aFileList:[_iTKEduClassRoomSessionHandle userListArray] isClassBegin:_isClassBegin];
    
}
-(void)mediaButtonClicked:(UIButton *)aButton{
     TKLog(@"影音列表");
     [_iMediaListView show:FileListTypeAudioAndVideo aFileList:[_iTKEduWhiteBoardHandle mediaArray] isClassBegin:_isClassBegin];
}
-(void)documentButtonClicked:(UIButton*)aButton{
     TKLog(@"文档列表");
     [_iDocumentListView show:FileListTypeDocument aFileList:[_iTKEduWhiteBoardHandle docmentArray]isClassBegin:_isClassBegin];
}


-(void)replyAction
{
    
    if (!_inputField || !_inputField.text || _inputField.text.length == 0)
    {
        return;
    }
    [_iTKEduClassRoomSessionHandle sessionHandleSendMessage:_inputField.text completion:nil];
    _inputField.text = @"";
   // [self refreshData];
    _replyText.hidden = NO;
    [_inputField resignFirstResponder];
    
}

- (void)replyAction2:(UIButton *)button
{
    button.selected = YES;
    [self.view endEditing:YES];
    [self showPopView:button];
}

- (void)showPopView:(UIButton *)button
{
    //showPopView
    GGT_PopoverController *vc = [GGT_PopoverController new];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.popoverPresentationController.sourceView = button;
    vc.popoverPresentationController.sourceRect = button.bounds;
    vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    vc.popoverPresentationController.delegate = self;
    
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
                //                [self.room.chatVM sendMessage:selectString];
                _inputField.text = selectString;
                [self replyAction];
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
    self.sendButton.selected = NO;
    return YES;
}

//弹框消失时调用的方法
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    NSLog(@"弹框已经消失");
}


-(void)raiseHandAction:(UIButton *)aButton{
    
    
//    if (_iRaiseHandButton.hidden && _iIsRaiseHandUp) {
//        return;
//    }
//    
    NSString *tMyPeerId      = _iTKEduClassRoomSessionHandle.localUser.peerID;
   // _iRaiseHandButton.hidden = YES;
    //_iIsRaiseHandUp          = YES;
    _iRaiseHandButton.enabled  = NO;
    _iRaiseHandButton.selected = YES;
    
//    [TKUtil setWidth:_inputInerContainer To:_iIsRaiseWidth];
    [_iTKEduClassRoomSessionHandle sessionHandleChangeUserProperty:tMyPeerId TellWhom:sTellAllExpectSender Key:sRaisehand Value:@(true) completion:nil];
    
    
}


-(void)sendGif:(NSInteger)aGiftNumber{
    if (aGiftNumber) {
         _iGiftCount = aGiftNumber;
    }
    
    if (_iScroll.contentOffset.x == ScreenW) {
         [_iSendGiftButton setTitle:[NSString stringWithFormat:@"%@",@(_iGiftCount)] forState:UIControlStateNormal];
    }else{
         [self potStartAnimationForView:_iSendGiftButton];
    }
   
   
}

-(void)sendUserList{
    _iScroll.scrollEnabled = YES;
    [_iScroll setContentOffset:CGPointMake(ScreenW, 0) animated:YES];
}
- (void)refreshData
{
    _iMessageList = [_iTKEduClassRoomSessionHandle messageList];
    
    [_iChatTableView reloadData];
    if(_iChatTableView.contentSize.height > _iChatTableView.frame.size.height)
        [_iChatTableView setContentOffset:CGPointMake(0, _iChatTableView.contentSize.height -_iChatTableView.bounds.size.height) animated:YES];
}
#pragma mark keyboard Notification
- (void)keyboardWillShow:(NSNotification*)notification
{
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
   // keyboardFrame = [self convertRect:keyboardFrame fromView:nil];
    //会掉两次notification
    if (_knownKeyboardHeight ==  keyboardFrame.size.height) {
        return;
    }

    _knownKeyboardHeight = keyboardFrame.size.height;
    double duration = ([[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone) animations:^
     {
      
         [TKUtil setBottom:_inputContainer To: CGRectGetHeight(_iRightView.frame)-_knownKeyboardHeight];
         //如果是举手状态或者已经显示，则直接跳过
         if (_iIsRaiseHandUp ) {
             return ;
         }
         _iRaiseHandButton.hidden = YES;
         //[TKUtil setWidth:_inputInerContainer To:_iIsRaiseWidth];
         
     }
                     completion:^(BOOL finished)
     {
         
     }];
    [self changeInputAreaHeight:(int)_knownKeyboardHeight duration:duration orientationChange:false dragging:false completion:nil];
    
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    
    if (_knownKeyboardHeight == 0) {
        return;
    }
    _replyText.hidden = _inputField.text.length != 0;

    
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _knownKeyboardHeight = 0;
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone) animations:^
     {
         
           [TKUtil setBottom:_inputContainer To: CGRectGetHeight(_iRightView.frame)-_knownKeyboardHeight];
         //[TKUtil setBottom:_inputContainer To: ScreenH-_knownKeyboardHeight];
         //如果是举手状态或者已经隐藏举手，则跳过
         if (_iIsRaiseHandUp) {
             return ;
         }
         _iRaiseHandButton.hidden = NO;
        // [TKUtil setWidth:_inputInerContainer To:_iIsNORaiseWidth];
     }
                     completion:^(BOOL finished)
     {
        
     }];
    
    
    [self changeInputAreaHeight:_knownKeyboardHeight duration:duration orientationChange:false dragging:false completion:nil];
}

-(void)reSetTitleView:(BOOL)aIsHide aInputContainerIsHide:(BOOL)aInputContainerIsHide aStatusIsHide:(BOOL)aStatusIsHide{
    _titleView.hidden = aIsHide;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
     [[UIApplication sharedApplication] setStatusBarHidden:aStatusIsHide animated:YES];
    
#pragma clang diagnostic pop
   
   // _inputContainer.hidden = aInputContainerIsHide;
  
}
-(void)chatBegin{
    [_inputField becomeFirstResponder];
}
- (void)changeInputAreaHeight:(int)height duration:(NSTimeInterval)duration orientationChange:(bool)orientationChange dragging:(bool)__unused dragging completion:(void (^)(BOOL finished))completion
{
    

    
}
- (void)updatePlaceholderVisibility:(bool)firstResponder
{
    _replyText.hidden = firstResponder || _inputField.text.length != 0;
}
#pragma mark TKTextViewInternalDelegate
- (void)TKTextViewChangedResponderState:(bool)firstResponder
{
    [self updatePlaceholderVisibility:firstResponder];
}
#pragma mark TKGrowingTextViewDelegate
- (void)growingTextView:(TKGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    [self growingTextView:growingTextView willChangeHeight:height animated:true];
}

- (void)growingTextView:(TKGrowingTextView *)__unused growingTextView willChangeHeight:(float)height animated:(bool)animated
{
    CGRect inputContainerFrame = _inputContainer.frame;
    float newHeight = MAX(10 + height, sChatBarHeight);
    if (inputContainerFrame.size.height != newHeight)
    {
        int currentKeyboardHeight = _knownKeyboardHeight;
        inputContainerFrame.size.height = newHeight;
        inputContainerFrame.origin.y = _inputContainer.superview.frame.size.height - currentKeyboardHeight - inputContainerFrame.size.height;
         _inputContainer.frame = inputContainerFrame;
        _replyText.frame = CGRectMake(10, 5, _inputContainer.frame.size.width - 75 , _inputContainer.frame.size.height - 10);
        
        [TKUtil setHeight:_inputInerContainer To:newHeight-2*6];
        
       
        
        [TKUtil setTop:_iRaiseHandButton To:(newHeight/2.0 - CGRectGetHeight(_iRaiseHandButton.frame)/2.0)];
        [TKUtil setHeight:_inputField To:CGRectGetHeight(_inputInerContainer.frame)];
        
        

        
    }
}

- (void)growingTextViewDidChange:(TKGrowingTextView *)growingTextView
{
    [self updatePlaceholderVisibility:[growingTextView.internalTextView isFirstResponder]];
}

- (BOOL)growingTextViewShouldReturn:(TKGrowingTextView *)growingTextView
{
    [self replyAction];
    return YES;
}

- (BOOL)growingTextViewShouldBeginEditing:(TKGrowingTextView *)growingTextView
{
    _replyText.hidden = YES;
    return YES;
}
- (BOOL)growingTextViewShouldEndEditing:(TKGrowingTextView *)growingTextView
{
    return YES;
}


#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"TKTextViewInternal"] )
    {
        return NO;
    }
    else
    {
        if (_iShowNavButton.selected) {
            _iShowNavButton.selected = NO;
            return YES;
        }
        return !_iCandraw;
        
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}
//_iShowNavButton
-(void)showNavButton:(UIButton *)aButton{
    _iShowNavButton.selected = !aButton.selected;
    [self tapTable:nil];
}
- (void)tapTable:(UIGestureRecognizer *)gesture
{
    
    [_inputField resignFirstResponder];
    [_iDocumentListView hide];
    [_iUsertListView hide];
    [_iMediaListView hide];
    [_iStudent1VideoView hide];
    [_iStudent2VideoView hide];
    [_iStudent3VideoView hide];
    [_iStudent4VideoView hide];
    [_iStudent5VideoView hide];
    [_iTeacherVideoView hide];
    [_iOurVideoView hide];
    [_iOurVideoBottomView hide];
  
    //[self resetTimer];
    //[self moveNaviBar];
}
#pragma mark reconnect
//重连
-(void)reconnectMeeting
{
    
    //_iNetConnectionStatus = YES;
    [self showConnectHUD];
    [self clearDataForReconnectFail];
    _iReconnectCount +=1;
    if (!_iTKEduClassRoomSessionHandle) {
        
        _iTKEduClassRoomSessionHandle = [[TKEduClassRoomSessionHandle alloc]initWithMeetingWithParamDic:_iParamDic aTKEduEnterClassRoomDelegate:_iTKEduEnterClassRoomDelegate aTKEduClassRoomSessionDelegate:self aRoomWhiteBoardDelegate:_iTKEduWhiteBoardHandle];
        
    }
    
    [TKEduClassRoomNetWorkManager getGiftinfo:_iTKEduClassRoomProperty.iRoomId aParticipantId: _iTKEduClassRoomProperty.iUserId  aHost:_iTKEduClassRoomProperty.sWebIp aPort:_iTKEduClassRoomProperty.sWebPort aGetGifInfoComplete:^(id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
#if TARGET_IPHONE_SIMULATOR
            
#else
            int result = 0;
            result = [[response objectForKey:@"result"]intValue];
            if (!result ) {
                
                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                
                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                    if (![_iTKEduClassRoomProperty.iUserId isEqualToString:@"0"]) {
                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:_iTKEduClassRoomProperty.iUserId]) {
                            
                            _iGiftCount = [[tDicInfo objectForKey:@"giftnumber"]intValue];
                            
                            [_iSendGiftButton setTitle:[NSString stringWithFormat:@"%@",@(_iGiftCount)] forState:UIControlStateNormal];
                            [_iTKEduClassRoomSessionHandle joinEduClassRoomForWithHost:_iTKEduClassRoomProperty.sWebIp aPort:_iTKEduClassRoomProperty.sWebPort aNickName:_iTKEduClassRoomProperty.sNickName aDomain:_iTKEduClassRoomProperty.sDomain aRoomId:_iTKEduClassRoomProperty.iRoomId aPassword:_iTKEduClassRoomProperty.sCmdPassWord aUserID:_iTKEduClassRoomProperty.iUserId Properties:@{sGiftNumber:@(_iGiftCount)}];
                            return ;
                            
                        }
                    }else{
                        
                        [_iTKEduClassRoomSessionHandle joinEduClassRoomForWithHost:_iTKEduClassRoomProperty.sWebIp aPort:_iTKEduClassRoomProperty.sWebPort aNickName:_iTKEduClassRoomProperty.sNickName aDomain:_iTKEduClassRoomProperty.sDomain aRoomId:_iTKEduClassRoomProperty.iRoomId aPassword:_iTKEduClassRoomProperty.sCmdPassWord aUserID:_iTKEduClassRoomProperty.iUserId Properties:nil];
                        return;
                    }
                    
                    
                }
            }
            if (result == -1) {
                 [_iTKEduClassRoomSessionHandle joinEduClassRoomForWithHost:_iTKEduClassRoomProperty.sWebIp aPort:_iTKEduClassRoomProperty.sWebPort aNickName:_iTKEduClassRoomProperty.sNickName aDomain:_iTKEduClassRoomProperty.sDomain aRoomId:_iTKEduClassRoomProperty.iRoomId aPassword:_iTKEduClassRoomProperty.sCmdPassWord aUserID:_iTKEduClassRoomProperty.iUserId Properties:nil];
                return;
            }
            
#endif
            
        });
        
    } aGetGifInfoError:^int(NSError * _Nullable aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_iTKEduClassRoomSessionHandle joinEduClassRoomForWithHost:_iTKEduClassRoomProperty.sWebIp aPort:_iTKEduClassRoomProperty.sWebPort aNickName:_iTKEduClassRoomProperty.sNickName aDomain:_iTKEduClassRoomProperty.sDomain aRoomId:_iTKEduClassRoomProperty.iRoomId aPassword:_iTKEduClassRoomProperty.sCmdPassWord aUserID:_iTKEduClassRoomProperty.iUserId Properties:nil];
        });
       
        return 1;
    }];


//    if (_connectTimer) {
//        [_connectTimer invalidate];
//        _connectTimer = nil;
//    }
    
//    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:30
//                                                     target:self
//                                                   selector:@selector(reconnectMeetingError)
//                                                   userInfo:nil
//                                                    repeats:NO];
//    
//
//    [_connectTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:30]];
     TKLog(@"----_connectTimer%@ count:%@ tkEduClassRoomSessionHandle:%@",_connectTimer,@(_iReconnectCount),_iTKEduClassRoomSessionHandle);
}
-(void)reconnectMeetingError{
    TKLog(@"----reconnectMeetingError");
    if (_connectHUD) {
        [_connectHUD hide:YES];
        _connectHUD = nil;
    }
    [_iTKEduClassRoomSessionHandle sessionHandleLeaveRoom:^(NSError *error) {
        
    }];

    
}
-(void)getGif{

    
}
- (void)showConnectHUD
{
    if (!_connectHUD) {
        _connectHUD = [[TKProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:_connectHUD];
        _connectHUD.dimBackground             = YES;
        _connectHUD.removeFromSuperViewOnHide = YES;
    }
    _connectHUD.labelText                 = MTLocalized(@"State.Reconnecting");
    [_connectHUD show:YES];
    
}
- (void)clearDataForReconnectFail{

    _iCandraw = NO;
    [_iTKEduClassRoomSessionHandle clearAllClassData];
    [_iTKEduWhiteBoardHandle clearAllWhiteBoardData];
    _iTeacherVideoView.iPeerId = @"";
     _iOurVideoView.iPeerId = @"";
     _iTeacherVideoViewRight.iPeerId = @"";
     _iOurVideoViewRight.iPeerId = @"";
     _iStudent1VideoView.iPeerId = @"";
     _iStudent2VideoView.iPeerId = @"";
     _iStudent3VideoView.iPeerId = @"";
     _iStudent4VideoView.iPeerId = @"";
     _iStudent5VideoView.iPeerId = @"";
    [_iVideoViewMutableDic removeAllObjects];
    
    
}

#pragma mark 动画
- (void)potStartAnimationForView:(UIView *)view
{
    if (_iGiftAnimationView) {
        return;
    }
    _iGiftAnimationView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"gift")];
    //animationView.backgroundColor = [UIColor yellowColor];
    _iGiftAnimationView.frame = CGRectMake(0, 0, 69, 80);
    _iGiftAnimationView.center = CGPointMake(ScreenW/2, ScreenH/2);
    [self.view addSubview:_iGiftAnimationView];
 
     [self transformForView:_iGiftAnimationView fromOldPoint:_iGiftAnimationView.layer.position toNewPoint:view.layer.position];
}
- (void)transformForView:(UIView *)d fromOldPoint:(CGPoint)oldPoint toNewPoint:(CGPoint)newPoint
{
    CABasicAnimation*scaleAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    //transform.scale:  x轴，y轴同时按比例缩放：
    scaleAnimation.fromValue = [NSNumber numberWithFloat:oldPoint.y+5]; //从 from
    scaleAnimation.toValue = [NSNumber numberWithFloat:oldPoint.y-5]; //to
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeBackwards;
    scaleAnimation.repeatCount = 2;  //重复次数       from到to
    scaleAnimation.duration = 0.8;    //一次时间
    

    //开演
    [d.layer addAnimation:scaleAnimation forKey:@"MoveUpDownAnimation"]; //key -- value.
    
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.fromValue = [NSValue valueWithCGPoint:oldPoint];
    animation.toValue = [NSValue valueWithCGPoint:newPoint];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //设置动画执行完毕之后不删除动画
    animation.removedOnCompletion = NO;
    //设置保存动画的最新状态
    animation.fillMode = kCAFillModeForwards;
    //NSString *str = NSStringFromCGPoint(d.layer.position);
    [d.layer addAnimation:animation forKey:@"position"];
    
    
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation2.duration = 1; // 动画持续时间
    animation2.repeatCount = 1; // 重复次数
    //animation2.autoreverses = YES; // 动画结束时执行逆动画
    animation2.removedOnCompletion = NO;
    // 缩放倍数
    animation2.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation2.toValue = [NSNumber numberWithFloat:0.3]; // 结束时的倍率
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = 1.0;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = [NSArray arrayWithObjects:scaleAnimation,animation, animation2, nil];
    [d.layer addAnimation:group forKey:@"move-scale-layer"];

}
#pragma mark CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    [_iGiftAnimationView removeFromSuperview];
    _iGiftAnimationView = nil;
    [_iSendGiftButton setTitle:[NSString stringWithFormat:@"%@",@(_iGiftCount)] forState:UIControlStateNormal];

}

#pragma mark 横竖屏
-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}
#pragma mark 状态栏
//设置样式  没效果
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
#pragma mark 其他
- (void)showMessage:(NSString *)message {
    NSArray *array = [UIApplication sharedApplication].windows;
    int count = (int)array.count;
    [TKRCGlobalConfig HUDShowMessage:message addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:2];
}





#pragma mark Wdeprecated


/*
-(void)initReConnection{
    
    _iNoNetView  = ({
        __weak typeof(self) weekSelf = self;
        
        TKNONetWorkView *tTiew = [[TKNONetWorkView alloc]initWithFrame:self.view.frame withReconctionBlock:^(UIButton *aReconnectionBlockButton) {
            
            __strong typeof(weekSelf)strongSelf = weekSelf;
            TKLog(@"buttonClicked:----%@",strongSelf);
            aReconnectionBlockButton.enabled = NO;
            [strongSelf reconnectMeeting];
            
            
        }];
        
        tTiew;
        
    });
    _iNoNetView.hidden = YES;
    
    [_iScroll addSubview:_iNoNetView];
    
    __weak typeof(self)weekSelf = self;
    _iAFNetworkReachablitityManager = [TKAFNetworkReachabilityManager sharedManager];
    _iNetStatus = YES;
    // 2.设置网络状态改变后的处理
    [_iAFNetworkReachablitityManager setReachabilityStatusChangeBlock:^(TKAFNetworkReachabilityStatus status) {
        __strong typeof(self)strongSelf = weekSelf;
        
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case TKAFNetworkReachabilityStatusUnknown: // 未知网络
            case TKAFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                TKLog(@"没有网络(断网)");
                _iNetStatusTimer = [[TKTimer alloc]initWithTimeout:10 repeat:NO completion:^{
                    _iNetStatus = NO;
                    
                    if (strongSelf.iTKEduClassRoomSessionHandle) {
                        //[self reconnectMeeting];
                    }else{
                        TKLog(@"没有网络-------------------没有调用");
                    }
                    
                    
                } queue:dispatch_get_main_queue()];
                [strongSelf.iNetStatusTimer start];
                break;
            }
                
            case TKAFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            case TKAFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                
                if (strongSelf.iNetStatusTimer) {
                    [strongSelf.iNetStatusTimer invalidate];
                }else{
                    TKLog(@"有网络-------------------没有调用");
                }
                TKLog(@"手机自带网络或者Wifi");
                break;
            }
                
        }
    }];
    [_iAFNetworkReachablitityManager startMonitoring];
}
-(void)hideNoNetView{
    _iNoNetView.hidden = YES;
    _iNoNetView.aReconnectionButton.enabled = YES;
}
-(void)showNoNetView{
    [self.view bringSubviewToFront:_iNoNetView];
    [self.view bringSubviewToFront:_titleView];
    _iNoNetView.hidden = NO;
    _iNoNetView.aReconnectionButton.enabled = YES;
}
*/

-(void)setClassTime:(UIButton*)aButton{
    NSString * H = @"0";
    NSString * M = @"0";
    NSString * S = @"0";
    long temps = _iLocalTime;
    //long temps = 1;
    long tempm = temps / 60;
    long temph = tempm / 60;
    long sec = temps - tempm * 60;
    tempm = tempm - temph * 60;
    H = temph == 0 ? @"00" : temph >= 10 ? [NSString stringWithFormat:@"%@",@(temph)] : [NSString stringWithFormat:@"0%@",@(temph)];
    M = tempm == 0 ? @"00" : tempm >= 10 ? [NSString stringWithFormat:@"%@",@(tempm)] : [NSString stringWithFormat:@"0%@",@(tempm)];
    S = sec == 0 ? @"00" : sec >= 10 ? [NSString stringWithFormat:@"%@",@(sec)] : [NSString stringWithFormat:@"0%@",@(sec)];
    
    [aButton setTitle:[NSString stringWithFormat:@"%@:%@:%@",H,M,S] forState:UIControlStateNormal];
    
}

-(void)resetTimerForKeyboardHide{
    
    [self reSetTitleView:YES aInputContainerIsHide:YES aStatusIsHide:YES];
}
- (void)resetTimerForKeyboardShow {
    [_iNavHideControltimer setFireDate:[NSDate distantFuture]];
    [self reSetTitleView:YES aInputContainerIsHide:NO aStatusIsHide:YES];
    
}
@end

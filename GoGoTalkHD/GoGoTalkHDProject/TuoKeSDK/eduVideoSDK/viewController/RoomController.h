//
//  RoomController.h
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

//reconnection
#import "TKTimer.h"
#import "TKProgressHUD.h"
#import "TKRCGlobalConfig.h"

#import "TKUtil.h"
#import "TKEduSessionHandle.h"
#import "TKVideoSmallView.h"
#import "TKSplitScreenView.h"

#import "UIControl+clickedOnce.h"


#import "TKMessageTableViewCell.h"
#import "TKTeacherMessageTableViewCell.h"
#import "TKStudentMessageTableViewCell.h"

#import "TKEduRoomProperty.h"

#import "TKChatMessageModel.h"

//getGifNum
#import "TKEduNetManager.h"
#import "TKClassTimeView.h"


#import "TKBaseMediaView.h"

@class TKEduRoomProperty;


#pragma mark nav
static const CGFloat sDocumentButtonWidth = 55;
static const CGFloat sRightWidth          = 236;
static const CGFloat sClassTimeViewHeigh  = 57.5;
static const CGFloat sViewCap             = 10;
static const CGFloat sBottomViewHeigh     = 144;
static const CGFloat sTeacherVideoViewHeigh     = 182;

static const CGFloat sStudentVideoViewHeigh     = 112;
static const CGFloat sStudentVideoViewWidth     = 120;
static const CGFloat sRightViewChatBarHeight    = 50;
static const CGFloat sSendButtonWidth           = 64;

static NSString *const sMessageCellIdentifier           = @"messageCellIdentifier";
static NSString *const sStudentCellIdentifier           = @"studentCellIdentifier";
static NSString *const sDefaultCellIdentifier           = @"defaultCellIdentifier";

@interface RoomController : UIViewController

@property (nonatomic, assign) BOOL isConnect;
//视频的宽高属性
@property (nonatomic, assign) CGFloat maxVideo;
@property (nonatomic, assign) CGFloat VideoSmallViewLittleWidth;
@property (nonatomic, assign) CGFloat VideoSmallViewLittleHeigh;
@property (nonatomic, assign) CGFloat VideoSmallViewBigHeigh;
@property (nonatomic, strong) NSTimer *iClassCurrentTimer;
@property (nonatomic, strong) NSTimer *iClassTimetimer;
@property (nonatomic, assign) BOOL iIsCanRaiseHandUp;//是否可以举手
//移动
@property(nonatomic,assign)CGPoint iCrtVideoViewC;
@property(nonatomic,assign)CGPoint iStrtCrtVideoViewP;

@property(nonatomic,retain)UIScrollView *iScroll;

@property (nonatomic, strong) UIView *iTKEduWhiteBoardView;//白板视图

@property (nonatomic, assign) RoomType iRoomType;//当前会议室
@property (nonatomic, assign) UserType iUserType;//当前身份


@property (nonatomic, assign) NSDictionary* iParamDic;//加入会议paraDic
//导航
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) TKClassTimeView *iClassTimeView;

//测试
@property (nonatomic, strong) UILabel *cpuLabel;
@property (nonatomic, strong) UILabel *memoryLabel;

@property(nonatomic,retain)UIView   *iMidView;
@property(nonatomic,retain)UIView   *iRightView;//左视图
@property(nonatomic,retain)UIView   *iBottomView;//视频视图

//共享桌面
@property (nonatomic, strong) TKBaseMediaView *iScreenView;
//共享电影
@property (nonatomic, strong) TKBaseMediaView *iFileView;

@property (nonatomic, strong) UIButton *iUserButton;

@property (nonatomic, strong) TKEduSessionHandle *iSessionHandle;
@property (nonatomic, strong) TKEduRoomProperty *iRoomProperty;//课堂数进行
@property (nonatomic, strong) NSMutableDictionary    *iPlayVideoViewDic;//播放的视频view的字典

//视频相关
@property (nonatomic, strong) TKVideoSmallView *iTeacherVideoView;//老师视频
@property (nonatomic, strong) TKVideoSmallView *iOurVideoView;//自己的视频
@property (nonatomic, strong) NSMutableArray  *iStudentVideoViewArray;//存放学生视频数组
@property (nonatomic, strong) TKSplitScreenView *splitScreenView;//分屏视图
@property (nonatomic, strong) NSMutableArray  *iStudentSplitViewArray;//存放学生视频数组
@property (nonatomic, strong) NSMutableArray  *iStudentSplitScreenArray;//存放学生分屏视频数组
@property (nonatomic, strong) NSDictionary    *iScaleVideoDict;//记录缩放的视频
@property (nonatomic, assign) BOOL            addVideoBoard;
@property (nonatomic, assign) BOOL            isLocalPublish;

@property(nonatomic,retain)UIView   *iMuteAudioAndRewardView;
@property(nonatomic,retain)UIButton *iMuteAudioButton;//全体静音
@property(nonatomic,retain)UIButton *iunMuteAllButton;//全体发言
@property(nonatomic,retain)UIButton *iRewardButton;//全体奖励
@property(nonatomic,retain)UIView   *iClassBeginAndOpenAlumdView;
@property(nonatomic,retain)UIButton *iOpenAlumButton;
@property(nonatomic,retain)UIButton *iClassBeginAndRaiseHandButton;//上课/下课按钮
@property(nonatomic,retain)UIView *iDocumentListView;//文档视图
@property(nonatomic,retain)UIView *iMediaListView;


//聊天
@property (nonatomic, strong) UITableView *iChatTableView; // 聊天tableView
@property (nonatomic,assign) CGRect inputContainerFrame;

//拖动进来时的状态
@property (nonatomic, strong) NSMutableDictionary    *iMvVideoDic;
//媒体流
@property (nonatomic, strong) TKBaseMediaView  *iMediaView;
@property (nonatomic, strong) TKTimer   *iCheckPlayVideotimer;

@property (nonatomic, strong) UIImagePickerController * iPickerController;

@property (nonatomic, copy) NSString *currentServer;

@property (nonatomic, assign) BOOL isQuiting;

// 发生断线重连设置为YES，恢复后设置为NO
@property (nonatomic, assign) BOOL networkRecovered;


/**
 初始化课堂

 @param aRoomDelegate 进入房间回调
 @param aParamDic 进入课堂所需参数
 @param aRoomName roomName
 @param aRoomProperty 课堂参数
 @return self
 */
- (instancetype)initWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                       aParamDic:(NSDictionary *)aParamDic
                       aRoomName:(NSString *)aRoomName
                   aRoomProperty:(TKEduRoomProperty *)aRoomProperty;

/**
 初始化回放课堂
 
 @param aRoomDelegate 进入房间回调
 @param aParamDic 进入课堂所需参数
 @param aRoomName roomName
 @param aRoomProperty 课堂参数
 @return self
 */
- (instancetype)initPlaybackWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                               aParamDic:(NSDictionary *)aParamDic
                               aRoomName:(NSString *)aRoomName
                           aRoomProperty:(TKEduRoomProperty *)aRoomProperty;

-(void)prepareForLeave:(BOOL)aQuityourself;

/**
 初始化左视图
 */
-(void)initRightView;

/**
 初始化底部视图
 */
-(void)initBottomView;

/**
 初始化白板视图
 */
-(void)initWhiteBoardView;

/**
 初始化分屏视图
 */
-(void)initSplitScreenView;

/**
 开始分屏
 */
- (void)beginTKSplitScreenView:(TKVideoSmallView*)videoView;

/**
 更新视图的位置

 @param aPeerId 用户id
 */
-(void)updateMvVideoForPeerID:(NSString *)aPeerId;

/**
 发送视频位置

 @param aPlayVideoViewDic 视图位置存储
 @param aSuperFrame 上层视图
 */
-(void)sendMoveVideo:(NSDictionary *)aPlayVideoViewDic aSuperFrame:(CGRect)aSuperFrame allowStudentSendDrag:(BOOL)isSendDrag;

-(void)moveVideo:(NSDictionary *)aMvVideoDic;


/**
 全体静音

 @param aButton 点击按钮
 */
-(void)muteAduoButtonClicked:(UIButton *)aButton;

/**
 全体发言

 @param aButton 点击按钮
 */
-(void)unMuteAllButtonClicked:(UIButton *)aButton;
/**
 全员奖励

 @param aButton 点击按钮
 */
-(void)rewardButtonClicked:(UIButton *)aButton;

/**
 上传图片

 @param sender 点击按钮
 */
-(void)openAlbum:(UIButton*)sender;

/**
 开始上课允许举手

 @param aButton 点击按钮
 */
-(void)classBeginAndRaiseHandButtonClicked:(UIButton *)aButton;

/**
 点击上课

 @param gesture 手势
 */
//- (void)handsupPressHold:(UIGestureRecognizer *)gesture;
//- (void)handsupPressHold:(id)sender forEvent:(UIEvent *)event;
- (void)handTouchDown;
- (void)handTouchUp;
- (void)loadChatView:(CGFloat)tViewCap;

/**
 拖动视频

 @param longGes 手势
 */
- (void)longPressClick:(UIGestureRecognizer *)longGes;

/**
 分屏

 @param array 分屏数组
 */
- (void)sVideoSplitScreen:(NSMutableArray *)array;

/**
 刷新视频视图
 */
-(void)refreshBottom;

/**
 刷新白板
 
 @param hasAnimate true false
 */
-(void)refreshWhiteBoard:(BOOL)hasAnimate;

/**
 刷新页面
 */
-(void)refreshUI;

/**
 刷新聊天和nav视图

 @param tViewCap 距离
 */
- (void)refreshChatAndNavUI:(CGFloat)tViewCap;

/**
 播放

 @param user 用户
 */
-(void)playVideo:(TKRoomUser *)user;
-(void)myPlayVideo:(TKRoomUser *)aRoomUser aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion;
/**
 停止播放

 @param peerID 用户
 */
-(void)unPlayVideo:(NSString *)peerID;
-(void)myUnPlayVideo:(NSString *)peerID aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion;


/**
 更改全体静音，全体发言的状态
 */
-(void)checkPlayVideo;


/**
 根据用户id返回用户视频窗口

 @param peerId 用户id
 @return 返回的视频窗口
 */
- (TKVideoSmallView *)videoViewForPeerId:(NSString *)peerId;

/**
 断网重连

 @param error error
 */
- (void)sessionManagerDidFailWithError:(NSError *)error;

- (void)clearVideoViewData:(TKVideoSmallView *)videoView;

/**
 自己进入课堂

 @param error error
 */
- (void)sessionManagerRoomJoined;

/**
 获取礼物数
 */
- (void)getTrophyNumber;
- (void)refreshData;
- (void)startClassReadyTimer;

/**
 观看视频

 @param user 用户
 */
- (void)sessionManagerUserPublished:(TKRoomUser *)user;

/**
 退出清楚数据
 */
- (void)quitClearData;

/**
 视频缩放

 @param peerIdToScaleDic 缩放内容
 */
- (void)sScaleVideo:(NSDictionary *)peerIdToScaleDic;

/**
 全屏通知

 @param aNotification 通知
 */
-(void)fullScreenToLc:(NSNotification*)aNotification;

- (void)showMessage:(NSString *)message;
@end

//
//  ClassRoomController.m
//  EduClassPad
//
//  Created by lyy on 2017/12/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "ClassRoomController.h"
@interface ClassRoomController ()
{
    CGFloat _sBottomViewHeigh;
    CGFloat _sStudentVideoViewHeigh;
    CGFloat _sStudentVideoViewWidth;
}
@end

@implementation ClassRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)initRightView{
    
    //重新计算sBottomViewHeigh高度
   
    if (self.iRoomProperty.iMaxVideo.intValue > 7) {
        self.maxVideo = 13;
    }else{
        self.maxVideo = 7;
    }
    
    _sStudentVideoViewWidth =(ScreenW-sViewCap*(self.maxVideo+1))/self.maxVideo;
    _sStudentVideoViewHeigh =_sStudentVideoViewWidth/4.0*3.0+_sStudentVideoViewWidth/4*3/7;
    _sBottomViewHeigh = _sStudentVideoViewHeigh+2*sViewCap;
    {
        CGFloat tRightY = (self.iRoomType == RoomType_OneToOne)?CGRectGetMaxY(self.titleView.frame):CGRectGetMaxY(self.titleView.frame)+_sBottomViewHeigh;
        CGRect tRithtFrame = CGRectMake(ScreenW-sRightWidth*Proportion, tRightY, sRightWidth*Proportion, ScreenH-tRightY);
        
        self.iRightView = ({
            
            UIView *tRightView = [[UIView alloc] initWithFrame: tRithtFrame];
            tRightView.backgroundColor =  RGBCOLOR(62, 62, 62) ;
            tRightView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            tRightView;
            
        });
        self.iScroll.userInteractionEnabled = YES;
        
        [self.iScroll addSubview:self.iRightView];
        
    }
    CGFloat tViewCap = sViewCap*Proportion;
    
    CGFloat tViewWidth = (sRightWidth-2*sViewCap)*Proportion;
    //老师
    CGFloat tTeacherVideoViewWidth = (self.iRoomType == RoomType_OneToOne)?(sRightWidth-2*sViewCap)*Proportion:_sStudentVideoViewWidth;
    CGFloat tTeacherVideoViewHeight = (self.iRoomType == RoomType_OneToOne)?sTeacherVideoViewHeigh*Proportion:_sStudentVideoViewHeigh;
    {
        self.iTeacherVideoView= ({
            
            TKVideoSmallView *tTeacherVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tViewCap, tViewCap, tTeacherVideoViewWidth, tTeacherVideoViewHeight) aVideoRole:EVideoRoleTeacher];
            tTeacherVideoView.iPeerId = @"";
            tTeacherVideoView.isDrag = NO;
            tTeacherVideoView.isSplit = NO;
            tTeacherVideoView.iVideoViewTag = -1;
            tTeacherVideoView.isNeedFunctionButton = (self.iUserType==UserType_Teacher);
            tTeacherVideoView.iEduClassRoomSessionHandle = self.iSessionHandle;
            tTeacherVideoView;
            
            
        });
        
        __weak typeof(self) weakSelf = self;
        
        self.iTeacherVideoView.isWhiteboardContainsSelfBlock = ^BOOL{
            return CGRectContainsRect(weakSelf.iTKEduWhiteBoardView.frame, weakSelf.iTeacherVideoView.frame);
        };
        // 接收到调整大小的信令
        self.iTeacherVideoView.onRemoteMsgResizeVideoViewBlock = ^CGRect(CGFloat scale) {
            
            CGRect wbRect = weakSelf.iTKEduWhiteBoardView.frame;
            CGRect videoRect = weakSelf.iTeacherVideoView.frame;
            CGFloat height = weakSelf.iTeacherVideoView.originalHeight * scale;
            CGFloat width = weakSelf.iTeacherVideoView.originalWidth *scale;
            CGPoint oldCenter = weakSelf.iTeacherVideoView.center;
            
            
            // top 1, right 2, bottom 3, left 4
            NSInteger vcrossEdge = 0;
            NSInteger hcrossEdge = 0;
            if (videoRect.origin.x <= wbRect.origin.x) {
                // 垂直边左相交
                vcrossEdge = 4;
            }
            if (videoRect.origin.x + videoRect.size.width >= wbRect.origin.x + wbRect.size.width) {
                // 垂直边右相交
                vcrossEdge = 2;
            }
            if (videoRect.origin.y <= wbRect.origin.y) {
                // 水平便顶相交
                hcrossEdge = 1;
            }
            if (videoRect.origin.y + videoRect.size.height >= wbRect.origin.y + wbRect.size.height) {
                // 水平便底相交
                hcrossEdge = 3;
            }
            
            if (vcrossEdge == 0 && hcrossEdge == 0) {
                CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
            }
            
            if (vcrossEdge == 0 && hcrossEdge == 1) {
                CGFloat x = oldCenter.x - width / 2.0;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 0 && hcrossEdge == 3) {
                CGFloat x = oldCenter.x - width / 2.0;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 2 && hcrossEdge == 0) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = oldCenter.y - height / 2.0;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 4 && hcrossEdge == 0) {
                CGFloat x = wbRect.origin.x;
                CGFloat y = oldCenter.y - height / 2.0;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 4 && hcrossEdge == 1) {
                CGFloat x = wbRect.origin.x;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 4 && hcrossEdge == 3) {
                CGFloat x = wbRect.origin.x;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 2 && hcrossEdge == 1) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 2 && hcrossEdge == 3) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            return CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
        };
        
        // 当缩放的视频窗口超出白板区域，调整视频窗口大小
        self.iTeacherVideoView.resizeVideoViewBlock = ^CGRect{
            CGRect wbRect = weakSelf.iTKEduWhiteBoardView.frame;
            CGRect videoRect = weakSelf.iTeacherVideoView.frame;
            CGFloat height = 0;
            CGFloat width = 0;
            
            // 如果横边和竖边都相交
            if ((videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width || videoRect.origin.x < wbRect.origin.x) &&
                (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height || videoRect.origin.y < wbRect.origin.y)) {
                width = (weakSelf.iTeacherVideoView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - weakSelf.iTeacherVideoView.center.x) ? (weakSelf.iTeacherVideoView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - weakSelf.iTeacherVideoView.center.x) * 2;
                height = (weakSelf.iTeacherVideoView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - weakSelf.iTeacherVideoView.center.y) ? (weakSelf.iTeacherVideoView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - weakSelf.iTeacherVideoView.center.y) * 2;
                if (width <= height * sStudentVideoViewWidth / sStudentVideoViewHeigh) {
                    height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                    return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
                }
                
                if (height <= width * sStudentVideoViewHeigh / sStudentVideoViewWidth) {
                    width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                    return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
                }
                
                return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
            }
            
            // 如果是竖边界相交
            if (videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width ||
                videoRect.origin.x < wbRect.origin.x) {
                width = (weakSelf.iTeacherVideoView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - weakSelf.iTeacherVideoView.center.x) ? (weakSelf.iTeacherVideoView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - weakSelf.iTeacherVideoView.center.x) * 2;
                height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
            }
            
            // 如果是横边相交
            if (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height ||
                videoRect.origin.y < wbRect.origin.y) {
                height = (weakSelf.iTeacherVideoView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - weakSelf.iTeacherVideoView.center.y) ? (weakSelf.iTeacherVideoView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - weakSelf.iTeacherVideoView.center.y) * 2;
                width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
            }
            
            return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
        };
        
        self.iTeacherVideoView.finishScaleBlock = ^{
            //缩放之后发布一下位移
            if (weakSelf.iUserType == UserType_Teacher) {
                [weakSelf sendMoveVideo:weakSelf.iPlayVideoViewDic aSuperFrame:weakSelf.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
            }
            
        };
        self.iTeacherVideoView.splitScreenClickBlock = ^(EVideoRole aVideoRole) {
            //学生分屏开始
            [weakSelf beginTKSplitScreenView:weakSelf.iTeacherVideoView];
            
            NSArray *videoArray = [NSArray arrayWithArray:weakSelf.iStudentVideoViewArray];
            NSArray *array = [NSArray arrayWithArray:weakSelf.iStudentSplitScreenArray];
            for (TKVideoSmallView *view in videoArray) {
                BOOL isbool = [weakSelf.iStudentSplitScreenArray containsObject: view.iRoomUser.peerID];
                if (view.isDrag && !view.isSplit && !isbool && array.count>0) {
                    [weakSelf.iStudentSplitScreenArray addObject:view.iRoomUser.peerID];
                    [weakSelf beginTKSplitScreenView:view];
                }
            }
        };
        self.iTeacherVideoView.oneKeyResetBlock = ^{//全部恢复
            
            [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAllExpectSender Data:@{} completion:nil];
            
            NSArray *sArray = [NSArray arrayWithArray:weakSelf.iStudentSplitViewArray];
            for (TKVideoSmallView *view in sArray) {
                
                view.isSplit = YES;
                [weakSelf beginTKSplitScreenView:view];
                
                
            }
            
            //将拖拽的视频还原
            for (TKVideoSmallView *view  in weakSelf.iStudentVideoViewArray) {
                
                [weakSelf updateMvVideoForPeerID:view.iPeerId];
                view.isDrag = NO;
            }
            
            [weakSelf sendMoveVideo:weakSelf.iPlayVideoViewDic aSuperFrame:weakSelf.iTKEduWhiteBoardView.frame allowStudentSendDrag:NO];
            
            [weakSelf refreshBottom];
        };
        
        if (self.iRoomType == RoomType_OneToOne) {
            [self.iRightView addSubview:self.iTeacherVideoView];
        }else{
            // 添加长按手势
            UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
            [self.iTeacherVideoView addGestureRecognizer:longGes];
            
        }
        
    }
    //我
    {
        CGFloat tOurVideoViewHeight = (self.iRoomType == RoomType_OneToOne)?sTeacherVideoViewHeigh*Proportion:0;
        CGFloat tOurVideoViewY = (self.iRoomType == RoomType_OneToOne)?CGRectGetMaxY(self.iTeacherVideoView.frame)+tViewCap:tViewCap;
        self.iOurVideoView= ({
            
            TKVideoSmallView *tOurVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tViewCap,tOurVideoViewY, tViewWidth, tOurVideoViewHeight) aVideoRole:EVideoRoleOur];
            tOurVideoView.iPeerId = @"";
            tOurVideoView.iEduClassRoomSessionHandle = self.iSessionHandle;
            tOurVideoView.iVideoViewTag = -2;
            tOurVideoView.isNeedFunctionButton = (self.iUserType==UserType_Teacher);
            tOurVideoView;
            
        });
        [self.iRightView addSubview:self.iOurVideoView];
        self.iOurVideoView.hidden = !tOurVideoViewHeight;
    }
    
    //静音与奖励
    {
        //不是老师，或没上课，隐藏 有1为1
        BOOL tIsHide = (self.iUserType != UserType_Teacher) || (![TKEduSessionHandle shareInstance].isClassBegin)|| (self.iRoomType==RoomType_OneToOne);
        CGFloat tMuteAudioAndRewardViewHeight = !tIsHide?(40*Proportion):0;
        
        self.iMuteAudioAndRewardView = ({
            
            UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(tViewCap, CGRectGetMaxY(self.iOurVideoView.frame), tViewWidth, tMuteAudioAndRewardViewHeight)];
//            tView.backgroundColor = [UIColor yellowColor];
            tView;
            
            
        });
        self.iMuteAudioAndRewardView.hidden = tIsHide;
        
        //全体静音
        self.iMuteAudioButton = ({
            UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(tViewCap, 0, tViewWidth / 2 - 5, (40*Proportion))];
            tButton.titleLabel.font = TKFont(13);
            [tButton addTarget:self action:@selector(muteAduoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.iUserType == UserType_Student) {
                [tButton setTitle:MTLocalized(@"Button.CloseAudio") forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.OpenAudio") forState:UIControlStateSelected];
//                tButton.backgroundColor = RGBACOLOR_ClassBegin_RedDeep;
                tButton.backgroundColor = UIColorRGB(0xecbec0);
            } else {
                [tButton setTitle:MTLocalized(@"Button.MuteAudio") forState:UIControlStateNormal];
//                tButton.backgroundColor = RGBACOLOR_ClassBegin_RedDeep;
                tButton.backgroundColor = UIColorRGB(0xecbec0);
            }
            
            [TKUtil setCornerForView:tButton];
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton;
            
        });
        
        [self.iMuteAudioAndRewardView addSubview:self.iMuteAudioButton];
        
        //全体发言
        self.iunMuteAllButton = ({
            UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.iMuteAudioButton.frame)+tViewCap, 0, tViewWidth / 2 - 5, (40*Proportion))];
            tButton.titleLabel.font = TKFont(13);
            
            // [tButton button_exchangeImplementations];
            
            [tButton addTarget:self action:@selector(unMuteAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (self.iUserType == UserType_Student) {
                [tButton setTitle:MTLocalized(@"Button.CloseVideo") forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.OpenVideo") forState:UIControlStateSelected];
            } else {
                tButton.itk_acceptEventInterval = 2;
                [tButton setTitle:MTLocalized(@"Button.MuteAll") forState:UIControlStateNormal];
            }
            
            [TKUtil setCornerForView:tButton];
            tButton.backgroundColor = UIColorRGBA(0x94c4e8, 1);
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton;
        });
        [self.iMuteAudioAndRewardView addSubview:self.iunMuteAllButton];
        [self.iRightView addSubview:self.iMuteAudioAndRewardView];
        
        //全员奖励
        self.iRewardButton = ({
            
            UIButton *tButton = [[UIButton alloc]initWithFrame: CGRectMake(tViewCap, CGRectGetMaxY(self.iMuteAudioAndRewardView.frame)+tViewCap, tViewWidth, (40*Proportion))];
            tButton.titleLabel.font = TKFont(13);
            
            [tButton addTarget:self action:@selector(rewardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.iUserType == UserType_Student) {
                [tButton setTitle:MTLocalized(@"Button.CloseVideo") forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.OpenVideo") forState:UIControlStateSelected];
            } else {
                tButton.itk_acceptEventInterval = 2;
                [tButton setTitle:MTLocalized(@"Button.Reward") forState:UIControlStateNormal];
            }
            
            [TKUtil setCornerForView:tButton];
            tButton.backgroundColor = RGBACOLOR_RewardColor;
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton;
            
        });
        self.iRewardButton.hidden = tIsHide;
        [self.iRightView addSubview:self.iRewardButton];
//        [self.iRightView addSubview:self.iMuteAudioAndRewardView];
    }
    //举手按钮
    {
        
        CGFloat tClassBeginAndRaiseHeight =  40*Proportion;
        self.iClassBeginAndOpenAlumdView = ({
            
            UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(tViewCap, CGRectGetMaxY(self.iMuteAudioAndRewardView.frame)+tViewCap+40*Proportion, tViewWidth, tClassBeginAndRaiseHeight)];
            tView.backgroundColor = [UIColor clearColor];
            tView;
            
        });
        
        bool tIsTeacherOrAssis  = (self.iUserType ==UserType_Teacher || self.iUserType ==UserType_Assistant || self.iUserType == UserType_Patrol);
        
        BOOL tIsStdAndRoomOne = (self.iUserType == UserType_Student && self.iRoomType == RoomType_OneToOne);
        
        
        CGFloat tOpenAlumWidth = tIsStdAndRoomOne ?tViewWidth:(tViewWidth / 2 - 5) ;
        tOpenAlumWidth = tIsTeacherOrAssis ?tViewWidth:tOpenAlumWidth;
        CGRect tLeftFrame = CGRectMake(0, 0, tOpenAlumWidth, (40*Proportion));
        CGRect tRightFrame = CGRectMake(tOpenAlumWidth+tViewCap*1, 0, tOpenAlumWidth, (40*Proportion));
        
        
        self.iOpenAlumButton = ({
            
            UIButton *tButton = [[UIButton alloc]initWithFrame:tLeftFrame];
            [tButton addTarget:self action:@selector(openAlbum:) forControlEvents:UIControlEventTouchUpInside];
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(15);
            
            [tButton setBackgroundColor:RGBACOLOR_ClassEnd_Red];
            [tButton setTitle:MTLocalized(@"Button.UploadPhoto") forState:UIControlStateNormal];
            tButton.enabled = NO;
            tButton.hidden = tIsTeacherOrAssis;
            [TKUtil setCornerForView:tButton];
            tButton;
            
        });
        
        //上课、下课
        self.iClassBeginAndRaiseHandButton = ({
            
            UIButton *tButton = [[UIButton alloc]initWithFrame:tRightFrame];
            [tButton addTarget:self action:@selector(classBeginAndRaiseHandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(15);
            
            [tButton setBackgroundColor:RGBACOLOR_ClassBeginAndEnd];
            if (self.iUserType == UserType_Student) {
                tButton.enabled = NO;
                [tButton setBackgroundColor:RGBACOLOR_ClassBeginAndEnd];
                [tButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
                
            }else if(self.iUserType == UserType_Teacher){
                [tButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
            }else if (self.iUserType == UserType_Patrol){
                [tButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
                [tButton setBackgroundColor:RGBACOLOR_ClassBeginAndEnd];
                tButton.enabled = NO;
            }
            [TKUtil setCornerForView:tButton];
            tButton;
            
            
        });
        [self.iClassBeginAndOpenAlumdView addSubview:self.iClassBeginAndRaiseHandButton];
        [self.iClassBeginAndOpenAlumdView addSubview:self.iOpenAlumButton];
        [self.iRightView addSubview:self.iClassBeginAndOpenAlumdView];
        
        // 举手按钮添加长按手势
//        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handsupPressHold:)];
//        [self.iClassBeginAndRaiseHandButton addGestureRecognizer:longPressGR];
//         [self.iClassBeginAndRaiseHandButton addTarget:self action:@selector(handsupPressHold:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        
        //处理按钮点击事件
        [self.iClassBeginAndRaiseHandButton addTarget:self action:@selector(handTouchDown)forControlEvents: UIControlEventTouchDown];
        //处理按钮松开状态
        [self.iClassBeginAndRaiseHandButton addTarget:self action:@selector(handTouchUp)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    
    [self loadChatView:tViewCap];

    
}
/**
 重写bottom布局
 */
- (void)initBottomView{
    self.iBottomView = ({
        
        UIView *tBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), ScreenW, _sBottomViewHeigh)];
        tBottomView;
        
    });
    self.iBottomView.backgroundColor = RGBCOLOR(48, 48, 48);
    
    [self.iScroll addSubview:self.iBottomView];
    
    CGFloat tWidth = _sStudentVideoViewWidth;
    CGFloat tHeight = _sStudentVideoViewHeigh;
    CGFloat tCap = sViewCap *Proportion;
    CGFloat w = ((ScreenW-7*sViewCap)/ 7);
    [self.iStudentVideoViewArray addObject:self.iTeacherVideoView];//先插入老师的视图
    self.iTeacherVideoView.originalWidth = w;
    self.iTeacherVideoView.originalHeight = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
    
    for (NSInteger i = 0; i < self.iRoomProperty.iMaxVideo.intValue-1; ++i) {
        TKVideoSmallView *tOurVideoBottomView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tCap*2 + tWidth,tCap + CGRectGetMinY(self.iBottomView.frame), tWidth, tHeight) aVideoRole:EVideoRoleOther];
        tOurVideoBottomView.originalWidth = w;
        tOurVideoBottomView.originalHeight = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
        tOurVideoBottomView.iPeerId         = @"";
        tOurVideoBottomView.iVideoViewTag   = i;
        tOurVideoBottomView.isDrag          = NO;
        tOurVideoBottomView.isSplit         = NO;
        tOurVideoBottomView.isNeedFunctionButton = (self.iUserType==UserType_Teacher);
        tOurVideoBottomView.iEduClassRoomSessionHandle = self.iSessionHandle;
        tOurVideoBottomView.hidden = NO;
        tOurVideoBottomView.iNameLabel.text = [NSString stringWithFormat:@"%@",@(i)];
        
        // 判断当前视频窗口是否与白板相交
        __weak typeof(TKVideoSmallView *) wtOurVideoBottomView = tOurVideoBottomView;
        tOurVideoBottomView.isWhiteboardContainsSelfBlock = ^BOOL{
            return CGRectContainsRect(self.iTKEduWhiteBoardView.frame, wtOurVideoBottomView.frame);
        };
        
        // 接收到调整大小的信令
        tOurVideoBottomView.onRemoteMsgResizeVideoViewBlock = ^CGRect(CGFloat scale) {
            CGRect wbRect = self.iTKEduWhiteBoardView.frame;
            CGRect videoRect = wtOurVideoBottomView.frame;
            CGFloat height = wtOurVideoBottomView.originalHeight * scale;
            CGFloat width = wtOurVideoBottomView.originalWidth *scale;
            CGPoint oldCenter = wtOurVideoBottomView.center;
            
            
            // top 1, right 2, bottom 3, left 4
            NSInteger vcrossEdge = 0;
            NSInteger hcrossEdge = 0;
            if (videoRect.origin.x <= wbRect.origin.x) {
                // 垂直边左相交
                vcrossEdge = 4;
            }
            if (videoRect.origin.x + videoRect.size.width >= wbRect.origin.x + wbRect.size.width) {
                // 垂直边右相交
                vcrossEdge = 2;
            }
            if (videoRect.origin.y <= wbRect.origin.y) {
                // 水平便顶相交
                hcrossEdge = 1;
            }
            if (videoRect.origin.y + videoRect.size.height >= wbRect.origin.y + wbRect.size.height) {
                // 水平便底相交
                hcrossEdge = 3;
            }
            
            if (vcrossEdge == 0 && hcrossEdge == 0) {
                CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
            }
            
            if (vcrossEdge == 0 && hcrossEdge == 1) {
                CGFloat x = oldCenter.x - width / 2.0;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 0 && hcrossEdge == 3) {
                CGFloat x = oldCenter.x - width / 2.0;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 2 && hcrossEdge == 0) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = oldCenter.y - height / 2.0;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 4 && hcrossEdge == 0) {
                CGFloat x = wbRect.origin.x;
                CGFloat y = oldCenter.y - height / 2.0;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 4 && hcrossEdge == 1) {
                CGFloat x = wbRect.origin.x;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 4 && hcrossEdge == 3) {
                CGFloat x = wbRect.origin.x;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 2 && hcrossEdge == 1) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 2 && hcrossEdge == 3) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            return CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
        };
        
        // 当缩放的视频窗口超出白板区域，调整视频窗口大小
        tOurVideoBottomView.resizeVideoViewBlock = ^CGRect{
            CGRect wbRect = self.iTKEduWhiteBoardView.frame;
            CGRect videoRect = wtOurVideoBottomView.frame;
            CGFloat height = 0;
            CGFloat width = 0;
            
            // 如果横边和竖边都相交
            if ((videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width || videoRect.origin.x < wbRect.origin.x) &&
                (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height || videoRect.origin.y < wbRect.origin.y)) {
                width = (wtOurVideoBottomView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) ? (wtOurVideoBottomView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) * 2;
                height = (wtOurVideoBottomView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) ? (wtOurVideoBottomView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) * 2;
                if (width <= height * sStudentVideoViewWidth / sStudentVideoViewHeigh) {
                    height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                    return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
                }
                
                if (height <= width * sStudentVideoViewHeigh / sStudentVideoViewWidth) {
                    width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                    return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
                }
                
                return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
            }
            
            // 如果是竖边界相交
            if (videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width ||
                videoRect.origin.x < wbRect.origin.x) {
                width = (wtOurVideoBottomView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) ? (wtOurVideoBottomView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) * 2;
                height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
            }
            
            // 如果是横边相交
            if (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height ||
                videoRect.origin.y < wbRect.origin.y) {
                height = (wtOurVideoBottomView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) ? (wtOurVideoBottomView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) * 2;
                width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
            }
            
            return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
        };
        
        __weak typeof(self) weakSelf = self;
        tOurVideoBottomView.finishScaleBlock = ^{
            //缩放之后发布一下位移
            if (weakSelf.iUserType == UserType_Teacher) {
                [weakSelf sendMoveVideo:weakSelf.iPlayVideoViewDic aSuperFrame:weakSelf.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
            }
            
        };
        //分屏按钮回调
        tOurVideoBottomView.splitScreenClickBlock = ^(EVideoRole aVideoRole) {
            //学生分屏开始
            [weakSelf beginTKSplitScreenView:wtOurVideoBottomView];
            
            NSArray *videoArray = [NSArray arrayWithArray:weakSelf.iStudentVideoViewArray];
            NSArray *array = [NSArray arrayWithArray:weakSelf.iStudentSplitScreenArray];
            for (TKVideoSmallView *view in videoArray) {
                BOOL isbool = [self.iStudentSplitScreenArray containsObject: view.iRoomUser.peerID];
                if (view.isDrag && !view.isSplit && !isbool && array.count>0) {
                    [self.iStudentSplitScreenArray addObject:view.iRoomUser.peerID];
                    [self beginTKSplitScreenView:view];
                }
            }
        };
        // 添加长按手势
        UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
        [tOurVideoBottomView addGestureRecognizer:longGes];
        [self.iStudentVideoViewArray addObject:tOurVideoBottomView];
        
        
    }    
}

-(void)refreshWhiteBoard:(BOOL)hasAnimate{
   
    CGFloat tWidth =  ScreenW-sRightWidth*Proportion;
    CGFloat tHeight = ScreenH - CGRectGetMaxY(self.titleView.frame);
    CGRect tFrame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), tWidth, tHeight);
    [self.iScroll bringSubviewToFront:self.iTKEduWhiteBoardView];
    
    // 去掉了判断1对1
    self.iBottomView.hidden = (self.iRoomType == RoomType_OneToOne)?YES:NO;
    if (self.iRoomType != RoomType_OneToOne) {
       
        tFrame = CGRectMake(0, CGRectGetMaxY(self.iBottomView.frame), tWidth,ScreenH-CGRectGetMaxY(self.iBottomView.frame));
    }
    
    if (hasAnimate) {
        [UIView animateWithDuration:0.1 animations:^{
            self.iTKEduWhiteBoardView.frame = tFrame;
            self.splitScreenView.frame = CGRectMake(0, 0, CGRectGetWidth(tFrame), CGRectGetHeight(tFrame));
            // MP3图标位置变化,但是MP4的位置不需要变化
            if (!self.iMediaView.hasVideo) {
                self.iMediaView.frame = CGRectMake(0, CGRectGetMaxY(self.iTKEduWhiteBoardView.frame)-57, CGRectGetWidth(self.iTKEduWhiteBoardView.frame), 57);
            }
            self.iMidView.frame =  CGRectMake(0, CGRectGetMaxY(self.iTKEduWhiteBoardView.frame), ScreenW-sRightWidth*Proportion,0);
            [[TKEduSessionHandle shareInstance].iBoardHandle refreshWebViewUI];
            [self refreshBottom];
            if (self.iMvVideoDic && self.iStudentSplitViewArray.count<=0) {
                [self moveVideo:self.iMvVideoDic];//视频位置会乱掉所以注释掉了
                
            }
            
        }];
    }else{
        
        self.iTKEduWhiteBoardView.frame = tFrame;
        self.splitScreenView.frame = CGRectMake(0, 0, CGRectGetWidth(tFrame), CGRectGetHeight(tFrame));
        self.iMidView.frame =  CGRectMake(0, CGRectGetMaxY(self.iTKEduWhiteBoardView.frame), ScreenW-sRightWidth*Proportion,0);
        [[TKEduSessionHandle shareInstance].iBoardHandle refreshWebViewUI];
        [self refreshBottom];
        if (self.iMvVideoDic) {
            
            [self moveVideo:self.iMvVideoDic];
            
        }
    }
}
-(void)refreshBottom{
    //记录正在播放的个数来固定位置
    int playingCount = 0;
    for (TKVideoSmallView *view in self.iStudentVideoViewArray) {
        if (view.iRoomUser && !view.isDrag) {
            playingCount = playingCount+1 ;
        }
    }
 
    CGFloat tRightY = (self.iRoomType == RoomType_OneToOne)?CGRectGetMaxY(self.titleView.frame):CGRectGetMaxY(self.titleView.frame)+_sBottomViewHeigh;
    CGRect tRithtFrame = CGRectMake(ScreenW-sRightWidth*Proportion, tRightY, sRightWidth*Proportion, ScreenH-tRightY);
    
    self.iRightView.frame = tRithtFrame;
    
    CGFloat tWidth  = _sStudentVideoViewWidth;
    CGFloat tHeight = _sStudentVideoViewHeigh;
    
    CGFloat tCap    = CGRectGetMinY(self.iBottomView.frame)+(CGRectGetHeight(self.iBottomView.frame)-tHeight)/2;
    CGFloat tleft = sViewCap *Proportion;
    CGFloat left    = tleft;
    BOOL tStdOutBottom = NO;
    
    //根据视频个数将视频平分在工具栏（始终居中平分）
    if((playingCount%2)==1)//奇数
    {
       left = ScreenW/2-tWidth/2-tleft*(playingCount/2)-tWidth*(playingCount/2);
    }
    else//偶数
    {
        left = ScreenW/2- tleft/2- tWidth*(playingCount/2)-tleft*(playingCount/2-1);
    }
    
    if(self.iStudentVideoViewArray.count !=0){
        TKVideoSmallView *iview = (TKVideoSmallView *)self.iStudentVideoViewArray[0];
        
        for (int i=0; i<self.iStudentVideoViewArray.count; i++) {
            TKVideoSmallView *view = (TKVideoSmallView *)self.iStudentVideoViewArray[i];
            if (view.iRoomUser && iview.iVideoViewTag !=-1) {
                [self.iStudentVideoViewArray exchangeObjectAtIndex:i withObjectAtIndex:0];
            }
        }
    }
    for (TKVideoSmallView *view in self.iStudentVideoViewArray) {
        
        if (view.iRoomUser) {
            
            if (!view.isSplit && view.isDrag == NO) {//判断是否分屏
                [self.iScroll addSubview:view];
                view.alpha  = 1;
                view.frame = CGRectMake(left, tCap, tWidth, tHeight);
                left += tleft + tWidth;
                
            }else{
                BOOL isEndMvToScrv = ((CGRectGetMaxY(view.frame) > CGRectGetMinY(self.iBottomView.frame)));
                if (!view.superview) {
                    [self.iScroll addSubview:view];
                }
                if (isEndMvToScrv) {
                    
                    view.isDrag = YES;
                    tStdOutBottom = YES;
                    continue;
                }
                view.isDrag = NO;
                view.alpha  = 1;
                view.frame = CGRectMake(left, tCap, tWidth, tHeight);
                left += tleft + tWidth;
                
            }
            
        }
        else {
            
            if (view.superview) {
                [view removeFromSuperview];
            }
        }
        
        if(view.iRoomUser.peerID){
            
            [self.iPlayVideoViewDic setObject:view forKey:view.iRoomUser.peerID];
        }
        
    }
    
    [TKEduSessionHandle shareInstance].iStdOutBottom = tStdOutBottom;
    if ([TKEduSessionHandle shareInstance].iIsFullState) {
        [self.iScroll bringSubviewToFront:self.iTKEduWhiteBoardView];
    }else{
        [self.iScroll sendSubviewToBack:self.iTKEduWhiteBoardView];
    }

}

- (void)refreshUI{
    if (self.iPickerController) {
        return;
    }
    
    //right
    CGFloat tViewCap = sViewCap*Proportion;
    //老师
    CGFloat tViewWidth = (sRightWidth-2*sViewCap)*Proportion;
    {
        if ([TKEduSessionHandle shareInstance].iStdOutBottom) {
            [self refreshBottom];
            
        }
        
    }
    //多人时 bottom和whiteview
    {
        
        [self refreshWhiteBoard:YES];
        [self sScaleVideo:self.iScaleVideoDict];
        [self moveVideo:self.iMvVideoDic];
        [self sVideoSplitScreen:self.iStudentSplitScreenArray];
        
    }
    //我
    {
        
        CGFloat tOurVideoViewHeight = (self.iRoomType == RoomType_OneToOne)?sTeacherVideoViewHeigh*Proportion:0;
        CGFloat tOurVideoViewY =  (self.iRoomType == RoomType_OneToOne)?CGRectGetMaxY(self.iTeacherVideoView.frame)+tViewCap:tViewCap;
        self.iOurVideoView.frame = CGRectMake(tViewCap,tOurVideoViewY, tViewWidth, tOurVideoViewHeight);
        self.iOurVideoView.hidden = !tOurVideoViewHeight;
    }
    
    //静音与奖励
    {
        //非老师
        BOOL tIsHide = (self.iUserType != UserType_Teacher) || (![TKEduSessionHandle shareInstance].isClassBegin) || (self.iRoomType==RoomType_OneToOne);
        
        // 一对一老师不显示全体静音与奖励按钮
        if (self.iRoomType == RoomType_OneToOne && self.iUserType == UserType_Teacher) {
            tIsHide = YES;
        }
        
        CGFloat tMuteAudioAndRewardViewHeight = !tIsHide?(40*Proportion):0;
        self.iMuteAudioAndRewardView.hidden = tIsHide;
        
        self.iMuteAudioAndRewardView.frame = CGRectMake(tViewCap, CGRectGetMaxY(self.iOurVideoView.frame), tViewWidth, tMuteAudioAndRewardViewHeight);
        
        self.iunMuteAllButton.hidden = tIsHide;
        
        
        //修改部分
        self.iMuteAudioButton.frame = CGRectMake(tViewCap - 10, 0, tViewWidth / 2 - 5, tMuteAudioAndRewardViewHeight);
        self.iMuteAudioButton.hidden = tIsHide;
        self.iRewardButton.frame = CGRectMake(tViewCap, CGRectGetMaxY(self.iMuteAudioAndRewardView.frame)+tViewCap, tViewWidth, (40*Proportion));
        
        // 如果是老师，需要管理全体静音按钮的背景色
        if (self.iUserType == UserType_Teacher) {
            if ([TKEduSessionHandle shareInstance].isMuteAudio) {
                self.iMuteAudioButton.enabled = NO;
                self.iMuteAudioButton.backgroundColor = RGBACOLOR_muteAudio_Normal;
                
            }else{
                self.iMuteAudioButton.enabled = YES;
                self.iMuteAudioButton.backgroundColor =  RGBACOLOR_muteAudio_Select;
                
            }
            if ([TKEduSessionHandle shareInstance].isunMuteAudio) {
                self.iunMuteAllButton.enabled = NO;
                self.iunMuteAllButton.backgroundColor = RGBACOLOR_unMuteAudio_Normal;
                
            }else{
                self.iunMuteAllButton.enabled = YES;
                self.iunMuteAllButton.backgroundColor =  RGBACOLOR_unMuteAudio_Select;
                
            }
        }
        
    }
    //举手按钮
    {
        BOOL tIsHide = NO;
        if ([[self.iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
        
            tIsHide = (![TKEduSessionHandle shareInstance].isClassBegin && (self.iUserType == UserType_Student));
        } else {
            // 非英联邦点击下课后，老师的上下课按钮可见
            tIsHide = NO;
            //            if (_iUserType == UserType_Teacher) {
            //                tIsHide = NO;
            //            } else {
            //                tIsHide = (![TKEduSessionHandle shareInstance].isClassBegin);
            //            }
        }
        BOOL tIsStdAndRoomOne = (self.iUserType == UserType_Student && self.iRoomType == RoomType_OneToOne);
        BOOL tIsTeacherOrAssis  = ([TKEduSessionHandle shareInstance].localUser.role ==UserType_Teacher ||
                                   [TKEduSessionHandle shareInstance].localUser.role ==UserType_Assistant ||
                                   [TKEduSessionHandle shareInstance].localUser.role ==UserType_Patrol);
        
        CGFloat tOpenAlumWidth = tIsStdAndRoomOne ?tViewWidth:(tViewWidth / 2 - 5) ;
        tOpenAlumWidth = tIsTeacherOrAssis ?tViewWidth:tOpenAlumWidth;
        
        CGFloat tLeftY =([TKEduSessionHandle shareInstance].isClassBegin && self.iRoomType != RoomType_OneToOne && self.iUserType == UserType_Teacher)? 40*Proportion+tViewCap:0;
        
        CGRect tLeftFrame = CGRectMake(0, 0, tOpenAlumWidth, (40*Proportion));
        
        CGRect tRightFrame = CGRectMake(tOpenAlumWidth+tViewCap*1, 0, tOpenAlumWidth, (40*Proportion));
        
        self.iClassBeginAndOpenAlumdView.frame = CGRectMake(tViewCap, CGRectGetMaxY(self.iMuteAudioAndRewardView.frame)+tViewCap+tLeftY, tViewWidth, (40*Proportion));
        
        self.iClassBeginAndRaiseHandButton.frame = tIsTeacherOrAssis?tLeftFrame:tRightFrame;
        
        self.iClassBeginAndRaiseHandButton.hidden = tIsHide;
        
        self.iOpenAlumButton.frame = tLeftFrame;
        self.iOpenAlumButton.hidden = tIsTeacherOrAssis;
        
        [TKUtil setCornerForView:self.iClassBeginAndRaiseHandButton];
        [TKUtil setCornerForView:self.iOpenAlumButton];
        BOOL isCanDraw = [[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sCandraw] boolValue];
        self.iOpenAlumButton.backgroundColor = isCanDraw?RGBACOLOR_ClassBegin_RedDeep:RGBACOLOR_ClassEnd_Red;
        self.iOpenAlumButton.enabled = isCanDraw;
        
        BOOL isNeedSelected =  NO;
        if (self.iUserType == UserType_Student) {
            bool tIsRaisHand =  [[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sRaisehand] boolValue];
            isNeedSelected = self.iSessionHandle.localUser.publishState == PublishState_BOTH || self.iSessionHandle.localUser.publishState == PublishState_AUDIOONLY || tIsRaisHand;
            if (isNeedSelected) {
                if (tIsRaisHand) {
                    if (self.iSessionHandle.localUser.publishState > 0) {
                        [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHandCancle") forState:UIControlStateNormal];
                    } else {
                        [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.CancleHandsup") forState:UIControlStateNormal];
                    }
                }
                
            }else{
                
                [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
                
            }
            
            // 当学生禁用自己音频时，无法举手
            if ([TKEduSessionHandle shareInstance].isClassBegin) {
                self.iIsCanRaiseHandUp = YES;       // 总是可以举手
            }else{
                self.iIsCanRaiseHandUp = NO;       // 总是可以举手
            }
            
            if (self.iIsCanRaiseHandUp) {
                self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBegin_RedDeep;
            } else {
                self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassEnd_Red;
            }
            
            self.iClassBeginAndRaiseHandButton.enabled = self.iIsCanRaiseHandUp;
            // [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sCandraw Value:@(_iIsCanRaiseHandUp) completion:nil];
            
        } else if (self.iUserType == UserType_Teacher) {
            
            isNeedSelected = [TKEduSessionHandle shareInstance].isClassBegin;
            
            if (isNeedSelected)
            {
                self.iRewardButton.hidden = (self.iRoomType == RoomType_OneToOne)?YES:NO;
            if ([[self.iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
                    self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                    [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                } else {
                    self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                    [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                }
            } else {
                
                self.iRewardButton.hidden = YES;
                self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
            }
        }else if (self.iUserType == UserType_Patrol){
            isNeedSelected = [TKEduSessionHandle shareInstance].isClassBegin;
            
            if (isNeedSelected)
            {
                self.iClassBeginAndRaiseHandButton.enabled = YES;
                if ([[self.iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
                    self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                    [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                } else {
                    self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                    [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                    
                }
                
            } else {
                
                [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
                self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassBeginAndEnd;
                
                self.iClassBeginAndRaiseHandButton.enabled = NO;
                
            }
            
            
        }
        
        [self.iRightView bringSubviewToFront:self.iClassBeginAndOpenAlumdView];
        
        
    }
    //聊天
    {
        [self refreshChatAndNavUI:tViewCap];

    }
    
    
    // 判断上下课按钮是否需要隐藏
    if (([self.iSessionHandle.roomMgr getRoomConfigration].hideClassBeginEndButton == YES && self.iSessionHandle.roomMgr.localUser.role != UserType_Student) || self.iSessionHandle.isPlayback == YES) {
        self.iClassBeginAndRaiseHandButton.hidden = YES;
        self.iClassBeginAndOpenAlumdView.hidden   = YES;
    }
    if(self.iSessionHandle.localUser.role == UserType_Patrol && [self.iSessionHandle.roomMgr getRoomConfigration].hideClassBeginEndButton == NO){
        if(self.iSessionHandle.isClassBegin){
            self.iClassBeginAndRaiseHandButton.hidden = NO;
            self.iClassBeginAndOpenAlumdView.hidden   = NO;
        }else{
            self.iClassBeginAndRaiseHandButton.hidden = YES;
            self.iClassBeginAndOpenAlumdView.hidden   = YES;
        }
    }
    
    if (![TKEduSessionHandle shareInstance].isClassBegin && self.iUserType == UserType_Student) {
        self.iClassBeginAndRaiseHandButton.enabled = NO;
        self.iClassBeginAndRaiseHandButton.backgroundColor = RGBACOLOR_ClassEnd_Red;
    }
}

#pragma mark - 视频长按手势
- (void)longPressClick:(UIGestureRecognizer *)longGes
{
    
    TKVideoSmallView * currentBtn = (TKVideoSmallView *)longGes.view;
    
    //未开始上课禁止拖动视频
    if (![TKEduSessionHandle shareInstance].isClassBegin) {
        return;
    }
    
    // 巡课不能拖视频
    if (self.iUserType == UserType_Patrol) {
        return;
    }
    
    // 学生只能在授权下拖拽自己的视频
    if (self.iUserType == UserType_Student) {
        if (![TKEduSessionHandle shareInstance].iIsCanDraw) {
            return;
        }
    }
    
    //判断视图是否处于分屏状态，如果是分屏状态则不可以拖动
    for (NSString *peerID in self.iStudentSplitScreenArray) {
        if ([peerID isEqualToString:currentBtn.iRoomUser.peerID] ) {
            return;
        }
    }
    
    if (([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol)) {
        return;
    }
    
    //把白板放到最下边
    [self.iScroll sendSubviewToBack:self.iTKEduWhiteBoardView];
    
    if (UIGestureRecognizerStateBegan == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iStrtCrtVideoViewP  = [longGes locationInView:currentBtn];
            self.iCrtVideoViewC      = currentBtn.center;
        }];
    }
    if (UIGestureRecognizerStateChanged == longGes.state) {
        //移动距离
        CGPoint newP = [longGes locationInView:currentBtn];
        CGFloat movedX = newP.x - self.iStrtCrtVideoViewP.x;
        CGFloat movedY = newP.y - self.iStrtCrtVideoViewP.y;
        CGFloat tCurBtnCenterX = currentBtn.center.x+ movedX;
        CGFloat tCurBtnCenterY = currentBtn.center.y + movedY;
        //边界
        CGFloat tEdgLeft = CGRectGetWidth(currentBtn.frame)/2.0;
        CGFloat tEdgRight = CGRectGetMaxX(self.iTKEduWhiteBoardView.frame) - CGRectGetWidth(currentBtn.frame)/2.0;
        CGFloat tEdgBtm = ScreenH - CGRectGetHeight(currentBtn.frame)/2.0-sViewCap;
        CGFloat tEdgTp = CGRectGetMinY(self.iTKEduWhiteBoardView.frame) - CGRectGetHeight(currentBtn.frame)/2.0;
        
        
        BOOL isOverEdgLR = (tCurBtnCenterX <= tEdgLeft) || (tCurBtnCenterX >= tEdgRight) || (tCurBtnCenterY <= tEdgTp) || (tCurBtnCenterY >= tEdgBtm);
        BOOL isOverEdgTD = (tCurBtnCenterY <= tEdgTp) || (tCurBtnCenterY >= tEdgBtm);
        if (isOverEdgLR) {
            tCurBtnCenterX =  tCurBtnCenterX - movedX;
        }
        if (isOverEdgTD) {
            tCurBtnCenterY = tCurBtnCenterY - movedY;
        }
        currentBtn.center = CGPointMake(tCurBtnCenterX, tCurBtnCenterY);
    }
    // 手指松开之后 进行的处理
    if (UIGestureRecognizerStateEnded == longGes.state) {
    
        BOOL isEndEdgMvToScrv = ((currentBtn.center.y> CGRectGetMinY(self.iBottomView.frame)) &&(CGRectGetMaxY(currentBtn.frame) < CGRectGetMinY(self.iBottomView.frame)));
        BOOL isEndMvToScrv = ((CGRectGetMinY(currentBtn.frame) > CGRectGetMaxY(self.iBottomView.frame)));
        
        currentBtn.isDrag = YES;
        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.alpha     = 1.0f;
            currentBtn.transform = CGAffineTransformIdentity;
            if (isEndEdgMvToScrv ) {
                
                 currentBtn.frame= CGRectMake(CGRectGetMinX(currentBtn.frame), CGRectGetMinY(self.iBottomView.frame)-CGRectGetHeight(currentBtn.frame), CGRectGetWidth(currentBtn.frame), CGRectGetHeight(currentBtn.frame));
                
            }else if(isEndMvToScrv) {
                TKLog(@"isEndMvToScrv 拖动");
            }else {
                currentBtn.isDrag = NO;
            }
            
            //拖拽视频后如果未放大需要初始化到7个均分的大小
            CGFloat w =((ScreenW-7*sViewCap)/ 7);
            CGFloat h = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
            
            if (!currentBtn.isSplit && currentBtn.currentWidth<currentBtn.originalWidth) {
                currentBtn.frame= CGRectMake(CGRectGetMinX(currentBtn.frame), CGRectGetMinY(currentBtn.frame), w, h);
            }
            
            //拖动视频的时候判断下视频是否有分屏状态的
            if(self.iStudentSplitScreenArray.count>0){
                
                [self beginTKSplitScreenView:currentBtn];
                return;
            }
            
            [self refreshBottom];
            [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
            
        }];
    }
}

#pragma mark - 播放
-(void)playVideo:(TKRoomUser *)user {
    
    [self.iSessionHandle delUserPlayAudioArray:user.peerID];
    
    TKVideoSmallView* viewToSee = nil;
    if (user.role == UserType_Teacher)
        viewToSee = self.iTeacherVideoView;
    else if ((self.iRoomType == RoomType_OneToOne && user.role == UserType_Student)||(self.iRoomType == RoomType_OneToOne && user.role == UserType_Patrol)) {
        viewToSee = self.iOurVideoView;
    }
    else
        for (int i =0; i< self.iStudentVideoViewArray.count; i++) {
            
            TKVideoSmallView *view = (TKVideoSmallView *)self.iStudentVideoViewArray[i];
            if(view.iVideoViewTag ==-1){
                continue;
            }
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:user.peerID]) {
                viewToSee = nil;
                break;
            }
            else if(view.iRoomUser == nil && !viewToSee) {
                viewToSee = view;
            }
        }
    
    if (viewToSee && viewToSee.iRoomUser == nil) {
        
        [self myPlayVideo:user aVideoView:viewToSee completion:^(NSError *error) {
            
            if (!error) {
                [self.iPlayVideoViewDic setObject:viewToSee forKey:user.peerID];
                if (self.iSessionHandle.iIsFullState) {//如果文档处于全屏模式下则不进行刷新界面
                    return;
                }
                [self refreshUI];
            }
        }];
    }
}

//- (TKVideoSmallView *)videoViewForPeerId:(NSString *)peerId {
//    if (peerId == nil) {
//        return nil;
//    }
//    
//    for (TKVideoSmallView *view in self.iStudentVideoViewArray) {
//        if ([view.iRoomUser.peerID isEqualToString:peerId]) {
//            return view;
//        }
//    }
//    
//    return nil;
//}

//进入会议失败,重连
- (void)sessionManagerDidFailWithError:(NSError *)error {
    if (!(error.code == TKErrorCode_ConnectSocketError || error.code == TKRoomWarning_ReConnectSocket_ServerChanged || error.code == TKErrorCode_Subscribe_RoomNotExist)) {
        return;
    }
    
    self.networkRecovered = NO;
    self.currentServer = nil;
    
    [self clearAll];
}
- (void)clearAll{
    
    if (self.isConnect) {
        return;
    }
    
    self.isConnect = YES;
    
    [[TKEduSessionHandle shareInstance]configureHUD:MTLocalized(@"State.Reconnecting") aIsShow:YES];
    
    
    [[TKEduSessionHandle shareInstance]configureDraw:false isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
    
    [[TKEduSessionHandle shareInstance].iBoardHandle disconnectCleanup];
    
    [self.iSessionHandle clearAllClassData];
    
    [self.iSessionHandle.iBoardHandle clearAllWhiteBoardData];
    
    [self clearVideoViewData:self.iOurVideoView];
    
    //将分屏的数据删除
    for (TKVideoSmallView *view in self.iStudentSplitViewArray) {
        view.isDrag = NO;
        [self.iStudentVideoViewArray addObject:view];
    }
    
    [self.iStudentSplitViewArray removeAllObjects];
    
    for (TKVideoSmallView *view in self.iStudentVideoViewArray) {
        [self clearVideoViewData:view];
    }
    
    if(self.iStudentVideoViewArray.count !=0){
        
        TKVideoSmallView *iview = (TKVideoSmallView *)self.iStudentVideoViewArray[0];
        
        for (int i=0; i<self.iStudentVideoViewArray.count; i++) {
            
            TKVideoSmallView *view = (TKVideoSmallView *)self.iStudentVideoViewArray[i];
            if (view.iRoomUser && iview.iVideoViewTag !=-1) {
                
                [self.iStudentVideoViewArray exchangeObjectAtIndex:i withObjectAtIndex:0];
                
            }
        }
    }
    
    [self.iPlayVideoViewDic removeAllObjects];
    
    if (self.iDocumentListView) {
        [self.iDocumentListView removeFromSuperview];
        self.iDocumentListView = nil;
    }
    if (self.iMediaListView) {
        [self.iMediaListView removeFromSuperview];
        self.iMediaListView = nil;
    }
    // 播放的MP4前，先移除掉上一个MP4窗口
    [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
    if (self.iMediaView) {
        [self.iMediaView deleteWhiteBoard];
        [self.iMediaView removeFromSuperview];
        self.iMediaView = nil;
    }
    
    if (self.iScreenView) {
        [self.iScreenView removeFromSuperview];
        self.iScreenView = nil;
    }
    
    
    
    [self.splitScreenView deleteAllVideoSmallView];
    
    [self.iStudentSplitScreenArray removeAllObjects];
    
    self.splitScreenView.hidden = YES;
}
- (void)sessionManagerUserPublished:(TKRoomUser *)user{
    
//    {
//        NSString *msg = [NSString stringWithFormat:@"播放：%@的视频,peerid:%@",user.nickName,user.peerID];
//        //测试删除
//        [self showMessage:msg];
//    }
    
    // ToDo: 线程安全
    [[TKEduSessionHandle shareInstance] addPublishUser:user];
    [[TKEduSessionHandle shareInstance] delePendingUser:user.peerID];
    
    /// 仝磊鸣修改，原来是大于1，由于现在只发布一次，所以先发布音频后发布视频会看不到
    TKLog(@"jin------publish:%@",user.nickName);
    if (user.publishState >0) {
        
        if (![TKEduSessionHandle shareInstance].isPlayMedia) {
            NSLog(@"---jin sessionManagerUserPublished");
            [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
            
        }
        [self playVideo:user];
    }
    
    if (user.publishState == 1) {
        [self.iSessionHandle addOrReplaceUserPlayAudioArray:user];
    }
}
//上课下课
-(void)classBeginAndRaiseHandButtonClicked:(UIButton *)aButton{
    
    if (self.iUserType == UserType_Teacher || self.iUserType == UserType_Patrol) {
        aButton.selected = [TKEduSessionHandle shareInstance].isClassBegin;
        if (!aButton.selected) {
            
                if([self.iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag && self.iUserType == UserType_Teacher){
                    [[TKEduSessionHandle shareInstance]sessionHandleDelMsg:sAllAll ID:sAllAll To:sTellNone Data:@{} completion:nil];
                }
                //当前时间定时器
                TKLog(@"开始上课");
                UIButton *tButton = self.iClassBeginAndRaiseHandButton;
                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
                
                [TKEduNetManager classBeginStar:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
                    tButton.backgroundColor = RGBACOLOR_ClassEnd_Red;
                    [tButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                    //  {"recordchat" : true};
                    NSString *str = [TKUtil dictionaryToJSONString:@{@"recordchat":@YES}];
                    //[_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true completion:nil];
                    [self.iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
                    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                    
                    return 0;
                } aNetError:^int(id  _Nullable response) {
                    
                    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                    return 0;
                }];
            
            
        } else {
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:MTLocalized(@"Prompt.prompt") message:MTLocalized(@"Prompt.FinishClass") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *tActionSure = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                TKLog(@"下课");
                //将分屏的数据删除
                NSArray *splitArray = [NSArray arrayWithArray:self.iStudentSplitViewArray];
                for (TKVideoSmallView *view in splitArray) {
                    if(view.iVideoViewTag ==-1){
                        view.isSplit = YES;
                        [self beginTKSplitScreenView:view];
                    }
                    
                }
                
                UIButton *tButton = self.iClassBeginAndRaiseHandButton;
                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
                [self.iClassTimetimer invalidate];      // 下课后计时器销毁
                
                // 下课关闭MP3和MP4
                if ([TKEduSessionHandle shareInstance].isPlayMedia == YES) {
                    [TKEduSessionHandle shareInstance].isPlayMedia          = NO;
                    [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:nil];
                }
                if(![self.iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag){
                    
                    // 下课清理聊天日志
                    [self.iSessionHandle clearMessageList];
                    [self refreshData];
                    // 下课文档复位
                    [self.iSessionHandle fileListResetToDefault];
                    // 下课后showpage
                    [self.iSessionHandle docmentDefault:[self.iSessionHandle getClassOverDocument]];
                 }
                
                [TKEduNetManager classBeginEnd:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
                    [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{} completion:nil];
                    
                    [tButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
                    
                    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                    
                    return 0;
                }aNetError:^int(id  _Nullable response) {
                    
                    
                    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                    
                    return 0;
                }];
                
            }];
            
            UIAlertAction *tActionCancel = [UIAlertAction actionWithTitle:MTLocalized(@"Prompt.Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //
            }];
            
            [ac addAction:tActionSure];
            [ac addAction:tActionCancel];
            
            [self presentViewController:ac animated:YES completion:nil];
        }
        
        
    }else{
        TKLog(@"举手");
        
        // 在台上点击举手按钮无效，只响应长按
        if (self.iSessionHandle.localUser.publishState > 0) {
            return;
        }
        
        aButton.selected = ![[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sRaisehand] boolValue];
        [self.iSessionHandle sessionHandleChangeUserProperty:self.iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(aButton.selected) completion:nil];
        if (aButton.selected) {
            if (self.iSessionHandle.localUser.publishState > 0) {
                [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHandCancle") forState:UIControlStateNormal];
            } else {
                [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.CancleHandsup") forState:UIControlStateNormal];
            }
        }else{
            [self.iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
        }
    }
}
-(void)unPlayVideo:(NSString *)peerID {

    TKVideoSmallView* viewToSee = nil;
    if (peerID == self.iTeacherVideoView.iPeerId)
        viewToSee = self.iTeacherVideoView;
    else if (self.iRoomType == RoomType_OneToOne && peerID == self.iOurVideoView.iPeerId) {
        viewToSee = self.iOurVideoView;
    }
    else
    {
        for (TKVideoSmallView* view in self.iStudentVideoViewArray) {
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:peerID]) {
                viewToSee = view;
                break;
            }
        }
        NSArray *splitA = [NSArray arrayWithArray:self.splitScreenView.videoSmallViewArray];
        for (TKVideoSmallView* view in splitA) {
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:peerID]) {
//                [self.iStudentVideoViewArray addObject:view];
//                [self.splitScreenView.videoSmallViewArray removeObject:view];
                viewToSee = view;
                break;
            }
        }
    }
    
    if (viewToSee && viewToSee.iRoomUser != nil && [viewToSee.iRoomUser.peerID isEqualToString:peerID]) {
        
        __weak typeof(self)weekSelf = self;
        NSMutableDictionary *tPlayVideoViewDic = self.iPlayVideoViewDic;
        
        NSArray *array = [NSArray arrayWithArray:self.iStudentSplitScreenArray];
        for (NSString *peerId in array) {
            if([peerID isEqualToString:peerId]) {
//                viewToSee.isSplit = YES;
//                [self beginTKSplitScreenView:viewToSee];
                [self.iStudentVideoViewArray addObject:viewToSee];
                [self.iStudentSplitViewArray removeObject:viewToSee];
            }
        }
        
        [self myUnPlayVideo:peerID aVideoView:viewToSee completion:^(NSError *error) {
            
            [tPlayVideoViewDic removeObjectForKey:peerID];
            
            __strong typeof(weekSelf) strongSelf =  weekSelf;
            
            //            viewToSee.frame = CGRectMake(0, CGRectGetMinY(_iBottomView.frame), CGRectGetWidth(viewToSee.frame), CGRectGetHeight(viewToSee.frame));
            
            [strongSelf updateMvVideoForPeerID:peerID];
            if (!self.iSessionHandle.iIsFullState) {
                [strongSelf refreshUI];
            }
            
        }];
    }
    [self.iSessionHandle delePendingUser:peerID];
}
-(void)myUnPlayVideo:(NSString *)peerID aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    [self.iSessionHandle sessionHandleUnPlayVideo:peerID completion:^(NSError *error) {
        
        //更新uiview
        [aVideoView clearVideoData];
        
        TKLog(@"----unplay:%@ frame:%@ VideoView:%@",peerID,@(aVideoView.frame.size.width),@(aVideoView.iVideoViewTag));
        completion(error);
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fullScreenToLc:(NSNotification*)aNotification{
    
    bool isFull = [aNotification.object boolValue];
    self.iClassTimeView.hidden = isFull;
    [TKEduSessionHandle shareInstance].iIsFullState = isFull;
    if (isFull) {
        [self.iScroll bringSubviewToFront:self.iTKEduWhiteBoardView];
    }else{
        [self.iScroll sendSubviewToBack:self.iTKEduWhiteBoardView];
        [self refreshUI];
    }
    
}
- (void)sScaleVideo:(NSDictionary *)peerIdToScaleDic{
    
    NSArray *peerIdArray = peerIdToScaleDic.allKeys;
    
    for (NSString *peerId in peerIdArray) {
        NSDictionary *scaleDict = [peerIdToScaleDic objectForKey:peerId];
        
        CGFloat scale = [scaleDict[@"scale"] floatValue];
        
        TKVideoSmallView *videoView = [self videoViewForPeerId:peerId];
        
        if (videoView && videoView.isDrag == YES) {
            [videoView changeVideoSize:scale];
        }
    }
}
-(void)moveVideo:(NSDictionary *)aMvVideoDic{
    
    for (NSString *peerId in aMvVideoDic) {
        NSDictionary *obj = [aMvVideoDic objectForKey:peerId];
        BOOL isDrag = [[obj objectForKey:@"isDrag"]boolValue];
        //对返回的数据做NSNull值判断
        if([[obj objectForKey:@"percentTop"] isKindOfClass:[NSNull class]]){
            return;
        }
        if([[obj objectForKey:@"percentLeft"] isKindOfClass:[NSNull class]]){
            return;
        }
        CGFloat top = [[obj objectForKey:@"percentTop"]floatValue];
        CGFloat left = [[obj objectForKey:@"percentLeft"]floatValue];
        TKVideoSmallView *tVideoView = [self.iPlayVideoViewDic objectForKey:peerId];
        
        if (tVideoView) {
            
            tVideoView.isDrag = isDrag;
            if (isDrag) {
                
                CGFloat tX = CGRectGetWidth(self.iTKEduWhiteBoardView.frame) - CGRectGetWidth(tVideoView.frame);
                CGFloat tY = CGRectGetHeight(self.iTKEduWhiteBoardView.frame)-CGRectGetHeight(tVideoView.frame);
                tVideoView.frame = CGRectMake(tX*left, CGRectGetMinY(self.iTKEduWhiteBoardView.frame)+ tY*top, CGRectGetWidth(tVideoView.frame), CGRectGetHeight(tVideoView.frame));
                
                CGFloat w =((ScreenW-7*sViewCap)/ 7);
                CGFloat h = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
                
                if (!tVideoView.isSplit && tVideoView.currentWidth<tVideoView.originalWidth) {
                    
                    tVideoView.frame = CGRectMake(tX*left, CGRectGetMinY(self.iTKEduWhiteBoardView.frame)+ tY*top, w, h);
                }
                
                
            }else{
                
                // 当老师拖拽后，网页助教再拖拽，收到的拖拽信令中有老师的peerID，因为从网页收到了老师view变化的错误信令
                if (tVideoView.iRoomUser.role != UserType_Teacher) {
                    //                    tVideoView.frame = CGRectMake(CGRectGetMinX(tVideoView.frame), CGRectGetMinY(_iBottomView.frame)+1, CGRectGetWidth(tVideoView.frame), CGRectGetHeight(tVideoView.frame));
                }
                
            }
            
        }
    }
    [self refreshBottom];
   
}
-(void)sendMoveVideo:(NSDictionary *)aPlayVideoViewDic aSuperFrame:(CGRect)aSuperFrame allowStudentSendDrag:(BOOL)isSendDrag{
    
    NSMutableDictionary *tVideosDic = @{}.mutableCopy;
    for (NSString *tKey in aPlayVideoViewDic) {
        
        TKVideoSmallView *tVideoView = [aPlayVideoViewDic objectForKey:tKey];
        CGFloat tX = CGRectGetWidth(aSuperFrame) - CGRectGetWidth(tVideoView.frame);
        CGFloat tY = CGRectGetHeight(aSuperFrame)-CGRectGetHeight(tVideoView.frame);
        CGFloat tLeft = CGRectGetMinX(tVideoView.frame)/tX;
        CGFloat tTop= (CGRectGetMinY(tVideoView.frame)-CGRectGetMinY(aSuperFrame))/tY;
        if(tVideoView.isSplit){
            tLeft = 0;
            tTop = 0;
        }
        
        NSDictionary *tDic = @{@"percentTop":@(tTop),@"percentLeft":@(tLeft),@"isDrag":@(tVideoView.isDrag)};
        if ((tVideoView.iRoomUser.role == UserType_Student) || (tVideoView.iRoomUser.role == UserType_Assistant) || (tVideoView.iRoomUser.role == UserType_Teacher) ) {
            [tVideosDic setObject:tDic forKey:tVideoView.iPeerId?tVideoView.iPeerId:@""];
        }
        
    }
    NSDictionary *tDic =   @{@"otherVideoStyle":tVideosDic};
    
    self.iMvVideoDic = [NSMutableDictionary dictionaryWithDictionary:tVideosDic];
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher || isSendDrag) {
        [[TKEduSessionHandle shareInstance]publishVideoDragWithDic:tDic To:sTellAllExpectSender];
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

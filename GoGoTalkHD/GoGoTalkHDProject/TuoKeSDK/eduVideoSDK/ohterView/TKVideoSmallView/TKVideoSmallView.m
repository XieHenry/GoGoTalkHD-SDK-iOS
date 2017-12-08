//
//  TKVideoSmallView.m
//  whiteBoardDemo
//
//  Created by ifeng on 2017/2/23.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKVideoSmallView.h"
#import "TKMacro.h"
#import "TKUtil.h"
#import "TKVideoFunctionView.h"
#import "TKEduSessionHandle.h"
#import "TKEduBoardHandle.h"
#import "TKEduNetManager.h"
#import "TKEduRoomProperty.h"
#import "TKEduSessionHandle.h"
#import "TKBackGroundView.h"
//214*140  214*120 214*20
//214*140  214*120 214*20
//120*112  120*90  120*22

//static const CGFloat sVideoSmallNameLabelHeight = 22;

@interface TKVideoSmallView ()<VideolistProtocol,CAAnimationDelegate>

@property (nonatomic, strong) TKBackGroundView *sIsInBackGroundView;//进入后台覆盖视图

@property(nonatomic,retain)TKVideoFunctionView *iFunctionView;
@property(nonatomic,assign)EVideoRole iVideoRole;
/** *  画笔 */
@property (nonatomic, strong) UIImageView * _Nullable iDrawImageView;
/** *  音频 */
@property (nonatomic, strong) UIImageView * _Nullable iAudioImageView;
/** *  举手 */
@property (nonatomic, strong) UIImageView * _Nullable iHandsUpImageView;
/** *  视频 */
@property (nonatomic, strong) UIImageView * _Nullable iVideoImageView;

//gift
@property (nonatomic, strong) UIImageView *iGiftAnimationView;
@property (nonatomic, assign) NSInteger iGiftCount;
@property (nonatomic, assign) EVideoRole videoRole;


@end


@implementation TKVideoSmallView

//super override
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame aVideoRole:EVideoRoleTeacher];
}
-(instancetype)initWithFrame:(CGRect)frame aVideoRole:(EVideoRole)aVideoRole{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGBCOLOR(47, 47, 47);
        _videoRole = aVideoRole;
        _iVideoBackgroundImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_teacher_big")];
        _iVideoBackgroundImageView.backgroundColor = RGBCOLOR(47, 47, 47);
        _iVideoBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewContentModeBottom;
        
        _iVideoRole  = aVideoRole;
        switch (aVideoRole) {
            case EVideoRoleTeacher:{
                
                 break;
            }
            case EVideoRoleOur:{
                
                _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_user_big");
                break;
                
            }
            default:{
                
                _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_user_small");
                
                break;
                
            }
              
        }

      
        _iNameLabel =({
            
            UILabel *tNameLabel = [[UILabel alloc]init];
            tNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            
            [tNameLabel setFont:TKFont(12)];
            tNameLabel.textColor = [UIColor whiteColor];
            //tNameLabel.text = @"笑笑";
            
            //tNameLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
            //tNameLabel.backgroundColor = [UIColor yellowColor];
            tNameLabel.textAlignment = NSTextAlignmentLeft;
            //tNameLabel.hidden = YES;
            tNameLabel;
        
        });
      
        
        _iBackgroundLabel =({
            UILabel *tLabel = [[UILabel alloc]init];
            tLabel.backgroundColor =RGBACOLOR(0, 0, 0, 0.3);
            tLabel;
        
        });
        
        [self addSubview:_iVideoBackgroundImageView];
        [self addSubview:_iBackgroundLabel];
        [self addSubview:_iNameLabel];
        
        
        _iGifButton = ({
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [tButton setImage:LOADIMAGE(@"icon_gift") forState:UIControlStateNormal];
            [tButton setTitleColor:RGBCOLOR(240,207,46)forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(11);
            tButton.hidden = YES;

            tButton;
            
        });
        
        if (aVideoRole != EVideoRoleTeacher) {
            
            _iVideoImageView = ({
                
                UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_video")];
                
                tImageView;
                
            });
        } else {
            
            _iVideoImageView = nil;
            
        }
        
        _iAudioImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_audio")];
//            tImageView.contentMode = UIViewContentModeTopLeft;
            tImageView;
          
            
        });
        _iDrawImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_tools")];
            
            tImageView;
            
        });
       
        _iHandsUpImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_hand")];
            
            
            tImageView;
            
        });
        
        [self addSubview:_iVideoImageView];
        [self addSubview:_iAudioImageView];
        [self addSubview:_iDrawImageView];
        [self addSubview:_iHandsUpImageView];
        
       
        if (aVideoRole != EVideoRoleTeacher) {[self addSubview:_iGifButton];}
        _iVideoImageView.hidden    = YES;
        _iAudioImageView.hidden    = YES;
        _iDrawImageView.hidden     = YES;
        _iHandsUpImageView.hidden  = YES;
        
         _iFunctionButton = ({
             
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
             
             [tButton addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

            tButton;
            
        });
         [self addSubview:_iFunctionButton];

    }
    return self;
}


-(void)layoutSubviews{
    
    [self bringSubviewToFront:_iFunctionButton];
    
    CGFloat videoSmallWidth  = CGRectGetWidth(self.frame);
    
    CGFloat videoSmallHeight = CGRectGetHeight(self.frame);
    
    CGFloat tVideoWidth     = videoSmallWidth;
    
//    CGFloat tVideoHeigh     = CGRectGetHeight(frame)-sVideoSmallNameLabelHeight*Proportion;
//    CGFloat tVideoHeigh     = tVideoWidth*3/4.0;
    
    CGFloat tVideoHeigh     = videoSmallHeight-30;
    
    _iVideoBackgroundImageView.frame        = CGRectMake(0, 0, tVideoWidth, tVideoHeigh);
    
    _iVideoFrame =  CGRectMake(0, 0, tVideoWidth, tVideoHeigh);
    
    _iRealVideoView.frame = _iVideoFrame;
    
//    CGFloat tWidth = (_videoRole != EVideoRoleTeacher?(videoSmallWidth-48):CGRectGetWidth(self.frame));
    CGFloat tWidth = videoSmallWidth-48;
    
    _iNameLabel.frame = CGRectMake(0,tVideoHeigh, tWidth, videoSmallHeight-tVideoHeigh);
    
    _iGifButton.frame = CGRectMake(CGRectGetMaxX(_iNameLabel.frame), CGRectGetMinY(_iNameLabel.frame), 48, CGRectGetHeight(_iNameLabel.frame));
    
    _iBackgroundLabel.frame = CGRectMake(0,tVideoHeigh, tVideoWidth, CGRectGetHeight(self.frame)-tVideoHeigh);
    
    
    CGFloat tVideoImageWidth = self.isSplit?30:(tVideoWidth-6)/8.0;
    
    _iVideoImageView.frame        = CGRectMake(0, 0, tVideoImageWidth, tVideoImageWidth);
    
    _iAudioImageView.frame        = CGRectMake((_videoRole == EVideoRoleTeacher) ? 0 : tVideoImageWidth, 0, tVideoImageWidth, tVideoImageWidth);
    
    
    _iDrawImageView.frame        = CGRectMake(tVideoImageWidth*2, 0, tVideoImageWidth, tVideoImageWidth);
    
    _iHandsUpImageView.frame        = CGRectMake(tVideoWidth-tVideoImageWidth-3, 0, tVideoImageWidth, tVideoImageWidth);
    
    _iFunctionButton.frame = CGRectMake(0, 0, videoSmallWidth, videoSmallHeight);
    
    
}

-(void)setIsNeedFunctionButton:(BOOL)isNeedFunctionButton{
    _iFunctionButton.enabled = isNeedFunctionButton;
}
-(void)setIRoomUser:(RoomUser *)iRoomUser{
    
    BOOL isShowAudioImage = ( iRoomUser.publishState == PublishState_AUDIOONLY ||
                             iRoomUser.publishState== PublishState_BOTH);
    BOOL isShowVideoImage = (iRoomUser.publishState == PublishState_BOTH ||
                             iRoomUser.publishState == PublishState_VIDEOONLY);
    if (iRoomUser) {
//         [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%@%@",sRaisehand,user.peerID] object:@(_iIsRaiseHandUp)];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshRaiseHandUI:) name:[NSString stringWithFormat:@"%@%@",sRaisehand,iRoomUser.peerID] object:nil];
        _iGifButton.hidden = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inBackground:) name:[NSString stringWithFormat:@"%@%@",sIsInBackGround,iRoomUser.peerID] object:nil];
        
    }else{
        // [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%@%@",sRaisehand,user.peerID] object:@(_iIsRaiseHandUp)];
        //删除前一个
        [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%@%@",sRaisehand,_iRoomUser.peerID] object:nil];
        
        _iGifButton.hidden = YES;
        
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%@%@",sIsInBackGround,_iRoomUser.peerID] object:nil];
        
    }
    [self bringSubviewToFront:_iAudioImageView];
    [self bringSubviewToFront:_iDrawImageView];
    [self bringSubviewToFront:_iHandsUpImageView];
    
    // 学生自己可以在自己的SmallView上弹出操作视图
    if ([iRoomUser.peerID isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID] && iRoomUser.role == EVideoRoleOther) {
        _iFunctionButton.enabled = YES;
    }
   
    _iRoomUser = iRoomUser;
    int currentGift = 0;
    if(iRoomUser && iRoomUser.properties && [iRoomUser.properties objectForKey:sGiftNumber])
        currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
    [_iGifButton setTitle:[NSString stringWithFormat:@"%@",@(currentGift)] forState:UIControlStateNormal];
    
    // 助教视频不显示奖杯
    if (iRoomUser.role == UserType_Assistant) {
        _iGifButton.hidden = YES;
    }
    
    _iAudioImageView.hidden = !isShowAudioImage;
    _iVideoImageView.hidden = !isShowVideoImage;
    _iDrawImageView.hidden  = !iRoomUser.canDraw || (iRoomUser.publishState == PublishState_NONE) || (iRoomUser.role == UserType_Teacher) ;
    
    _iHandsUpImageView.hidden  = ![[iRoomUser.properties objectForKey:sRaisehand] boolValue]|| (iRoomUser.role == UserType_Teacher);
    
    // 根据用户disableAudio和disableVideo去设置图片
    [self changeAudioDisabledState];
    [self changeVideoDisabledState];
    
    // 未上课，不显示摄像头和话筒图标
    if ([TKEduSessionHandle shareInstance].isClassBegin == NO) {
        _iAudioImageView.hidden = YES;
        _iVideoImageView.hidden = YES;
    }
}
- (void)inBackground:(NSNotification *)aNotification{
    BOOL isInBackground =[aNotification.userInfo[sIsInBackGround] boolValue];
    
     [self endInBackGround:isInBackground];
    
}
- (void)endInBackGround:(BOOL)isInBackground{
    
    if (isInBackground) {//进入后台需将视频顶层覆盖视图
        
        [self addSubview:self.sIsInBackGroundView];
        [self bringSubviewToFront:self.sIsInBackGroundView];
    }else{//取消覆盖
        [self.sIsInBackGroundView removeFromSuperview];
        
    }
}
-(void)refreshRaiseHandUI:(NSNotification *)aNotification{
    NSDictionary *tDic = (NSDictionary *)aNotification.object;
    PublishState tPublishState = [[tDic objectForKey:sPublishstate]integerValue];
    BOOL tAudioImageShow = !(tPublishState  == PublishState_BOTH || tPublishState == PublishState_AUDIOONLY );
    _iAudioImageView.hidden = tAudioImageShow;
    
    BOOL tVideoImageShow = !(tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY);
    _iVideoImageView.hidden = tVideoImageShow;

     BOOL tHandsUpImageShow = (_iRoomUser.role == UserType_Teacher) ||([TKEduSessionHandle shareInstance].localUser.role ==UserType_Student)|| (![[tDic objectForKey:sRaisehand]boolValue]);
    _iHandsUpImageView.hidden = tHandsUpImageShow;
    
    BOOL tDrawImageShow = (_iRoomUser.role == UserType_Teacher) ||![[tDic objectForKey:sCandraw]boolValue];
    _iDrawImageView.hidden = tDrawImageShow;
    
    if([[tDic objectForKey:sGiftNumber]integerValue] && _iRoomUser.role != UserType_Teacher){
        NSString *fromId = [tDic objectForKey:sFromId];
        if ([fromId isEqualToString:_iRoomUser.peerID] == NO) {
            [self potStartAnimationForView:self];
        }
    }
    
    self.iRoomUser.disableVideo = [[tDic valueForKey:sDisableVideo] boolValue];
    self.iRoomUser.disableAudio = [[tDic valueForKey:sDisableAudio] boolValue];
    // 只有学生才能控制音视频禁用状态
    if (_iVideoRole != EVideoRoleTeacher) {
        [self changeAudioDisabledState];
        [self changeVideoDisabledState];
    }
    
    if (_iVideoRole == EVideoRoleTeacher) {
        if (tPublishState == PublishState_AUDIOONLY || tPublishState == PublishState_NONE_ONSTAGE) {
            [self bringSubviewToFront:_iVideoBackgroundImageView];      // 背景图片显示上来
            [self bringSubviewToFront:_iVideoImageView];
            [self bringSubviewToFront:_iAudioImageView];
            [self bringSubviewToFront:_iDrawImageView];
            [self bringSubviewToFront:_iHandsUpImageView];
        } else {
            [self sendSubviewToBack:_iVideoBackgroundImageView];
        }
    }
}
-(void)functionButtonClicked:(UIButton *)aButton{
   
    if ([TKEduSessionHandle shareInstance].isClassBegin == NO) {
        return;
    }
    
//    if (!_iPeerId || [_iPeerId isEqualToString:@""] || ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student && [TKEduSessionHandle shareInstance].roomMgr.allowStudentCloseAV == NO) || [[TKEduSessionHandle shareInstance].roomMgr.companyId isEqualToString:YLB_COMPANYID] || ([TKEduSessionHandle shareInstance].localUser.role != UserType_Teacher && ![_iPeerId isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID]))
//        return;
    
    if (!_iPeerId || [_iPeerId isEqualToString:@""] || ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student && [TKEduSessionHandle shareInstance].roomMgr.allowStudentCloseAV == NO) || ([TKEduSessionHandle shareInstance].localUser.role != UserType_Teacher && ![_iPeerId isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID]))
        return;
    
    if (!_iFunctionView) {
        [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
        switch (_iVideoRole) {
            case EVideoRoleTeacher:{
                //修改部分
                _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 320, 70) withType:1 aVideoRole:EVideoRoleTeacher aRoomUer:_iRoomUser];
                // _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 295, 70) withType:1 aVideoRole:EVideoRoleTeacher aRoomUer:_iRoomUser];
                
                self.iFunctionView.iDelegate = self;
                
                break;
            }
            case EVideoRoleOur:{
                //修改部分
                _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 320, 70) withType:1 aVideoRole:EVideoRoleOur aRoomUer:_iRoomUser];
                // _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 295, 70) withType:1 aVideoRole:EVideoRoleOur aRoomUer:_iRoomUser];
                _iFunctionView.iDelegate = self;
                break;
                
            }
            default:{
                
                _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_user_small");
                
                //此处判断下是否为学生且开启了允许开关摄像头功能
                CGFloat functionWidth = 320;
                
                //修改部分
                if (!self.isSplit) {
                    
                    _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)-70, functionWidth, 70) withType:0 aVideoRole:EVideoRoleOther aRoomUer:_iRoomUser];
                }else{
                    _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+70, functionWidth, 70) withType:0 aVideoRole:EVideoRoleOther aRoomUer:_iRoomUser];
                }
                
                _iFunctionView.isSplitScreen = self.isSplit;
                // _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.superview.frame)-70, 295, 70) withType:0 aVideoRole:EVideoRoleOther aRoomUer:_iRoomUser];
                _iFunctionView.iDelegate = self;
                
                break;
                
            }
                
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.iFunctionView];
        
        
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
        [self hideFunctionView];
    }
    
}
-(void)hideFunctionView{
    _iFunctionView.hidden = YES;
    [_iFunctionView removeFromSuperview];
    _iFunctionView = nil;
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

-(void)changeName:(NSString *)aName{
  
    _iNameLabel.hidden = ([aName isEqualToString:@""]);
    [self bringSubviewToFront:_iNameLabel];
    [self bringSubviewToFront:_iFunctionButton];
    
    NSAttributedString * attrStr =  [[NSAttributedString alloc]initWithData:[aName dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    _iNameLabel.text = attrStr.string ;
    
    
}

-(void)clearVideoData{
    _iPeerId = @"";
    self.iRoomUser = nil;
    _isDrag = NO;
    
    [self changeName:@""];
    [_iRealVideoView removeFromSuperview];
    _iRealVideoView = nil;
    _iGifButton.hidden = YES;
}

-(void)addVideoView:(UIView*)view{
    
    [self insertSubview:view aboveSubview:_iVideoBackgroundImageView];
}
#pragma mark VideolistProtocol
-(void)videoSmallbutton1:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    [self hideFunctionView];
    if ( ![_iPeerId isEqualToString:@""]) {
       // _iCurrentPeerId = _iPeerId;
        if (aVideoRole == EVideoRoleTeacher) {
            TKLog(@"关闭视频");
            PublishState tPublishState = _iRoomUser.publishState;
            switch (tPublishState) {
                case PublishState_VIDEOONLY:
                    tPublishState = PublishState_NONE_ONSTAGE;
                    break;
                case PublishState_AUDIOONLY:
                    tPublishState = PublishState_BOTH;
                    break;
                case PublishState_BOTH:
                    tPublishState = PublishState_AUDIOONLY;
                    break;
                case PublishState_NONE_ONSTAGE:
                    tPublishState = PublishState_VIDEOONLY;
                    break;
                default:
                    break;
            }
            //[_iEduClassRoomSessionHandle sessionHandleEnableVideo:![_iEduClassRoomSessionHandle sessionHandleIsVideoEnabled]];
            //aButton.selected = [_iEduClassRoomSessionHandle sessionHandleIsVideoEnabled];
            
            // iPad端老师不通过VideoEnable来开关视频，直接发publish状态改变信令
            [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:tPublishState completion:nil];
            aButton.selected = (tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY);
            _iVideoImageView.hidden = !aButton.selected;
            
            if (!aButton.selected) {
                // 如果不播放视频，将背景图片移动至最上层
                [self bringSubviewToFront:_iVideoBackgroundImageView];
                [self bringSubviewToFront:_iVideoImageView];
                [self bringSubviewToFront:_iAudioImageView];
                [self bringSubviewToFront:_iDrawImageView];
                [self bringSubviewToFront:_iHandsUpImageView];
            } else {
                // 如果播放视频，将背景图片移动至最底层
                [self sendSubviewToBack:_iVideoBackgroundImageView];
            }
        }else{
            
            TKLog(@"授权涂鸦");
            if (_iRoomUser.publishState>1) {
                //[_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@((bool)(!_iRoomUser.canDraw)) completion:nil];
                [[TKEduSessionHandle shareInstance]configureDraw:!_iRoomUser.canDraw isSend:YES to:sTellAll peerID:_iRoomUser.peerID];
                
                ////[[TKEduWhiteBoardHandle shareTKEduWhiteBoardHandleInstance] setDrawable:!_iRoomUser.canDraw];
                aButton.selected =  !_iRoomUser.canDraw;
                _iDrawImageView.hidden = _iRoomUser.canDraw;
            }
        }
        
    }
    
    //_iEduClassRoomSessionHandle
  
}
-(void)videoSmallButton2:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    [self hideFunctionView];
    if ( ![_iPeerId isEqualToString:@""]) {
        if (aVideoRole == EVideoRoleTeacher) {
            TKLog(@"关闭音频");
            PublishState tPublishState = _iRoomUser.publishState;
            switch (tPublishState) {
                case PublishState_VIDEOONLY:
                    tPublishState = PublishState_BOTH;
                    break;
                case PublishState_AUDIOONLY:
                    tPublishState = PublishState_NONE_ONSTAGE;
                    break;
                case PublishState_BOTH:
                    tPublishState = PublishState_VIDEOONLY;
                    break;
                case PublishState_NONE_ONSTAGE:
                    tPublishState = PublishState_AUDIOONLY;
                    break;
                default:
                    break;
            }
            //[_iEduClassRoomSessionHandle sessionHandleEnableAudio:![_iEduClassRoomSessionHandle sessionHandleIsAudioEnabled]];
            //aButton.selected = ![_iEduClassRoomSessionHandle sessionHandleIsAudioEnabled];
            
            // iPad端老师不通过AudioEnable来开关视频，直接发publish状态改变信令
            [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:tPublishState completion:nil];
            aButton.selected = !(tPublishState == PublishState_AUDIOONLY || tPublishState == PublishState_BOTH);
            _iAudioImageView.hidden = aButton.selected;
                       
        }else{
            
            TKLog(@"下讲台");
            PublishState tPublishState = _iRoomUser.publishState;
            //BOOL isShowVideo = (tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY);
            BOOL isShowVideo = (tPublishState != PublishState_NONE);
            if (isShowVideo) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE completion:nil];
                // 助教始终有画笔权限
                if (_iRoomUser.role != UserType_Assistant) {
                    [[TKEduSessionHandle shareInstance]configureDraw:false isSend:true to:sTellAll peerID:_iRoomUser.peerID];
                    //[_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@(false) completion:nil];
                }

            } else {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_BOTH completion:nil];
            }
           
           // _iAudioImageView.hidden = !isShowVideo;
             aButton.selected = !isShowVideo;
        }
    }
    
}
-(void)videoSmallButton3:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    TKLog(@"关闭音频");
    [self hideFunctionView];
    if (![_iPeerId isEqualToString:@""]) {
        
        //_iCurrentPeerId = _iPeerId;
          BOOL isShowAudioImage = ( _iRoomUser.publishState == PublishState_AUDIOONLY || _iRoomUser.publishState== PublishState_BOTH);
        if (aVideoRole == UserType_Teacher) {
            [_iEduClassRoomSessionHandle sessionHandleEnableAudio:!isShowAudioImage];
            aButton.selected = isShowAudioImage;
            _iAudioImageView.hidden = !aButton.selected;
        }else{
            
            if (_iRoomUser.publishState == PublishState_NONE || _iRoomUser.publishState == PublishState_NONE_ONSTAGE) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_AUDIOONLY completion:nil];
                aButton.selected = YES;
                _iAudioImageView.hidden = !aButton.selected;
                 [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }else if (_iRoomUser.publishState == PublishState_AUDIOONLY){
                // 该状态下，音视频都关闭但在台上
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE_ONSTAGE completion:nil];
                aButton.selected = NO;
                _iAudioImageView.hidden = !aButton.selected;

            }else if (_iRoomUser.publishState == PublishState_BOTH){
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_VIDEOONLY completion:nil];
                aButton.selected = NO;
                _iAudioImageView.hidden = !aButton.selected;
            }else if(_iRoomUser.publishState == PublishState_VIDEOONLY){
                 [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_BOTH completion:nil];
                 aButton.selected = YES;
                 _iAudioImageView.hidden = !aButton.selected;
                [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }
            
        }
        
    }
    
}
-(void)videoSmallButton4:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    [self hideFunctionView];
    if (![_iPeerId isEqualToString:@""]) {
       
        TKEduSessionHandle *tSessionHandle = [TKEduSessionHandle shareInstance];
        TKEduRoomProperty *tRoomProperty = tSessionHandle.iRoomProperties;
        __weak typeof(self)weakSelf = self;
        RoomUser *tRoomUser = _iRoomUser;
        [TKEduNetManager sendGifForRoomUser:@[tRoomUser] roomID:tRoomProperty.iRoomId  aMySelf:tSessionHandle.localUser aHost:tRoomProperty.sWebIp aPort:tRoomProperty.sWebPort aSendComplete:^(id  _Nullable response) {
            __strong typeof(self)strongSelf = weakSelf;
            int currentGift = 0;
            if(tRoomUser && tRoomUser.properties && [tRoomUser.properties objectForKey:sGiftNumber])
                currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
            [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sGiftNumber Value:@(currentGift + 1) completion:nil];
            [strongSelf potStartAnimationForView:strongSelf];
           
            
        }aNetError:nil];
        TKLog(@"发奖励");
    }
    
}
-(void)videoSmallButton5:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    TKLog(@"关闭视频");
    [self hideFunctionView];
    if (![_iPeerId isEqualToString:@""]) {
        
        //_iCurrentPeerId = _iPeerId;
        BOOL isShowVideoImage = ( _iRoomUser.publishState == PublishState_VIDEOONLY || _iRoomUser.publishState== PublishState_BOTH);
        if (aVideoRole == UserType_Teacher) {
            [_iEduClassRoomSessionHandle sessionHandleEnableAudio:!isShowVideoImage];
            aButton.selected = isShowVideoImage;
            _iVideoImageView.hidden = !aButton.selected;
        }else{
            
            if (_iRoomUser.publishState == PublishState_NONE || _iRoomUser.publishState == PublishState_NONE_ONSTAGE) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_VIDEOONLY completion:nil];
                aButton.selected = YES;
                _iVideoImageView.hidden = !aButton.selected;
                [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }else if (_iRoomUser.publishState == PublishState_VIDEOONLY){
                // 这种情况下音视频都关闭，但还在台上
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE_ONSTAGE completion:nil];
                aButton.selected = NO;
                _iVideoImageView.hidden = !aButton.selected;
                
            }else if (_iRoomUser.publishState == PublishState_BOTH){
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_AUDIOONLY completion:nil];
                aButton.selected = NO;
                _iVideoImageView.hidden = !aButton.selected;
            }else if(_iRoomUser.publishState == PublishState_AUDIOONLY){
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_BOTH completion:nil];
                aButton.selected = YES;
                _iVideoImageView.hidden = !aButton.selected;
                [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }
            
        }
        
        if (!aButton.selected) {
            // 如果不播放视频，将背景图片移动至最上层
            [self bringSubviewToFront:_iVideoBackgroundImageView];
            
            [self bringSubviewToFront:_iVideoImageView];
            [self bringSubviewToFront:_iAudioImageView];
            [self bringSubviewToFront:_iDrawImageView];
            [self bringSubviewToFront:_iHandsUpImageView];
        } else {
            // 如果播放视频，将背景图片移动至最底层
            [self sendSubviewToBack:_iVideoBackgroundImageView];
        }
        
    }
}
-(void)videoSmallButton6:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{//分屏显示
    [self hideFunctionView];
    if (self.splitScreenClickBlock) {
        self.splitScreenClickBlock(aVideoRole);
    }
}
- (void)videoOneKeyReset{//全部恢复
    [self hideFunctionView];
    if (self.oneKeyResetBlock) {
        self.oneKeyResetBlock();
    }
}
#pragma mark 动画
- (void)potStartAnimationForView:(UIView *)view
{
    if (_iGiftAnimationView) {
        return;
    }
    _iGiftAnimationView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"icon_gift")];
    //animationView.backgroundColor = [UIColor yellowColor];
    _iGiftAnimationView.frame = CGRectMake(0, 0, 125, 100);
 
    _iGiftAnimationView.center = CGPointMake(ScreenW/2, ScreenH/2);
    [[UIApplication sharedApplication].keyWindow addSubview:_iGiftAnimationView];
  //- (CGPoint)convertPoint:(CGPoint)point fromView:(nullable UIView *)view;
    CGRect frame = [view convertRect:view.bounds toView:nil];
    [self transformForView:_iGiftAnimationView fromOldPoint:_iGiftAnimationView.layer.position toNewPoint:CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2)];
}
- (void)transformForView:(UIView *)d fromOldPoint:(CGPoint)oldPoint toNewPoint:(CGPoint)newPoint
{
    //上下移动
    CABasicAnimation*upDownAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    upDownAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(oldPoint.x, oldPoint.y+20)]; // 起始点
    upDownAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(oldPoint.x, oldPoint.y-20)]; // 终了点
    
    upDownAnimation.autoreverses = YES;
    upDownAnimation.fillMode = kCAFillModeBackwards;
    upDownAnimation.repeatCount = 2;  //重复次数       from到to
    upDownAnimation.duration = 0.3;    //一次时间
    [upDownAnimation setBeginTime:0.0];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.fromValue = [NSValue valueWithCGPoint:oldPoint];
    animation.toValue = [NSValue valueWithCGPoint:newPoint];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [animation setBeginTime:0.6];

    // 设定为缩放
    CABasicAnimation *animationScale2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animationScale2.duration = 1; // 动画持续时间
    animationScale2.repeatCount = 1; // 重复次数
   // animationScale2.autoreverses = YES; // 动画结束时执行逆动画
    animationScale2.removedOnCompletion = NO;
    animationScale2.fillMode = kCAFillModeForwards;
    // 缩放倍数
    animationScale2.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animationScale2.toValue = [NSNumber numberWithFloat:0.3]; // 结束时的倍率
    [animationScale2 setBeginTime:0.6];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = 1.6;
    //group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = [NSArray arrayWithObjects:upDownAnimation,animation,animationScale2, nil];
    [d.layer addAnimation:group forKey:@"move-scale-layer"];
    
}
#pragma mark CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _iGiftCount++;
    [_iGiftAnimationView removeFromSuperview];
    _iGiftAnimationView = nil;
    
    int currentGift = 0;
    if(_iRoomUser && _iRoomUser.properties && [_iRoomUser.properties objectForKey:sGiftNumber])
        currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
    
    [self.iGifButton setTitle:[NSString stringWithFormat:@"%@",@(currentGift)] forState:UIControlStateNormal];
    
}

#pragma mark private

-(void)changeAudioDisabledState {
    //self.iRoomUser.disableAudio = state;
    if (self.iRoomUser.disableAudio == YES) {
        self.iAudioImageView.image = LOADIMAGE(@"icon_audio_disabled");
        self.iAudioImageView.hidden = NO;
    } else {
        if (self.iRoomUser.publishState == 1 || self.iRoomUser.publishState == 3) {
            self.iAudioImageView.image = LOADIMAGE(@"icon_audio");
            self.iAudioImageView.hidden = NO;
        } else {
            self.iAudioImageView.image = LOADIMAGE(@"icon_audio");
            self.iAudioImageView.hidden = YES;
        }
    }
    
    // 未上课，不显示摄像头和话筒图标
    if ([TKEduSessionHandle shareInstance].isClassBegin == NO) {
        _iAudioImageView.hidden = YES;
        _iVideoImageView.hidden = YES;
    }
}

-(void)changeVideoDisabledState {
    //self.iRoomUser.disableVideo = state;
    if (self.iRoomUser.disableVideo == YES) {
        self.iVideoImageView.image = LOADIMAGE(@"icon_video_disabled");
        self.iVideoImageView.hidden = NO;
        
        [self bringSubviewToFront:_iVideoBackgroundImageView];      // 背景图片显示上来
        [self bringSubviewToFront:_iVideoImageView];
        [self bringSubviewToFront:_iAudioImageView];
        [self bringSubviewToFront:_iDrawImageView];
        [self bringSubviewToFront:_iHandsUpImageView];
        
    } else {
        if (self.iRoomUser.publishState == 2 || self.iRoomUser.publishState == 3) {
            self.iVideoImageView.image = LOADIMAGE(@"icon_video");
            self.iVideoImageView.hidden = NO;
            
            [self sendSubviewToBack:_iVideoBackgroundImageView];
        } else {
            self.iVideoImageView.image = LOADIMAGE(@"icon_video");
            self.iVideoImageView.hidden = YES;
            
            [self bringSubviewToFront:_iVideoBackgroundImageView];      // 背景图片显示上来
            [self bringSubviewToFront:_iVideoImageView];
            [self bringSubviewToFront:_iAudioImageView];
            [self bringSubviewToFront:_iDrawImageView];
            [self bringSubviewToFront:_iHandsUpImageView];
        }
    }
    
    // 未上课，不显示摄像头和话筒图标
    if ([TKEduSessionHandle shareInstance].isClassBegin == NO) {
        _iAudioImageView.hidden = YES;
        _iVideoImageView.hidden = YES;
    }
}

#pragma mark Wdeprecated
///** *  开始触摸，记录触点位置用于判断是拖动还是点击 */
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    // 获得触摸在根视图中的坐标
//    UITouch *touch = [touches anyObject];
//    _iStartPositon = [touch locationInView:_iRootView];
//}
///** *  手指按住移动过程,通过悬浮按钮的拖动事件来拖动整个悬浮窗口 */
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    // 获得触摸在根视图中的坐标
//    UITouch *touch = [touches anyObject];
//    CGPoint curPoint = [touch locationInView:_iRootView];
//    // 移动按钮到当前触摸位置
//    self.center = curPoint;
//}
///** *  拖动结束后使悬浮窗口吸附在最近的屏幕边缘 */
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    // 获得触摸在根视图中的坐标
//    UITouch *touch = [touches anyObject];
//    CGPoint curPoint = [touch locationInView:_iRootView];
//    // 通知代理,如果结束触点和起始触点极近则认为是点击事件
//    if (pow((_iStartPositon.x - curPoint.x),2) + pow((_iStartPositon.y - curPoint.y),2) < 1) {
//        //[self.btnDelegate dragButtonClicked:self];
//
//    }
//    // 与四个屏幕边界距离
//    CGFloat left = curPoint.x;
//    CGFloat right = ScreenW - curPoint.x;
//    CGFloat top = curPoint.y;
//    CGFloat bottom = ScreenH - curPoint.y;
//    // 计算四个距离最小的吸附方向
//    EDir minDir = EDirLeft;
//    CGFloat minDistance = left;
//    if (right < minDistance) {
//        minDistance = right;
//        minDir = EDirRight;
//    }
//    if (top < minDistance)
//    {        minDistance = top;
//        minDir = EDirTop;
//    }
//    if (bottom < minDistance) {
//        minDir = EDirBottom;
//    }
//    // 开始吸附
//    switch (minDir) {
//        case EDirLeft:
//            self.center = CGPointMake(self.frame.size.width/2, self.center.y);
//            break;
//        case EDirRight:
//            self.center = CGPointMake(ScreenW - self.frame.size.width/2, self.center.y);
//            break;
//        case EDirTop:
//            self.center = CGPointMake(self.center.x, self.frame.size.height/2);
//            break;
//        case EDirBottom:
//            self.center = CGPointMake(self.center.x, ScreenH - self.frame.size.height/2);
//            break;
//        default:
//            break;
//    }
//}
- (UIView *)sIsInBackGroundView{
    if (!_sIsInBackGroundView) {
        self.sIsInBackGroundView = [[[NSBundle mainBundle]loadNibNamed:@"TKBackGroundView" owner:nil options:nil] lastObject];
        self.sIsInBackGroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return _sIsInBackGroundView;
}


@end

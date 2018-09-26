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
@property (nonatomic, strong) UIView *bottomView;
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
        _originalWidth = frame.size.width;
        _originalHeight = frame.size.height;
        _videoRole = aVideoRole;
        _iVideoBackgroundImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_teacher_big")];
        CGFloat tVideoWidth     = CGRectGetWidth(frame);
        CGFloat tVideoHeigh     = self.frame.size.height;
//        tVideoWidth*3/4.0;
        _iVideoBackgroundImageView.frame        = CGRectMake(0, 0, tVideoWidth, tVideoHeigh);
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
            CGFloat tWidth = (aVideoRole != EVideoRoleTeacher?(CGRectGetWidth(frame)-30):CGRectGetWidth(frame));
            UILabel *tNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, tWidth, CGRectGetHeight(frame)-tVideoHeigh)];
            tNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            [tNameLabel adjustsFontSizeToFitWidth];
            tNameLabel.textColor = [UIColor whiteColor];
            tNameLabel.textAlignment = NSTextAlignmentLeft;
            tNameLabel;
        
        });
      
        
        _iBackgroundLabel =({
            CGFloat tWidth = (CGRectGetWidth(frame));
            UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,tVideoHeigh, tWidth, CGRectGetHeight(frame)-tVideoHeigh)];
            tLabel.backgroundColor =RGBACOLOR(0, 0, 0, 0.3);
            tLabel;
        
        });
        
        [self addSubview:_iVideoBackgroundImageView];
        [self addSubview:_iBackgroundLabel];
//        [self addSubview:_iNameLabel];
        
        
        _iGifButton = ({
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tButton.frame = CGRectMake(CGRectGetMaxX(_iNameLabel.frame), CGRectGetMinY(_iNameLabel.frame), 30, CGRectGetHeight(_iNameLabel.frame));
            tButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [tButton setImage:LOADIMAGE(@"icon_gift") forState:UIControlStateNormal];
            [tButton setTitleColor:RGBCOLOR(240,207,46)forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(11);
            tButton.hidden = YES;

            tButton;
            
        });
        
        CGFloat tVideoImageWidth = (tVideoWidth-6)/8.0;
        _iVideoImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_video")];
            tImageView.frame        = CGRectMake(0, 0, tVideoImageWidth, tVideoImageWidth);
            tImageView;
            
        });
        _iAudioImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_audio")];
            tImageView.frame        = CGRectMake((aVideoRole == EVideoRoleTeacher) ? 0 : tVideoImageWidth, 0, tVideoImageWidth, tVideoImageWidth);
            tImageView;
          
            
        });
        _iDrawImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_tools")];
            tImageView.frame        = CGRectMake(tVideoImageWidth*2, 0, tVideoImageWidth, tVideoImageWidth);
            tImageView;
            
        });
       
        _iHandsUpImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_hand")];
            tImageView.frame        = CGRectMake(tVideoWidth-tVideoImageWidth-3, 0, tVideoImageWidth, tVideoImageWidth);
            
            tImageView;
            
        });
//        CGRectMake(0,0, tWidth, CGRectGetHeight(frame)-tVideoHeigh)
        self.bottomView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.7;
            view;
        });
        
        [self addSubview:_iVideoImageView];
        [self addSubview:_iAudioImageView];
        [self addSubview:_iDrawImageView];
        [self addSubview:_iHandsUpImageView];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.iNameLabel];
        if (aVideoRole != EVideoRoleTeacher) {[self.bottomView addSubview:_iGifButton];}
        _iVideoImageView.hidden    = YES;
        _iAudioImageView.hidden    = YES;
        _iDrawImageView.hidden     = YES;
        _iHandsUpImageView.hidden  = YES;
        
         _iFunctionButton = ({
             
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
             tButton.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
             [tButton addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
             tButton.backgroundColor = [UIColor clearColor];

            tButton;
            
        });
         [self addSubview:_iFunctionButton];

        // 缩放手势
        UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchSelf:)];
        [self addGestureRecognizer:pinchGR];
    }
    return self;
}

-(void)layoutSubviews{
    
    [self bringSubviewToFront:_iFunctionButton];
    [self bringSubviewToFront:self.bottomView];
    
    // 分屏下布局
    CGFloat videoSmallWidth  = CGRectGetWidth(self.frame);
    
    CGFloat videoSmallHeight = CGRectGetHeight(self.frame);
    
    self.currentWidth = videoSmallWidth;
    self.currentHeight = videoSmallHeight;
    
    CGFloat tVideoWidth     = videoSmallWidth;
    
    CGFloat tVideoHeigh     = self.isSplit?videoSmallHeight-30:videoSmallHeight/7.0*6;
    
    _iVideoBackgroundImageView.frame        =CGRectMake(0, 0, tVideoWidth, videoSmallHeight);
//    CGRectMake(0, 0, tVideoWidth, tVideoHeigh);
    
    _iVideoBackgroundImageView.contentMode = UIViewContentModeCenter;
    
    _sIsInBackGroundView.frame = CGRectMake(0, 0, videoSmallWidth, videoSmallHeight);
    
    _iVideoFrame =  CGRectMake(0, 0, tVideoWidth, tVideoHeigh);
    
    
    _iRealVideoView.frame = _iVideoFrame;
    CGFloat tWidth = videoSmallWidth-30;
    
    self.bottomView.frame =  CGRectMake(0,tVideoHeigh, tVideoWidth, videoSmallHeight-tVideoHeigh);
    
    _iNameLabel.frame = CGRectMake(0,0, tWidth, videoSmallHeight-tVideoHeigh);
    if (_iNameLabel.text) {
        int currentFontSize = [TKUtil getCurrentFontSize:CGSizeMake(_iNameLabel.frame.size.width, _iNameLabel.frame.size.height) withString:_iNameLabel.text];
        if (currentFontSize>12) {
            currentFontSize = 12;
        }
        [_iNameLabel setFont:TKFont(currentFontSize)];
    }
    _iGifButton.frame = CGRectMake(CGRectGetMaxX(_iNameLabel.frame)-10, 0, 40, CGRectGetHeight(_iNameLabel.frame));
    _iGifButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (_iGifButton.titleLabel.text) {
        int gifFontSize = [TKUtil getCurrentFontSize:CGSizeMake(_iGifButton.frame.size.width, _iGifButton.frame.size.height) withString:_iGifButton.titleLabel.text];
        if (gifFontSize>11) {
            gifFontSize = 11;
        }
        _iGifButton.titleLabel.font = TKFont(gifFontSize);
    }
    
    _iBackgroundLabel.frame = CGRectMake(0,tVideoHeigh, tVideoWidth, CGRectGetHeight(self.frame)-tVideoHeigh);
    
    
    CGFloat tVideoImageWidth = self.isSplit?30:(tVideoWidth-6)/8.0;
    //todo
    _iVideoImageView.frame        = CGRectMake(0, 0, tVideoImageWidth, tVideoImageWidth);
    
    _iAudioImageView.frame        = CGRectMake((_videoRole == EVideoRoleTeacher) ? 0 : tVideoImageWidth, 0, tVideoImageWidth, tVideoImageWidth);
    _iAudioImageView.frame        = CGRectMake(tVideoImageWidth, 0, tVideoImageWidth, tVideoImageWidth);
    
    _iDrawImageView.frame        = CGRectMake(tVideoImageWidth*2, 0, tVideoImageWidth, tVideoImageWidth);
    
    _iHandsUpImageView.frame        = CGRectMake(tVideoWidth-tVideoImageWidth-3, 0, tVideoImageWidth, tVideoImageWidth);
    
    _iFunctionButton.frame = CGRectMake(0, 0, videoSmallWidth, videoSmallHeight);
    
    
    if (self.finishScaleBlock) {
        self.finishScaleBlock();
    }
}

-(void)setIsNeedFunctionButton:(BOOL)isNeedFunctionButton{
    _iFunctionButton.enabled = isNeedFunctionButton;
}
-(void)setIRoomUser:(TKRoomUser *)iRoomUser{
    
    BOOL isShowAudioImage = ( iRoomUser.publishState == PublishState_AUDIOONLY ||
                             iRoomUser.publishState== PublishState_BOTH);
    BOOL isShowVideoImage = (iRoomUser.publishState == PublishState_BOTH ||
                             iRoomUser.publishState == PublishState_VIDEOONLY);
    if (iRoomUser) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshRaiseHandUI:) name:[NSString stringWithFormat:@"%@%@",sRaisehand,iRoomUser.peerID] object:nil];
        _iGifButton.hidden = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inBackground:) name:[NSString stringWithFormat:@"%@%@",sIsInBackGround,iRoomUser.peerID] object:nil];
        
    }else{
        
        //删除前一个
        [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%@%@",sRaisehand,_iRoomUser.peerID] object:nil];
        
        _iGifButton.hidden = YES;
        
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%@%@",sIsInBackGround,_iRoomUser.peerID] object:nil];
        
    }
    [self bringSubviewToFront:_iVideoImageView];
    [self bringSubviewToFront:_iAudioImageView];
    [self bringSubviewToFront:_iDrawImageView];
    [self bringSubviewToFront:_iHandsUpImageView];
    [self bringSubviewToFront:self.bottomView];
    
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
//todo
    _iAudioImageView.hidden = (iRoomUser.role == UserType_Teacher)?YES:!isShowAudioImage;
    _iAudioImageView.hidden = !isShowAudioImage;
    _iVideoImageView.hidden = !isShowVideoImage;
    _iDrawImageView.hidden  = !iRoomUser.canDraw || (iRoomUser.publishState == PublishState_NONE) || (iRoomUser.role == UserType_Teacher) ;
    
    _iHandsUpImageView.hidden  = ![[iRoomUser.properties objectForKey:sRaisehand] boolValue]|| (iRoomUser.role == UserType_Teacher);
    
    // 根据用户disableAudio和disableVideo去设置图片
    [self changeAudioDisabledState];
    [self changeVideoDisabledState];
    
    [self refreshBackLogoImage];
    
    
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
    PublishState tPublishState = (PublishState)[[tDic objectForKey:sPublishstate]integerValue];
    BOOL tAudioImageShow = !(tPublishState  == PublishState_BOTH || tPublishState == PublishState_AUDIOONLY );
    //todo
    _iAudioImageView.hidden = tAudioImageShow;
    
    BOOL tVideoImageShow = !(tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY);
    _iVideoImageView.hidden = tVideoImageShow;
    
    BOOL tHandsUpImageShow = (![[tDic objectForKey:sRaisehand]boolValue]);
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
        [self changeVideoDisabledState2];
    }
    [self changeAudioDisabledState];
    [self changeVideoDisabledState2];
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
    
    
    [self refreshBackLogoImage];

    
   
}
-(void)functionButtonClicked:(UIButton *)aButton{
   
    if ([[TKEduSessionHandle shareInstance] localUser].publishState == PublishState_NONE ||[[TKEduSessionHandle shareInstance] localUser].publishState ==  PublishState_Local_NONE) {
        return;
    }
    
    if (![[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].allowStudentCloseAV && [TKEduSessionHandle shareInstance].localUser.role == UserType_Student) {
        return;
    }
    if (![TKEduSessionHandle shareInstance].isClassBegin && [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher && ![_iPeerId isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID]) {
        return;
    }
    
    if (!_iPeerId || [_iPeerId isEqualToString:@""] || ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student && [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].allowStudentCloseAV == NO) || ([TKEduSessionHandle shareInstance].localUser.role != UserType_Teacher && ![_iPeerId isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID]))
        return;
    
    
    CGFloat functionY =  55*Proportion+(ScreenW-10*8)/7/4*3;
    TKEduSessionHandle *tSessionHandle = [TKEduSessionHandle shareInstance];
    TKEduRoomProperty *tRoomProperty = tSessionHandle.iRoomProperties;
   
    if (!_iFunctionView) {
        [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
        switch (_iVideoRole) {
            case EVideoRoleTeacher:{//老师
                //修改部分
                CGRect functionViewFrame;
                
                if ([tRoomProperty.iPadLayout isEqualToString:SHARKTOP_COMPANY]) {//判断是什么模板
                    if (self.isSplit) {
                        functionViewFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)+functionY, 320, 70);
                    }else{
                        functionViewFrame= CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)-70, 320, 70);
                    }
                    
                    _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:functionViewFrame withType:0 aVideoRole:EVideoRoleTeacher aRoomUer:_iRoomUser isSplit:self.isSplit];
                }else{
                    
                    functionViewFrame = CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 320, 70);
                    
                    _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:functionViewFrame withType:1 aVideoRole:EVideoRoleTeacher aRoomUer:_iRoomUser isSplit:self.isSplit];
                }
                
                
                
                self.iFunctionView.iDelegate = self;
                
                _iFunctionView.isSplitScreen = self.isSplit;
                
                break;
            }
            case EVideoRoleOur:{//自己
                //修改部分
                _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 320, 70) withType:1 aVideoRole:EVideoRoleOur aRoomUer:_iRoomUser isSplit:self.isSplit];
                _iFunctionView.iDelegate = self;
                break;
                
            }
            default:{//学生及其他人
                
//                _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_user_small");
                
                CGRect functionViewFrame;
                if ([tRoomProperty.iPadLayout isEqualToString:SHARKTOP_COMPANY]) {//判断是什么模板
                    
                    if (!self.isSplit) {
                        functionViewFrame = CGRectMake(CGRectGetMinX(self.frame)-140, CGRectGetMinY(self.frame)-70, 360, 70);
                        
                    }else{
                        functionViewFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)+functionY, 360, 70);
                        
                    }
                    
                    if (self.isDrag) {
                        functionViewFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)-70, 360, 70);
                    }else if(!self.isSplit){
                        //修改超出边界的问题 上边无用？需要确定
                        if (ScreenW-CGRectGetMaxX(self.frame) > 360) {
                            //修改超出边界的问题
                            functionViewFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)-70, 360, 70);
                            
                        }
                        NSLog(@"%f",ScreenW-CGRectGetMaxX(self.frame));
                        if (ScreenW-CGRectGetMinX(self.frame) < 360) {
                            functionViewFrame = CGRectMake(ScreenW-360, CGRectGetMinY(self.frame)-70, 360, 70);
                        }
                    }
                    
                  
                }else{
                    if (!self.isSplit) {
                        functionViewFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)-70, 360, 70);
                        
                    }else{
                        functionViewFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)+70, 360, 70);
                        
                    }
                }
               
                _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:functionViewFrame withType:0 aVideoRole:EVideoRoleOther aRoomUer:_iRoomUser isSplit:self.isSplit];
                
                _iFunctionView.isSplitScreen = self.isSplit;
                
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
//    [self bringSubviewToFront:_iNameLabel];
    [self bringSubviewToFront:self.bottomView];
    [self bringSubviewToFront:_iFunctionButton];
    
    if (!aName || [aName isEqualToString:@""]) {
        return;
    }
    NSAttributedString * attrStr =  [[NSAttributedString alloc]initWithData:[aName dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    _iNameLabel.text = attrStr.string ;
}

-(void)clearVideoData{
    _iPeerId = @"";
    self.iRoomUser = nil;
    _isDrag = NO;
    _isSplit = NO;
    
    [self changeName:@""];
    [_iRealVideoView removeFromSuperview];
    _iRealVideoView = nil;
    _iGifButton.hidden = YES;
}

-(void)addVideoView:(UIView*)view{
    
    [self insertSubview:view aboveSubview:_iVideoBackgroundImageView];
}

- (void)changeVideoSize:(CGFloat)scale {
    CGFloat width = self.originalWidth * scale;
    if (width < self.originalWidth) {
        // 无法缩小至比初始化大小还小
        return;
    }
    
    if (self.onRemoteMsgResizeVideoViewBlock) {
        self.frame = self.onRemoteMsgResizeVideoViewBlock(scale);
        [self setNeedsLayout];
    }
}

#pragma mark Action
- (void)pinchSelf:(UIPinchGestureRecognizer *)gestureRecognizer {
    // 巡课不允许缩放
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        return;
    }
    
    if (![TKEduSessionHandle shareInstance].iIsCanDraw ) {
        
            return;
        
    }
    
    // 没有拖出去不允许缩放
    if (self.isDrag == NO) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint center = self.center;
        CGRect newframe = self.frame;
        CGFloat height = newframe.size.height * gestureRecognizer.scale;
        CGFloat width = newframe.size.width * gestureRecognizer.scale;
        if (width < self.originalWidth) {
            // 无法缩小至比初始化大小还小
            return;
        }
        
        // 保证不超出白板
        if (self.isWhiteboardContainsSelfBlock) {
            if(self.isWhiteboardContainsSelfBlock() == NO) {
                if (gestureRecognizer.scale >= 1.0) {
                    return;
                }
            }
        }
        
        self.frame = CGRectMake(center.x - width/2.0, center.y - height/2.0, width, height);
        [self setNeedsLayout];
        gestureRecognizer.scale = 1;
        
        // 只有老师发送缩放信令
        if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
            NSDictionary *tDict = @{@"ScaleVideoData":
                                        @{self.iRoomUser.peerID:
                                              @{@"scale":@(width/self.originalWidth)}
                                          }
                                    };
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sVideoZoom ID:sVideoZoom To:sTellAllExpectSender Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.isWhiteboardContainsSelfBlock) {
            if(self.isWhiteboardContainsSelfBlock() == NO) {
                if (self.resizeVideoViewBlock) {
                    self.frame = self.resizeVideoViewBlock();
                    [self setNeedsLayout];
                    
                    // 只有老师发送缩放信令
                    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
                        NSDictionary *tDict = @{@"ScaleVideoData":
                                                    @{self.iRoomUser.peerID:
                                                          @{@"scale":@(self.frame.size.width/self.originalWidth)}
                                                      }
                                                };
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDict options:NSJSONWritingPrettyPrinted error:nil];
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sVideoZoom ID:sVideoZoom To:sTellAllExpectSender Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
                    }
                }
            }
        }
    }
}

#pragma mark VideolistProtocol
-(void)videoSmallbutton1:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    [self hideFunctionView];
    if ( ![_iPeerId isEqualToString:@""]) {
       // _iCurrentPeerId = _iPeerId;
        if (aVideoRole == EVideoRoleTeacher) {
            TKLog(@"关闭视频");
            PublishState tPublishState = (PublishState)_iRoomUser.publishState;
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
                [self bringSubviewToFront:self.bottomView];
            } else {
                // 如果播放视频，将背景图片移动至最底层
                [self sendSubviewToBack:_iVideoBackgroundImageView];
            }
        }else{
            
            TKLog(@"授权涂鸦");
            if (_iRoomUser.publishState>1) {
                [[TKEduSessionHandle shareInstance]configureDraw:!_iRoomUser.canDraw isSend:YES to:sTellAll peerID:_iRoomUser.peerID];
                
                aButton.selected =  !_iRoomUser.canDraw;
                _iDrawImageView.hidden = _iRoomUser.canDraw;
            }
        }
        
    }
    
  
}
-(void)videoSmallButton2:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    [self hideFunctionView];
    if ( ![_iPeerId isEqualToString:@""]) {
        if (aVideoRole == EVideoRoleTeacher) {
            TKLog(@"关闭音频");
            PublishState tPublishState = (PublishState)_iRoomUser.publishState;
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
            
            // iPad端老师不通过AudioEnable来开关视频，直接发publish状态改变信令
            [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:tPublishState completion:nil];
            aButton.selected = !(tPublishState == PublishState_AUDIOONLY || tPublishState == PublishState_BOTH);
            //todo
            _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:aButton.selected;
            _iAudioImageView.hidden = aButton.selected;
                       
        }else{
            
            TKLog(@"下讲台");
            PublishState tPublishState = (PublishState)_iRoomUser.publishState;
            //BOOL isShowVideo = (tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY);
            BOOL isShowVideo = (tPublishState != PublishState_NONE);
            if (isShowVideo) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE completion:nil];
                // 助教始终有画笔权限
                if (_iRoomUser.role != UserType_Assistant) {
                    [[TKEduSessionHandle shareInstance]configureDraw:false isSend:true to:sTellAll peerID:_iRoomUser.peerID];
                }

            } else {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_BOTH completion:nil];
            }
           
             aButton.selected = !isShowVideo;
        }
    }
    
}
-(void)videoSmallButton3:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    TKLog(@"关闭音频");
    [self hideFunctionView];
    if (![_iPeerId isEqualToString:@""]) {
        
          BOOL isShowAudioImage = ( _iRoomUser.publishState == PublishState_AUDIOONLY || _iRoomUser.publishState== PublishState_BOTH);
        if (aVideoRole == UserType_Teacher) {
            [_iEduClassRoomSessionHandle sessionHandleEnableAudio:!isShowAudioImage];
            aButton.selected = isShowAudioImage;
            //todo
            _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
            _iAudioImageView.hidden = aButton.selected;
        }else{
            
            if (_iRoomUser.publishState == PublishState_NONE || _iRoomUser.publishState == PublishState_NONE_ONSTAGE) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_AUDIOONLY completion:nil];
                aButton.selected = YES;
                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
                 [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }else if (_iRoomUser.publishState == PublishState_AUDIOONLY){
                // 该状态下，音视频都关闭但在台上
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE_ONSTAGE completion:nil];
                aButton.selected = NO;
                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;

            }else if (_iRoomUser.publishState == PublishState_BOTH){
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_VIDEOONLY completion:nil];
                aButton.selected = NO;
                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
            }else if(_iRoomUser.publishState == PublishState_VIDEOONLY){
                 [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_BOTH completion:nil];
                 aButton.selected = YES;
                 _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
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
        TKRoomUser *tRoomUser = _iRoomUser;
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
            [self bringSubviewToFront:self.bottomView];
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
    _iGiftAnimationView.frame = CGRectMake(0, 0, 125, 100);
 
    _iGiftAnimationView.center = CGPointMake(ScreenW/2, ScreenH/2);
    [[UIApplication sharedApplication].keyWindow addSubview:_iGiftAnimationView];
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
- (void)animationDidStart:(CAAnimation *)anim
{
    //奖杯声音播放
//    NSString *pcmFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//    pcmFilePath = [pcmFilePath stringByAppendingPathComponent:@"ABC.wav"];
//    [[TKEduSessionHandle shareInstance].roomMgr startPlayingAudioFile:pcmFilePath loop:false fileFormat:7];

    //动画开始的时候 播放声音
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL result = [fileManager fileExistsAtPath:pcmFilePath];
//    
//    if (result) {
//      [[TKUtil shareInstance] playVoiceWithFileURL:pcmFilePath];
//    }

}

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
        //todo
        self.iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:NO;
        self.iAudioImageView.hidden = YES;
        
    } else {
        
        if (self.iRoomUser.publishState == PublishState_AUDIOONLY || self.iRoomUser.publishState == PublishState_BOTH) {
            //todo
            self.iAudioImageView.image = LOADIMAGE(@"icon_audio");
            self.iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:NO;
            self.iAudioImageView.hidden = NO;
            [self bringSubviewToFront:self.iAudioImageView];
        } else {
            self.iAudioImageView.image = LOADIMAGE(@"icon_audio");
            self.iAudioImageView.hidden = YES;
        }
    }
    
//    // 未上课，不显示摄像头和话筒图标
//    if ([TKEduSessionHandle shareInstance].isClassBegin == NO && ![TKEduSessionHandle shareInstance].roomMgr.beforeClassPubVideoFlag) {
//        _iAudioImageView.hidden = YES;
//        _iVideoImageView.hidden = YES;
//    }
}

-(void)changeVideoDisabledState {
    //self.iRoomUser.disableVideo = state;
    
    if (self.iRoomUser.disableVideo == YES) {
        self.iVideoImageView.image = LOADIMAGE(@"icon_video_disabled");
        self.iVideoImageView.hidden = NO;
        
//        [self bringSubviewToFront:_iVideoBackgroundImageView];      // 背景图片显示上来
        [self bringSubviewToFront:_iVideoImageView];
        [self bringSubviewToFront:_iAudioImageView];
        [self bringSubviewToFront:_iDrawImageView];
        [self bringSubviewToFront:_iHandsUpImageView];
        [self bringSubviewToFront:self.bottomView];
        
    } else {
        if (self.iRoomUser.publishState == 2 || self.iRoomUser.publishState == 3) {
            self.iVideoImageView.image = LOADIMAGE(@"icon_video");
            self.iVideoImageView.hidden = NO;
            [self bringSubviewToFront:_iVideoImageView];
            [self sendSubviewToBack:_iVideoBackgroundImageView];
            
        } else {
            self.iVideoImageView.image = LOADIMAGE(@"icon_video");
            self.iVideoImageView.hidden = YES;
            
//            [self bringSubviewToFront:_iVideoBackgroundImageView];      // 背景图片显示上来
            [self bringSubviewToFront:_iVideoImageView];
            [self bringSubviewToFront:_iAudioImageView];
            [self bringSubviewToFront:_iDrawImageView];
            [self bringSubviewToFront:_iHandsUpImageView];
            [self bringSubviewToFront:self.bottomView];
        }
    }
    if (self.iRoomUser.publishState == PublishState_Local_NONE) {//0：未发布，1：发布音频；2：发布视频；3：发布音视频
        [self sendSubviewToBack:_iVideoBackgroundImageView];
    }
}
-(void)changeVideoDisabledState2 {
    //self.iRoomUser.disableVideo = state;
    if (self.iRoomUser.disableVideo == YES) {
        self.iVideoImageView.image = LOADIMAGE(@"icon_video_disabled");
        self.iVideoImageView.hidden = NO;
        
                [self bringSubviewToFront:_iVideoBackgroundImageView];      // 背景图片显示上来
        [self bringSubviewToFront:_iVideoImageView];
        [self bringSubviewToFront:_iAudioImageView];
        [self bringSubviewToFront:_iDrawImageView];
        [self bringSubviewToFront:_iHandsUpImageView];
        [self bringSubviewToFront:self.bottomView];
        
    } else {
        if (self.iRoomUser.publishState == 2 || self.iRoomUser.publishState == 3) {
            self.iVideoImageView.image = LOADIMAGE(@"icon_video");
            self.iVideoImageView.hidden = NO;
            [self bringSubviewToFront:_iVideoImageView];
            [self sendSubviewToBack:_iVideoBackgroundImageView];
        } else {
            self.iVideoImageView.image = LOADIMAGE(@"icon_video");
            self.iVideoImageView.hidden = YES;
            
                        [self bringSubviewToFront:_iVideoBackgroundImageView];      // 背景图片显示上来
            [self bringSubviewToFront:_iVideoImageView];
            [self bringSubviewToFront:_iAudioImageView];
            [self bringSubviewToFront:_iDrawImageView];
            [self bringSubviewToFront:_iHandsUpImageView];
            [self bringSubviewToFront:self.bottomView];
        }
    }
    if (self.iRoomUser.publishState == PublishState_Local_NONE) {//0：未发布，1：发布音频；2：发布视频；3：发布音视频
        [self sendSubviewToBack:_iVideoBackgroundImageView];
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
        [self setBackgroundLabelContent];
    }
    [self setBackgroundLabelContent];
    return _sIsInBackGroundView;
}

- (void)setBackgroundLabelContent {
    if (_iRoomUser.role == UserType_Student) {
        [_sIsInBackGroundView setContent:MTLocalized(@"State.isInBackGround")];
    }
    if (_iRoomUser.role == UserType_Teacher) {
        [_sIsInBackGroundView setContent:MTLocalized(@"State.teacherInBackGround")];
    }
}

- (void)refreshBackLogoImage{
    switch (self.iRoomUser.publishState) {
        case PublishState_NONE:
        {
            if (self.iVideoViewTag == -1) {
                
                _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_teacher_big");
            }else if (self.iVideoViewTag == -2){
                
                _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_user_big");
            }else{
                _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_user_small");
                
            }
        }
            
            break;
        case PublishState_AUDIOONLY:
        case PublishState_VIDEOONLY:
        case PublishState_BOTH:
        case PublishState_NONE_ONSTAGE:////音视频都没有但还在台上
        case PublishState_Local_NONE:
        {
            if (self.iRoomUser.hasVideo) {
                //1v1显示大图、1vn标准模板下老师 显示大图，其余情况显示小图
                if (([TKEduSessionHandle shareInstance].iRoomProperties.iRoomType == RoomType_OneToOne) || (![[TKEduSessionHandle shareInstance].iRoomProperties.iPadLayout isEqualToString:SHARKTOP_COMPANY] && _videoRole == UserType_Teacher) ) {
                    
                    _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_videoClose_big");
                    
                }else if([[TKEduSessionHandle shareInstance].iRoomProperties.iMaxVideo intValue]<=7){
                    
                    _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_videoClose_small");
                }else{
                    
                    _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_videoClose_mini");
                }
                
                
            }else{
                //1v1显示大图、1vn标准模板下老师 显示大图，其余情况显示小图
                if (([TKEduSessionHandle shareInstance].iRoomProperties.iRoomType == RoomType_OneToOne) || (![[TKEduSessionHandle shareInstance].iRoomProperties.iPadLayout isEqualToString:SHARKTOP_COMPANY] && _videoRole == UserType_Teacher) ) {
                    
                    _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_noVideo_big");
                }else if([[TKEduSessionHandle shareInstance].iRoomProperties.iMaxVideo intValue]<=7){
                    
                    _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_noVideo_small");
                }else{
                    
                    _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_noVideo_mini");
                }
            }
        }
            break;
        default:
            break;
    }
    
}
@end

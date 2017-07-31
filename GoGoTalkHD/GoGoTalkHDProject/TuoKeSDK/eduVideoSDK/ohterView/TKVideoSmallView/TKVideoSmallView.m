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
//214*140  214*120 214*20
//214*140  214*120 214*20
//120*112  120*90  120*22

static const CGFloat sVideoSmallNameLabelHeight = 22;

@interface TKVideoSmallView ()<VideolistProtocol,CAAnimationDelegate>
@property(nonatomic,retain)TKVideoFunctionView *iFunctionView;
@property(nonatomic,assign)EVideoRole iVideoRole;
/** *  画笔 */
@property (nonatomic, strong) UIImageView * _Nullable iDrawImageView;
/** *  音频 */
@property (nonatomic, strong) UIImageView * _Nullable iAudioImageView;
/** *  举手 */
@property (nonatomic, strong) UIImageView * _Nullable iHandsUpImageView;

//gift
@property (nonatomic, strong) UIImageView *iGiftAnimationView;
@property (nonatomic, assign) NSInteger iGiftCount;

@end


@implementation TKVideoSmallView

//super override
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame aVideoRole:EVideoRoleTeacher];
}
-(instancetype)initWithFrame:(CGRect)frame aVideoRole:(EVideoRole)aVideoRole{
    if (self = [super initWithFrame:frame]) {
        //[iRootView addSubview:self];
        self.backgroundColor = RGBCOLOR(47, 47, 47);
        CGFloat tVideoWidth     = CGRectGetWidth(frame);
       // CGFloat tVideoHeigh     = CGRectGetHeight(frame)-sVideoSmallNameLabelHeight*Proportion;
        CGFloat tVideoHeigh     = tVideoWidth*3/4.0;
        _iVideoBackgroundImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_teacher_big")];
        _iVideoBackgroundImageView.frame        = CGRectMake(0, 0, tVideoWidth, tVideoHeigh);
        _iVideoBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewContentModeBottom;
        
        _iVideoFrame =  CGRectMake(0, 0, tVideoWidth, tVideoHeigh);
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
            CGFloat tWidth = (aVideoRole != EVideoRoleTeacher?(CGRectGetWidth(frame)-48):CGRectGetWidth(frame));
            
            UILabel *tNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,tVideoHeigh, tWidth, CGRectGetHeight(frame)-tVideoHeigh)];
            
            [tNameLabel setFont:TKFont(12)];
            tNameLabel.textColor = [UIColor whiteColor];
            //tNameLabel.text = @"笑笑";
            
            //tNameLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
            //tNameLabel.backgroundColor = [UIColor yellowColor];
            tNameLabel.textAlignment = NSTextAlignmentLeft;
            //tNameLabel.hidden = YES;
            tNameLabel;
        
        });
      
        
        UILabel *tBackgroundLabel =({
            CGFloat tWidth = (CGRectGetWidth(frame));
            
            UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,tVideoHeigh, tWidth, CGRectGetHeight(frame)-tVideoHeigh)];
            tLabel.backgroundColor =RGBACOLOR(0, 0, 0, 0.3);
            tLabel;
        
        });
        
        [self addSubview:_iVideoBackgroundImageView];
        [self addSubview:tBackgroundLabel];
        [self addSubview:_iNameLabel];
        
        
        _iGifButton = ({
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tButton.frame = CGRectMake(CGRectGetMaxX(_iNameLabel.frame), CGRectGetMinY(_iNameLabel.frame), 48, CGRectGetHeight(_iNameLabel.frame));
            
            tButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [tButton setImage:LOADIMAGE(@"icon_gift") forState:UIControlStateNormal];
            [tButton setTitleColor:RGBCOLOR(240,207,46)forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(11);
            tButton.hidden = YES;

            tButton;
            
        });
        CGFloat tVideoImageWidth = (tVideoWidth-6)/8.0;
        _iAudioImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_audio")];
            tImageView.frame        = CGRectMake(0, 0, tVideoImageWidth, tVideoImageWidth);
            tImageView;
            
        });
        _iDrawImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_tools")];
            tImageView.frame        = CGRectMake(tVideoImageWidth*2+3, 0, tVideoImageWidth, tVideoImageWidth);
            tImageView;
            
        });
       
        _iHandsUpImageView = ({
            
            UIImageView *tImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_hand")];
            tImageView.frame        = CGRectMake(tVideoWidth-tVideoImageWidth-3, 0, tVideoImageWidth, tVideoImageWidth);
            
            tImageView;
            
        });
        [self addSubview:_iAudioImageView];
        [self addSubview:_iDrawImageView];
        [self addSubview:_iHandsUpImageView];
        
       
        if (aVideoRole != EVideoRoleTeacher) {[self addSubview:_iGifButton];}
        _iAudioImageView.hidden    = YES;
        _iDrawImageView.hidden     = YES;
        _iHandsUpImageView.hidden  = YES;
        
         _iFunctionButton = ({
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
             tButton.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
             [tButton addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

            tButton;
            
            
        });
         [self addSubview:_iFunctionButton];

    }
    return self;
}

-(void)setIsNeedFunctionButton:(BOOL)isNeedFunctionButton{
    _iFunctionButton.enabled = isNeedFunctionButton;
}
-(void)setIRoomUser:(RoomUser *)iRoomUser{
    
     BOOL isShowAudioImage = ( iRoomUser.publishState == PublishState_AUDIOONLY || iRoomUser.publishState== PublishState_BOTH);
    if (iRoomUser) {
//         [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%@%@",sRaisehand,user.peerID] object:@(_iIsRaiseHandUp)];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshRaiseHandUI:) name:[NSString stringWithFormat:@"%@%@",sRaisehand,iRoomUser.peerID] object:nil];
        _iGifButton.hidden = NO;
        
    }else{
        // [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%@%@",sRaisehand,user.peerID] object:@(_iIsRaiseHandUp)];
        //删除前一个
        [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%@%@",sRaisehand,_iRoomUser.peerID] object:nil];
        
        _iGifButton.hidden = YES;
    }
      [self bringSubviewToFront:_iAudioImageView];
      [self bringSubviewToFront:_iDrawImageView];
      [self bringSubviewToFront:_iHandsUpImageView];
    
   
    _iRoomUser = iRoomUser;
    int currentGift = 0;
    if(iRoomUser && iRoomUser.properties && [iRoomUser.properties objectForKey:sGiftNumber])
        currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
    [_iGifButton setTitle:[NSString stringWithFormat:@"%@",@(currentGift)] forState:UIControlStateNormal];
    
    _iAudioImageView.hidden    = !isShowAudioImage;
    _iDrawImageView.hidden    = !iRoomUser.canDraw || (iRoomUser.publishState == PublishState_NONE)|| (iRoomUser.role == UserType_Teacher) ;
    
    _iHandsUpImageView.hidden  = ![[iRoomUser.properties objectForKey:sRaisehand] boolValue]|| (iRoomUser.role == UserType_Teacher);
    
}

-(void)refreshRaiseHandUI:(NSNotification *)aNotification{
    NSDictionary *tDic = (NSDictionary *)aNotification.object;
    PublishState tPublishState = [[tDic objectForKey:sPublishstate]integerValue];
    BOOL tAudioImageShow = !(tPublishState  == PublishState_BOTH || tPublishState == PublishState_AUDIOONLY );
    _iAudioImageView.hidden = tAudioImageShow;

     BOOL tHandsUpImageShow = (_iRoomUser.role == UserType_Teacher) ||([TKEduSessionHandle shareInstance].localUser.role ==UserType_Student)|| (![[tDic objectForKey:sRaisehand]boolValue]);
    _iHandsUpImageView.hidden = tHandsUpImageShow;
    
    BOOL tDrawImageShow = (_iRoomUser.role == UserType_Teacher) ||![[tDic objectForKey:sCandraw]boolValue];
    _iDrawImageView.hidden = tDrawImageShow;
    
    if([[tDic objectForKey:sGiftNumber]integerValue] && _iRoomUser.role != UserType_Teacher){
        [self  potStartAnimationForView:self];
    }
    
    
    
}
-(void)functionButtonClicked:(UIButton *)aButton{
    TKLog(@"aaaaaa");
    if (!_iPeerId || [_iPeerId isEqualToString:@""])
        return;
    
    if (!_iFunctionView) {
        [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
        switch (_iVideoRole) {
            case EVideoRoleTeacher:{
                _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 295, 70) withType:1 aVideoRole:EVideoRoleTeacher aRoomUer:_iRoomUser];
                _iFunctionView.iDelegate = self;
                break;
            }
            case EVideoRoleOur:{
                
                 _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 295, 70) withType:1 aVideoRole:EVideoRoleOur aRoomUer:_iRoomUser];
                _iFunctionView.iDelegate = self;
                break;
                
            }
            default:{
                
                _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_user_small");
                 _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.superview.frame)-70, 295, 70) withType:0 aVideoRole:EVideoRoleOther aRoomUer:_iRoomUser];
                _iFunctionView.iDelegate = self;
                
                break;
                
            }
                
        }
        
       
        [[UIApplication sharedApplication].keyWindow addSubview:_iFunctionView];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
       
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
            [_iEduClassRoomSessionHandle sessionHandleEnableVideo:![_iEduClassRoomSessionHandle sessionHandleIsVideoEnabled]];
            aButton.selected = [_iEduClassRoomSessionHandle sessionHandleIsVideoEnabled];
          
            
        }else{
            
            TKLog(@"授权涂鸦");
            if (_iRoomUser.publishState>1) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@((bool)(!_iRoomUser.canDraw)) completion:nil];
                
                //[[TKEduWhiteBoardHandle shareTKEduWhiteBoardHandleInstance] setDrawable:!_iRoomUser.canDraw];
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
            [_iEduClassRoomSessionHandle sessionHandleEnableAudio:![_iEduClassRoomSessionHandle sessionHandleIsAudioEnabled]];
            aButton.selected = ![_iEduClassRoomSessionHandle sessionHandleIsAudioEnabled];
            _iAudioImageView.hidden = aButton.selected;
                       
        }else{
            
            TKLog(@"下讲台");
            PublishState tPublishState = _iRoomUser.publishState;
            BOOL isShowVideo = (tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY );
            if (isShowVideo) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE completion:nil];
                  [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@(false) completion:nil];
                
                
            }else{
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
            
            if (_iRoomUser.publishState == PublishState_NONE) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_AUDIOONLY completion:nil];
                aButton.selected = YES;
                _iAudioImageView.hidden = !aButton.selected;
                 [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }else if (_iRoomUser.publishState == PublishState_AUDIOONLY){
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE completion:nil];
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
           
            
        }];
        TKLog(@"发奖励");
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
@end

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
#import "TKEduClassRoomSessionHandle.h"

//214*140  214*120 214*20
//214*140  214*120 214*20
//120*112  120*90  120*22


#pragma mark - 隐藏视频上课老师和学生下面的黑条
//static const CGFloat sVideoSmallNameLabelHeight = 22;
static const CGFloat sVideoSmallNameLabelHeight = 0;


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
    return [self initWithFrame:frame iRootView:nil aVideoRole:EVideoRoleTeacher];
}
-(instancetype)initWithFrame:(CGRect)frame iRootView:(UIView * _Nullable )iRootView aVideoRole:(EVideoRole)aVideoRole{
    if (self = [super initWithFrame:frame]) {
        //[iRootView addSubview:self];
        _iRootView  = iRootView;
        _iGifNumber = 0;
        self.backgroundColor = RGBCOLOR(47, 47, 47);
        //self.userInteractionEnabled = NO;
        CGFloat tVideoWidth     = CGRectGetWidth(frame);
        CGFloat tVideoHeigh     = CGRectGetHeight(frame)-sVideoSmallNameLabelHeight*Proportion;
        _iVideoBackgroundImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_teacher_big")];
        _iVideoBackgroundImageView.frame        = CGRectMake(0, 0, tVideoWidth, tVideoHeigh);
        _iVideoFrame            =  CGRectMake(0, 0, tVideoWidth, tVideoHeigh);
        _iVideoRole = aVideoRole;
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
        //[TKUtil setCenter:tImageView ToFrame:frame];
      
        _iNameLabel =({
            CGFloat tWidth = (aVideoRole != EVideoRoleTeacher?(CGRectGetWidth(frame)-48):CGRectGetWidth(frame));
            
            UILabel *tNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-sVideoSmallNameLabelHeight*Proportion, tWidth, sVideoSmallNameLabelHeight*Proportion)];
            
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
            
            UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-sVideoSmallNameLabelHeight*Proportion, tWidth, sVideoSmallNameLabelHeight*Proportion)];
            tLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
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
            [tButton setTitle:[NSString stringWithFormat:@"%@",@(_iGifNumber)] forState:UIControlStateNormal];
            [tButton setTitleColor:RGBCOLOR(240,207,46)forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(11);
            
#pragma mark - 隐藏礼物图标
            tButton.hidden = YES;
            
            
            tButton;
            
        });
        CGFloat tVideoImageWidth = (tVideoWidth-6)/4.0;
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
        _iAudioImageView.hidden = YES;
        _iDrawImageView.hidden = YES;
        _iHandsUpImageView.hidden = YES;
        
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
-(void)functionButtonClicked:(UIButton *)aButton{
    TKLog(@"aaaaaa");
    if (!_iFunctionView) {
        switch (_iVideoRole) {
            case EVideoRoleTeacher:{
                _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 295, 70) withType:1 aVideoRole:EVideoRoleTeacher];
                _iFunctionView.iDelegate = self;
                break;
            }
            case EVideoRoleOur:{
                
                 _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(ScreenW-295-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame)+70, 295, 70) withType:1 aVideoRole:EVideoRoleOur];
                _iFunctionView.iDelegate = self;
                break;
                
            }
            default:{
                
                _iVideoBackgroundImageView.image = LOADIMAGE(@"icon_user_small");
                 _iFunctionView = [[TKVideoFunctionView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.superview.frame)-70, 295, 70) withType:0 aVideoRole:EVideoRoleOther];
                _iFunctionView.iDelegate = self;
                
                break;
                
            }
                
        }
       
        
        [[UIApplication sharedApplication].keyWindow addSubview:_iFunctionView];
    }else{
        _iFunctionView.hidden = !_iFunctionView.hidden;
    }
  
}
-(void)hide{
      _iFunctionView.hidden = YES;
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
    _iNameLabel.text = aName;
    
}
-(void)changeGiftNum:(NSInteger)aGitNumber{
    _iGifNumber  = aGitNumber;
    [_iGifButton setTitle:[NSString stringWithFormat:@"%@",@(_iGifNumber)] forState:UIControlStateNormal];
    
}

-(void)videoSmallbutton1:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    
    if (!_iPeerId || ![_iPeerId isEqualToString:@""]) {
        _iCurrentPeerId = _iPeerId;
    }
    if (aVideoRole == EVideoRoleTeacher) {
         TKLog(@"关闭视频");
        
        if (!aButton.selected) {
             [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iCurrentPeerId Publish:PublishState_NONE completion:nil];
        }else{
             [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iCurrentPeerId Publish:PublishState_BOTH completion:nil];
        }
       
//        [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iPeerId TellWhom:sTellAll Key:sPublishstate Value:@(aButton.selected) completion:nil];
        
        
    }else{
         TKLog(@"授权涂鸦");
        _iDrawImageView.hidden = !aButton.selected;
        [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iCurrentPeerId TellWhom:sTellAll Key:sCandraw Value:@(aButton.selected) completion:nil];
        
        
    }
    //_iEduClassRoomSessionHandle
  
}
-(void)videoSmallButton2:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    if (!_iPeerId || ![_iPeerId isEqualToString:@""]) {
        _iCurrentPeerId = _iPeerId;
    }
    if (aVideoRole == EVideoRoleTeacher) {
        TKLog(@"关闭音频");
        if (!aButton.selected) {
            [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iCurrentPeerId Publish:PublishState_VIDEOONLY completion:nil];
        }else{
            [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iCurrentPeerId Publish:PublishState_BOTH completion:nil];
        }
         //[_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_VIDEOONLY completion:nil];
    }else{
        
        TKLog(@"下讲台");
        if (!aButton.selected) {
            [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iCurrentPeerId Publish:PublishState_NONE completion:nil];

        }else{
            [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iCurrentPeerId Publish:PublishState_BOTH completion:nil];
        }
    }
}
-(void)videoSmallButton3:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    TKLog(@"关闭音频");
    if (!_iPeerId || ![_iPeerId isEqualToString:@""]) {
        _iCurrentPeerId = _iPeerId;
    }
    _iAudioImageView.hidden = !aButton.selected;
    if (!aButton.selected) {
        [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iCurrentPeerId Publish:PublishState_VIDEOONLY completion:nil];
        
    }else{
        [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iCurrentPeerId Publish:PublishState_BOTH completion:nil];
    }
   
    
}
-(void)videoSmallButton4:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    if (!_iPeerId || ![_iPeerId isEqualToString:@""]) {
        _iCurrentPeerId = _iPeerId;
    }
    [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iCurrentPeerId TellWhom:sTellAll Key:sGiftNumber Value:@(1) completion:nil];
    [self potStartAnimationForView:self];
     TKLog(@"发礼物");
}
#pragma mark 动画
- (void)potStartAnimationForView:(UIView *)view
{
    if (_iGiftAnimationView) {
        return;
    }
    _iGiftAnimationView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"icon_gift")];
    //animationView.backgroundColor = [UIColor yellowColor];
    _iGiftAnimationView.frame = CGRectMake(0, 0, 69, 80);
    _iGiftAnimationView.center = CGPointMake(ScreenW/2, ScreenH/2);
    [[UIApplication sharedApplication].keyWindow addSubview:_iGiftAnimationView];
  
    
    [self transformForView:_iGiftAnimationView fromOldPoint:_iGiftAnimationView.layer.position toNewPoint:view.superview.layer.position];
}
- (void)transformForView:(UIView *)d fromOldPoint:(CGPoint)oldPoint toNewPoint:(CGPoint)newPoint
{
    CABasicAnimation*scaleAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    //transform.scale:  x轴，y轴同时按比例缩放：
//    scaleAnimation.fromValue = [NSNumber numberWithFloat:oldPoint.y+5]; //从 from
//    scaleAnimation.toValue = [NSNumber numberWithFloat:oldPoint.y-5]; //to
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
    _iGiftCount++;
    [_iGiftAnimationView removeFromSuperview];
    _iGiftAnimationView = nil;
    [self.iGifButton setTitle:[NSString stringWithFormat:@"%@",@(_iGiftCount)] forState:UIControlStateNormal];
    
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

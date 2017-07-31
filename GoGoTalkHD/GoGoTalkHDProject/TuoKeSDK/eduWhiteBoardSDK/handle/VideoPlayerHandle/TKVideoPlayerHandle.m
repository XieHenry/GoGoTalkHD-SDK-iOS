//
//  TKVideoPlayerHandle.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/20.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKVideoPlayerHandle.h"
#import "TKMacro.h"
#import "RoomUser.h"
#import "TKEduBoardHandle.h"
#import "TKEduSessionHandle.h"
#import "TKMediaDocModel.h"

@interface TKVideoPlayerHandle (){

    
}

@property (nonatomic,strong)UIView *iRootView;
@property (nonatomic, assign) float volume;//默认最大声

@property(nonatomic,strong)CABasicAnimation *iRotationAnimation;
@property(nonatomic, strong)AVPlayerLayer   *iPreAVPlayerLayer;
@property(nonatomic, strong)TKMediaDocModel *iPreMediaDocModel;
@property(nonatomic, strong)UIButton        *iPreAudioButtion;
@property(nonatomic, strong)AVPlayerItem    *iPreItem;// item
@property (strong, nonatomic)  UISlider *iAudioslider2;
@end
NSString *const kAVPlayerCloseVideoNotificationKey   = @"kAVPlayerCloseVideoNotificationKey";
NSString *const kAVPlayerCloseDetailVideoNotificationKey = @"kAVPlayerCloseDetailVideoNotificationKey";
NSString *const kAVPlayerFullScreenBtnNotificationKey = @"kAVPlayerFullScreenBtnNotificationKey";
NSString *const kAVPlayerPopDetailNotificationKey = @"kAVPlayerPopDetailNotificationKey";
NSString *const kAVPlayerFinishedPlayNotificationKey = @"kAVPlayerFinishedPlayNotificationKey";

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;
@implementation TKVideoPlayerHandle

- (void)playerInitialize:(NSString *)urlString  aMediaDocModel:(TKMediaDocModel*)aMediaDocModel withView:(UIView*)aRootView aType:(NSString*)aType add:(BOOL)add aRoomUser:(RoomUser*)aRoomUser{

    if (add) {
        _iRootView = aRootView;
        _iMediaDocModel = aMediaDocModel;
        self.volume = 1.0;
        NSString *tdeletePathExtension = urlString.stringByDeletingPathExtension;
        NSString *tNewURLString = [NSString stringWithFormat:@"%@-1.%@",tdeletePathExtension,urlString.pathExtension];
        NSArray *tArray          = [tNewURLString componentsSeparatedByString:@"/"];
        if ([tArray count]<4) {
            return;
        }
        NSString *tNewURLString2 = [NSString stringWithFormat:@"%@//%@/%@/%@",[tArray objectAtIndex:0],[tArray objectAtIndex:1],[tArray objectAtIndex:2],[tArray objectAtIndex:3]];
        NSURL*liveURL      = [NSURL URLWithString:tNewURLString2];
        AVAsset* liveAsset = [AVURLAsset URLAssetWithURL:liveURL options:nil];
        //保存上一个currentItem
        if (_iCurrentItem) {
            
            _iPreItem = _iCurrentItem;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            [self removeObserverFromPlayerItem:_iPreItem];
            
        }
        //重新设置currentItem
        _iCurrentItem = [AVPlayerItem playerItemWithAsset:liveAsset];
        [self addObserverFromPlayerItem:_iCurrentItem];
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        //如果没有avplayer，则设置avplayer
        if (!_iAVPlayer) {
            _iAVPlayer = [AVPlayer playerWithPlayerItem:_iCurrentItem];
        }else{
            
            [_iAVPlayer replaceCurrentItemWithPlayerItem:_iCurrentItem];
        }
        
        if ([aType isEqualToString:@"video"]) {
            if(_iPreAVPlayerLayer)
            {
                [_iAVPlayer.currentItem cancelPendingSeeks];
                [_iAVPlayer.currentItem.asset cancelLoading];
                [_iAVPlayer pause];
                [_iAVPlayerLayer removeFromSuperlayer];
                [_iPreAVPlayerLayer removeFromSuperlayer];
                
            }
            AVPlayerLayer *tAVPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_iAVPlayer];
            tAVPlayerLayer.frame          = aRootView.layer.bounds;
            /*
             
             第1种模式AVLayerVideoGravityResizeAspect是按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑；
             第2种AVLayerVideoGravityResizeAspectFill是以原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分就被切割了；
             第3种AVLayerVideoGravityResize是拉伸视频内容达到边框占满，但不按原比例拉伸，这里明显可以看出宽度被拉伸了。
             
             */
            tAVPlayerLayer.videoGravity   =AVLayerVideoGravityResize;
            _iAVPlayerLayer               = tAVPlayerLayer;
            if (!_iPreAVPlayerLayer) {
                _iPreAVPlayerLayer = tAVPlayerLayer;
            }
           
            [aRootView.layer addSublayer:tAVPlayerLayer];
            NSLog(@"------layer %@",@([aRootView.layer.sublayers count]));
            
           
        }else if([aType isEqualToString:@"audio"]) {
            if(_iPreAudioButtion)
            {
                [_iAVPlayer.currentItem cancelPendingSeeks];
                [_iAVPlayer.currentItem.asset cancelLoading];
                [_iAVPlayer pause];
                [_iAudioButtion.layer removeAllAnimations];
                [_iAudioButtion removeFromSuperview];
                [_iPreAudioButtion removeFromSuperview];
                
            }
 
            
            //132 ==bottomHeigh
            UIButton * tAudioButtion = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH-50-132, 50, 50)];
            [tAudioButtion setImage:LOADIMAGE(@"disk") forState:UIControlStateNormal];
            [aRootView addSubview:tAudioButtion];
            _iAudioButtion = tAudioButtion;
            if (!_iPreAudioButtion) {
                _iPreAudioButtion = tAudioButtion;
            }
            
        };
       
    }else{
        
        [self removePlayer:aType aMediaDocModel:aMediaDocModel];
        
    }
      [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
    
    
    
}

-(BOOL)iIsPlayState{
    return _iAVPlayer.rate ?YES:NO;
    
}

-(void)removePlayer:(NSString*)aType aMediaDocModel:(TKMediaDocModel *)aMediaDocModel{
    if (aMediaDocModel) {_iPreMediaDocModel = aMediaDocModel;}
    
      if ([aType isEqualToString:@"video"]) {
          if (_iAVPlayerLayer) {
              [_iAVPlayer.currentItem cancelPendingSeeks];
              [_iAVPlayer.currentItem.asset cancelLoading];
              [_iAVPlayer pause];
              [_iAVPlayerLayer removeFromSuperlayer];
              [_iPreAVPlayerLayer removeFromSuperlayer];
              
          }
         _iPreAVPlayerLayer = _iAVPlayerLayer;
          
    }else{
        
        if (_iAudioButtion) {
           
            [_iAVPlayer.currentItem cancelPendingSeeks];
            [_iAVPlayer.currentItem.asset cancelLoading];
            [_iAVPlayer pause];
            [_iAudioButtion.layer removeAllAnimations];
            [_iAudioButtion removeFromSuperview];
            [_iPreAudioButtion removeFromSuperview];
        }
        _iPreAudioButtion = _iAudioButtion;
       
    }
    
  [[TKEduSessionHandle shareInstance]configurePlayerRoute:NO];

    
}
//获取视频的总时间
- (double)itemDuration{
    AVPlayerItem *playerItem = _iAVPlayer.currentItem;
    //currentItem 只有在 AVPlayerItemStatusReadyToPlay状态才好使
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return CMTimeGetSeconds([playerItem.asset duration]);
    }
    else{
        return 0.f;
    }
}

-(void)playeOrPause:(BOOL)aIsPlay {
    if (!(_iAudioButtion || _iAVPlayerLayer)) {
        return;
    }
    
    NSInteger tCurrentTime = CMTimeGetSeconds(_iAVPlayer.currentItem.currentTime);
    _iMediaDocModel.currentTime = @(tCurrentTime);
    if (aIsPlay) {
        // 如果是重新播放，需要将时间调回到0
        NSInteger totalDuration = CMTimeGetSeconds(_iAVPlayer.currentItem.duration);
        if (totalDuration == tCurrentTime) {
            [self setCurrentTime:0];
            
        }
        
    }
    
    //正在播放
    if (aIsPlay && _iAudioButtion) {
         CABasicAnimation *tRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        tRotationAnimation.toValue     = [NSNumber numberWithFloat: M_PI * 2.0 ];
        tRotationAnimation.duration    = 1;
        tRotationAnimation.cumulative  = YES;
        tRotationAnimation.repeatCount = HUGE_VALF;
        [_iAudioButtion.layer addAnimation:tRotationAnimation forKey:@"rotationAnimation"];
        
        
    }else if(_iAudioButtion){
        //没播放，且是audioButton，则去掉动画
        [_iAudioButtion.layer removeAllAnimations];
        
    }
  
    aIsPlay?[_iAVPlayer play]:[_iAVPlayer pause];
    !aIsPlay?:[self configureVolume:self.volume];
    [[TKEduSessionHandle shareInstance] configurePlayerRoute:aIsPlay];
 
  
    
}

//获取视频当前播放的时间
- (double)itemCurrentTime{
    
    return CMTimeGetSeconds([_iAVPlayer currentTime]);
    
}
//设置跳转到当前播放时间
- (void)setCurrentTime:(double)time{
    
    [_iAVPlayer seekToTime:CMTimeMakeWithSeconds(time, 1)];
    
}

-(void)releaseAVPlayer{
 
    [_iAVPlayer.currentItem cancelPendingSeeks];
    [_iAVPlayer.currentItem.asset cancelLoading];
    [_iAVPlayer pause];
    [_iAVPlayerLayer removeFromSuperlayer];
    [_iPreAVPlayerLayer removeFromSuperlayer];
    
    [_iAudioButtion removeFromSuperview];
    [_iPreAudioButtion removeFromSuperview];
    
    [_iAVPlayer replaceCurrentItemWithPlayerItem:nil];
    [self removeObserverFromPlayerItem:_iCurrentItem];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _iAVPlayer    = nil;
    _iCurrentItem = nil;
    _iAVPlayerLayer = nil;
    _iPreAudioButtion = nil;
    
    [[TKEduSessionHandle shareInstance]configurePlayerRoute:NO];
}
-(void)dealloc{
    [self releaseAVPlayer];
    NSLog(@"-------VideoPlayerHandle");
}

#pragma mark - 添加监听
- (void)addObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    //监听播放状态的变化
    [playerItem addObserver:self
                 forKeyPath:@"status"
                    options:NSKeyValueObservingOptionNew
                    context:PlayViewStatusObservationContext];
  
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
}

//监听播放状态的变化、网络加载情况
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status == AVPlayerStatusReadyToPlay){
            // 设置进度条最大value= 视频总时长
           // double duration = CMTimeGetSeconds(_iAVPlayer.currentItem.duration);
            if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student) {
                 //[[TKEduClassRoomSessionHandle shareInstance]publishtNeedProgressMediaDocModel:_iMediaDocModel];
            }
           
         
        }
        
    }
}
- (void)moviePlayDidEnd:(NSNotification *)notification {
    
    if (_iAudioButtion) {
        [_iAudioButtion.layer removeAllAnimations];
    }
    
}
#pragma mark 其他
/**
 *  获取系统音量
 */
- (void)configureVolume:(float)volume {
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _iAudioslider2 = (UISlider *)view;
            _iAudioslider2.value = volume;

            break;
        }
    }
}
-(void)setVolumeForPlayer:(AVAsset*)liveAsset playerItem:(AVPlayerItem*) playerItem volume:(float)volume{
    
    //AVF_EXPORT NSString *const AVMediaTypeVideo                 NS_AVAILABLE(10_7, 4_0);
    //    AVF_EXPORT NSString *const AVMediaTypeAudio                 NS_AVAILABLE(10_7, 4_0);
    NSArray *audioTracks = [liveAsset tracksWithMediaType:AVMediaTypeAudio];
    
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams =
        [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:volume atTime:kCMTimeZero];
        // 或者用 MPVolumeView
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    
    [playerItem setAudioMix:audioMix];
}
//-(void) setVolume:(float)volume{
//    //作品音量控制
//    NSMutableArray *allAudioParams = [NSMutableArray array];
//    AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
//    [audioInputParams setVolume:volume atTime:kCMTimeZero];
//    [audioInputParams setTrackID:1];
//    [allAudioParams addObject:audioInputParams];
//    audioMix = [AVMutableAudioMix audioMix];
//    [audioMix setInputParameters:allAudioParams];
//    [_mp3PlayerItem setAudioMix:audioMix]; // Mute the player item
//
//    [avAudioPlayer setVolume:volume];
//}

@end

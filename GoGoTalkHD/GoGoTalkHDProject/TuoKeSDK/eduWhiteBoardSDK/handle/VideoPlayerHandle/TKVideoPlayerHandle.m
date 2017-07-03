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
@interface TKVideoPlayerHandle (){

    
}

@property (nonatomic,strong)UIView *iRootView;

@property(nonatomic,strong)CABasicAnimation *iRotationAnimation;
@property(nonatomic, strong)AVPlayerLayer   *iPreAVPlayerLayer;
@property(nonatomic, strong)TKMediaDocModel *iPreMediaDocModel;
@property(nonatomic, strong)UIButton        *iPreAudioButtion;
@property(nonatomic, strong)AVPlayerItem    *iPreItem;// item

@end
NSString *const kAVPlayerCloseVideoNotificationKey   = @"kAVPlayerCloseVideoNotificationKey";
NSString *const kAVPlayerCloseDetailVideoNotificationKey = @"kAVPlayerCloseDetailVideoNotificationKey";
NSString *const kAVPlayerFullScreenBtnNotificationKey = @"kAVPlayerFullScreenBtnNotificationKey";
NSString *const kAVPlayerPopDetailNotificationKey = @"kAVPlayerPopDetailNotificationKey";
NSString *const kAVPlayerFinishedPlayNotificationKey = @"kAVPlayerFinishedPlayNotificationKey";

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;
@implementation TKVideoPlayerHandle

- (void)playerInitialize:(NSString *)urlString  aMediaDocModel:(TKMediaDocModel*)aMediaDocModel withView:(UIView*)aRootView aType:(NSString*)aType add:(BOOL)add aRoomUser:(RoomUser*)aRoomUser{
    NSLog(@"---------%@",@(add));
    if (add) {
        _iRootView = aRootView;
        _iMediaDocModel = aMediaDocModel;
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
           // [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_iCurrentItem];
            [self removeObserverFromPlayerItem:_iCurrentItem];
            
        }
        //重新设置currentItem
        _iCurrentItem = [AVPlayerItem playerItemWithAsset:liveAsset];
        [self addObserverFromPlayerItem:_iCurrentItem];
        // 添加视频播放结束通知
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:aType];
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
                 NSLog(@"---------(删除)");
            }
            AVPlayerLayer *tAVPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_iAVPlayer];
            tAVPlayerLayer.frame          =aRootView.layer.bounds;
            tAVPlayerLayer.videoGravity   =AVLayerVideoGravityResizeAspectFill;
            _iAVPlayerLayer               = tAVPlayerLayer;
            if (!_iPreAVPlayerLayer) {
                _iPreAVPlayerLayer = tAVPlayerLayer;
            }
           
           
            [aRootView.layer addSublayer:tAVPlayerLayer];
             NSLog(@"---------(%@)",@(aRootView.layer.sublayers.count));
           
        }else if([aType isEqualToString:@"audio"]) {
            
            UIButton * tAudioButtion = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH-50, 50, 50)];
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
    //正在播放
    if (aIsPlay && _iAudioButtion) {
         CABasicAnimation *tRotationAnimation            = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
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
    [_iAudioButtion removeFromSuperview];
    [_iAVPlayer replaceCurrentItemWithPlayerItem:nil];
    [self removeObserverFromPlayerItem:_iCurrentItem];
    _iAVPlayer    = nil;
    _iCurrentItem = nil;
}
-(void)dealloc{
    [self releaseAVPlayer];
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
         
        }
        
    }
}
- (void)moviePlayDidEnd:(NSNotification *)notification {
    
    NSString *tStringType = notification.object;
    [self removePlayer:tStringType aMediaDocModel:nil];
    
}
#pragma mark 其他

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

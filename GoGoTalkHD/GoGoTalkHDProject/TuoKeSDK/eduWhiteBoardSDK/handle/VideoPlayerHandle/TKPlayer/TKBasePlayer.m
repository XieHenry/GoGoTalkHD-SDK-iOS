//
//  TKBasePlayer.m
//  EduClassPad
//
//  Created by MAC-MiNi on 2017/7/17.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "TKBasePlayer.h"
#import "TKEduSessionHandle.h"

@implementation TKBasePlayer

- (instancetype)initWithMediaDocModel:(TKMediaDocModel *)aMediaDocModel
                        aRoomProperty:(TKEduRoomProperty*)aRoomProperty
                          SendToOther:(BOOL)send
                                frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _iMediaDocModel = aMediaDocModel;
        _iRoomProperty = aRoomProperty;
        _iSendToOther = send;
        [self construct];
    }
    return self;
}

- (void)dealloc {
    TKLog(@"jin %@-------------------------------dead",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserveWithPlayerItem:self.avPlayerItem];
    [[TKEduSessionHandle shareInstance]configurePlayerRoute:NO];
    
}

- (void)construct {
    [self ac_initPlayer];
    [self ac_initSubviews];
    
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    self.volume =1;
    [self configureVolume:self.volume];
}

- (void)ac_initPlayer {
    
#ifdef Debug
    NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",@"http",_iRoomProperty.sWebIp,@"80",_iMediaDocModel.swfpath];
#else
    NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",sHttp,_iRoomProperty.sWebIp,_iRoomProperty.sWebPort,_iMediaDocModel.swfpath];
#endif
    
    NSString *tdeletePathExtension = tUrl.stringByDeletingPathExtension;
    NSString *tNewURLString = [NSString stringWithFormat:@"%@-1.%@",tdeletePathExtension,tUrl.pathExtension];
    NSArray *tArray          = [tNewURLString componentsSeparatedByString:@"/"];
    if ([tArray count]<4) {
        return;
    }
    NSString *tNewURLString2 = [NSString stringWithFormat:@"%@//%@/%@/%@",[tArray objectAtIndex:0],[tArray objectAtIndex:1],[tArray objectAtIndex:2],[tArray objectAtIndex:3]];
    
    NSURL*liveURL      = [NSURL URLWithString:tNewURLString2];
    self.avPlayerItem = [AVPlayerItem playerItemWithURL:liveURL];
    [self addObserveWithPlayerItem:self.avPlayerItem];
    
    self.avPlayer      = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _isPlayEnd = NO;
    
}

- (void)clearPublishMedia:(TKMediaDocModel*)aMediaDocModel isPublish:(BOOL)isPublish {
    
    [self.avPlayer pause];
    [self.link invalidate];
    self.avPlayer = nil;
    [self removeFromSuperview];
    [[TKEduSessionHandle shareInstance]configurePlayerRoute:NO];
    if (isPublish) {
        [[TKEduSessionHandle shareInstance] publishtMediaDocModel:aMediaDocModel add:false To:sTellAllExpectSender];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaBackAction)]) {
        [(id<mediaProtocol>)self.delegate mediaBackAction];
    }
    
}

// 添加view，子类实现
- (void)ac_initSubviews {

}

// 切换当前播放的内容
- (void)changeCurrentplayerItemWithAC_VideoModel:(TKMediaDocModel *)model {
    
    if (self.avPlayer) {
        //由暂停状态切换时候 开启定时器，将暂停按钮状态设置为播放状态
        self.link.paused = NO;
        self.playButton.selected = NO;
        
        //移除当前AVPlayerItem对"loadedTimeRanges"和"status"的监听
        [self removeObserveWithPlayerItem:self.avPlayer.currentItem];
#ifdef Debug
        
        NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",@"http",_iRoomProperty.sWebIp,@"80",model.swfpath];
#else
        NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",sHttp,_iRoomProperty.sWebIp,_iRoomProperty.sWebPort,model.swfpath];
#endif
        NSString *tdeletePathExtension = tUrl.stringByDeletingPathExtension;
        NSString *tNewURLString = [NSString stringWithFormat:@"%@-1.%@",tdeletePathExtension,tUrl.pathExtension];
        NSArray *tArray = [tNewURLString componentsSeparatedByString:@"/"];
        if ([tArray count]<4) {
            return;
        }
        NSString *tNewURLString2 = [NSString stringWithFormat:@"%@//%@/%@/%@",[tArray objectAtIndex:0],[tArray objectAtIndex:1],[tArray objectAtIndex:2],[tArray objectAtIndex:3]];
        NSURL*liveURL = [NSURL URLWithString:tNewURLString2];
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:liveURL];
        [self addObserveWithPlayerItem:playerItem];
        self.avPlayerItem = playerItem;
        self.iMediaDocModel.currentTime = 0;
        
        //更换播放的AVPlayerItem
        [self.avPlayer replaceCurrentItemWithPlayerItem:playerItem];
        self.playButton.enabled = NO;
        self.iProgressSlider.enabled = NO;
    }
}

// 获取系统音量
- (void)configureVolume:(float)volume {
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
   
    for (UIView *view in [volumeView subviews]) {
        
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            self.iAudioslider2 = (UISlider *)view;
            self.iAudioslider2.value = volume;
            //float volume = [[AVAudioSession sharedInstance] outputVolume];
            self.iAudioslider.sliderPercent = volume;
            self.iAudioButton.selected = ( volume == 0 );
            break;
        }
    }
}

#pragma mark - 视频监听缓冲和状态加载
// 注册观察者监听状态和缓冲
- (void)addObserveWithPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

// 移除处观察者
- (void)removeObserveWithPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"status"];
}

// KVO监听到属性状态变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        // 什么都不做
        
    } else if ([keyPath isEqualToString:@"status"]) {
        
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            
            self.iProgressSlider.enabled = YES;
            self.playButton.enabled = YES;
            [self playAction:YES SendToOther:_iSendToOther];
            [self setCurrentTime:[self.iMediaDocModel.currentTime doubleValue] SendToOther:NO];
            //刚开始准备的时候，第一次不发送给其他人
            if (!self.iSendToOther) {
                [self playAction:NO SendToOther:self.iSendToOther];
                self.iSendToOther = YES;
            }
            
        } else{
            
            NSLog(@"load break");
            self.faildView.hidden = NO;
        }
        
        BOOL isSucess = self.avPlayer.status == AVPlayerItemStatusReadyToPlay?YES:NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayStatus:)]) {
            [(id<mediaProtocol>)self.delegate mediaPlayStatus:isSucess];
        }
    
    }
    
}

- (void)setCurrentTime:(double)time SendToOther:(BOOL)send{
    
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay){
        CMTime seekTime = CMTimeMakeWithSeconds(time, 1);
        _iMediaDocModel.currentTime = @(time);
        [self.avPlayer seekToTime:seekTime completionHandler:^(BOOL finished) {
            
            if(self.avPlayer && self.avPlayer.currentItem) {
                NSTimeInterval total = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
                if (total) {
                    self.iProgressSlider.sliderPercent=time/total;
                    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self formatPlayTime:time], isnan(total)?@"00:00":[self formatPlayTime:total]];
                }
            }
            
            BOOL tIsClass = [TKEduSessionHandle shareInstance].isClassBegin;
            if (tIsClass && _iSendToOther && send) {
                
                [[TKEduSessionHandle shareInstance]publishtProgressMediaDocModel:_iMediaDocModel To:sTellAllExpectSender isPlay:_iIsPlay?true:false];
            }
            
        }];
    }
    
}

#pragma mark - 通知响应

- (void)moviePlayDidEnd{
    NSLog(@"播放完成");
    [self.avPlayer pause];
    self.playButton.selected = NO;
    self.isPlayEnd = YES;
    [self.activity stopAnimating];
    [[TKEduSessionHandle shareInstance] publishtPlayOrPauseMediaDocModel:_iMediaDocModel To:sTellAllExpectSender isPlay:false];
}

- (void)enterForeground:(NSNotification *)aNotification {

    if (self.iMediaDocModel && self.iIsPlay) {
        [self playOrPauseAction:self.playButton];
        [[TKEduSessionHandle shareInstance] publishtPlayOrPauseMediaDocModel:self.iMediaDocModel To:sTellAllExpectSender isPlay:self.iIsPlay];
    }
    
}

- (void)enterBackground:(NSNotification *)aNotification {
    
    if (self.iMediaDocModel && self.iIsPlay) {
        [self playAction:NO SendToOther:YES];
        [[TKEduSessionHandle shareInstance] publishtPlayOrPauseMediaDocModel:self.iMediaDocModel To:sTellAllExpectSender isPlay:NO];
    }
    
}

#pragma mark - 响应事件

// 点击退出
- (void)backAction:(UIButton *)button {
    BOOL tIsClass = [TKEduSessionHandle shareInstance].isClassBegin;
    [self clearPublishMedia:_iMediaDocModel isPublish:tIsClass];
}

// 播放和暂停
- (void)playOrPauseAction:(UIButton *)sender {
    [self playAction:!sender.selected SendToOther:YES];
}

- (void)playAction:(BOOL)start {
    [self playAction:start SendToOther:NO];
}

- (void)playAction:(BOOL)start SendToOther:(BOOL)send {
    
    self.iIsPlay = start;
    //播放结束，重新播放
    if (_isPlayEnd) {
        _isPlayEnd = NO;
        [self changeCurrentplayerItemWithAC_VideoModel:self.iMediaDocModel];
    } else {
        
        if (!start) {
            
            [self.avPlayer pause];
            self.link.paused = YES;
            [self.activity stopAnimating];
    
            
        } else {
            [self.avPlayer play];
             self.link.paused = NO;
           
        }
         [[TKEduSessionHandle shareInstance]configurePlayerRoute:start];
    }
    
    BOOL tIsClass = [TKEduSessionHandle shareInstance].isClassBegin;
    if (tIsClass && send) {
        [[TKEduSessionHandle shareInstance]publishtPlayOrPauseMediaDocModel:self.iMediaDocModel To:sTellAllExpectSender isPlay: start];
    }
    
    self.playButton.selected = start;
}

// 播放进度滑块
- (void)progressValueChange:(TKProgressSlider *)slider {
    
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
        NSTimeInterval duration = self.iProgressSlider.sliderPercent* CMTimeGetSeconds(self.avPlayer.currentItem.duration);
        CMTime seekTime = CMTimeMake(duration, 1);
        
        [self.avPlayer seekToTime:seekTime completionHandler:^(BOOL finished) {
            self.iMediaDocModel.currentTime = @(duration);
            BOOL tIsClass = [TKEduSessionHandle shareInstance].isClassBegin;
            if (tIsClass) {
                
                [[TKEduSessionHandle shareInstance]publishtProgressMediaDocModel:self.iMediaDocModel To:sTellAllExpectSender isPlay:self.iIsPlay?true:false];
            }
        }];
    }
    
}

// 声音开关
-(void)audioButtonClicked:(UIButton *)aButton{
    BOOL tBtnSlct                   = self.iAudioslider2.value ?NO:YES;
    aButton.selected                = !tBtnSlct;
    CGFloat tVolume                 = aButton.selected ? 0 : 1;
    self.volume                     = tVolume;
    self.iAudioslider2.value        = tVolume;
    self.iAudioslider.sliderPercent = tVolume;
 
    
}

// 音量大小滑块
- (void)progressValueChange2:(TKProgressSlider *)slider {
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
        [_iAudioslider2 setValue:self.iAudioslider.sliderPercent animated:NO];
        _iAudioButton.selected = (_iAudioslider2.value==0);
        self.volume = self.iAudioslider.sliderPercent;
         
    }
}

// 重新加载
- (void)reloadAction:(UIButton *)button {
    [self changeCurrentplayerItemWithAC_VideoModel:self.iMediaDocModel];
    self.faildView.hidden = YES;
}

// CADisplayLink的更新
- (void)update
{
    NSTimeInterval current = CMTimeGetSeconds(self.avPlayer.currentTime);
    NSTimeInterval total = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (!self.iProgressSlider.isSliding) {
        self.iProgressSlider.sliderPercent = current/total;
    }
    
    if (current!=self.lastTime) {
        [self.activity stopAnimating];
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self formatPlayTime:current], isnan(total)?@"00:00":[self formatPlayTime:total]];
    } else {
        if (current < total) {
            [self.activity startAnimating];
        }
    }
    
    if (_iSendToOther) {
        _iMediaDocModel.currentTime = @(current);
    }
    
    self.lastTime = current;
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    
    if(now - self.lastSyncTime > 1) {
        self.lastSyncTime = now;
        BOOL tIsClass = [TKEduSessionHandle shareInstance].isClassBegin;
        if (tIsClass && self.iSendToOther) {
            [[TKEduSessionHandle shareInstance]publishtProgressMediaDocModel:self.iMediaDocModel To:sTellNone isPlay:self.iIsPlay?true:false];
        }
    }
}

- (NSString *)formatPlayTime:(NSTimeInterval)duration {
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
}

@end

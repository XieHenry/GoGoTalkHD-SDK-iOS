//
//  TKAudioPlayer.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/16.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKAudioPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "TKAVPlayerView.h"
#import "TKProgressSlider.h"
#import "TKMacro.h"
#import "TKEduClassRoomProperty.h"
#import "TKMediaDocModel.h"

@interface TKAudioPlayer ()

@property (strong, nonatomic) UIView *iAudioView;

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerItem *avPlayerItem;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;



@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *bottmView;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) TKProgressSlider *slider;

@property (strong, nonatomic) TKProgressSlider *iAudioslider;
@property (strong, nonatomic)  UISlider *iAudioslider2;

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSTimeInterval lastTime;

@property (strong, nonatomic) UIView *faildView;

@property (strong, nonatomic) TKMediaDocModel *iMediaDocModel;

@property (nonatomic, strong) TKEduClassRoomProperty *iEduClassRoomProperty;


@end

@implementation TKAudioPlayer
- (instancetype)initWithMediaDocModel:(TKMediaDocModel *)aMediaDocModel aEduClassRoomProperty:(TKEduClassRoomProperty*)aEduClassRoomProperty{
    //NSAssert(aMediaDocModel, @"The playlist can not be empty!");
    self = [super init];
    if (self) {
        
        _iMediaDocModel = aMediaDocModel;
        _iEduClassRoomProperty = aEduClassRoomProperty;
    }
    return self;
}
-(UIView *)audioPlayerView:(CGRect)aFrame{
    
   // CGRectMake(0, 0, 788, 57)
    _iAudioView = [[UIView alloc]initWithFrame:aFrame];
    _iAudioView.backgroundColor = RGBCOLOR(23, 23, 23);
    [self ac_initPlayer];
    [self ac_initSubViews];
    
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    [self playOrPauseAction:_playButton];
    [self configureVolume:1];
    return _iAudioView;
}
- (void)ac_initPlayer
{
    NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",sHttp,_iEduClassRoomProperty.sWebIp,_iEduClassRoomProperty.sWebPort,_iMediaDocModel.swfpath];
    NSString *tdeletePathExtension = tUrl.stringByDeletingPathExtension;
    NSString *tNewURLString = [NSString stringWithFormat:@"%@-1.%@",tdeletePathExtension,tUrl.pathExtension];
    NSArray *tArray          = [tNewURLString componentsSeparatedByString:@"/"];
    if ([tArray count]<4) {
        return;
    }
    NSString *tNewURLString2 = [NSString stringWithFormat:@"%@//%@/%@/%@",[tArray objectAtIndex:0],[tArray objectAtIndex:1],[tArray objectAtIndex:2],[tArray objectAtIndex:3]];
    
    //NSString *tNewURLString2 = @"https://global.talk-cloud.com/upload/20170520_202258_vlcdycdg-1.mp4";
    NSURL*liveURL      = [NSURL URLWithString:tNewURLString2];
    self.avPlayerItem = [AVPlayerItem playerItemWithURL:liveURL];
    [self addObserveWithPlayerItem:self.avPlayerItem];
    
    self.avPlayer      = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    
    TKAVPlayerView *avPlayerView = [[TKAVPlayerView alloc] initWithMoviePlayerLayer:self.avPlayerLayer frame:_iAudioView.bounds];
    avPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_iAudioView addSubview:avPlayerView];
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(upadte)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void)ac_initSubViews
{
    //返回按钮
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_iAudioView.frame)-40, (CGRectGetHeight(_iAudioView.frame)-30)/2, 30, 30)];
    
    [self.backButton setImage:LOADIMAGE(@"btn_closed_normal") forState:UIControlStateNormal];
//    self.backButton.backgroundColor = [UIColor yellowColor];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_iAudioView addSubview:self.backButton];
    
    //播放按钮
    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 57, 57)];
    [self.playButton setImage:LOADIMAGE(@"pauseBtn") forState:UIControlStateNormal];
    [self.playButton setImage:LOADIMAGE(@"playBtn") forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.enabled = NO;
    [_iAudioView addSubview:self.playButton];
    
    //名称
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playButton.frame)+20, 0, 315, 25)];
    self.titleLabel.text = _iMediaDocModel.filename;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_iAudioView addSubview:self.titleLabel];
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 110, 25)];
    self.timeLabel.text = @"00:00/00:00";
    self.titleLabel.font = TKFont(12);
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [_iAudioView addSubview:self.timeLabel];
    CGSize size = CGSizeMake(1000,10000);
    //计算实际frame大小，并将label的frame变成实际大小
    NSDictionary *attribute = @{NSFontAttributeName:self.timeLabel.font};
    CGSize labelsize = [self.timeLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame), 0, labelsize.width, labelsize.height);
//    self.timeLabel.backgroundColor = [UIColor redColor];
    
    
    //滑块
    self.slider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playButton.frame)+20, 25, 425, 25) direction:AC_SliderDirectionHorizonal];
    [_iAudioView addSubview:self.slider];
    self.slider.enabled = NO;
    [self.slider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *tbutton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.slider.frame)+20, 25, 25, 25)];
    [tbutton setImage:LOADIMAGE(@"btn_volume_normal") forState:UIControlStateNormal];
    [_iAudioView addSubview:tbutton];
    //声道滑块
    self.iAudioslider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tbutton.frame)+8, 25, 150, 25) direction:AC_SliderDirectionHorizonal];
    self.iAudioslider.enabled = YES;
    [self.iAudioslider addTarget:self action:@selector(progressValueChange2:) forControlEvents:UIControlEventValueChanged];
    [_iAudioView addSubview:self.iAudioslider];
    

    
}

//更新方法
- (void)upadte
{
    NSTimeInterval current = CMTimeGetSeconds(self.avPlayer.currentTime);
    NSTimeInterval total = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (!self.slider.isSliding) {
        self.slider.sliderPercent = current/total;
    }
    
    if (current!=self.lastTime) {
        [self.activity stopAnimating];
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self formatPlayTime:current], isnan(total)?@"00:00":[self formatPlayTime:total]];
    }else{
        [self.activity startAnimating];
    }
    self.lastTime = current;
    
}
//切换当前播放的内容
- (void)changeCurrentplayerItemWithAC_VideoModel:(TKMediaDocModel *)model
{
    if (self.avPlayer) {
        
        //由暂停状态切换时候 开启定时器，将暂停按钮状态设置为播放状态
        self.link.paused = NO;
        self.playButton.selected = NO;
        
        //移除当前AVPlayerItem对"loadedTimeRanges"和"status"的监听
        [self removeObserveWithPlayerItem:self.avPlayer.currentItem];
        
        NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",sHttp,_iEduClassRoomProperty.sWebIp,_iEduClassRoomProperty.sWebPort,model.swfpath];
        NSString *tdeletePathExtension = tUrl.stringByDeletingPathExtension;
        NSString *tNewURLString = [NSString stringWithFormat:@"%@-1.%@",tdeletePathExtension,tUrl.pathExtension];
        NSArray *tArray          = [tNewURLString componentsSeparatedByString:@"/"];
        if ([tArray count]<4) {
            return;
        }
        NSString *tNewURLString2 = [NSString stringWithFormat:@"%@//%@/%@/%@",[tArray objectAtIndex:0],[tArray objectAtIndex:1],[tArray objectAtIndex:2],[tArray objectAtIndex:3]];
        NSURL*liveURL      = [NSURL URLWithString:tNewURLString2];
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:liveURL];
        [self addObserveWithPlayerItem:playerItem];
        self.avPlayerItem = playerItem;
        //更换播放的AVPlayerItem
        [self.avPlayer replaceCurrentItemWithPlayerItem:playerItem];
        
        self.playButton.enabled = NO;
        self.slider.enabled = NO;
    }
}

#pragma mark 监听视频缓冲和加载状态
//注册观察者监听状态和缓冲
- (void)addObserveWithPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

//移除处观察者
- (void)removeObserveWithPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"status"];
}

- (NSString *)formatPlayTime:(NSTimeInterval)duration
{
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
}


//视频播放完成
- (void)moviePlayDidEnd
{
    NSLog(@"播放完成");
    [self.avPlayer pause];
    [self.link invalidate];
    
    //    NSInteger index = [self.videoArr indexOfObject:self.videoModel];
    //    if (index!= self.videoArr.count-1) {
    //        [self.avPlayer pause];
    //        self.videoModel = self.videoArr[index + 1];
    //        [self changeCurrentplayerItemWithAC_VideoModel:self.videoModel];
    //    }else{
    //        [self.avPlayer pause];
    //        [self.link invalidate];
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }
}

#pragma mark 各种事件点击
- (void)backAction:(UIButton *)button
{
    [self.avPlayer pause];
    [self.link invalidate];
    [_iAudioView removeFromSuperview];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}

- (void)reloadAction:(UIButton *)button
{
    [self changeCurrentplayerItemWithAC_VideoModel:self.iMediaDocModel];
    self.faildView.hidden = YES;
}


//播放暂停按钮
- (void)playOrPauseAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.avPlayer.rate == 1) {
        [self.avPlayer pause];
        self.link.paused = YES;
        [self.activity stopAnimating];
    } else {
        [self.avPlayer play];
        self.link.paused = NO;
    }
}

//处理滑块
- (void)progressValueChange:(TKProgressSlider *)slider
{
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
        NSTimeInterval duration = self.slider.sliderPercent* CMTimeGetSeconds(self.avPlayer.currentItem.duration);
        CMTime seekTime = CMTimeMake(duration, 1);
        
        [self.avPlayer seekToTime:seekTime completionHandler:^(BOOL finished) {
            
        }];
    }
}

//处理滑块
- (void)progressValueChange2:(TKProgressSlider *)slider
{
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
        
        //[self setVolume:self.iAudioslider.sliderPercent];
        [_iAudioslider2 setValue:self.iAudioslider.sliderPercent animated:NO];
        
    }
}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval loadedTime = [self availableDurationWithplayerItem:playerItem];
        NSTimeInterval totalTime = CMTimeGetSeconds(playerItem.duration);
        
        if (!self.slider.isSliding) {
            self.slider.progressPercent = loadedTime/totalTime;
        }
        
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"playerItem is ready");
            
            [self.avPlayer play];
            self.slider.enabled = YES;
            self.playButton.enabled = YES;
        } else{
            NSLog(@"load break");
            self.faildView.hidden = NO;
        }
    }
}


- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem
{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - rotate control
- (BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeLeft;
    return UIInterfaceOrientationMaskLandscape;

    
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeLeft;
    return UIInterfaceOrientationLandscapeRight;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    NSLog(@"dead");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserveWithPlayerItem:_avPlayerItem];
}



-(void) setVolume:(float)volume{
    //作品音量控制
    NSMutableArray *allAudioParams = [NSMutableArray array];
    AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
    [audioInputParams setVolume:volume atTime:kCMTimeZero];
    [audioInputParams setTrackID:1];
    [allAudioParams addObject:audioInputParams];
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    [_avPlayerItem setAudioMix:audioMix]; // Mute the player item
    
    [_avPlayer setVolume:volume];
}
/**
 *  获取系统音量
 */
- (void)configureVolume:(float)volume {
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
   
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _iAudioslider2 = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
}
@end

//
//  TKPlaybackMaskView.m
//  EduClassPad
//
//  Created by MAC-MiNi on 2017/9/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKPlaybackMaskView.h"
#import "TKProgressSlider.h"
#import "TKEduSessionHandle.h"
#import "TKUtil.h"
#import "TKMacro.h"
//#import "PlaybackModel.h"

@interface TKPlaybackMaskView ()

@property (nonatomic, assign) NSTimeInterval seekInterval;
@property (nonatomic, assign) NSTimeInterval acceptSeekTime;

@end

@implementation TKPlaybackMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.model = [[PlaybackModel alloc] init];
        self.seekInterval = 2;
        self.acceptSeekTime = 0;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    CGFloat tBottmViewWH = 70;
    CGFloat tViewCap = 8;
    
    //bottonBar
    self.bottmView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-2 * tBottmViewWH, ScreenW, tBottmViewWH)];
    self.bottmView.backgroundColor = RGBACOLOR(0, 0, 0, 1);
    [self addSubview:self.bottmView];
    
    //播放按钮
    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(tViewCap, 0, tBottmViewWH, tBottmViewWH)];
    [self.playButton setImage:LOADIMAGE(@"playBtn") forState:UIControlStateNormal];
    [self.playButton setImage:LOADIMAGE(@"pauseBtn") forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottmView addSubview:self.playButton];
    
    //名称
    CGFloat tProgressSliderW = CGRectGetWidth(self.bottmView.frame) - CGRectGetMaxX(self.playButton.frame)-tViewCap-200*Proportion;

    //进度滑块
    self.iProgressSlider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame)+tViewCap, 33, tProgressSliderW, 25) direction:AC_SliderDirectionHorizonal];
    
    [self.iProgressSlider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.bottmView addSubview:self.iProgressSlider];
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame)+tViewCap, 10, 150, 25)];
    self.timeLabel.text = @"00:00/00:00";
    self.timeLabel.textColor = RGBACOLOR_Title_White;
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottmView addSubview:self.timeLabel];
    
    //菊花
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activity setCenter:self.center];//指定进度轮中心点
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    self.activity.hidesWhenStopped = YES;
    [self addSubview:self.activity];
}

- (void)playOrPauseAction:(UIButton *)sender {
    if (sender.selected == NO) {
        [[TKEduSessionHandle shareInstance] playback];
        sender.selected = YES;
    } else {
        [[TKEduSessionHandle shareInstance] pausePlayback];
        sender.selected = NO;
    }
    
    [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
    
    //TKLog(@"&&&playback: playOrPause");
}

// 播放进度滑块
- (void)progressValueChange:(TKProgressSlider *)slider {
    
    //TKLog(@"&&&playback: seek, %f", self.iProgressSlider.sliderPercent);
    
    if (self.iProgressSlider.sliderPercent < 0) {
        self.iProgressSlider.sliderPercent = 0;
    }
    
    if (self.iProgressSlider.sliderPercent > 1) {
        self.iProgressSlider.sliderPercent = 1;
    }
    NSTimeInterval pos = floor(self.iProgressSlider.sliderPercent * self.duration);
    
    if (NSDate.date.timeIntervalSince1970 - self.acceptSeekTime < self.seekInterval) {
        return;
    }
    
    if (self.seekInterval > 0) {
        self.acceptSeekTime = NSDate.date.timeIntervalSince1970;
        [[TKEduSessionHandle shareInstance] seekPlayback:pos];
        NSLog(@"tk-------------滑动!");
    }
}

- (void)update:(NSTimeInterval)current
{
    //TKLog(@"&&&playback: update %f", current);
    
    if (self.playButton.selected == NO) {
        return;
    }
    
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (!self.iProgressSlider.isSliding) {
        self.iProgressSlider.sliderPercent = current/self.duration;
    }
    
    if (current!=self.lastTime) {
        [self.activity stopAnimating];
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self formatPlayTime:current/1000], isnan(self.duration)?@"00:00":[self formatPlayTime:self.duration/1000]];
    } else {
        if (current < self.duration) {
            [self.activity startAnimating];
        }
    }
    
    self.lastTime = current;
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    if(now - self.lastSyncTime > 1) {
        self.lastSyncTime = now;
    }
    
    //[[TKEduSessionHandle shareInstance]configurePlayerRoute: NO isCancle:NO];
}

- (NSString *)formatPlayTime:(NSTimeInterval)duration {
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
}

- (void)playbackEnd {
    //TKLog(@"&&&playback: end");
    
    self.playButton.selected = NO;
    self.iProgressSlider.sliderPercent = 0;
    [[TKEduSessionHandle shareInstance] seekPlayback:0];
    [[TKEduSessionHandle shareInstance] pausePlayback];
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", @"00:00", [self formatPlayTime:self.duration/1000]];
}

//- (void)getPlayDuration:(NSTimeInterval)duration {
//    self.model.duration = duration;
//    self.playButton.selected = YES;
//    
//    [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
//}

- (void)getPlayDuration:(NSTimeInterval)duration {
    //TKLog(@"&&&playback: get duration");
    
    if (self.playButton.selected == YES) {
        // 播放状态断线重连，进行seek
        NSTimeInterval pos = self.iProgressSlider.sliderPercent * self.duration;
        [[TKEduSessionHandle shareInstance] seekPlayback:pos];
    } else {
        if (self.iProgressSlider.sliderPercent > 0.001) {
            // 暂停状态断线重连，进行seek，然后再pause
            NSTimeInterval pos = self.iProgressSlider.sliderPercent * self.duration;
            [[TKEduSessionHandle shareInstance] seekPlayback:pos];
            [[TKEduSessionHandle shareInstance] pausePlayback];
        } else {
            // 正常状态
            self.duration = duration;
            self.playButton.selected = YES;
            [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
        }
    }
}


@end

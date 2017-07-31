//
//  TKAudioVideoPlayerView.m
//  EduClassPad
//
//  Created by MAC-MiNi on 2017/7/18.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKAudioVideoPlayerView.h"
#import "TKAVPlayerView.h"
#import "TKEduSessionHandle.h"

@implementation TKAudioVideoPlayerView

/*
- (void)ac_initPlayer {
    [super ac_initPlayer];
}
*/

- (void)ac_initSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    TKAVPlayerView *avPlayerView = [[TKAVPlayerView alloc] initWithMoviePlayerLayer:self.avPlayerLayer frame:self.bounds];
    avPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:avPlayerView];
    
    //返回按钮
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-60, 10, 50, 50)];
    [self.backButton setImage:LOADIMAGE(@"btn_closed_normal") forState:UIControlStateNormal];
    [self.backButton setImage:LOADIMAGE(@"btn_closed_pressed") forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    CGFloat tBottmViewWH = 70;
    CGFloat tViewCap = 8;
    //bottonBar
    self.bottmView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-tBottmViewWH, ScreenW, tBottmViewWH)];
    self.bottmView.backgroundColor = RGBACOLOR(0, 0, 0, .5);
    [self addSubview:self.bottmView];
    
    //播放按钮
    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(tViewCap, 0, tBottmViewWH, tBottmViewWH)];
    [self.playButton setImage:LOADIMAGE(@"playBtn") forState:UIControlStateNormal];
    [self.playButton setImage:LOADIMAGE(@"pauseBtn") forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.enabled = NO;
    [self.bottmView addSubview:self.playButton];
    
    //声道滑块
    CGFloat tAudiosliderWidth = 107;
    self.iAudioslider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bottmView.frame)-tAudiosliderWidth-tViewCap, 0, tAudiosliderWidth, CGRectGetHeight(self.bottmView.frame)) direction:AC_SliderDirectionHorizonal];
    self.iAudioslider.enabled = YES;
    [self.iAudioslider addTarget:self action:@selector(progressValueChange2:) forControlEvents:UIControlEventValueChanged];
    [self.bottmView addSubview:self.iAudioslider];
    
    self.iAudioButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.iAudioslider.frame)-25,(CGRectGetHeight(self.bottmView.frame)-25)/2, 25, 25)];
    [self.iAudioButton setImage:LOADIMAGE(@"btn_volume_normal") forState:UIControlStateNormal];
    [self.iAudioButton setImage:LOADIMAGE(@"btn_mute_normal") forState:UIControlStateSelected];
    [self.iAudioButton addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottmView addSubview:self.iAudioButton];
    
    //名称
    CGFloat tProgressSliderW = CGRectGetWidth(self.bottmView.frame) - CGRectGetMaxX(self.playButton.frame)-(CGRectGetWidth(self.bottmView.frame)-CGRectGetMinX(self.iAudioButton.frame))-tViewCap-70*Proportion;
    //滑块
    self.iProgressSlider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame)+tViewCap, 33, tProgressSliderW, 25) direction:AC_SliderDirectionHorizonal];
    self.iProgressSlider.enabled = NO;
    [self.iProgressSlider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.bottmView addSubview:self.iProgressSlider];
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    self.timeLabel.text = @"00:00/00:00";
    self.titleLabel.font = TKFont(12);
    self.timeLabel.textColor = RGBACOLOR_Title_White;
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottmView addSubview:self.timeLabel];
    
    CGSize size = CGSizeMake(1000,10000);
    //计算实际frame大小，并将label的frame变成实际大小
    NSDictionary *attribute = @{NSFontAttributeName:self.timeLabel.font};
    CGSize labelsize = [self.timeLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.iProgressSlider.frame)- labelsize.width-10, 8, labelsize.width+10, labelsize.height);
    
    self.titleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.playButton.frame)+tViewCap, 8, tProgressSliderW- labelsize.width-10, 25)];
    self.titleLabel.text = self.iMediaDocModel.filename;
    self.titleLabel.textColor = RGBACOLOR_Title_White;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottmView addSubview:self.titleLabel];
    
    //菊花
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activity setCenter:self.center];//指定进度轮中心点
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    self.activity.hidesWhenStopped = YES;
    [self addSubview:self.activity];
    
    //加载失败
    self.faildView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.faildView];
    self.faildView.hidden = YES;
    //
    UIButton *reLoadButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [reLoadButton setTitle:@"视频加载失败，点击重新加载" forState:UIControlStateNormal];
    [reLoadButton addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.faildView addSubview:reLoadButton];
    
}


@end

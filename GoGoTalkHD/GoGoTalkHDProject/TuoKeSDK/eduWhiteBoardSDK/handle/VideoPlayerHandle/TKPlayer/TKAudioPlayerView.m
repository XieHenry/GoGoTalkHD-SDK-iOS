//
//  TKAudioPlayerView.m
//  EduClassPad
//
//  Created by MAC-MiNi on 2017/7/18.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKAudioPlayerView.h"
#import "TKEduSessionHandle.h"

@implementation TKAudioPlayerView

- (void)ac_initSubviews {
    
    self.backgroundColor = RGBCOLOR(23, 23, 23);
    
    //返回按钮
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-40, (CGRectGetHeight(self.frame)-30)/2, 30, 30)];
    
    [self.backButton setImage:LOADIMAGE(@"btn_closed_normal") forState:UIControlStateNormal];
    //    self.backButton.backgroundColor = [UIColor yellowColor];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    //播放按钮
    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 57, 57)];
    [self.playButton setImage:LOADIMAGE(@"playBtn") forState:UIControlStateNormal];
    [self.playButton setImage:LOADIMAGE(@"pauseBtn") forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.enabled = NO;
    [self addSubview:self.playButton];
    
    //名称
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame)+20, 0, 315, 25)];
    self.titleLabel.text = self.iMediaDocModel.filename;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 110, 25)];
    self.timeLabel.text = @"00:00/00:00";
    self.titleLabel.font = TKFont(12);
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.timeLabel];
    CGSize size = CGSizeMake(1000,10000);
    //计算实际frame大小，并将label的frame变成实际大小
    NSDictionary *attribute = @{NSFontAttributeName:self.timeLabel.font};
    CGSize labelsize = [self.timeLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, labelsize.width+10, labelsize.height);
    // 进度拖拽滑块
    self.iProgressSlider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame)+20, 25, 425, 25) direction:AC_SliderDirectionHorizonal];
    [self addSubview:self.iProgressSlider];
    self.iProgressSlider.enabled = NO;
    [self.iProgressSlider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    
    // 声音开关按钮
    self.iAudioButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iProgressSlider.frame)+20, 25, 25, 25)];
    [self.iAudioButton setImage:LOADIMAGE(@"btn_volume_normal") forState:UIControlStateNormal];
    [self.iAudioButton setImage:LOADIMAGE(@"btn_mute_normal") forState:UIControlStateSelected];
    [self.iAudioButton addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.iAudioButton];
    //声道滑块
    self.iAudioslider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iAudioButton.frame)+8, 25, 150, 25) direction:AC_SliderDirectionHorizonal];
    self.iAudioslider.enabled = YES;
    [self.iAudioslider addTarget:self action:@selector(progressValueChange2:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.iAudioslider];
}


@end

//
//  TKPlaybackMaskView.h
//  EduClassPad
//
//  Created by MAC-MiNi on 2017/9/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKProgressSlider;

@interface TKPlaybackMaskView : UIView

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) TKProgressSlider *iProgressSlider;

@property (nonatomic, strong) UIView *bottmView;

@property (nonatomic, strong) UILabel *timeLabel;

//@property (nonatomic, strong) PlaybackModel *model;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) NSTimeInterval lastTime;

@property (nonatomic, assign) NSTimeInterval lastSyncTime;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

- (void)update:(NSTimeInterval)current;

- (void)playbackEnd;

- (void)getPlayDuration:(NSTimeInterval)duration;

@end

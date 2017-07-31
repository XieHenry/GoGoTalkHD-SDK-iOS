//
//  TKBasePlayer.h
//  EduClassPad
//
//  Created by MAC-MiNi on 2017/7/17.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TKBasePlayer.h"
#import "TKProgressSlider.h"
#import "TKMediaDocModel.h"
#import "TKEduRoomProperty.h"
#import "mediaProtocol.h"

@interface TKBasePlayer : UIView

- (instancetype)initWithMediaDocModel:(TKMediaDocModel *)aMediaDocModel
                aRoomProperty:(TKEduRoomProperty*)aRoomProperty
                          SendToOther:(BOOL)send
                                frame:(CGRect)frame;
- (void)ac_initPlayer;
- (void)backAction:(UIButton *)button;
- (void)playOrPauseAction:(UIButton *)sender;
- (void)playAction:(BOOL)start SendToOther:(BOOL)send;
- (void)playAction:(BOOL)start;
- (void)progressValueChange:(TKProgressSlider *)slider;
- (void)audioButtonClicked:(UIButton *)aButton;
- (void)progressValueChange2:(TKProgressSlider *)slider;
- (void)update;
- (void)changeCurrentplayerItemWithAC_VideoModel:(TKMediaDocModel *)model;
- (void)reloadAction:(UIButton *)button;
- (void)setCurrentTime:(double)time SendToOther:(BOOL)send;
- (void)clearPublishMedia:(TKMediaDocModel*)aMediaDocModel isPublish:(BOOL)isPublish;

@property (nonatomic, weak) id<mediaProtocol> delegate;

@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *avPlayerItem;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottmView;
@property (nonatomic, assign) NSTimeInterval lastSyncTime;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) TKProgressSlider *iProgressSlider;
@property (nonatomic, strong) UIButton         *iAudioButton;
@property (nonatomic, strong) TKProgressSlider *iAudioslider;
@property (nonatomic, strong) UISlider         *iAudioslider2;

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign)  BOOL iSendToOther;
@property (nonatomic, assign) BOOL iIsPlay;
@property (nonatomic, assign) BOOL isPlayEnd;
@property (nonatomic, strong) UIView *faildView;

@property (nonatomic, strong) TKMediaDocModel *iMediaDocModel;
@property (nonatomic, strong) TKEduRoomProperty *iRoomProperty;
@property (nonatomic, assign) float volume;//默认最大声



@end

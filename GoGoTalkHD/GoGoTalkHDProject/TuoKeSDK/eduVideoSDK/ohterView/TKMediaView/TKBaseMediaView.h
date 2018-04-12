//
//  TKBaseMediaView.h
//  EduClassPad
//
//  Created by ifeng on 2017/8/29.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKVideoBoardHandle.h"
#import "TKEduSessionHandle.h"

@class TKMediaDocModel,TKProgressSlider,MediaStream;
@interface TKBaseMediaView : UIView

- (instancetype)initWithMediaStream:(MediaStream *)aMediaStream
                              frame:(CGRect)frame
                      sessionHandle:(TKEduSessionHandle *)sessionHandle;

- (instancetype)initScreenShare:(CGRect)frame;
- (instancetype)initFileShare:(CGRect)frame;

- (void)playAction:(BOOL)star;
-(void)seekProgressToPos:(NSTimeInterval)value;
- (void)update:(NSTimeInterval)current total:(NSTimeInterval)total;
-(void)updatePlayUI:(BOOL)star;
- (void)loadWhiteBoard;
- (void)hiddenVideoWhiteBoard;
- (void)deleteWhiteBoard;

- (void)loadLoadingView;
//播放mp4时，需要 hidden loading
- (void)hiddenLoadingView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottmView;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) TKProgressSlider *iProgressSlider;
@property (nonatomic, strong) UIButton         *iAudioButton;
@property (nonatomic, strong) TKProgressSlider *iAudioslider;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSTimeInterval lastSyncTime;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL iIsPlay;
@property (nonatomic, assign) BOOL isPlayEnd;
@property (nonatomic, strong) MediaStream *iMediaStream;
@property(nonatomic, strong) UIButton        *iDiskButtion;

@property (nonatomic, strong) UIView *iVideoBoardView;
@property (nonatomic, strong) UIImageView *loadingView;
@end

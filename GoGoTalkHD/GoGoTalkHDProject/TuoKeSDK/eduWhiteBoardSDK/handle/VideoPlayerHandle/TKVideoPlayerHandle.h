//
//  TKVideoPlayerHandle.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/20.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreMedia;
@import MediaPlayer;
@import AVFoundation;
@class TKMediaDocModel,RoomUser;

@interface TKVideoPlayerHandle : NSObject

@property (nonatomic,strong) AVPlayer        *iAVPlayer;
@property(nonatomic, strong) AVPlayerLayer   *iAVPlayerLayer;
@property(nonatomic, strong) AVPlayerItem    *iCurrentItem;// item
@property(nonatomic, strong) UIButton        *iAudioButtion;
@property(nonatomic, strong) TKMediaDocModel *iMediaDocModel;

@property(nonatomic,readonly, assign) BOOL iIsPlayState;


- (void)playerInitialize:(NSString *)urlString  aMediaDocModel:(TKMediaDocModel*)aMediaDocModel withView:(UIView*)aRootView aType:(NSString*)aType add:(BOOL)add aRoomUser:(RoomUser*)aRoomUser;
//设置跳转到当前播放时间
- (void)setCurrentTime:(double)time;
-(void)releaseAVPlayer;
-(void)playeOrPause:(BOOL)aIsPlay;
@end

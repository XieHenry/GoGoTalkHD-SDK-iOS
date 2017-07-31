//
//  TKAVPlayerView.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/16.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface TKAVPlayerView : UIView
- (instancetype)initWithMoviePlayerLayer:(AVPlayerLayer *)playerLayer frame:(CGRect)frame;
@end

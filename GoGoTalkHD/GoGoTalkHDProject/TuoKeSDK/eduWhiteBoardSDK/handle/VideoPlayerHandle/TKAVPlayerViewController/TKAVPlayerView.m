//
//  TKAVPlayerView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/16.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKAVPlayerView.h"

@interface TKAVPlayerView ()
{
    AVPlayerLayer *_playerLayer;
}

@end

@implementation TKAVPlayerView

- (instancetype)initWithMoviePlayerLayer:(AVPlayerLayer *)playerLayer frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _playerLayer = playerLayer;
        playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_playerLayer];
    }
    return self;
}


- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    _playerLayer.bounds = self.layer.bounds;
    _playerLayer.position = self.layer.position;
}


@end

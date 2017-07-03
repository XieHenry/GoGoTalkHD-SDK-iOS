//
//  TKAudioPlayer.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/16.
//  Copyright © 2017年 beijing. All rights reserved.
//
@import UIKit;
#import <Foundation/Foundation.h>
@class TKMediaDocModel,TKEduClassRoomProperty;
@interface TKAudioPlayer : NSObject
- (instancetype)initWithMediaDocModel:(TKMediaDocModel *)aMediaDocModel aEduClassRoomProperty:(TKEduClassRoomProperty*)aEduClassRoomProperty;
-(UIView *)audioPlayerView:(CGRect)aFrame;

@end

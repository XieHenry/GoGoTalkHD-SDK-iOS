//
//  NSTimer+BlockSupport.m
//  测试NSTimer对Target的强引用
//
//  Created by 辰 on 2017/4/20.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "NSTimer+BlockSupport.h"

@implementation NSTimer (BlockSupport)

// timer是自启动的
+ (NSTimer *)xc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:repeats];
}


// timer需要fire 然后添加到runloop中
+ (NSTimer *)xc_timerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeats
{
    return [self timerWithTimeInterval:interval target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:YES];
}


+ (void)blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}


@end

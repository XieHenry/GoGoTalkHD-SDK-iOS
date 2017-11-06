//
//  NSTimer+BlockSupport.h
//  测试NSTimer对Target的强引用
//
//  Created by 辰 on 2017/4/20.
//  Copyright © 2017年 Chn. All rights reserved.
//  需要注意block的循环引用的问题 采用weakSelf的形式可避免
//  在dealloc中需要将[self.timer invalidate]; self.timer = nil; 不然timer还会继续跑
//  在系统的[NSTimer scheduledTimerWithTimeInterval:2.0f repeats:YES block:^(NSTimer * _Nonnull timer) {}]; 的方法中 也会造成循环引用的问题 也需要采用weakSelf的形式  但在dealloc中无法销毁timer timer还会一直跑下去
/*
 - (void)dealloc
 {
     if ([self.timer isValid]) {
         [self.timer invalidate];
         self.timer = nil;
     }
 }
 */


#import <Foundation/Foundation.h>

@interface NSTimer (BlockSupport)

// timer是自启动的
+ (NSTimer *)xc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeats;

// timer需要fire 然后添加到runloop中
+ (NSTimer *)xc_timerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeats;

@end

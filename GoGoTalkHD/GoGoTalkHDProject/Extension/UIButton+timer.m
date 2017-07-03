//
//  UIButton+timer.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "UIButton+timer.h"

@implementation UIButton (timer)

//获取验证码倒计时
-(void)addTimer
{
    __block int timeout= 60;//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);//没秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout<=0) {//倒计时结束,关闭
            dispatch_source_cancel(_timer);
            //            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(),^{
                ;
                self.userInteractionEnabled = YES;
                //设置界面的按钮显示 根据自己需求设置;
                [self setTitle:@"获取验证码" forState:(UIControlStateNormal)];
                [self setTitleColor:UICOLOR_FROM_HEX(ColorC40016) forState:(UIControlStateNormal)];
                self.titleLabel.font = Font(14);
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%d %@",timeout,@"s"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示;
                self.userInteractionEnabled = NO;
                [self setTitle:strTime forState:UIControlStateNormal];
                [self setTitleColor:UICOLOR_FROM_HEX(0xD2D2D2) forState:(UIControlStateNormal)];
                self.titleLabel.font = Font(14);
                
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}


@end

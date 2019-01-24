//
//  GGT_CheckDeviceView.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/19.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_CheckDeviceView.h"
#import <AVFoundation/AVFoundation.h>

@implementation GGT_CheckDeviceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
    }
    return self;
}

- (void)initView {
    
    //照相机
    _cameraBigImgView = [[UIImageView alloc]init];
    [self addSubview:_cameraBigImgView];
    
    [_cameraBigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(60);
        make.top.equalTo(self.mas_top).offset(40);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
    
   
    _camerasmallImgView = [[UIImageView alloc]init];
    _camerasmallImgView.image = UIIMAGE_FROM_NAME(@"camera_Inthetest");
    [_cameraBigImgView addSubview:_camerasmallImgView];
    
    [_camerasmallImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cameraBigImgView.mas_centerX);
        make.centerY.equalTo(self.cameraBigImgView.mas_centerY);
        make.size.mas_offset(CGSizeMake(32, 26));
    }];
    
    //麦克风
    _microphoneBigImgView = [[UIImageView alloc]init];
    _microphoneBigImgView.image = UIIMAGE_FROM_NAME(@"voice_Waiting_for_the");
    [self addSubview:_microphoneBigImgView];
    
    
    [_microphoneBigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(40);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
   
    _microphonesmallImgView = [[UIImageView alloc]init];
    _microphonesmallImgView.image = UIIMAGE_FROM_NAME(@"voice_In_the_test");
    [_microphoneBigImgView addSubview:_microphonesmallImgView];
    _microphonesmallImgView.hidden = YES;

    
    [_microphonesmallImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.microphoneBigImgView.mas_centerX);
        make.centerY.equalTo(self.microphoneBigImgView.mas_centerY);
        make.size.mas_offset(CGSizeMake(23,32));
    }];
    
    
    //WIFI
    _wifiBigImgView = [[UIImageView alloc]init];
    _wifiBigImgView.image = UIIMAGE_FROM_NAME(@"WiFi_Waiting_for_the");
    [self addSubview:_wifiBigImgView];
    
    
    [_wifiBigImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-60);
        make.top.equalTo(self.mas_top).offset(40);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    
    
    _wifismallImgView = [[UIImageView alloc]init];
    _wifismallImgView.image = UIIMAGE_FROM_NAME(@"WiFi_In_the_test");
    [_wifiBigImgView addSubview:_wifismallImgView];
    _wifismallImgView.hidden = YES;

    
    [_wifismallImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wifiBigImgView.mas_centerX);
        make.centerY.equalTo(self.wifiBigImgView.mas_centerY);
        make.size.mas_offset(CGSizeMake(32, 26));
    }];
    
    
    
    //正在检测
    self.checkingLabel = [[UILabel alloc]init];
    self.checkingLabel.text = @"正在检测...";
    self.checkingLabel.font = Font(18);
    self.checkingLabel.textColor = UICOLOR_FROM_HEX(Color232323);
    [self addSubview:self.checkingLabel];
    
    [self.checkingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.microphoneBigImgView.mas_bottom).offset(50);
        make.height.equalTo(@(25));
    }];
    
    
    
    //取消
    self.cancleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.cancleButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.cancleButton setTitleColor:UICOLOR_FROM_HEX(ColorC40016) forState:(UIControlStateNormal)];
    self.cancleButton.titleLabel.font = Font(18);
    self.cancleButton.layer.masksToBounds = YES;
    self.cancleButton.layer.cornerRadius = LineW(22);
    self.cancleButton.layer.borderWidth = LineW(1);
    self.cancleButton.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
    [self addSubview:self.cancleButton];
    
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-40);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(324, 44));
    }];
    
    

    //去设置
    self.setButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.setButton setTitle:@"去设置" forState:(UIControlStateNormal)];
    [self.setButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
    self.setButton.titleLabel.font = Font(18);
    self.setButton.layer.masksToBounds = YES;
    self.setButton.layer.cornerRadius = LineW(22);
    self.setButton.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
    [self addSubview:self.setButton];
    self.setButton.hidden = YES;
    
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-40);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(324, 44));
    }];
    

    
    
    //进入页面，先让照相机先检测起来
    [self animationClick:_cameraBigImgView];
    
    /************************检测设备的代码******************************************/
    
    //1.任务一：摄像头
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];

        GGT_Singleton *singleton = [GGT_Singleton sharedSingleton];
        if (singleton.cameraStatus == YES) {
            
            [self animaCamera:YES];

        } else {
            
            [self animaCamera:NO];

        }

    }];
    
    
    
    
    // 任务二 麦克风
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        
        GGT_Singleton *singleton = [GGT_Singleton sharedSingleton];
        if (singleton.micStatus == YES) {
            
            [self animaMic:YES];
            
        } else {
            
            [self animaMic:NO];
            
        }
        
    }];
    
    
    
    // 任务三 网络检测
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];

        GGT_Singleton *singleton = [GGT_Singleton sharedSingleton];

        if (singleton.netStatus == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.microphoneBigImgView.animationImages = nil;
                self.wifiBigImgView.image = UIIMAGE_FROM_NAME(@"WiFi_open");
                self.wifismallImgView.hidden = YES;
                self.wifiBigImgView.animationImages = nil;

            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.microphoneBigImgView.animationImages = nil;
                self.wifiBigImgView.image = UIIMAGE_FROM_NAME(@"WiFi_off");
                self.wifismallImgView.hidden = YES;
                self.wifiBigImgView.animationImages = nil;

            });
        }
        
    }];
    
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        GGT_Singleton *singleton = [GGT_Singleton sharedSingleton];

        NSLog(@"检测设备-%d-%d--%d",singleton.cameraStatus,singleton.micStatus,singleton.netStatus);

        dispatch_async(dispatch_get_main_queue(), ^{
            
            //设备检测一切都正常
            if (singleton.cameraStatus == YES && singleton.micStatus == YES && singleton.netStatus == YES) {
                self.checkingLabel.text = @"所有检测项目完成并通过！";
                self.cancleButton.hidden = NO;
                [self.cancleButton setTitle:@"确定" forState:(UIControlStateNormal)];
                [self.cancleButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
                self.cancleButton.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
                self.setButton.hidden = YES;
                return ;
            }
            
            
            
            
            //设备检测不正常
            //对不能正常运行的工具进行提醒。
            NSMutableArray *alertArr = [NSMutableArray array];
           
            if (singleton.cameraStatus == NO) {
                [alertArr addObject:@"请在“设置”中允许此应用访问相机"];
            }
            
            if (singleton.micStatus == NO) {
                [alertArr addObject:@"请在“设置”中允许此应用访问麦克风"];

            }
            
            if (singleton.netStatus == NO) {
                [alertArr addObject:@"请检查您的网络是否连接正常"];
            }
            
            
            for (int i=0; i<alertArr.count; i++) {
                UILabel *alertLabel = [[UILabel alloc]init];
                alertLabel.text = alertArr[i];
                alertLabel.font = Font(18);
                alertLabel.textAlignment = NSTextAlignmentCenter;
                alertLabel.textColor = UICOLOR_FROM_HEX(Color232323);
                [self addSubview:alertLabel];
                
                CGFloat h;
                if (alertArr.count == 1) {
                    h = 56;
                } else if (alertArr.count == 2){
                    h = 38;
                } else {
                    h = 20;
                }
                
                [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.mas_centerX);
                    make.top.equalTo(self.microphoneBigImgView.mas_bottom).offset(h+36*i);
                    make.height.equalTo(@(25));
                }];
            }
            
            //如果仅有网络检测不通过，则此处为“确认”button，点击隐藏弹窗即可，无跳转
            if (singleton.cameraStatus == YES && singleton.micStatus == YES && singleton.netStatus == NO) {
                self.cancleButton.hidden = NO;
                self.checkingLabel.hidden = YES;
                [self.cancleButton setTitle:@"确定" forState:(UIControlStateNormal)];
                [self.cancleButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
                self.cancleButton.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
                self.setButton.hidden = YES;
                
            } else {
                
                self.checkingLabel.hidden = YES;
                self.cancleButton.hidden = YES;
                self.setButton.hidden = NO;
            }
            
        });
        
    }];
    
    
    //4.设置依赖
    [operation2 addDependency:operation1];      //任务二依赖任务一
    [operation3 addDependency:operation2];
    [operation4 addDependency:operation3];
    
    //5.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation4,operation3, operation2, operation1] waitUntilFinished:NO];
    

}

#pragma mark 麦克风检测动画
- (void)animaMic:(BOOL)isYes {
    if (isYes == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.wifismallImgView.hidden = NO;
            self.microphoneBigImgView.animationImages = nil;
            self.microphonesmallImgView.hidden = NO;
            self.microphoneBigImgView.image = UIIMAGE_FROM_NAME(@"voice_open");
            [self animationClick:self.wifiBigImgView];
            self.microphonesmallImgView.hidden = YES;
        });
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.wifismallImgView.hidden = NO;
            self.microphoneBigImgView.animationImages = nil;
            self.microphoneBigImgView.image = UIIMAGE_FROM_NAME(@"voice_off");
            [self animationClick:self.wifiBigImgView];
            self.microphonesmallImgView.hidden = YES;
        });
    }
}



#pragma mark 照相机动画
- (void)animaCamera:(BOOL)isYes{
    if (isYes == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.microphonesmallImgView.hidden = NO;
            self.cameraBigImgView.animationImages = nil;
            self.camerasmallImgView.hidden = YES;
            self.cameraBigImgView.image = UIIMAGE_FROM_NAME(@"camera_open");
            [self animationClick:self.microphoneBigImgView];

        });
        
    } else {

        dispatch_async(dispatch_get_main_queue(), ^{
            self.microphonesmallImgView.hidden = NO;
            self.cameraBigImgView.animationImages = nil;
            self.camerasmallImgView.hidden = YES;
            self.cameraBigImgView.image = UIIMAGE_FROM_NAME(@"camera_off");
            [self animationClick:self.microphoneBigImgView];
        });
    }
}

//动画
- (void)animationClick :(UIImageView *)imgView {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 41; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"shebeijianche_%ld",(long)i]];
        [imageArray addObject:image];
    }
    
    imgView.animationImages = imageArray;
    imgView.animationDuration = 0.03 * imageArray.count;
    imgView.animationRepeatCount = 0;
    [imgView startAnimating];
}


@end

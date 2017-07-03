//
//  GGT_CheckDeviceView.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/19.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface GGT_CheckDeviceView : UIView

//照相机
@property (nonatomic, strong) UIImageView *cameraBigImgView;
@property (nonatomic, strong) UIImageView *camerasmallImgView;

//麦克风
@property (nonatomic, strong) UIImageView *microphoneBigImgView;
@property (nonatomic, strong) UIImageView *microphonesmallImgView;


//网络
@property (nonatomic, strong) UIImageView *wifiBigImgView;
@property (nonatomic, strong) UIImageView *wifismallImgView;


//取消
@property (nonatomic, strong) UIButton *cancleButton;

//去设置
@property (nonatomic, strong) UIButton *setButton;

//正在检测
@property (nonatomic, strong) UILabel *checkingLabel;

@end

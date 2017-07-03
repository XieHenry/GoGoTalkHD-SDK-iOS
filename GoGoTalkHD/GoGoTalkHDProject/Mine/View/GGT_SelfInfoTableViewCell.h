//
//  GGT_SelfInfoTableViewCell.h
//  GoGoTalkHD
//
//  Created by 何建新 on 2017/5/22.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_SelfInfoTableViewCell : UITableViewCell
//左边的提醒文字
@property (nonatomic, strong) UILabel *leftTitleLabel;
//右边的请求文字
@property (nonatomic, strong) UILabel *contentLabel;
//右边的跳转图片
@property (nonatomic, strong) UIImageView *rightImgView;

@end

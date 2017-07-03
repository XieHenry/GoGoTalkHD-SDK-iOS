//
//  GGT_PreviewDemoPlaceholderView.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/9.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PreviewDemoPlaceholderView.h"

@implementation GGT_PreviewDemoPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addNewUserPlaceholderView];
    }
    return self;
}

// 新用户的placeholder
- (void)addNewUserPlaceholderView
{
    [self initView];
    [self masView];
}

- (void)initView
{
    
    self.xc_imgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.frame = CGRectMake(0, 0, 258, 190);
        imgView.contentMode = UIViewContentModeCenter;
        imgView;
    });
    [self addSubview:self.xc_imgView];
    
    self.xc_label = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color777777);
        label.text = @" ";
        [label changeLineSpaceWithSpace:10.0];
        // 需要放到设置行间距的后面
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    [self addSubview:self.xc_label];
}

- (void)masView
{
    
    [self.xc_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(120);
        make.width.equalTo(@(258));
        make.height.equalTo(@(190));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.xc_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_imgView.mas_bottom).offset(margin30);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (void)setXc_model:(GGT_ResultModel *)xc_model
{
    _xc_model = xc_model;
    
    // 不明所以
    xc_model.msg = [xc_model.msg stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
   if ([xc_model.result isEqualToString:@"2"]) {
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"tiyanke");
       
    } else if ([xc_model.result isEqualToString:@"3"]) {
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"dengdaizhong");
        
    } else if ([xc_model.result isEqualToString:@"4"]) {
        
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            
            //您还没有预约课程，预约课程请联系您的学习顾问\n或登录官网自主约课：www.gogo-talk.com
            NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:xc_model.msg];
            NSDictionary * attris = @{NSForegroundColorAttributeName:UICOLOR_FROM_HEX(kThemeColor)};
            if ([xc_model.msg containsString:@"："]) {
                NSRange rang = [xc_model.msg rangeOfString:@"："];
                [mutableAttriStr setAttributes:attris range:NSMakeRange(rang.location+1,mutableAttriStr.length-rang.location-1)];
            }
            if ([xc_model.msg containsString:@":"]) {
                NSRange rang = [xc_model.msg rangeOfString:@":"];
                [mutableAttriStr setAttributes:attris range:NSMakeRange(rang.location+1,mutableAttriStr.length-rang.location-1)];
            }
            self.xc_label.attributedText = mutableAttriStr;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"weichuxi");
        
    } else {    // 0
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"weichuxi");
        
    }
}

- (void)drawRect:(CGRect)rect
{
    [self xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:6.0f];
}


@end

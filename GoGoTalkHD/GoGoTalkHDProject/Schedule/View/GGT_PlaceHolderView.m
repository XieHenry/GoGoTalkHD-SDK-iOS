//
//  GGT_PlaceHolderView.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/19.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PlaceHolderView.h"

@interface GGT_PlaceHolderView ()
@property (nonatomic, strong) UIButton *xc_bottomButton;
@end

@implementation GGT_PlaceHolderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addNewUserPlaceholderView];
    }
    return self;
}

// 新用户的placeholder
- (void)addNewUserPlaceholderView
{
    [self initView];
    [self masView];
    [self makeEvent];
}

- (void)initView
{
    
    self.xc_imgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.frame = CGRectMake(0, 0, 258, 190);
        imgView.image = UIIMAGE_FROM_NAME(@"wukecheng");
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
    
    self.xc_bottomButton = ({
        UIButton *button = [UIButton new];
        [button setBackgroundColor:UICOLOR_FROM_HEX(kThemeColor)];
        button.frame = CGRectMake(0, 0, 324, 44);
        [button setTitle:@"立即预约" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = button.height/2.0;
        button;
    });
    [self addSubview:self.xc_bottomButton];
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
    
    [self.xc_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_label.mas_bottom).offset(margin20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(self.xc_bottomButton.height));
        make.width.equalTo(@(self.xc_bottomButton.width));
    }];
}

- (void)makeEvent
{
    @weakify(self);
    [[self.xc_bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         
         // 发送网络请求
         [self sendNetWork];
         
     }];
}

// 约课
- (void)sendNetWork
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSString *studentName = [UserDefaults() objectForKey:K_studentName];
    
    NSString *url = nil;
    if (studentName.length > 0) {
        url = [NSString stringWithFormat:@"%@?studentName=%@", URL_AddDemoMsg, K_studentName];
    } else {
        url = [NSString stringWithFormat:@"%@?studentName=%@", URL_AddDemoMsg, @""];
    }
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:vc success:^(id responseObject) {
        
        
        // 不能使用setModel 有冲突
        GGT_ResultModel *xc_model = [GGT_ResultModel yy_modelWithDictionary:responseObject];
        xc_model.msg = [xc_model.msg stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"dengdaizhong");
        self.xc_bottomButton.hidden = YES;
        
        
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)setXc_model:(GGT_ResultModel *)xc_model
{
    _xc_model = xc_model;
    
    // 不明所以
    xc_model.msg = [xc_model.msg stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    //1:已约正课 2：已约体验课 3：已申请体验课 4：没有约体验课也没有申请体验课也没有正课
    if ([xc_model.result isEqualToString:@"1"]) {
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            
            //您还没有预约课程，预约课程请联系您的学习顾问\n或登录官网自主约课：www.gogo-talk.com
            NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:xc_model.msg];
            NSDictionary * attris = @{NSForegroundColorAttributeName:UICOLOR_FROM_HEX(kThemeColor)};
            if ([xc_model.msg containsString:@"www"]) {
                NSRange rang = [xc_model.msg rangeOfString:@"www"];
                [mutableAttriStr setAttributes:attris range:NSMakeRange(rang.location,mutableAttriStr.length-rang.location)];
            }
            self.xc_label.attributedText = mutableAttriStr;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"wukecheng");
        self.xc_bottomButton.hidden = YES;
    } else if ([xc_model.result isEqualToString:@"2"]) {
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"wukecheng");
        self.xc_bottomButton.hidden = YES;
    } else if ([xc_model.result isEqualToString:@"3"]) {
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"dengdaizhong");
        self.xc_bottomButton.hidden = YES;
    } else if ([xc_model.result isEqualToString:@"4"]) {
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"wukecheng");
        self.xc_bottomButton.hidden = NO;
    } else {
        if ([xc_model.msg isKindOfClass:[NSString class]] && xc_model.msg.length > 0) {
            self.xc_label.text = xc_model.msg;
        } else {
            self.xc_label.text = @"";
        }
        self.xc_imgView.image = UIIMAGE_FROM_NAME(@"wukecheng");
        self.xc_bottomButton.hidden = YES;
    }
    
    
}

@end

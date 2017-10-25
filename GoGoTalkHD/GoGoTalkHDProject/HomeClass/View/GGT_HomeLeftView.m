//
//  GGT_HomeLeftView.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_HomeLeftView.h"

@implementation GGT_HomeLeftView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
    }
    return self;
}



//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.titleLabel.font = Font(14);

    
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGFloat totalHeight = LineH(55);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - LineH(imageSize.height)), 0.0, 0.0, - LineW(titleSize.width));
    btn.titleEdgeInsets = UIEdgeInsetsMake(LineH(7), - LineW(imageSize.width), - ((totalHeight-LineH(17)) ), 0);
}


- (void)initView {
    //设置view的背景为亮黑色
    self.backgroundColor = UICOLOR_FROM_HEX(0x2C2C2C);

    //icon
    UIImageView *iconImgView = [[UIImageView alloc]init];
    iconImgView.image = UIIMAGE_FROM_NAME(@"logo_daohanglan");
    [self addSubview:iconImgView];
    
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(LineY(32));
        make.size.mas_offset(CGSizeMake(LineW(68), LineH(21)));
    }];
    

    self.optionsView = [[UIView alloc]init];
    [self addSubview:self.optionsView];
    
    
    [self.optionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).with.offset(LineY(163));
        make.height.mas_offset(LineH(314)); //88*3+25+25
    }];
    
 
    // 课表按钮
    UIButton *scheduleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scheduleButton setTitle:@"课表" forState:UIControlStateNormal];
    scheduleButton.frame = CGRectMake(0, 0, LineW(88), LineH(88));
    scheduleButton.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
    [scheduleButton setImage:UIIMAGE_FROM_NAME(@"kebiao") forState:UIControlStateNormal];
    [scheduleButton setImage:UIIMAGE_FROM_NAME(@"kebiao") forState:UIControlStateSelected];
    scheduleButton.tag = 100;
    scheduleButton.selected = YES;
    [scheduleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:scheduleButton];
    [self.optionsView addSubview:scheduleButton];
    
    
    [scheduleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.top.equalTo(self.optionsView.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(LineW(88), LineH(88)));
    }];
    
    // 约课按钮
    UIButton *bookClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookClassButton setTitle:@"约课" forState:UIControlStateNormal];
    bookClassButton.frame = CGRectMake(0, 0, LineW(88), LineH(88));
    [bookClassButton setImage:UIIMAGE_FROM_NAME(@"yueke") forState:UIControlStateNormal];
    [bookClassButton setImage:UIIMAGE_FROM_NAME(@"yueke") forState:UIControlStateSelected];
    bookClassButton.tag = 101;
    bookClassButton.selected = NO;
    [bookClassButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:bookClassButton];
    [self.optionsView addSubview:bookClassButton];
    
    
    [bookClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.top.equalTo(scheduleButton.mas_bottom).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(LineW(88), LineH(88)));
    }];
    
    
    // 我的按钮
    UIButton *mineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mineButton setTitle:@"我的" forState:UIControlStateNormal];
    mineButton.frame = CGRectMake(0, 0, LineW(88), LineH(88));
    [mineButton setImage:UIIMAGE_FROM_NAME(@"wode") forState:UIControlStateNormal];
    [mineButton setImage:UIIMAGE_FROM_NAME(@"wode") forState:UIControlStateSelected];
    mineButton.tag = 102;
    mineButton.selected = NO;
    [mineButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:mineButton];
    [self.optionsView addSubview:mineButton];
    
    [mineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.bottom.equalTo(self.optionsView.mas_bottom).with.offset(-0);
        make.size.mas_equalTo(CGSizeMake(LineW(88), LineH(88)));
    }];

    
    
    
    // 检测按钮
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setImage:UIIMAGE_FROM_NAME(@"jiance") forState:UIControlStateNormal];
    checkButton.tag = 103;
    [checkButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkButton];

    
    // 电话按钮
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"kefu"] forState:(UIControlStateNormal)];
    phoneButton.tag = 104;
    [phoneButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneButton];
    
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(phoneButton.mas_top).with.offset(-LineY(30));
        make.size.mas_equalTo(CGSizeMake(LineW(28), LineH(27)));
    }];
    
    
    [phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).with.offset(-LineH(30));
        make.size.mas_equalTo(CGSizeMake(LineW(26), LineH(26)));
    }];
    
    GGT_Singleton *single = [GGT_Singleton sharedSingleton];
    if (single.isAuditStatus) {
        phoneButton.hidden = YES;
    } else {
        phoneButton.hidden = NO;
    }
    
}

- (void)buttonAction:(UIButton *)button {
    
    if ([self.optionsView.subviews containsObject:button]) {
        for (UIView *view in self.optionsView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                btn.selected = NO;
                btn.backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    button.selected = YES;
    

    if (button.tag == 100 || button.tag == 101 || button.tag == 102) {
        button.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
    }
    
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(button);
    }
}

@end

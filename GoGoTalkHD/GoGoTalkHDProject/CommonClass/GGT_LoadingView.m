//
//  GGT_LoadingView.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/8/18.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_LoadingView.h"

@interface GGT_LoadingView ()
@property (nonatomic, strong) UIImageView *indicatorView;

@property (nonatomic, strong) UILabel *failIndicatorLabel;

@property (nonatomic, strong) UIImageView *failView;

@property (nonatomic, strong) UILabel *failLabel;

@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation GGT_LoadingView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initUiView];
    }
    
    return self;
}

- (void)initUiView{
    
    self.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    _failView = [[UIImageView alloc] init];
    _failView.image = [UIImage imageNamed:@"wuwanglo"];
    _failView.frame = CGRectMake(marginFocusOn/2 - 130, SCREEN_HEIGHT()/2 - 189, 260, 189);
    [self addSubview:_failView];
    
    _failLabel = [[UILabel alloc] init];
    _failLabel.text = @"网络请求失败";
    _failLabel.textAlignment = NSTextAlignmentCenter;
    _failLabel.font = Font(16);
    _failLabel.textColor = UICOLOR_FROM_HEX(Color666666);
    [self addSubview:_failLabel];
    
    [_failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.failView.mas_bottom).offset(20);
        
    }];
    
    _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    _reloadButton.titleLabel.font = Font(16);
    [_reloadButton setTitleColor:UICOLOR_FROM_HEX(Color666666) forState:UIControlStateNormal];
    _reloadButton.layer.borderColor = UICOLOR_FROM_HEX(Color999999).CGColor;
    _reloadButton.layer.borderWidth = 0.5;
    _reloadButton.layer.cornerRadius = 3;
    [_reloadButton addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reloadButton];
    [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.failLabel.mas_bottom).offset(23);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 38));
    }];
    
    [self addSubview:_reloadButton];
    
}

- (void)hideLoadingView{
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)reloadAction:(UIButton *)btn{
    
    if (self.loadingFailedBlock) {
        self.loadingFailedBlock(btn);
    }
    
    
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    if (sin.netStatus== NO) {
        [MBProgressHUD showMessage:@"重新加载中..." toView:[[UIApplication sharedApplication] keyWindow]];
    }
    
}


@end

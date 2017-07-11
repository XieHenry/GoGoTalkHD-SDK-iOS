//
//  GGT_NoMoreDateAlertView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/9.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_NoMoreDateAlertView.h"

@implementation GGT_NoMoreDateAlertView

- (instancetype)initWithFrame:(CGRect)frame andImageString:(NSString *)imageString andAlertString:(NSString *)alertString {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureUIWithImageString:imageString andAlertString:alertString];
    }
    
    return self;
    
}

- (void)configureUIWithImageString:(NSString *)imageString andAlertString:(NSString *)alertString {
    
    self.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    //wudingdan_wode
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageString];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(LineW(101.5), LineH(155)));
        make.top.mas_equalTo(self.mas_top).with.offset(0);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    
    UILabel *label = [[UILabel alloc] init];
    label.text = alertString;
    label.font = Font(14);
    label.textColor = UICOLOR_FROM_HEX(Color666666);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView);
        make.top.mas_equalTo(imageView.mas_bottom).with.offset(LineY(10));
    }];
    
}


@end

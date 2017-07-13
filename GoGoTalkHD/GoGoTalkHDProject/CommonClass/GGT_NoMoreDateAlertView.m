//
//  GGT_NoMoreDateAlertView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/9.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_NoMoreDateAlertView.h"

@implementation GGT_NoMoreDateAlertView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)initView {
    
    self.placeImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.frame = CGRectMake(0, 0, 260, 160);
        imgView.contentMode = UIViewContentModeCenter;
        imgView;
    });
    [self addSubview:self.placeImgView];
    
    [self.placeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(250);
        make.width.equalTo(@(260));
        make.height.equalTo(@(160));
        make.centerX.equalTo(self.mas_centerX);
    }];
 
    
    
    
    self.placeLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(15);
        label.textColor = UICOLOR_FROM_HEX(Color777777);
        label.text = @" ";
        [label changeLineSpaceWithSpace:10.0];
        // 需要放到设置行间距的后面
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    [self addSubview:self.placeLabel];
    
    
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.placeImgView.mas_bottom).offset(margin30);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (void)imageString:(NSString *)imageString andAlertString:(NSString *)alertString {
    self.placeImgView.image = [UIImage imageNamed:imageString];
    self.placeLabel.text = alertString;
}



@end

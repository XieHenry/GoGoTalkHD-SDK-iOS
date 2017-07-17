//
//  GGT_OrderPlaceholderView.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderPlaceholderView.h"

@interface GGT_OrderPlaceholderView ()
@property (nonatomic, strong) UIImageView *xc_placeholderImgView;
@property (nonatomic, strong) UILabel *xc_placeholderLabel;
@end

@implementation GGT_OrderPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    self.xc_placeholderImgView = ({
        UIImageView *imgView = [UIImageView new];
        UIImage *img = UIIMAGE_FROM_NAME(@"weichuxi");
        imgView.image = img;
        imgView.contentMode = UIViewContentModeCenter;
        imgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        imgView;
    });
    [self addSubview:self.xc_placeholderImgView];
    
    [self.xc_placeholderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(434.0f/2);
        make.width.equalTo(@(self.xc_placeholderImgView.width));
        make.height.equalTo(@(self.xc_placeholderImgView.height));
    }];
    
    self.xc_placeholderLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color333333);
        label.font = Font(17);
        label.text = @" ";
        [label changeLineSpaceWithSpace:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    [self addSubview:self.xc_placeholderLabel];
    
    [self.xc_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xc_placeholderImgView);
        make.top.equalTo(self.xc_placeholderImgView.mas_bottom).offset(27);
    }];
    
}

- (void)setXc_model:(GGT_ResultModel *)xc_model
{
    _xc_model = xc_model;
    if ([xc_model.msg isKindOfClass:[NSString class]]) {
        self.xc_placeholderLabel.text = xc_model.msg;
    }
}

@end

//
//  GGT_AllWithNoDateView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/6/23.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_AllWithNoDateView.h"

@implementation GGT_AllWithNoDateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    
//    GGT_NoMoreDateAlertView *nodataView = [[GGT_NoMoreDateAlertView alloc]initWithFrame:CGRectMake(0, LineY(80), SCREEN_WIDTH(), LineW(180)) andImageString:@"wudingdan_wode" andAlertString:@"此时间段没有老师"];
//    [self addSubview:nodataView];
    
    
    //推荐时间
//    UILabel *tuijianLabel = [[UILabel alloc]init];
//    tuijianLabel.frame = CGRectMake(0, nodataView.y+nodataView.height+LineY(34), SCREEN_WIDTH(), LineW(18));
//    tuijianLabel.text = @"推荐时间";
//    tuijianLabel.font = Font(16);
//    tuijianLabel.textAlignment = NSTextAlignmentCenter;
//    tuijianLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
//    [self addSubview:tuijianLabel];
    
    
    
}




@end

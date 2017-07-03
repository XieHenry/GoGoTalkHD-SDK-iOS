//
//  TKNONetWorkView.m
//  whiteBoardDemo
//
//  Created by ifeng on 2017/3/6.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKNONetWorkView.h"
#import "TKUtil.h"
#import "TKMacro.h"
@implementation TKNONetWorkView
-(instancetype)initWithFrame:(CGRect)frame withReconctionBlock:(bReconnectionBlock)bReconnectionBlock{
    if (self = [super init]) {
        self.frame = frame;
        _bReconnectionButtonClick = bReconnectionBlock;
        
        UILabel *tTipLabel = ({
            
            CGFloat tWidth = [TKUtil widthForTextString:@"无网络连接" height:20 fontSize:14];
            UILabel *tLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tWidth, 20)];
            tLabel.text = @"无网络连接";
            tLabel.font = [UIFont fontWithName:@"PingFang-SC-Light" size:14];
            tLabel.textColor = [UIColor colorWithRed:193/255.0 green:195/255.0 blue:202/255.0 alpha:1];
            tLabel.center = CGPointMake((CGRectGetWidth(frame) )/2, (CGRectGetHeight(frame))/2);
            tLabel;
            
        });
        UIImageView *tNoNetImageView =  ({
            CGFloat tHeigh = (57.0/80.0) *CGRectGetWidth(tTipLabel.frame);
            UIImageView *tImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(tTipLabel.frame), CGRectGetMinY(tTipLabel.frame)-tHeigh, CGRectGetWidth(tTipLabel.frame),tHeigh)];
            tImageView.image =   LOADIMAGE(@"noNetwork");
            tImageView;
        });
       
       _aReconnectionButton = ({
        
            //UIButton *tButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(tTipLabel.frame), CGRectGetMaxY(tTipLabel.frame)+20, 80, 20)];
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tButton.frame = CGRectMake(CGRectGetMinX(tTipLabel.frame), CGRectGetMaxY(tTipLabel.frame)+20, 80, 20);
            [tButton setTitle:@"刷新页面" forState:UIControlStateNormal];
            tButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Light" size:14];
            [tButton setTitleColor:[UIColor colorWithRed:139/255.0 green:139/255.0 blue:142/255.0 alpha:1] forState:UIControlStateNormal];
            tButton.layer.cornerRadius  = 10;
            tButton.layer.masksToBounds = YES;
            tButton.layer.shadowColor   = [UIColor blackColor].CGColor;
            tButton.layer.shadowOffset  = CGSizeMake(-2, -3);
            tButton.layer.shadowOpacity = 1;
            tButton.layer.shadowRadius  = 5;
            [tButton addTarget:self action:@selector(reconnectButtonCkick:) forControlEvents:UIControlEventTouchUpInside];
            tButton.backgroundColor = [UIColor whiteColor];
            tButton;
        
        
        });
        [self addSubview:_aReconnectionButton];
        [self addSubview:tNoNetImageView];
        [self addSubview:tTipLabel];
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        
    }
    return self;
}

-(void)reconnectButtonCkick:(UIButton *)aButton{
   // _bReconnectionButtonClick ?:_bReconnectionButtonClick(aButton);
    
    if (_bReconnectionButtonClick) {
        _bReconnectionButtonClick(aButton);
    }
}

@end

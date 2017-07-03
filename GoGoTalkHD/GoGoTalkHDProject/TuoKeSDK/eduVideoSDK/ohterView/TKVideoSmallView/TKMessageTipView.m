//
//  TKMessageTipView.m
//  whiteBoardDemo
//
//  Created by ifeng on 2017/2/27.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKMessageTipView.h"
#import "TKMacro.h"
#import "TKUtil.h"

#define userNameLabelWidth 45
#define userNameLabelHeigh 13

@implementation TKMessageTipView
- (nonnull instancetype)initWithFrame:(CGRect) frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9];
       
        self.iUserNameLabel = [[UIButton alloc]initWithFrame:CGRectMake(10, (CGRectGetHeight(frame)-userNameLabelHeigh)/2, userNameLabelWidth, userNameLabelHeigh)];
        [self.iUserNameLabel setTitle:MTLocalized(@"classDemo_teacher")  forState:UIControlStateNormal];
        self.iUserNameLabel.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Light" size:12];
        self.iUserNameLabel.titleLabel.textColor=[UIColor whiteColor];
       
        [self.iUserNameLabel setBackgroundImage:[UIImage imageNamed:@"chatto_teacher.png"] forState:UIControlStateNormal];
        
        self.iMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.iUserNameLabel.frame)+10, CGRectGetMinY(_iUserNameLabel.frame), 0, userNameLabelHeigh)];
        
        [self.iMessageLabel setFont:[UIFont fontWithName:@"PingFang-SC-Light" size:12]];
        self.iMessageLabel.numberOfLines = 0;
        [self addSubview:self.iUserNameLabel];
        [self addSubview:self.iMessageLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
     //self.iMessageLabel.frame =CGRectMake(CGRectGetWidth(self.iUserNameLabel.frame)+10, 8, CGRectGetWidth(self.frame)-30, 13);
}
-(void)setIMessageString:(NSString *)iMessageString{
    _iMessageLabel.text = iMessageString;
    _iMessageString = iMessageString;
    CGFloat tWidth = [TKUtil widthForTextString:iMessageString height:12 fontSize:12];
     CGFloat tUserWidth = [TKUtil widthForTextString:_iUserNameString height:12 fontSize:12];
    _iMessageLabel.frame = CGRectMake(CGRectGetWidth(self.iUserNameLabel.frame)+12,  (21-userNameLabelHeigh)/2, tWidth, userNameLabelHeigh);
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), tUserWidth+tWidth+12, 21);
}
-(void)setIUserNameString:(NSString *)iUserNameString{
    _iUserNameString = iUserNameString;
//    _iUserNameLabel.titleLabel.text = iUserNameString;
    [_iUserNameLabel setTitle:iUserNameString forState:UIControlStateNormal];
    CGFloat tWidth = [TKUtil widthForTextString:iUserNameString height:12 fontSize:12];
     CGFloat tMessageWidth = [TKUtil widthForTextString:_iMessageString height:12 fontSize:12];
    _iUserNameLabel.frame = CGRectMake(10,(21-userNameLabelHeigh)/2,tWidth,userNameLabelHeigh);
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), tMessageWidth+tWidth+12, 21);
}



@end

//
//  TKClassTimeView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/8.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKClassTimeView.h"
#import "TKMacro.h"
#import "TKUtil.h"
static const CGFloat sTimeWithViewCap = 5;
static const CGFloat sColonWidth = 10;

@interface TKClassTimeView ()
@property (nonatomic,retain)UILabel *iHourLabel;
@property (nonatomic,retain)UILabel *iMinuteLabel;
@property (nonatomic,retain)UILabel *iSecondLabel;
@property (nonatomic,retain)UILabel *iColonLabel;
@property (nonatomic,retain)UILabel *iColon2Label;
@property (nonatomic, strong) NSTimer *iClassTimetimer;
@property (nonatomic, assign) NSTimeInterval iLocalTime;
@end

@implementation TKClassTimeView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView:frame];
    }
    return  self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
       
    }
    return self;
}
-(void)initView:(CGRect)aFrame{
    _iLocalTime = 0;
    CGFloat tMinWidth =CGRectGetHeight(aFrame)>CGRectGetWidth(aFrame)?CGRectGetWidth(aFrame):CGRectGetHeight(aFrame);
    
    
    CGFloat tWidth = tMinWidth-sTimeWithViewCap*2;

    //最小是5
    if (tMinWidth < sTimeWithViewCap*2) {
        tWidth = tMinWidth;
    }
    _iHourLabel = ({
    
        UILabel *tHourLabel = [[UILabel alloc]initWithFrame:CGRectMake(sTimeWithViewCap, sTimeWithViewCap, tWidth, tWidth)];
        tHourLabel.textColor      =  RGBCOLOR(217, 217, 217);
        tHourLabel.text = @"00";
        tHourLabel.textAlignment = NSTextAlignmentCenter;
        tHourLabel.backgroundColor = RGBCOLOR(38, 38, 38);
        [TKUtil setCornerForView:tHourLabel];
        tHourLabel;
    
        
    });
    
    [self addSubview:_iHourLabel];
    _iColonLabel = ({
        
        UILabel *tColonLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iHourLabel.frame), CGRectGetMinY(_iHourLabel.frame), sColonWidth, tWidth)];
        tColonLabel.text = @":";
        tColonLabel.textAlignment = NSTextAlignmentCenter;
        tColonLabel.textColor      =  RGBCOLOR(217, 217, 217);
        tColonLabel.backgroundColor = [UIColor clearColor];
        
        tColonLabel;
        
        
    });
     [self addSubview:_iColonLabel];
    _iMinuteLabel = ({
        
        UILabel *tMinuteLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iColonLabel.frame), CGRectGetMinY(_iHourLabel.frame), tWidth, tWidth)];
        tMinuteLabel.textColor      =  RGBCOLOR(217, 217, 217);
        tMinuteLabel.text = @"00";
        tMinuteLabel.textAlignment = NSTextAlignmentCenter;
        tMinuteLabel.backgroundColor = RGBCOLOR(38, 38, 38);
        [TKUtil setCornerForView:tMinuteLabel];
        tMinuteLabel;
        
        
    });
    [self addSubview:_iMinuteLabel];
    _iColon2Label = ({
        
        UILabel *tColon2Label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iMinuteLabel.frame), CGRectGetMinY(_iHourLabel.frame), sColonWidth, tWidth)];
        tColon2Label.textColor      =  RGBCOLOR(217, 217, 217);
        tColon2Label.backgroundColor = [UIColor clearColor];
        tColon2Label.text = @":";
        tColon2Label.textAlignment = NSTextAlignmentCenter;
        [TKUtil setCornerForView:tColon2Label];
        tColon2Label;
        
        
    });
    [self addSubview:_iColon2Label];
    _iSecondLabel = ({
        
        UILabel *tSecondLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iColon2Label.frame), CGRectGetMinY(_iHourLabel.frame), tWidth, tWidth)];
        tSecondLabel.textColor      =  RGBCOLOR(217, 217, 217);
        tSecondLabel.backgroundColor = RGBCOLOR(38, 38, 38);
        tSecondLabel.text = @"00";
        tSecondLabel.textAlignment = NSTextAlignmentCenter;
        [TKUtil setCornerForView:tSecondLabel];
        tSecondLabel;
        
        
    });
   [self addSubview:_iSecondLabel];
    _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(classBegin)
                                                      userInfo:nil
                                                       repeats:YES];
    [_iClassTimetimer setFireDate:[NSDate distantFuture]];
    
   
    
}
-(void)classBegin{
    _iLocalTime +=1;
    [self setClassTime:_iLocalTime];
}

-(void)invalidateClassBeginTime{
    [_iClassTimetimer invalidate];
    _iLocalTime = 0;
    _iClassTimetimer = nil;
}

-(void)startClassBeginTimer{
     [_iClassTimetimer setFireDate:[NSDate date]];
}


-(void)setClassTime:(NSTimeInterval)aLocalTime{
    
    _iLocalTime = aLocalTime;
    NSString * H = @"0";
    NSString * M = @"0";
    NSString * S = @"0";
    long temps = aLocalTime;
    //long temps = 1;
    long tempm = temps / 60;
    long temph = tempm / 60;
    long sec = temps - tempm * 60;
    tempm = tempm - temph * 60;
    H = temph == 0 ? @"00" : temph >= 10 ? [NSString stringWithFormat:@"%@",@(temph)] : [NSString stringWithFormat:@"0%@",@(temph)];
    M = tempm == 0 ? @"00" : tempm >= 10 ? [NSString stringWithFormat:@"%@",@(tempm)] : [NSString stringWithFormat:@"0%@",@(tempm)];
    S = sec == 0 ? @"00" : sec >= 10 ? [NSString stringWithFormat:@"%@",@(sec)] : [NSString stringWithFormat:@"0%@",@(sec)];

    _iHourLabel.text   = H;
    _iMinuteLabel.text = M;
    _iSecondLabel.text = S;
    
    
}
@end

//
//  TKVideoFunctionView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/15.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKVideoFunctionView.h"
#import "TKButton.h"

@interface TKVideoFunctionView ()
@property (nonatomic,retain)TKButton *iButton1;
@property (nonatomic,retain)TKButton *iButton2;
@property (nonatomic,retain)TKButton *iButton3;
@property (nonatomic,retain)TKButton *iButton4;
@property (nonatomic,assign)EVideoRole iVideoRole;
@end

@implementation TKVideoFunctionView
//291*70
-(instancetype)initWithFrame:(CGRect)frame withType:(int)type aVideoRole:(EVideoRole)aVideoRole{
    
    if (self = [super initWithFrame:frame]) {
        
        _iVideoRole =aVideoRole;
        
        CGFloat tHeight = CGRectGetHeight(frame);
        
        CGFloat tPoroFloat = 4.0;
        
        if (aVideoRole == EVideoRoleTeacher) {
            tPoroFloat = 2.0;
        }
        CGFloat tWidth = (CGRectGetWidth(frame)-20)/tPoroFloat;
       
        _iButton1 = ({
        
            TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
            [tButton setImage:LOADIMAGE(@"icon_control_tools_01") forState:UIControlStateNormal];
            [tButton setTitle:@"授权涂鸦" forState:UIControlStateNormal];
            [tButton setImage:LOADIMAGE(@"icon_control_tools_02") forState:UIControlStateSelected];
            [tButton setTitle:@"关闭涂鸦" forState:UIControlStateSelected];
            tButton.titleLabel.font = TKFont(13);
            [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
            tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
            [tButton addTarget:self  action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
            tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
            tButton.frame = CGRectMake(0, 0, tWidth, tHeight);
            tButton;
        
        });
       
        _iButton2 = ({
            
            TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];

            [tButton setImage:LOADIMAGE(@"icon_control_up") forState:UIControlStateNormal];
            [tButton setTitle:@"上讲台" forState:UIControlStateNormal];

            [tButton setImage:LOADIMAGE(@"icon_control_down") forState:UIControlStateSelected];
            [tButton setTitle:@"下讲台" forState:UIControlStateSelected];
            
            tButton.titleLabel.font = TKFont(13);
            [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
             tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
             [tButton addTarget:self  action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
            tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
            tButton.frame = CGRectMake(tWidth, 0, tWidth, tHeight);
            tButton;
            
        });
        _iButton3 = ({
            
            TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
            [tButton setImage:LOADIMAGE(@"icon_control_audio")  forState:UIControlStateNormal];
            [tButton setTitle:@"打开音频" forState:UIControlStateNormal];
            
            [tButton setImage:LOADIMAGE(@"icon_control_mute")  forState:UIControlStateSelected];
            [tButton setTitle:@"关闭音频" forState:UIControlStateSelected];
            
            tButton.titleLabel.font = TKFont(13);
            [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
              [tButton addTarget:self  action:@selector(button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
             tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
            tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
            tButton.frame = CGRectMake(tWidth*2, 0, tWidth, tHeight);
            tButton;
            
        });
        _iButton4= ({
            
            TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
            [tButton setImage:LOADIMAGE(@"icon_control_gift")  forState:UIControlStateNormal];
            [tButton setTitle:@"发礼物" forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(13);
            [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
            [tButton addTarget:self  action:@selector(button4Clicked:) forControlEvents:UIControlEventTouchUpInside];
             tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
            tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
            tButton.frame = CGRectMake(tWidth*3, 0, tWidth, tHeight);
            tButton;
            
        });
       
        self.backgroundColor = RGBCOLOR(31, 31, 31);
        
        
        if (aVideoRole == EVideoRoleTeacher) {
            _iButton1 = ({
                
                TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
                
                //[tButton setImage:LOADIMAGE(@"icon_control_up") forState:UIControlStateNormal];
                //[tButton setTitle:@"上讲台" forState:UIControlStateNormal];
              
                //
                [tButton setImage:LOADIMAGE(@"icon_control_camera_01") forState:UIControlStateNormal];
                [tButton setTitle:@"打开视频" forState:UIControlStateNormal];
                [tButton setImage:LOADIMAGE(@"icon_control_camera_02") forState:UIControlStateSelected];
                [tButton setTitle:@"关闭视频" forState:UIControlStateSelected];
                
                tButton.titleLabel.font = TKFont(13);
                [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
                tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
                [tButton addTarget:self  action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
                tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
                tButton.frame = CGRectMake(0, 0, tWidth, tHeight);
                tButton;
                
            });
            _iButton2 = ({
                
                TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
                
                [tButton setImage:LOADIMAGE(@"icon_control_audio")  forState:UIControlStateNormal];
                [tButton setTitle:@"打开音频" forState:UIControlStateNormal];
                
                [tButton setImage:LOADIMAGE(@"icon_control_mute")  forState:UIControlStateSelected];
                [tButton setTitle:@"关闭音频" forState:UIControlStateSelected];
                tButton.titleLabel.font = TKFont(13);
                [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
                [tButton addTarget:self  action:@selector(button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
                tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
                tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
                tButton.frame = CGRectMake(tWidth, 0, tWidth, tHeight);
                tButton;
                
            });
            [self addSubview:_iButton1];
            [self addSubview:_iButton2];
            _iButton1.selected = YES;
            _iButton2.selected = YES;
           
        }else{
            [self addSubview:_iButton1];
            [self addSubview:_iButton2];
            [self addSubview:_iButton3];
            [self addSubview:_iButton4];
            _iButton1.selected = NO;
            _iButton2.selected = YES;
            _iButton3.selected = YES;
            _iButton4.selected = NO;
        }
        
       
      
       
        [TKUtil setCornerForView:self];
        //1 代表冲右
        if (type) {
            UIImageView *tImagevew = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame), (CGRectGetHeight(frame)-18)/2.0, 8, 18)];
            tImagevew.image = LOADIMAGE(@"triangle_02");
           
            [self addSubview:tImagevew];
        }else{
            //代表冲下
            UIImageView *tImagevew = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_iButton1.frame)+18/2, CGRectGetHeight(frame), 18, 8)];
            tImagevew.image = LOADIMAGE(@"triangle_01");
            [self addSubview:tImagevew];
        }
       
    }
    
    
    return self;
    
}

-(void)button1Clicked:(UIButton *)tButton{
    tButton.selected = !tButton.selected;
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallbutton1:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallbutton1:tButton aVideoRole:_iVideoRole];
    }
    
}
-(void)button2Clicked:(UIButton *)tButton{
    tButton.selected = !tButton.selected;
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton2:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton2:tButton aVideoRole:_iVideoRole];
    }
     
}
-(void)button3Clicked:(UIButton *)tButton{
    tButton.selected = !tButton.selected;
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton3:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton3:tButton aVideoRole:_iVideoRole];
    }
}
-(void)button4Clicked:(UIButton *)tButton{
    tButton.selected = !tButton.selected;
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton4:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton4:tButton aVideoRole:_iVideoRole];
    }
    
}
@end

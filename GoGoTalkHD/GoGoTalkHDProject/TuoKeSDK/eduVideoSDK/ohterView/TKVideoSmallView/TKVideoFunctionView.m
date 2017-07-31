//
//  TKVideoFunctionView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/15.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKVideoFunctionView.h"
#import "TKButton.h"
#import "TKEduSessionHandle.h"

@interface TKVideoFunctionView ()
@property (nonatomic,retain)TKButton *iButton1;
@property (nonatomic,retain)TKButton *iButton2;
@property (nonatomic,retain)TKButton *iButton3;
@property (nonatomic,retain)TKButton *iButton4;
@property (nonatomic,assign)EVideoRole iVideoRole;
@end

@implementation TKVideoFunctionView
//291*70
-(instancetype)initWithFrame:(CGRect)frame withType:(int)type aVideoRole:(EVideoRole)aVideoRole aRoomUer:(RoomUser*)aRoomUer{
    
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
            [tButton setTitle:MTLocalized(@"Button.AllowDoodle") forState:UIControlStateNormal];
            [tButton setImage:LOADIMAGE(@"icon_control_tools_02") forState:UIControlStateSelected];
            [tButton setTitle:MTLocalized(@"Button.CancelDoodle") forState:UIControlStateSelected];
            tButton.titleLabel.font = TKFont(13);
            [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
            tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
            [tButton addTarget:self  action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
            tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
            tButton.frame = CGRectMake(0, 0, tWidth, tHeight);
            tButton.selected = aRoomUer.canDraw;
            tButton;
        
        });
       
        _iButton2 = ({
            
            TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];

            [tButton setImage:LOADIMAGE(@"icon_control_up") forState:UIControlStateNormal];
            [tButton setTitle:MTLocalized(@"Button.UpPlatform") forState:UIControlStateNormal];
            
            [tButton setImage:LOADIMAGE(@"icon_control_down") forState:UIControlStateSelected];
            [tButton setTitle:MTLocalized(@"Button.DownPlatform") forState:UIControlStateSelected];
            
            tButton.titleLabel.font = TKFont(13);
            tButton.selected = (aRoomUer.publishState == PublishState_VIDEOONLY ||
                                aRoomUer.publishState == PublishState_BOTH);
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
            [tButton setTitle:MTLocalized(@"Button.OpenAudio") forState:UIControlStateNormal];
            [tButton setImage:LOADIMAGE(@"icon_control_mute")  forState:UIControlStateSelected];
            [tButton setTitle:MTLocalized(@"Button.CloseAudio") forState:UIControlStateSelected];
            BOOL isSelected = (aRoomUer.publishState == PublishState_BOTH) || (aRoomUer.publishState == PublishState_AUDIOONLY);
            tButton.selected = isSelected;
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
            [tButton setTitle:MTLocalized(@"Button.GiveCup") forState:UIControlStateNormal];
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
                [tButton setTitle:MTLocalized(@"Button.OpenVideo") forState:UIControlStateNormal];
                [tButton setImage:LOADIMAGE(@"icon_control_camera_02") forState:UIControlStateSelected];
                [tButton setTitle:MTLocalized(@"Button.CloseVideo") forState:UIControlStateSelected];
                 tButton.selected = [[TKEduSessionHandle shareInstance]sessionHandleIsVideoEnabled];
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
                
                [tButton setImage:LOADIMAGE(@"icon_control_audio")  forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.OpenAudio") forState:UIControlStateNormal];
                
                [tButton setImage:LOADIMAGE(@"icon_control_mute")  forState:UIControlStateSelected];
                [tButton setTitle:MTLocalized(@"Button.CloseAudio") forState:UIControlStateSelected];
                tButton.titleLabel.font = TKFont(13);
                 tButton.selected = [[TKEduSessionHandle shareInstance]sessionHandleIsAudioEnabled];
                [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
                [tButton addTarget:self  action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
                tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
                tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
                tButton.frame = CGRectMake(tWidth, 0, tWidth, tHeight);
                tButton;
                
            });
            [self addSubview:_iButton1];
            [self addSubview:_iButton2];
         
           
        }else{
            [self addSubview:_iButton1];
            [self addSubview:_iButton2];
            [self addSubview:_iButton3];
            [self addSubview:_iButton4];

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
   
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallbutton1:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallbutton1:tButton aVideoRole:_iVideoRole];
    }
    
}
-(void)button2Clicked:(UIButton *)tButton{
   
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton2:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton2:tButton aVideoRole:_iVideoRole];
    }
     
}
-(void)button3Clicked:(UIButton *)tButton{
   
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton3:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton3:tButton aVideoRole:_iVideoRole];
    }
}
-(void)button4Clicked:(UIButton *)tButton{
   
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton4:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton4:tButton aVideoRole:_iVideoRole];
    }
    
}
@end

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

#import "TKEduRoomProperty.h"

@interface TKVideoFunctionView ()
@property (nonatomic,retain)TKButton *iButton1;
@property (nonatomic,retain)TKButton *iButton2;
@property (nonatomic,retain)TKButton *iButton3;
@property (nonatomic,retain)TKButton *iButton4;
@property (nonatomic,retain)TKButton *iButton5;
@property (nonatomic,retain)TKButton *iButton6;
@property (nonatomic,assign)EVideoRole iVideoRole;
@end

@implementation TKVideoFunctionView
//291*70
-(instancetype)initWithFrame:(CGRect)frame withType:(int)type aVideoRole:(EVideoRole)aVideoRole aRoomUer:(RoomUser*)aRoomUer isSplit:(BOOL)isSplit{
    
    if (self = [super initWithFrame:frame]) {
        _iRoomUer = aRoomUer;
        _iVideoRole =aVideoRole;
        
        CGFloat tHeight = CGRectGetHeight(frame);
        
        CGFloat tPoroFloat = 0;
        
        if (aRoomUer.disableVideo == YES) {
            if (aRoomUer.disableAudio == YES) {
                tPoroFloat = 4;
            } else {
                tPoroFloat = 5;
            }
        } else {
            if (aRoomUer.disableAudio == YES) {
                tPoroFloat = 5;
            } else {
                tPoroFloat = 6;
            }
        }
        
        //CGFloat tPoroFloat = aRoomUer.disableAudio ? 3.0 : 4.0;
    
        if (aVideoRole == EVideoRoleTeacher || (aVideoRole != EVideoRoleTeacher && [aRoomUer.peerID isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID])) {
            if ([TKEduSessionHandle shareInstance].roomMgr.allowStudentCloseAV && aRoomUer.role == 2) {
                tPoroFloat = 2.0;
            }else{
                
                TKEduSessionHandle *tSessionHandle = [TKEduSessionHandle shareInstance];
                TKEduRoomProperty *tRoomProperty = tSessionHandle.iRoomProperties;
                if ([tRoomProperty.iPadLayout isEqualToString:SHARKTOP_COMPANY]) {
                    if ([[TKEduSessionHandle shareInstance] roomType] != RoomType_OneToOne && ![TKEduSessionHandle shareInstance].isClassBegin && [[TKEduSessionHandle shareInstance] localUser].role == EVideoRoleTeacher) {
                        tPoroFloat = 3.0;//3.0    4.0  这里还需要判断是什么模板
                    }else{
                        tPoroFloat = 4.0;//3.0    4.0  这里还需要判断是什么模板
                    }
                    
                }else{
                    tPoroFloat = 3.0;
                }
            }
            
        }
        
        // 不显示学生的关闭视频按钮，减一个位置
        if (aVideoRole != EVideoRoleTeacher && ![aRoomUer.peerID isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID]) {
//            tPoroFloat = tPoroFloat - 1;
        }
        
        // 如果是助教，只显示下台和关音频2个
        if (aRoomUer.role == UserType_Assistant) {
            tPoroFloat = 4;
        }
        
        //如果是1v1课堂减少分屏按钮
        if ( [[TKEduSessionHandle shareInstance] roomType] == RoomType_OneToOne && (aRoomUer.role == UserType_Teacher || aRoomUer.role == UserType_Student) && [[TKEduSessionHandle shareInstance] localUser].role == EVideoRoleTeacher) {
            tPoroFloat = tPoroFloat - 1;
        }
        if ([[TKEduSessionHandle shareInstance] roomType] != RoomType_OneToOne && ![TKEduSessionHandle shareInstance].isClassBegin && [[TKEduSessionHandle shareInstance] localUser].role == EVideoRoleTeacher) {
            tPoroFloat = tPoroFloat -1;
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
            [tButton addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            //修改部分
            tButton.imageRect = CGRectMake((tWidth-30)/2.0 - 10, (tHeight-50)/2.0, 30, 30);
            tButton.titleRect = CGRectMake(-10, tHeight-30, tWidth, 20);
            tButton.frame = CGRectMake(20, 0, tWidth, tHeight);
//            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
//            tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
//            tButton.frame = CGRectMake(0, 0, tWidth, tHeight);
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
            //tButton.selected = (aRoomUer.publishState == PublishState_VIDEOONLY || aRoomUer.publishState == PublishState_BOTH);
            tButton.selected = (aRoomUer.publishState != PublishState_NONE);    // 除了None状态，剩余都在台上
            [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
             tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
             [tButton addTarget:self  action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
            //修改部分
            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-50)/2.0, 30, 30);
            tButton.titleRect = CGRectMake(0, tHeight-30, tWidth, 20);
//            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
//            tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
            tButton.frame = CGRectMake(10+tWidth, 0, tWidth, tHeight);
            tButton;
            
        });
        
        if (aRoomUer.disableVideo == NO) {
            _iButton5 = ({//关闭视频
                
                TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
                [tButton setImage:LOADIMAGE(@"icon_control_camera_01")  forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.OpenVideo") forState:UIControlStateNormal];
                [tButton setImage:LOADIMAGE(@"icon_control_camera_02")  forState:UIControlStateSelected];
                [tButton setTitle:MTLocalized(@"Button.CloseVideo") forState:UIControlStateSelected];
                BOOL isSelected = (aRoomUer.publishState == PublishState_BOTH) || (aRoomUer.publishState == PublishState_VIDEOONLY);
                tButton.selected = isSelected;
                tButton.titleLabel.font = TKFont(13);
                [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
                [tButton addTarget:self  action:@selector(button5Clicked:) forControlEvents:UIControlEventTouchUpInside];
                tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
                //修改部分2
                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-50)/2.0, 30, 30);
                tButton.titleRect = CGRectMake(0, tHeight-30, tWidth, 20);
//                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
//                tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
                tButton.frame = CGRectMake(10+tWidth*3, 0, tWidth, tHeight);
                tButton;
                
            });
        }
        
        if (aRoomUer.disableAudio == NO) {
            
            _iButton3 = ({//关闭音频
                
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
                //修改部分
                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-50)/2.0, 30, 30);
                tButton.titleRect = CGRectMake(0, tHeight-30, tWidth, 20);
                //            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
                //            tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
                //tButton.frame = CGRectMake((aRoomUer.disableVideo?tWidth*2:tWidth*3)+10 , 0, tWidth, tHeight);
                tButton.frame = CGRectMake((aRoomUer.disableVideo?tWidth*1:tWidth*2)+10 , 0, tWidth, tHeight);  // 不显示关闭视频按钮，减一个位置
                tButton;
                
            });
        }

        _iButton4= ({//发送奖杯
            
            TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
            [tButton setImage:LOADIMAGE(@"icon_control_gift")  forState:UIControlStateNormal];
            [tButton setTitle:MTLocalized(@"Button.GiveCup") forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(13);
            [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
            [tButton addTarget:self  action:@selector(button4Clicked:) forControlEvents:UIControlEventTouchUpInside];
             tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
            //修改部分
            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-50)/2.0, 30, 30);
            tButton.titleRect = CGRectMake(0, tHeight-30, tWidth, 20);
            //tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
            //tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
            CGFloat x = 0;
            if (aRoomUer.disableAudio == YES) {
                if (aRoomUer.disableVideo == YES) {
                    x = tWidth * 2;
                } else {
                    x = tWidth * 3;
                }
            } else {
                if (aRoomUer.disableVideo == YES) {
                    x = tWidth * 3;
                } else {
                    x = tWidth * 4;
                }
            }
//            x = x - tWidth;     // 不显示关闭视频按钮，减一个位置
            tButton.frame = CGRectMake(10+x, 0, tWidth, tHeight);
            tButton;
            
        });
       
        self.backgroundColor = RGBCOLOR(31, 31, 31);
        
        _iButton6 = ({//演讲
            TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
            [tButton setImage:LOADIMAGE(@"icon_split_normal")  forState:UIControlStateNormal];
            [tButton setTitle:MTLocalized(@"Button.Speech") forState:UIControlStateNormal];
            [tButton setImage:LOADIMAGE(@"icon_oneKeyReset_normal")  forState:UIControlStateSelected];
            [tButton setTitle:MTLocalized(@"Button.Recovery") forState:UIControlStateSelected];
            
            tButton.titleLabel.font = TKFont(13);
            [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
            [tButton addTarget:self  action:@selector(button6Clicked:) forControlEvents:UIControlEventTouchUpInside];
            tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
            //修改部分2
            tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-50)/2.0, 30, 30);
            tButton.titleRect = CGRectMake(0, tHeight-30, tWidth, 20);
            //                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
            //                tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
            tButton.frame = CGRectMake(10+tWidth*5, 0, tWidth, tHeight);
            tButton;
            
        });
        
        
        if (aVideoRole == EVideoRoleTeacher) {
            
            _iButton1 = ({//关闭视频
                
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
                //修改部分
                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-50)/2.0, 30, 30);
                tButton.titleRect = CGRectMake(0, tHeight-30, tWidth, 20);
                //                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
                //                tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
                tButton.frame = CGRectMake(tWidth, 0, tWidth, tHeight);
                tButton;
                
            });
            _iButton2 = ({//关闭音频
                
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
                //修改部分
                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-50)/2.0, 30, 30);
                tButton.titleRect = CGRectMake(0, tHeight-30, tWidth, 20);
//                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
//                tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
                tButton.frame = CGRectMake(0, 0, tWidth, tHeight);
                tButton;
                
            });
            _iButton3 = ({//全部恢复
                
                TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
                [tButton setImage:LOADIMAGE(@"icon_allReset")  forState:UIControlStateNormal];
                [tButton setTitle:MTLocalized(@"Button.OneKeyRecovery") forState:UIControlStateNormal];
                [tButton setImage:LOADIMAGE(@"icon_allReset")  forState:UIControlStateSelected];
                [tButton setTitle:MTLocalized(@"Button.OneKeyRecovery") forState:UIControlStateSelected];
                
                tButton.titleLabel.font = TKFont(13);
                [tButton setTitleColor:RGBCOLOR(181, 181, 181) forState:UIControlStateNormal];
                [tButton addTarget:self  action:@selector(buttonReset:) forControlEvents:UIControlEventTouchUpInside];
                tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
                //修改部分2
                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-50)/2.0, 30, 30);
                tButton.titleRect = CGRectMake(0, tHeight-30, tWidth, 20);
                //                tButton.imageRect = CGRectMake((tWidth-30)/2.0, (tHeight-30)/2.0, 30, 30);
                //                tButton.titleRect = CGRectMake(0, tHeight-20, tWidth, 20);
                tButton.frame = CGRectMake(tWidth*2, 0, tWidth, tHeight);
                tButton;
                
                
            });
            
            [self addSubview:_iButton1];
            [self addSubview:_iButton2];
           
            if ([TKEduSessionHandle shareInstance].isClassBegin) {
                [self addSubview:_iButton3];
            }
            if(tPoroFloat == 4.0)
            {
                _iButton3.frame = CGRectMake(tWidth*3, 0, tWidth, tHeight);
                _iButton6.frame = CGRectMake(tWidth*2, 0, tWidth, tHeight);
                [self addSubview:_iButton6];
                
            }
         
           
        } else if ([aRoomUer.peerID isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID] && aVideoRole != EVideoRoleTeacher) {
            _iButton3.frame = CGRectMake(10, 0, tWidth, tHeight);
            _iButton5.frame = CGRectMake(10+tWidth, 0, tWidth, tHeight);
            [self addSubview:_iButton5];
            [self addSubview:_iButton3];
            [self addSubview:_iButton6];
        } else if (aRoomUer.role == UserType_Assistant) {
            _iButton2.frame = CGRectMake(10, 0, tWidth, tHeight);
            _iButton3.frame = CGRectMake(10+tWidth, 0, tWidth, tHeight);
            _iButton5.frame = CGRectMake(20+2*tWidth, 0, tWidth, tHeight);
            _iButton6.frame = CGRectMake(30+3*tWidth, 0, tWidth, tHeight);
            [self addSubview:_iButton2];
            [self addSubview:_iButton3];
            [self addSubview:_iButton5];
            [self addSubview:_iButton6];
        } else {
            
            CGFloat tWidth = (CGRectGetWidth(frame)-20)/(tPoroFloat-1);
            if (!isSplit) {
                [self addSubview:_iButton1];
            }else{
                _iButton2.frame = CGRectMake(10, 0, tWidth, tHeight);
                _iButton3.frame = CGRectMake(10+tWidth, 0, tWidth, tHeight);
                _iButton5.frame = CGRectMake(20+2*tWidth, 0, tWidth, tHeight);
                _iButton4.frame = CGRectMake(30+3*tWidth, 0, tWidth, tHeight);
                _iButton6.frame = CGRectMake(40+4*tWidth, 0, tWidth, tHeight);
            }
            [self addSubview:_iButton2];
            [self addSubview:_iButton3];
            [self addSubview:_iButton5];
            [self addSubview:_iButton4];
            [self addSubview:_iButton6];
            
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
-(void)button5Clicked:(UIButton *)tButton{
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton5:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton5:tButton aVideoRole:_iVideoRole];
    }
}
-(void)button6Clicked:(UIButton *)tButton{
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton6:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton6:tButton aVideoRole:_iVideoRole];
    }
}
- (void)buttonReset:(UIButton *)tButton{
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoOneKeyReset)]) {
        [(id<VideolistProtocol>)_iDelegate videoOneKeyReset];
    }
}
- (void)setIsSplitScreen:(BOOL)isSplitScreen{
    switch (_iVideoRole) {
        case EVideoRoleTeacher:
        {
            _iButton3.selected = isSplitScreen;
            
            _iButton6.selected = isSplitScreen;
        }
            break;
        case EVideoRoleOur:
        case EVideoRoleOther:
        {
            _iButton6.selected = isSplitScreen;
        }
            break;
        default:
            break;
    }
}
@end

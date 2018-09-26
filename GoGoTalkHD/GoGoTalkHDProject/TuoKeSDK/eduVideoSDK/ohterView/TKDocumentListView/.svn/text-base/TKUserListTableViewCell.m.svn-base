//
//  TKUserListTableViewCell.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/14.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKUserListTableViewCell.h"
#import "TKDocmentDocModel.h"
#import "TKMediaDocModel.h"
#import "RoomUser.h"
#import "TKUtil.h"
#import "TKEduBoardHandle.h"
#import "TKEduSessionHandle.h"

@implementation TKUserListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setupView
{
    CGFloat tWidth   = CGRectGetHeight(self.frame);
    CGFloat tViewCap =  4;
    CGFloat tWidthAndCap = tWidth + tViewCap;
    CGFloat tY = 0;
    CGFloat tX = CGRectGetWidth(self.frame)-tWidthAndCap*4;
    _iIconImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_user")];
    _iIconImageView.frame = CGRectMake(8, (CGRectGetHeight(self.frame)-30)/2, 30, 30);
    [self.contentView addSubview:_iIconImageView];
    _iNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iIconImageView.frame)+10, 0, CGRectGetWidth(self.frame)-2*tWidth-CGRectGetMaxX(_iIconImageView.frame)-90, CGRectGetHeight(self.frame))];
    _iNameLabel.textColor = RGBACOLOR_PromptWhite;
    _iNameLabel.backgroundColor = [UIColor clearColor];
    [_iNameLabel setFont:TEXT_FONT];
    [self.contentView addSubview:_iNameLabel];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor             = [UIColor clearColor];
   
    
    _iHandUpBtn = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.frame = CGRectMake(tX, tY, tWidth, tWidth);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button setImage: LOADIMAGE(@"btn_hand") forState:UIControlStateNormal];
        [button setImage: LOADIMAGE(@"btn_hand") forState:UIControlStateSelected];
        //[button addTarget:self action:@selector(Button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
        
    });
    [self.contentView addSubview:_iHandUpBtn];
    
    _iButton1 = ({
    
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tLeftButton.frame = CGRectMake(tX, tY, tWidth, tWidth);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [tLeftButton setImage: LOADIMAGE(@"btn_hand") forState:UIControlStateNormal];
        [tLeftButton setImage: LOADIMAGE(@"btn_hand") forState:UIControlStateSelected];
        [tLeftButton addTarget:self action:@selector(Button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        tLeftButton;
    
    });
   
     [self.contentView addSubview:_iButton1];
    _iButton2 = ({
        
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
       tLeftButton.frame = CGRectMake(tX+tWidthAndCap, tY, tWidth, tWidth);
        //        tLeftButton.center = CGPointMake(25+8, _titleView.center.y);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [tLeftButton setImage: LOADIMAGE(@"btn_down_normal") forState:UIControlStateNormal];
        [tLeftButton setImage: LOADIMAGE(@"btn_up_normal") forState:UIControlStateSelected];
        [tLeftButton addTarget:self action:@selector(Button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
        tLeftButton;
        
    });
     [self.contentView addSubview:_iButton2];
    _iButton3 = ({
        
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
         tLeftButton.frame = CGRectMake(tX+tWidthAndCap*2, tY, tWidth, tWidth);
        //        tLeftButton.center = CGPointMake(25+8, _titleView.center.y);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [tLeftButton setImage: LOADIMAGE(@"btn_audio_01_normal") forState:UIControlStateNormal];
        [tLeftButton setImage: LOADIMAGE(@"btn_audio_02_normal") forState:UIControlStateSelected];
        [tLeftButton addTarget:self action:@selector(Button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
        tLeftButton;
        
    });
     [self.contentView addSubview:_iButton3];
    _iButton4 = ({
        
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
         tLeftButton.frame = CGRectMake(tX+tWidthAndCap*3, tY, tWidth, tWidth);
        //        tLeftButton.center = CGPointMake(25+8, _titleView.center.y);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [tLeftButton setImage: LOADIMAGE(@"icon_control_tools_02") forState:UIControlStateNormal];
        [tLeftButton setImage: LOADIMAGE(@"btn_tools_02_normal") forState:UIControlStateSelected];
        [tLeftButton addTarget:self action:@selector(Button4Clicked:) forControlEvents:UIControlEventTouchUpInside];
        tLeftButton;
        
    });
     [self.contentView addSubview:_iButton4];
   
    // cell点击时不显示选中状态
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)resetView
{
    _iNameLabel.text = _text;
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat tWidth   = CGRectGetHeight(self.frame);
    CGFloat tViewCap =  4;
    CGFloat tWidthAndCap = tWidth + tViewCap;
    CGFloat tY = 0;
    CGFloat tX = CGRectGetWidth(self.frame)-tWidthAndCap*4;
    _iIconImageView.frame = CGRectMake(8, (CGRectGetHeight(self.frame)-30)/2, 30, 30);
    _iNameLabel.frame = CGRectMake(CGRectGetMaxX(_iIconImageView.frame)+10, 0, CGRectGetWidth(self.frame)-2*tWidth-CGRectGetMaxX(_iIconImageView.frame)-90, CGRectGetHeight(self.frame));
    _iButton1.frame = CGRectMake(tX, tY, tWidth, tWidth);
    _iButton2.frame = CGRectMake(tX+tWidthAndCap, tY, tWidth, tWidth);
    _iButton3.frame = CGRectMake(tX+tWidthAndCap*2, tY, tWidth, tWidth);
    _iButton4.frame = CGRectMake(tX+tWidthAndCap*3, tY, tWidth, tWidth);
    
    if (_iFileListType == FileListTypeUserList) {
        tWidth = 40;
        tY = _iIconImageView.frame.origin.y + _iIconImageView.frame.size.height / 2 - tWidth / 2;
        _iHandUpBtn.frame = CGRectMake(self.frame.size.width-5*tWidth, tY, tWidth, tWidth);
        _iButton1.frame = CGRectMake(self.frame.size.width-4*tWidth, tY, tWidth, tWidth);
        _iButton2.frame = CGRectMake(self.frame.size.width-3*tWidth, tY, tWidth, tWidth);
        _iButton3.frame = CGRectMake(self.frame.size.width-2*tWidth, tY, tWidth, tWidth);
        _iButton4.frame = CGRectMake(self.frame.size.width-tWidth, tY, tWidth, tWidth);
    }
    
}
-(void)configaration:(id)aModel withFileListType:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin{
     _iFileListType = aFileListType;
      [self clearButtonState];
    switch (_iFileListType) {
            //视频列表
        case FileListTypeAudioAndVideo:
        {
            _iButton1.hidden = YES;
            _iButton2.hidden = YES;
            TKMediaDocModel *tMediaModel =(TKMediaDocModel*) aModel;
            NSString *tTypeString = [TKUtil docmentOrMediaImage:tMediaModel.filetype?tMediaModel.filetype:[tMediaModel.filename pathExtension]];

            
            _iIconImageView.image = LOADIMAGE(tTypeString);
            _iButton3.selected = NO;
            _iButton4.selected = NO;
            _iNameLabel.text = tMediaModel.filename;
            _iButton3.hidden = NO;
            _iButton4.hidden = _hiddenDeleteBtn;
            TKMediaDocModel *tCurrentMediaModel = [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
            BOOL tIsCurrentDocment =[[TKEduSessionHandle shareInstance]isEqualFileId:tMediaModel aSecondModel:tCurrentMediaModel];
            _iButton3.selected = tIsCurrentDocment;

            [_iButton3 setImage: LOADIMAGE(@"btn_play_normal") forState:UIControlStateNormal];
            [_iButton3 setImage: LOADIMAGE(@"btn_play_normal") forState:UIControlStateSelected];
            [_iButton4 setImage: LOADIMAGE(@"btn_delete_normal") forState:UIControlStateNormal];
            [_iButton4 setImage: LOADIMAGE(@"btn_delete_pressed") forState:UIControlStateHighlighted];
            [_iButton4 setImage: LOADIMAGE(@"btn_delete_pressed") forState:UIControlStateSelected];
        }
            break;
            // 文档列表
        case FileListTypeDocument:
        {
            _iButton1.hidden = YES;
            _iButton2.hidden = YES;
            TKDocmentDocModel *tDocModel =(TKDocmentDocModel*) aModel;
             NSString *tTypeString = [TKUtil docmentOrMediaImage:tDocModel.filetype?tDocModel.filetype:[tDocModel.filename pathExtension]];
             TKDocmentDocModel *tCurrentDocModel = [TKEduSessionHandle shareInstance].iCurrentDocmentModel;
            BOOL tIsCurrentDocment = [[TKEduSessionHandle shareInstance]isEqualFileId:tDocModel aSecondModel:tCurrentDocModel];
            TKLog(@"------current %@ %@", [TKEduSessionHandle shareInstance].iCurrentDocmentModel.fileid, tDocModel.fileid);
            
            _iIconImageView.image = LOADIMAGE(tTypeString);
            _iNameLabel.text = tDocModel.filename;
            _iButton3.selected = NO;
            _iButton4.selected = _hiddenDeleteBtn;
            if ([tDocModel.filetype isEqualToString:(@"whiteboard")]) {
                //_iButton3.hidden = YES;
                _iButton3.hidden = NO;              // 白板的眼睛也需要显示出来
                [_iButton3 setImage: LOADIMAGE(@"btn_eyes_01_normal") forState:UIControlStateNormal];
                [_iButton3 setImage: LOADIMAGE(@"btn_eyes_02_normal") forState:UIControlStateSelected];
                _iButton3.selected = tIsCurrentDocment;
                
                _iButton4.hidden = YES;
            }else{
                _iButton3.hidden = NO;
                _iButton4.hidden = _hiddenDeleteBtn;
                _iButton3.selected = tIsCurrentDocment;
                [_iButton3 setImage: LOADIMAGE(@"btn_eyes_01_normal") forState:UIControlStateNormal];
                [_iButton3 setImage: LOADIMAGE(@"btn_eyes_02_normal") forState:UIControlStateSelected];
                [_iButton4 setImage: LOADIMAGE(@"btn_delete_normal") forState:UIControlStateNormal];
                [_iButton4 setImage: LOADIMAGE(@"btn_delete_pressed") forState:UIControlStateHighlighted];
                [_iButton4 setImage: LOADIMAGE(@"btn_delete_pressed") forState:UIControlStateSelected];
            }
          

        }
            break;
            //用户列表
        case FileListTypeUserList:
        {
            RoomUser *tRoomUser =(RoomUser*) aModel;
            RoomUser *tPublishUser = [[[TKEduSessionHandle shareInstance]publishUserDic]objectForKey:tRoomUser.peerID];
            RoomUser *tUnPublishUser = [[[TKEduSessionHandle shareInstance]unpublishUserDic]objectForKey:tRoomUser.peerID];
            RoomUser *tPendUser = [[[TKEduSessionHandle shareInstance]pendingUserDic]objectForKey:tRoomUser.peerID];
        
            // 发布状态，0：未发布，1：发布音频；2：发布视频；3：发布音视频
            switch (tRoomUser.publishState) {
                case PublishState_NONE:
                {
                    _iButton2.selected = NO;
                    _iButton3.selected = NO;
                   break;
                }
                case PublishState_AUDIOONLY:
                {
                    _iButton2.selected = NO ;
                    _iButton3.selected = YES;
                   break;
                }
                case PublishState_VIDEOONLY:
                {
                    _iButton2.selected = YES;
                    _iButton3.selected = NO;
                   break;
                }
                case PublishState_BOTH:
                {
                    _iButton2.selected = YES;
                    _iButton3.selected = YES;
                }
                    break;
                    
                default:
                    break;
            }
            
           
            if (!isClassBegin || ((tRoomUser.role != UserType_Student) && (tRoomUser.role != UserType_Assistant) ) || ((tRoomUser.role == UserType_Assistant) && [TKEduSessionHandle shareInstance].iIsAssitOpenVInit == 0)) {
                _iHandUpBtn.hidden = YES;
                _iButton1.hidden = YES;
                _iButton2.hidden = YES;
                _iButton3.hidden = YES;
                _iButton4.hidden = YES;
                
                _iButton1.enabled = YES;
                _iButton2.enabled = YES;
                _iButton3.enabled = YES;
                _iButton4.enabled = YES;
            }else{
                _iHandUpBtn.hidden = ![[tRoomUser.properties objectForKey:sRaisehand]boolValue];
                _iButton1.hidden = NO; //![[tRoomUser.properties objectForKey:sRaisehand]boolValue];
                _iButton2.hidden = NO;
                _iButton3.hidden = NO;
                _iButton4.hidden = NO;
                _iButton4.selected = tRoomUser.canDraw;
                
                _iButton1.enabled = YES;
                _iButton2.enabled = YES;
                _iButton3.enabled = YES;
                _iButton4.enabled = YES;
            }
            
            //用设备图标替换用户头像
            NSMutableDictionary *properties = tRoomUser.properties;
            NSString *devicetype = properties[@"devicetype"];
            NSString *deviceImg;
            if ([devicetype isEqualToString:@"AndroidPad"] || [devicetype isEqualToString:@"iPad"] || [devicetype isEqualToString:@"AndroidPhone"] || [devicetype isEqualToString:@"iPhone"] || [devicetype isEqualToString:@"WindowClient"] || [devicetype isEqualToString:@"WindowPC"] || [devicetype isEqualToString:@"MacClient"] || [devicetype isEqualToString:@"MacPC"] || [devicetype isEqualToString:@"AndroidTV"]
                ) {
                deviceImg = [NSString stringWithFormat:@"icon_%@",properties[@"devicetype"]];
            }else{
                deviceImg = @"icon_unknown";
            }
            _iIconImageView.contentMode = UIViewContentModeCenter;
            _iIconImageView.image = LOADIMAGE(deviceImg);
            
            // 当用被墙了，图标变化
            if ([tRoomUser.properties objectForKey:sUdpState]) {
                NSInteger udpState = [[tRoomUser.properties objectForKey:sUdpState] integerValue];
                if (udpState == 2) {
                    NSString *deviceImg1 = [NSString stringWithFormat:@"icon_%@_udp",properties[@"devicetype"]];
                    _iIconImageView.image = LOADIMAGE(deviceImg1);
                } else {
                    _iIconImageView.image = LOADIMAGE(deviceImg);
                }
            }
            
            //昵称 （身份）
            NSAttributedString * attrStr =  [[NSAttributedString alloc]initWithData:[tRoomUser.nickName dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
          
//            NSArray *userTypeArray = [NSArray arrayWithObjects:MTLocalized(@"Role.Teacher"),MTLocalized(@"Role.Assistant"),MTLocalized(@"Role.Student"),@"直播",MTLocalized(@"Role.Patrol"), nil];//直播只是占个位
            
            NSString *nickAndRole = [NSString stringWithFormat:@"%@",attrStr.string];
            _iNameLabel.text = nickAndRole ;
            _iNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

            switch (tRoomUser.role) {
                case UserType_Teacher:
                    
                    [_iButton1 setImage: LOADIMAGE(@"teacher_down") forState:UIControlStateNormal];
                    [_iButton1 setImage: LOADIMAGE(@"teacher_up") forState:UIControlStateSelected];
                    break;
                case UserType_Student:
                    
                    [_iButton1 setImage: LOADIMAGE(@"student_down") forState:UIControlStateNormal];
                    [_iButton1 setImage: LOADIMAGE(@"student_up") forState:UIControlStateSelected];
                    break;
                case UserType_Assistant:
                    
                    [_iButton1 setImage: LOADIMAGE(@"assistant-down") forState:UIControlStateNormal];
                    [_iButton1 setImage: LOADIMAGE(@"assistant_up") forState:UIControlStateSelected];
                    break;
                    
                default:
                    break;
            }
            
            [_iButton2 setImage: LOADIMAGE(@"btn_camera_01_normal") forState:UIControlStateNormal];
            [_iButton2 setImage: LOADIMAGE(@"btn_camera_02_normal") forState:UIControlStateSelected];
            [_iButton3 setImage: LOADIMAGE(@"btn_audio_01_normal") forState:UIControlStateNormal];
            [_iButton3 setImage: LOADIMAGE(@"btn_audio_02_normal") forState:UIControlStateSelected];
            [_iButton3 setImage: LOADIMAGE(@"btn_audio_02_normal") forState:UIControlStateHighlighted];
            [_iButton4 setImage: LOADIMAGE(@"icon_control_tools_02") forState:UIControlStateNormal];
            [_iButton4 setImage: LOADIMAGE(@"btn_tools_02_normal") forState:UIControlStateSelected];
            
            if (tRoomUser.publishState >= 1) {
                _iButton1.selected = YES;
            } else {
                _iButton1.selected = NO;
            }
            
            if (tRoomUser.disableAudio) {
                [_iButton3 setImage:LOADIMAGE(@"btn_audio_disabled") forState:UIControlStateNormal];
                _iButton3.enabled = NO;
            }
            
            if (tRoomUser.disableVideo) {
                [_iButton2 setImage:LOADIMAGE(@"btn_video_disabled") forState:UIControlStateNormal];
                _iButton2.enabled = NO;
            }
            
//            // 检测用户举手状态
//            if ([tRoomUser.properties objectForKey:sRaisehand] && [[tRoomUser.properties objectForKey:sRaisehand] boolValue] == YES) {
//                //
//                NSLog(@"检测到举手");
//            }

            //CGFloat tWidth   = CGRectGetHeight(self.frame);
            CGFloat tWidth = 30;
            CGFloat tViewCap =  4;
            CGFloat tWidthAndCap = tWidth + tViewCap;
            [TKUtil setWidth:_iNameLabel To: CGRectGetWidth(self.frame)-4*tWidthAndCap-CGRectGetMaxX(_iIconImageView.frame)];
            
        }
            break;
        default:
            break;
    }

    
    
}
-(void)clearButtonState{
    _iButton1.hidden = NO;
    _iButton2.hidden = NO;
    _iButton3.hidden = NO;
    _iButton4.hidden = NO;
    _iButton1.selected = NO;
    _iButton2.selected = NO;
    _iButton3.selected = NO;
    _iButton4.selected = NO;
    _iButton1.enabled = YES;
    _iButton2.enabled = YES;
    _iButton3.enabled = YES;
    _iButton4.enabled = YES;
    [_iButton3 setImage: LOADIMAGE(@"btn_play_normal") forState:UIControlStateNormal];
    [_iButton4 setImage: LOADIMAGE(@"btn_delete_normal") forState:UIControlStateNormal];
}
-(void)Button1Clicked:(UIButton *)aButton {
    //aButton.selected = !aButton.selected;
    if ([_iListDelegate respondsToSelector:@selector(listButton1:aIndexPath:)]) {
        [(id<listProtocol>)_iListDelegate listButton1:aButton aIndexPath:_iIndexPath];
    }
    TKLog(@"1");
}
-(void)Button2Clicked:(UIButton *)aButton{
     // aButton.selected = !aButton.selected;
    if ([_iListDelegate respondsToSelector:@selector(listButton2:aIndexPath:)]) {
        [(id<listProtocol>)_iListDelegate listButton2:aButton aIndexPath:_iIndexPath];
    }
     TKLog(@"2");
}
-(void)Button3Clicked:(UIButton *)aButton{
    //aButton.selected = !aButton.selected;
    
    if ([_iListDelegate respondsToSelector:@selector(listButton3:aIndexPath:)]) {
        [(id<listProtocol>)_iListDelegate listButton3:aButton aIndexPath:_iIndexPath];
    }
     TKLog(@"3");
}
-(void)Button4Clicked:(UIButton *)aButton{
     // aButton.selected = !aButton.selected;
    if ([_iListDelegate respondsToSelector:@selector(listButton4:aIndexPath:)]) {
        [(id<listProtocol>)_iListDelegate listButton4:aButton aIndexPath:_iIndexPath];
    }
     TKLog(@"4");
}

@end

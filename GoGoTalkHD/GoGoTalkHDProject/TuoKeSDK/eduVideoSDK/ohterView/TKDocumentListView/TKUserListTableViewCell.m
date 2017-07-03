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
    CGFloat tWidth   =60;
    CGFloat tViewCap =  4;
    CGFloat tWidthAndCap = tWidth + tViewCap;
    CGFloat tY = (CGRectGetHeight(self.frame)-tWidth)/2;
    CGFloat tX = CGRectGetWidth(self.frame)-tWidthAndCap*4;
    _iIconImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"icon_user")];
    _iIconImageView.frame = CGRectMake(8, 14, 30, 30);
    [self.contentView addSubview:_iIconImageView];
    _iNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, CGRectGetWidth(self.frame)-2*tWidth, CGRectGetHeight(self.frame))];
    _iNameLabel.textColor = RGBCOLOR(134, 134, 134);
    _iNameLabel.backgroundColor = [UIColor clearColor];
    [_iNameLabel setFont:TEXT_FONT];
    [self.contentView addSubview:_iNameLabel];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor             = [UIColor clearColor];
   
   
    
    _iButton1 = ({
    
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tLeftButton.frame = CGRectMake(tX, tY, tWidth, tWidth);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [tLeftButton setImage: LOADIMAGE(@"icon_hand") forState:UIControlStateNormal];
        [tLeftButton setImage: LOADIMAGE(@"icon_hand") forState:UIControlStateSelected];
        [tLeftButton addTarget:self action:@selector(Button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        tLeftButton;
    
    });
     [self.contentView addSubview:_iButton1];
    _iButton2 = ({
        
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
       tLeftButton.frame = CGRectMake(tX+tWidthAndCap, tY, tWidth, tWidth);
        //        tLeftButton.center = CGPointMake(25+8, _titleView.center.y);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [tLeftButton setImage: LOADIMAGE(@"icon_control_tools_01") forState:UIControlStateNormal];
        [tLeftButton setImage: LOADIMAGE(@"icon_control_tools_02") forState:UIControlStateSelected];
        [tLeftButton addTarget:self action:@selector(Button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
        tLeftButton;
        
    });
     [self.contentView addSubview:_iButton2];
    _iButton3 = ({
        
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
         tLeftButton.frame = CGRectMake(tX+tWidthAndCap*2, tY, tWidth, tWidth);
        //        tLeftButton.center = CGPointMake(25+8, _titleView.center.y);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [tLeftButton setImage: LOADIMAGE(@"btn_camera_01_normal@") forState:UIControlStateNormal];
        [tLeftButton setImage: LOADIMAGE(@"btn_camera_02_normal") forState:UIControlStateSelected];
        [tLeftButton addTarget:self action:@selector(Button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
        tLeftButton;
        
    });
     [self.contentView addSubview:_iButton3];
    _iButton4 = ({
        
        UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
         tLeftButton.frame = CGRectMake(tX+tWidthAndCap*3, tY, tWidth, tWidth);
        //        tLeftButton.center = CGPointMake(25+8, _titleView.center.y);
        tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [tLeftButton setImage: LOADIMAGE(@"btn_audio_01_normal") forState:UIControlStateNormal];
        [tLeftButton setImage: LOADIMAGE(@"btn_audio_02_normal") forState:UIControlStateSelected];
        [tLeftButton addTarget:self action:@selector(Button4Clicked:) forControlEvents:UIControlEventTouchUpInside];
        tLeftButton;
        
    });
     [self.contentView addSubview:_iButton4];
   
    
}

- (void)resetView
{
    _iNameLabel.text = _text;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat tWidth   =60;
    CGFloat tViewCap =  4;
    CGFloat tWidthAndCap = tWidth + tViewCap;

    _iNameLabel.frame = CGRectMake(40, 0, CGRectGetWidth(self.frame)-2*tWidth, CGRectGetHeight(self.frame));
    
    
}
-(void)configaration:(id)aModel withFileListType:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin{
     _iFileListType = aFileListType;
    
    switch (_iFileListType) {
            //视频列表
        case FileListTypeAudioAndVideo:
        {
            _iButton1.hidden = YES;
            _iButton2.hidden = YES;
             TKMediaDocModel *tDocModel =(TKMediaDocModel*) aModel;
            NSString *tTypeString = [TKUtil docmentOrMediaImage:tDocModel.filetype];
            
            _iIconImageView.image = LOADIMAGE(tTypeString);
            _iButton3.selected = NO;
            _iButton4.selected = NO;
            _iNameLabel.text = tDocModel.filename;
            _iButton3.hidden = NO;
            _iButton4.hidden = NO;
            [_iButton3 setImage: LOADIMAGE(@"btn_play_normal") forState:UIControlStateNormal];
            [_iButton3 setImage: LOADIMAGE(@"btn_pause_normal") forState:UIControlStateSelected];
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
            NSString *tTypeString = [TKUtil docmentOrMediaImage:tDocModel.filetype];
            
            _iIconImageView.image = LOADIMAGE(tTypeString);
            _iNameLabel.text = tDocModel.filename;
            _iButton3.selected = NO;
            _iButton4.selected = NO;
            if ([tDocModel.filetype isEqualToString:@""]) {
                _iButton3.hidden = YES;
                _iButton4.hidden = YES;
            }else{
                _iButton3.hidden = NO;
                _iButton4.hidden = NO;
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
            // 发布状态，0：未发布，1：发布音频；2：发布视频；3：发布音视频
            switch (tRoomUser.publishState) {
                case PublishState_NONE:
                {
                    _iButton3.selected = NO;
                    _iButton4.selected = NO;
                   break;
                }
                case PublishState_AUDIOONLY:
                {
                    _iButton3.selected = NO ;
                    _iButton4.selected = YES;
                   break;
                }
                case PublishState_VIDEOONLY:
                {
                    _iButton3.selected = YES;
                    _iButton4.selected = NO;
                   break;
                }
                case PublishState_BOTH:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
            _iButton1.hidden = ![tRoomUser.properties objectForKey:sRaisehand];
            _iButton2.selected = [tRoomUser.properties objectForKey:sCandraw];
            if (!isClassBegin) {
                _iButton1.hidden = YES;
                _iButton2.hidden = YES;
                _iButton3.hidden = YES;
                _iButton4.hidden = YES;
            }else{
                _iButton2.hidden = NO;
                _iButton3.hidden = NO;
                _iButton4.hidden = NO;
            }
            
            

            _iIconImageView.image = LOADIMAGE(@"icon_user.png");
            _iNameLabel.text = tRoomUser.nickName;
            
            [_iButton1 setImage: LOADIMAGE(@"icon_hand") forState:UIControlStateNormal];
            [_iButton1 setImage: LOADIMAGE(@"icon_hand") forState:UIControlStateSelected];
            
            [_iButton2 setImage: LOADIMAGE(@"icon_control_tools_01") forState:UIControlStateNormal];
            [_iButton2 setImage: LOADIMAGE(@"icon_control_tools_02") forState:UIControlStateSelected];
            [_iButton3 setImage: LOADIMAGE(@"btn_camera_01_normal") forState:UIControlStateNormal];
            [_iButton3 setImage: LOADIMAGE(@"btn_camera_02_normal") forState:UIControlStateSelected];
            [_iButton3 setImage: LOADIMAGE(@"btn_camera_02_normal") forState:UIControlStateHighlighted];
            [_iButton4 setImage: LOADIMAGE(@"btn_audio_01_normal") forState:UIControlStateNormal];
            [_iButton4 setImage: LOADIMAGE(@"btn_audio_02_normal") forState:UIControlStateSelected];
             [_iButton3 setImage: LOADIMAGE(@"btn_audio_02_normal") forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }

    
    
}

-(void)Button1Clicked:(UIButton *)aButton {
    aButton.selected = !aButton.selected;
    if ([_iListDelegate respondsToSelector:@selector(listButton1:aIndexPath:)]) {
        [(id<listProtocol>)_iListDelegate listButton1:aButton aIndexPath:_iIndexPath];
    }
    TKLog(@"1");
}
-(void)Button2Clicked:(UIButton *)aButton{
      aButton.selected = !aButton.selected;
    if ([_iListDelegate respondsToSelector:@selector(listButton2:aIndexPath:)]) {
        [(id<listProtocol>)_iListDelegate listButton2:aButton aIndexPath:_iIndexPath];
    }
     TKLog(@"2");
}
-(void)Button3Clicked:(UIButton *)aButton{
    aButton.selected = !aButton.selected;
    if ([_iListDelegate respondsToSelector:@selector(listButton3:aIndexPath:)]) {
        [(id<listProtocol>)_iListDelegate listButton3:aButton aIndexPath:_iIndexPath];
    }
     TKLog(@"3");
}
-(void)Button4Clicked:(UIButton *)aButton{
      aButton.selected = !aButton.selected;
    if ([_iListDelegate respondsToSelector:@selector(listButton4:aIndexPath:)]) {
        [(id<listProtocol>)_iListDelegate listButton4:aButton aIndexPath:_iIndexPath];
    }
     TKLog(@"4");
}

@end

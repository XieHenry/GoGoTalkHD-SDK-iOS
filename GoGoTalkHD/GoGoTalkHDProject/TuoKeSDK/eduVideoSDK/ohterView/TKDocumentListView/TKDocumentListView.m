//
//  TKDocumentListView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/13.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKDocumentListView.h"

#import "TKUtil.h"
#import "TKUserListTableViewCell.h"
#import "TKMediaDocModel.h"
#import "TKDocmentDocModel.h"
#import "RoomUser.h"
#import "RoomController.h"
#import "TKProgressHUD.h"
#import "TKEduNetManager.h"
#import "TKAudioVideoPlayerView.h"
#import "TKAudioPlayerView.h"
#import "TKAudioVideoPlayerView.h"
#import "TKAudioPlayerView.h"



@interface TKDocumentListView ()<listProtocol,mediaProtocol>
@property (nonatomic,retain)UILabel  *iFileHeadLabel;
@property (nonatomic,assign)FileListType  iFileListType;
@property (nonatomic,retain)NSMutableArray *iFileMutableArray;
@property (nonatomic,retain)UITableView    *iFileTableView;

@property (nonatomic,assign)BOOL  isClassBegin;
@property (nonatomic,strong)UIButton*  iCurrrentButton;
@property (nonatomic,strong)UIButton*  iPreButton;
@property (nonatomic,strong) TKAudioVideoPlayerView *iAudioVideoPlayerView;     // 代替iAVPlayerVideoController
@property (nonatomic,strong) TKAudioPlayerView *iAudioPlayerView;               // 代替iAudioPlayer

@property (nonatomic,strong)TKProgressHUD*  iVideoPlayerHud;

@end

@implementation TKDocumentListView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBACOLOR(35, 35, 35, 0.6);
        _iFileTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) style:UITableViewStyleGrouped];
        _iFileTableView.backgroundColor = [UIColor clearColor];
        _iFileTableView.separatorColor  = [UIColor clearColor];
        _iFileTableView.showsHorizontalScrollIndicator = NO;
        _iFileTableView.delegate   = self;
        _iFileTableView.dataSource = self;
        _isClassBegin = NO;
        _iFileTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _iFileHeadLabel = ({
            UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 60)];
            
            tLabel.text = MTLocalized(@"Title.UserList.two");
            tLabel.font = TEXT_FONT;
            tLabel.textAlignment = NSTextAlignmentCenter;
            tLabel.textColor = RGBCOLOR(225, 225, 225);
            tLabel;
            
        });
        _iFileTableView.tableHeaderView = _iFileHeadLabel;
        [_iFileTableView registerClass:[TKUserListTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        [self addSubview:_iFileTableView];

         [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}
//382

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 2;
    return _iFileMutableArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tHeight = 60;
    return tHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   
    TKUserListTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    tCell.iListDelegate = self;
    tCell.iIndexPath = indexPath;
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            _iFileHeadLabel.text = MTLocalized(@"Title.MediaList");
             TKMediaDocModel *tMediaDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
           
            [tCell configaration:tMediaDocModel withFileListType:FileListTypeAudioAndVideo isClassBegin:_isClassBegin];
            
        }
            break;
        case FileListTypeDocument:
        {
            //文档列表
           // NSString *tString = [NSString stringWithFormat:@"文档列表"];
            _iFileHeadLabel.text =MTLocalized(@"Title.DocumentList");;
              TKDocmentDocModel *tMediaDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
           
            [tCell configaration:tMediaDocModel withFileListType:FileListTypeDocument isClassBegin:_isClassBegin];
            
        }
            break;
        case FileListTypeUserList:
        {
             NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            tCell.iIndexPath = indexPath;
            RoomUser *tRoomUser = [_iFileMutableArray objectAtIndex:indexPath.row];
            [tCell configaration:tRoomUser withFileListType:FileListTypeUserList isClassBegin:_isClassBegin];
            
            
        }
            break;
        default:
            break;
    }
    
    
    
    return tCell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [self hide];
    TKLog(@"%@",@(indexPath.row));
    if ((indexPath.row == 0)&&(_iFileListType == FileListTypeDocument)) {
         TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
        if (_isClassBegin) {
            [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
 
        }else{
            [[TKEduSessionHandle shareInstance] docmentDefault:tDocmentDocModel];
         
        }
        
        if(_iPreButton) {
            [_iPreButton setSelected:NO];
            _iPreButton = nil;
            
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)show:(FileListType)aFileListType aFileList:(NSArray *)aFileList isClassBegin:(BOOL)isClassBegin{

    [self refreshData:aFileListType aFileList:aFileList isClassBegin:isClassBegin];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
   // [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
   
    [TKUtil setLeft:self To:ScreenW-CGRectGetWidth(self.frame)];
    
    [UIView commitAnimations];
    
}
-(void)hide{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
 //   [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [TKUtil setLeft:self To:ScreenW];
    
    [UIView commitAnimations];
}
-(void)clearVideo:(BOOL)isPublish{
    
    if (_iAudioVideoPlayerView) {
        [_iAudioVideoPlayerView clearPublishMedia:[TKEduSessionHandle shareInstance].iCurrentMediaDocModel isPublish:isPublish];
        _iAudioVideoPlayerView = nil;
    }
    
    if (_iAudioPlayerView) {
        [_iAudioPlayerView clearPublishMedia:[TKEduSessionHandle shareInstance].iCurrentMediaDocModel isPublish:isPublish];
        _iAudioPlayerView = nil;
    }

}

-(void)refreshData:(FileListType)aFileListType aFileList:(NSArray *)aFileList isClassBegin:(BOOL)isClassBegin{
    _iFileMutableArray = [aFileList mutableCopy];
    _iFileListType    = aFileListType;
    _isClassBegin = isClassBegin;
    switch (aFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            _iFileHeadLabel.text = MTLocalized(@"Title.MediaList");
        }
            break;
        case FileListTypeDocument:
        {
            //@"文档列表"
          _iFileHeadLabel.text = MTLocalized(@"Title.DocumentList");
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            
        }
            break;
        default:
            break;
    }
    [_iFileTableView reloadData];
}

-(void)prepareVideoOrAudio:(TKMediaDocModel*)aMediaDocModel SendToOther:(BOOL)send{
    if (!_iVideoPlayerHud) {
        _iVideoPlayerHud = [[TKProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:_iVideoPlayerHud];
        _iVideoPlayerHud.dimBackground = YES;
        _iVideoPlayerHud.removeFromSuperViewOnHide = YES;
        
    }
    [_iVideoPlayerHud show:NO];
    
   //@"影音列表"
     _iFileHeadLabel.text = MTLocalized(@"Title.MediaList");
    [self clearVideo:_isClassBegin];
    BOOL tBool = [TKUtil isVideo:aMediaDocModel.filetype];
    if ([TKEduSessionHandle shareInstance].iCurrentMediaDocModel) {
        [TKEduSessionHandle shareInstance].iPreMediaDocModel = [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
    }
    
    //清零
    if (send) {
         aMediaDocModel.currentTime = @(0);
    }
   
    [TKEduSessionHandle shareInstance].iCurrentMediaDocModel = aMediaDocModel;
    if (_isClassBegin) {
        [[TKEduSessionHandle shareInstance] publishtMediaDocModel:aMediaDocModel add:true To:sTellAllExpectSender];
    }
    
  
    TKEduRoomProperty *tRoomProperty = [TKEduSessionHandle shareInstance].iRoomProperties;
    if (tBool) {
        
        _iAudioVideoPlayerView = [[TKAudioVideoPlayerView alloc] initWithMediaDocModel:aMediaDocModel
                                                                 aRoomProperty:tRoomProperty
                                                                           SendToOther:send
                                                                                 frame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _iAudioVideoPlayerView.delegate = self;
        [_delegate.view addSubview:_iAudioVideoPlayerView];

    }else{
        _iAudioPlayerView = [[TKAudioPlayerView alloc] initWithMediaDocModel:aMediaDocModel
                                                       aRoomProperty:tRoomProperty
                                                                 SendToOther:send
                                                                       frame:CGRectMake(0, CGRectGetHeight(_delegate.iTKEduWhiteBoardView.frame)-57, CGRectGetWidth(_delegate.iTKEduWhiteBoardView.frame), 57)];
        _iAudioPlayerView.delegate = self;
        [_delegate.iTKEduWhiteBoardView addSubview:_iAudioPlayerView];
        
    }
    
    if (![TKEduSessionHandle shareInstance].iPreMediaDocModel) {
        [TKEduSessionHandle shareInstance].iPreMediaDocModel = aMediaDocModel;
    }else{
        [TKEduSessionHandle shareInstance].iPreMediaDocModel =  [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
    }
    
    [TKEduSessionHandle shareInstance].iCurrentMediaDocModel = aMediaDocModel;
}

-(void)playOrPauseVideoOrAudio:(BOOL)aPlay{
    
    if (_iAudioPlayerView) {
        [_iAudioPlayerView playAction:aPlay];
    }
    
    if (_iAudioVideoPlayerView) {
        [_iAudioVideoPlayerView playAction:aPlay];
    }
}
//设置跳转到当前播放时间
- (void)setCurrentTime:(double)time SendToOther:(BOOL)send{

    if (_iAudioPlayerView) {
        [_iAudioPlayerView setCurrentTime:time SendToOther:send];
    }
    
    if (_iAudioVideoPlayerView) {
        [_iAudioVideoPlayerView setCurrentTime:time SendToOther:send];
    }
    
}
#pragma mark  listProtocol
//举手标志
-(void)listButton1:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{

}
//上台
-(void)listButton2:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    [self hide];
   // TKUserListTableViewCell *tCell = [_iFileTableView cellForRowAtIndexPath:aIndexPath];
    
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            _iFileHeadLabel.text = MTLocalized(@"Title.MediaList");
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            tMediaDocModel.isPlay =@( aButton.selected);
            
        }
            break;
        case FileListTypeDocument:
        {
            //文档列表
           
            //TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
            _iFileHeadLabel.text = MTLocalized(@"Title.DocumentList");
        }
            break;
        case FileListTypeUserList:
        {
           NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"), @([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            RoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
            int isSucess = [[TKEduSessionHandle shareInstance]addPendingButton:tRoomUser];
            if (!isSucess) {break;}
            PublishState tState = tRoomUser.publishState;
            BOOL isShowVideo = tRoomUser.publishState >1;
            if (isShowVideo) {
                tState = PublishState_NONE;
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@(false) completion:nil];

                
            }else{
                tState = PublishState_BOTH;
            }
            
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:tRoomUser.peerID Publish:tState completion:nil];
            
        }
            break;
        default:
            break;
    }
}

//切换动态ppt，音视频
-(void)listButton3:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
   
  [self hide];
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
//            if ([TKEduWhiteBoardHandle shareTKEduWhiteBoardHandleInstance].iCurrentMediaDocModel
//                && [tMediaDocModel.fileid intValue] == [[TKEduWhiteBoardHandle shareTKEduWhiteBoardHandleInstance].iCurrentMediaDocModel.fileid intValue])
//                return;
            
            aButton.selected = YES;
            [self prepareVideoOrAudio:tMediaDocModel SendToOther:YES];

           
            
        }
            break;
        case FileListTypeDocument:
        {
            //文档列表
             _iFileHeadLabel.text = MTLocalized(@"Title.DocumentList");
            [aButton setSelected:YES];
            if (aButton == _iPreButton) {
                return;
            }

            TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
        
            if (_isClassBegin) {
                [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
                
            }else{
                [[TKEduSessionHandle shareInstance] docmentDefault:tDocmentDocModel];
              
            }

            
            _iCurrrentButton = aButton;
            if (_iPreButton) {
                [_iPreButton setSelected:NO];
            }
            
            _iPreButton = _iCurrrentButton;
        }
            break;
        case FileListTypeUserList:
        {
             NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            RoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
            PublishState tState = tRoomUser.publishState;
            switch (tRoomUser.publishState) {
                    
                case PublishState_AUDIOONLY:
                {
                    tState = PublishState_NONE;
                    
                }
                    break;
                case PublishState_BOTH:
                {
                    tState = PublishState_VIDEOONLY;
                }
                    break;
                case PublishState_NONE:
                {
                    tState = PublishState_AUDIOONLY;
                    
                }
                    break;
                case PublishState_VIDEOONLY:
                {
                    tState = PublishState_BOTH;
                    
                }
                    break;
                default:
                    break;
            }
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:tRoomUser.peerID Publish:tState completion:nil];
           
            
        }
            break;
        default:
            break;
    }
}
//涂鸦，删除文件，影音
-(void)listButton4:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    //[self hide];
      TKEduRoomProperty *tRoomProperty = [TKEduSessionHandle shareInstance].iRoomProperties;
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            //@"影音列表"
            _iFileHeadLabel.text = MTLocalized(@"Title.MediaList");
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
          
            [TKEduNetManager delRoomFile:tRoomProperty.iRoomId docid:[NSString stringWithFormat:@"%@",tMediaDocModel.fileid] isMedia:false aHost:tRoomProperty.sWebIp aPort:tRoomProperty.sWebPort  aDelComplete:^int(id  _Nullable response) {
                
                [[TKEduSessionHandle shareInstance] deleteaMediaDocModel:tMediaDocModel To:sTellAllExpectSender];
                
                if ([[TKEduSessionHandle shareInstance].iCurrentMediaDocModel.fileid integerValue] == [tMediaDocModel.fileid integerValue]) {

                    /*
                     if (_iAVPlayerVidewController) {
                     //[_iAVPlayerVidewController clearPublishMedia:tMediaDocModel isPublish:YES];
                     [_iAVPlayerVidewController clearPublishMedia:tMediaDocModel isPublish:YES aIsDismissViewController:NO];
                     
                     }
                     if (_iAudioPlayer) {
                     [_iAudioPlayer clearPublishMedia:tMediaDocModel isPublish:YES];
                     _iAudioPlayer = nil;
                     }
                     */
                    
                    if ([TKEduSessionHandle shareInstance].isClassBegin) {
                        
                    }
                    if (_iAudioVideoPlayerView) {
                        [_iAudioVideoPlayerView clearPublishMedia:tMediaDocModel isPublish:YES];
                    }

                    if (_iAudioPlayerView) {
                        [_iAudioPlayerView clearPublishMedia:tMediaDocModel isPublish:YES];
                    }

                  
                }
                
                
                [[TKEduSessionHandle shareInstance] delMediaArray:tMediaDocModel];
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] mediaArray]mutableCopy];
                [_iFileTableView reloadData];
                return 1;
            }];

            
          
            
        }
            break;
        case FileListTypeDocument:
        {
            //@"文档列表"
            _iFileHeadLabel.text = MTLocalized(@"Title.DocumentList");
            TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
        
            [TKEduNetManager delRoomFile:tRoomProperty.iRoomId docid:tDocmentDocModel.fileid isMedia:false aHost:tRoomProperty.sWebIp aPort:tRoomProperty.sWebPort  aDelComplete:^int(id  _Nullable response) {
                
                [[TKEduSessionHandle shareInstance] deleteDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
                if ([[TKEduSessionHandle shareInstance].iCurrentDocmentModel.fileid isEqualToString:tDocmentDocModel.fileid]) {
                    TKDocmentDocModel *tDocmentDocNextModel = [[TKEduSessionHandle shareInstance] getNextDocment:[TKEduSessionHandle shareInstance].iCurrentDocmentModel];
                   
                    
                    if (_isClassBegin) {
                        [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocNextModel To:sTellAllExpectSender];
                        
                    }else{
                        [[TKEduSessionHandle shareInstance] docmentDefault:tDocmentDocNextModel];
                      
                    }
                   
                }
                
                [[TKEduSessionHandle shareInstance] delDocmentArray:tDocmentDocModel];
                _iFileMutableArray = [[[TKEduSessionHandle shareInstance] docmentArray]mutableCopy];
                [_iFileTableView reloadData];
                return 1;
            }];
          
            
        }
            break;
        case FileListTypeUserList:
        {
            [self hide];
            //关闭涂鸦
            NSString *tString = [NSString stringWithFormat:@"%@(%@)", MTLocalized(@"Title.UserList"),@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            RoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
            if (tRoomUser.publishState>1) {
                
                [[TKEduSessionHandle shareInstance]  sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sCandraw Value:@((bool)(!tRoomUser.canDraw)) completion:nil];
 
            }

            
        }
            break;
        default:
            break;
    } 
 
}

#pragma mark  mediaProtocol

-(void)mediaPlayStatus:(BOOL)aSucess{
    
  [_iVideoPlayerHud hide:YES];
    
}

-(void)mediaBackAction{
    
    if (_iAudioVideoPlayerView) {

        _iAudioVideoPlayerView = nil;
    }
    
    if (_iAudioPlayerView) {

        _iAudioPlayerView = nil;
    }
    
}

- (void)replay:(TKMediaDocModel *)model {
    [self prepareVideoOrAudio:model SendToOther:YES];
}


@end

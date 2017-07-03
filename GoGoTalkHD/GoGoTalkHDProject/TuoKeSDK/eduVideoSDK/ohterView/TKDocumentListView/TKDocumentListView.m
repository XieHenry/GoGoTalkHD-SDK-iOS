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
#import "TKAVPlayerViewController.h"
#import "RoomController.h"
#import "TKAudioPlayer.h"

@interface TKDocumentListView ()<listProtocol>
@property (nonatomic,retain)UILabel  *iFileHeadLabel;
@property (nonatomic,assign)FileListType  iFileListType;
@property (nonatomic,retain)NSMutableArray *iFileMutableArray;
@property (nonatomic,retain)UITableView    *iFileTableView;
@property (nonatomic, strong) TKEduWhiteBoardHandle *iTKEduWhiteBoardHandle;
@property (nonatomic, strong) TKEduClassRoomSessionHandle *iTKEduClassRoomSessionHandle;
@property (nonatomic, strong) TKEduClassRoomProperty *iTKEduClassRoomProperty;
@property (nonatomic,assign)BOOL  isClassBegin;
@end

@implementation TKDocumentListView
-(instancetype)initWithFrame:(CGRect)frame withWhiteBoardHandel:(TKEduWhiteBoardHandle *)aWhiteBoardHandle withClassRoomSessionHandle:(TKEduClassRoomSessionHandle *)aClassRoomSessionHandle withClassRoomProperty:(TKEduClassRoomProperty *)aClassRoomProperty{
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
            
            tLabel.text = MTLocalized(@"用户列表（1人）");
            tLabel.font = TEXT_FONT;
            tLabel.textAlignment = NSTextAlignmentCenter;
            tLabel.textColor = RGBCOLOR(225, 225, 225);
            tLabel;
            
        });
        _iFileTableView.tableHeaderView = _iFileHeadLabel;
        [_iFileTableView registerClass:[TKUserListTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        [self addSubview:_iFileTableView];
        _iTKEduWhiteBoardHandle       = aWhiteBoardHandle;
        _iTKEduClassRoomSessionHandle = aClassRoomSessionHandle;
        _iTKEduClassRoomProperty      = aClassRoomProperty;
         [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}
//382
-(instancetype)initWithFrame:(CGRect)frame{
    
    return [self initWithFrame:frame withWhiteBoardHandel:nil withClassRoomSessionHandle:nil withClassRoomProperty:nil];
}
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
            NSString *tString = [NSString stringWithFormat:@"影音列表"];
            _iFileHeadLabel.text = MTLocalized(tString);
             TKMediaDocModel *tMediaDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
           
            [tCell configaration:tMediaDocModel withFileListType:FileListTypeAudioAndVideo isClassBegin:_isClassBegin];
            
        }
            break;
        case FileListTypeDocument:
        {
            NSString *tString = [NSString stringWithFormat:@"文档列表"];
            _iFileHeadLabel.text = MTLocalized(tString);
              TKDocmentDocModel *tMediaDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
           
            [tCell configaration:tMediaDocModel withFileListType:FileListTypeDocument isClassBegin:_isClassBegin];
            
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"用户列表(%@人)",@([_iFileMutableArray count])];
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
    TKLog(@"%@",@(indexPath.row));
    if ((indexPath.row == 0)&&(_iFileListType == FileListTypeDocument)) {
         TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:indexPath.row];
        NSDictionary *tDocmentDocModelDic = @{
                                              @"fileid":tDocmentDocModel.fileid,
                                              
                                              @"ismedia":@(false),
                                              @"filedata":@{
                                                       @"fileid":tDocmentDocModel.fileid,
                                                       @"currpage":tDocmentDocModel.currpage,
                                                       @"pagenum":tDocmentDocModel.pagenum,
                                                       @"filetype":tDocmentDocModel.filetype,
                                                       @"filename":tDocmentDocModel.filename,
                                                       @"swfpath":tDocmentDocModel.swfpath
                                                      }
                                              };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDocmentDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [_iTKEduClassRoomSessionHandle sessionHandlePubMsg:sShowPage ID:sShowPage To:sTellAll Data:jsonString Save:false completion:nil];
        
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
-(void)refreshData:(FileListType)aFileListType aFileList:(NSArray *)aFileList isClassBegin:(BOOL)isClassBegin{
    _iFileMutableArray = [aFileList mutableCopy];
    _iFileListType    = aFileListType;
    _isClassBegin = isClassBegin;
    switch (aFileListType) {
        case FileListTypeAudioAndVideo:
        {
            NSString *tString = [NSString stringWithFormat:@"影音列表"];
            _iFileHeadLabel.text = MTLocalized(tString);
        }
            break;
        case FileListTypeDocument:
        {
            NSString *tString = [NSString stringWithFormat:@"文档列表"];
            _iFileHeadLabel.text = MTLocalized(tString);
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"用户列表(%@人)",@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            
        }
            break;
        default:
            break;
    }
    [_iFileTableView reloadData];
}


#pragma mark  listProtocol
-(void)listButton1:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    

}
-(void)listButton2:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            NSString *tString = [NSString stringWithFormat:@"影音列表"];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            tMediaDocModel.isPlay =@( aButton.selected);
            
        }
            break;
        case FileListTypeDocument:
        {
            NSString *tString = [NSString stringWithFormat:@"文档列表"];
            TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
            
            _iFileHeadLabel.text = MTLocalized(tString);
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"用户列表(%@人)",@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            RoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
            [_iTKEduClassRoomSessionHandle sessionHandleChangeUserProperty:tRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(aButton.selected) completion:nil];
            
        }
            break;
        default:
            break;
    }
}
-(void)listButton3:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            NSString *tString = [NSString stringWithFormat:@"影音列表"];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            tMediaDocModel.isPlay =@( aButton.selected);
            
            NSDictionary *tMediaDocModelDic = @{
                                                  @"fileid":tMediaDocModel.fileid,
                                                  @"page":tMediaDocModel.page?tMediaDocModel.page:@(1),
                                                  @"ismedia":@(true),
                                                  @"filedata":@{
                                                           @"fileid":tMediaDocModel.fileid,
                                                           @"currpage":@(1),
                                                           @"pagenum":tMediaDocModel.pagenum?tMediaDocModel.pagenum:@(1),
                                                           @"filetype":tMediaDocModel.filetype,
                                                           @"filename":tMediaDocModel.filename,
                                                            @"swfpath":tMediaDocModel.swfpath
                                                          }
                                                  };
            _iFileHeadLabel.text = MTLocalized(tString);
            NSString *tIdString = [tMediaDocModel.filetype isEqualToString:@"video"]?sVideo_MediaFilePage_ShowPage:sAudio_MediaFilePage_ShowPage ;

            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tMediaDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (aButton.selected) {
                [_iTKEduClassRoomSessionHandle sessionHandlePubMsg:sShowPage ID:tIdString To:sTellAllExpectSender Data:jsonString Save:false completion:nil];
            }else{
                [_iTKEduClassRoomSessionHandle sessionHandleDelMsg:sShowPage ID:tIdString To:sTellAllExpectSender Data:jsonString completion:nil];
            }
            if ([tMediaDocModel.filetype isEqualToString:@"video"]) {
                TKAVPlayerViewController *tall = [[TKAVPlayerViewController alloc]initWithMediaDocModel:tMediaDocModel aEduClassRoomProperty:_iTKEduClassRoomProperty];
                [_delegate presentViewController:tall animated:YES completion:^{
                    
                }];
            }else{
                
                TKAudioPlayer *tAudioPlayer = [[TKAudioPlayer alloc]initWithMediaDocModel:tMediaDocModel aEduClassRoomProperty:_iTKEduClassRoomProperty];
                [_delegate.iTKEduWhiteBoardView addSubview:[tAudioPlayer audioPlayerView:CGRectMake(0, CGRectGetHeight(_delegate.iTKEduWhiteBoardView.frame)-57, CGRectGetWidth(_delegate.iTKEduWhiteBoardView.frame), 57)] ];
                
            }
           
          
            
           
            
            
            
        }
            break;
        case FileListTypeDocument:
        {
            /*
             
             
             filedata =     {
             currpage = 1;
             fileid = 649;
             filename = "\U6dfb\U52a0\U5242 .docx";
             filetype = docx;
             pagenum = 1;
             swfpath = "/upload/20170516_115957_icteekor.jpg";
             };
             fileid = 649;
             ismedia = 0;
             
             
             */
            NSString *tString = [NSString stringWithFormat:@"文档列表"];
            TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
           
            NSDictionary *tDocmentDocModelDic = @{
                                                  @"fileid":tDocmentDocModel.fileid,
                                                  
                                                  @"ismedia":@(false),
                                                  @"filedata":@{
                                                          @"fileid":tDocmentDocModel.fileid,
                                                          @"currpage":tDocmentDocModel.currpage?tDocmentDocModel.currpage:@(1),
                                                          @"pagenum":tDocmentDocModel.pagenum?tDocmentDocModel.pagenum:@(1),
                                                          @"filetype":tDocmentDocModel.filetype,
                                                          @"filename":tDocmentDocModel.filename,
                                                          @"swfpath":tDocmentDocModel.swfpath
                                                          }
                                                  };
            
            if ([tDocmentDocModel.dynamicppt boolValue]) {
                bool tIsAynamicPPT = true;
               tDocmentDocModelDic = @{
                                                      @"action":@"show",
                                                      @"aynamicPPT":@(tIsAynamicPPT),
                                                      
                                                      @"ismedia":@(false),
                                                      @"filedata":@{
                                                              @"fileid":tDocmentDocModel.fileid,
                                                              @"currpage":tDocmentDocModel.currpage?tDocmentDocModel.currpage:@(1),
                                                              @"pagenum":tDocmentDocModel.pagenum?tDocmentDocModel.pagenum:@(0),
                                                              @"filetype":tDocmentDocModel.filetype,
                                                              @"filename":tDocmentDocModel.filename,
                                                              @"swfpath":tDocmentDocModel.swfpath
                                                              }
                                                      };
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDocmentDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
             NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            _iFileHeadLabel.text = MTLocalized(tString);
            if (aButton.selected) {
                  [_iTKEduClassRoomSessionHandle sessionHandlePubMsg:sShowPage ID:sShowPage To:sTellAll Data:jsonString Save:false completion:nil];
            }else{
                [_iTKEduClassRoomSessionHandle sessionHandleDelMsg:sShowPage ID:sShowPage To:sTellAll Data:jsonString completion:nil];
            }
            
            
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"用户列表(%@人)",@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            RoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
            PublishState tState = tRoomUser.publishState;
            switch (tRoomUser.publishState) {
                case PublishState_NONE:
                {
                    if (aButton.selected) {
                        tState = PublishState_VIDEOONLY;
                    }
                }
                    break;
                case PublishState_VIDEOONLY:
                {
                    if (aButton.selected) {
                        tState = PublishState_VIDEOONLY;
                    }else{
                        tState = PublishState_NONE;
                    }
                }
                    break;
                case PublishState_AUDIOONLY:
                {
                    if (aButton.selected) {
                        tState = PublishState_BOTH;
                    }else{
                        tState = PublishState_AUDIOONLY;
                    }
                }
                    break;
                case PublishState_BOTH:
                {
                    if (aButton.selected) {
                        tState = PublishState_BOTH;
                    }else{
                        tState = PublishState_AUDIOONLY;
                    }
                }
                    break;
                default:
                    break;
            }
            [_iTKEduClassRoomSessionHandle sessionHandleChangeUserPublish:tRoomUser.peerID Publish:tState completion:nil];
           
            
        }
            break;
        default:
            break;
    }
}
-(void)listButton4:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath{
    switch (_iFileListType) {
        case FileListTypeAudioAndVideo:
        {
            NSString *tString = [NSString stringWithFormat:@"影音列表"];
            _iFileHeadLabel.text = MTLocalized(tString);
            TKMediaDocModel *tMediaDocModel =  [_iFileMutableArray objectAtIndex:aIndexPath.row];
            tMediaDocModel.isPlay =@( aButton.selected);
            
            NSDictionary *tMediaDocModelDic = @{
                                                @"fileid":tMediaDocModel.fileid,
                                                @"page":tMediaDocModel.page?tMediaDocModel.page:@(1),
                                                @"ismedia":@(true),
                                                @"filedata":@{
                                                        @"fileid":tMediaDocModel.fileid,
                                                        @"currpage":@(1),
                                                        @"pagenum":tMediaDocModel.pagenum?tMediaDocModel.pagenum:@(1),
                                                        @"filetype":tMediaDocModel.filetype,
                                                        @"filename":tMediaDocModel.filename,
                                                        @"swfpath":tMediaDocModel.swfpath
                                                        }
                                                };
            _iFileHeadLabel.text = MTLocalized(tString);
            NSString *tIdString = [tMediaDocModel.filetype isEqualToString:@"video"]?sVideo_MediaFilePage_ShowPage:sAudio_MediaFilePage_ShowPage ;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tMediaDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
             [_iTKEduClassRoomSessionHandle sessionHandleDelMsg:sShowPage ID:tIdString To:sTellAllExpectSender Data:jsonString completion:nil];
            [_iTKEduWhiteBoardHandle delMediaArray:tMediaDocModel];
            _iFileMutableArray = [[_iTKEduWhiteBoardHandle mediaArray]mutableCopy];
            [_iFileTableView reloadData];
            
        }
            break;
        case FileListTypeDocument:
        {
            NSString *tString = [NSString stringWithFormat:@"文档列表"];
            TKDocmentDocModel *tDocmentDocModel = [_iFileMutableArray objectAtIndex:aIndexPath.row];
            
            NSDictionary *tDocmentDocModelDic = @{
                                                  @"fileid":tDocmentDocModel.fileid,
                                                  
                                                  @"ismedia":@(false),
                                                  @"filedata":@{
                                                          @"fileid":tDocmentDocModel.fileid,
                                                          @"currpage":tDocmentDocModel.currpage?tDocmentDocModel.currpage:@(1),
                                                          @"pagenum":tDocmentDocModel.pagenum?tDocmentDocModel.pagenum:@(1),
                                                          @"filetype":tDocmentDocModel.filetype,
                                                          @"filename":tDocmentDocModel.filename,
                                                          @"swfpath":tDocmentDocModel.swfpath
                                                          }
                                                  };
            
            if (tDocmentDocModel.dynamicppt) {
                bool tIsAynamicPPT = true;
                tDocmentDocModelDic = @{
                                        @"action":@"show",
                                        @"aynamicPPT":@(tIsAynamicPPT),
                                        
                                        @"ismedia":@(false),
                                        @"filedata":@{
                                                @"fileid":tDocmentDocModel.fileid,
                                                @"currpage":tDocmentDocModel.currpage?tDocmentDocModel.currpage:@(1),
                                                @"pagenum":tDocmentDocModel.pagenum?tDocmentDocModel.pagenum:@(0),
                                                @"filetype":tDocmentDocModel.filetype,
                                                @"filename":tDocmentDocModel.filename,
                                                @"swfpath":tDocmentDocModel.swfpath
                                                }
                                        };
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDocmentDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            _iFileHeadLabel.text = MTLocalized(tString);
             [_iTKEduClassRoomSessionHandle sessionHandleDelMsg:sShowPage ID:sShowPage To:sTellAll Data:jsonString completion:nil];
            [_iTKEduWhiteBoardHandle delDocmentArray:tDocmentDocModel];
            _iFileMutableArray = [[_iTKEduWhiteBoardHandle docmentArray]mutableCopy];
            [_iFileTableView reloadData];
            
        }
            break;
        case FileListTypeUserList:
        {
            NSString *tString = [NSString stringWithFormat:@"用户列表(%@人)",@([_iFileMutableArray count])];
            _iFileHeadLabel.text = MTLocalized(tString);
            RoomUser *tRoomUser =[_iFileMutableArray objectAtIndex:aIndexPath.row];
            PublishState tState = tRoomUser.publishState;
            switch (tRoomUser.publishState) {
                case PublishState_NONE:
                {
                    if (aButton.selected) {
                        tState = PublishState_VIDEOONLY;
                    }
                }
                    break;
                case PublishState_VIDEOONLY:
                {
                    if (aButton.selected) {
                        tState = PublishState_VIDEOONLY;
                    }else{
                        tState = PublishState_NONE;
                    }
                }
                    break;
                case PublishState_AUDIOONLY:
                {
                    if (aButton.selected) {
                        tState = PublishState_BOTH;
                    }else{
                        tState = PublishState_AUDIOONLY;
                    }
                }
                    break;
                case PublishState_BOTH:
                {
                    if (aButton.selected) {
                        tState = PublishState_BOTH;
                    }else{
                        tState = PublishState_AUDIOONLY;
                    }
                }
                    break;
                default:
                    break;
            }
            [_iTKEduClassRoomSessionHandle sessionHandleChangeUserPublish:tRoomUser.peerID Publish:tState completion:nil];
            
            
        }
            break;
        default:
            break;
    }
 
}
@end

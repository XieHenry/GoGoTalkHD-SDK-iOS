//
//  eduWhiteBoardView.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/9.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomManager.h"

@class TKEduClassRoomProperty,TKEduClassRoomSessionHandle,TKMediaDocModel,TKDocmentDocModel;
@import UIKit;


typedef void(^bLoadFinishedBlock)();

@protocol TKEduWhiteBoardDelegate <NSObject>
@optional


- (void)eduWhiteBoardOnFileList:(NSArray*)fileList;
- (BOOL)eduWhiteBoardOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data;
- (void)eduWhiteBoardOnRemoteMsgList:(NSArray*)list;

@end



@interface TKEduWhiteBoardHandle : NSObject<RoomWhiteBoard>


@property (nonatomic,strong) TKMediaDocModel *iCurrentMediaDocModel;
@property (nonatomic,strong) TKMediaDocModel *iPreMediaDocModel;

@property (nonatomic, strong) TKEduClassRoomSessionHandle *iEduClassRoomSessionHandle;
@property (nonatomic, weak) id<TKEduWhiteBoardDelegate>iEduWhiteBoardDelegate;
@property (nonatomic, strong) TKEduClassRoomProperty *iEduClassRoomProperty;

@property (nonatomic,assign)BOOL isClassBegin;
- (UIView*)createWhiteBoard:(id<TKEduWhiteBoardDelegate>)delegate Frame:(CGRect)rect  UserName:(NSString*)username aClassRoomProperty:(TKEduClassRoomProperty*)aClassRoomProperty aClassRoomSessionHandle:(TKEduClassRoomSessionHandle*)aClassRoomSessionHandle aBloadFinishedBlock:(bLoadFinishedBlock)aBloadFinishedBlock aRootView:(UIView *)aRootView ;
-(void)setDrawable:(BOOL) candraw;
-(void)setPagePermission:(BOOL)canPage;
-(void)pageNext;
-(void)pageFont;
- (int)uploadDocumentWithFileData:(NSData *)fileData fileName:(NSString *)filename;

//数据
-(void)clearAllWhiteBoardData;
//文档
- (NSArray *)docmentArray;
- (void)addOrReplaceDocmentArray:(TKDocmentDocModel *)aDocmentDocModel;
- (void)delDocmentArray:(TKDocmentDocModel *)aDocmentDocModel;
//音视频
- (NSArray *)mediaArray;
- (void)addOrReplaceMediaArray:(TKMediaDocModel *)aMediaDocModel;
- (void)delMediaArray:(TKMediaDocModel *)aMediaDocModel;

@end

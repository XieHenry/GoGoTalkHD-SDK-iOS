//
//  TKDocumentListView.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/13.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
#import "TKEduWhiteBoardHandle.h"
#import "TKEduClassRoomSessionHandle.h"
#import "TKEduClassRoomProperty.h"
@class RoomController;



@interface TKDocumentListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)RoomController*  delegate;

-(instancetype)initWithFrame:(CGRect)frame withWhiteBoardHandel:(TKEduWhiteBoardHandle *)aWhiteBoardHandle withClassRoomSessionHandle:(TKEduClassRoomSessionHandle *)aClassRoomSessionHandle withClassRoomProperty:(TKEduClassRoomProperty *)ahClassRoomProperty;


-(void)show:(FileListType)aFileListType aFileList:(NSArray *)aFileList isClassBegin:(BOOL)isClassBegin;
-(void)hide;

@end

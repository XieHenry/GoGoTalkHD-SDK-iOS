//
//  TKDocumentListView.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/13.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
#import "TKEduBoardHandle.h"
#import "TKEduSessionHandle.h"
#import "TKEduRoomProperty.h"
@class RoomController;



@interface TKDocumentListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)RoomController*  delegate;
@property (nonatomic, assign) BOOL isShow;
-(instancetype)initWithFrame:(CGRect)frame;

-(void)show:(FileListType)aFileListType aFileList:(NSArray *)aFileList isClassBegin:(BOOL)isClassBegin;
-(void)hide;

- (void)reloadData;
@end

//
//  TKUserListTableViewCell.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/14.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
@class TKMediaDocModel,TKDocmentDocModel,RoomUser;

@protocol listProtocol <NSObject>

-(void)listButton1:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath;
-(void)listButton2:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath;
-(void)listButton3:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath;
-(void)listButton4:(UIButton *)aButton aIndexPath:(NSIndexPath*)aIndexPath;

@end

@interface TKUserListTableViewCell : UITableViewCell

@property (weak, nonatomic) id<listProtocol> iListDelegate;

@property (strong, nonatomic) UILabel *iNameLabel;
@property (strong, nonatomic) UIImageView *iIconImageView;
@property (strong, nonatomic) UIButton *iButton1;
@property (strong, nonatomic) UIButton *iButton2;
@property (strong, nonatomic) UIButton *iButton3;
@property (strong, nonatomic) UIButton *iButton4;
@property (strong, nonatomic) UIButton *iHandUpBtn;     // 举手按钮
@property (nonatomic,assign)  FileListType  iFileListType;
@property (nonatomic, strong) NSString *text;
@property (strong, nonatomic) TKMediaDocModel *iMediaDocModel;
@property (strong, nonatomic) TKDocmentDocModel *iDocmentDocModel;
@property (strong, nonatomic) RoomUser *iRoomUserModel;
@property (strong, nonatomic) NSIndexPath *iIndexPath;

@property (nonatomic, assign) BOOL hiddenDeleteBtn;

-(void)configaration:(id)aModel withFileListType:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin;


@end

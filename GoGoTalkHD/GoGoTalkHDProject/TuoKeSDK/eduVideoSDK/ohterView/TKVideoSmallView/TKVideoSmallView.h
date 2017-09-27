//
//  TKVideoSmallView.h
//  whiteBoardDemo
//
//  Created by ifeng on 2017/2/23.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
@class TKEduSessionHandle,RoomUser;
// 枚举四个吸附方向
typedef NS_ENUM(NSInteger, EDir)
{
    EDirLeft,
    EDirRight,
    EDirTop,
    EDirBottom
};

// 悬浮按钮的尺寸
#define floatSize 50



typedef CGPoint (^bVideoSmallViewClickeBlockType)();
@interface TKVideoSmallView : UIView

-(nonnull instancetype)initWithFrame:(CGRect)frame aVideoRole:(EVideoRole)aVideoRole NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithCoder:(NSCoder * _Nullable)aDecode NS_DESIGNATED_INITIALIZER;
/** *  开始按下的触点坐标 */
@property (nonatomic, assign)CGPoint iStartPositon;
/** *  悬浮的window */
@property(strong,nonatomic)UIWindow *_Nonnull iWindow;
/** *  识别key */
@property(strong,nonatomic)NSString *_Nonnull iVideoSmallViewkey;
/** *  名字 */
@property(strong,nonatomic)UILabel *_Nonnull iNameLabel;
/** *  奖杯 */
@property(strong,nonatomic)UIButton *_Nonnull iGifButton;
/** *  当前看的peerid */
@property(copy,nonatomic)NSString *_Nonnull iPeerId;

/** *  当前的用户 */
@property(strong,nonatomic)RoomUser *_Nullable iRoomUser;

/** *  视频view */
@property (nonatomic, weak) UIView * _Nullable  iRealVideoView;
/** *  视频tag */
@property (nonatomic, assign) int iVideoViewTag;
/** *  视频Frame */
@property (nonatomic, assign) CGRect  iVideoFrame;
/** *  视频ImageView */
@property (nonatomic, strong) UIImageView * _Nullable iVideoBackgroundImageView;
/** *  授权等点击事件 */
@property(strong,nonatomic)UIButton *_Nonnull iFunctionButton;
/** *  授权等点击事件 */
@property(assign,nonatomic)BOOL  isNeedFunctionButton;


@property(strong,nonatomic)TKEduSessionHandle *_Nonnull iEduClassRoomSessionHandle;


@property(copy,nonatomic)bVideoSmallViewClickeBlockType  _Nullable bVideoSmallViewClickedBlock;

-(void)changeName:(NSString *_Nullable)aName;
-(void)hideFunctionView;
-(void)clearVideoData;
-(void)addVideoView:(UIView*_Nullable)view;
-(void)changeAudioDisabledState;
-(void)changeVideoDisabledState;
@end

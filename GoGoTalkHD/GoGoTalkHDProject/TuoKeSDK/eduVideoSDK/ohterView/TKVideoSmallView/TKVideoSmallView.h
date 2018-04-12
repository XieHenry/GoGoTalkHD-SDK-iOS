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

typedef BOOL(^IsWhiteboardContainsSelfBlock)(void);
typedef CGRect(^ResizeVideoViewBlock)(void);
typedef CGRect(^OnRemoteMsgResizeVideoViewBlock)(CGFloat);

// 悬浮按钮的尺寸
#define floatSize 50
typedef CGPoint (^bVideoSmallViewClickeBlockType)(void);

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
@property(strong,nonatomic)UILabel *_Nonnull iBackgroundLabel;
/** *  奖杯 */
@property(strong,nonatomic)UIButton *_Nonnull iGifButton;
/** *  当前看的peerid */
@property(copy,nonatomic)NSString *_Nonnull iPeerId;
/** *  是否拖拽出去了 */
@property(assign,nonatomic)BOOL isDrag;
/** *  固定到白板区标志 */
@property(assign,nonatomic)BOOL isDragWhiteBoard;
/** *  是否分屏 */
@property(assign,nonatomic)BOOL isSplit;

/** *  当前的用户 */
@property(strong,nonatomic)RoomUser *_Nullable iRoomUser;

/** *  视频view */
@property (nonatomic, weak) UIView * _Nullable  iRealVideoView;
/** *  视频tag */
@property (nonatomic, assign) NSInteger iVideoViewTag;
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


@property(nonatomic,copy) void(^ _Nullable splitScreenClickBlock)(EVideoRole aVideoRole);//分屏回调

@property(nonatomic,copy) void(^ _Nullable oneKeyResetBlock)(void);//分屏回调

@property(nonatomic,copy) void(^ _Nullable finishScaleBlock)(void);//分屏回调

@property (nonatomic, strong) IsWhiteboardContainsSelfBlock _Nullable isWhiteboardContainsSelfBlock;

@property (nonatomic, strong) ResizeVideoViewBlock _Nullable resizeVideoViewBlock;
    
@property (nonatomic, strong) OnRemoteMsgResizeVideoViewBlock _Nullable onRemoteMsgResizeVideoViewBlock;

// 记录初始窗口大小
@property (nonatomic, assign) CGFloat originalWidth;
@property (nonatomic, assign) CGFloat originalHeight;
@property (nonatomic, assign) CGFloat currentWidth;
@property (nonatomic, assign) CGFloat currentHeight;


-(void)changeName:(NSString *_Nullable)aName;
-(void)hideFunctionView;
-(void)clearVideoData;
-(void)addVideoView:(UIView*_Nullable)view;
-(void)changeAudioDisabledState;
-(void)changeVideoDisabledState;
-(void)changeVideoDisabledState2;
- (void)endInBackGround:(BOOL)isInBackground;

/**
 缩放视频窗口

 @param scale 缩放比例
 */
- (void)changeVideoSize:(CGFloat)scale;
@end

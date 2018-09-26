//
//  TKVideoFunctionView.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/15.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
#import "TKUtil.h"
#import "RoomUser.h"
@protocol VideolistProtocol <NSObject>

-(void)videoSmallbutton1:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole;
-(void)videoSmallButton2:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole;
-(void)videoSmallButton3:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole;
-(void)videoSmallButton4:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole;
-(void)videoSmallButton5:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole;
-(void)videoSmallButton6:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole;
-(void)videoOneKeyReset;

@end
@interface TKVideoFunctionView : UIView

@property (nonatomic, assign) BOOL isSplitScreen;//分屏标识
@property (nonatomic,weak)id<VideolistProtocol>iDelegate;
@property (nonatomic,strong)RoomUser *iRoomUer;
-(instancetype)initWithFrame:(CGRect)frame withType:(int)type aVideoRole:(EVideoRole)aVideoRole aRoomUer:(RoomUser*)aRoomUer isSplit:(BOOL)isSplit;


@end

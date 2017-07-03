//
//  RoomController.h
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKEduClassRoomSessionHandle.h"
@class TKEduClassRoomProperty;

@interface RoomController : UIViewController
@property (nonatomic, strong) UIView *iTKEduWhiteBoardView;
- (instancetype)initWithDelegate:(id<TKEduEnterClassRoomDelegate>)aTKEduEnterClassRoomdelegate aParamDic:(NSDictionary *)aParamDic aRoomName:(NSString *)aRoomName aClassRoomProperty:(TKEduClassRoomProperty *)aClassRoomProperty;
-(void)prepareForLeave:(BOOL)aQuityourself;
@end

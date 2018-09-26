//
//  TKVideoBoardHandle.h
//  EduClassPad
//
//  Created by lyy on 2017/12/19.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomManager.h"
#import "TKMacro.h"
#import <WebKit/WebKit.h>

//@import UIKit;
#import <UIKit/UIKit.h>

typedef void(^bLoadFinishedBlock) (void);

@interface TKVideoBoardHandle : NSObject

@property(nonatomic,retain)WKWebView *iWebView;//视频文件上的标注webview

@property(nonatomic,copy)bLoadFinishedBlock iBloadFinishedBlock;

/**
 创建视频标注页面

 @param rect frame
 @param username 用户名称
 @param aBloadFinishedBlock 完成回调
 @return 视图
 */
- (UIView*)createVideoWhiteBoardWithFrame:(CGRect)rect
                                 UserName:(NSString*)username
                    videoDrawingBoardType:(NSString *)videoDrawingBoardType
                      aBloadFinishedBlock:(bLoadFinishedBlock)aBloadFinishedBlock;

-(void)setPageParameterForPhoneForRole:(UserType)aRole;

- (void)deleteVideoWhiteBoard;
@end

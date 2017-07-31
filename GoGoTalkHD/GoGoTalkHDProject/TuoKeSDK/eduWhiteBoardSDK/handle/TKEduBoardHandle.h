//
//  eduWhiteBoardView.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/9.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomManager.h"
#import "TKMacro.h"
#import <WebKit/WebKit.h>

@import UIKit;

typedef void(^bLoadFinishedBlock)();

@interface TKEduBoardHandle : NSObject

@property(nonatomic,retain)WKWebView *iWebView;
@property(nonatomic,weak)  UIView *iRootView;

- (UIView*)createWhiteBoardWithFrame:(CGRect)rect
                   UserName:(NSString*)username
        aBloadFinishedBlock:(bLoadFinishedBlock)aBloadFinishedBlock
                  aRootView:(UIView *)aRootView;

-(void)setDrawable:(BOOL) candraw;
-(void)setPagePermission:(BOOL)canPage;
-(void)setPageParameterForPhoneForRole:(UserType)aRole;
-(void)setAddPagePermission:(bool)aPagePermission;
//数据
-(void)clearAllWhiteBoardData;
-(void)cleanup;
-(void)refreshUIForFull:(BOOL)isFull;


@end

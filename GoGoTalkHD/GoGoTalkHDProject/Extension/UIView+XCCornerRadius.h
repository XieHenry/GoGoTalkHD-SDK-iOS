//
//  UIView+XCCornerRadius.h
//  XCHelper
//
//  Created by 辰 on 2017/4/21.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XCSideType) {
    XCSideTypeTopLine    = 0,
    XCSideTypeLeftLine   = 1,
    XCSideTypeBottomLine = 2,
    XCSideTypeRightLine  = 3,
    
    XCSideTypeTopRightCorner  = 4,
    XCSideTypeTopLeftCorner  = 5,
    XCSideTypeBottomRightCorner  = 6,
    XCSideTypeBottomLeftCorner  = 7,
    
    XCSideTypeAll    = 8,
};

@interface UIView (XCCornerRadius)

/**
 *
 *  设置不同边的圆角
 *
 *  @param sideType 圆角类型
 *  @param cornerRadius 圆角半径
 */
- (void)xc_SetCornerWithSideType:(XCSideType)sideType cornerRadius:(CGFloat)cornerRadius;

@end

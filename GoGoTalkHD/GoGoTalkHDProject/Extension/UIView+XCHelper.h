//
//  UIView+XCHelper.h
//  GoGoTalk
//
//  Created by 辰 on 2017/5/5.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XCHelper)
/**
 @abstract 根据borderWidth,borderColor和cornerRadius为UIVIEW添加边框.
 @param borderWidth 边框的宽度.
 @param borderColor 边框的颜色.
 @param cornerRadius UIVIEW的圆角度.
 **/
- (void)addBorderForViewWithBorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor CornerRadius:(CGFloat)cornerRadius;
/**
 @abstract 根据shadowOffset,shadowOpacity,shadowRadius和shadowColor为UIVIEW添加阴影.
 @param shadowOffset 阴影的位置.
 @param shadowOpacity 阴影的透明度.
 @param shadowRadius 阴影的边框圆角度.
 @param shadowColor 阴影的颜色.
 **/
- (void)addShadowForViewWithShadowOffset:(CGSize)shadowOffset ShadowOpacity:(CGFloat)shadowOpacity ShadowRadius:(CGFloat)shadowRadius ShadowColor:(UIColor *)shadowColor;

- (NSLayoutConstraint *)getLayoutConstraintWithIdentify:(NSString *)identify;
@end

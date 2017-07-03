//
//  UIView+XCCornerRadius.m
//  XCHelper
//
//  Created by 辰 on 2017/4/21.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "UIView+XCCornerRadius.h"

@implementation UIView (XCCornerRadius)

- (void)xc_SetCornerWithSideType:(XCSideType)sideType cornerRadius:(CGFloat)cornerRadius
{
    
    CGSize cornerSize = CGSizeMake(cornerRadius,cornerRadius);
    UIBezierPath *maskPath;
    
    switch (sideType) {
        case XCSideTypeTopLine: {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                   cornerRadii:cornerSize];
            break;
        }
            
        case XCSideTypeLeftLine: {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                                   cornerRadii:cornerSize];
            break;
        }
            
        case XCSideTypeBottomLine: {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                   cornerRadii:cornerSize];
            break;
        }
            
        case XCSideTypeRightLine: {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)
                                                   cornerRadii:cornerSize];
            break;
        }
            
        case XCSideTypeTopLeftCorner: {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:UIRectCornerTopLeft
                                                   cornerRadii:cornerSize];
            break;
        }
            
        case XCSideTypeTopRightCorner: {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:UIRectCornerTopRight
                                                   cornerRadii:cornerSize];
            break;
        }
            
        case XCSideTypeBottomLeftCorner: {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:UIRectCornerBottomLeft
                                                   cornerRadii:cornerSize];
            break;
        }
            
        case XCSideTypeBottomRightCorner: {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:UIRectCornerBottomRight
                                                   cornerRadii:cornerSize];
            break;
        }
            
        default: {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:UIRectCornerAllCorners
                                                   cornerRadii:cornerSize];
            break;
        }
    }
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
    [self.layer setMasksToBounds:YES];
}

@end

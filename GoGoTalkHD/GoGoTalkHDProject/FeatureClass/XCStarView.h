//
//  XCStarView.m
//  EvaluationStar
//
//  Created by 辰 on 15/11/26.
//  Copyright © 2015年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XCSelectBlock)(NSInteger count);

@interface XCStarView : UIView

@property (nonatomic, assign) NSInteger selectedStatCount;

@property (nonatomic, copy) XCSelectBlock selectBlock;

// 
- (instancetype)initWithEmptyImage:(NSString *)Empty StarImage:(NSString *)Star totalStarCount:(NSInteger)totalStarCount starMargin:(CGFloat)starMargin starWidth:(CGFloat)starWidth selectBlock:(XCSelectBlock)selectBlock;


// 选中星星的个数
- (instancetype)initWithEmptyImage:(NSString *)Empty StarImage:(NSString *)Star totalStarCount:(NSInteger)totalStarCount selectedStatCount:(NSInteger)selectedStatCount starMargin:(CGFloat)starMargin starWidth:(CGFloat)starWidth;


@end

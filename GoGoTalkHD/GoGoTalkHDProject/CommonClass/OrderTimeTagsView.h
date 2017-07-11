//
//  OrderTimeTagsView.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/9.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TagClickedBlock)(NSString *tagsString);

@interface OrderTimeTagsView : UIView
{
    UIView *view;
    NSArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) UIColor *textbackgroundColor; //背景色
@property (nonatomic, strong) UIColor *bordColor;       //边框颜色
@property (nonatomic, strong) UIColor *textColor;       //文字颜色
@property (nonatomic, assign) CGFloat textSize;         //字号
@property (nonatomic, assign) CGFloat cornerRadius;     //圆角度数
@property (nonatomic, assign) BOOL allowClick;          //是否允许点击
@property (nonatomic, copy) TagClickedBlock tagClickedBlock;
- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@end

//
//  UILabel+XCHelper.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/2.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XCHelper)

#pragma mark - 使用之前 label必须有内容 即text必须有值 可设置成” “ 之后再修改内容
/*
 label.font = Font(18);
 label.textColor = UICOLOR_FROM_HEX(Color777777);
 label.text = @" ";
 [label changeLineSpaceWithSpace:10.0];
 // 需要放到设置行间距的后面
 label.textAlignment = NSTextAlignmentCenter;
 label.numberOfLines = 0;
 */
/**
 *  改变行间距
 */
- (void)changeLineSpaceWithSpace:(float)space;

/**
 *  改变字间距
 */
- (void)changeWordSpaceWithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)changeSpacewithLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


@end

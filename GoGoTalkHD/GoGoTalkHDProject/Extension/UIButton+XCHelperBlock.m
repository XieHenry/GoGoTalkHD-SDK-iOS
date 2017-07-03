//
//  UIButton+XCHelperBlock.m
//  XCHelper
//
//  Created by 辰 on 2017/4/21.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "UIButton+XCHelperBlock.h"
#import <objc/runtime.h>

@interface UIButton ()

@property(nonatomic, strong)XCUIButtonClickBlock clickBlock;

@end

@implementation UIButton (XCHelperBlock)

// OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
// OBJC_EXPORT id objc_getAssociatedObject(id object, const void *key)
// const void *key 可以使用static NSString * const name = @"name"; 来代替  只是一个唯一的标识符，绑定set和get方法
// 在get方法中_cmd相当于@select(clickBlock)
// 在set方法中不能使用_cmd


- (void)xc_addClickBlock:(XCUIButtonClickBlock)block{
    self.clickBlock = block;
}

- (void)xc_UIButtonEvent: (UIButton *)sender{
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
}


- (void)setClickBlock:(XCUIButtonClickBlock)clickBlock{
    if (clickBlock != self.clickBlock) {
        
        /**
         *  两种方式的runtime
         */
        objc_setAssociatedObject(self, @selector(clickBlock), clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        [self addTarget: self action: @selector(xc_UIButtonEvent:) forControlEvents: UIControlEventTouchUpInside];
        
        // 不知道什么用
        if (!clickBlock) {
            [self removeTarget: self action: @selector(xc_UIButtonEvent:) forControlEvents: UIControlEventTouchUpInside];
        }
    }
}


- (XCUIButtonClickBlock)clickBlock{
    return objc_getAssociatedObject(self, _cmd);    // 这个方法等价于下面的那个方法
    //    return objc_getAssociatedObject(self, @selector(clickBlock));
}

@end

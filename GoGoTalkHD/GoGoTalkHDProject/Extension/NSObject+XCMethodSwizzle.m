//
//  NSObject+XCMethodSwizzle.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/7.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "NSObject+XCMethodSwizzle.h"

@implementation NSObject (XCMethodSwizzle)

+ (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(newMethod),
                                        method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@end

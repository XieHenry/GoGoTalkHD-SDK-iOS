//
//  NSObject+XCMethodSwizzle.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/7.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XCMethodSwizzle)

+ (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end

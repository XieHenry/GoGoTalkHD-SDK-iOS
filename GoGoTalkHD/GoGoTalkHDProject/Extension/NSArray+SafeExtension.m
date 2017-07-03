//
//  NSArray+SafeExtension.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "NSArray+SafeExtension.h"

@implementation NSArray (SafeExtension)

- (id)safe_objectAtIndex:(NSInteger) index{
    
    if (index < self.count) {
        return [self objectAtIndex:index];
    }else{
        NSLog(@"----------数组越界--------");
        return nil;
    }
}


@end

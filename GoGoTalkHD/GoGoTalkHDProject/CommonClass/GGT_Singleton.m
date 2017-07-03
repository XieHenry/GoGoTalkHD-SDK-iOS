//
//  GGT_Singleton.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_Singleton.h"


static GGT_Singleton *singleton = nil;
@implementation GGT_Singleton

+ (GGT_Singleton *)sharedSingleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[GGT_Singleton alloc]init];
    });
    
    return singleton;
}

@end

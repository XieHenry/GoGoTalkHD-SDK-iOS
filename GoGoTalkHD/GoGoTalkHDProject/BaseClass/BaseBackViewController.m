//
//  BaseBackViewController.m
//  GoGoTalk
//
//  Created by 辰 on 2017/5/5.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "BaseBackViewController.h"

@interface BaseBackViewController ()

@end

@implementation BaseBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackButton];
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}



@end

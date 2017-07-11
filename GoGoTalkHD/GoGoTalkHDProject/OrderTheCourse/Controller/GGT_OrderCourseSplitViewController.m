//
//  GGT_OrderCourseSplitViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderCourseSplitViewController.h"
#import "GGT_OrderCourseOfAllLeftVc.h"
#import "GGT_OrderCourseOfAllRightVc.h"

@interface GGT_OrderCourseSplitViewController () <UISplitViewControllerDelegate>

@end

@implementation GGT_OrderCourseSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    GGT_OrderCourseOfAllLeftVc *LeftVC = [[GGT_OrderCourseOfAllLeftVc alloc] init];
    
    
    GGT_OrderCourseOfAllRightVc *RightVc = [[GGT_OrderCourseOfAllRightVc alloc] init];
    
    self.viewControllers = @[LeftVC, RightVc];
    //使用UISplitViewController前，第一步要做的是设置ViewControllers数组，再设置控制器的其他属性
    self.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  GGT_MineSplitViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineSplitViewController.h"
#import "GGT_MineLeftViewController.h"
#import "GGT_MineRightViewController.h"


@interface GGT_MineSplitViewController () <UISplitViewControllerDelegate>

@end

@implementation GGT_MineSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);

    GGT_MineLeftViewController *mineLeftVC = [[GGT_MineLeftViewController alloc] init];

    
    GGT_MineRightViewController *mineRightVc = [[GGT_MineRightViewController alloc] init];
    BaseNavigationController *detailNav = [[BaseNavigationController alloc] initWithRootViewController:mineRightVc];
    
    self.viewControllers = @[mineLeftVC, detailNav];
    //使用UISplitViewController前，第一步要做的是设置ViewControllers数组，再设置控制器的其他属性
    self.delegate = self;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

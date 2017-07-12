//
//  GGT_OrderCourseOfAllLeftVc.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderCourseOfAllLeftVc.h"
#import "GGT_OrderCourseLeftView.h"


@interface GGT_OrderCourseOfAllLeftVc ()

@end

@implementation GGT_OrderCourseOfAllLeftVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.splitViewController.maximumPrimaryColumnWidth = LineW(350); //可以修改屏幕的宽度
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.48;
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    [self initView];
    
    
}


- (void)initView {
    GGT_OrderCourseLeftView *view = [[GGT_OrderCourseLeftView alloc]init];
    view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.view addSubview:view];
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

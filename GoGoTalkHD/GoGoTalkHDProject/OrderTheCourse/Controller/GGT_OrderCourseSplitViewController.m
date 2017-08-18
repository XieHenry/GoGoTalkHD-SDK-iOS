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
#import "AppDelegate.h"

@interface GGT_OrderCourseSplitViewController () <UISplitViewControllerDelegate>
@property (nonatomic, strong) GGT_OrderCourseOfAllLeftVc *LeftVC;

@end

@implementation GGT_OrderCourseSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
     self.LeftVC = [[GGT_OrderCourseOfAllLeftVc alloc] init];
    __weak GGT_OrderCourseSplitViewController *weakself  = self;
    
    self.LeftVC.refreshLoadData = ^(BOOL is) {
        if (is == YES) {
            [weakself hideLoadingView];
            
        } else {
            [weakself showLoadingView];
            
            weakself.loadingView.loadingFailedBlock = ^(UIButton *btn){
                
                [weakself.LeftVC xc_refreshData];
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate getDayAndWeekLoadData];
                
            };
            
        }
    };
    
    
    
    
    GGT_OrderCourseOfAllRightVc *RightVc = [[GGT_OrderCourseOfAllRightVc alloc] init];
    
    self.viewControllers = @[self.LeftVC, RightVc];
    //使用UISplitViewController前，第一步要做的是设置ViewControllers数组，再设置控制器的其他属性
    self.delegate = self;
    
    self.LeftVC.delegate = RightVc;
    
}

#pragma mark 网络请求失败后，重新点击按钮加载数据
- (void)showLoadingView{
    
    if (!self.loadingView) {
        _loadingView = [[GGT_LoadingView alloc] initWithFrame:CGRectMake(0, 0,marginFocusOn, SCREEN_HEIGHT())];
    }
    
    [self.view addSubview:_loadingView];
}

- (void)hideLoadingView{
    
    double delaySeconds = 0.5;
    __weak GGT_OrderCourseSplitViewController *weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        [weakSelf.loadingView hideLoadingView];
        
        weakSelf.loadingView = nil;
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  GGT_CheckDevicePopViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/19.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_CheckDevicePopViewController.h"
#import "GGT_CheckDeviceView.h"

@interface GGT_CheckDevicePopViewController ()

@property (nonatomic, strong) UIButton *xc_rightItem;
@property (nonatomic, strong) GGT_CheckDeviceView *checkDeviceView;
@end

@implementation GGT_CheckDevicePopViewController

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 462;
        tempSize.height = 323;//368 切图是368，减去45的导航高度
        return tempSize;
    }else {
        return [super preferredContentSize];
    }
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检测设备";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(16),NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil]];
    
    
    [self initView];
    
    [self initNavBarItem];
    
}

- (void)initView {
    self.checkDeviceView = [[GGT_CheckDeviceView alloc]init];
    [self.view addSubview:self.checkDeviceView];
    
    [self.checkDeviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    
    
    @weakify(self);
    [[self.checkDeviceView.cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    
    [[self.checkDeviceView.setButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

     }];

}

#pragma mark 导航
- (void)initNavBarItem {

    self.xc_rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xc_rightItem setTitle:@"关闭" forState:UIControlStateNormal];
    self.xc_rightItem.titleLabel.font = Font(14);
    [self.xc_rightItem sizeToFit];
    [self.xc_rightItem setTitleColor:UICOLOR_FROM_HEX(ColorC40016) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.xc_rightItem];
    
    
    @weakify(self);
    [[self.xc_rightItem rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
}


@end

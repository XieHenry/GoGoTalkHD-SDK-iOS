//
//  GGT_CourseDetailsViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/6/23.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_CourseDetailsViewController.h"

@interface GGT_CourseDetailsViewController ()

@end

@implementation GGT_CourseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.navigationItem.title = @"课程详情";

    
    WKWebView *webView = [[WKWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gogo-talk.com"]]];
    webView.scrollView.bounces=NO;
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

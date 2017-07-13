//
//  GGT_DetailsOfTeacherViewController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_DetailsOfTeacherViewController.h"
#import "GGT_DetailsOfTeacherView.h"

@interface GGT_DetailsOfTeacherViewController ()

@property (nonatomic, strong) GGT_DetailsOfTeacherView *detailsOfTeacherView;
@end

@implementation GGT_DetailsOfTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"老师详情";
    
    [self setLeftBackButton];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    

    
    GGT_DetailsOfTeacherView *View = [[GGT_DetailsOfTeacherView alloc]initWithFrame:CGRectMake(0, 0, marginFocusOn, LineH(124))];
    View.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.view addSubview:View];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
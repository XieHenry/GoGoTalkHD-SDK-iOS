//
//  GGT_OrderCourseViewController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderCourseViewController.h"
#import "GGT_OrderCourseOfFocusViewController.h"
#import "GGT_OrderCourseSplitViewController.h"

@interface GGT_OrderCourseViewController ()
@property (nonatomic, strong) GGT_OrderCourseOfFocusViewController  *focusVc;
@property (nonatomic, strong) GGT_OrderCourseSplitViewController  *allVC;
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *animaView;


@end

@implementation GGT_OrderCourseViewController


- (void)changeNav {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航上的2个切换按钮
    [self initSegmentedControl];
    
    //添加2个子视图
    [self setUpNewController];
    
}

- (void)setUpNewController {
    self.allVC = [[GGT_OrderCourseSplitViewController alloc] init];
    [self.allVC.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT())];
    [self addChildViewController:self.allVC];
    
    self.focusVc = [[GGT_OrderCourseOfFocusViewController alloc] init];
    [self.focusVc.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT())];
    
    //  默认,第一个视图(你会发现,全程就这一个用了addSubview)
    [self.view addSubview:self.allVC.view];
    self.currentVC = self.allVC;
    
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController {
    /*
     transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.3f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        } else {
            
            self.currentVC = oldController;
            
        }
    }];
}


- (void)initSegmentedControl {
    
    //添加到视图  368   60
    self.titleView = [[UIView alloc]init];
    self.titleView.frame = CGRectMake((marginFocusOn-LineW(184))/2, LineY(9), LineW(184), LineH(30));
    self.titleView.layer.masksToBounds = YES;
    self.titleView.layer.cornerRadius = LineH(15);
    self.titleView.layer.borderColor = UICOLOR_FROM_HEX(ColorFFFFFF).CGColor;
    self.titleView.layer.borderWidth = LineW(1);
    self.navigationItem.titleView = self.titleView ;
    
    
    self.animaView = [[UIView alloc]init];
    self.animaView.frame = CGRectMake(0,0, LineW(92), LineH(30));
    self.animaView.layer.masksToBounds = YES;
    self.animaView.layer.cornerRadius = LineH(15);
    self.animaView.layer.borderColor = UICOLOR_FROM_HEX(ColorFFFFFF).CGColor;
    self.animaView.layer.borderWidth = LineW(1);
    self.animaView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.titleView addSubview:self.animaView];
    
    
    
    UIButton *allButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    allButton.frame = CGRectMake(0, 0, LineW(92), LineH(30));
    [allButton setTitle:@"全部" forState:(UIControlStateNormal)];
    [allButton setTitleColor:UICOLOR_FROM_HEX(ColorC40016) forState:(UIControlStateNormal)];
    allButton.titleLabel.font = Font(18);
    [allButton addTarget:self action:@selector(changeVc:) forControlEvents:(UIControlEventTouchUpInside)];
    allButton.tag = 5;
    allButton.selected = YES;
    [self.titleView addSubview:allButton];
    
    
    
    UIButton *focusButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    focusButton.frame = CGRectMake(LineW(92), 0, LineW(92), LineH(30));
    [focusButton setTitle:@"关注" forState:(UIControlStateNormal)];
    [focusButton setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
    [focusButton addTarget:self action:@selector(changeVc:) forControlEvents:(UIControlEventTouchUpInside)];
    focusButton.tag = 6;
    focusButton.titleLabel.font = Font(18);
    [self.titleView addSubview:focusButton];
    
}

- (void)changeVc:(UIButton *)button {
    
    if (button.tag == 5) {
        //  点击处于当前页面的按钮,直接跳出
        if (self.currentVC == self.allVC) {
            return;
        } else {
            [button setTitleColor:[UIColor clearColor] forState:(UIControlStateNormal)];
            
            UIButton *btn = [self.titleView viewWithTag:6];
            [btn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
            [button setTitleColor:UICOLOR_FROM_HEX(ColorC40016) forState:(UIControlStateNormal)];
            

            [UIView animateWithDuration:0.3 animations:^{
                self.animaView.frame = CGRectMake(0,0, LineW(92), LineH(30));

            } completion:^(BOOL finished) {
                [self anima];

            }];
            
            
            [self replaceController:self.currentVC newController:self.allVC];
        }
    } else if (button.tag == 6) {
        if (self.currentVC == self.focusVc) {
            return;
        } else {
            [button setTitleColor:[UIColor clearColor] forState:(UIControlStateNormal)];
            
            UIButton *btn = [self.titleView viewWithTag:5];
            [btn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
            [button setTitleColor:UICOLOR_FROM_HEX(ColorC40016) forState:(UIControlStateNormal)];
            
            
            [UIView animateWithDuration:0.3 animations:^{
                self.animaView.frame = CGRectMake(LineW(92),0, LineW(92), LineH(30));
                
            } completion:^(BOOL finished) {
                [self anima];
            }];
            
            
            [self replaceController:self.currentVC newController:self.focusVc];
        }
    }
}

//抖动动画
- (void)anima {
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = [NSNumber numberWithFloat:-2];
    shake.toValue = [NSNumber numberWithFloat:2];
    shake.duration = 0.1;//执行时间
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 2;//次数
    [_animaView.layer addAnimation:shake forKey:@"shakeAnimation"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

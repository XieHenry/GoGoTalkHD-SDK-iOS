//
//  TKDrogView.h
//  whiteBoardDemo
//
//  Created by ifeng on 2017/2/22.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
//屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define ScreenW [UIScreen mainScreen].bounds.size.width

// 枚举四个吸附方向

typedef NS_ENUM(NSInteger, Dir)
{
    LEFT,
    RIGHT,
    TOP,
    BOTTOM
};


// 悬浮按钮的尺寸
#define floatSize 50

/** *  代理按钮的点击事件 */
@protocol UIDragButtonDelegate <NSObject>
- (void)dragButtonClicked:(UIButton  * _Nullable )sender;
@end

@interface UIDragButton : UIButton
/** *  悬浮窗所依赖的根视图 */
@property (nonatomic, strong) UIView * _Nonnull rootView;

/** *  UIDragButton的点击事件代理 */
@property (nonatomic, weak) id  < UIDragButtonDelegate > _Nullable  btnDelegate;

@end



@interface UIDragButton()
/** *  开始按下的触点坐标 */
@property (nonatomic, assign)CGPoint startPos;

@end

@implementation UIDragButton

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
/** *  开始触摸，记录触点位置用于判断是拖动还是点击 */
- (void)touchesBegan:(NSSet<UITouch *> *_Nonnull)touches withEvent:(nullable UIEvent *)event {
    // 获得触摸在根视图中的坐标


    UITouch *touch = [touches anyObject];
    _startPos = [touch locationInView:_rootView];
}
/** *  手指按住移动过程,通过悬浮按钮的拖动事件来拖动整个悬浮窗口 */
- (void)touchesMoved:(NSSet<UITouch *> *_Nonnull)touches withEvent:(nullable UIEvent *)event{
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 移动按钮到当前触摸位置
    self.superview.center = curPoint;
}
/** *  拖动结束后使悬浮窗口吸附在最近的屏幕边缘 */
- (void)touchesEnded:(NSSet<UITouch *> *_Nonnull)touches withEvent:(UIEvent *_Nullable)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 通知代理,如果结束触点和起始触点极近则认为是点击事件
    if (pow((_startPos.x - curPoint.x),2) + pow((_startPos.y - curPoint.y),2) < 1) {
        [self.btnDelegate dragButtonClicked:self];
    }
    // 与四个屏幕边界距离
    CGFloat left = curPoint.x;
    CGFloat right = ScreenW - curPoint.x;
    CGFloat top = curPoint.y;
    CGFloat bottom = ScreenH - curPoint.y;
    // 计算四个距离最小的吸附方向
    Dir minDir = LEFT;
    CGFloat minDistance = left;
    if (right < minDistance) {
        minDistance = right;
        minDir = RIGHT;
    }
    if (top < minDistance)
    {        minDistance = top;
        minDir = TOP;
    }
    if (bottom < minDistance) {        minDir = BOTTOM;    }
    // 开始吸附
    switch (minDir) {
        case LEFT:
            self.superview.center = CGPointMake(self.superview.frame.size.width/2, self.superview.center.y);
            break;
        case RIGHT:
            self.superview.center = CGPointMake(ScreenW - self.superview.frame.size.width/2, self.superview.center.y);
            break;
        case TOP:
            self.superview.center = CGPointMake(self.superview.center.x, self.superview.frame.size.height/2);
            break;
        case BOTTOM:
            self.superview.center = CGPointMake(self.superview.center.x, ScreenH - self.superview.frame.size.height/2);
            break;
        default:            break;
    }
}
@end



@interface FloatingViewController:UIViewController <UIDragButtonDelegate>
/** *  悬浮的window */
@property(strong,nonatomic)UIWindow *_Nonnull window;
/** *  悬浮的按钮 */
@property(strong,nonatomic)UIDragButton *_Nonnull button;
@end
//#import "FloatingViewController.h"
//#import "UIDragButton.h"
@implementation FloatingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 将视图尺寸设置为0，防止阻碍其他视图元素的交互
    self.view.frame = CGRectZero;
    // 延时显示悬浮窗口
    [self performSelector:@selector(createButton) withObject:nil afterDelay:1];
}
/** *  创建悬浮窗口 */
- (void)createButton{
    // 悬浮按钮
    _button = [UIDragButton buttonWithType:UIButtonTypeCustom];
    [_button setImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
    // 按钮图片伸缩充满整个按钮
    _button.imageView.contentMode = UIViewContentModeScaleToFill;
    _button.frame = CGRectMake(0, 0, floatSize, floatSize);
    // 按钮点击事件
    //
    [_button addTarget:self action:@selector(dragButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 按钮点击事件代理
    _button.btnDelegate = self;
    // 初始选中状态
    _button.selected = NO;
    // 禁止高亮
    _button.adjustsImageWhenHighlighted = NO;
    _button.rootView = self.view.superview;
    // 悬浮窗
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(ScreenW-floatSize, ScreenH/2, floatSize, floatSize)];
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor orangeColor];
    _window.layer.cornerRadius = floatSize/2;
    _window.layer.masksToBounds = YES;
    // 将按钮添加到悬浮按钮上
    [_window addSubview:_button];
    //显示window
    [_window makeKeyAndVisible];
}
/** *  悬浮按钮点击 */
- (void)dragButtonClicked:(UIButton *_Nullable)sender {
    // 按钮选中关闭切换
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"add_rotate"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
    }
    // 关闭悬浮窗
    [_window resignKeyWindow];
    _window = nil;
    
}


@end
/*
 http://www.th7.cn/Program/IOS/201606/878750.shtml
 ＊使用方法只要在根视图控制器中实例化一个FloatingViewController，作为子控制器和子视图即可：
 floatingVIewController *floatVC = [[floatingVIewController alloc]init];
 [self addchildviewcontroller:fload];
 self.view addsubview:foltavc.view
 */


@interface TKDrogView : UIView

@end

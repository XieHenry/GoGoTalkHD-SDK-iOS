//
//  GGT_PreviewCourseAlertView.m
//  GoGoTalk
//
//  Created by 辰 on 2017/5/8.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_PreviewCourseAlertView.h"

static NSString * const enterButtonTitle = @"进入教室";

@interface GGT_PreviewCourseAlertView ()
@property (nonatomic, strong) UIImageView *xc_contentImgView;
@property (nonatomic, strong) UIButton *xc_cancleButton;
@property (nonatomic, strong) UILabel *xc_titleLabel;
@property (nonatomic, strong) UILabel *xc_messageLabel;
@property (nonatomic, strong) UIButton *xc_enterRoomButton;

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *messageString;

@end

@implementation GGT_PreviewCourseAlertView

//+ (instancetype)shareAlertView
//{
//    static GGT_PreviewCourseAlertView *alertView = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        alertView = [GGT_PreviewCourseAlertView new];
//    });
//    return alertView;
//}

+ (instancetype)viewWithTitle:(NSString *)title message:(NSString *)message cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock
{
    GGT_PreviewCourseAlertView *shareView = [[GGT_PreviewCourseAlertView alloc] init];
    shareView.frame = [UIScreen mainScreen].bounds;
    shareView.backgroundColor = UICOLOR_FROM_RGB_ALPHA(0, 0, 0, 0.4);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareView];
    
    shareView.titleString = title;
    shareView.messageString = message;
    shareView.cancleBlock = cancleBlock;
    shareView.enterBlock = enterBlock;
    
    [shareView initView];
    [shareView mas_view];
    [shareView initEnent];
    [shareView setShowAnimation:XCAnimationNO];
    return shareView;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = UICOLOR_FROM_RGB_ALPHA(0, 0, 0, 0.2);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        self.titleString = title;
        self.messageString = message;
        self.cancleBlock = cancleBlock;
        self.enterBlock = enterBlock;
        
        [self initView];
        [self mas_view];
        [self initEnent];
        [self setShowAnimation:XCAnimationNO];
    }
    return self;
}

- (void)initView
{
    self.xc_contentImgView = ({
        UIImageView *xc_contentImgView = [UIImageView new];
        UIImage *img = UIIMAGE_FROM_NAME(@"jijiangkaike_background");
        xc_contentImgView.image = img;
        xc_contentImgView.contentMode = UIViewContentModeCenter;
        xc_contentImgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        xc_contentImgView.userInteractionEnabled = YES;
        xc_contentImgView;
    });
    [self addSubview:self.xc_contentImgView];
    
    self.xc_cancleButton = ({
        UIButton *xc_cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = UIIMAGE_FROM_NAME(@"Shut_down");
        [xc_cancleButton setImage:img forState:UIControlStateNormal];
        [xc_cancleButton setImage:img forState:UIControlStateHighlighted];
        xc_cancleButton.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [xc_cancleButton sizeToFit];
        xc_cancleButton;
    });
    [self.xc_contentImgView addSubview:self.xc_cancleButton];
    
    self.xc_titleLabel = ({
        UILabel *xc_titleLabel = [UILabel new];
        xc_titleLabel.text = self.titleString;
        xc_titleLabel.textColor = UICOLOR_FROM_HEX(Color333333);
        xc_titleLabel.font = Font(24);
        xc_titleLabel;
    });
    [self.xc_contentImgView addSubview:self.xc_titleLabel];
    
    self.xc_messageLabel = ({
        UILabel *xc_messageLabel = [UILabel new];
        xc_messageLabel.text = self.messageString;
        xc_messageLabel.textColor = UICOLOR_FROM_HEX(Color333333);
        xc_messageLabel.font = Font(19);
        xc_messageLabel;
    });
    [self.xc_contentImgView addSubview:self.xc_messageLabel];
    
    self.xc_enterRoomButton = ({
        UIButton *xc_enterRoomButton = [UIButton new];
        xc_enterRoomButton.frame = CGRectMake(0, 0, 0, 0);
        [xc_enterRoomButton setBackgroundColor:UICOLOR_FROM_HEX(kThemeColor)];
        [xc_enterRoomButton setTitle:enterButtonTitle forState:UIControlStateNormal];
        [xc_enterRoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        xc_enterRoomButton.titleLabel.font = Font(17);
        xc_enterRoomButton;
    });
    [self.xc_contentImgView addSubview:self.xc_enterRoomButton];
}

- (void)mas_view
{
    [self.xc_contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.xc_contentImgView.width));//289*264
        make.height.equalTo(@(self.xc_contentImgView.height));
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.xc_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_contentImgView.mas_top).offset(LineH(24));
        make.right.equalTo(self.xc_contentImgView.mas_right).offset(-LineW(7));
    }];
    
    [self.xc_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.xc_contentImgView);
    }];
    
    [self.xc_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xc_titleLabel);
        make.top.equalTo(self.xc_titleLabel.mas_bottom).offset(LineH(margin15));
    }];
    
    [self.xc_enterRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(LineW(180)));
        make.height.equalTo(@(LineH(39)));
        make.centerX.equalTo(self.xc_messageLabel);
        make.bottom.equalTo(self.xc_contentImgView.mas_bottom).offset(-LineH(20));
    }];
    
    // 需要更新 不然frame为0
    [self layoutIfNeeded];
    self.xc_enterRoomButton.layer.masksToBounds = YES;
    self.xc_enterRoomButton.layer.cornerRadius = self.xc_enterRoomButton.height/2.0f;
}

- (void)initEnent
{
    @weakify(self);
    [[self.xc_enterRoomButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.enterBlock) {
             self.enterBlock();
         }
         [self removeFromSuperview];
     }];
    
    [[self.xc_cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.cancleBlock) {
             self.cancleBlock();
         }
         [self removeFromSuperview];
     }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

-(void)setShowAnimation:(XCShowAnimationStyle)animationStyle
{
    int count = 4;
    switch (animationStyle) {
            
        case XCAnimationDefault:
        {
            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.xc_contentImgView.layer setValue:@(0) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.23 * count delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.xc_contentImgView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.09 *count delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [self.xc_contentImgView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.05 *count delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [self.xc_contentImgView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
        }
            break;
            
        case XCAnimationLeftShake:{
            
            CGPoint startPoint = CGPointMake(-self.xc_contentImgView.width, self.center.y);
            self.xc_contentImgView.layer.position=startPoint;
            
            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
            //velocity:弹性复位的速度
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.xc_contentImgView.layer.position=self.center;
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case XCAnimationTopShake:{
            
            CGPoint startPoint = CGPointMake(self.center.x, -self.xc_contentImgView.frame.size.height);
            self.xc_contentImgView.layer.position=startPoint;
            
            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
            //velocity:弹性复位的速度
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.xc_contentImgView.layer.position=self.center;
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case XCAnimationNO:{
            
        }
            
            break;
            
        default:
            break;
    }
    
}

@end

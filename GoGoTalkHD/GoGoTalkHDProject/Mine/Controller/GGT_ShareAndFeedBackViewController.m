//
//  GGT_ShareAndFeedBackViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/19.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ShareAndFeedBackViewController.h"


@interface GGT_ShareAndFeedBackViewController ()
//分享
@property (nonatomic, strong) ShareView *shareView;
//反馈
@property (nonatomic, strong) FeedBackView *feedBackView;

@end

@implementation GGT_ShareAndFeedBackViewController

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
       
        if (self.isShareController == YES) {
            tempSize.width = 482;
            tempSize.height = 196;//减去45的导航高度
        } else {
            tempSize.width = 462;
            tempSize.height = 240;//减去45的导航高度
        }
        //分享的尺寸为482 241，反馈的尺寸为462 285
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
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(16),NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil]];
    
    [self initView];
    
}

- (void)initView {
    
    if (self.isShareController == YES) {
        self.title = @"分享";

        __weak typeof(self) weakSelf = self;
        self.shareView = [[ShareView alloc]init];
        self.shareView.buttonClickBlock = ^(UIButton *button) {
            if (weakSelf.testbuttonClickBlock) {
                weakSelf.testbuttonClickBlock(button);
            }
        };
        [self.view addSubview:self.shareView];
        
        [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];

    } else {
        self.title = @"反馈成功!";

        self.feedBackView = [[FeedBackView alloc]init];
        [self.view addSubview:self.feedBackView];
        
        [self.feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
    }
    

    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-LineH(49));
        make.height.equalTo(@(LineH(1)));
    }];
    
    
    //按钮----取消或者知道了
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isShareController == YES) {
        [nextButton setTitleColor:UICOLOR_FROM_HEX(Color777777) forState:UIControlStateNormal];
        [nextButton setTitle:@"取消" forState:(UIControlStateNormal)];
    }else {
        [nextButton setTitleColor:UICOLOR_FROM_HEX(ColorC40016) forState:UIControlStateNormal];
        [nextButton setTitle:@"知道了" forState:(UIControlStateNormal)];
    }
    nextButton.titleLabel.font = Font(16);
    [nextButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
        make.height.equalTo(@(LineH(49)));
    }];

}

#pragma mark 取消----知道了按钮
- (void)buttonAction {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end


/*************************************************************************************************************************/
#pragma mark 分享模块
@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initShareView];
        
    }
    return self;
    
}

- (void)initShareView {
   //检测是否安装app
    NSMutableArray *imgArray = [NSMutableArray array];
    NSMutableArray *titleArray = [NSMutableArray array];

    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession] == YES) {
        [imgArray addObject:@"WeChat"];
        [imgArray addObject:@"Circleoffriends"];
        
        [titleArray addObject:@"微信好友"];
        [titleArray addObject:@"朋友圈"];
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ] == YES) {
        [imgArray addObject:@"QQ"];
        [imgArray addObject:@"QQ_space"];
        
        [titleArray addObject:@"QQ好友"];
        [titleArray addObject:@"QQ空间"];
    }
    
    //默认只有一个新浪微博，因为他可以调取webview进行登录。
        [imgArray addObject:@"Sina_weibo"];
        [titleArray addObject:@"新浪微博"];

        CGFloat w = LineW(172)/6;
    
    for (int i=0; i<imgArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(w+w*i+LineW(62)*i, LineY(31), LineW(62), LineH(61));
        [button setBackgroundImage:UIIMAGE_FROM_NAME(imgArray[i]) forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titleArray[i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor clearColor] forState:(UIControlStateNormal)];
        [self addSubview:button];
        
        
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.frame = CGRectMake(w+w*i+LineW(62)*i, button.y+button.height+LineH(6), LineW(62), LineH(17));
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.font = Font(12);
        leftLabel.text = titleArray[i];
        leftLabel.textColor = UICOLOR_FROM_HEX(Color232323);
        [self addSubview:leftLabel];
    }
    
}

- (void)buttonClick:(UIButton *)button {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(button);
    }
}

@end


/*************************************************************************************************************************/

#pragma mark 反馈模块
@implementation FeedBackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
                [self initFeedBackView];
        
    }
    return self;
    
}

- (void)initFeedBackView {
    
    //Hi
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.font = Font(18);
    leftLabel.text = @"Hi";
    leftLabel.textColor = UICOLOR_FROM_HEX(0x1A1A1A);
    [self addSubview:leftLabel];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(LineX(20));
        make.top.equalTo(self.mas_top).with.offset(LineX(20));
        make.height.equalTo(@(LineH(25)));
    }];
    
    
    //中间文字
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = Font(16);
    contentLabel.textColor = UICOLOR_FROM_HEX(0x1A1A1A);
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 行间距设置为5
    [paragraphStyle  setLineSpacing:LineH(5)];
    NSString  *testString = @"您的反馈已经提交成功，GoGoTalk团队会将您提出的建议纳入产品和服务的优化改进中，谢谢您的关注！";
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    
    // 设置Label要显示的text
    [contentLabel  setAttributedText:setString];
    [self addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(LineX(20));
        make.right.equalTo(self.mas_right).with.offset(-LineX(20));
        make.top.equalTo(leftLabel.mas_bottom).with.offset(LineY(10));
        make.height.equalTo(@(LineH(50)));
    }];
    
    
    
    //right
    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.font = Font(14);
    rightLabel.text = @"GoGoTalk团队";
    rightLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    [self addSubview:rightLabel];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-LineW(20));
        make.top.equalTo(contentLabel.mas_bottom).with.offset(LineX(24));
        make.height.equalTo(@(LineH(20)));
    }];
    
    
}

@end




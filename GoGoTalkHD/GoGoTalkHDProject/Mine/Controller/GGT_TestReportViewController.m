//
//  GGT_TestReportViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/15.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_TestReportViewController.h"
#import "GGT_ShareAndFeedBackViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "GGT_MineClassPlaceholderView.h"

@interface GGT_TestReportViewController () <UIPopoverPresentationControllerDelegate>


@property (nonatomic, strong) GGT_MineClassPlaceholderView *mineClassPlaceholderView;

@property (nonatomic, copy) NSString *shareUrlStr ;

@property (nonatomic, copy) NSString *nameStr;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation GGT_TestReportViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.navigationItem.title = @"测评报告";
    
    
    //分享按钮
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setImage:UIIMAGE_FROM_NAME(@"Share_white") forState:UIControlStateNormal];
    [_rightBtn setImage:UIIMAGE_FROM_NAME(@"Share_white") forState:UIControlStateHighlighted];
    _rightBtn.frame = CGRectMake(0, 0, LineW(44), LineH(44));
    // 重点位置开始
    _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    _rightBtn.hidden = YES;
    
    
    [self getLoadData];
    
}

#pragma mark 获取数据
- (void)getLoadData {
    
    [[BaseService share] sendGetRequestWithPath:URL_GetReportsList token:YES viewController:self success:^(id responseObject) {
        
        NSArray *dataArr = responseObject[@"data"];
        
        [self showStatusView:[dataArr safe_objectAtIndex:0][@"htmlUrl"] method:ClassNormal];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果地址为空，则隐藏按钮，不为空，显示分享按钮
            if (IsStrEmpty([dataArr safe_objectAtIndex:0][@"htmlUrl"])) {
                
            }else {
                self.rightBtn.hidden = NO;
                self.shareUrlStr = [dataArr safe_objectAtIndex:0][@"htmlUrl"];
                self.nameStr = [dataArr safe_objectAtIndex:0][@"NameEn"];
            }
        });
    } failure:^(NSError *error) {
        
        //result返回1 为成功 2：即将上课 3：待测评 4 ：缺席 0 ：失败   UserInfo={msg=失败, result=0}
        //只分为两种，1是成功，2是剩下的全部状态都使用一种提醒。
        
        if ([error.userInfo[@"result"] isEqual:@0] || [error.userInfo[@"result"] isEqual:@2] || [error.userInfo[@"result"] isEqual:@3] || [error.userInfo[@"result"] isEqual:@4]){
            [self showStatusView:@"参与体验课，获得英语水平测评报告！" method:ClassNotStartStatus];
            
        }else {
            [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
            
        }
        
    }];
    
}



- (void)showStatusView:(NSString *)alertStr method:(NSInteger)method {
    switch (method) {
        case ClassNormal: {
            
            WKWebView *_webView = [[WKWebView alloc] init];
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:alertStr]]];
            _webView.scrollView.showsVerticalScrollIndicator = NO;
            _webView.scrollView.showsHorizontalScrollIndicator = NO;
            _webView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
            [self.view addSubview:_webView];
            
            [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(LineY(0));
                make.left.equalTo(self.view.mas_left).offset(LineX(0));
                make.right.equalTo(self.view.mas_right).offset(-LineX(0));
                make.bottom.equalTo(self.view.mas_bottom).offset(0);
            }];
        }
            break;
            
        case ClassOverAndNoTestReportStatus:  { //暂未使用
            
            self.mineClassPlaceholderView = [[GGT_MineClassPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, marginMineRight,  SCREEN_HEIGHT()-64) method:ClassOverAndNoTestReportStatus alertStr:alertStr];
            self.mineClassPlaceholderView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
            [self.view addSubview:_mineClassPlaceholderView];
            
        }
            
            break;
            
        case ClassNotStartStatus:  {
            
            self.mineClassPlaceholderView = [[GGT_MineClassPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, marginMineRight,  SCREEN_HEIGHT()-64) method:ClassNotStartStatus alertStr:alertStr];
            self.mineClassPlaceholderView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
            [self.view addSubview:_mineClassPlaceholderView];
            
        }
            
            break;
            
        default:
            break;
    }
}




#pragma mark 分享功能
- (void)rightAction {
    //这里会对未安装的app客户端进行隐藏，如果有就展示-----避免上线被拒。
    GGT_ShareAndFeedBackViewController *vc = [GGT_ShareAndFeedBackViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    vc.isShareController = YES;
    vc.testbuttonClickBlock = ^(UIButton *button) {
        
        //判断按钮
        if ([button.titleLabel.text isEqualToString:@"微信好友"]) {
            
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            
        } else if ([button.titleLabel.text isEqualToString:@"朋友圈"]) {
            
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            
        } else if ([button.titleLabel.text isEqualToString:@"QQ好友"]) {
            
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
            
        } else if ([button.titleLabel.text isEqualToString:@"QQ空间"]) {
            
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            
        } else if ([button.titleLabel.text isEqualToString:@"新浪微博"]) {
            
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
            
        }
        
        
        
    };
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.popoverPresentationController.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //title 和 webpageUrl不能为空
    NSString *desctStr = [NSString stringWithFormat:@"%@ 在GoGoTalk青少外教英语体验课中获得了一份英语水平测评报告！",self.nameStr];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"GoGoTalk英语水平测评报告" descr:desctStr thumImage:UIIMAGE_FROM_NAME(@"启动图标-分享")];
    
    //设置网页地址
    shareObject.webpageUrl = self.shareUrlStr;
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


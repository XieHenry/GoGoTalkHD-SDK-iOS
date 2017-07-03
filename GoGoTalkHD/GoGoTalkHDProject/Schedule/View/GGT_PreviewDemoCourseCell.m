//
//  GGT_PreviewDemoCourseCell.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/9.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PreviewDemoCourseCell.h"
#import "GGT_PreviewDemoPlaceholderView.h"
#import "GGT_ShareAndFeedBackViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface GGT_PreviewDemoCourseCell ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) GGT_PreviewDemoPlaceholderView *xc_placeholderView;
@end

@implementation GGT_PreviewDemoCourseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_PreviewDemoCourseCellID = NSStringFromClass([self class]);
    GGT_PreviewDemoCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_PreviewDemoCourseCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_PreviewDemoCourseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_PreviewDemoCourseCellID];
    }
    cell.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        
        [self configView];
        self.xc_height = 0;
    }
    return self;
}

- (void)configView
{
    // 测评报告
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
    self.xc_webView = [[WKWebView alloc] initWithFrame:self.bounds
                                            configuration:config];
    self.xc_webView.navigationDelegate = self;
    self.xc_webView.UIDelegate = self;
    self.xc_webView.scrollView.scrollEnabled = NO;
    self.xc_webView.scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:self.xc_webView];
    
    
    
    [self.xc_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-margin10);
        make.left.equalTo(self).offset(margin10);
        make.right.equalTo(self).offset(-margin10);
    }];
    
    // 无数据时候显示的view
    self.xc_placeholderView = ({
        GGT_PreviewDemoPlaceholderView *view = [[GGT_PreviewDemoPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        view;
    });
    [self addSubview:self.xc_placeholderView];
    
    [self.xc_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(margin10);
        make.right.equalTo(self).offset(-margin10);
    }];
    
    [self layoutIfNeeded];
}

- (void)drawRect:(CGRect)rect
{
    [self.xc_webView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:6.0];
}

- (void)setXc_reportModel:(GGT_EvaReportModel *)xc_reportModel
{
    _xc_reportModel = xc_reportModel;
    
    self.xc_placeholderView.hidden = YES;
    self.xc_webView.hidden = NO;
    
    [self loadHtml:xc_reportModel.htmlUrl inView:self.xc_webView];
}

- (void)setXc_resultModel:(GGT_ResultModel *)xc_resultModel
{
    _xc_resultModel = xc_resultModel;
    self.xc_placeholderView.xc_model = xc_resultModel;
    self.xc_webView.hidden = YES;
    self.xc_placeholderView.hidden = NO;
}

-(void)loadHtml:(NSString *)urlString inView:(WKWebView *)webView
{
    if (urlString.length > 0) {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

#pragma mark - WKWebView
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    [MBProgressHUD hideHUDForView:self.superview];
    [webView evaluateJavaScript:@"document.body.offsetHeight;"completionHandler:^(id _Nullable result,NSError *_Nullable error) {
        
        //获取页面高度，并重置webview的frame
        CGFloat height = [result doubleValue];
        if (self.xc_height == 0) {
            if ([self.delegate respondsToSelector:@selector(previewDemoCourseCellHeightWithHeight:)]) {
                [self.delegate previewDemoCourseCellHeightWithHeight:height];
                self.xc_height = height;
            }
        }
    }];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    [MBProgressHUD showLoading:self.superview];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
//    [MBProgressHUD hideHUDForView:self.superview];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AppModel"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSLog(@"%@", message.body);
        
        [self rightAction];
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
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    [[UMSocialManager defaultManager] openLog:YES];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString *desctStr = [NSString stringWithFormat:@"%@ 在GoGoTalk青少外教英语体验课中获得了一份英语水平测评报告！",self.xc_reportModel.NameEn];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"GoGoTalk英语水平测评报告" descr:desctStr thumImage:UIIMAGE_FROM_NAME(@"启动图标-分享")];
    //设置网页地址
    if ([self.xc_reportModel.htmlUrl isKindOfClass:[NSString class]] && self.xc_reportModel.htmlUrl.length > 0) {
        shareObject.webpageUrl = self.xc_reportModel.htmlUrl;
    } else {
        shareObject.webpageUrl = @"";
    }
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
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
        //        [self alertWithError:error];
    }];
}


@end

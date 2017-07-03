//
//  GGT_PreviewCoursewareCell.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/22.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PreviewCoursewareCell.h"
#import "XCStarView.h"


@interface GGT_PreviewCoursewareCell ()<WKNavigationDelegate>

@end

@implementation GGT_PreviewCoursewareCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_PreviewCoursewareCellID = NSStringFromClass([self class]);
    GGT_PreviewCoursewareCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_PreviewCoursewareCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_PreviewCoursewareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_PreviewCoursewareCellID];
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
    // 底部课件
    self.xc_webView = ({
        WKWebView *webView = [WKWebView new];
        webView.navigationDelegate = self;
        webView.scrollView.scrollEnabled = NO;
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView;
    });
    [self addSubview:self.xc_webView];
    
    [self.xc_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-margin10);
        make.left.equalTo(self).offset(margin10);
        make.right.equalTo(self).offset(-margin10);
    }];
    
    [self layoutIfNeeded];
    
    
}


- (void)drawRect:(CGRect)rect
{
    [self.xc_webView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:6.0];
}

- (void)setXc_model:(GGT_CourseCellModel *)xc_model
{
    _xc_model = xc_model;
    [self loadHtml:xc_model.FilePath inView:self.xc_webView];
}

-(void)loadHtml:(NSString *)urlString inView:(WKWebView *)webView
{
    if ([urlString isKindOfClass:[NSString class]] && urlString.length > 0) {
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
            if ([self.delegate respondsToSelector:@selector(previewCoursewareCellHeightWithHeight:)]) {
                [self.delegate previewCoursewareCellHeightWithHeight:height];
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








@end

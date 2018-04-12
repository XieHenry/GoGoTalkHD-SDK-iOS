//
//  GGT_PreCoursewareVC.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PreCoursewareVC.h"

#import "BaseNavigationController.h"
#import "GGT_EvaluationPopViewController.h"     // 测试
#import "GGT_CourseDetailCell.h"

#import "GGT_PreTeachEvaView.h"


@interface GGT_PreCoursewareVC ()<UIScrollViewDelegate, WKNavigationDelegate, UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UIScrollView *xc_scrollView;
@property (nonatomic, strong) UIView *xc_contentView;
@property (nonatomic, strong) GGT_CourseDetailCell *xc_topView;
@property (nonatomic, strong) GGT_PreTeachEvaView *xc_middleView;
@property (nonatomic, strong) WKWebView *xc_webView;

@property (nonatomic, strong) UIButton *xc_scrollTopButton;

@property (nonatomic) CGPoint tempContentOffset;

@property (nonatomic, strong) GGT_CourseCellModel *xc_course_model;

@end

@implementation GGT_PreCoursewareVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configView];
    
    [self configScrollTopButton];
    
    [self configData];
    
}

- (void)dealloc
{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        // Done
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tempContentOffset = self.xc_scrollView.contentOffset;
    self.xc_scrollView.contentOffset = CGPointZero;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.xc_scrollView.contentOffset = self.tempContentOffset;
}

- (void)configView
{
    self.title = @"课程详情";
    
    [self setLeftItem:@"fanhui_top" title:@"课表"];
    
    self.xc_scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.delegate = self;
        scrollView;
    });
    [self.view addSubview:self.xc_scrollView];
    
    self.xc_contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        view;
    });
    [self.xc_scrollView addSubview:self.xc_contentView];
    
    
    self.xc_topView = ({
        GGT_CourseDetailCell *view = [[GGT_CourseDetailCell alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 130)];
        view.xc_cellModel = self.xc_model;
        view;
    });
    [self.xc_contentView addSubview:self.xc_topView];
    
    self.xc_middleView = ({

        GGT_PreTeachEvaView *view = [[GGT_PreTeachEvaView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0) model:self.xc_model];
        view;
    });
    [self.xc_contentView addSubview:self.xc_middleView];
    
    self.xc_webView = ({
        WKWebView *webView = [WKWebView new];
        webView.backgroundColor = [UIColor whiteColor];
        webView.scrollView.delegate = self;
        webView.navigationDelegate = self;
        webView.scrollView.showsHorizontalScrollIndicator = NO;
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView;
    });
    [self.xc_contentView addSubview:self.xc_webView];

    
    [self.xc_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.xc_scrollView);
        make.width.equalTo(self.xc_scrollView);
    }];
    
    [self.xc_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(margin10));
        make.left.right.equalTo(self.xc_contentView);
        make.height.equalTo(@(130));
    }];

    [self.xc_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topView.mas_bottom);
        make.left.right.equalTo(self.xc_contentView);
        make.height.equalTo(@(self.xc_middleView.height));
    }];
    
    // 0 是未评价  1 是评价
    if (self.xc_model.IsComment == 1) {
        self.xc_middleView.hidden = NO;
        [self.xc_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.xc_middleView.mas_bottom).offset(margin10);
            make.left.equalTo(self.xc_contentView).offset(margin10);
            make.right.equalTo(self.xc_contentView).offset(-margin10);
            make.height.equalTo(@(self.view.height-64));
        }];
    } else {
        self.xc_middleView.hidden = YES;
        [self.xc_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.xc_topView.mas_bottom);
            make.left.equalTo(self.xc_contentView).offset(margin10);
            make.right.equalTo(self.xc_contentView).offset(-margin10);
            make.height.equalTo(@(self.view.height-64));
        }];
    }
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xc_webView.mas_bottom).offset(margin10);
    }];
    
    [self.view layoutIfNeeded];
    
    self.xc_webView.layer.masksToBounds = YES;
    self.xc_webView.layer.cornerRadius = 6.0f;
}

- (void)configData
{
    if ([self.xc_model.FilePath isKindOfClass:[NSString class]] && self.xc_model.FilePath.length > 0) {
        NSString *urlStr = [self.xc_model.FilePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.xc_webView loadRequest:request];
    }
    
    
    @weakify(self);
    [RACObserve(self.xc_scrollView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        
        float offsetY = self.xc_scrollView.contentOffset.y;
        if (offsetY <= self.xc_webView.top) {
            self.xc_scrollView.scrollEnabled = YES;
            self.xc_webView.scrollView.scrollEnabled = NO;
        }
        else {
            self.xc_scrollView.scrollEnabled = NO;
            self.xc_webView.scrollView.scrollEnabled = YES;
        }
    }];
    
    [RACObserve(self.xc_webView.scrollView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        
        float offsetY = self.xc_webView.scrollView.contentOffset.y;
        if (offsetY < 0) {
            self.xc_scrollView.scrollEnabled = YES;
            [self.xc_scrollView setContentOffset:CGPointMake(0, self.xc_webView.top + offsetY) animated:NO];
        }
        
        // 滚动超出一个平面后显示xc_scrollTopButton
        if (offsetY > self.xc_webView.height) {
            self.xc_scrollTopButton.hidden = NO;
        } else {
            self.xc_scrollTopButton.hidden = YES;
        }

    }];
    
    [self.xc_topView.xc_courseButton addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configScrollTopButton
{
    self.xc_scrollTopButton = ({
        UIButton *button = [UIButton new];
        UIImage *img = UIIMAGE_FROM_NAME(@"huidaodingbu");
        [button setImage:img forState:UIControlStateNormal];
        [button setImage:img forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        button.hidden = YES;
        button;
    });
    [self.view addSubview:self.xc_scrollTopButton];
    
    [self.xc_scrollTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-margin40);
        make.bottom.equalTo(self.view).offset(-120);
    }];
    
    @weakify(self);
    [[self.xc_scrollTopButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self);
        [self.xc_scrollView setContentOffset:CGPointZero animated:YES];
        [self.xc_webView.scrollView setContentOffset:CGPointZero animated:YES];
        
    }];
}


#pragma mark - ButtonAction
- (void)cellButtonAction:(UIButton *)button
{
    GGT_CourseCellModel *model = self.xc_model;
    
    self.xc_course_model = model;
    
    switch ([model.Status integerValue]) {
        case 0:     // 已经预约  // 点击按钮可以取消预约  // 需要刷新上一个控制器中cell
        {
            [self cancleReservationCourseWithModel:model];
        }
            break;
        case 1:     // 即将上课  // 进入预习界面
        {
            
            @weakify(self);
            [GGT_ClassroomManager chooseClassroomWithViewController:self courseModel:model leftRoomBlock:^{
                
                @strongify(self);
                // 网络请求 刷新数据
                [self refreshTableView];
                
            }];
            
        }
            break;
        case 2:     // 正在上课  // 进入教室
        {
            @weakify(self);
            [GGT_ClassroomManager chooseClassroomWithViewController:self courseModel:model leftRoomBlock:^{
                
                @strongify(self);
                // 网络请求 刷新数据
                [self refreshTableView];
                
            }];
            
            
        }
            break;
        case 3:     // 已经结束 待评价     // 需要刷新上一个控制器中cell
        {
            [self showEvaluationViewWithCellModel:model];
        }
            break;
        case 4:     // 已经结束 已评价
        {
            [self showEvaluationViewWithCellModel:model];
        }
            break;
        case 5:     // 已经结束 缺席
        {
            
        }
            break;
            
        default:
            break;
    }
}


// 取消预约
- (void)cancleReservationCourseWithModel:(GGT_CourseCellModel *)model
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?lessonid=%@", URL_GetCancelFormalLessonStatus, model.LessonId];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self cancelClassWithModel:model responseObject:responseObject];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

// 取消约课
- (void)cancelClassWithModel:(GGT_CourseCellModel *)model responseObject:(NSDictionary *)responseObject
{
    
    // 在可以取消约课的情况下 弹框
//    NSString *message1 = @"本月您已消耗完<span style='color:red;font-size=17px'>3次</span>机会，本次取消将扣除1课时";
    
    NSString *xc_alertMsg = @"";
    if ([responseObject[@"msg"] isKindOfClass:[NSString class]] && [responseObject[@"msg"] length] > 0) {
        xc_alertMsg = responseObject[@"msg"];
    }
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [xc_alertMsg dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attiSS = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
    // 在可以取消约课的情况下 弹框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:xc_alertMsg preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    
    [attiSS addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:ps} range:NSMakeRange(0, attiSS.length)];
    [alertController setValue:attiSS forKey:@"attributedMessage"];
    
    
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"暂不取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 网络请求
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"lessonId"] = model.LessonId;
        [[BaseService share] sendPostRequestWithPath:URL_DelLesson parameters:dic token:YES viewController:self success:^(id responseObject) {
            
            [MBProgressHUD showMessage:responseObject[xc_message] toView:self.view];
            
            // 取消成功后 更新界面 删除单个cell
            if (self.xc_deleteBlock) {
                self.xc_deleteBlock();
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        } failure:^(NSError *error) {
            
            //判断是否有网络，如果没网络，会显示为空
            GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
            
            if (sin.netStatus == YES) {
                if ([error.userInfo[xc_returnCode] integerValue] != 1) {
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:error.userInfo[xc_message] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertController addAction:action];
                    action.textColor = UICOLOR_FROM_HEX(kThemeColor);
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            } else {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:xc_alert_message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:0 handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:action];
                action.textColor = UICOLOR_FROM_HEX(kThemeColor);
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
            
        }];
    }];
    
    cancleAction.textColor = UICOLOR_FROM_HEX(Color777777);
    enterAction.textColor = UICOLOR_FROM_HEX(kThemeColor);
    [alertController addAction:cancleAction];
    [alertController addAction:enterAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 弹出评价的弹窗
- (void)showEvaluationViewWithCellModel:(GGT_CourseCellModel *)model
{
    GGT_EvaluationPopViewController *vc = [GGT_EvaluationPopViewController new];
    vc.xc_model = model;
    
    @weakify(self);
    vc.xc_reloadBlock = ^(GGT_CourseCellModel *model) {
        @strongify(self);
        
        // 需要回调 刷新上一个控制器的待评价的cell
        if (self.xc_changeStatusBlock) {
            self.xc_changeStatusBlock(model);
            // 刷新本界面的cell
            self.xc_topView.xc_cellModel = model;
            self.xc_model = model;
        }
        
    };
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.popoverPresentationController.delegate = self;
    //    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // 修改弹出视图的size 在控制器内部修改更好
    //    vc.preferredContentSize = CGSizeMake(100, 100);
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - UIPopoverPresentationControllerDelegate
//默认返回的是覆盖整个屏幕，需设置成UIModalPresentationNone。
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

//点击蒙版是否消失，默认为yes；
-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return NO;
}

//弹框消失时调用的方法
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    NSLog(@"弹框已经消失");
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [MBProgressHUD showLoading:self.view];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [MBProgressHUD hideHUDForView:self.view];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view];
}

// 退出教室 刷新数据
- (void)refreshTableView
{
    NSString *url = [NSString stringWithFormat:@"%@?lessonId=%@", URL_GetLessonByLessonId, self.xc_model.LessonId];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *data = responseObject[@"data"];
            if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
                self.xc_model = [GGT_CourseCellModel yy_modelWithDictionary:[data firstObject]];
            } else {
                
            }
            self.xc_topView.xc_cellModel = self.xc_model;
            
            // 需要回调 刷新上一个控制器的待评价的cell
            if (self.xc_changeStatusBlock) {
                self.xc_changeStatusBlock(self.xc_model);
            }
        }
        
    } failure:^(NSError *error) {
        
        NSDictionary *dic = error.userInfo;
        if ([dic[@"msg"] isKindOfClass:[NSString class]] && [dic[@"msg"] length] > 0) {
            [MBProgressHUD showMessage:dic[@"msg"] toView:self.view];
        }
        
    }];
}


@end

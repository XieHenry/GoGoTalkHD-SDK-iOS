//
//  GGT_PreviewDemoCourseVC.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/9.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PreviewDemoCourseVC.h"
#import "GGT_CourseDetailCell.h"
#import "GGT_PreviewDemoCourseCell.h"


@interface GGT_PreviewDemoCourseVC ()<UITableViewDelegate, UITableViewDataSource, GGT_PreviewDemoCourseCellDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *xc_tableView;
@property (nonatomic, assign) float webViewCellHeight;
@property (nonatomic, strong) WKWebView *xc_webView;
@property (nonatomic, strong) GGT_ResultModel *xc_resultModel;
@property (nonatomic, strong) GGT_EvaReportModel *xc_reportModel;
@property (nonatomic, strong) UIButton *xc_scrollTopButton;
@property (nonatomic, strong) GGT_CourseCellModel *xc_course_model;
@end

@implementation GGT_PreviewDemoCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 布局
    [self configView];
    
    // 监听
    [self rac_action];
    
    // 网络请求
    [self loadData];
    
    // 滚动到顶部按钮
    [self configScrollTopButton];
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
        [self.xc_tableView setContentOffset:CGPointZero animated:YES];
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f", self.xc_tableView.contentOffset.y);
    if (self.xc_tableView.contentOffset.y > 130) {
        self.xc_scrollTopButton.hidden = NO;
    } else {
        self.xc_scrollTopButton.hidden = YES;
    }
}

- (void)rac_action
{
    @weakify(self)
    [RACObserve(self, webViewCellHeight) subscribeNext:^(id x) {
        @strongify(self);
        // 必须执行一次 可以在代理中使用dispath once实现 但效果不是很好
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [self.xc_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    

    [RACObserve(self.xc_tableView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
        if ([self.xc_webView respondsToSelector:@selector(_updateVisibleContentRects)]) {
            ((void(*)(id,SEL,BOOL))objc_msgSend)(self.xc_webView,@selector(_updateVisibleContentRects),NO);
        }
#pragma clang diagnostic pop
    }];

}

- (void)configView
{
    
    self.title = @"课程详情";
    
    [self setLeftItem:@"fanhui_top" title:@"课表"];
    
    self.webViewCellHeight = 10;
    
    self.xc_tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = NO;
        tableView;
    });
    [self.view addSubview:self.xc_tableView];
    
    [self.xc_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(margin10);
    }];
    
    [self.xc_tableView registerClass:[GGT_CourseDetailCell class] forCellReuseIdentifier:NSStringFromClass([GGT_CourseDetailCell class])];
    [self.xc_tableView registerClass:[GGT_PreviewDemoCourseCell class] forCellReuseIdentifier:NSStringFromClass([GGT_PreviewDemoCourseCell class])];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.xc_tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
}

- (void)loadData
{
    [[BaseService share] sendGetRequestWithPath:URL_GetReportsList token:YES viewController:self success:^(id responseObject) {
        
        // 加载网页
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *data = responseObject[@"data"];
        
            if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
                
                self.xc_reportModel = [GGT_EvaReportModel yy_modelWithDictionary:data.firstObject];
                
            } else {
                self.xc_reportModel = nil;
            }
        }
        
        [self.xc_tableView reloadData];
        
    } failure:^(NSError *error) {
        NSDictionary *dic = error.userInfo;
        GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:dic];
        self.xc_resultModel = model;
        [self.xc_tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        GGT_CourseDetailCell *cell = [GGT_CourseDetailCell cellWithTableView:tableView forIndexPath:indexPath];
        cell.xc_cellModel = self.xc_model;
        [cell.xc_courseButton addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        GGT_PreviewDemoCourseCell *cell = [GGT_PreviewDemoCourseCell cellWithTableView:tableView forIndexPath:indexPath];
        cell.delegate = self;
        if (self.xc_reportModel) {
            cell.xc_reportModel = self.xc_reportModel;
        }
        if (self.xc_resultModel) {
            cell.xc_resultModel = self.xc_resultModel;
        }
        self.xc_webView = cell.xc_webView;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    } else {
        
        // 增加判断  测评报告没有出来  高度固定  测评报告未出来  高度不固定
        if (self.xc_reportModel) {
            return self.webViewCellHeight;
        } else {
            return SCREEN_HEIGHT() - 64 - 130;
        }
    }
}

#pragma mark - GGT_PreviewDemoCourseCellDelegate
- (void)previewDemoCourseCellHeightWithHeight:(CGFloat)height
{
    self.webViewCellHeight = height;
}

#pragma mark - ButtonAction
- (void)cellButtonAction:(UIButton *)button
{
    GGT_CourseCellModel *model = self.xc_model;
    
    self.xc_course_model = model;
    
    switch ([model.Status integerValue]) {
        case 0:     // 已经预约  // 点击按钮可以取消预约  // 需要刷新上一个控制器中cell
        {

        }
            break;
        case 1:     // 即将上课  // 进入预习界面
        {

            @weakify(self);
            [GGT_ClassroomManager chooseClassroomWithViewController:self courseModel:model leftRoomBlock:^{
                @strongify(self);
                // 网络请求 刷新数据
                [self refreshTableView];
                [self loadData];
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
                [self loadData];
            }];
            
        }
            break;
        case 3:     // 已经结束 待评价     // 需要刷新上一个控制器中cell
        {

        }
            break;
        case 4:     // 已经结束 已评价
        {

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

// 进入教室调用接口
- (void)postNetworkModifyLessonStatusWithCourseModel:(GGT_CourseCellModel *)model
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"LessonId"] = model.LessonId;
    
    NSString *url = [NSString stringWithFormat:@"%@?LessonId=%@", URL_ModifyLessonStatus, model.LessonId];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
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
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            GGT_CourseDetailCell *cell = [self.xc_tableView cellForRowAtIndexPath:indexPath];
            cell.xc_cellModel = self.xc_model;
            
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

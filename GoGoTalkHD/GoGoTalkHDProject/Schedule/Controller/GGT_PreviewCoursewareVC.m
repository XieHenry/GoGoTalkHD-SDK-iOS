//
//  GGT_PreviewCoursewareVC.m
//  GoGoTalk
//
//  Created by 辰 on 2017/5/5.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_PreviewCoursewareVC.h"

#import "GGT_PreviewCourseAlertView.h"

#import "BaseNavigationController.h"
#import "GGT_EvaluationPopViewController.h"     // 测试

#import "GGT_CourseDetailCell.h"
#import "GGT_PreviewCoursewareCell.h"

#import "GGT_PreviewTeachEvaCell.h"


@interface GGT_PreviewCoursewareVC ()<UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, GGT_PreviewCoursewareCellDelegate, GGT_PreviewTeachEvaCellDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *xc_tableView;

@property (nonatomic, assign) float secCellHeight;
@property (nonatomic, assign) float webViewCellHeight;

@property (nonatomic, strong) WKWebView *xc_webView;

@property (nonatomic, strong) UIButton *xc_scrollTopButton;

@end

@implementation GGT_PreviewCoursewareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
    
    [self rac_action];
    
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
    @weakify(self);
    [RACObserve(self, secCellHeight) subscribeNext:^(id x) {
        @strongify(self);
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [self.xc_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [RACObserve(self, webViewCellHeight) subscribeNext:^(id x) {
        @strongify(self)
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
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
    
    self.webViewCellHeight = 10;
    self.secCellHeight = 0;
    
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
    [self.xc_tableView registerClass:[GGT_PreviewCoursewareCell class] forCellReuseIdentifier:NSStringFromClass([GGT_PreviewCoursewareCell class])];
    [self.xc_tableView registerClass:[GGT_PreviewTeachEvaCell class] forCellReuseIdentifier:NSStringFromClass([GGT_PreviewTeachEvaCell class])];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.xc_tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        GGT_CourseDetailCell *cell = [GGT_CourseDetailCell cellWithTableView:tableView forIndexPath:indexPath];
        cell.xc_cellModel = self.xc_model;
        [cell.xc_courseButton addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else if (indexPath.row == 1) {
        
        GGT_PreviewTeachEvaCell *cell = [GGT_PreviewTeachEvaCell cellWithTableView:tableView forIndexPath:indexPath];
        cell.xc_model = self.xc_model;
        cell.delegate = self;
        if (self.xc_model.IsComment == 1) { // 0 是未评价  1 是评价
            cell.hidden = NO;
        } else {
            cell.hidden = YES;
        }
        
        return cell;
        
    } else {
        GGT_PreviewCoursewareCell *cell = [GGT_PreviewCoursewareCell cellWithTableView:tableView forIndexPath:indexPath];
        cell.delegate = self;
        cell.xc_model = self.xc_model;
        self.xc_webView = cell.xc_webView;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    } else if (indexPath.row == 1) {
        
        if (self.xc_model.IsComment == 1) { // 0 是未评价  1 是评价
            return self.secCellHeight;
        } else {
            return 0;
        }
        
    } else {
        return self.webViewCellHeight;
    }
}

#pragma mark - ButtonAction
- (void)cellButtonAction:(UIButton *)button
{
    GGT_CourseCellModel *model = self.xc_model;
//    NSIndexPath *indexPath = self.xc_indexPath;
    
    switch ([model.Status integerValue]) {
        case 0:     // 已经预约  // 点击按钮可以取消预约  // 需要刷新上一个控制器中cell
        {
            [self cancleReservationCourseWithModel:model];
        }
            break;
        case 1:     // 即将上课  // 进入预习界面
        {
            
        }
            break;
        case 2:     // 正在上课  // 进入教室
        {
            
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
    // 在可以取消约课的情况下 弹框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消本次预约课程" preferredStyle:UIAlertControllerStyleAlert];
    
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
            if ([error.userInfo[xc_returnCode] integerValue] != 1) {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:error.userInfo[xc_message] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
                    
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
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            GGT_CourseDetailCell *cell = [self.xc_tableView cellForRowAtIndexPath:indexPath];
            cell.xc_cellModel = model;
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

#pragma mark - GGT-PreviewTeachEvaCellDelegate
- (void)previewTeachEvaCellHeightWithHeight:(CGFloat)height
{
    self.secCellHeight = height;
}

#pragma mark - GGT-PreviewCoursewareCellDelegate
- (void)previewCoursewareCellHeightWithHeight:(CGFloat)height
{
    self.webViewCellHeight = height;
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



@end

//
//  GGT_EvaluationPopViewController.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/18.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_EvaluationPopViewController.h"
#import "GGT_EvaluateView.h"
#import "PlaceholderTextView.h"

static NSString * const titleString = @"课后评价";
static NSString * const evaluatForTeach = @"对老师的满意度";
static NSString * const evaluatForClass = @"这节课的学习效果";
static NSString * const textViewPlaceholdString = @"请输入您对本节课程和外教老师的评价（200字以内）";

@interface GGT_EvaluationPopViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIButton *xc_leftItem;
@property (nonatomic, strong) UIButton *xc_rightItem;
@property (nonatomic, strong) GGT_EvaluateView *xc_evaTeachView;
@property (nonatomic, strong) GGT_EvaluateView *xc_evaCourseView;
@property (nonatomic, strong) PlaceholderTextView *xc_textView;

@end

@implementation GGT_EvaluationPopViewController

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController && self.xc_textView != nil) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 462;
        tempSize.height = 368;
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
    
    self.title = titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(16),NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil]];
    
    [self initView];
    
    if ([self.xc_model.Status isEqualToString:@"3"]) {      // @"3" 是待评价
        [self initNavBarItem];
    } else {        // @"4" 是已评价
        [self initNavBarItemClose];
    }

}


- (void)initNavBarItemClose
{
    self.xc_rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xc_rightItem setTitle:@"关闭" forState:UIControlStateNormal];
    self.xc_rightItem.titleLabel.font = Font(14);
    [self.xc_rightItem sizeToFit];
    [self.xc_rightItem setTitleColor:UICOLOR_FROM_HEX(kThemeColor) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.xc_rightItem];
    
    @weakify(self);
    [[self.xc_rightItem rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"点击了关闭");
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    self.xc_textView.userInteractionEnabled = NO;
    self.xc_evaTeachView.userInteractionEnabled = NO;
    self.xc_evaCourseView.userInteractionEnabled = NO;
    
    if ([self.xc_model.StuRemark isKindOfClass:[NSString class]] && self.xc_model.StuRemark.length > 0) {
        self.xc_textView.text = self.xc_model.StuRemark;
    } else {
        self.xc_textView.text = @" ";
    }
    
    self.xc_evaTeachView.xc_starView.selectedStatCount = self.xc_model.StuLikeTchStar;
    self.xc_evaCourseView.xc_starView.selectedStatCount = self.xc_model.SturememberStar;
}


- (void)initView
{
    NSArray *evaTeach = @[@"没感觉", @"和老师交流很愉快", @"和老师互动非常开心"];
    NSArray *evaCourse = @[@"完全不记得", @"记得一部分", @"基本都记下了"];
    
    
    self.xc_evaTeachView = [[GGT_EvaluateView alloc] initWithTitle:evaluatForTeach evaluateArray:evaTeach selectCount:evaTeach.count];
    [self.view addSubview:self.xc_evaTeachView];
    [self.xc_evaTeachView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(margin20);
        make.right.equalTo(self.view).offset(-margin20);
        make.top.equalTo(self.view).offset(margin20);
        // 内部子控件已经使用过LineH() 则外部就不再需要使用
        make.height.equalTo(@(self.xc_evaTeachView.height));
    }];
    
    
    
    self.xc_evaCourseView = [[GGT_EvaluateView alloc] initWithTitle:evaluatForClass evaluateArray:evaCourse selectCount:evaCourse.count];
    [self.view addSubview:self.xc_evaCourseView];
    [self.xc_evaCourseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.xc_evaTeachView);
        make.top.equalTo(self.xc_evaTeachView.mas_bottom).offset(margin20);
    }];
    
    // xc_textView
    self.xc_textView = ({
        PlaceholderTextView *xc_textView = [PlaceholderTextView new];
        xc_textView.placeholder = textViewPlaceholdString;
        xc_textView.placeholderColor = UICOLOR_FROM_HEX(Color777777);
        xc_textView.placeHolderLabel.font = Font(14);
        xc_textView.marginSize = CGSizeMake(LineX(12), LineY(12));
        xc_textView.marginSize = CGSizeMake(5, 5);
        xc_textView.delegate = self;
        xc_textView;
    });
    [self.view addSubview:self.xc_textView];
    [self.xc_textView addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(ColorD8D8D8) CornerRadius:6.0f];
    
    [self.xc_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_evaCourseView);
        make.right.equalTo(self.xc_evaCourseView);
        make.top.equalTo(self.xc_evaCourseView.mas_bottom).offset(margin20);
        make.bottom.equalTo(@(-margin20));
    }];
    
    [self.view layoutIfNeeded];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=200)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}

- (void)initNavBarItem
{
    self.xc_leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xc_leftItem setTitle:@"取消" forState:UIControlStateNormal];
    self.xc_leftItem.titleLabel.font = Font(14);
    [self.xc_leftItem sizeToFit];
    [self.xc_leftItem setTitleColor:UICOLOR_FROM_HEX(Color666666) forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.xc_leftItem];
    
    self.xc_rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.xc_rightItem setTitle:@"保存" forState:UIControlStateNormal];
    self.xc_rightItem.titleLabel.font = Font(14);
    [self.xc_rightItem sizeToFit];
    [self.xc_rightItem setTitleColor:UICOLOR_FROM_HEX(kThemeColor) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.xc_rightItem];
    
    @weakify(self);
    [[self.xc_leftItem rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"点击了取消");
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    [[self.xc_rightItem rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"点击了保存");
         
         // 网络请求
         [self evaTeach];

     }];
}

- (void)evaTeach
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"lessonId"] = self.xc_model.LessonId;
    dic[@"remark"] = self.xc_textView.text;
    dic[@"likeTchStar"] = [NSString stringWithFormat:@"%ld", (long)self.xc_evaTeachView.selectCount];
    dic[@"rememberStar"] = [NSString stringWithFormat:@"%ld", (long)self.xc_evaCourseView.selectCount];
    [[BaseService share] sendPostRequestWithPath:URL_AppStudentEvaluateTeacher parameters:dic token:YES viewController:self success:^(id responseObject) {
        
        [MBProgressHUD showMessage:responseObject[xc_message] toView:self.view];
        
        
        NSMutableArray *muArray = [NSMutableArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *data = responseObject[@"data"];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_CourseCellModel *model = [GGT_CourseCellModel yy_modelWithDictionary:obj];
                [muArray addObject:model];
            }];
            
        }
        
        // 刷新上一个界面的cell
        if (self.xc_reloadBlock) {
            if (muArray.count > 0) {
               self.xc_reloadBlock(muArray[0]);
            } else {
                self.xc_reloadBlock(self.xc_model);
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[xc_message] toView:self.view];
        
        // 刷新上一个界面的cell
        if (self.xc_reloadBlock) {
            self.xc_reloadBlock(self.xc_model);
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
    }];
}



@end

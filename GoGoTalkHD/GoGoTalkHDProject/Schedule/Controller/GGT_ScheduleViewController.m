//
//  GGT_ScheduleViewController.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/18.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ScheduleViewController.h"
#import <FSCalendar/FSCalendar.h>
#import "GGT_CalendarCell.h"
#import "GGT_ScheduleStudyingCell.h"
#import "OYCountDownManager.h"
#import "GGT_EvaluationPopViewController.h"

#import "GGT_PlaceHolderView.h"

#import "GGT_PreviewDemoCourseVC.h"
//#import "GGT_PreviewCoursewareVC.h"

#import "GGT_PreCoursewareVC.h"

#import "MZTimerLabel.h"

#import "TKEduClassRoom.h"      // 测试拓课
#import "TKMacro.h"

static NSString * const CalendarCellID = @"cell";

@interface GGT_ScheduleViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate, MZTimerLabelDelegate, TKEduEnterClassRoomDelegate>
{
    void * _KVOContext;
}
@property (weak, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSArray *datesWithEvent;
@property (strong, nonatomic) NSDateFormatter *xc_dateFormatter;
@property (strong, nonatomic) NSDateFormatter *xc_dateFormatter2;
@property (strong, nonatomic) UIButton *xc_titleButton;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
@property (strong, nonatomic) UIView *xc_lineView;


@property (strong, nonatomic) UITableView *xc_tableView;
@property (strong, nonatomic) GGT_PlaceHolderView *xc_placeholderView;


@property (strong, nonatomic) NSMutableArray *xc_calendarEventsMuArray;
@property (strong, nonatomic) NSMutableDictionary *xc_calendarEventsMuDic;

@property (strong, nonatomic) NSMutableArray *xc_courseMuArray;

@property (nonatomic, strong) NSString *stime;      //时间 选中时间

@property (nonatomic, strong) NSDate *xc_selectedDate;

@property (nonatomic, strong) NSTimer *xc_timer;    // 用于每隔5分钟发送一次网络请求 刷新数据
@property (nonatomic, strong) NSTimer *xc_CountDownTimer;

@property (nonatomic, strong) MZTimerLabel *xc_mzTimer;

@property (nonatomic, strong) GGT_CourseCellModel *xc_recentCourseModel;

@end

@implementation GGT_ScheduleViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.title = @"FSCalendar";
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        self.xc_dateFormatter = [[NSDateFormatter alloc] init];
        self.xc_dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        self.xc_dateFormatter2 = [[NSDateFormatter alloc] init];
        self.xc_dateFormatter2.dateFormat = @"yyyy年MM月";
        
        self.xc_selectedDate = [NSDate date];
    }
    return self;
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

// 加载view
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
    
    self.view = view;
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height-64)];
    
    calendar.dataSource = self;
    calendar.delegate = self;
    
    
    
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    
    calendar.appearance.weekdayTextColor = UICOLOR_FROM_HEX(Color2C2C2C);
    
    calendar.appearance.titleTodayColor = UICOLOR_FROM_HEX(kThemeColor);
    
    
    calendar.appearance.subtitleDefaultColor = [UIColor blackColor];
    calendar.appearance.subtitleSelectionColor = [UIColor blackColor];
    calendar.appearance.subtitleTodayColor = [UIColor blackColor];
    
    
    calendar.appearance.titlePlaceholderColor = UICOLOR_FROM_HEX(kCalendar_PlaceHolderColor);
    calendar.appearance.subtitlePlaceholderColor = UICOLOR_FROM_HEX(kCalendar_PlaceHolderColor);
    
    calendar.appearance.titleFont = Font(16);
    calendar.appearance.subtitleFont = Font(14);
    calendar.appearance.weekdayFont = Font(16);
    
    calendar.appearance.subtitleOffset = CGPointMake(0, LineH(10));
    
    calendar.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    // 隐藏顶部时间
    calendar.headerHeight = 0;
    calendar.weekdayHeight = LineH(44);
    
    [calendar xc_SetCornerWithSideType:XCSideTypeBottomLine cornerRadius:5.0f];
    
    // cell下面的横线
    //    calendar.appearance.separators = FSCalendarSeparatorInterRows;
    
    //    calendar.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:calendar];
    
    [calendar registerClass:[GGT_CalendarCell class] forCellReuseIdentifier:CalendarCellID];
    
    self.calendar = calendar;
    
    self.xc_lineView = ({
        UIView *xc_lineView =[UIView new];
        xc_lineView.backgroundColor = [UIColor lightGrayColor];
        xc_lineView;
    });
    [calendar.calendarWeekdayView addSubview:self.xc_lineView];
    [self.xc_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(calendar.calendarWeekdayView);
        make.height.equalTo(@0.5);
    }];
    self.xc_lineView.hidden = YES;
    
    // 更新数据源 刷新calendar
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 更新数据
////        self.datesWithEvent = @[@"2017/05/03",
////                                @"2017/05/04",
////                                @"2017/05/06",
////                                @"2017/05/12",
////                                @"2017/05/25",
////                                @"2017/06/01"];
////        [self.calendar reloadData];
//        
//    });
    
    [self.calendar.calendarWeekdayView.weekdayLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textAlignment = NSTextAlignmentCenter;
        obj.frame = CGRectMake(obj.x+20, obj.y, obj.width-20, obj.height);
    }];
    
    // 定义titleView
    [self initTitleView];
    
    self.calendar.scope = FSCalendarScopeWeek;
    self.xc_titleButton.selected = YES;
}


// 初始化titleView
- (void)initTitleView
{
    UIButton *xc_titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *titleString = [self.xc_dateFormatter2 stringFromDate:[NSDate date]];
    [xc_titleButton setTitle:titleString forState:UIControlStateNormal];
    //    [xc_titleButton setFrame:CGRectMake(0, 0, 200, 30)];
    [xc_titleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [xc_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xc_titleButton setTintColor:[UIColor whiteColor]];
    
    UIImage *image = UIIMAGE_FROM_NAME(@"shangla");
    [xc_titleButton setImage:image forState:UIControlStateNormal];
    [xc_titleButton setImage:UIIMAGE_FROM_NAME(@"xiala") forState:UIControlStateSelected];
    
    [xc_titleButton.titleLabel sizeToFit];
    [xc_titleButton sizeToFit];
    
    // 设置button的insets
    [xc_titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [xc_titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, xc_titleButton.titleLabel.bounds.size.width + margin5, 0, -xc_titleButton.titleLabel.bounds.size.width - margin5)];
    [xc_titleButton setFrame:CGRectMake(0, 0, 200, 30)];
    
    
    
    self.xc_titleButton = xc_titleButton;
    self.navigationItem.titleView = xc_titleButton;
    
    __block BOOL flag = YES;
    
    @weakify(self);
    [[xc_titleButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         
         xc_titleButton.selected = !xc_titleButton.isSelected;
         
         // 要刷新界面
         if (self.calendar.scope == FSCalendarScopeMonth) {
             [self.calendar setScope:FSCalendarScopeWeek animated:YES];
         } else {
             [self.calendar setScope:FSCalendarScopeMonth animated:YES];
         }
         
         if (flag) {
             [UIView animateWithDuration:0.3f animations:^{
                 //                 self.xc_titleButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
             } completion:^(BOOL finished) {
                 flag = NO;
             }];
         }
         else {
             [UIView animateWithDuration:0.3f animations:^{
                 //                 self.xc_titleButton.imageView.transform = CGAffineTransformMakeRotation(0);
             } completion:^(BOOL finished) {
                 flag = YES;
             }];
         }
         
         // 当点击xc_titleButton的时候需要将xc_tableView滚动到顶部
         [self.xc_tableView setContentOffset:CGPointZero animated:YES];
         
     }];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    
    NSDate *date = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:0];
    return [self getFirstAndLastDayOfThisMonthWithDate:date][1];
}

// 获取月份的第一天和最后一天日期
- (NSArray *)getFirstAndLastDayOfThisMonthWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *firstDay;
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDay interval:nil forDate:date];
    NSDateComponents *lastDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitDay fromDate:firstDay];
    NSUInteger dayNumberOfMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSInteger day = [lastDateComponents day];
    [lastDateComponents setDay:day+dayNumberOfMonth-1];
    NSDate *lastDay = [calendar dateFromComponents:lastDateComponents];
    return [NSArray arrayWithObjects:firstDay,lastDay, nil];
}



// 设置calendar的subtitle上面的文字
// 优先级大于在自定义cell中设置的优先级
- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSString *dateString = [self.xc_dateFormatter stringFromDate:date];
    if ([self.xc_calendarEventsMuArray containsObject:dateString]) {
        
        NSArray *ListTimes = self.xc_calendarEventsMuDic[dateString];
        __block NSString *string = @"";
        [ListTimes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@",%@", obj[@"HourMinute"]]];
        }];
        return string;
    } else {
        return @"";
    }
}

// 设置日期的显示方式 今日显示“今”
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今";
    }
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    if (self.calendar.scope == FSCalendarScopeWeek) {
        [dateFormat setDateFormat:@"dd"];//设定时间格式,这里可以设置成自己需要的格式
    } else {
        [dateFormat setDateFormat:@"dd"];//设定时间格式,这里可以设置成自己需要的格式
    }
    return [dateFormat stringFromDate:date];
    
}

// 自定义cell
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    GGT_CalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:CalendarCellID forDate:date atMonthPosition:monthPosition];
    cell.isSmall = self.xc_titleButton.isSelected;
    cell.date = date;
    
    if ([self.gregorian isDateInToday:date]) {
        cell.dateType = DateTypeToday;
    } else {
        cell.dateType = DateTypeOther;
    }
    
    return cell;
}

// 设置选中日期的选中颜色  圆的颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
{
    //    if ([self.gregorian isDateInToday:date]) {
    //        return [UIColor whiteColor];
    //    }
    return UICOLOR_FROM_HEX(kThemeColor);
}

// 设置今日的选中颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    //    if ([self.gregorian isDateInToday:date]) {
    //        return [UIColor blueColor];
    //    }
    return [UIColor whiteColor];
}

// 点击cell的事件
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.xc_dateFormatter stringFromDate:date]);
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[self.xc_dateFormatter stringFromDate:obj]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    
    // 更新xc_titleButton上面的文字
    [self.xc_titleButton setTitle:[self.xc_dateFormatter2 stringFromDate:date] forState:UIControlStateNormal];
    
    
    // 进行网络请求
    self.xc_selectedDate = date;
    [self loadCourseDataWithStime:self.xc_selectedDate showMBP:YES];
    [self loadCalendarDataWithDate:self.xc_selectedDate showMBP:YES];
    
    
    // 当日历全屏展示的时候  点击日期  日历也要收回
    if (calendar.scope == FSCalendarScopeMonth) {
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
        self.xc_titleButton.selected = YES;
    }
    
}

// 日历左右翻动 调用
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    [self.xc_titleButton setTitle:[self.xc_dateFormatter2 stringFromDate:calendar.currentPage] forState:UIControlStateNormal];
    
    // 翻页请求数据
    [self loadCalendarDataWithDate:calendar.currentPage showMBP:YES];
    
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    NSLog(@"%@",(calendar.scope==FSCalendarScopeWeek?@"week":@"month"));
    
    if (calendar.scope == FSCalendarScopeWeek) {
        self.calendar.frame = CGRectMake(0, -LineH(44), self.view.width, CGRectGetHeight(bounds));
        self.xc_lineView.hidden = YES;
        calendar.weekdayHeight = LineH(44);
        
    } else {
        self.calendar.frame = CGRectMake(0, 0, self.view.width, CGRectGetHeight(bounds));
        self.xc_lineView.hidden = YES;
        calendar.weekdayHeight = LineH(44);
        calendar.appearance.titleOffset = CGPointMake(0, 0);
        
    }
    
#pragma mark - 调整xc_placeholderView的frame 不然会出问题
    self.xc_placeholderView.frame = CGRectMake(0, 0, self.calendar.width, self.view.height - self.calendar.height);
    [self.view layoutIfNeeded];
}

- (void)dealloc
{
    [self.calendar removeObserver:self forKeyPath:@"scope" context:_KVOContext];
    
    if ([self.xc_timer isValid]) {
        [self.xc_timer invalidate];
        self.xc_timer = nil;
    }
    
    if ([self.xc_CountDownTimer isValid]) {
        [self.xc_CountDownTimer invalidate];
        self.xc_CountDownTimer = nil;
    }
    
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
        
        // 当scope状态更改后 需要刷新界面 否则subtitle可能不会显示出来
        // 若刷新后 又会出现闪烁的现象
        //        [self.calendar reloadData];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>
// Whether scope gesture should begin
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = self.xc_tableView.contentOffset.y <= -self.xc_tableView.contentInset.top;
    if (self.calendar.scope == FSCalendarScopeWeek) {
        return NO;
    }
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:
            {
                return velocity.y < 0;
            }
            case FSCalendarScopeWeek:
            {
                if (velocity.y > 0) {
                    [self.calendar setScope:FSCalendarScopeMonth animated:YES];
                }
                return velocity.y > 0;
            }
        }
    }
    return shouldBegin;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    // 不加手势
    //    self.scopeGesture = panGesture;
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.xc_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.calendar.width, SCREEN_HEIGHT()-64) style:UITableViewStylePlain];
    self.xc_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.xc_tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.xc_tableView.delegate = self;
    self.xc_tableView.dataSource = self;
    [self.view addSubview:self.xc_tableView];
    [self.xc_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendar.mas_bottom).offset(margin5);
        make.right.left.bottom.equalTo(self.view);
    }];

#pragma mark - 添加xc_placeholderView
    self.xc_placeholderView = [[GGT_PlaceHolderView alloc] initWithFrame:CGRectMake(0, 0, self.xc_tableView.width, self.xc_tableView.height)];
    self.xc_tableView.enablePlaceHolderView = YES;
    self.xc_tableView.xc_PlaceHolderView = self.xc_placeholderView;


    
    // While the scope gesture begin, the pan gesture of tableView should cancel.
    [self.xc_tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    
    // 配置tableView
    [self configTableView];
    
    // 启动倒计时管理
//    [kCountDownManager start];
    
    // 初始化数据
    [self initData];
    
    // 请求日历上面的数据
    [self loadCalendarDataWithDate:self.xc_selectedDate showMBP:YES];

    // 请求日历下面的数据
    [self loadCourseDataWithStime:self.xc_selectedDate showMBP:YES];
    
    
    // 添加右侧item
    [self addRightBarButtonItem];
    
    
    // 添加一个定时器 每隔5分钟请求一次接口 刷新界面
    [self sendNetEvery5Min];
    
    // 请求最近一次上课时间
    [self getRecentCourse];
    
    // 用户是否进入教室的标识
    GGT_Singleton *single = [GGT_Singleton sharedSingleton];
    single.isInRoom = NO;
    
}

- (void)addRightBarButtonItem
{
    UIButton *xc_todayItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xc_todayItemButton setTitle:@"今日" forState:UIControlStateNormal];
    [xc_todayItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xc_todayItemButton sizeToFit];
    
    UIBarButtonItem *xc_rightItem = [[UIBarButtonItem alloc] initWithCustomView:xc_todayItemButton];
    self.navigationItem.rightBarButtonItem = xc_rightItem;
    
    @weakify(self)
    [[xc_todayItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.calendar setCurrentPage:[NSDate date] animated:YES];
        [self.calendar selectDate:[NSDate date] scrollToDate:YES];
        
        self.calendar.scope = FSCalendarScopeWeek;
        self.xc_titleButton.selected = YES;
        
        // 还需要网络请求
        self.xc_selectedDate = [NSDate date];
        [self loadCalendarDataWithDate:self.xc_selectedDate showMBP:YES];
        [self loadCourseDataWithStime:self.xc_selectedDate showMBP:YES];
        
    }];

}

#pragma mark - 刷新数据
- (void)reloadData {
    // 网络加载数据
    
    // 调用[kCountDownManager reload]
    [kCountDownManager reload];
    // 刷新
    [self.xc_tableView reloadData];
}

- (void)initData
{
    // 存放课程的可变数组
    self.xc_courseMuArray = [NSMutableArray array];
}

// 配置tableView
- (void)configTableView
{
    [self.xc_tableView registerClass:[GGT_ScheduleStudyingCell class] forCellReuseIdentifier:NSStringFromClass([GGT_ScheduleStudyingCell class])];
    
    
    __unsafe_unretained UITableView *tableView = self.xc_tableView;
    // 下拉刷新
    @weakify(self);
    tableView.mj_header = [XCNormalHeader headerWithRefreshingBlock:^{
        
//        self.xc_tableView.xc_refreshType = XCRefreshHeader;
        
        @strongify(self);
        [self loadCourseDataWithStime:self.xc_selectedDate showMBP:YES];
        [self loadCalendarDataWithDate:self.xc_selectedDate showMBP:YES];
    
        [tableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    tableView.mj_footer = [XCNormalFooter footerWithRefreshingBlock:^{

        @strongify(self);
        [self loadCourseDataWithStime:self.xc_selectedDate showMBP:YES];
        [self loadCalendarDataWithDate:self.xc_selectedDate showMBP:YES];
        
        [tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.xc_courseMuArray.count > 0) {
        // 启动倒计时管理
        [kCountDownManager start];
    } else {
        // 关闭倒计时管理
        [kCountDownManager invalidate];
    }
    return self.xc_courseMuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSDictionary *tDict = @{
//                            @"serial"   :@"755158726",
//                            @"host"    :@"global.talk-cloud.com",
//                            // @"userid"  : @"1111",
//                            @"port"    :@"443",
//                            @"nickname":@"test-6",    // 学生密码567
//                            @"userrole":@"2"    //用户身份，0：老师；1：助教；2：学生；3：旁听；4：隐身用户
//                            };
//    TKEduClassRoom *shareRoom = [TKEduClassRoom shareTKEduClassRoomInstance];
//    shareRoom.xc_roomPassword = @"567";
//    shareRoom.xc_roomName = @"test-6";
//    [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:self Delegate:self];
//    // 记录日志
//    [XCLogManager xc_redirectNSlogToDocumentFolder];
//    return;
    
    
    GGT_ScheduleStudyingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    if (sin.isAuditStatus) {
        // 增加判断  （0：已经预约 1：即将上课 2：正在上课 3：已经结束 待评价 4：已经结束 已评价 5：已经结束 缺席）
        if ([cell.xc_cellModel.Status integerValue] == 0 || [cell.xc_cellModel.Status integerValue] == 1) {
            LOSAlert(@"上课时间未到，请耐心等待！");
        } else {
            [self getLessonWithCourseModel:cell.xc_cellModel tableView:tableView indexPath:indexPath];
        }
    } else {
        [self getLessonWithCourseModel:cell.xc_cellModel tableView:tableView indexPath:indexPath];
    }
    
}

- (void)getLessonWithCourseModel:(GGT_CourseCellModel *)courseModel tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *url = [NSString stringWithFormat:@"%@?lessonId=%@", URL_GetLessonByLessonId, courseModel.LessonId];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *data = responseObject[@"data"];
            GGT_CourseCellModel *model = nil;
            if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
                model = [GGT_CourseCellModel yy_modelWithDictionary:[data firstObject]];
            } else {
                model = courseModel;
            }
            
            if (model.IsDemo == 1) { // 1 体验课
                
                GGT_PreviewDemoCourseVC *vc = [GGT_PreviewDemoCourseVC new];
                vc.xc_model = model;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {    // 0 正课     // 都是进入到课件详情
                // @"2"是正在上课 @"5"是缺席
//                if ([model.Status integerValue] != 2) {     // 2 是上课
                    GGT_PreCoursewareVC *vc = [GGT_PreCoursewareVC new];
                    vc.xc_model = model;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    
                    // 如果Status是0 是可以取消预约的 3 待评价  也是需要更新
                    // 需要单独处理  可能需要Block回调
                    if ([model.Status integerValue] == 0) { // 取消预约
                        @weakify(self);
                        vc.xc_deleteBlock = ^{
                            @strongify(self);
                            // 取消成功后 更新界面 删除单个cell
                            [self.xc_courseMuArray removeObjectAtIndex:indexPath.row];  //删除xc_courseMuArray数组里的数据
                            [self.xc_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                            // 刷新日历 可能红色的不见了
                            // 此处不能使用xc_selectedDate
                            [self loadCalendarDataWithDate:[NSDate date] showMBP:YES];
                            [self loadCourseDataWithStime:self.xc_selectedDate showMBP:YES];
                        };
                    }
                    
                    if ([model.Status integerValue] == 3) {
                        @weakify(self);
                        vc.xc_changeStatusBlock = ^(GGT_CourseCellModel *xc_model) {
                            @strongify(self);
                            GGT_ScheduleStudyingCell *cell = [self.xc_tableView cellForRowAtIndexPath:indexPath];
                            // 有问题  还要更新星星的个数  评价的内容
                            cell.xc_cellModel = xc_model;
                            
                            // 更改数据源
                            [self.xc_courseMuArray replaceObjectAtIndex:indexPath.row withObject:xc_model];
                            
                            //                [self.xc_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                        };
                    }
                    
//                } else if ([model.Status isEqualToString:@"2"]) {
                
//                    // 还需要传一些参数 上课的一些信息
//                    GGT_ClassRoomViewController *vc = [GGT_ClassRoomViewController new];
//                    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
//                    vc.xc_model = model;
//                    [self presentViewController:vc animated:YES completion:nil];
                    //        LOSAlert(@"进入到上课界面");
//                }
            }
        }
        
    } failure:^(NSError *error) {
        
        NSDictionary *dic = error.userInfo;
        if ([dic[@"msg"] isKindOfClass:[NSString class]] && [dic[@"msg"] length] > 0) {
            [MBProgressHUD showMessage:dic[@"msg"] toView:self.view];
        }

    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGT_ScheduleStudyingCell *cell = [GGT_ScheduleStudyingCell cellWithTableView:tableView forIndexPath:indexPath];
    if (self.xc_courseMuArray.count > 0) {
        cell.xc_cellModel = self.xc_courseMuArray[indexPath.row];
    }
    
    cell.xc_courseButton.tag = indexPath.row+100;
    [cell.xc_courseButton addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)cellButtonAction:(UIButton *)button
{
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag-100 inSection:0];
    GGT_ScheduleStudyingCell *cell = [self.xc_tableView cellForRowAtIndexPath:indexPath];
    GGT_CourseCellModel *model = cell.xc_cellModel;
    
    switch ([model.Status integerValue]) {
        case 0:     // 已经预约  // 点击按钮可以取消预约
        {
            [self cancleReservationCourseWithModel:model withIndexPath:indexPath];
        }
            break;
        case 1:     // 即将上课  // 进入直播上课界面
        {
            GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
            if (sin.isAuditStatus) {
                // 进pdf界面
                [self getLessonWithCourseModel:model tableView:self.xc_tableView indexPath:indexPath];
            } else {
                
                NSDictionary *tDict = @{
                                        @"serial"   :model.serial,
                                        @"host"    :model.host,
                                        // @"userid"  : @"1111",
                                        @"port"    :model.port,
                                        @"nickname":model.nickname,    // 学生密码567
                                        @"userrole":model.userrole    //用户身份，0：老师；1：助教；2：学生；3：旁听；4：隐身用户
                                        };
                TKEduClassRoom *shareRoom = [TKEduClassRoom shareTKEduClassRoomInstance];
                shareRoom.xc_roomPassword = model.stuPwd;
                shareRoom.xc_roomName = model.LessonName;
                [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:self Delegate:self];

                // 记录日志
                [XCLogManager xc_redirectNSlogToDocumentFolder];

            }
            
        }
            break;
        case 2:     // 正在上课  // 进入教室
        {
            // 还需要传一些参数 上课的一些信息
            GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
            if (sin.isAuditStatus) {
                // 进pdf界面
                [self getLessonWithCourseModel:model tableView:self.xc_tableView indexPath:indexPath];
            } else {
                
                NSDictionary *tDict = @{
                                        @"serial"   :model.serial,
                                        @"host"    :model.host,
                                        // @"userid"  : @"1111",
                                        @"port"    :model.port,
                                        @"nickname":model.nickname,    // 学生密码567
                                        @"userrole":model.userrole    //用户身份，0：老师；1：助教；2：学生；3：旁听；4：隐身用户
                                        };
                TKEduClassRoom *shareRoom = [TKEduClassRoom shareTKEduClassRoomInstance];
                shareRoom.xc_roomPassword = model.stuPwd;
                shareRoom.xc_roomName = model.LessonName;
                [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:self Delegate:self];

                // 记录日志
                [XCLogManager xc_redirectNSlogToDocumentFolder];
                
            }
        }
            break;
        case 3:     // 已经结束 待评价
        {
            [self showEvaluationViewWithCellModel:model withIndexPath:indexPath];
        }
            break;
        case 4:     // 已经结束 已评价
        {
            [self showEvaluationViewWithCellModel:model withIndexPath:indexPath];
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
- (void)cancleReservationCourseWithModel:(GGT_CourseCellModel *)model withIndexPath:(NSIndexPath *)indexPath
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
            [self.xc_courseMuArray removeObjectAtIndex:indexPath.row];  //删除xc_courseMuArray数组里的数据
            [self.xc_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
            
            // 刷新日历 可能红色的不见了
            // 此处不能使用xc_selectedDate
            [self loadCalendarDataWithDate:[NSDate date] showMBP:YES];
            [self loadCourseDataWithStime:self.xc_selectedDate showMBP:YES];
           
            
        } failure:^(NSError *error) {
            if ([error.userInfo[xc_returnCode] integerValue] != 1) {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:error.userInfo[xc_message] preferredStyle:UIAlertControllerStyleAlert];
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


#pragma mark - 网络请求
// 日历上面的subtitle事件
- (void)loadCalendarDataWithDate:(NSDate *)date showMBP:(BOOL)isShow
{
    
    NSString *dateString = [self.xc_dateFormatter stringFromDate:date];
    
    // 每次滑动都要重新初始化 不然无法清除之前数据
    self.xc_calendarEventsMuArray = [NSMutableArray array];
    self.xc_calendarEventsMuDic = [NSMutableDictionary dictionary];
    
    
    //413498    413302
    
    NSString *url = [NSString stringWithFormat:@"%@?&dateTemp=%@", URL_LessonList, dateString];
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:isShow  success:^(id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = responseObject[@"data"];
            if ([data[@"ListDates"] isKindOfClass:[NSArray class]]) {
                
                NSArray *ListDates = data[@"ListDates"];
                [ListDates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSLog(@"%@", obj);
                    GGT_CalendarCellModel *model = [GGT_CalendarCellModel yy_modelWithDictionary:obj];
                    [self.xc_calendarEventsMuArray addObject:model.YearMonthDay];
                    self.xc_calendarEventsMuDic[model.YearMonthDay] = model.ListTimes;
                }];
                
                [self.calendar reloadData];
                
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

// 日历下面的课程列表数据
- (void)loadCourseDataWithStime:(NSDate *)date showMBP:(BOOL)isShow
{
    NSString *stime = [NSString stringWithFormat:@"%@", [self.xc_dateFormatter stringFromDate:date]];
    
    NSString *url = [NSString stringWithFormat:@"%@?stime=%@", URL_GetMyLesson, stime];
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:isShow success:^(id responseObject) {
        
        NSDictionary *dic = responseObject;
        GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:dic];
        self.xc_placeholderView.xc_model = model;
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *data = responseObject[@"data"];
            
            [self.xc_courseMuArray removeAllObjects];
            
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                GGT_CourseCellModel *model = [GGT_CourseCellModel yy_modelWithDictionary:obj];
                [self.xc_courseMuArray addObject:model];
               
            }];
            
            [self reloadData];
        
        }
        
    } failure:^(NSError *error) {
        
        NSDictionary *dic = error.userInfo;
        GGT_ResultModel *model = [GGT_ResultModel yy_modelWithDictionary:dic];
        self.xc_placeholderView.xc_model = model;
        
    }];
    
}

// 弹出评价的弹窗
- (void)showEvaluationViewWithCellModel:(GGT_CourseCellModel *)model withIndexPath:(NSIndexPath *)indexPath
{
    GGT_EvaluationPopViewController *vc = [GGT_EvaluationPopViewController new];
    vc.xc_model = model;
    
    @weakify(self);
    vc.xc_reloadBlock = ^(GGT_CourseCellModel *model) {
        @strongify(self);
        GGT_ScheduleStudyingCell *cell = [self.xc_tableView cellForRowAtIndexPath:indexPath];
        cell.xc_cellModel = model;
        
        // 更改数据源
        [self.xc_courseMuArray replaceObjectAtIndex:indexPath.row withObject:model];
        
//        [self.xc_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.popoverPresentationController.delegate = self;
    //    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // 修改弹出视图的size 在控制器内部修改更好
    //    vc.preferredContentSize = CGSizeMake(100, 100);
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MZTimerLabelDelegate
-(void)timerLabel:(MZTimerLabel*)timerlabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType
{
    int i = floor(time);
    NSLog(@"%d", i);
    if (i == 60) {
        NSDictionary *messageDic = nil;
        if (self.xc_recentCourseModel) {
            messageDic = @{xc_message : self.xc_recentCourseModel};
        } else {
            messageDic = @{xc_message : @""};
        }
        
        GGT_Singleton *single = [GGT_Singleton sharedSingleton];
        if (single.isInRoom) {  // 在教室不发送通知
            
        } else {
            // 进入教室后 不弹框
            [[NSNotificationCenter defaultCenter] postNotificationName:kPopoverCourseAlterViewNotification object:nil userInfo:messageDic];
        }
        
    }
}

// 获取最近一次的上课时间
- (void)getRecentCourse
{
    @weakify(self);
    self.xc_CountDownTimer = [NSTimer xc_scheduledTimerWithTimeInterval:60*25 block:^{
        @strongify(self);
        NSLog(@"每隔25分钟刷新一次数据 %@", self.view);
        
        [self getRecentCourseNetwork];
        
    } repeats:YES];
    [self.xc_CountDownTimer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.xc_timer forMode:NSRunLoopCommonModes];
}

// 添加一个定时器 每隔5分钟请求一次接口 刷新界面
- (void)sendNetEvery5Min
{
    @weakify(self);
    self.xc_timer = [NSTimer xc_scheduledTimerWithTimeInterval:60*5 block:^{
        @strongify(self);
        
        NSLog(@"每隔5分钟刷新一次数据 %@", self.view);
        
        // 请求日历上面的数据
        [self loadCalendarDataWithDate:self.xc_selectedDate showMBP:NO];
        // 请求日历下面的数据
        [self loadCourseDataWithStime:self.xc_selectedDate showMBP:NO];
        
    } repeats:YES];
    [self.xc_timer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.xc_timer forMode:NSRunLoopCommonModes];
}

/// 获取最近上课的网络请求
- (void)getRecentCourseNetwork
{
    [[BaseService share] sendGetRequestWithPath:URL_AppStuLatelyLesson token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSArray *data = responseObject[@"data"];
        if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
            self.xc_recentCourseModel = [GGT_CourseCellModel yy_modelWithDictionary:data.firstObject];
        }
        
        // 开始倒计时
        if (self.xc_mzTimer == nil) {
            self.xc_mzTimer = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
            self.xc_mzTimer.delegate = self;
            [self.xc_mzTimer setCountDownTime:self.xc_recentCourseModel.CountDown];
            self.xc_mzTimer.timeFormat = @"mm:ss";
            [self.xc_mzTimer start];
        } else {
            [self.xc_mzTimer reset];
            [self.xc_mzTimer setCountDownTime:self.xc_recentCourseModel.CountDown];
            [self.xc_mzTimer start];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
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


#pragma mark TKEduEnterClassRoomDelegate
//error.code  Description:error.description
- (void) onEnterRoomFailed:(int)result Description:(NSString*)desc{
    if ([desc isEqualToString:MTLocalized(@"Error.NeedPwd")]) {     // 需要密码错误日志不发送
        
    } else {
        TKLog(@"-----onEnterRoomFailed");
        [XCLogManager xc_readDataFromeFile];
    }
}
- (void) onKitout:(EKickOutReason)reason{
    TKLog(@"-----onKitout");
}
- (void) joinRoomComplete{
    TKLog(@"-----joinRoomComplete");
    [XCLogManager xc_readDataFromeFile];
}
- (void) leftRoomComplete{
    TKLog(@"-----leftRoomComplete");
    [XCLogManager xc_deleteLogData];
}
- (void) onClassBegin{
    TKLog(@"-----onClassBegin");
}
- (void) onClassDismiss{
    NSLog(@"-----onClassDismiss");
    [TKEduClassRoom leftRoom];
}
- (void) onCameraDidOpenError{
    TKLog(@"-----onCameraDidOpenError");
}


@end

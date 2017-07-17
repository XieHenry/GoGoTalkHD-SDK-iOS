//
//  GGT_ScheduleStudyingCell.m
//  GoGoTalk
//
//  Created by 辰 on 2017/5/3.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_ScheduleStudyingCell.h"
#import "OYCountDownManager.h"
#import "XCStarView.h"

static NSString * const xc_CountDownTitleName = @"正在上课";

@interface GGT_ScheduleStudyingCell ()

// 整体布局
@property (nonatomic, strong) UIView *xc_contentView;
@property (nonatomic, strong) UIView *xc_topView;
@property (nonatomic, strong) UIView *xc_bodyView;

// 顶部 共有
@property (nonatomic, strong) UILabel *xc_courseTimeLabel;

// 底部 共有
@property (nonatomic, strong) UIImageView *xc_headPortraitImgView;
@property (nonatomic, strong) UILabel *xc_courseNameLabel;
@property (nonatomic, strong) UILabel *xc_teachNameLabel;

// 顶部 上课前倒计时
@property (nonatomic, strong) UIView *xc_topCountDownParentView;    // 新增
@property (nonatomic, strong) UILabel *xc_countDownLabel;
@property (nonatomic, strong) FLAnimatedImageView *xc_countDownImageView;

// 顶部 正在上课
@property (nonatomic, strong) UIView *xc_topHavingClassParentView;
@property (nonatomic, strong) UILabel *xc_havingClassLabel;
@property (nonatomic, strong) FLAnimatedImageView *xc_havingClassImgView;

// 顶部 未开始 或者 已结束
@property (nonatomic, strong) UIView *xc_topNotStartOrFinishedParentView;
@property (nonatomic, strong) UIImageView *xc_notStartOrFinishedImgView;
@property (nonatomic, strong) UILabel *xc_notStartOrFinishedLabel;

// 底部 外教点评
@property (nonatomic, strong) UIView *xc_bottomTeachEvaParentView;
@property (nonatomic, strong) UILabel *xc_starTitleLabel;
@property (nonatomic, strong) XCStarView *xc_starView;

// 底部 进入教室

@property (nonatomic, strong) UILabel *xc_courseTypeLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;



@end

@implementation GGT_ScheduleStudyingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_ScheduleCellID = NSStringFromClass([self class]);
    GGT_ScheduleStudyingCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_ScheduleCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_ScheduleStudyingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_ScheduleCellID];
    }
    cell.indexPath = indexPath;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        [self configView];
        
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
}

// 自定义cell
- (void)configView
{
    [self initView];
    [self mas_View];
}

// 初始化view
- (void)initView
{
#pragma mark - 整体
    // 整体
    self.xc_contentView = ({
        UIView *xc_contentView = [UIView new];
        xc_contentView.backgroundColor = [UIColor whiteColor];
        xc_contentView;
    });
    [self addSubview:self.xc_contentView];
    
    self.xc_topView = ({
        UIView *xc_topView = [UIView new];
        xc_topView;
    });
    [self.xc_contentView addSubview:self.xc_topView];
    
    self.xc_bodyView = ({
        UIView *xc_bodyView = [UIView new];
        xc_bodyView;
    });
    [self.xc_contentView addSubview:self.xc_bodyView];
    
    
#pragma mark - xc_topView
    self.xc_courseTimeLabel = ({
        UILabel *xc_timelabel = [UILabel new];
        xc_timelabel.text = @"课程时间";
        xc_timelabel.textColor = UICOLOR_FROM_HEX(Color1A1A1A);
        xc_timelabel.font = Font(16);
        xc_timelabel;
    });
    [self.xc_topView addSubview:self.xc_courseTimeLabel];
    
    // 顶部 上课前倒计时
    self.xc_topCountDownParentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self.xc_topView addSubview:self.xc_topCountDownParentView];
    
    self.xc_countDownLabel = ({
        UILabel *xc_timelabel = [UILabel new];
        xc_timelabel.text = @"00:00";
        xc_timelabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
        xc_timelabel.font = Font(14);
        xc_timelabel;
    });
    [self.xc_topCountDownParentView addSubview:self.xc_countDownLabel];
    
    self.xc_countDownImageView = ({
        FLAnimatedImageView *xc_markImageView = [FLAnimatedImageView new];
        [xc_markImageView sd_setImageWithURL:nil placeholderImage:UIIMAGE_FROM_NAME(@"jishiqi")];
        xc_markImageView.contentMode = UIViewContentModeCenter;
        xc_markImageView;
    });
    [self.xc_topCountDownParentView addSubview:self.xc_countDownImageView];
    
    
    // 顶部 正在上课
    self.xc_topHavingClassParentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self.xc_topView addSubview:self.xc_topHavingClassParentView];
    
    self.xc_havingClassImgView = ({
        FLAnimatedImageView *imgView = [FLAnimatedImageView new];
        imgView.contentMode = UIViewContentModeCenter;
        NSString *pathString = [[NSBundle mainBundle] pathForResource:@"having_Class.gif" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:pathString];
        [imgView sd_setImageWithURL:url placeholderImage:nil];
        imgView;
    });
    [self.xc_topHavingClassParentView addSubview:self.xc_havingClassImgView];
    
    self.xc_havingClassLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"正在上课";
        label.textColor = UICOLOR_FROM_HEX(kThemeColor);
        label.font = Font(14);
        label;
    });
    [self.xc_topHavingClassParentView addSubview:self.xc_havingClassLabel];
    
    // 顶部 未开始 或者 已结束
    self.xc_topNotStartOrFinishedParentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self.xc_topView addSubview:self.xc_topNotStartOrFinishedParentView];
    
    self.xc_notStartOrFinishedImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.image = UIIMAGE_FROM_NAME(@"weikaike");
        imgView.contentMode = UIViewContentModeCenter;
        imgView;
    });
    [self.xc_topNotStartOrFinishedParentView addSubview:self.xc_notStartOrFinishedImgView];
    
    self.xc_notStartOrFinishedLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(14);
        label.text = @"迟到五分钟";
        label;
    });
    [self.xc_topNotStartOrFinishedParentView addSubview:self.xc_notStartOrFinishedLabel];
    
#pragma mark - xc_bodyView
    
    // 公用
    self.xc_headPortraitImgView = ({
        UIImageView *xc_headPortraitImgView = [UIImageView new];
        xc_headPortraitImgView.image = UIIMAGE_FROM_NAME(@"default_avatar");
        xc_headPortraitImgView;
    });
    [self.xc_bodyView addSubview:self.xc_headPortraitImgView];
    
    self.xc_courseNameLabel = ({
        UILabel *xc_courseNameLabel = [UILabel new];
        xc_courseNameLabel.text = @"课程名字";
        xc_courseNameLabel.textColor = UICOLOR_FROM_HEX(Color222222);
        xc_courseNameLabel.font = Font(14);
        xc_courseNameLabel;
    });
    [self.xc_bodyView addSubview:self.xc_courseNameLabel];
    
    self.xc_courseTypeLabel = ({
        UILabel *xc_courseTypeLabel = [UILabel new];
        xc_courseTypeLabel.textColor = UICOLOR_FROM_HEX(Color222222);
        xc_courseTypeLabel.font = Font(12);
        xc_courseTypeLabel.text = @"上课类型";
        xc_courseTypeLabel;
    });
    [self.xc_bodyView addSubview:self.xc_courseTypeLabel];
    
    self.xc_teachNameLabel = ({
        UILabel *xc_teachNameLabel = [UILabel new];
        xc_teachNameLabel.text = @"老师名字";
        xc_teachNameLabel.textColor = UICOLOR_FROM_HEX(Color6F6F6F);
        xc_teachNameLabel.font = Font(12);
        xc_teachNameLabel;
    });
    [self.xc_bodyView addSubview:self.xc_teachNameLabel];
    
    self.xc_courseButton = ({
        UIButton *xc_enterRoomButton = [UIButton new];
        xc_enterRoomButton.frame = CGRectMake(0, 0, 88, 30);
        xc_enterRoomButton.titleLabel.font = Font(14);
        [xc_enterRoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        xc_enterRoomButton;
    });
    [self.xc_bodyView addSubview:self.xc_courseButton];
    

    // 底部 外教点评
    self.xc_bottomTeachEvaParentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self.xc_bodyView addSubview:self.xc_bottomTeachEvaParentView];
    
    self.xc_starTitleLabel = ({
        UILabel *xc_starNameLabel = [UILabel new];
        xc_starNameLabel.text = @"外教点评：";
        xc_starNameLabel.textColor = UICOLOR_FROM_HEX(Color6F6F6F);
        xc_starNameLabel.font = Font(12);
        xc_starNameLabel;
    });
    [self.xc_bottomTeachEvaParentView addSubview:self.xc_starTitleLabel];
    
    self.xc_starView = ({
        XCStarView *xc_starView = [[XCStarView alloc] initWithEmptyImage:@"dianping_kebiao_da_wei" StarImage:@"dianping_kebiao_da_yi" totalStarCount:5 selectedStatCount:0 starMargin:LineW(11) starWidth:LineW(11)];
        xc_starView;
    });
    [self.xc_bottomTeachEvaParentView addSubview:self.xc_starView];
    
}

- (void)mas_View
{
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LineW(margin10));
        make.right.equalTo(self).offset(-LineW(margin10));
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-LineH(margin10));
    }];
    
    [self.xc_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.xc_contentView);
        make.height.equalTo(@(LineH(44)));
    }];
    
    [self.xc_bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.xc_contentView);
        make.top.equalTo(self.xc_topView.mas_bottom);
    }];
    
    
#pragma mark - xc_topView
    [self.xc_courseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_topView).offset(LineW(margin20));
        make.centerY.equalTo(self.xc_topView.mas_centerY);
    }];
    
    // 顶部 上课前倒计时
    [self.xc_topCountDownParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_courseTimeLabel.mas_right);
        make.top.right.bottom.equalTo(self.xc_topView);
    }];
    
    [self.xc_countDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_topCountDownParentView).offset(-LineW(margin20));
        make.centerY.equalTo(self.xc_topCountDownParentView.mas_centerY);
        make.width.height.equalTo(@(LineW(18)));
    }];
    
    [self.xc_countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_countDownImageView.mas_left).offset(-LineW(margin10));
        make.centerY.equalTo(self.xc_topCountDownParentView.mas_centerY);
    }];
    
    // 顶部 正在上课
    [self.xc_topHavingClassParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_courseTimeLabel.mas_right);
        make.top.right.bottom.equalTo(self.xc_topView);
    }];
    
    [self.xc_havingClassImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_topHavingClassParentView).offset(-LineW(margin20));
        make.centerY.equalTo(self.xc_topHavingClassParentView.mas_centerY);
        make.width.height.equalTo(@(LineW(18)));
    }];
    
    [self.xc_havingClassLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_havingClassImgView.mas_left).offset(-LineW(margin10));
        make.centerY.equalTo(self.xc_havingClassImgView.mas_centerY);
    }];
    
    // 顶部 未开始 或者 已结束
    [self.xc_topNotStartOrFinishedParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_courseTimeLabel.mas_right);
        make.top.right.bottom.equalTo(self.xc_topView);
    }];
    
    [self.xc_notStartOrFinishedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_topNotStartOrFinishedParentView);
        make.centerY.equalTo(self.xc_topNotStartOrFinishedParentView.mas_centerY);
        make.width.height.equalTo(self.xc_topNotStartOrFinishedParentView.mas_height);
    }];
    
    [self.xc_notStartOrFinishedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_notStartOrFinishedImgView.mas_left);
        make.centerY.equalTo(self.xc_topNotStartOrFinishedParentView);
    }];
    
#pragma mark - xc_bodyView
    [self.xc_headPortraitImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_bodyView).offset(LineW(margin20));
        make.top.equalTo(self.xc_bodyView).offset(LineH(margin10));
        make.bottom.equalTo(self.xc_bodyView).offset(-LineH(margin10));
        make.width.equalTo(self.xc_headPortraitImgView.mas_height);
    }];
    
    [self.xc_courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_headPortraitImgView.mas_right).offset(LineW(margin20));
        make.top.equalTo(self.xc_headPortraitImgView.mas_top).offset(LineH(margin15/2.0));
    }];
    
    [self.xc_courseTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_courseNameLabel.mas_right).offset(margin40);
        make.centerY.equalTo(self.xc_courseNameLabel);
    }];
    
    [self.xc_teachNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xc_headPortraitImgView.mas_bottom).offset(-LineH(margin15/2.0));
        make.left.equalTo(self.xc_courseNameLabel.mas_left);
    }];
    
    [self.xc_courseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_bodyView).offset(-LineW(margin15));
        make.bottom.equalTo(self.xc_headPortraitImgView);
        make.width.equalTo(@(LineW(self.xc_courseButton.width)));//142 × 62
        make.height.equalTo(@(LineH(self.xc_courseButton.height)));
    }];
    
    // 底部 外教点评
    [self.xc_starTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_bottomTeachEvaParentView.mas_left);
        make.centerY.equalTo(self.xc_bottomTeachEvaParentView);
    }];
    
    [self.xc_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_starTitleLabel.mas_right).offset(LineW(margin5));
        make.centerY.equalTo(self.xc_starTitleLabel);
        make.height.equalTo(@(self.xc_starView.height));
        make.width.equalTo(@(self.xc_starView.width));
    }];
    
    [self.xc_bottomTeachEvaParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_teachNameLabel.mas_right).offset(LineW(margin20));
        make.right.equalTo(self.xc_starView.mas_right);
        make.top.bottom.equalTo(self.xc_starTitleLabel);
        make.centerY.equalTo(self.xc_teachNameLabel);
    }];

}

- (void)drawRect:(CGRect)rect
{
    [self.xc_contentView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineW(5.0f)];
    [self.xc_headPortraitImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:self.xc_headPortraitImgView.width];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}

// 已预约 未开课
- (void)notStart
{
    self.xc_topHavingClassParentView.hidden = YES;
    self.xc_topCountDownParentView.hidden = YES;
    self.xc_topNotStartOrFinishedParentView.hidden = NO;
    
    
    [self courseButtonWithImage:@"Button_gray" title:@"取消预约" titleColor:UICOLOR_FROM_HEX(Color777777)];
    [self courseNotStartOrFinishedLabelWithText:@"" textColor:UICOLOR_FROM_HEX(Color777777) imageName:@"weikaike"];
}

// 即将上课 倒计时
- (void)countDown
{
    self.xc_topHavingClassParentView.hidden = YES;
    self.xc_topCountDownParentView.hidden = NO;
    self.xc_topNotStartOrFinishedParentView.hidden = YES;
    
    
    [self courseButtonWithImage:@"anniu" title:@"进入教室" titleColor:[UIColor whiteColor]];
    self.xc_countDownImageView.image = UIIMAGE_FROM_NAME(@"jishiqi");
    
//    self.xc_timeCount = [NSString stringWithFormat:@"%ld",self.xc_cellModel.CountDown];
    
    
    NSInteger countDown = [self.xc_timeCount integerValue] - kCountDownManager.timeInterval;
    
    if (countDown <= 0) {
        // 可能需要更新status
        NSString *pathString = [[NSBundle mainBundle] pathForResource:@"having_Class.gif" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:pathString];
        [self.xc_countDownImageView sd_setImageWithURL:url placeholderImage:nil];
    } else {
        [self.xc_countDownImageView sd_setImageWithURL:nil placeholderImage:UIIMAGE_FROM_NAME(@"jishiqi")];
    }

}

// 正在上课
- (void)havingClass
{
    self.xc_topHavingClassParentView.hidden = NO;
    self.xc_topCountDownParentView.hidden = YES;
    self.xc_topNotStartOrFinishedParentView.hidden = YES;
    
    
    [self courseButtonWithImage:@"anniu" title:@"进入教室" titleColor:[UIColor whiteColor]];
}

// 已完成 未评价
- (void)finishedWithNotEva
{
    self.xc_topHavingClassParentView.hidden = YES;
    self.xc_topCountDownParentView.hidden = YES;
    self.xc_topNotStartOrFinishedParentView.hidden = NO;
    self.xc_courseButton.hidden = NO;
    
    [self courseButtonWithImage:@"Button_red" title:@"待评价" titleColor:UICOLOR_FROM_HEX(kThemeColor)];
    [self courseNotStartOrFinishedLabelWithText:@"" textColor:UICOLOR_FROM_HEX(Color777777)imageName:@"yiwancheng"];
}

// 已完成 已评价
- (void)finishedWithEva
{
    self.xc_topHavingClassParentView.hidden = YES;
    self.xc_topCountDownParentView.hidden = YES;
    self.xc_topNotStartOrFinishedParentView.hidden = NO;
    
    
    [self courseButtonWithImage:@"Button_gray" title:@"已评价" titleColor:UICOLOR_FROM_HEX(Color777777)];
    [self courseNotStartOrFinishedLabelWithText:@"" textColor:UICOLOR_FROM_HEX(Color777777) imageName:@"yiwancheng"];
}

// 已完成 缺席
- (void)finishedAbsent
{
    self.xc_topHavingClassParentView.hidden = YES;
    self.xc_topCountDownParentView.hidden = YES;
    self.xc_topNotStartOrFinishedParentView.hidden = NO;
    
    
    [self courseNotStartOrFinishedLabelWithText:@"缺席" textColor:UICOLOR_FROM_HEX(kThemeColor) imageName:@"yiwancheng"];
}



// 设置课程按钮的颜色 文字 背景色
- (void)courseButtonWithImage:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)titleColor
{
    [self.xc_courseButton setTitle:title forState:UIControlStateNormal];
    [self.xc_courseButton setBackgroundImage:UIIMAGE_FROM_NAME(imageName) forState:UIControlStateNormal];
    [self.xc_courseButton setBackgroundImage:UIIMAGE_FROM_NAME(imageName) forState:UIControlStateHighlighted];
    [self.xc_courseButton setTitleColor:titleColor forState:UIControlStateNormal];
    
}

// 设置未开课 已完成 顶部文字和图片的状态
- (void)courseNotStartOrFinishedLabelWithText:(NSString *)text textColor:(UIColor *)textColor imageName:(NSString *)imageName
{
    self.xc_notStartOrFinishedLabel.text = text;
    self.xc_notStartOrFinishedLabel.textColor = textColor;
    self.xc_notStartOrFinishedImgView.image = UIIMAGE_FROM_NAME(imageName);
    
    // 不能显示迟到的label
    if ([self.xc_cellModel.Status integerValue] == 0 || [self.xc_cellModel.Status integerValue] == 1) {
        
        self.xc_notStartOrFinishedLabel.text = @"";
        
    } else if ([self.xc_cellModel.Status integerValue] == 2 || [self.xc_cellModel.Status integerValue] == 3 || [self.xc_cellModel.Status integerValue] == 4) {    // 显示迟到的label
        
        if ([self.xc_cellModel.LateTime isKindOfClass:[NSString class]] && self.xc_cellModel.LateTime.length > 0 && ![self.xc_cellModel.LateTime isEqualToString:@"0"]) {
            self.xc_notStartOrFinishedLabel.text = [NSString stringWithFormat:@"迟到%@分钟", self.xc_cellModel.LateTime];
        } else {
            self.xc_notStartOrFinishedLabel.text = @"";
        }
        
    } else {
        self.xc_notStartOrFinishedLabel.text = @"缺席";
    }
    
}

#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }
    
    if (self.xc_cellModel.CountDown > 30 * 60 || self.xc_cellModel.CountDown < 0) return;
    
    /// 计算倒计时
    NSInteger countDown = [self.xc_timeCount integerValue] - kCountDownManager.timeInterval;
    
//    NSLog(@"%ld", countDown);
    
    if (countDown < 0) return;
    if (countDown > 30 * 60) return;
    
    /// 重新赋值
    self.xc_countDownLabel.text = [NSString stringWithFormat:@"%02zd分%02zd秒", (countDown/60)%60, countDown%60];
    /// 当倒计时到了进行回调
    if (countDown == 0) {
        self.xc_countDownLabel.text = xc_CountDownTitleName;
        // 可以添加block
//        if (self.countDownZero) {
//            self.countDownZero();
//        }
        
        // 可能需要更新status
        NSString *pathString = [[NSBundle mainBundle] pathForResource:@"having_Class.gif" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:pathString];
        [self.xc_countDownImageView sd_setImageWithURL:url placeholderImage:nil];
    }
    
    
    if ([self.xc_cellModel.Status integerValue] == 5) {
        self.xc_courseButton.hidden = YES;
    } else {
        if (self.xc_cellModel.IsDemo == 1) {    // 体验课10分钟前 才显示进入教室button
            if (countDown < 10*60) {
                self.xc_courseButton.hidden = NO;
            } else {
                self.xc_courseButton.hidden = YES;
            }
        } else {
            if (countDown > 30*60) {
                self.xc_courseButton.hidden = YES;
            } else {
                self.xc_courseButton.hidden = NO;
            }
        }
    }
}

- (void)setXc_timeCount:(NSString *)xc_timeCount
{
    _xc_timeCount = xc_timeCount;
    // 手动调用通知的回调
    [self countDownNotification];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setXc_cellModel:(GGT_CourseCellModel *)xc_cellModel
{
    _xc_cellModel = xc_cellModel;
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        xc_cellModel.Status = @"1";
//        xc_cellModel.CountDown = 70;
//    });
    
    // 公用的
    // 上课时间  头像  课程名称  外教名称
    if ([xc_cellModel.StartTime isKindOfClass:[NSString class]] && xc_cellModel.StartTime.length > 0) {
        self.xc_courseTimeLabel.text = xc_cellModel.StartTime;
    }
    if ([xc_cellModel.ImageUrl isKindOfClass:[NSString class]] && xc_cellModel.ImageUrl.length > 0) {
        [self.xc_headPortraitImgView sd_setImageWithURL:[NSURL URLWithString:xc_cellModel.ImageUrl] placeholderImage:UIIMAGE_FROM_NAME(@"default_avatar")];
    }
    if ([xc_cellModel.LessonName isKindOfClass:[NSString class]] && xc_cellModel.LessonName.length > 0) {
        self.xc_courseNameLabel.text = xc_cellModel.LessonName;
    }
    if ([xc_cellModel.TeacherName isKindOfClass:[NSString class]] && xc_cellModel.TeacherName.length > 0) {
        self.xc_teachNameLabel.text = xc_cellModel.TeacherName;
    }
    
    self.xc_starView.selectedStatCount = xc_cellModel.StuScore;
    
    // 需要放到switch方法前面 且需要对所有情况都需要重新set
    self.xc_timeCount = [NSString stringWithFormat:@"%ld",(long)xc_cellModel.CountDown];
    
    switch ([xc_cellModel.Status integerValue]) {
        case 0:     // 已经预约
        {
            [self notStart];
        }
            break;
        case 1:     // 即将上课
        {
            [self countDown];
        }
            break;
        case 2:     // 正在上课
        {
            [self havingClass];
        }
            break;
        case 3:     // 已经结束 待评价
        {
            [self finishedWithNotEva];
        }
            break;
        case 4:     // 已经结束 已评价
        {
            [self finishedWithEva];
        }
            break;
        case 5:     // 已经结束 缺席
        {
            [self finishedAbsent];
        }
            break;
            
        default:
            break;
    }
    
    
    // 1：体验课   正课可以取消预约 体验课不能取消预约
    if (xc_cellModel.IsDemo == 1) {
        self.xc_courseTypeLabel.text = @"体验课";
        self.xc_courseTypeLabel.hidden = NO;
    } else {  // 0:正课  正课可以取消预约 体验课不能取消预约
        
        if ([self.xc_cellModel.Status integerValue] == 0 || [self.xc_cellModel.Status integerValue] == 1) {
            if (self.xc_cellModel.IsShowBooking == 1) {
                self.xc_courseTypeLabel.hidden = NO;
            } else {
                self.xc_courseTypeLabel.hidden = YES;
            }
            self.xc_courseTypeLabel.text = @"预习课件";
            
        } else {
            self.xc_courseTypeLabel.hidden = YES;
        }
    }
    
    
    // 外教是否评价 0 未评价 1 评价
    if (xc_cellModel.IsComment == 0) {
        self.xc_bottomTeachEvaParentView.hidden = YES;
    } else {
        self.xc_bottomTeachEvaParentView.hidden = NO;
    }
    
    
    // 判断是否显示courseButton
    if ([self.xc_cellModel.Status integerValue] == 5) {
        self.xc_courseButton.hidden = YES;
    } else {
        if (xc_cellModel.IsDemo == 1) {
            
            if ([xc_cellModel.Status integerValue] == 1 || [xc_cellModel.Status integerValue] == 2) {
                if (self.xc_cellModel.CountDown <= 10 * 60) {
                    self.xc_courseButton.hidden = NO;
                } else {
                    self.xc_courseButton.hidden = YES;
                }
                
            } else {
                self.xc_courseButton.hidden = YES;
            }
        } else {
            if ([xc_cellModel.Status integerValue] == 1 || [xc_cellModel.Status integerValue] == 2) {
                if (self.xc_cellModel.CountDown <= 30 * 60) {
                    self.xc_courseButton.hidden = NO;
                } else {
                    self.xc_courseButton.hidden = YES;
                }
            } else {
                self.xc_courseButton.hidden = NO;
            }
        }
    }
    
}

@end

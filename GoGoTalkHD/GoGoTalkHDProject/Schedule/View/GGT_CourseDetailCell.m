//
//  GGT_CourseDetailCell.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/22.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_CourseDetailCell.h"
#import "XCStarView.h"
#import "MZTimerLabel.h"

static NSString * const xc_CountDownTitleName = @"正在上课";

@interface GGT_CourseDetailCell ()<MZTimerLabelDelegate>


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

// 底部 教室性别 年龄
@property (nonatomic, strong) UILabel *xc_sexLabel;
@property (nonatomic, strong) UILabel *xc_ageLabel;

// 顶部 上课前倒计时
@property (nonatomic, strong) UIView *xc_topCountDownParentView;    // 新增
@property (nonatomic, strong) MZTimerLabel *xc_countDownLabel;
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

@implementation GGT_CourseDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_CourseDetailCellID = NSStringFromClass([self class]);
    GGT_CourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_CourseDetailCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_CourseDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_CourseDetailCellID];
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
        MZTimerLabel *xc_timelabel = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
        xc_timelabel.text = @"00:00";
        xc_timelabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
        xc_timelabel.font = Font(14);
        xc_timelabel.delegate = self;
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
        label.text = @"";
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
        xc_enterRoomButton.hidden = YES;
        xc_enterRoomButton;
    });
    [self.xc_bodyView addSubview:self.xc_courseButton];
    
    
    // 教室性别  年龄
    self.xc_sexLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color6F6F6F);
        label.font = Font(10);
        label.text = @"性别";
        label;
    });
    [self.xc_bodyView addSubview:self.xc_sexLabel];
    
    self.xc_ageLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color6F6F6F);
        label.font = Font(10);
        label.text = @"年龄";
        label;
    });
    [self.xc_bodyView addSubview:self.xc_ageLabel];
    
    
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
    
    // 性别  年龄
    [self.xc_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_teachNameLabel.mas_right).offset(margin20);
        make.centerY.equalTo(self.xc_teachNameLabel.mas_centerY);
    }];
    
    [self.xc_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_sexLabel.mas_right).offset(margin20);
        make.centerY.equalTo(self.xc_sexLabel.mas_centerY);
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
    
    if ([self.xc_cellModel.Status integerValue] == 5) {
        [self courseNotStartOrFinishedLabelWithText:@"缺席" textColor:UICOLOR_FROM_HEX(kThemeColor) imageName:@"yiwancheng"];
    } else {
        [self courseNotStartOrFinishedLabelWithText:@"老师缺席" textColor:UICOLOR_FROM_HEX(kThemeColor) imageName:@"yiwancheng"];
    }
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
        self.xc_notStartOrFinishedLabel.text = text;
    }
    
}

- (void)setXc_timeCount:(NSString *)xc_timeCount
{
    _xc_timeCount = xc_timeCount;
    
    [self.xc_countDownLabel setCountDownTime:[xc_timeCount integerValue]+0.5];
    self.xc_countDownLabel.timeFormat = @"mm:ss";
    [self.xc_countDownLabel start];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setXc_cellModel:(GGT_CourseCellModel *)xc_cellModel
{
    _xc_cellModel = xc_cellModel;
    
    // 公用的
    // 上课时间  头像  课程名称  外教名称
    if ([xc_cellModel.StartTime isKindOfClass:[NSString class]] && xc_cellModel.StartTime.length > 0) {
        self.xc_courseTimeLabel.text = xc_cellModel.StartTime;
    } else {
        self.xc_courseNameLabel.text = @"";
    }
    
    if ([xc_cellModel.ImageUrl isKindOfClass:[NSString class]] && xc_cellModel.ImageUrl.length > 0) {
        [self.xc_headPortraitImgView sd_setImageWithURL:[NSURL URLWithString:xc_cellModel.ImageUrl] placeholderImage:UIIMAGE_FROM_NAME(@"default_avatar")];
    }
    
    if ([xc_cellModel.LessonName isKindOfClass:[NSString class]] && xc_cellModel.LessonName.length > 0) {
        self.xc_courseNameLabel.text = xc_cellModel.LessonName;
    } else {
        self.xc_courseNameLabel.text = @"";
    }
    
    if ([xc_cellModel.TeacherName isKindOfClass:[NSString class]] && xc_cellModel.TeacherName.length > 0) {
        self.xc_teachNameLabel.text = xc_cellModel.TeacherName;
    } else {
        self.xc_teachNameLabel.text = @"";
    }
    
    self.xc_starView.selectedStatCount = xc_cellModel.StuScore;
    
    if ([self.xc_cellModel.Age isKindOfClass:[NSString class]] && self.xc_cellModel.Age.length > 0) {
        self.xc_ageLabel.text = self.xc_cellModel.Age;
    } else {
        self.xc_ageLabel.text = @"";
    }
    
    if ([self.xc_cellModel.Gender isKindOfClass:[NSString class]] && self.xc_cellModel.Gender.length > 0) {
        self.xc_sexLabel.text = self.xc_cellModel.Gender;
    } else {
        self.xc_sexLabel.text = @"";
    }
    
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
        case 5:     // 已经结束 缺席  学生缺席
        {
            [self finishedAbsent];
        }
            break;
        case 6:     // 已经结束 缺席  老师缺席
        {
            [self finishedAbsent];
        }
            
            break;
            
        default:
            break;
    }
    

    if (xc_cellModel.IsDemo == 1) { // 1：体验课   正课可以取消预约 体验课不能取消预约
        self.xc_courseTypeLabel.text = @"体验课";
        self.xc_courseTypeLabel.hidden = NO;
    } else {  // 0:正课  正课可以取消预约 体验课不能取消预约
        
        if ([self.xc_cellModel.Status integerValue] == 0 || [self.xc_cellModel.Status integerValue] == 1) {
            self.xc_courseTypeLabel.text = @"预习课件";
            self.xc_courseTypeLabel.hidden = NO;
        } else {
            self.xc_courseTypeLabel.hidden = YES;
        }
        
        // 正课不显示 预习课件
        self.xc_courseTypeLabel.hidden = YES;
    }
    
    // 判断是否显示courseButton
    if ([self.xc_cellModel.Status integerValue] == 5 || [self.xc_cellModel.Status integerValue] == 6) {
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
    
    
    // 不需要显示外教的点评
    self.xc_bottomTeachEvaParentView.hidden = YES;
    
    
    
}

#pragma mark - MZTimerLabelDelegate
-(void)timerLabel:(MZTimerLabel*)timerlabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType
{
    int i = floor(time);
//    NSLog(@"%d", i);
    if ([self.xc_cellModel.Status integerValue] == 5 || [self.xc_cellModel.Status integerValue] == 6) {
        self.xc_courseButton.hidden = YES;
    } else {
        if (self.xc_cellModel.IsDemo == 1) {    // 体验课10分钟前 才显示进入教室button
           
            //0：已经预约 1：即将上课 2：正在上课 3：已经结束 待评价 4：已经结束 已评价 5：已经结束 缺席）
            if ([self.xc_cellModel.Status integerValue] == 0 || [self.xc_cellModel.Status integerValue] == 3 || [self.xc_cellModel.Status integerValue] == 4) {
                self.xc_courseButton.hidden = YES;
            } else {
                if (i < 10*60) {
                    self.xc_courseButton.hidden = NO;
                } else {
                    self.xc_courseButton.hidden = YES;
                }
            }
            
        } else {
            if (i > 30*60) {
                self.xc_courseButton.hidden = YES;
            } else {
                self.xc_courseButton.hidden = NO;
            }
        }
    }
}


@end

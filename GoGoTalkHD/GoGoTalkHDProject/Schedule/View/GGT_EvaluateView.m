//
//  GGT_EvaluateView.m
//  GoGoTalk
//
//  Created by 辰 on 2017/5/8.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_EvaluateView.h"


@interface GGT_EvaluateView ()
@property (nonatomic, strong) UILabel *xc_titleLabel;
@property (nonatomic, strong) UILabel *xc_detailLabel;

@property (nonatomic, strong) NSArray *xc_evaluateArray;
@property (nonatomic, strong) NSString *xc_title;
@end

@implementation GGT_EvaluateView

- (instancetype)initWithTitle:(NSString *)title evaluateArray:(NSArray *)evaluateArray selectCount:(NSInteger)selectCount
{
    if (self = [super init]) {
        self.xc_evaluateArray = evaluateArray;
        self.xc_title = title;
        self.selectCount = selectCount;
        [self initView];
        [self mas_view];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH(), self.xc_detailLabel.bottom);
    }
    return self;
}

#pragma mark - 初始化
- (void)initView
{
    
#pragma mark - 初始化
    // 创建xc_titleLabel
    self.xc_titleLabel = ({
        UILabel *xc_titleLabel = [UILabel new];
        xc_titleLabel.text = self.xc_title;
        xc_titleLabel.font = Font(14);
        xc_titleLabel.textColor = UICOLOR_FROM_HEX(Color232323);
        xc_titleLabel;
    });
    [self addSubview:self.xc_titleLabel];
    
    // 创建xc_detailLabel
    self.xc_detailLabel = ({
        UILabel *xc_detailLabel = [UILabel new];
        xc_detailLabel.font = Font(12);
        xc_detailLabel.textColor = UICOLOR_FROM_HEX(Color232323);
        xc_detailLabel;
    });
    [self addSubview:self.xc_detailLabel];
    
    // xc_starView
    @weakify(self);
    self.xc_starView = [[XCStarView alloc] initWithEmptyImage:@"dainping_wei" StarImage:@"dianping_yi" totalStarCount:self.xc_evaluateArray.count starMargin:LineW(20) starWidth:LineW(16) selectBlock:^(NSInteger count) {
        @strongify(self);
        [self showDetailLabelTextWithCount:count];
    }];
    self.xc_starView.selectedStatCount = self.selectCount;
    [self addSubview:self.xc_starView];
    
}

#pragma mark - 布局
- (void)mas_view
{
    // xc_titleLabel
    [self.xc_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [self.xc_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.equalTo(@(self.xc_starView.width));
        make.height.equalTo(@(self.xc_starView.height));
        make.centerY.equalTo(self.xc_titleLabel.mas_centerY);
    }];
    
    // xc_detailLabel
    [self.xc_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.xc_starView);
        make.top.equalTo(self.xc_starView.mas_bottom).offset(margin10);
    }];
    

    
    [self layoutIfNeeded];
}

- (void)showDetailLabelTextWithCount:(NSInteger)count
{
    if (count<1) {
        return;
    }
    self.xc_detailLabel.text = self.xc_evaluateArray[count-1];
    self.selectCount = count;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}


@end

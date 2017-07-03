//
//  GGT_PreviewTeachEvaCell.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/8.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PreviewTeachEvaCell.h"
#import "XCStarView.h"

@interface GGT_PreviewTeachEvaCell ()
// 顶部 外教点评
// 整体
@property (nonatomic, strong) UIView *xc_evaParentView;
@property (nonatomic, strong) UIView *xc_topParentView;
@property (nonatomic, strong) UIView *xc_bottomLineView;

// 底部
@property (nonatomic, strong) UIView *xc_topEvaTitleParentView;
@property (nonatomic, strong) UILabel *xc_topStarTitleLabel;
@property (nonatomic, strong) XCStarView *xc_topStarView;
@property (nonatomic, strong) UILabel *xc_topContentLabel;
@end

@implementation GGT_PreviewTeachEvaCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_PreviewTeachEvaCellID = NSStringFromClass([self class]);
    GGT_PreviewTeachEvaCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_PreviewTeachEvaCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_PreviewTeachEvaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_PreviewTeachEvaCellID];
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
        
    }
    return self;
}

- (void)configView
{
#pragma mark - 整体
    // 整体
    self.xc_evaParentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self addSubview:self.xc_evaParentView];
    
    // 顶部
    self.xc_topParentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.xc_evaParentView addSubview:self.xc_topParentView];
    
    // 底部
    self.xc_bottomLineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        view;
    });
    [self.xc_evaParentView addSubview:self.xc_bottomLineView];
    
    
#pragma mark -
    // 顶部评价
    self.xc_topEvaTitleParentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self.xc_topParentView addSubview:self.xc_topEvaTitleParentView];
    
    
    // 顶部子view
    self.xc_topStarTitleLabel = ({
        UILabel *xc_starNameLabel = [UILabel new];
        xc_starNameLabel.text = @"外教点评：";
        xc_starNameLabel.textColor = UICOLOR_FROM_HEX(Color1A1A1A);
        xc_starNameLabel.font = Font(16);
        xc_starNameLabel;
    });
    [self.xc_topEvaTitleParentView addSubview:self.xc_topStarTitleLabel];
    
    self.xc_topStarView = ({
        XCStarView *xc_starView = [[XCStarView alloc] initWithEmptyImage:@"dianping_kebiao_da_wei" StarImage:@"dianping_kebiao_da_yi" totalStarCount:5 selectedStatCount:0 starMargin:LineW(11) starWidth:LineW(11)];
        xc_starView;
    });
    [self.xc_topEvaTitleParentView addSubview:self.xc_topStarView];
    
    // 底部子view
    self.xc_topContentLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color777777);
        label.font = Font(16);
        label.numberOfLines = 0;
        label;
    });
    [self.xc_topParentView addSubview:self.xc_topContentLabel];
    
    
    // 布局
    [self.xc_topStarTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_topEvaTitleParentView.mas_left);
        make.centerY.equalTo(self.xc_topEvaTitleParentView);
    }];
    
    [self.xc_topStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_topStarTitleLabel.mas_right).offset(LineW(margin5));
        make.centerY.equalTo(self.xc_topStarTitleLabel);
        make.height.equalTo(@(self.xc_topStarView.height));
        make.width.equalTo(@(self.xc_topStarView.width));
    }];
    
    [self.xc_topEvaTitleParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_topParentView).offset(LineW(margin20));
        make.right.equalTo(self.xc_topStarView.mas_right);
        make.bottom.equalTo(self.xc_topStarTitleLabel);
        make.top.equalTo(self.xc_topParentView).offset(margin20);
    }];
    
    [self.xc_topContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topEvaTitleParentView.mas_bottom).offset(margin10);
        make.left.equalTo(self.xc_topParentView.mas_left).offset(LineW(margin20));
        make.right.equalTo(self.xc_topParentView.mas_right).offset(LineW(-margin20));
    }];
    
    [self.xc_topParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.xc_evaParentView);
        make.bottom.equalTo(self.xc_topContentLabel.mas_bottom).offset(margin10);
    }];
    
    [self.xc_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topParentView.mas_bottom);
        make.height.equalTo(@(margin10));
        make.left.right.equalTo(self.xc_evaParentView);
    }];
    
    [self.xc_evaParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(margin10);
        make.right.equalTo(self).offset(-margin10);
        make.bottom.equalTo(self.xc_bottomLineView.mas_bottom);
    }];

}

- (void)setXc_model:(GGT_CourseCellModel *)xc_model
{
    _xc_model = xc_model;
    
    
    
    if ([xc_model.Remark isKindOfClass:[NSString class]] && xc_model.Remark.length > 0) {
        self.xc_topContentLabel.text = xc_model.Remark;
    } else {
        self.xc_topContentLabel.text = @"";
    }
    [self.xc_topContentLabel changeLineSpaceWithSpace:5.0];
    
    [self layoutIfNeeded];
    
    if ([self.delegate respondsToSelector:@selector(previewTeachEvaCellHeightWithHeight:)]) {
        [self.delegate previewTeachEvaCellHeightWithHeight:self.xc_topContentLabel.bottom];
    }
    
}


- (void)drawRect:(CGRect)rect
{
    [self.xc_topParentView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:6.0];
}


@end

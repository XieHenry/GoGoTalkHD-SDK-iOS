//
//  GGT_TeachEvaCell.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/22.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_TeachEvaCell.h"
#import "XCStarView.h"

@interface GGT_TeachEvaCell ()
@property (nonatomic, strong) UIView *xc_contentView;
@property (nonatomic, strong) UIView *xc_starParentView;
@property (nonatomic, strong) UILabel *xc_starTitleLabel;
@property (nonatomic, strong) XCStarView *xc_starView;
@property (nonatomic, strong) UILabel *xc_label;
@end

@implementation GGT_TeachEvaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *GGT_TeachEvaCellID = NSStringFromClass([self class]);
    GGT_TeachEvaCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_TeachEvaCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_TeachEvaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_TeachEvaCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
        
        
        
        [self initView];
        [self masView];
        self.frame = CGRectMake(0, 0, 0, self.xc_contentView.bottom);
        self.backgroundColor = [UIColor purpleColor];
        self.xc_contentView.backgroundColor = [UIColor orangeColor];
        
        
    }
    return self;
}

- (void)initView
{
    self.xc_contentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self addSubview:self.xc_contentView];
    
    self.xc_starParentView = ({
        UIView *view = [UIView new];
        view;
    });
    [self.xc_contentView addSubview:self.xc_starParentView];
    
    self.xc_starTitleLabel = ({
        UILabel *xc_starNameLabel = [UILabel new];
        xc_starNameLabel.text = @"外教点评：";
        xc_starNameLabel.textColor = UICOLOR_FROM_HEX(Color6F6F6F);
        xc_starNameLabel.font = Font(12);
        xc_starNameLabel;
    });
    [self.xc_starParentView addSubview:self.xc_starTitleLabel];
    
    self.xc_starView = ({
        XCStarView *xc_starView = [[XCStarView alloc] initWithEmptyImage:@"dianping_kebiao_da_wei" StarImage:@"dianping_kebiao_da_yi" totalStarCount:5 selectedStatCount:2 starMargin:LineW(11) starWidth:LineW(11)];
        xc_starView;
    });
    [self.xc_starParentView addSubview:self.xc_starView];
    
    
    self.xc_label = ({
        
        UILabel *xc_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        xc_label.font = Font(16);
        xc_label.textColor = UICOLOR_FROM_HEX(Color777777);
        
        xc_label.numberOfLines = 0;
        xc_label.text = @"1";
        xc_label.preferredMaxLayoutWidth = SCREEN_WIDTH();
        xc_label;
    });
    [self.xc_contentView addSubview:self.xc_label];
    
    [self.xc_label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    
}

- (void)masView
{
    // 底部 外教点评
    [self.xc_starTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_starParentView.mas_left);
        make.centerY.equalTo(self.xc_starParentView);
    }];
    
    [self.xc_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_starTitleLabel.mas_right).offset(LineW(margin5));
        make.centerY.equalTo(self.xc_starTitleLabel);
        make.height.equalTo(@(self.xc_starView.height));
        make.width.equalTo(@(self.xc_starView.width));
    }];
    
    [self.xc_starParentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_contentView.mas_left).offset(LineW(margin20));
        make.right.equalTo(self.xc_starView.mas_right);
        make.top.equalTo(self.xc_contentView).offset(margin20);
        make.height.equalTo(@(margin30));
    }];
    
    [self.xc_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_contentView).offset(margin20);
        make.right.equalTo(self.xc_contentView).offset(-margin20);
        make.top.equalTo(self.xc_starParentView.mas_bottom).offset(margin10);
    }];
    
    [self.xc_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(margin10);
        make.right.equalTo(self).offset(-margin10);
        make.bottom.equalTo(@(self.xc_label.bottom));
    }];
    
    [self layoutIfNeeded];
    
}


@end

//
//  GGT_PopoverCell.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/18.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PopoverCell.h"

@interface GGT_PopoverCell ()
@property (nonatomic, strong) UILabel *xc_titleLabel;
@end

@implementation GGT_PopoverCell

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
    NSString *GGT_PopoverCellID = NSStringFromClass([self class]);
    GGT_PopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:GGT_PopoverCellID forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[GGT_PopoverCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GGT_PopoverCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UICOLOR_FROM_RGB_ALPHA(255, 255, 255, 0.8);
        [self configView];
    }
    return self;
}

- (void)configView
{
    self.xc_titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = UICOLOR_FROM_HEX(Color1A1A1A);
        label.font = Font(18);
        label;
    });
    [self addSubview:self.xc_titleLabel];
    
    [self.xc_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(margin30));
        make.centerY.equalTo(self);
    }];
}

- (void)setXc_name:(NSString *)xc_name
{
    _xc_name = xc_name;
    self.xc_titleLabel.text = xc_name;
}

@end

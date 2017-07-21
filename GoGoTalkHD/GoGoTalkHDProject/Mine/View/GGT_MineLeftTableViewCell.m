//
//  GGT_MineLeftTableViewCell.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/16.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineLeftTableViewCell.h"

@implementation GGT_MineLeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initView];
    }
    return self;
}
-(void)setIconName:(NSString *)iconName
{
    _iconName = iconName;
    self.iconImgView.image = UIIMAGE_FROM_NAME(self.iconName);
}
- (void)initView {
    self.iconImgView = [[UIImageView alloc]init];
    self.iconImgView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:self.iconImgView];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(LineX(31));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(25), LineH(25)));
    }];
    
    
    self.leftTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.leftTitleLabel];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).with.offset(LineX(10));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(25);
    }];
    
    //剩余课时
    self.leftSubTitleLabel = [[UILabel alloc]init];
    self.leftSubTitleLabel.font = Font(14);
    self.leftSubTitleLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    [self.contentView addSubview:self.leftSubTitleLabel];
    
    [self.leftSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-LineX(21));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(LineH(20));
    }];

    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.height.mas_offset(LineH(1));
    }];

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  GGT_MineClassTableViewCell.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/16.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineClassTableViewCell.h"

@implementation GGT_MineClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initView];
    }
    return self;
}

- (void)initView {
    self.leftTitleLabel = [[UILabel alloc]init];
    self.leftTitleLabel.font = Font(18);
    self.leftTitleLabel.textColor = UICOLOR_FROM_HEX(0x3D3D3D);
    [self.contentView addSubview:self.leftTitleLabel];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(LineX(20));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(LineH(25));
    }];
    
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    self.contentLabel.font = Font(16);
    [self.contentView addSubview:self.contentLabel];

    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitleLabel.mas_right).with.offset(LineX(15));
        make.right.equalTo(self.contentView.mas_right).with.offset(-LineX(21));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(LineH(22));
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

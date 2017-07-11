//
//  GGT_SelectCoursewareViewCell.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/11.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_SelectCoursewareViewCell.h"

@implementation GGT_SelectCoursewareViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        
        
        
        [self initCellView];
        
    }
    return self;
}

- (void)initCellView {
    //课件名称
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"Get Ready 1-09";
    self.titleLabel.font = Font(16);
    self.titleLabel.textColor = UICOLOR_FROM_HEX(Color333333);
    [self.contentView addSubview:self.titleLabel];
    

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(LineX(15));
        make.right.equalTo(self.contentView.mas_right).with.offset(-LineW(50));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(LineW(18));
    }];
    
    
    //图片
    self.selectedImgView = [[UIImageView alloc]init];
    self.selectedImgView.image = UIIMAGE_FROM_NAME(@"xuanzhong_xuanzhekejian");
    [self.contentView addSubview:self.selectedImgView];
    
    
    [self.selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-LineW(15));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(LineW(19), LineW(19)));
    }];
    
    
    //底部的分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(LineX(10));
        make.right.equalTo(self.contentView.mas_right).with.offset(-0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-0);;
        make.height.mas_offset(LineW(0.5));
    }];
    
    
    
}


@end

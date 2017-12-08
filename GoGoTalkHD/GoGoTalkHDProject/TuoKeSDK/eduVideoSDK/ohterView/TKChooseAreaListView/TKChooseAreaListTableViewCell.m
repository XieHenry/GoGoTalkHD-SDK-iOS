//
//  TKChooseAreaListTableViewCell.m
//  EduClassPad
//
//  Created by tom555cat on 2017/11/18.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKChooseAreaListTableViewCell.h"
#import "TKMacro.h"

@interface TKChooseAreaListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;

@end

@implementation TKChooseAreaListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor             = [UIColor clearColor];
    self.areaNameLabel.font = TEXT_FONT;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAreaName:(NSString *)areaName {
    self.areaNameLabel.text = areaName;
}

- (void)setChoosed:(BOOL)choosed {
    if (choosed == YES) {
        //[self.checkBoxImageView setImage:LOADIMAGE(@"icon_selected")];
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        //[self.checkBoxImageView setImage:LOADIMAGE(@"icon_unselected")];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
}

@end

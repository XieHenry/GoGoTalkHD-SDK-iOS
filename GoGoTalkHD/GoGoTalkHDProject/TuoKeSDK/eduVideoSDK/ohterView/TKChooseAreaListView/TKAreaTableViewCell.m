//
//  TKAreaTableViewCell.m
//  EduClassPad
//
//  Created by tom555cat on 2017/11/28.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKAreaTableViewCell.h"
#import "TKMacro.h"

@implementation TKAreaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor             = [UIColor clearColor];
        self.textLabel.font = TITLE_FONT;
        self.textLabel.textColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAreaName:(NSString *)areaName {
    self.textLabel.text = areaName;
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

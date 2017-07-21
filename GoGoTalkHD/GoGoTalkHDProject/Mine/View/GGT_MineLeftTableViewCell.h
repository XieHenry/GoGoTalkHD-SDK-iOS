//
//  GGT_MineLeftTableViewCell.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/16.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_MineLeftTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *leftTitleLabel;

@property (nonatomic, strong) UILabel *leftSubTitleLabel;  //剩余课时

@property (nonatomic, strong) NSString *iconName;
@end

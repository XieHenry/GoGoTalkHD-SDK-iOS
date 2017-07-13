//
//  GGT_OrderForeignListCell.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
//暂无数据的提醒
#import "GGT_NoMoreDateAlertView.h"


@interface GGT_OrderForeignListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

//预约按钮
@property (nonatomic, strong) UIButton *xc_orderButton;

@end

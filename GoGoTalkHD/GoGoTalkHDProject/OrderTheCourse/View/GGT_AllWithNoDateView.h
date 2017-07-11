//
//  GGT_AllWithNoDateView.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/6/23.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
//暂无数据的提醒
#import "GGT_NoMoreDateAlertView.h"

#import "OrderTimeTagsView.h"

@interface GGT_AllWithNoDateView : UIView

//预约时间的小标签
@property (nonatomic, strong) OrderTimeTagsView *tagsView;

@end

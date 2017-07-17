//
//  GGT_DetailsOfTeacherViewController.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "BaseViewController.h"

//这个是刷新关注的状态
typedef void(^RefreshCellBlick)(NSString *statusStr);

//如果是预约了课程，需要刷新全部的数据
typedef void(^RefreshLoadDataBlock)(BOOL isYes);


@interface GGT_DetailsOfTeacherViewController : BaseViewController

@property (nonatomic, strong) GGT_HomeTeachModel *pushModel;

@property (nonatomic, copy) RefreshCellBlick refreshCellBlick;
@property (nonatomic, copy) RefreshLoadDataBlock refreshLoadDataBlock;
@end

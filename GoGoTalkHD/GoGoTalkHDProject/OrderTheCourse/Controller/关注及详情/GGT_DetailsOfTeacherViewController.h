//
//  GGT_DetailsOfTeacherViewController.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RefreshCellBlick)(NSString *statusStr);
@interface GGT_DetailsOfTeacherViewController : BaseViewController

@property (nonatomic, strong) GGT_HomeTeachModel *pushModel;

@property (nonatomic, copy) RefreshCellBlick refreshCellBlick;
@end

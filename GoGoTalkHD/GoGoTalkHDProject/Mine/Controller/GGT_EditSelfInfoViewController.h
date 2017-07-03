//
//  GGT_EditSelfInfoViewController.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/23.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "BaseViewController.h"
#import "GGT_SelfInfoModel.h"

typedef void(^SaveButtonClickBlock)(NSString *FieldText);
@interface GGT_EditSelfInfoViewController : BaseViewController

//title
@property (nonatomic, copy) NSString *titleStr;

//获取的model
@property (nonatomic, strong) GGT_SelfInfoModel *getModel;

@property (nonatomic, copy) SaveButtonClickBlock buttonClickBlock;

@end

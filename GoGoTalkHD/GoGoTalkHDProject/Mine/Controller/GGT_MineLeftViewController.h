//
//  GGT_MineLeftViewController.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RefreshLoadData)(BOOL is);
@interface GGT_MineLeftViewController : BaseViewController

@property (nonatomic, copy) RefreshLoadData refreshLoadData;

-(void)refreshLodaData;

@end

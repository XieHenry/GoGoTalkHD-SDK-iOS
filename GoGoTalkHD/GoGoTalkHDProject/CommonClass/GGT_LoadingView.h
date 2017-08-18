//
//  GGT_LoadingView.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/8/18.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoadingFailedBlock) (UIButton *button);

@interface GGT_LoadingView : UIView

@property (nonatomic, copy) LoadingFailedBlock loadingFailedBlock;

- (void)hideLoadingView;


@end

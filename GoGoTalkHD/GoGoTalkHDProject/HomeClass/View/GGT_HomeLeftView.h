//
//  GGT_HomeLeftView.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XCButtonClickBlock)(UIButton *button);

@interface GGT_HomeLeftView : UIView

@property (nonatomic, copy) XCButtonClickBlock buttonClickBlock;

//课表和我的view
@property (nonatomic,strong) UIView *optionsView;

@end

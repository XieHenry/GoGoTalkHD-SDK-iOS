//
//  TKNONetWorkView.h
//  whiteBoardDemo
//
//  Created by ifeng on 2017/3/6.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^bReconnectionBlock)(UIButton *aReconnectionBlockButton);

@interface TKNONetWorkView : UIView
-(instancetype)initWithFrame:(CGRect)frame withReconctionBlock:(bReconnectionBlock)bReconnectionBlock;
@property (nonatomic,copy)bReconnectionBlock bReconnectionButtonClick;

@property (nonatomic,copy)UIButton * aReconnectionButton;


@end

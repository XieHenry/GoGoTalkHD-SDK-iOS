//
//  GGT_EvaluateView.h
//  GoGoTalk
//
//  Created by 辰 on 2017/5/8.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCStarView.h"


@interface GGT_EvaluateView : UIView

@property (nonatomic, assign) NSInteger selectCount;

@property (nonatomic, strong) XCStarView *xc_starView;

- (instancetype)initWithTitle:(NSString *)title evaluateArray:(NSArray *)evaluateArray selectCount:(NSInteger)selectCount;

@end

//
//  UICollectionView+XCPlaceholderView.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/7.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (XCPlaceholderView)

/**
 是否启用 启动后无数据的时候展示站位图
 */
@property (nonatomic, assign) BOOL enablePlaceHolderView;

/**
 自定义站位图只需赋值给这个view,如无需自定义忽略此属性
 */
@property (nonatomic, strong) UIView *xc_PlaceHolderView;

@end

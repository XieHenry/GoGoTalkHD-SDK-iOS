//
//  GGT_OrderTimeTableView.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_OrderTimeCollectionViewCell.h"

@interface GGT_OrderTimeTableView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>


//UICollectionView----选择时间的控件
@property (nonatomic, strong) UICollectionView *collectionView;
//承载日期和周几的UIScrollView
@property (nonatomic, strong) UIScrollView *headerScrollerView;
//承载UICollectionView的UIScrollView
@property (nonatomic, strong) UIScrollView *bgScrollerView;
//日期的数据
@property (nonatomic, strong) NSMutableArray *yearsArray;
//周几的数据
@property (nonatomic, strong) NSMutableArray *weeksArray;
//自定义时间
@property (nonatomic, strong) NSArray *alltimeArray;
//展示多少天的数据
@property (nonatomic, assign) NSInteger sectionRow;




@end

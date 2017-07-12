//
//  GGT_OrderCourseLeftView.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_OrderCourseLeftView : UIView

//xx月xx日
@property (nonatomic, strong) UICollectionView *dayCollectionView;
@property (nonatomic, strong) NSMutableArray *dayArray;



//几点
@property (nonatomic, strong) UICollectionView *timeCollectionView;
@property (nonatomic, strong) NSMutableArray *timeArray;


@end




/*UICollectionView*/
@interface CollectionTimeView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *lastIndex;
@end


/*UICollectionViewCell*/
@interface SelectCollectionView : UICollectionViewCell
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekLabel;

-(void)getCellDic:(NSDictionary *)dic;

@end

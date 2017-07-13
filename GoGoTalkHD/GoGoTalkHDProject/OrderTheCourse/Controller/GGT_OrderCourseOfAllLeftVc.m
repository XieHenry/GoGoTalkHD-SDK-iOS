//
//  GGT_OrderCourseOfAllLeftVc.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderCourseOfAllLeftVc.h"
//#import "GGT_OrderCourseLeftView.h"
#import "GGT_DateCollectionCell.h"
#import "GGT_TimeCollectionCell.h"
#import "GGT_DateAndTimeHeaderView.h"

static CGFloat const xc_viewWidth = 350.0f;
static CGFloat const xc_collectionViewMargin = 9.0f;
static CGFloat const xc_cellWidth = (xc_viewWidth-xc_collectionViewMargin*2)/4.0;
static CGFloat const xc_topCellHeight = 112/2.0;
static CGFloat const xc_bottomCellHeight = 74/2.0;
static CGFloat const xc_collectionHeaderHeight = 50.0f;
static CGFloat const xc_collectionFooterHeight = 35.0f/2;
static CGFloat const xc_topCollectionViewHeight = 324.0f/2;

@interface GGT_OrderCourseOfAllLeftVc ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *xc_topCollectionView;
@property (nonatomic, strong) UICollectionView *xc_bottomCollectionView;
@property (nonatomic, strong) NSMutableArray *xc_dateMuArray;
@property (nonatomic, strong) NSMutableArray *xc_timeMuArray;
@end

@implementation GGT_OrderCourseOfAllLeftVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.splitViewController.maximumPrimaryColumnWidth = LineW(xc_viewWidth); //可以修改屏幕的宽度
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.48;
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
//    [self initView];
    
    [self buildData];
//    [self buildUI];
    [self buildUI1];
}

- (void)buildData
{
    // i=1当前选中 i=0不可选 其他都可选
    self.xc_dateMuArray = [NSMutableArray array];
    self.xc_timeMuArray = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        NSDictionary *dic = @{@"date":[NSString stringWithFormat:@"08月0%d日", i], @"time":@"09:56", @"type":@(i)};
        
        GGT_TestModel *model = [GGT_TestModel yy_modelWithDictionary:dic];
        [self.xc_dateMuArray addObject:model];
    }
    
    for (int i = 0; i < 100; i++) {
        NSDictionary *dic = @{@"time":[NSString stringWithFormat:@"%d:00", i],@"type":@(i)};
        GGT_TestModel *model = [GGT_TestModel yy_modelWithDictionary:dic];
        [self.xc_timeMuArray addObject:model];
    }
}


- (void)buildUI1
{
    UICollectionViewFlowLayout *xc_topLayout = [[UICollectionViewFlowLayout alloc] init];
    xc_topLayout.itemSize = CGSizeMake(xc_cellWidth, xc_topCellHeight);
    xc_topLayout.minimumLineSpacing = 0;
    xc_topLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.xc_topCollectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:xc_topLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.alwaysBounceVertical = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        collectionView;
    });
    [self.view addSubview:self.xc_topCollectionView];
    
    [self.xc_topCollectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(xc_collectionViewMargin);
        make.right.equalTo(self.view).offset(-xc_collectionViewMargin);
        make.height.equalTo(@(xc_topCollectionViewHeight));
    }];
    
    
    UICollectionViewFlowLayout *xc_bottomLayout = [[UICollectionViewFlowLayout alloc] init];
    xc_bottomLayout.itemSize = CGSizeMake(xc_cellWidth, xc_bottomCellHeight);
    xc_bottomLayout.minimumLineSpacing = 0;
    xc_bottomLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.xc_bottomCollectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:xc_bottomLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.alwaysBounceVertical = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        collectionView;
    });
    [self.view addSubview:self.xc_bottomCollectionView];
    
    [self.xc_bottomCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topCollectionView.mas_bottom);
        make.left.right.equalTo(self.xc_topCollectionView);
        make.bottom.equalTo(self.view);
    }];
    
    // 注册xc_topCollectionView
    [self.xc_topCollectionView registerClass:[GGT_DateCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([GGT_DateCollectionCell class])];
    [self.xc_topCollectionView  registerClass:[GGT_DateAndTimeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([GGT_DateAndTimeHeaderView class])];
    
    
    // 注册xc_bottomCollectionView
    [self.xc_bottomCollectionView registerClass:[GGT_TimeCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([GGT_TimeCollectionCell class])];
    [self.xc_bottomCollectionView  registerClass:[GGT_DateAndTimeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([GGT_DateAndTimeHeaderView class])];
    [self.xc_bottomCollectionView  registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];

    [self.view layoutIfNeeded];
    
}

// 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.xc_topCollectionView) {
        return 1;
    } else {
        return 1;
    }
}

// 每组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.xc_topCollectionView) {
        return self.xc_dateMuArray.count;
    } else {
        return self.xc_timeMuArray.count;
    }
}

// 设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.xc_topCollectionView) {
        return CGSizeMake(xc_cellWidth, xc_topCellHeight);
    } else {
        return CGSizeMake(xc_cellWidth, xc_bottomCellHeight);
    }
}

//返回行内部cell（item）之间的距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//返回行间距 上下间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.xc_topCollectionView) {
        GGT_DateCollectionCell *cell = [GGT_DateCollectionCell cellWithCollectionView:collectionView indexPath:indexPath];
        cell.xc_model = self.xc_dateMuArray[indexPath.row];
        
        GGT_TestModel *model = self.xc_dateMuArray[indexPath.row];
        if (model.type == 1) {
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        return cell;
    }
    if (collectionView == self.xc_bottomCollectionView) {
        GGT_TimeCollectionCell *cell = [GGT_TimeCollectionCell cellWithCollectionView:collectionView indexPath:indexPath];
        cell.xc_model = self.xc_timeMuArray[indexPath.row];
        
        GGT_TestModel *model = self.xc_timeMuArray[indexPath.row];
        if (model.type == 1) {
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        return cell;
    }
    return nil;
}

// 设置header和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
        GGT_DateAndTimeHeaderView *headerView = [GGT_DateAndTimeHeaderView headerWithCollectionView:collectionView indexPath:indexPath];
        return headerView;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        return footerView;
    }
}

// collectionView的footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (collectionView == self.xc_topCollectionView) {
        return CGSizeZero;
    } else {
        return CGSizeMake(0, xc_collectionFooterHeight);
    }
}

// collectionView的header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (collectionView == self.xc_topCollectionView) {
        return CGSizeMake(0, xc_collectionHeaderHeight);
    } else {
        if (section == 0) {
            return CGSizeMake(0, xc_collectionHeaderHeight);
        } else {
            return CGSizeZero;
        }
    }
}

// 将要选中状态
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.xc_topCollectionView) {
        GGT_TestModel *model = self.xc_dateMuArray[indexPath.row];
        if (model.type == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    
    if (collectionView == self.xc_bottomCollectionView) {
        GGT_TestModel *model = self.xc_timeMuArray[indexPath.row];
        if (model.type == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

// 选中cell的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.xc_topCollectionView) {
        GGT_TestModel *model = self.xc_dateMuArray[indexPath.row];
        model.type = 1;
        GGT_DateCollectionCell *cell = (GGT_DateCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.xc_model = model;
        [collectionView reloadData];
    }
    
    if (collectionView == self.xc_bottomCollectionView) {
        GGT_TestModel *model = self.xc_timeMuArray[indexPath.row];
        model.type = 1;
        GGT_TimeCollectionCell *cell = (GGT_TimeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.xc_model = model;
        [self.xc_timeMuArray replaceObjectAtIndex:indexPath.row withObject:model];
        [collectionView reloadData];
    }
}

// 取消选中cell的时候
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.xc_topCollectionView) {
        GGT_TestModel *model = self.xc_dateMuArray[indexPath.row];
        model.type = 2;
        GGT_DateCollectionCell *cell = (GGT_DateCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.xc_model = model;
        [self.xc_dateMuArray replaceObjectAtIndex:indexPath.row withObject:model];
    }
    if (collectionView == self.xc_bottomCollectionView) {
        GGT_TestModel *model = self.xc_timeMuArray[indexPath.row];
        model.type = 2;
        GGT_TimeCollectionCell *cell = (GGT_TimeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.xc_model = model;
        [self.xc_timeMuArray replaceObjectAtIndex:indexPath.row withObject:model];
    }
}

@end
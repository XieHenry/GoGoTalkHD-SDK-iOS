//
//  GGT_OrderCourseOfAllLeftVc.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderCourseOfAllLeftVc.h"
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
static CGFloat const xc_topCollectionViewHeight = 274.0f;

@interface GGT_OrderCourseOfAllLeftVc ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *xc_topCollectionView;
@property (nonatomic, strong) UICollectionView *xc_bottomCollectionView;
@property (nonatomic, strong) NSMutableArray *xc_dateMuArray;
//@property (nonatomic, strong) NSMutableArray *xc_timeMuArray;

@property (nonatomic, strong) NSMutableArray *xc_timeTopMuArray;
@property (nonatomic, strong) NSMutableArray *xc_timeMiddleMuArray;
@property (nonatomic, strong) NSMutableArray *xc_timeBottomMuArray;

@property (nonatomic, strong) GGT_HomeDateModel *xc_dateModel;
@property (nonatomic, strong) GGT_HomeTimeModel *xc_timeModel;

@end

@implementation GGT_OrderCourseOfAllLeftVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.splitViewController.maximumPrimaryColumnWidth = LineW(xc_viewWidth); //可以修改屏幕的宽度
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.48;
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
//    [self initView];
    
    [self buildData];

    [self buildUI];
    
    [self xc_loadData];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xc_refreshData) name:kEnterForeground object:nil];
}

- (void)xc_refreshData
{
    [self.xc_dateMuArray removeAllObjects];
    [self xc_loadData];
}



- (void)buildData
{
    self.xc_dateMuArray = [NSMutableArray array];
    
    self.xc_timeTopMuArray = [NSMutableArray array];
    self.xc_timeMiddleMuArray = [NSMutableArray array];
    self.xc_timeBottomMuArray = [NSMutableArray array];
}


- (void)buildUI
{
    UICollectionViewFlowLayout *xc_topLayout = [[UICollectionViewFlowLayout alloc] init];
    xc_topLayout.itemSize = CGSizeMake(xc_cellWidth, xc_topCellHeight);
    xc_topLayout.minimumLineSpacing = 0;
    xc_topLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.xc_topCollectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:xc_topLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
//        collectionView.alwaysBounceVertical = YES;
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

// 获取上部日期数据
- (void)xc_loadData
{
    [[BaseService share] sendGetRequestWithPath:URL_GetDate token:YES viewController:self success:^(id responseObject) {
       
        NSArray *dataArray = responseObject[@"data"];
        if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0) {
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_HomeDateModel *model = [GGT_HomeDateModel yy_modelWithDictionary:obj];
                [self.xc_dateMuArray addObject:model];
                
                if (model.isHaveClass == XCDateSelectOrder) {
                    [self xc_loadTimeDataWithDate:model.date];
                    self.xc_dateModel = model;
                }
                
            }];
        }
        
        [self.xc_topCollectionView reloadData];
        
        if (self.refreshLoadData) {
            self.refreshLoadData(YES);
        }
        
    } failure:^(NSError *error) {
        GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
        if (sin.netStatus == NO) {
            if (self.refreshLoadData) {
                self.refreshLoadData(NO);
            }
            
        }
    }];
}

// 获取下部时间数据
- (void)xc_loadTimeDataWithDate:(NSString *)date
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?date=%@", URL_GetTime, date];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        
        [self.xc_timeTopMuArray removeAllObjects];
        [self.xc_timeMiddleMuArray removeAllObjects];
        [self.xc_timeBottomMuArray removeAllObjects];
        
        NSDictionary *dataDic = responseObject[@"data"];
        if ([dataDic isKindOfClass:[NSDictionary class]]) {
            
            // dataDic字典中中存放着三个数组
            // buttomList centerList topList
            
            NSArray *topList = dataDic[@"topList"];
            [topList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_HomeTimeModel *model = [GGT_HomeTimeModel yy_modelWithDictionary:obj];
                [self.xc_timeTopMuArray addObject:model];
                if (model.pic == XCTimeSelectOrder) {
                    self.xc_timeModel = model;
                }
            }];
            
            NSArray *centerList = dataDic[@"centerList"];
            [centerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_HomeTimeModel *model = [GGT_HomeTimeModel yy_modelWithDictionary:obj];
                [self.xc_timeMiddleMuArray addObject:model];
                if (model.pic == XCTimeSelectOrder) {
                    self.xc_timeModel = model;
                }
            }];
            
            NSArray *buttomList = dataDic[@"buttomList"];
            [buttomList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GGT_HomeTimeModel *model = [GGT_HomeTimeModel yy_modelWithDictionary:obj];
                [self.xc_timeBottomMuArray addObject:model];
                if (model.pic == XCTimeSelectOrder) {
                    self.xc_timeModel = model;
                }
            }];
        }
        
        [self.xc_bottomCollectionView reloadData];
        
        // 传送数据到右侧界面
        if ([self.delegate respondsToSelector:@selector(leftSendToRightDate:time:)]) {
            [self.delegate leftSendToRightDate:self.xc_dateModel.date time:self.xc_timeModel.name];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

// 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.xc_topCollectionView) {
        return 1;
    } else {
        return 3;
    }
}

// 每组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.xc_topCollectionView) {
        return self.xc_dateMuArray.count;
    } else {
//        return self.xc_timeMuArray.count;
        if (section == 0) {
            return self.xc_timeTopMuArray.count;
        }
        if (section == 1) {
            return self.xc_timeMiddleMuArray.count;
        }
        if (section == 2) {
            return self.xc_timeBottomMuArray.count;
        }
        return 0;
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
        
        GGT_HomeDateModel *model = self.xc_dateMuArray[indexPath.row];
        if (model.isHaveClass == XCDateSelectOrder) {
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        return cell;
        
    } else if (collectionView == self.xc_bottomCollectionView) {
        GGT_TimeCollectionCell *cell = [GGT_TimeCollectionCell cellWithCollectionView:collectionView indexPath:indexPath];
        
        GGT_HomeTimeModel *model = nil;
        if (indexPath.section == 0) {
            model = self.xc_timeTopMuArray[indexPath.row];
        }
        if (indexPath.section == 1) {
            model = self.xc_timeMiddleMuArray[indexPath.row];
        }
        if (indexPath.section == 2) {
            model = self.xc_timeBottomMuArray[indexPath.row];
        }
        
        cell.xc_model = model;
    
        if (model.pic == XCTimeSelectOrder) {
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        return cell;
        
    } else {
        
        NSLog(@"解决内存泄漏--Some exception message for unexpected tableView");
        abort();
    }
}

// 设置header和footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
        GGT_DateAndTimeHeaderView *headerView = [GGT_DateAndTimeHeaderView headerWithCollectionView:collectionView indexPath:indexPath];
        if (collectionView == self.xc_topCollectionView) {
            headerView.xc_titleLabel.text = @"日期";
        } else {
            headerView.xc_titleLabel.text = @"时间";
        }
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
        GGT_HomeDateModel *model = self.xc_dateMuArray[indexPath.row];
        if (model.isHaveClass == XCDateDoNotOrder) {
            return NO;
        } else {
            return YES;
        }
    }
    
    if (collectionView == self.xc_bottomCollectionView) {
        
        GGT_HomeTimeModel *model = nil;
        if (indexPath.section == 0) {
            model = self.xc_timeTopMuArray[indexPath.row];
        }
        if (indexPath.section == 1) {
            model = self.xc_timeMiddleMuArray[indexPath.row];
        }
        if (indexPath.section == 2) {
            model = self.xc_timeBottomMuArray[indexPath.row];
        }
        
        if (model.pic == XCTimeDoNotOrder) {
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
        GGT_HomeDateModel *model = self.xc_dateMuArray[indexPath.row];
        model.isHaveClass = XCDateSelectOrder;
//        GGT_DateCollectionCell *cell = (GGT_DateCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.xc_model = model;
        [collectionView reloadData];
        
        
        // 选中上面的cell时 要刷新下面数据 请求接口
        [self xc_loadTimeDataWithDate:model.date];
        
        self.xc_dateModel = model;
        
    }
    
    if (collectionView == self.xc_bottomCollectionView) {
        
        GGT_HomeTimeModel *model = nil;
        if (indexPath.section == 0) {
            model = self.xc_timeTopMuArray[indexPath.row];
        }
        if (indexPath.section == 1) {
            model = self.xc_timeMiddleMuArray[indexPath.row];
        }
        if (indexPath.section == 2) {
            model = self.xc_timeBottomMuArray[indexPath.row];
        }
        
        model.pic = XCTimeSelectOrder;
        
//        GGT_TimeCollectionCell *cell = (GGT_TimeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.xc_model = model;
        
        if (indexPath.section == 0) {
            [self.xc_timeTopMuArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
        if (indexPath.section == 1) {
            [self.xc_timeMiddleMuArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
        if (indexPath.section == 2) {
            [self.xc_timeBottomMuArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
        
        [collectionView reloadData];
        
        self.xc_timeModel = model;
        
        // 传送数据
        if ([self.delegate respondsToSelector:@selector(leftSendToRightDate:time:)]) {
            [self.delegate leftSendToRightDate:self.xc_dateModel.date time:self.xc_timeModel.name];
        }
    }
    
}

// 取消选中cell的时候
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.xc_topCollectionView) {
        GGT_HomeDateModel *model = self.xc_dateMuArray[indexPath.row];
        model.isHaveClass = XCDateCanOrder;
//        GGT_DateCollectionCell *cell = (GGT_DateCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.xc_model = model;
        [self.xc_dateMuArray replaceObjectAtIndex:indexPath.row withObject:model];
    }
    if (collectionView == self.xc_bottomCollectionView) {
        
        GGT_HomeTimeModel *model = nil;
        if (indexPath.section == 0) {
            model = self.xc_timeTopMuArray[indexPath.row];
        }
        if (indexPath.section == 1) {
            model = self.xc_timeMiddleMuArray[indexPath.row];
        }
        if (indexPath.section == 2) {
            model = self.xc_timeBottomMuArray[indexPath.row];
        }
        
        model.pic = XCTimeCanOrder;
        
//        GGT_TimeCollectionCell *cell = (GGT_TimeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.xc_model = model;
        
        if (indexPath.section == 0) {
            [self.xc_timeTopMuArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
        if (indexPath.section == 1) {
            [self.xc_timeMiddleMuArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
        if (indexPath.section == 2) {
            [self.xc_timeBottomMuArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
    
    }
}

@end

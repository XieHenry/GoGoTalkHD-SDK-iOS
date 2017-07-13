//
//  GGT_OrderTimeTableView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderTimeTableView.h"

@implementation GGT_OrderTimeTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.sectionRow = 7;
        
        [self initDataSource];
        [self initContentView];
        
    }
    return self;
}

#pragma mark 创建顶部数据
- (void)initDataSource {
    
    //对头部的时间数据进行创建
    self.yearsArray = [NSMutableArray array];
    //对头部的周几数据进行创建
    self.weeksArray = [NSMutableArray array];
    
    
    //获取2周的数据
    for (int i = 0; i < self.sectionRow; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        
        //组合时间
        [self.yearsArray addObject:dateStr];
        [self.weeksArray addObject:weekStr];
    }
    
    
    //7天时间 89*7
    _headerScrollerView = [[UIScrollView alloc]init];
    //    _headerScrollerView.contentSize = CGSizeMake(LineW(85)*self.sectionRow,LineH(60));
    _headerScrollerView.scrollEnabled = YES;
    _headerScrollerView.showsVerticalScrollIndicator = NO;
    _headerScrollerView.showsHorizontalScrollIndicator = NO;
    _headerScrollerView.pagingEnabled = NO;
    _headerScrollerView.bounces = NO;
    _headerScrollerView.delegate = self;
    _headerScrollerView.backgroundColor = UICOLOR_FROM_HEX(0xEBEBEB);
    [self addSubview:_headerScrollerView];
    
    [_headerScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.height.mas_offset(LineH(60));
    }];
    
    
    
    for (NSUInteger i =  0; i < self.weeksArray.count; i++) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake((marginFocusOn-LineW(728))/2 +LineW(104)*i, 0, LineW(104), LineH(60))];
        [_headerScrollerView addSubview:headerView];
        
        UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, LineY(15), LineW(104), LineH(15))];
        monthLabel.text = self.yearsArray[i];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.font = Font(12);
        monthLabel.textColor = UICOLOR_FROM_HEX(Color333333);
        [headerView addSubview:monthLabel];

        
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,monthLabel.y+monthLabel.height+LineY(6), LineW(104), LineH(12))];
        weekLabel.text = self.weeksArray[i];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.font = Font(15);
        weekLabel.textColor = UICOLOR_FROM_HEX(Color666666);
        [headerView addSubview:weekLabel];
        
    }
    
}


#pragma mark 创建UICollectionView
- (void)initContentView {
    _bgScrollerView = [[UIScrollView alloc]init];
    _bgScrollerView.contentSize = CGSizeMake(marginFocusOn,31*LineH(42)+LineH(20));
    _bgScrollerView.scrollEnabled = YES;
    _bgScrollerView.showsVerticalScrollIndicator = NO;
    _bgScrollerView.showsHorizontalScrollIndicator = NO;
    _bgScrollerView.pagingEnabled = NO;
    _bgScrollerView.delegate = self;
    _bgScrollerView.bounces = NO;
    _bgScrollerView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self addSubview:_bgScrollerView];
    
    [_bgScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.top.equalTo(_headerScrollerView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0);
    }];
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//     layout.minimumLineSpacing = LineY(5); //上下的间距 可以设置0看下效果
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake((marginFocusOn-LineW(728))/2, 0, LineW(728), 31*LineH(42)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    _collectionView.scrollEnabled = NO;
    [_bgScrollerView addSubview:_collectionView];
    
    
    [_collectionView registerClass:[GGT_OrderTimeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    _alltimeArray = @[@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30"];
    
    
    [_collectionView reloadData];
}


#pragma mark -- UICollectionViewDelegate-------------
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 7;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _alltimeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    GGT_OrderTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (!cell) {
        NSLog(@"-----------------");
    }
    
    cell.timeLabel.text = _alltimeArray[indexPath.row];
//    cell.backgroundColor = UICOLOR_RANDOM_COLOR();
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(84), LineH(32));
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(LineY(5), LineX(10), LineY(5), LineX(10));
  
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return LineY(10);
}


//取消某item
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    NSLog(@"what-%ld---%ld",(long)indexPath.section,(long)indexPath.row);
    
    
    //    GGT_OrderTimeCollectionViewCell * deselectedCell =(GGT_OrderTimeCollectionViewCell *) [_collectionView cellForItemAtIndexPath:indexPath];
    //    deselectedCell.layer.cornerRadius = LineW(0);
    //    deselectedCell.layer.masksToBounds = NO;
    //    deselectedCell.layer.borderColor = [UIColor clearColor].CGColor;
    //    deselectedCell.layer.borderWidth = LineW(0);
    
}

//选中某item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_OrderTimeCollectionViewCell * deselectedCell =(GGT_OrderTimeCollectionViewCell *) [_collectionView cellForItemAtIndexPath:indexPath];
    deselectedCell.layer.cornerRadius = LineW(5);
    deselectedCell.layer.masksToBounds = YES;
    deselectedCell.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
    deselectedCell.layer.borderWidth = LineW(0.5);
    deselectedCell.timeLabel.textColor = UICOLOR_FROM_HEX(ColorC40016);
    
}



-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



@end

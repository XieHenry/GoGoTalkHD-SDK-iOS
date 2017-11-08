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
        
        [self initDataSource];
        [self initContentView];
        
    }
    return self;
}

#pragma mark 创建顶部数据
- (void)initDataSource {

    UIView *headerBgView = [[UIView alloc]init];
    headerBgView.backgroundColor = UICOLOR_FROM_HEX(0xEBEBEB);
    [self addSubview:headerBgView];
    [headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.height.mas_offset(LineH(60));
    }];
    
    
    
    //7天时间 89*7
    _headerScrollerView = [[UIScrollView alloc]init];
        _headerScrollerView.contentSize = CGSizeMake(LineW(728)*2,LineH(60));
    _headerScrollerView.scrollEnabled = YES;
    _headerScrollerView.showsVerticalScrollIndicator = NO;
    _headerScrollerView.showsHorizontalScrollIndicator = NO;
    _headerScrollerView.pagingEnabled = YES;
    _headerScrollerView.bounces = NO;
    _headerScrollerView.delegate = self;
    _headerScrollerView.backgroundColor = UICOLOR_FROM_HEX(0xEBEBEB);
    [self addSubview:_headerScrollerView];
    
    [_headerScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(LineW(104));
        make.right.equalTo(self.mas_right).with.offset(-LineW(104));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.height.mas_offset(LineH(60));
    }];
    
    
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    
    for (NSUInteger i =  0; i < sin.orderCourse_dateMuArray.count; i++) {
        GGT_HomeDateModel *model = [sin.orderCourse_dateMuArray safe_objectAtIndex:i];
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(LineW(104)*i, 0, LineW(104), LineH(60))];
        [_headerScrollerView addSubview:headerView];
        
        UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, LineY(15), LineW(104), LineH(15))];
        monthLabel.text = model.date;
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.font = Font(15);
        monthLabel.textColor = UICOLOR_FROM_HEX(Color333333);
        [headerView addSubview:monthLabel];

        
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,monthLabel.y+monthLabel.height+LineY(6), LineW(104), LineH(12))];
        weekLabel.text = model.week;
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.font = Font(15);
        weekLabel.textColor = UICOLOR_FROM_HEX(Color666666);
        [headerView addSubview:weekLabel];
        
    }
    
}


#pragma mark 创建UICollectionView
- (void)initContentView {
    _bgScrollerView = [[UIScrollView alloc]init];
    _bgScrollerView.scrollEnabled = YES;
    _bgScrollerView.showsVerticalScrollIndicator = NO;
    _bgScrollerView.showsHorizontalScrollIndicator = NO;
    _bgScrollerView.pagingEnabled = YES;
    _bgScrollerView.delegate = self;
    _bgScrollerView.bounces = NO;
    _bgScrollerView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    //更新坐标
    _bgScrollerView.contentSize = CGSizeMake(LineW(728) * 2,(29 * LineH(42)) + LineH(18));
    [self addSubview:_bgScrollerView];
    
    [_bgScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(LineW(104));
        make.right.equalTo(self.mas_right).with.offset(-LineW(104));
        make.top.equalTo(_headerScrollerView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0);
    }];
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    _collectionView.scrollEnabled = NO;
    [_bgScrollerView addSubview:_collectionView];
    [_collectionView registerClass:[GGT_OrderTimeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}


#pragma mark -- UICollectionViewDelegate-------------
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.alltimeArray.count;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.alltimeArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    GGT_OrderTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }

    
    GGT_TimeCollectionModel *model = [[_alltimeArray safe_objectAtIndex:indexPath.section] safe_objectAtIndex:indexPath.row];
    
    
//    isHaveClass 0:不可预约 1：可以预约 2：默认选中
    [cell getTextModel:model];

    
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


//选中某item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"what-%ld---%ld",(long)indexPath.section,(long)indexPath.row);
   
    GGT_TimeCollectionModel *timeCollectionModel = [[_alltimeArray safe_objectAtIndex:indexPath.section] safe_objectAtIndex:indexPath.row];
    
    self.didSelectedPath = [NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section];
    
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    GGT_HomeDateModel *homeDateModel = [sin.orderCourse_dateMuArray safe_objectAtIndex:indexPath.section];

    GGT_OrderTimeCollectionViewCell * deselectedCell =(GGT_OrderTimeCollectionViewCell *) [_collectionView cellForItemAtIndexPath:indexPath];
    deselectedCell.layer.cornerRadius = LineW(5);
    deselectedCell.layer.masksToBounds = YES;
    deselectedCell.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
    deselectedCell.layer.borderWidth = LineW(0);
    deselectedCell.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
    deselectedCell.timeLabel.textColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    
    if (self.orderBlick) {
        self.orderBlick(timeCollectionModel,homeDateModel);
    }
    
    
}

#pragma mark 取消预约---重置颜色
- (void)ClernColor {

    GGT_OrderTimeCollectionViewCell * deselectedCell =(GGT_OrderTimeCollectionViewCell *) [_collectionView cellForItemAtIndexPath:self.didSelectedPath];
    deselectedCell.layer.cornerRadius = LineW(5);
    deselectedCell.layer.masksToBounds = YES;
    deselectedCell.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
    deselectedCell.layer.borderWidth = LineW(0.5);
    deselectedCell.timeLabel.textColor = UICOLOR_FROM_HEX(ColorC40016);
    deselectedCell.backgroundColor = [UIColor clearColor];
}

#pragma mark 已经预约---设置不可选中
- (void)orderCourse {
      GGT_OrderTimeCollectionViewCell * deselectedCell =(GGT_OrderTimeCollectionViewCell *) [_collectionView cellForItemAtIndexPath:self.didSelectedPath];
    
    deselectedCell.layer.cornerRadius = 0;
    deselectedCell.layer.masksToBounds = NO;
    deselectedCell.layer.borderColor = [UIColor clearColor].CGColor;
    deselectedCell.layer.borderWidth = 0;
    deselectedCell.timeLabel.textColor = UICOLOR_FROM_HEX(ColorCCCCCC);
    deselectedCell.backgroundColor = [UIColor clearColor];
    deselectedCell.lineView.hidden = NO;
    deselectedCell.userInteractionEnabled = NO;
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

#pragma mark 获取数据
- (void)getCellArr:(NSMutableArray *)dataArray {
    self.alltimeArray =  [NSMutableArray array];
//    _alltimeArray = @[@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00"];
    
    
    self.alltimeArray = dataArray;

    //更新坐标
    NSInteger count = [[self.alltimeArray safe_objectAtIndex:0] count];
    _bgScrollerView.contentSize = CGSizeMake(LineW(728) * 2,(count * LineH(42)) + LineH(18));
    _collectionView.frame = CGRectMake(0, LineY(8), LineW(728) *2,(count * LineH(42)));
    
    [_collectionView reloadData];

}

//设置两个UIScrollView联动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(scrollView == self.headerScrollerView) {
        
        CGFloat offsetY = self.headerScrollerView.contentOffset.x;
        CGPoint offset = self.bgScrollerView.contentOffset;
        offset.x = offsetY;
        self.bgScrollerView.contentOffset = offset;
        
        
    } else {
        CGFloat offsetY = self.bgScrollerView.contentOffset.x;
        CGPoint offset = self.headerScrollerView.contentOffset;
        offset.x = offsetY;
        self.headerScrollerView.contentOffset = offset;
        
    }
    
}


- (void)tableView:(UITableView *)tableView scrollFollowTheOther:(UITableView *)other{
    CGFloat offsetY= other.contentOffset.y;
    CGPoint offset=tableView.contentOffset;
    offset.y=offsetY;
    tableView.contentOffset=offset;

}


@end


#pragma mark  GGT_OrderTimeCollectionViewCell
@implementation GGT_OrderTimeCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = Font(15);
        [self addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(-0);
            make.top.equalTo(self.mas_top).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(-LineH(2));
        }];
        
        
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UICOLOR_FROM_HEX(ColorC40016);
        [self addSubview:self.lineView];
        self.lineView.hidden = YES;
        
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(-0);
            make.top.equalTo(self.mas_bottom).with.offset(-LineH(2));
            make.height.equalTo(@(LineH(2)));
        }];
    }
    
    return self;
}

- (void)getTextModel:(GGT_TimeCollectionModel *)model {
    
    NSString *statusStr = [NSString stringWithFormat:@"%ld",(long)model.isHaveClass];

    self.timeLabel.text = model.time;
    
    if ([statusStr isEqualToString:@"0"]) {
        self.timeLabel.textColor = UICOLOR_FROM_HEX(ColorCCCCCC);
        self.userInteractionEnabled = NO;
        
    } else if ([statusStr isEqualToString:@"1"]) {
        
        self.layer.cornerRadius = LineW(5);
        self.layer.masksToBounds = YES;
        self.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
        self.layer.borderWidth = LineW(0.5);
        self.timeLabel.textColor = UICOLOR_FROM_HEX(ColorC40016);
        
    } else if ([statusStr isEqualToString:@"2"]) {
        
        self.lineView.hidden = NO;
        self.timeLabel.textColor = UICOLOR_FROM_HEX(ColorCCCCCC);
        self.userInteractionEnabled = NO;
    }

}

@end




//
//  GGT_OrderCourseLeftView.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/11.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_OrderCourseLeftView.h"

@implementation GGT_OrderCourseLeftView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDayView];
        
    }
    
    return self;
}

- (void)initDayView {
    UILabel *dayLabel = [[UILabel alloc]init];
    dayLabel.text = @"日期";
    [self addSubview:dayLabel];
    
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(LineY(20.5));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(LineH(22)));
    }];
    
    
    //0 为可以选中，1为不可点击状态
    CollectionTimeView *dayView = [[CollectionTimeView alloc]init];
    NSArray *dataArray = @[@{@"day":@"07月12日",@"week":@"星期三",@"isSelect":@"1"},@{@"day":@"07月13日",@"week":@"星期四",@"isSelect":@"0"},@{@"day":@"07月14日",@"week":@"星期五",@"isSelect":@"0"},@{@"day":@"07月15日",@"week":@"星期六",@"isSelect":@"1"},@{@"day":@"07月16日",@"week":@"星期日",@"isSelect":@"1"},@{@"day":@"07月17日",@"week":@"星期一",@"isSelect":@"0"},@{@"day":@"07月18日",@"week":@"星期二",@"isSelect":@"0"}];
    dayView.dataArray = (NSMutableArray *)dataArray;
    [self addSubview:dayView];
    
    
    [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dayLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.height.equalTo(@(LineH(154.5)));
    }];
    
    
    
    
    
//    UILabel *timeLabel = [[UILabel alloc]init];
//    timeLabel.text = @"时间";
//    [self addSubview:timeLabel];
//    
//    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(dayView.mas_bottom).with.offset(LineY(40));
//        make.centerX.equalTo(self.mas_centerX);
//        make.height.equalTo(@(LineH(22)));
//    }];
//    
//    
//    CollectionTimeView *timeView = [[CollectionTimeView alloc]init];
//    timeView.dataArray = (NSMutableArray *) @[@"1",@"2",@"3",@"4",@"2",@"3",@"4",@"2",@"3",@"4",@"2",@"3",@"4"];
//    [self addSubview:timeView];
//    
//    
//    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(timeLabel.mas_bottom).with.offset(LineY(20));
//        make.left.equalTo(self.mas_left).with.offset(0);
//        make.right.equalTo(self.mas_right).with.offset(-0);
//        make.height.equalTo(@(LineH(300)));
//    }];
//    
    
}

@end









/*****************************CollectionTimeView***********************************************/
@implementation CollectionTimeView : UIView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      
        [self initView];
        
    }
    
    return self;
}

- (void)initView {
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(LineW(83), LineH(55));
    
    //创建collectionView 通过一个布局策略layout来创建
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    //代理设置
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    //注册item类型 这里使用系统的类型
    [_collectionView registerClass:[SelectCollectionView class] forCellWithReuseIdentifier:@"cellid"];
    [self addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0);
    }];
    
    
//    [self collectionView:_collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
}

#pragma mark 以下是UICollectionView的代理
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectCollectionView * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    //传值
    [cell getCellDic:_dataArray[indexPath.row]];

//    if (indexPath.row == 0) {
//        if ([[_dataArray[indexPath.row] objectForKey:@"isSelect"] isEqualToString:@"0"]) {
//            cell.userInteractionEnabled = NO;
//            cell.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
//        } else {
//            cell.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
//        }
//    }
    
    
    
    return cell;
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

    SelectCollectionView * selectedCell =(SelectCollectionView *) [_collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.backgroundColor = [UIColor clearColor];
    
    
    
//    if ([[_dataArray[indexPath.row] objectForKey:@"isSelect"] isEqualToString:@"1"]) {
//        selectedCell.dayLabel.textColor = UICOLOR_FROM_HEX(ColorCCCCCC);
//        selectedCell.weekLabel.textColor = UICOLOR_FROM_HEX(ColorCCCCCC);
//    } else {
//        selectedCell.dayLabel.textColor = UICOLOR_FROM_HEX(Color333333);
//        selectedCell.weekLabel.textColor = UICOLOR_FROM_HEX(Color333333);
// 
//    }
// 
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    _lastIndex = indexPath;
    SelectCollectionView * selectedCell =(SelectCollectionView *) [_collectionView cellForItemAtIndexPath:indexPath];
   
    //0 为可以选中，1为不可点击状态
    if ([[_dataArray[indexPath.row] objectForKey:@"isSelect"] isEqualToString:@"1"]) {
//        selectedCell.userInteractionEnabled = NO;
        NSLog(@"------无课可预约");
    } else  {
        selectedCell.backgroundColor = UICOLOR_FROM_HEX(kThemeColor);
    }

}

//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake(LineW(83), LineH(55));
}



//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(16, 32, 26,20);
    return UIEdgeInsetsMake(0, 0, 0,0);

}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
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









/*****************************SelectCollectionView***********************************************/
@implementation SelectCollectionView : UICollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        
    }
    
    return self;
}

- (void)initView {
    _dayLabel = [[UILabel alloc]init];
    _dayLabel.font = Font(14);
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.textColor = UICOLOR_FROM_HEX(Color333333);
    [self addSubview:_dayLabel];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(LineH(15)));
    }];
    
    
    
    _weekLabel = [[UILabel alloc]init];
    _weekLabel.font = Font(12);
    _weekLabel.textAlignment = NSTextAlignmentCenter;
    _weekLabel.textColor = UICOLOR_FROM_HEX(Color333333);
    [self addSubview:_weekLabel];
    
    [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dayLabel.mas_bottom).with.offset(LineY(10));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(LineH(15)));
    }];
    
    
}

-(void)getCellDic:(NSDictionary *)dic {
    _dayLabel.text = dic[@"day"];
    _weekLabel.text = dic[@"week"];

     //0 为可以选中，1为不可点击状态
    if ([dic[@"isSelect"] isEqualToString:@"1"]) {
        _dayLabel.textColor = UICOLOR_FROM_HEX(ColorCCCCCC);
        _weekLabel.textColor = UICOLOR_FROM_HEX(ColorCCCCCC);
    }
    
    
    
}


@end





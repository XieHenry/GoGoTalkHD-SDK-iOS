//
//  GGT_OrderCourseOfFocusViewController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/2.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderCourseOfFocusViewController.h"
#import "GGT_FocusOnOfPageScrollView.h"
#import "GGT_FocusOnOfPageView.h"
#import "GGT_DetailsOfTeacherView.h"
#import "GGT_NoMoreDateAlertView.h"

#define magnification 1.15f  //头像放大倍数
#define headPortraitW 62.5f  //头像宽度


@interface GGT_OrderCourseOfFocusViewController () <OTPageScrollViewDataSource,OTPageScrollViewDelegate>

//上面部分头像部分
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) GGT_FocusOnOfPageView *PScrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation GGT_OrderCourseOfFocusViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    
//    GGT_NoMoreDateAlertView *nodataView = [[GGT_NoMoreDateAlertView alloc]init];
//    [nodataView imageString:@"weichuxi" andAlertString:@"您还没有开通课时，开通后即可预约课程！\n 客服电话：400-8787-276"];
//    nodataView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
//    [self.view addSubview:nodataView];
//    
//    [nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).with.offset(0);
//        make.left.equalTo(self.view.mas_left).with.offset(0);
//        make.right.equalTo(self.view.mas_right).with.offset(-80);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(-64);
//    }];
//    
    
    
    
    
    //头部滚动头像
    [self initHeaderView];
    
    //下面的课表模块
    [self initCollectionView];
}


#pragma mark 时间选择
- (void)initCollectionView {
    
    GGT_OrderTimeTableView *orderTimeView = [[GGT_OrderTimeTableView alloc]init];
    orderTimeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderTimeView];
    
    [orderTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(129);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
    }];
    
}

#pragma mark 头部滚动头像
- (void)initHeaderView {
    
    _headerView = [[UIView alloc]init];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH() - home_leftView_width, 124);
    _headerView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.view addSubview:_headerView];

    
    
    _PScrollView = [[GGT_FocusOnOfPageView alloc] initWithFrame:CGRectMake(0, 17, SCREEN_WIDTH() - home_leftView_width, 72)];
    _PScrollView.pageScrollView.dataSource = self;
    _PScrollView.pageScrollView.delegate = self;
    _PScrollView.pageScrollView.padding = 40;
    _PScrollView.pageScrollView.leftRightOffset = 0;
    _PScrollView.pageScrollView.frame = CGRectMake((SCREEN_WIDTH() - home_leftView_width - headPortraitW - 40)/2, 0, headPortraitW + 40, 72); //62.5
    [_headerView addSubview:_PScrollView];
    
    
    _dataArray = [NSMutableArray array];
    _dataArray = [NSMutableArray arrayWithObjects:
                  @"0",
                  @"1",
                  @"2",
                  @"3",
                  @"4",
                  @"5",
                  @"6",
                  @"7",
                  @"8",
                  @"9",
                  @"10",
                  @"11",
                  @"12",
                  @"13",
                  @"14",
                  @"15",
                  @"16",
                  @"17",
                  @"18",
                  @"19",
                  nil];
    [_PScrollView.pageScrollView reloadData];
    
    
    CGSize cellSize=[@"Runsun" boundingRectWithSize:CGSizeMake(800, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font(15)} context:nil].size;
    
    
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake((_headerView.width-cellSize.width-46)/2, 94, cellSize.width + 46, 20)];
    [_headerView addSubview:nameView];
    
    
    
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.frame = CGRectMake(0, 0, cellSize.width, 19);
    self.nameLabel.text = @"Runsun";
    self.nameLabel.textColor = UICOLOR_FROM_HEX(Color333333);
    self.nameLabel.font = Font(15);
    [nameView addSubview:self.nameLabel];
    
    
    UIButton *focusOnBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    focusOnBtn.frame = CGRectMake(self.nameLabel.x+self.nameLabel.width+10, 0,LineW(36), LineH(19));
    [focusOnBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
    focusOnBtn.titleLabel.font = Font(10);
    [focusOnBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
    focusOnBtn.backgroundColor = UICOLOR_FROM_HEX(ColorCCCCCC);
    [focusOnBtn addTarget:self action:@selector(focusOnBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [nameView addSubview:focusOnBtn];
    
    
    
    
}

#pragma mark 关注按钮
- (void)focusOnBtnClick {
    
}



- (NSInteger)numberOfPageInPageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView{
    return [_dataArray count];
}

- (UIView*)pageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView viewForRowAtIndex:(int)index{
    
    UIView *cell = [[UIView alloc] init];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = headPortraitW/2;
    cell.frame = CGRectMake(0, 0, headPortraitW, headPortraitW);
    cell.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    cell.tag = 100 +index;
    
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    iconImgView.image = UIIMAGE_FROM_NAME(@"headPortrait_default_avatar");
    [cell addSubview:iconImgView];

    self.nameLabel.text = self.dataArray[index];
    
    
    return cell;
}


- (CGSize)sizeCellForPageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView {
    return CGSizeMake(headPortraitW, headPortraitW);
}

- (void)pageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index{
    NSLog(@"点击的第 %ld 个头像",index);
    for (int i=0; i<_dataArray.count; i++) {
        UIView *view = [self.view viewWithTag:100 + i];
        view.transform = CGAffineTransformMakeScale(1, 1);
        view.layer.borderColor = [UIColor clearColor].CGColor;
        view.layer.borderWidth = 0;
    }
    
    
    UIView *view = [self.view viewWithTag:100 + index];
    view.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
    view.layer.borderWidth = 1;
    view.transform = CGAffineTransformMakeScale(magnification,magnification);
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSLog(@"滑动的第 %ld 个头像",index);
    
    for (int i=0; i<_dataArray.count; i++) {
        UIView *view = [self.view viewWithTag:100 + i];
        view.layer.borderColor = [UIColor clearColor].CGColor;
        view.layer.borderWidth = 0;
        view.transform = CGAffineTransformMakeScale(1, 1);
    }
    
    
    UIView *view = [self.view viewWithTag:100 + index];
    view.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
    view.layer.borderWidth = 1;
    view.transform = CGAffineTransformMakeScale(magnification, magnification);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

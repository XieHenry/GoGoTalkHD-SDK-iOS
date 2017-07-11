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

@interface GGT_OrderCourseOfFocusViewController () <OTPageScrollViewDataSource,OTPageScrollViewDelegate>

@property (nonatomic,strong) GGT_FocusOnOfPageView *PScrollView;
@property (nonatomic,strong) NSMutableArray *dataArray;



@end

@implementation GGT_OrderCourseOfFocusViewController

//为了解决偏移量造成的返回视图问题
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isSecondVc == YES) {
        _PScrollView.pageScrollView.contentOffset = CGPointMake(0, 0);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    //为了和我的--中的关注外教区分
    if (self.isSecondVc == YES) {
        [self setLeftBackButton];
    }
    
    GGT_NoMoreDateAlertView *nodataView = [[GGT_NoMoreDateAlertView alloc]initWithFrame:CGRectMake(0, LineY(180), SCREEN_WIDTH(), LineW(180)) andImageString:@"wudingdan_wode" andAlertString:@"您暂时没有关注任何外教"];
    [self.view addSubview:nodataView];
    
//    请求数据
    [self initLoadData];
    
    
//    头部滚动头像
    [self initHeaderView];
    
//    下面的课表模块
    [self initCollectionView];
}


#pragma mark 请求数据
- (void)initLoadData {
//    [[BaseService share] sendGetRequestWithPath:URL_GetTeacherFollow token:YES viewController:self success:^(id responseObject) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
}


#pragma mark 时间选择
- (void)initCollectionView {

    GGT_OrderTimeTableView *orderTimeView = [[GGT_OrderTimeTableView alloc]init];
    [self.view addSubview:orderTimeView];
    
    [orderTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(130);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
    }];
    
}

#pragma mark 头部滚动头像
- (void)initHeaderView {
    
    _PScrollView = [[GGT_FocusOnOfPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 110)];
    _PScrollView.pageScrollView.dataSource = self;
    _PScrollView.pageScrollView.delegate = self;
    _PScrollView.pageScrollView.padding = 15;
    _PScrollView.pageScrollView.leftRightOffset = 0;
    _PScrollView.pageScrollView.frame = CGRectMake((SCREEN_WIDTH() - 65)/2, 0, 65, 110);
    _PScrollView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
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
    [self.view addSubview:_PScrollView];
    

    
    UIImageView *sanjiaoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2-9, 120,18, 10)];
    sanjiaoImgView.image = UIIMAGE_FROM_NAME(@"sanjiaoxing_wode");
    [self.view addSubview:sanjiaoImgView];
    
}


- (NSInteger)numberOfPageInPageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView{
    return [_dataArray count];
}

- (UIView*)pageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView viewForRowAtIndex:(int)index{
    
    UIView *cell = [[UIView alloc] init];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 25;
    cell.frame = CGRectMake(0, 0, 50, 50);
    cell.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:239.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    cell.tag = 100 +index;
    
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    iconImgView.image = UIIMAGE_FROM_NAME(@"wode_top");
    [cell addSubview:iconImgView];

    return cell;
    
}


- (CGSize)sizeCellForPageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView
{
    return CGSizeMake(50, 50);
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
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.borderWidth = 2;
    view.transform = CGAffineTransformMakeScale(1 + 0.2, 1  + 0.2);
    
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
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.borderWidth = 2;
    view.transform = CGAffineTransformMakeScale(1 + 0.2, 1  + 0.2);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

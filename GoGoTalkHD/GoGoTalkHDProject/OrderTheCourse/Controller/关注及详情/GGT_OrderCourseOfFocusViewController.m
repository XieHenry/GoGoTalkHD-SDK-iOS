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
#import "GGT_OrderTimeTableView.h"
#import "GGT_NoMoreDateAlertView.h"
#import "GGT_FocusImgModel.h"
#import "GGT_TimeCollectionModel.h"
#import "GGT_HomeDateModel.h"
#import "GGT_OrderClassPopVC.h"


#define magnification 1.15f  //头像放大倍数
#define headPortraitW 62.5f  //头像宽度


@interface GGT_OrderCourseOfFocusViewController () <OTPageScrollViewDataSource,OTPageScrollViewDelegate,UIPopoverPresentationControllerDelegate>

/***上部分头像***/
//上面部分头像部分
@property (nonatomic, strong) UIView *headerView;
//滚动头像的view
@property (nonatomic, strong) GGT_FocusOnOfPageView *PScrollView;
//头像的数据源
@property (nonatomic, strong) NSMutableArray *iconDataArray;
//头像下部分的控件
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UIButton *focusOnBtn;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger page;
@property BOOL isrefreshMore;

/***下部分时间表格***/
@property (nonatomic, strong) NSMutableArray *dayAndWeekArray;
@property (nonatomic, strong) NSMutableArray *timeDataArray;
@property (nonatomic, strong)  GGT_OrderTimeTableView *orderTimeView;




/***缺省图***/
@property (nonatomic, strong) GGT_NoMoreDateAlertView *nodataView; //没数据时的缺省图


@end

@implementation GGT_OrderCourseOfFocusViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimeTableColor:) name:@"changeTimeTableColor" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTimeTableColor" object:nil];
}

- (void)changeTimeTableColor:(NSNotification *)noti {
    [self.orderTimeView  ClernColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    
    self.nodataView = [[GGT_NoMoreDateAlertView alloc]init];
    self.nodataView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:self.nodataView];
    self.nodataView.hidden = YES;
    
    
    [self.nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-80);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-64);
    }];
    
    
    //头部滚动头像
    [self initHeaderView];
    
    
    //请求上部分头像的数据
    self.iconDataArray = [NSMutableArray array];
    self.page = 1;
    self.isrefreshMore = NO;
    [self getTeacherFollowLoadData];
    
    
    //下面的课表模块
//    [self initCollectionView];
}


#pragma mark 请求上部分头像的数据
-(void)getTeacherFollowLoadData {

    NSString *url = [NSString stringWithFormat:@"%@?pageIndex=%ld",URL_GetTeacherFollowApp,(long)self.page];
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
       
        NSArray *dataArr = responseObject[@"data"];
        
        //如果数组为空，证明是没关注，加载缺省图
        if (IsArrEmpty(dataArr)) {
            [self.nodataView imageString:@"weichuxi" andAlertString:responseObject[@"msg"]];

            self.nodataView.hidden = NO;
            self.headerView.hidden = YES;
            self.orderTimeView.hidden = YES;
            return ;
        }
        
        
        //加载头像数据
        NSMutableArray *tempArr = [NSMutableArray array];

        for (NSDictionary *dic in dataArr) {
            GGT_FocusImgModel *model = [GGT_FocusImgModel yy_modelWithDictionary:dic];
            [tempArr addObject:model];
        }
        [self.iconDataArray addObjectsFromArray:tempArr];

        
        //让头像居中显示---这个必须和GGT_FocusOnOfPageScrollView中的74行内容保持一致
        if (self.page == 1) {
            
            if (self.iconDataArray.count > 9) {
                GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:4];
                self.nameLabel.text = model.TeacherName;
                [self reloadFocusOnImgFrame:model.TeacherName];
                self.selectedIndex = 4;
                _PScrollView.pageScrollView.status = @"center1";
            } else {
                GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:self.iconDataArray.count/2];
                self.nameLabel.text = model.TeacherName;
                [self reloadFocusOnImgFrame:model.TeacherName];
                self.selectedIndex = self.iconDataArray.count/2;
                _PScrollView.pageScrollView.status = @"center2";

            }

        } else {
            _PScrollView.pageScrollView.isfirst = NO;
            _PScrollView.pageScrollView.status = @"last";
            _PScrollView.pageScrollView.page = self.page-1;
            self.selectedIndex = ((self.page-1)*10)-1;

        }
        [_PScrollView.pageScrollView reloadData];


        //获取时间表格数据
        [self getOrderTimeTableViewLoadData];


    } failure:^(NSError *error) {
        
        NSDictionary *dic = error.userInfo;
        self.nodataView.hidden = NO;
        self.headerView.hidden = YES;
        self.orderTimeView.hidden = YES;
        
        [self.nodataView imageString:@"weichuxi" andAlertString:dic[@"msg"]];

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
    _PScrollView.pageScrollView.isfirst = YES;
    _PScrollView.pageScrollView.frame = CGRectMake((SCREEN_WIDTH() - home_leftView_width - headPortraitW - 40)/2, 0, headPortraitW + 40, 72);
    [_headerView addSubview:_PScrollView];

    
    self.nameView = [[UIView alloc]init];
    [_headerView addSubview:self.nameView];
    
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = UICOLOR_FROM_HEX(Color333333);
    self.nameLabel.font = Font(15);
    [self.nameView addSubview:self.nameLabel];
    
    
    self.focusOnBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.focusOnBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
    self.focusOnBtn.titleLabel.font = Font(10);
    [self.focusOnBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:(UIControlStateNormal)];
    self.focusOnBtn.backgroundColor = UICOLOR_FROM_HEX(ColorCCCCCC);
    [self.focusOnBtn addTarget:self action:@selector(focusOnBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.nameView addSubview:self.focusOnBtn];
    
}



#pragma mark 关注按钮
- (void)focusOnBtnClick {

    GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:self.selectedIndex];
    
    NSString *url = [NSString stringWithFormat:@"%@?teacherId=%@&state=%@",URL_GetAttention,[NSString stringWithFormat:@"%ld",(long)model.TeacherId],@"1"];
    
    NSLog(@"%ld----%@",(long)self.selectedIndex,url);
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        //先从本地数组删除这个数据
        [self.iconDataArray removeObjectAtIndex:self.selectedIndex];
        [_PScrollView.pageScrollView reloadData];

        //刷新UI
        [self reloadIconImageView:self.selectedIndex];

        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark --GGT_FocusOnOfPageScrollView的代理方法--以及UI更新
- (NSInteger)numberOfPageInPageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView {
    return [_iconDataArray count];
}

- (UIView*)pageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView viewForRowAtIndex:(int)index {
    
    UIView *cell = [[UIView alloc] init];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = headPortraitW/2;
    cell.frame = CGRectMake(0, 0, headPortraitW, headPortraitW);
    cell.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    cell.tag = 100 +index;
    
    
    GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:index];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.ImageUrl]] placeholderImage:UIIMAGE_FROM_NAME(@"headPortrait_default_avatar")];
    [cell addSubview:iconImgView];

    
    
    return cell;
}


- (CGSize)sizeCellForPageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView {
    return CGSizeMake(headPortraitW, headPortraitW);
}

- (void)pageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index {
//    NSLog(@"点击的第 %ld 个头像",index);

    [self reloadIconImageView:index];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
//    NSLog(@"滑动的第 %ld 个头像",index);
    
    [self reloadIconImageView:index];
}

//刷新姓名和关注的坐标
- (void)reloadFocusOnImgFrame:(NSString *)nameStr {
    CGSize cellSize=[nameStr boundingRectWithSize:CGSizeMake(800, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font(15)} context:nil].size;
    
    
    self.nameView.frame = CGRectMake((_headerView.width - cellSize.width-46)/2, 94, cellSize.width + 46, 20);
    self.nameLabel.frame = CGRectMake(0, 0, cellSize.width, 19);
    self.focusOnBtn.frame = CGRectMake(self.nameLabel.x+self.nameLabel.width+10, 0,LineW(36), LineH(19));
}

//点击或滑动头像，刷新UI和数据
- (void)reloadIconImageView:(NSInteger )index {
    //如果是点击的最后一个，才会加载最新的数据，page++
    if (self.iconDataArray.count < 10) {
        
    } else if (self.iconDataArray.count == 10) {
        if (index == self.iconDataArray.count-1) {
            self.page ++;
            //获取数据
            [self getTeacherFollowLoadData];
        }
    }
    
    
    
    //刷新UI
    for (int i=0; i<_iconDataArray.count; i++) {
        UIView *view = [self.view viewWithTag:100 + i];
        view.transform = CGAffineTransformMakeScale(1, 1);
        view.layer.borderColor = [UIColor clearColor].CGColor;
        view.layer.borderWidth = 0;
    }
    
    
    UIView *view = [self.view viewWithTag:100 + index];
    view.layer.borderColor = UICOLOR_FROM_HEX(ColorC40016).CGColor;
    view.layer.borderWidth = 1;
    view.transform = CGAffineTransformMakeScale(magnification,magnification);
    
    
    GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:index];
    //处理数据，对点击的头像进行切换名字
    self.nameLabel.text = model.TeacherName;
    
    [self reloadFocusOnImgFrame:model.TeacherName];
    
    self.selectedIndex = index;
    
    
    //获取时间表格数据
    [self getOrderTimeTableViewLoadData];
  
}


#pragma mark ---以下为数据表格的数据操作---
- (void)initCollectionView {
    
    self.orderTimeView = [[GGT_OrderTimeTableView alloc]init];
    self.orderTimeView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    
    
    __weak GGT_OrderCourseOfFocusViewController *weakSelf = self;
    
    self.orderTimeView.orderBlick = ^(GGT_TimeCollectionModel *timeCollectionModel,GGT_HomeDateModel *homeDateModel) {
        GGT_OrderClassPopVC *vc = [GGT_OrderClassPopVC new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = weakSelf;
    
        
        GGT_FocusImgModel *focusImgModel = [weakSelf.iconDataArray safe_objectAtIndex:weakSelf.selectedIndex];
        
//        07月13日（星期三）18:30
        GGT_HomeTeachModel *model = [[GGT_HomeTeachModel alloc]init];
        model.TeacherName = focusImgModel.TeacherName;
        model.TeacherId = [NSString stringWithFormat:@"%ld",(long)focusImgModel.TeacherId];
        model.ImageUrl = focusImgModel.ImageUrl;
        model.StartTime = [NSString stringWithFormat:@"%@ (%@) %@", homeDateModel.date, homeDateModel.week, timeCollectionModel.date];
        model.LessonId = [NSString stringWithFormat:@"%ld",(long)timeCollectionModel.week];
        
        vc.xc_model = model;
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    [self.view addSubview:self.orderTimeView];
    
    [self.orderTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(129);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
    }];
    
}


- (void)getOrderTimeTableViewLoadData {
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[GGT_OrderTimeTableView class]]) {
                GGT_OrderTimeTableView *cell = (GGT_OrderTimeTableView *)view;
                [cell removeFromSuperview];
            }
        }

    
    GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:self.selectedIndex];
    
    NSString *url = [NSString stringWithFormat:@"%@?teacherId=%@",URL_GetTimeByTeacherId,[NSString stringWithFormat:@"%ld",(long)model.TeacherId]];
    
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
//    classListA classListB classListC classListD classListE classListF classListG
//        NSArray *keyArr = @[@"classListA",@"classListB",@"classListC",@"classListD",@"classListE",@"classListF",@"classListG"];

        
        /*代码啰嗦，待改进*/
        NSDictionary *dataDic = responseObject[@"data"];
        self.timeDataArray = [NSMutableArray array];
        NSMutableArray *classListAArr = [NSMutableArray array];
        NSMutableArray *classListBArr = [NSMutableArray array];
        NSMutableArray *classListCArr = [NSMutableArray array];
        NSMutableArray *classListDArr = [NSMutableArray array];
        NSMutableArray *classListEArr = [NSMutableArray array];
        NSMutableArray *classListFArr = [NSMutableArray array];
        NSMutableArray *classListGArr = [NSMutableArray array];

        
        
        for (NSDictionary *dic in dataDic[@"classListA"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListAArr addObject:model];
        }
        [self.timeDataArray addObject:classListAArr];

        
        for (NSDictionary *dic in dataDic[@"classListB"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListBArr addObject:model];
        }
        [self.timeDataArray addObject:classListBArr];

        for (NSDictionary *dic in dataDic[@"classListC"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListCArr addObject:model];
        }
        [self.timeDataArray addObject:classListCArr];

        for (NSDictionary *dic in dataDic[@"classListD"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListDArr addObject:model];
        }
        [self.timeDataArray addObject:classListDArr];

        for (NSDictionary *dic in dataDic[@"classListE"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListEArr addObject:model];
        }
        [self.timeDataArray addObject:classListEArr];

        for (NSDictionary *dic in dataDic[@"classListF"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListFArr addObject:model];
        }
        [self.timeDataArray addObject:classListFArr];

        for (NSDictionary *dic in dataDic[@"classListG"]) {
            GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
            [classListGArr addObject:model];
        }
        
        [self.timeDataArray addObject:classListGArr];

        //cell获得数据
        
        [self initCollectionView];

        [self.orderTimeView getCellArr:self.timeDataArray];

        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

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
#import "AppDelegate.h"

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
//关注老师的总数
@property (nonatomic, assign) NSInteger totalCount;




/***下部分时间表格***/
@property (nonatomic, strong)  GGT_OrderTimeTableView *orderTimeView;


/***缺省图***/
@property (nonatomic, strong) GGT_NoMoreDateAlertView *nodataView; //没数据时的缺省图


@end

@implementation GGT_OrderCourseOfFocusViewController





#pragma mark 点击时间弹出GGT_OrderClassPopVC，如果点击了取消，需要发送通知，对cell的颜色进行恢复
- (void)changeTimeTableColor:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([[dic objectForKey:@"statusColor"] isEqualToString:@"order"]) {
        [self.orderTimeView  orderCourse];
        
    } else {
        
        [self.orderTimeView  ClernColor];
    }
}

#pragma mark 在别的界面如果点击了关注，在这里刷新
- (void)refreshFocusClick:(NSNotification *)noti {

    //请求上部分头像的数据
    self.iconDataArray = [NSMutableArray array];
    self.page = 1;
    [self getTeacherFollowLoadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimeTableColor:) name:@"changeTimeTableColor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFocusClick:) name:@"refreshFocus" object:nil];
    
    
    self.nodataView = [[GGT_NoMoreDateAlertView alloc]init];
    self.nodataView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:self.nodataView];
    self.nodataView.hidden = YES;
    
    
    [self.nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-80);
        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
    }];
    
    
    //头部滚动头像
    [self initHeaderView];
    
    
    //请求上部分头像的数据
    self.iconDataArray = [NSMutableArray array];
    self.page = 1;
    [self getTeacherFollowLoadData];
    
}


#pragma mark 请求上部分头像的数据
-(void)getTeacherFollowLoadData {
    
    NSString *url = [NSString stringWithFormat:@"%@?pageIndex=%ld",URL_GetTeacherFollowApp,(long)self.page];
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        [self hideLoadingView];

        
        //如果全部取消关注的时候，会全部隐藏，所以这里需要显示一下
        self.nodataView.hidden = YES;
        self.headerView.hidden = NO;
        self.orderTimeView.hidden = NO;
        
        NSArray *dataArr = responseObject[@"data"];
        self.totalCount = [responseObject[@"total"] integerValue];
        

        //加载头像数据
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (NSDictionary *dic in dataArr) {
            GGT_FocusImgModel *model = [GGT_FocusImgModel yy_modelWithDictionary:dic];
            [tempArr addObject:model];
        }
        [self.iconDataArray addObjectsFromArray:tempArr];
        
        //如果数组为空，证明是没关注，加载缺省图
        if (IsArrEmpty(dataArr) && IsArrEmpty(self.iconDataArray)) {
            [self.nodataView imageString:@"weichuxi" andAlertString:responseObject[@"msg"]];
            
            self.nodataView.hidden = NO;
            self.headerView.hidden = YES;
            self.orderTimeView.hidden = YES;
            return ;
        }


        //让头像居中显示---这个必须和GGT_FocusOnOfPageScrollView中的74行内容保持一致
        if (self.page == 1) {
            
            if (self.iconDataArray.count > 9) {
                GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:4];
                self.nameLabel.text = model.TeacherName;
                [self reloadFocusOnImgFrame:model.TeacherName];
                self.selectedIndex = 4;
                self.PScrollView.pageScrollView.status = @"center1";
            } else if(self.iconDataArray.count == 1){
                GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:self.iconDataArray.count/2];
                self.nameLabel.text = model.TeacherName;
                [self reloadFocusOnImgFrame:model.TeacherName];
                self.selectedIndex = 0;
                self.PScrollView.pageScrollView.status = @"first";
                
            }else {
                GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:self.iconDataArray.count/2];
                self.nameLabel.text = model.TeacherName;
                [self reloadFocusOnImgFrame:model.TeacherName];
                self.selectedIndex = self.iconDataArray.count/2;
                self.PScrollView.pageScrollView.status = @"center2";
                
            }
            
        } else {
            self.PScrollView.pageScrollView.isfirst = NO;
            self.PScrollView.pageScrollView.status = @"last";
            self.PScrollView.pageScrollView.page = self.page-1;
            self.selectedIndex = ((self.page-1)*10)-1;
            
        }
        [self.PScrollView.pageScrollView reloadData];
        
        
        //获取时间表格数据
        [self getOrderTimeTableViewLoadData];
        
        
    } failure:^(NSError *error) {
        
        GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
        if (sin.netStatus == NO) {
            [self showLoadingView];
            
            __weak GGT_OrderCourseOfFocusViewController *weakself  = self;
            weakself.loadingView.loadingFailedBlock = ^(UIButton *btn){
                [weakself getTeacherFollowLoadData];
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate getDayAndWeekLoadData];
            };
        } else {
            NSDictionary *dic = error.userInfo;
            self.nodataView.hidden = NO;
            self.headerView.hidden = YES;
            self.orderTimeView.hidden = YES;
            
            [self.nodataView imageString:@"weichuxi" andAlertString:dic[@"msg"]];
        }

        
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要取消关注吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self cancleFocus];
        
    }];
    cancelAction.textColor = UICOLOR_FROM_HEX(Color777777);
    sureAction.textColor = UICOLOR_FROM_HEX(kThemeColor);
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)cancleFocus {
    
    GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:self.selectedIndex];
    
    NSString *url = [NSString stringWithFormat:@"%@?teacherId=%ld&state=%@",URL_Attention_Home,(long)model.TeacherId,@"1"];
    
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:NO success:^(id responseObject) {
        
        //刷新数据
        self.iconDataArray = [NSMutableArray array];
        self.page = 1;
        [self getTeacherFollowLoadData];
        
        
    } failure:^(NSError *error) {
        NSDictionary *dic = error.userInfo;
        if ([dic[@"msg"] isKindOfClass:[NSString class]]) {
            [MBProgressHUD showMessage:dic[@"msg"] toView:self.view];
        }
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
        
    } else if (self.iconDataArray.count == 10) { //在每一页的最后一个头像加载新的数据
        //如果点击的是最后一个，加载新的数据,防止点击以前的加载新数据
        if (index == self.iconDataArray.count-1) {
            //计算一共多少页
            NSInteger totalPage = (self.totalCount + 10 -1) / 10;
            //如果总页数大于当前的页数，需要加载新的
            if (totalPage > self.page) {
                self.page ++;
                //获取数据
                [self getTeacherFollowLoadData];
            }
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


#pragma mark   是否可以预约
- (void)isCanOrderTheCourseData:(GGT_TimeCollectionModel *)timeCollectionModel homeDateModel:(GGT_HomeDateModel *)homeDateModel{
    
    GGT_FocusImgModel *focusImgModel = [self.iconDataArray safe_objectAtIndex:self.selectedIndex];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?teacherId=%ld&dateTime=%@", URL_GetIsSureClass,(long)focusImgModel.TeacherId,timeCollectionModel.date];
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
        
        
        GGT_OrderClassPopVC *vc = [GGT_OrderClassPopVC new];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        nav.popoverPresentationController.delegate = self;
        
        
        vc.ImageUrl = focusImgModel.ImageUrl;
        vc.TeacherName = focusImgModel.TeacherName;
        vc.StartTime = [NSString stringWithFormat:@"%@ (%@)  %@", homeDateModel.date, homeDateModel.week, timeCollectionModel.time];
        vc.LessonId = [NSString stringWithFormat:@"%ld",(long)timeCollectionModel.TLId];
        
        
        //预约了课程的回调
        vc.orderCourse = ^(BOOL yes) {
            [self.orderTimeView  orderCourse];
        };
        [self presentViewController:nav animated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
        NSDictionary *dic = error.userInfo;
        if ([dic[@"msg"] isKindOfClass:[NSString class]]) {
            [MBProgressHUD showMessage:dic[@"msg"] toView:self.view];
        }
        
        [self.orderTimeView  ClernColor];
        
    }];
    
}


- (void)getOrderTimeTableViewLoadData {
    //先删除以前的GGT_OrderTimeTableView
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[GGT_OrderTimeTableView class]]) {
            GGT_OrderTimeTableView *cell = (GGT_OrderTimeTableView *)view;
            [cell removeFromSuperview];
        }
    }
    
    
    GGT_FocusImgModel *model = [self.iconDataArray safe_objectAtIndex:self.selectedIndex];
    
    NSString *url = [NSString stringWithFormat:@"%@?teacherId=%@",URL_GetTimeByTeacherId,[NSString stringWithFormat:@"%ld",(long)model.TeacherId]];
    
    
    [[BaseService share] sendGetRequestWithPath:url token:YES viewController:self showMBProgress:YES success:^(id responseObject) {
        
//        NSDictionary *dataDic = responseObject[@"data"];
//        //获取所有的key
//        NSArray *keyArray = [dataDic allKeys];
//        //对所有的key进行排序
//        NSArray *newKeyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
//
//
        NSMutableArray *tempArray = [NSMutableArray array];
//
//        //处理数据，对每一个section数据添加到大数组中
//        for (int i=0; i<newKeyArray.count; i++) {
//            NSMutableArray *section = [NSMutableArray array];
//            for (NSDictionary *dic in dataDic[newKeyArray[i]]) {
//                GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
//                [section addObject:model];
//            }
//            [tempArray addObject:section];
//        }
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && [responseObject[@"data"] count] > 0) {
            NSArray *dataArr = responseObject[@"data"];
            for (NSArray *arr in dataArr) {
                NSMutableArray *section = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    GGT_TimeCollectionModel *model = [GGT_TimeCollectionModel yy_modelWithDictionary:dic];
                    [section addObject:model];
                }
                [tempArray addObject:section];
            }
        }
        
        
        
        
        
        
        
        

        self.orderTimeView = [[GGT_OrderTimeTableView alloc]initWithFrame:CGRectMake(0, LineH(129), marginFocusOn, SCREEN_HEIGHT()-LineH(129)-64)];
        self.orderTimeView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        [self.orderTimeView getCellArr:tempArray];
        __weak GGT_OrderCourseOfFocusViewController *weakSelf = self;
        self.orderTimeView.orderBlick = ^(GGT_TimeCollectionModel *timeCollectionModel,GGT_HomeDateModel *homeDateModel) {
            
            //先判断是否可预约
            [weakSelf isCanOrderTheCourseData:timeCollectionModel homeDateModel:homeDateModel];
        };
        [self.view addSubview:self.orderTimeView];
        
        
    } failure:^(NSError *error) {
        NSDictionary *dic = error.userInfo;
        if ([dic[@"msg"] isKindOfClass:[NSString class]]) {
            [MBProgressHUD showMessage:dic[@"msg"] toView:self.view];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTimeTableColor" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshFocus" object:nil];
    NSLog(@"控制器--%@--销毁了", [self class]);

}



@end

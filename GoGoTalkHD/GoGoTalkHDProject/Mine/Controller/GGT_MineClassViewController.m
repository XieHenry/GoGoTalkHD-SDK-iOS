//
//  GGT_MineClassViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/15.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineClassViewController.h"
#import "GGT_MineClassTableViewCell.h"
#import "GGT_MineClassPlaceholderView.h"

@interface GGT_MineClassViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

//大的数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

//由于section==2的时候，数据不固定，作为一个临时数据来添加到大数组中
@property (nonatomic, strong) NSMutableArray *tempContentArray;

//pageIndex
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) GGT_MineClassPlaceholderView *mineClassPlaceholderView;
@end

@implementation GGT_MineClassViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.navigationItem.title = @"我的课时";

    [self initTableView];
    

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataArray = [NSMutableArray array];
        _tempContentArray = [NSMutableArray array];
        self.page = 1;
        [self getLoadData];
    }];
    [self.tableView.mj_header beginRefreshing];

    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self getLoadData];

    }];
}

#pragma mark 数据请求，比较复杂，加强测试
- (void)getLoadData {

    
    NSString *urlStr = [NSString stringWithFormat:@"%@?pageIndex=%ld",URL_GetMyClassHour,(long)self.page];
    
    [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:self success:^(id responseObject) {
      
            //总课时
            NSArray *listGoodsArr = responseObject[@"data"][@"result_listGoods"];
            
            NSArray *listArray = responseObject[@"data"][@"result_list"];
            
            //如果无数据。展示缺省图，并终止下面的操作
            if (IsArrEmpty(listGoodsArr) && IsArrEmpty(listArray)) {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
                self.dataArray = [NSMutableArray array];
                self.mineClassPlaceholderView.hidden = NO;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
                return ;
            }
            
            
            NSMutableArray *headerArray = [NSMutableArray array];
            for (NSDictionary *dic in listGoodsArr) {
                [headerArray addObject:@{@"leftTitle":[NSString stringWithFormat:@"剩余%@课时",dic[@"SurplusCount"]],@"rightTitle":@""}];
                [headerArray addObject:@{@"leftTitle":[NSString stringWithFormat:@"总共%@课时",dic[@"TotalCount"]],@"rightTitle":[NSString stringWithFormat:@"有效期至:%@",dic[@"ExpireTime"]]}];
          
               //判断是否操作课时，如果操作，进行刷新left的数据
                GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
                
                //数据不一样，进行刷新，因为在修改姓名的时候，有一个通知，再次直接用那个了
                if ([[NSString stringWithFormat:@"%@",dic[@"SurplusCount"]] isEqualToString:sin.leftTotalCount] == NO) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNameStatus" object:nil];
                }

                
            }
            
        
            
            NSMutableArray *contentArray = [NSMutableArray array];
            for (NSDictionary *dic in listArray) {
                //1 🐶麦课时 2报名课时  3返还课时
                if ([dic[@"types"] isEqual:@1]) {
                    [contentArray addObject:@{@"leftTitle":[NSString stringWithFormat:@"获赠%@课时",dic[@"classHour"]],@"rightTitle":dic[@"createTime"]}];

                } else if ([dic[@"types"] isEqual:@2]) {
                    [contentArray addObject:@{@"leftTitle":[NSString stringWithFormat:@"报名%@课时",dic[@"classHour"]],@"rightTitle":dic[@"createTime"]}];

                } else if ([dic[@"types"] isEqual:@3]) {
                    [contentArray addObject:@{@"leftTitle":[NSString stringWithFormat:@"返还%@课时",dic[@"classHour"]],@"rightTitle":dic[@"createTime"]}];
                }
            }
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];

            [_tempContentArray addObjectsFromArray:contentArray];
            self.dataArray = [NSMutableArray arrayWithObjects:headerArray,_tempContentArray, nil];
            [self.tableView reloadData];
      

            if (contentArray.count < 20 && _tempContentArray.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
                return ;
            }

        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
      

    }];
}


- (void)initTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(LineX(20), LineY(20), marginMineRight-LineW(40), SCREEN_HEIGHT()-LineH(20)-64) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:_tableView];
    
    
    self.mineClassPlaceholderView = [[GGT_MineClassPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width,  SCREEN_HEIGHT()-LineH(20)-64) method:MyClassStatus alertStr:nil];
    self.mineClassPlaceholderView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.tableView addSubview:_mineClassPlaceholderView];
    self.mineClassPlaceholderView.hidden = YES;
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //如果数组为空，就显示缺省图，需要设置1个数据，1个分组，显示加载完成，才能在最下面。
    if (IsArrEmpty(_tempContentArray) && IsArrEmpty(_dataArray)) {
        return 1;
    }
    return _dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (IsArrEmpty(_tempContentArray) && IsArrEmpty(_dataArray)) {
        return 1;
    }
    return [_dataArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_MineClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[GGT_MineClassTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    
    //对第一个和最后一个进行切圆角
    if (IsArrEmpty(_tempContentArray) && IsArrEmpty(_dataArray)) {
        cell.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);

    } else {
        if (indexPath.section == 0) {//如果是第一组，就对上下进行裁角

            if (indexPath.row == 0) {
                
                [self cornCell:cell sideType:UIRectCornerTopLeft|UIRectCornerTopRight];
                
            } else if (indexPath.row == [_dataArray[indexPath.section] count]-1) {
                
                [self cornCell:cell sideType:UIRectCornerBottomLeft|UIRectCornerBottomRight];
            }
        } else { //如果是第二组，首先判断数据是否为1，进行全部剪裁，如果>1，就对第一最后一个分别进行定制剪裁
            if (_tempContentArray.count == 1) {
                [self cornCell:cell sideType:UIRectCornerTopLeft|UIRectCornerTopRight | UIRectCornerBottomLeft|UIRectCornerBottomRight];

            } else if(_tempContentArray.count > 1) {
                if (indexPath.row == 0) {
                    
                    [self cornCell:cell sideType:UIRectCornerTopLeft|UIRectCornerTopRight];
                    
                } else if (indexPath.row == [_dataArray[indexPath.section] count]-1) {
                    
                    [self cornCell:cell sideType:UIRectCornerBottomLeft|UIRectCornerBottomRight];
                }
            }
        }
        
        
        cell.leftTitleLabel.text = _dataArray[indexPath.section][indexPath.row][@"leftTitle"];
        cell.contentLabel.text = _dataArray[indexPath.section][indexPath.row][@"rightTitle"];
        cell.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);

    }

    
    return cell;
    
}

- (void)cornCell:(UITableViewCell *)cell sideType:(UIRectCorner)corners{
    CGSize cornerSize = CGSizeMake(LineW(6),LineH(6));
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _tableView.width,LineH(48))
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, _tableView.width, LineH(48));
    maskLayer.path = maskPath.CGPath;
    
    cell.layer.mask = maskLayer;
    [cell.layer setMasksToBounds:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (IsArrEmpty(_tempContentArray) && IsArrEmpty(_dataArray)) {
        return 0.00001;
    } else {
        if (section == 0) {
            return 0.00001;
        }else {
            return LineH(20);
        }
        
    }
    
  
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (IsArrEmpty(_tempContentArray) && IsArrEmpty(_dataArray)) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IsArrEmpty(_tempContentArray) && IsArrEmpty(_dataArray)) {
        return SCREEN_HEIGHT()-LineH(20)-64;
    }
    return LineH(48);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

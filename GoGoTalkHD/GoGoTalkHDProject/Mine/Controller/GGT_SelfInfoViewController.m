//
//  GGT_SelfInfoViewController.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_SelfInfoViewController.h"
#import "GGT_ChangePassWordViewController.h"
#import "GGT_SelfInfoTableViewCell.h"
#import "GGT_EditSelfInfoViewController.h"
#import "GGT_ChoicePickView.h"
#import "GGT_SelfInfoModel.h"

@interface GGT_SelfInfoViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
//左边文字
@property (nonatomic, strong) NSArray *leftTitleArray;
//右边请求的数组
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) GGT_SelfInfoModel *selfInfoModel;

@end

@implementation GGT_SelfInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    self.navigationItem.title = @"个人信息";
    
    //新建tap手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    
    //初始化tableview
    [self initTableView];
    
    //获取网络请求，添加到cell上
    [self getLoadData];
    
}


- (void)initTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(LineX(20), LineY(20), marginMineRight-LineW(40), SCREEN_HEIGHT()-LineH(40)-64) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self.view addSubview:_tableView];
    
    
    _leftTitleArray = @[@[@"账号信息",@"英文名",@"中文名",@"性别",@"生日"],@[@"父母称呼",@"所在地",@"修改密码"]];
    [_tableView reloadData];
    
}

#pragma mark 获取网络请求，添加到cell上
- (void)getLoadData {
    
    [[BaseService share] sendGetRequestWithPath:URL_GetStudentInfo token:YES viewController:self success:^(id responseObject) {
        
        _selfInfoModel = [GGT_SelfInfoModel yy_modelWithDictionary:responseObject[@"data"]];
        _dataArray = [NSMutableArray array];
        NSArray *sectionArr1 = @[_selfInfoModel.Mobile,_selfInfoModel.NameEn,_selfInfoModel.Name,_selfInfoModel.Gender,_selfInfoModel.Birthday];
        NSArray *sectionArr2 = @[_selfInfoModel.FatherName,_selfInfoModel.Address,@""];
        
        _dataArray = [NSMutableArray arrayWithObjects:sectionArr1,sectionArr2, nil];
        [_tableView reloadData];
        
        //保存英文名
        [UserDefaults() setObject:_selfInfoModel.NameEn forKey:K_nameEn];
        [UserDefaults() synchronize];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
    
}



#pragma mark - Table View delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _leftTitleArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_leftTitleArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GGT_SelfInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[GGT_SelfInfoTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    //对第一个和最后一个进行切圆角
    if (indexPath.row == 0) {
        
        [self cornCell:cell sideType:UIRectCornerTopLeft|UIRectCornerTopRight];
        
    } else if (indexPath.row == [_leftTitleArray[indexPath.section] count]-1) {
        
        [self cornCell:cell sideType:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        //更新坐标
        cell.rightImgView.hidden = YES;
        [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.leftTitleLabel.mas_right).with.offset(LineX(15));
            make.right.equalTo(cell.rightImgView.mas_left).with.offset(-LineX(20));
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.height.mas_offset(LineH(22));
        }];
        
        
        [cell.rightImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).with.offset(-LineX(0));
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.size.mas_offset(CGSizeMake(LineW(0), LineH(0)));
        }];
        
    }
    
    
    
    cell.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    cell.leftTitleLabel.text = _leftTitleArray[indexPath.section][indexPath.row];
    cell.contentLabel.text = _dataArray[indexPath.section][indexPath.row];
    
    
    
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
    if (section == 0) {
        return 0.0001;
    }
    return LineH(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LineH(48);
    
}

#pragma mark cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                //账号信息
                NSLog(@"账号信息只做展示用，不进行修改");
                break;
            case 1:
                //英文名
            {
                
                GGT_EditSelfInfoViewController *vc = [[GGT_EditSelfInfoViewController alloc]init];
                vc.titleStr = @"英文名";
                vc.getModel = _selfInfoModel;
                vc.buttonClickBlock = ^(NSString *FieldText) {
                    //下页面进行了post，返回来之后需要刷新数据
                    _dataArray = [NSMutableArray array];
                    [self getLoadData];
                    
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
                //中文名
            {
                GGT_EditSelfInfoViewController *vc = [[GGT_EditSelfInfoViewController alloc]init];
                vc.titleStr = @"中文名";
                vc.getModel = _selfInfoModel;
                vc.buttonClickBlock = ^(NSString *FieldText) {
                    _dataArray = [NSMutableArray array];
                    [self getLoadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
                //性别
            {
                
                GGT_ChoicePickView *view = [[GGT_ChoicePickView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) method:SexType];
                view.backgroundColor = UICOLOR_FROM_HEX(0xF5F6F8);
                view.tag = 111;
                __weak GGT_ChoicePickView *weakview = view;
                view.SexBlock = ^(NSString *dateStr) {
                    //默认选中是男
                    [self changePickViewData:dateStr IDStr:@"" type:@"sexType"];
                    [weakview removeFromSuperview];
                };
                [self.view addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(LineW(marginMineRight), LineH(256)));
                    make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
                }];
                
                
            }
                break;
            case 4:
                //生日
            {
                GGT_ChoicePickView *view = [[GGT_ChoicePickView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) method:BirthdayType];
                view.backgroundColor = UICOLOR_FROM_HEX(0xF5F6F8);
                view.tag = 222;
                __weak GGT_ChoicePickView *weakview = view;
                
                view.DateBlock = ^(NSString *dateStr) {
                    [self changePickViewData:dateStr IDStr:@"" type:@"birthdayType"];
                    
                    //默认打印日期是当前日期，今日日期， 2017年05月27日
                    [weakview removeFromSuperview];
                };
                [self.view addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(LineW(marginMineRight), LineH(256)));
                    make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
                }];
                
                
            }
                break;
            default:
                break;
        }
        
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                //父母称呼
            {
                GGT_EditSelfInfoViewController *vc = [[GGT_EditSelfInfoViewController alloc]init];
                vc.titleStr = @"父母称呼";
                vc.getModel = _selfInfoModel;
                vc.buttonClickBlock = ^(NSString *FieldText) {
                    _dataArray = [NSMutableArray array];
                    [self getLoadData];
                    
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
                //所在地
            {
                GGT_ChoicePickView *view = [[GGT_ChoicePickView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) method:AddressType];
                view.backgroundColor = UICOLOR_FROM_HEX(0xF5F6F8);
                __weak GGT_ChoicePickView *weakview = view;
                view.tag = 333;
                view.addressBlock = ^(NSString *addressStr,NSString *addressIdStr) {
                    [self changePickViewData:addressStr IDStr:addressIdStr type:@"addressType"];
                    
                    //直接点击完成，打印null，可以默认选中北京市的第一条信息 北京市-北京市-东城区
                    [weakview removeFromSuperview];
                };
                [self.view addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(LineW(marginMineRight), LineH(256)));
                    make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
                }];
            }
                break;
            case 2:
                //修改密码
            {
                
                GGT_ChangePassWordViewController *Vc = [[GGT_ChangePassWordViewController alloc]init];
                [self.navigationController pushViewController:Vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}

//轻击手势触发方法----点击空白处，消除弹出框
-(void)tapGesture {
    UIView *view1 = [self.view viewWithTag:111];
    UIView *view2 = [self.view viewWithTag:222];
    UIView *view3 = [self.view viewWithTag:333];
    
    [view1 removeFromSuperview];
    [view2 removeFromSuperview];
    [view3 removeFromSuperview];
    
}

//解决手势和按钮冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIButton class]]){
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma mark 修改3个pickview的数据---目前接口还有问题，等待修改
- (void)changePickViewData:(NSString *)changeStr   IDStr:(NSString *)idStr  type:(NSString *)Type {
    //如果没网络的情况下，提交信息会造成数据为空，造成崩溃，因此，判断一下
    if (IsStrEmpty(self.selfInfoModel.Mobile)) {
        [MBProgressHUD showMessage:xc_alert_message toView:self.view];
        return;
    }
    
    
    NSDictionary *postDic;
    
    //    NameEn(string):英文名
    //    Name(string)中文名
    //    Age(int):年龄
    //    Gender(int)：性别
    //    FatherName(int)：家长姓名
    //    DateOfBirth（string） 生日
    //    Province(int)     省份ID
    //    City (int)         城市ID
    //    Area(int)         区县ID
    
    //1:男   0:女   未完善是随便一个数字
    int sexInt;
    if ([self.selfInfoModel.Gender isEqualToString:@"男"]) {
        sexInt = 1;
    } else if ([self.selfInfoModel.Gender isEqualToString:@"女"]) {
        sexInt = 0;
        
    } else {
        sexInt = 2;
    }
    
    
    if ([Type isEqualToString:@"sexType"]) {
        //字符串转int
        int intString = [changeStr intValue];
        postDic = @{@"NameEn":self.selfInfoModel.NameEn,@"Name":self.selfInfoModel.Name,@"Age":[NSString stringWithFormat:@"%ld",(long)self.selfInfoModel.Age],@"Gender":@(intString),@"FatherName":self.selfInfoModel.FatherName,@"DateOfBirth":self.selfInfoModel.Birthday,@"Province":@0,@"City":@0,@"Area":@0};
        
    }else if ([Type isEqualToString:@"birthdayType"]) {
        
      
        
        postDic = @{@"NameEn":self.selfInfoModel.NameEn,@"Name":self.selfInfoModel.Name,@"Age":[NSString stringWithFormat:@"%ld",(long)self.selfInfoModel.Age],@"Gender":@(sexInt),@"FatherName":self.selfInfoModel.FatherName,@"DateOfBirth":changeStr,@"Province":@0,@"City":@0,@"Area":@0};
        
    } else if ([Type isEqualToString:@"addressType"]) {
        //将string字符串转换为array数组
        NSArray  *array = [idStr componentsSeparatedByString:@","];
        
        postDic = @{@"NameEn":self.selfInfoModel.NameEn,@"Name":self.selfInfoModel.Name,@"Age":[NSString stringWithFormat:@"%ld",(long)self.selfInfoModel.Age],@"Gender":@(sexInt),@"FatherName":self.selfInfoModel.FatherName,@"DateOfBirth":self.selfInfoModel.Birthday,@"Province":[array safe_objectAtIndex:0],@"City":[array safe_objectAtIndex:1],@"Area":[array safe_objectAtIndex:2]};
    }
    
    [[BaseService share] sendPostRequestWithPath:URL_UpdateStudentInfo parameters:postDic token:YES viewController:self success:^(id responseObject) {
        
        [MBProgressHUD showMessage:responseObject[@"msg"] toView:self.view];
        
        
        //这里使用的是文本替换的方法，修改完信息之后，没有刷新UI。下面两个方法任选其一
//        1.
        [self getLoadData];
        //2.
//        if ([Type isEqualToString:@"sexType"]) {
//            GGT_SelfInfoTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//            
//            if ([changeStr isEqualToString:@"1"]) {
//                cell.contentLabel.text = @"男";
//            } else {
//                cell.contentLabel.text = @"女";
//            }
//            
//        }else if ([Type isEqualToString:@"birthdayType"]) {
//            
//            GGT_SelfInfoTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
//            cell.contentLabel.text = changeStr;
//            
//        } else if ([Type isEqualToString:@"addressType"]) {
//            GGT_SelfInfoTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//            cell.contentLabel.text = changeStr;
//        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:error.userInfo[@"msg"] toView:self.view];
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
